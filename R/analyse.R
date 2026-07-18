#' Run the standard pCAT analysis workflow
#'
#' Validates and classifies responses, creates item-level summaries and
#' consensus diagnostics, and optionally creates a barrier-focused action plan.
#'
#' @param data Long-format pCAT response data.
#' @param group_vars Optional grouping columns such as site and time point.
#' @param respondent_id Respondent identifier column.
#' @param key_cols Columns defining one assessment for validation.
#' @param require_complete Require exactly one response to each item 1-14.
#' @param neutral_effect Handling of neutral responses paired with any recorded
#'   effect; passed to [pcat_validate()].
#' @param validation_action Validation behavior: `"none"`, `"warn"`, or
#'   `"error"`.
#' @param strict Treat validation warnings as invalid.
#' @param suppress_below Optional minimum respondent count for summary output.
#'   Numeric analytic results and derived modal classifications are hidden for
#'   suppressed rows.
#' @param agreement_threshold,polarization_min,minimum_n Consensus settings
#'   passed to [pcat_consensus()]. Probability thresholds must each be one
#'   finite number from zero through one.
#' @param include_action_plan Create an action-plan table.
#' @param barrier_threshold,strong_barrier_threshold Action-plan thresholds;
#'   each must be one finite number from zero through one.
#' @param include_approximate Include approximate strategy mappings.
#' @return A list of class `pcat_analysis`.
#' @export
pcat_analyse <- function(
    data,
    group_vars = NULL,
    respondent_id = "respondent_id",
    key_cols = NULL,
    require_complete = FALSE,
    neutral_effect = c("flag", "allow", "set_missing"),
    validation_action = c("none", "warn", "error"),
    strict = FALSE,
    suppress_below = NULL,
    agreement_threshold = 0.60,
    polarization_min = 0.20,
    minimum_n = 2L,
    include_action_plan = TRUE,
    barrier_threshold = 0.50,
    strong_barrier_threshold = 0.20,
    include_approximate = FALSE) {
  neutral_effect <- match.arg(neutral_effect)
  validation_action <- match.arg(validation_action)
  group_vars <- unique(as.character(group_vars %||% character()))
  .pcat_check_data_frame(data)
  .pcat_check_columns(data, c(group_vars, respondent_id))

  validation <- pcat_validate(
    data,
    key_cols = key_cols,
    require_complete = require_complete,
    neutral_effect = neutral_effect,
    action = validation_action,
    strict = strict
  )
  classified <- pcat_classify(validation, attach_items = TRUE)
  summary <- pcat_summarise(
    classified,
    group_vars = group_vars,
    respondent_id = respondent_id,
    suppress_below = suppress_below
  )
  consensus <- pcat_consensus(
    summary,
    agreement_threshold = agreement_threshold,
    polarization_min = polarization_min,
    minimum_n = minimum_n
  )
  action_plan <- if (isTRUE(include_action_plan)) {
    pcat_action_plan(
      summary,
      group_vars = group_vars,
      barrier_threshold = barrier_threshold,
      strong_barrier_threshold = strong_barrier_threshold,
      include_strategy_candidates = TRUE,
      include_approximate = include_approximate
    )
  } else {
    NULL
  }

  result <- list(
    validation = validation,
    classified = classified,
    summary = summary,
    consensus = consensus,
    action_plan = action_plan,
    settings = list(
      group_vars = group_vars,
      respondent_id = respondent_id,
      key_cols = validation$settings$key_cols,
      require_complete = isTRUE(require_complete),
      neutral_effect = neutral_effect,
      validation_action = validation_action,
      strict = isTRUE(strict),
      suppress_below = suppress_below,
      agreement_threshold = agreement_threshold,
      polarization_min = polarization_min,
      minimum_n = minimum_n,
      include_action_plan = isTRUE(include_action_plan),
      barrier_threshold = barrier_threshold,
      strong_barrier_threshold = strong_barrier_threshold,
      include_approximate = isTRUE(include_approximate)
    )
  )
  class(result) <- c("pcat_analysis", "list")
  result
}

#' @rdname pcat_analyse
#' @export
print.pcat_analysis <- function(x, ...) {
  cat("<pcat_analysis>\n")
  cat("  input rows: ", nrow(x$validation$data), "\n", sep = "")
  cat("  validation errors: ", x$validation$n_errors, "\n", sep = "")
  cat("  validation warnings: ", x$validation$n_warnings, "\n", sep = "")
  cat("  classified rows: ", nrow(x$classified), "\n", sep = "")
  cat("  summary rows: ", nrow(x$summary), "\n", sep = "")
  cat("  consensus rows: ", nrow(x$consensus), "\n", sep = "")
  if (is.null(x$action_plan)) {
    cat("  action plan: not requested\n")
  } else {
    cat("  action-plan rows: ", nrow(x$action_plan), "\n", sep = "")
  }
  groups <- x$settings$group_vars
  cat(
    "  grouping: ",
    if (length(groups) == 0L) "overall" else paste(groups, collapse = ", "),
    "\n",
    sep = ""
  )
  cat("  total-score calculation: not performed\n")
  invisible(x)
}

#' Export a complete pCAT analysis bundle
#'
#' Writes analysis components to a directory using stable, human-readable file
#' names. An optional profile PDF places each grouping combination on its own
#' page. The classified-response file can be omitted when respondent-level
#' output is not needed or should not be distributed.
#'
#' @param x A `pcat_analysis` object returned by [pcat_analyse()].
#' @param path Output directory.
#' @param overwrite Allow replacement of files previously generated by
#'   `pcat_write_analysis()` in an existing directory. Unrelated files are
#'   retained.
#' @param include_profile_pdf Create `06_profile.pdf`.
#' @param include_classified Write `02_classified_responses.csv`.
#' @param profile_label Item label used in the profile PDF.
#' @return The normalized output directory, invisibly.
#' @export
pcat_write_analysis <- function(
    x,
    path,
    overwrite = FALSE,
    include_profile_pdf = TRUE,
    include_classified = TRUE,
    profile_label = c(
      "cfir_original_construct", "cfir_2022_construct", "item_text", "item_id"
    )) {
  if (!inherits(x, "pcat_analysis")) {
    .pcat_abort("`x` must be a `pcat_analysis` object returned by `pcat_analyse()`.")
  }
  profile_label <- match.arg(profile_label)
  if (length(path) != 1L || is.na(path) || !nzchar(path)) {
    .pcat_abort("`path` must be one non-missing output directory.")
  }

  generated_files <- c(
    "00_manifest.csv",
    "01_validation_issues.csv",
    "02_classified_responses.csv",
    "03_item_summary.csv",
    "04_consensus_diagnostics.csv",
    "05_action_plan.csv",
    "06_profile.pdf",
    "07_analysis_settings.csv",
    "08_session_info.txt",
    "README.txt"
  )

  if (dir.exists(path)) {
    existing <- list.files(path, all.files = TRUE, no.. = TRUE)
    if (length(existing) > 0L && !isTRUE(overwrite)) {
      .pcat_abort(
        paste0(
          "Output directory is not empty: `", path,
          "`. Set `overwrite = TRUE` to replace package-generated files."
        )
      )
    }
    if (isTRUE(overwrite)) {
      old_generated <- file.path(path, generated_files)
      old_generated <- old_generated[file.exists(old_generated)]
      if (length(old_generated) > 0L) {
        unlink(old_generated, recursive = FALSE, force = TRUE)
      }
    }
  } else {
    dir.create(path, recursive = TRUE, showWarnings = FALSE)
  }
  if (!dir.exists(path)) {
    .pcat_abort(paste0("Could not create output directory: `", path, "`."))
  }

  write_component <- function(object, filename) {
    utils::write.csv(
      as.data.frame(object, stringsAsFactors = FALSE, check.names = FALSE),
      file.path(path, filename),
      row.names = FALSE,
      na = ""
    )
  }

  write_component(
    pcat_validation_issues(x$validation),
    "01_validation_issues.csv"
  )
  classified_written <- isTRUE(include_classified)
  if (classified_written) {
    write_component(x$classified, "02_classified_responses.csv")
  }
  write_component(x$summary, "03_item_summary.csv")
  write_component(x$consensus, "04_consensus_diagnostics.csv")
  action_plan_written <- !is.null(x$action_plan)
  if (action_plan_written) {
    write_component(x$action_plan, "05_action_plan.csv")
  }

  profile_written <- FALSE
  if (isTRUE(include_profile_pdf) && nrow(x$classified) > 0L) {
    if (!is.null(x$settings$suppress_below)) {
      .pcat_warn(
        paste(
          "The profile PDF is created from classified response data and does",
          "not inherit small-cell suppression applied to summary tables.",
          "Review the PDF before dissemination or set `include_profile_pdf = FALSE`."
        ),
        "pcat_profile_suppression_warning"
      )
    }
    pcat_save_profile_pdf(
      x$classified,
      path = file.path(path, "06_profile.pdf"),
      group_vars = x$settings$group_vars,
      overwrite = TRUE,
      label = profile_label,
      label_width = 34L,
      show_n = TRUE
    )
    profile_written <- TRUE
  }

  format_setting <- function(value) {
    if (is.null(value) || length(value) == 0L) return("")
    if (inherits(value, "Date") || inherits(value, "POSIXt")) {
      value <- as.character(value)
    }
    paste(as.character(value), collapse = ";")
  }
  settings <- data.frame(
    setting = names(x$settings),
    value = vapply(x$settings, format_setting, character(1)),
    stringsAsFactors = FALSE
  )
  utils::write.csv(
    settings,
    file.path(path, "07_analysis_settings.csv"),
    row.names = FALSE,
    na = ""
  )
  writeLines(
    utils::capture.output(utils::sessionInfo()),
    file.path(path, "08_session_info.txt"),
    useBytes = TRUE
  )

  package_version <- tryCatch(
    as.character(utils::packageVersion("pcatR")),
    error = function(e) "development"
  )
  manifest <- data.frame(
    field = c(
      "package", "package_version", "exported_at_utc", "input_rows",
      "validation_errors", "validation_warnings", "group_vars",
      "require_complete", "classified_written", "action_plan_written",
      "profile_pdf_written", "total_score_calculated"
    ),
    value = c(
      "pcatR",
      package_version,
      format(Sys.time(), tz = "UTC", usetz = TRUE),
      nrow(x$validation$data),
      x$validation$n_errors,
      x$validation$n_warnings,
      if (length(x$settings$group_vars) == 0L) {
        "overall"
      } else {
        paste(x$settings$group_vars, collapse = ";")
      },
      x$settings$require_complete,
      classified_written,
      action_plan_written,
      profile_written,
      FALSE
    ),
    stringsAsFactors = FALSE
  )
  utils::write.csv(
    manifest,
    file.path(path, "00_manifest.csv"),
    row.names = FALSE,
    na = ""
  )

  readme <- c(
    "pcatR analysis export",
    "=====================",
    "",
    "00_manifest.csv: Package version, analysis settings, and export metadata.",
    "01_validation_issues.csv: Row- and assessment-level validation findings.",
    if (classified_written) {
      "02_classified_responses.csv: Standardized respondent-item classifications."
    } else {
      "02_classified_responses.csv: Not written (include_classified = FALSE)."
    },
    "03_item_summary.csv: Item-level counts, percentages, and denominators.",
    "04_consensus_diagnostics.csv: Agreement, polarization, and entropy diagnostics.",
    if (action_plan_written) {
      "05_action_plan.csv: Barrier-focused planning worksheet."
    } else {
      "05_action_plan.csv: Not written (action plan was not requested)."
    },
    if (profile_written) {
      "06_profile.pdf: One readable barrier-facilitator profile per grouping combination."
    } else {
      "06_profile.pdf: Not written."
    },
    "07_analysis_settings.csv: Settings used by pcat_analyse().",
    "08_session_info.txt: R and package-session information for reproducibility.",
    "",
    "Important: pcatR does not calculate a validated total pCAT scale score.",
    "Review respondent-level and graphical files under the applicable privacy and disclosure rules."
  )
  writeLines(readme, file.path(path, "README.txt"), useBytes = TRUE)

  invisible(normalizePath(path, winslash = "/", mustWork = TRUE))
}
