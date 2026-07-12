#' Run the built-in pcatR self-test
#'
#' Runs checks of the instrument dictionary, validation, classification,
#' summaries, reshaping, longitudinal comparison, action planning, the standard
#' analysis wrapper, and plotting.
#'
#' @param verbose Print one line per check.
#' @return A data frame with check names and results, invisibly.
#' @export
pcat_self_test <- function(verbose = TRUE) {
  same <- function(x, y) isTRUE(all.equal(x, y, check.attributes = FALSE))
  checks <- list(
    "14-item dictionary" = function() {
      items <- pcat_items("both")
      stopifnot(nrow(items) == 14L, identical(sort(items$item_id), 1:14))
    },
    "updated CFIR mapping" = function() {
      items <- pcat_items("2022")
      stopifnot(length(unique(items$cfir_construct)) == 14L)
    },
    "secondary Funding mapping" = function() {
      mapping <- pcat_construct_map("2022", include_secondary = TRUE)
      item10 <- mapping[mapping$item_id == 10L, , drop = FALSE]
      stopifnot(nrow(mapping) == 15L, nrow(item10) == 2L)
    },
    "example completeness validation" = function() {
      value <- pcat_validate(
        pcat_example_data(),
        require_complete = TRUE,
        action = "none"
      )
      stopifnot(isTRUE(value$valid), value$n_errors == 0L)
    },
    "five-category classification" = function() {
      data <- data.frame(
        respondent_id = paste0("R", 1:5),
        item_id = 1:5,
        direction = c(1, 1, 2, 3, 3),
        effect = c(1, 0, NA, 0, 1)
      )
      value <- pcat_classify(data)
      stopifnot(same(
        value$pcat_class,
        c(
          "strong_barrier", "weak_barrier", "neutral",
          "weak_facilitator", "strong_facilitator"
        )
      ))
      stopifnot(same(value$pcat_display_code, c(-2, -1, 0, 1, 2)))
    },
    "invalid-value detection" = function() {
      data <- data.frame(
        respondent_id = c("R1", "R1"),
        item_id = c(15, 15),
        direction = c(4, 4),
        effect = c(2, 2)
      )
      value <- pcat_validate(data, action = "none")
      issues <- pcat_validation_issues(value, "row")
      stopifnot(!value$valid)
      stopifnot(all(c(
        "invalid_item_id", "invalid_direction", "invalid_effect", "duplicate_key"
      ) %in% issues$issue_code))
    },
    "neutral-effect warning" = function() {
      data <- data.frame(
        respondent_id = "R1", item_id = 1, direction = 2, effect = 1
      )
      value <- pcat_validate(data, action = "none")
      stopifnot(value$n_errors == 0L, value$n_warnings == 1L)
      stopifnot("neutral_with_effect" %in% pcat_validation_issues(value)$issue_code)
    },
    "missing-effect classification" = function() {
      data <- data.frame(
        respondent_id = "R1", item_id = 1, direction = 1, effect = NA
      )
      value <- pcat_classify(data)
      stopifnot(
        value$pcat_side == "barrier",
        value$pcat_class == "barrier_effect_missing",
        is.na(value$pcat_display_code)
      )
    },
    "duplicate exclusion" = function() {
      data <- data.frame(
        respondent_id = c("R1", "R1"), item_id = c(1, 1),
        direction = c(1, 1), effect = c(1, 1)
      )
      classified <- pcat_classify(data)
      summary <- pcat_summarise(classified)
      stopifnot(
        all(!classified$pcat_record_eligible),
        summary$n_rows_input == 2L,
        summary$n_rows_eligible == 0L,
        is.na(summary$pct_barrier)
      )
    },
    "summary percentages" = function() {
      data <- data.frame(
        respondent_id = paste0("R", 1:4), item_id = 1,
        direction = c(1, 1, 2, 3), effect = c(1, 0, NA, 1)
      )
      value <- pcat_summarise(data)
      stopifnot(
        value$n_valid_direction == 4L,
        same(value$pct_barrier, 0.50),
        same(value$pct_neutral, 0.25),
        same(value$pct_facilitator, 0.25)
      )
    },
    "polarization detection" = function() {
      data <- data.frame(
        respondent_id = paste0("R", 1:10), item_id = 1,
        direction = c(rep(1, 5), rep(3, 5)), effect = 1
      )
      value <- pcat_consensus(data)
      stopifnot(isTRUE(value$polarized), value$consensus_label == "polarized")
    },
    "long-wide-long conversion" = function() {
      long <- pcat_template("long", 2, include_item_text = FALSE)
      long$direction <- rep(c(1L, 3L), length.out = nrow(long))
      long$effect <- rep(c(0L, 1L), length.out = nrow(long))
      back <- pcat_wide_to_long(pcat_long_to_wide(long))
      back <- back[order(back$respondent_id, back$item_id), ]
      long <- long[order(long$respondent_id, long$item_id), ]
      stopifnot(
        same(back$direction, long$direction),
        same(back$effect, long$effect)
      )
    },
    "paired longitudinal change" = function() {
      data <- data.frame(
        respondent_id = c("R1", "R1"), item_id = c(1, 1),
        timepoint = c("planning", "mid"), direction = c(1, 3), effect = c(1, 1)
      )
      value <- pcat_change(data, from = "planning", to = "mid")
      stopifnot(
        value$delta_display_code == 4,
        value$transition == "toward_facilitation",
        value$transition_detail == "strong_barrier -> strong_facilitator"
      )
    },
    "strategy lookup" = function() {
      value <- pcat_strategy_candidates("Available Resources", tier = "1")
      stopifnot(
        nrow(value) >= 1L,
        all(value$tier == 1L),
        all(value$mapping_status == "direct")
      )
    },
    "action-plan generation" = function() {
      data <- data.frame(
        respondent_id = paste0("R", 1:5), item_id = 8,
        direction = 1, effect = c(1, 1, 1, 0, 0)
      )
      value <- pcat_action_plan(data)
      stopifnot(
        nrow(value) >= 1L,
        all(value$item_id == 8L),
        "planned_action" %in% names(value)
      )
    },
    "empty validation issue binding" = function() {
      validation <- pcat_validate(
        pcat_example_data(),
        require_complete = TRUE,
        action = "none"
      )
      issues <- pcat_validation_issues(validation)
      stopifnot(
        is.data.frame(issues),
        nrow(issues) == 0L,
        all(c("issue_code", "severity", "message") %in% names(issues))
      )
    },
    "neutral weak-effect warning" = function() {
      data <- data.frame(
        respondent_id = "R1", item_id = 1, direction = 2, effect = 0
      )
      validation <- pcat_validate(data, action = "none")
      issues <- pcat_validation_issues(validation, "row")
      stopifnot(
        validation$n_errors == 0L,
        validation$n_warnings == 1L,
        "neutral_with_effect" %in% issues$issue_code
      )
    },
    "distinct analysis denominators" = function() {
      data <- data.frame(
        respondent_id = paste0("R", 1:4), item_id = 1,
        direction = c(1, 1, 2, 3), effect = c(1, NA, NA, 0)
      )
      value <- pcat_summarise(data)
      stopifnot(
        value$n_valid_direction == 4L,
        value$n_complete_class == 3L,
        same(value$pct_barrier, 0.50),
        same(value$pct_strong_barrier, 1 / 3),
        same(value$pct_effect_missing, 0.25)
      )
    },
    "small-cell suppression" = function() {
      data <- data.frame(
        respondent_id = paste0("R", 1:3), site_id = "SITE_A",
        item_id = 1, direction = c(1, 2, 3), effect = c(1, NA, 0)
      )
      value <- pcat_summarise(
        data, group_vars = "site_id", suppress_below = 4
      )
      stopifnot(
        isTRUE(value$suppressed),
        identical(value$site_id, "SITE_A"),
        value$item_id == 1L,
        !is.na(value$item_text),
        is.na(value$n_respondents),
        is.na(value$pct_barrier)
      )
    },
    "packaged technical guide" = function() {
      pdf <- pcat_user_guide("pdf", open = FALSE)
      markdown <- pcat_user_guide("markdown", open = FALSE)
      stopifnot(file.exists(pdf), file.exists(markdown))
    }
  )

  checks[["NA-safe action-plan filter"]] <- function() {
    summary_data <- data.frame(
      item_id = 1L,
      pct_barrier = 0.10,
      pct_strong_barrier = NA_real_,
      cfir_original_construct = "Patient Needs & Resources",
      stringsAsFactors = FALSE
    )
    value <- pcat_action_plan(
      summary_data,
      barrier_threshold = 0.50,
      strong_barrier_threshold = 0.20,
      include_strategy_candidates = FALSE
    )
    stopifnot(nrow(value) == 0L)
  }

  checks[["invalid reshape item IDs rejected"]] <- function() {
    wide_error <- tryCatch(
      {
        pcat_wide_to_long(data.frame(item15_direction = 1, item15_effect = 1))
        NULL
      },
      error = function(e) e
    )
    long_error <- tryCatch(
      {
        pcat_long_to_wide(data.frame(
          respondent_id = "R1", item_id = 15,
          direction = 1, effect = 1
        ))
        NULL
      },
      error = function(e) e
    )
    stopifnot(inherits(wide_error, "error"), inherits(long_error, "error"))
  }

  checks[["privacy-aware export cleanup"]] <- function() {
    analysis <- pcat_analyse(
      pcat_example_data(),
      group_vars = c("site_id", "timepoint"),
      require_complete = TRUE,
      validation_action = "none"
    )
    path <- tempfile("pcat_self_test_export_")
    on.exit(unlink(path, recursive = TRUE, force = TRUE), add = TRUE)
    pcat_write_analysis(
      analysis,
      path,
      include_profile_pdf = FALSE,
      include_classified = TRUE
    )
    stopifnot(file.exists(file.path(path, "02_classified_responses.csv")))
    analysis_no_plan <- pcat_analyse(
      pcat_example_data(),
      group_vars = c("site_id", "timepoint"),
      require_complete = TRUE,
      validation_action = "none",
      include_action_plan = FALSE
    )
    pcat_write_analysis(
      analysis_no_plan,
      path,
      overwrite = TRUE,
      include_profile_pdf = FALSE,
      include_classified = FALSE
    )
    stopifnot(
      !file.exists(file.path(path, "02_classified_responses.csv")),
      !file.exists(file.path(path, "05_action_plan.csv")),
      file.exists(file.path(path, "07_analysis_settings.csv")),
      file.exists(file.path(path, "08_session_info.txt"))
    )
  }

  checks[["standard analysis wrapper"]] <- function() {
    value <- pcat_analyse(
      pcat_example_data(),
      group_vars = c("site_id", "timepoint"),
      require_complete = TRUE
    )
    stopifnot(
      inherits(value, "pcat_analysis"),
      isTRUE(value$validation$valid),
      nrow(value$summary) == 56L,
      nrow(value$consensus) == 56L
    )
  }

  if (requireNamespace("ggplot2", quietly = TRUE)) {
    checks[["profile plot construction"]] <- function() {
      plot <- plot_pcat_profile(
        pcat_classify(pcat_example_data()),
        label = "cfir_original_construct"
      )
      is_plot <- if (exists("is_ggplot", envir = asNamespace("ggplot2"), inherits = FALSE)) {
        get("is_ggplot", envir = asNamespace("ggplot2"))(plot)
      } else {
        inherits(plot, "ggplot")
      }
      stopifnot(isTRUE(is_plot))
      stopifnot(length(unique(as.character(plot$data$item_label))) == 14L)
    }
  }

  results <- data.frame(
    check = names(checks),
    status = NA_character_,
    message = NA_character_,
    stringsAsFactors = FALSE
  )
  for (i in seq_along(checks)) {
    error <- tryCatch(
      {
        checks[[i]]()
        NULL
      },
      error = function(e) e
    )
    if (is.null(error)) {
      results$status[[i]] <- "PASS"
      results$message[[i]] <- ""
    } else {
      results$status[[i]] <- "FAIL"
      results$message[[i]] <- conditionMessage(error)
    }
    if (isTRUE(verbose)) {
      cat(sprintf("[%s] %s", results$status[[i]], results$check[[i]]))
      if (nzchar(results$message[[i]])) cat(": ", results$message[[i]], sep = "")
      cat("\n")
    }
  }

  failed <- results$status == "FAIL"
  if (any(failed)) {
    .pcat_abort(
      paste0(
        "pcatR self-test failed: ",
        paste(results$check[failed], collapse = "; ")
      ),
      "pcat_self_test_failed"
    )
  }
  if (isTRUE(verbose)) {
    cat(sprintf("All %d pcatR self-tests passed.\n", nrow(results)))
  }
  invisible(results)
}
