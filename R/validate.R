#' Validate pCAT response data
#'
#' Checks identifiers, item numbers, direction/effect values, duplicate keys,
#' neutral responses paired with any effect response, and optionally assessment
#' completeness.
#'
#' @param data Long-format data using standard pCAT column names.
#' @param key_cols Columns defining one assessment.
#' @param require_complete Require exactly one response to each item 1-14.
#' @param neutral_effect How to handle any non-missing effect response paired with a neutral direction.
#' @param action `"warn"`, `"error"`, or `"none"`.
#' @param strict Treat warnings as invalid when determining `$valid`.
#' @return An object of class `pcat_validation`.
#' @export
pcat_validate <- function(
    data,
    key_cols = NULL,
    require_complete = FALSE,
    neutral_effect = c("flag", "allow", "set_missing"),
    action = c("warn", "error", "none"),
    strict = FALSE) {
  neutral_effect <- match.arg(neutral_effect)
  action <- match.arg(action)
  .pcat_check_data_frame(data)
  .pcat_check_columns(data, c("respondent_id", "item_id", "direction", "effect"))

  if (nrow(data) == 0L) {
    .pcat_abort(
      "`data` must contain at least one pCAT response row.",
      "pcat_empty_data"
    )
  }

  raw <- as.data.frame(data, stringsAsFactors = FALSE, check.names = FALSE)
  rownames(raw) <- NULL
  out <- raw

  parsed_item <- .pcat_parse_item_id(raw$item_id)
  parsed_direction <- .pcat_parse_direction(raw$direction)
  parsed_effect <- .pcat_parse_effect(raw$effect)
  item_parse_failed <- attr(parsed_item, "parse_failed")
  direction_parse_failed <- attr(parsed_direction, "parse_failed")
  effect_parse_failed <- attr(parsed_effect, "parse_failed")

  out$item_id <- parsed_item
  out$direction <- parsed_direction
  out$effect <- parsed_effect

  n <- nrow(out)
  issue_codes <- vector("list", n)
  issue_severity <- vector("list", n)

  add_issue <- function(mask, code, severity = "error") {
    mask <- as.logical(mask)
    idx <- which(!is.na(mask) & mask)
    if (length(idx) == 0L) return(invisible(NULL))
    for (i in idx) {
      issue_codes[[i]] <<- unique(c(issue_codes[[i]], code))
      issue_severity[[i]] <<- unique(c(issue_severity[[i]], severity))
    }
    invisible(NULL)
  }

  respondent_missing <- is.na(raw$respondent_id) |
    !nzchar(trimws(as.character(raw$respondent_id)))
  add_issue(respondent_missing, "missing_respondent_id")
  add_issue(is.na(out$item_id) & !item_parse_failed, "missing_item_id")
  add_issue(
    item_parse_failed | (!is.na(out$item_id) & !out$item_id %in% 1:14),
    "invalid_item_id"
  )
  add_issue(is.na(out$direction) & !direction_parse_failed, "missing_direction")
  add_issue(
    direction_parse_failed |
      (!is.na(out$direction) & !out$direction %in% 1:3),
    "invalid_direction"
  )
  add_issue(
    effect_parse_failed | (!is.na(out$effect) & !out$effect %in% 0:1),
    "invalid_effect"
  )
  add_issue(
    out$direction %in% c(1L, 3L) & is.na(out$effect),
    "missing_effect"
  )
  add_issue(
    is.na(out$direction) & !is.na(out$effect),
    "effect_without_direction",
    "warning"
  )

  neutral_with_effect <- !is.na(out$direction) & out$direction == 2L &
    !is.na(out$effect)
  if (neutral_effect == "flag") {
    add_issue(neutral_with_effect, "neutral_with_effect", "warning")
  } else if (neutral_effect == "set_missing") {
    add_issue(neutral_with_effect, "neutral_with_effect", "warning")
    out$effect[neutral_with_effect] <- NA_integer_
  }

  if (is.null(key_cols)) {
    key_cols <- intersect(
      c(
        "project_id", "site_id", "team_id", "timepoint",
        "assessment_date", "respondent_id"
      ),
      names(out)
    )
  }
  key_cols <- unique(c(setdiff(as.character(key_cols), "item_id"), "respondent_id"))
  .pcat_check_columns(out, key_cols)
  row_key_cols <- c(key_cols, "item_id")

  duplicate_key <- .pcat_key(out, row_key_cols)
  duplicate <- duplicated(duplicate_key) | duplicated(duplicate_key, fromLast = TRUE)
  duplicate[is.na(out$item_id)] <- FALSE
  add_issue(duplicate, "duplicate_key")

  out$.pcat_row_error <- vapply(
    issue_severity,
    function(x) "error" %in% x,
    logical(1)
  )
  out$.pcat_row_warning <- vapply(
    issue_severity,
    function(x) "warning" %in% x,
    logical(1)
  )
  out$.pcat_issue_codes <- vapply(
    issue_codes,
    function(x) paste(x, collapse = ";"),
    character(1)
  )

  row_issue_parts <- list()
  issue_counter <- 0L
  for (i in seq_len(n)) {
    codes <- issue_codes[[i]]
    if (length(codes) == 0L) next
    for (code in codes) {
      issue_counter <- issue_counter + 1L
      severity <- if (code %in% c(
        "effect_without_direction", "neutral_with_effect", "neutral_with_strong_effect"
      )) "warning" else "error"
      part <- data.frame(
        .pcat_row = i,
        issue_code = code,
        severity = severity,
        message = .pcat_issue_message(code),
        stringsAsFactors = FALSE,
        check.names = FALSE
      )
      for (column in key_cols) part[[column]] <- raw[[column]][i]
      part$item_id_raw <- raw$item_id[i]
      row_issue_parts[[issue_counter]] <- part
    }
  }
  row_issues <- .pcat_bind_rows(row_issue_parts)
  if (nrow(row_issues) == 0L) {
    row_issues <- data.frame(
      .pcat_row = integer(),
      issue_code = character(),
      severity = character(),
      message = character(),
      stringsAsFactors = FALSE
    )
  }

  group_issues <- data.frame(stringsAsFactors = FALSE)
  if (isTRUE(require_complete)) {
    assessment_keys <- .pcat_key(out, key_cols)
    unique_keys <- unique(assessment_keys)
    parts <- vector("list", length(unique_keys))
    for (j in seq_along(unique_keys)) {
      idx <- which(assessment_keys == unique_keys[[j]])
      valid_ids <- out$item_id[idx]
      valid_ids <- valid_ids[!is.na(valid_ids) & valid_ids %in% 1:14]
      present <- sort(unique(valid_ids))
      part <- out[idx[[1L]], key_cols, drop = FALSE]
      part$present_items <- paste(present, collapse = ",")
      part$n_distinct_items <- length(present)
      part$n_rows <- length(valid_ids)
      part$missing_item_ids <- paste(setdiff(1:14, present), collapse = ",")
      parts[[j]] <- part
    }
    assessments <- .pcat_bind_rows(parts)
    incomplete <- assessments$n_distinct_items != 14L | assessments$n_rows != 14L
    if (any(incomplete)) {
      group_issues <- assessments[incomplete, , drop = FALSE]
      group_issues$issue_code <- "incomplete_assessment"
      group_issues$severity <- "error"
      group_issues$message <- .pcat_issue_message("incomplete_assessment")
      rownames(group_issues) <- NULL
    }
  }

  n_errors <- if (nrow(row_issues) == 0L) 0L else sum(row_issues$severity == "error")
  n_errors <- n_errors + if (nrow(group_issues) == 0L) 0L else sum(group_issues$severity == "error")
  n_warnings <- if (nrow(row_issues) == 0L) 0L else sum(row_issues$severity == "warning")
  n_warnings <- n_warnings + if (nrow(group_issues) == 0L) 0L else sum(group_issues$severity == "warning")
  n_errors <- as.integer(n_errors)
  n_warnings <- as.integer(n_warnings)
  valid <- n_errors == 0L && (!isTRUE(strict) || n_warnings == 0L)

  result <- structure(
    list(
      valid = valid,
      data = out,
      raw_data = raw,
      row_issues = row_issues,
      group_issues = group_issues,
      n_errors = n_errors,
      n_warnings = n_warnings,
      settings = list(
        key_cols = key_cols,
        require_complete = isTRUE(require_complete),
        neutral_effect = neutral_effect,
        strict = isTRUE(strict)
      )
    ),
    class = "pcat_validation"
  )

  if (action == "error" && !valid) {
    .pcat_abort(
      paste0(
        "pCAT validation failed with ", n_errors, " error(s) and ",
        n_warnings, " warning(s). Use `pcat_validation_issues()` for details."
      ),
      "pcat_validation_failed"
    )
  }
  if (action == "warn" && (!valid || n_warnings > 0L)) {
    .pcat_warn(
      paste0(
        "pCAT validation found ", n_errors, " error(s) and ",
        n_warnings, " warning(s)."
      ),
      "pcat_validation_warning"
    )
  }
  result
}

#' @rdname pcat_validate
#' @export
print.pcat_validation <- function(x, ...) {
  cat("<pcat_validation>\n")
  cat("  valid: ", if (isTRUE(x$valid)) "yes" else "no", "\n", sep = "")
  cat("  rows: ", nrow(x$data), "\n", sep = "")
  cat("  errors: ", x$n_errors, "\n", sep = "")
  cat("  warnings: ", x$n_warnings, "\n", sep = "")
  cat(
    "  complete assessments required: ",
    if (isTRUE(x$settings$require_complete)) "yes" else "no",
    "\n",
    sep = ""
  )
  invisible(x)
}

#' Extract standardized data from a validation object
#'
#' @param x A `pcat_validation` object.
#' @param valid_rows_only Keep only rows without row-level errors.
#' @return A data frame.
#' @rdname pcat_validate
#' @export
pcat_validation_data <- function(x, valid_rows_only = FALSE) {
  if (!inherits(x, "pcat_validation")) {
    .pcat_abort("`x` must be a `pcat_validation` object.")
  }
  out <- x$data
  if (isTRUE(valid_rows_only)) {
    out <- out[!out$.pcat_row_error, , drop = FALSE]
  }
  rownames(out) <- NULL
  out
}

#' Extract validation issues
#'
#' @param x A `pcat_validation` object.
#' @param level `"all"`, `"row"`, or `"assessment"`.
#' @return A data frame.
#' @rdname pcat_validate
#' @export
pcat_validation_issues <- function(
    x,
    level = c("all", "row", "assessment")) {
  level <- match.arg(level)
  if (!inherits(x, "pcat_validation")) {
    .pcat_abort("`x` must be a `pcat_validation` object.")
  }
  if (level == "row") return(x$row_issues)
  if (level == "assessment") return(x$group_issues)

  row <- x$row_issues
  if (nrow(row) > 0L) row$issue_level <- "row"
  group <- x$group_issues
  if (nrow(group) > 0L) group$issue_level <- "assessment"
  .pcat_bind_rows(list(row, group))
}
