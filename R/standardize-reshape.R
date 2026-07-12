#' Standardize user column names
#'
#' Copies user-specified columns to the standard names used by `pcatR`.
#'
#' @param data A data frame.
#' @param respondent_id,item_id,direction,effect Column names as strings.
#' @param project_id,site_id,team_id,role,timepoint,assessment_date,comment
#'   Optional column names as strings.
#' @param keep_original Retain source columns when their names differ from the
#'   standard names.
#' @return A data frame with standard pCAT column names.
#' @export
pcat_standardize <- function(
    data,
    respondent_id = "respondent_id",
    item_id = "item_id",
    direction = "direction",
    effect = "effect",
    project_id = NULL,
    site_id = NULL,
    team_id = NULL,
    role = NULL,
    timepoint = NULL,
    assessment_date = NULL,
    comment = NULL,
    keep_original = TRUE) {
  .pcat_check_data_frame(data)
  required_map <- c(
    respondent_id = respondent_id,
    item_id = item_id,
    direction = direction,
    effect = effect
  )
  .pcat_check_columns(data, unname(required_map))

  optional_map <- c(
    project_id = project_id,
    site_id = site_id,
    team_id = team_id,
    role = role,
    timepoint = timepoint,
    assessment_date = assessment_date,
    comment = comment
  )
  optional_map <- optional_map[!is.na(optional_map) & nzchar(optional_map)]
  .pcat_check_columns(data, unname(optional_map))

  out <- as.data.frame(data, stringsAsFactors = FALSE, check.names = FALSE)
  all_map <- c(required_map, optional_map)
  for (standard in names(all_map)) {
    out[[standard]] <- data[[all_map[[standard]]]]
  }

  if (!isTRUE(keep_original)) {
    source_names <- unique(unname(all_map))
    standard_names <- names(all_map)
    drop <- setdiff(source_names, standard_names)
    out[drop] <- NULL
  }
  rownames(out) <- NULL
  out
}

#' Create a pCAT data-entry template
#'
#' @param format `"long"` or `"wide"`.
#' @param n_respondents Number of blank respondent records.
#' @param include_item_text Include item wording in a long template.
#' @return A data frame.
#' @rdname pcat_standardize
#' @export
pcat_template <- function(
    format = c("long", "wide"),
    n_respondents = 1L,
    include_item_text = TRUE) {
  format <- match.arg(format)
  n_respondents <- suppressWarnings(as.integer(n_respondents))
  if (length(n_respondents) != 1L || is.na(n_respondents) || n_respondents < 1L) {
    .pcat_abort("`n_respondents` must be a positive integer.")
  }

  items <- pcat_items("both")
  ids <- sprintf("R%03d", seq_len(n_respondents))
  out <- data.frame(
    project_id = rep("PROJECT_01", n_respondents * 14L),
    respondent_id = rep(ids, each = 14L),
    site_id = rep("SITE_01", n_respondents * 14L),
    team_id = rep(NA_character_, n_respondents * 14L),
    role = rep(NA_character_, n_respondents * 14L),
    timepoint = rep("planning", n_respondents * 14L),
    assessment_date = as.Date(rep(NA_character_, n_respondents * 14L)),
    item_id = rep(items$item_id, times = n_respondents),
    direction = rep(NA_integer_, n_respondents * 14L),
    effect = rep(NA_integer_, n_respondents * 14L),
    comment = rep(NA_character_, n_respondents * 14L),
    stringsAsFactors = FALSE,
    check.names = FALSE
  )
  if (isTRUE(include_item_text)) {
    out$item_text <- items$item_text[match(out$item_id, items$item_id)]
    desired <- c(
      "project_id", "respondent_id", "site_id", "team_id", "role",
      "timepoint", "assessment_date", "item_id", "item_text",
      "direction", "effect", "comment"
    )
    out <- out[desired]
  }

  if (format == "wide") {
    out$item_text <- NULL
    out$comment <- NULL
    out <- pcat_long_to_wide(
      out,
      id_cols = c(
        "project_id", "respondent_id", "site_id", "team_id", "role",
        "timepoint", "assessment_date"
      )
    )
  }
  rownames(out) <- NULL
  out
}

#' Write a pCAT data-entry template
#'
#' @param path Output CSV path.
#' @param format,n_respondents,include_item_text Passed to [pcat_template()].
#' @param overwrite Overwrite an existing file.
#' @return The normalized file path, invisibly.
#' @rdname pcat_standardize
#' @export
pcat_write_template <- function(
    path,
    format = c("long", "wide"),
    n_respondents = 1L,
    include_item_text = TRUE,
    overwrite = FALSE) {
  format <- match.arg(format)
  if (length(path) != 1L || is.na(path) || !nzchar(path)) {
    .pcat_abort("`path` must be one non-missing output file path.")
  }
  if (file.exists(path) && !isTRUE(overwrite)) {
    .pcat_abort(
      paste0("File already exists: `", path, "`. Set `overwrite = TRUE` to replace it.")
    )
  }
  parent <- dirname(path)
  if (!dir.exists(parent)) dir.create(parent, recursive = TRUE, showWarnings = FALSE)
  out <- pcat_template(format, n_respondents, include_item_text)
  utils::write.csv(out, path, row.names = FALSE, na = "")
  invisible(normalizePath(path, winslash = "/", mustWork = FALSE))
}

#' Convert wide pCAT responses to long format
#'
#' Wide response columns must follow `item01_direction`, `item01_effect`, ...,
#' `item14_direction`, `item14_effect` by default.
#'
#' @param data A wide data frame.
#' @param item_prefix Prefix before the item number.
#' @return A long data frame.
#' @rdname pcat_standardize
#' @export
pcat_wide_to_long <- function(data, item_prefix = "item") {
  .pcat_check_data_frame(data)
  prefix <- .pcat_escape_regex(item_prefix)
  pattern <- paste0("^", prefix, "([0-9]{1,2})_(direction|effect)$")
  response_cols <- grep(pattern, names(data), value = TRUE)
  if (length(response_cols) == 0L) {
    .pcat_abort(
      paste0(
        "No response columns matched `", item_prefix,
        "01_direction` / `", item_prefix, "01_effect` naming."
      )
    )
  }

  matches <- regexec(pattern, response_cols)
  parsed <- regmatches(response_cols, matches)
  item_ids <- as.integer(vapply(parsed, `[[`, character(1), 2L))
  components <- vapply(parsed, `[[`, character(1), 3L)
  if (any(is.na(item_ids) | !item_ids %in% 1:14)) {
    .pcat_abort(
      "Wide pCAT response columns must use item numbers 1 through 14."
    )
  }
  component_key <- paste(item_ids, components, sep = "::")
  if (anyDuplicated(component_key)) {
    .pcat_abort(
      paste(
        "Wide data contain duplicate response columns for the same item",
        "component (for example, both `item1_direction` and",
        "`item01_direction`)."
      )
    )
  }
  unique_items <- sort(unique(item_ids))
  identifier_cols <- setdiff(names(data), response_cols)

  parts <- vector("list", length(unique_items))
  for (j in seq_along(unique_items)) {
    item <- unique_items[[j]]
    part <- if (length(identifier_cols) > 0L) {
      data[identifier_cols]
    } else {
      data.frame(.pcat_row = seq_len(nrow(data)))[, FALSE, drop = FALSE]
    }
    part$.pcat_input_row <- seq_len(nrow(data))
    part$item_id <- as.integer(item)

    direction_name <- response_cols[item_ids == item & components == "direction"]
    effect_name <- response_cols[item_ids == item & components == "effect"]
    part$direction <- if (length(direction_name) > 0L) data[[direction_name[[1L]]]] else NA
    part$effect <- if (length(effect_name) > 0L) data[[effect_name[[1L]]]] else NA
    parts[[j]] <- part
  }

  out <- .pcat_bind_rows(parts)
  out <- out[order(out$.pcat_input_row, out$item_id), , drop = FALSE]
  out$.pcat_input_row <- NULL
  rownames(out) <- NULL
  out
}

#' Convert long pCAT responses to wide format
#'
#' @param data A long data frame.
#' @param id_cols Identifier columns retained as one row per assessment.
#' @param item_prefix Prefix used in output response columns.
#' @return A wide data frame.
#' @rdname pcat_standardize
#' @export
pcat_long_to_wide <- function(data, id_cols = NULL, item_prefix = "item") {
  .pcat_check_data_frame(data)
  .pcat_check_columns(data, c("item_id", "direction", "effect"))

  if (is.null(id_cols)) {
    id_cols <- intersect(
      c(
        "project_id", "respondent_id", "site_id", "team_id", "role",
        "timepoint", "assessment_date"
      ),
      names(data)
    )
  }
  id_cols <- unique(as.character(id_cols))
  if (length(id_cols) == 0L) {
    .pcat_abort("Supply at least one identifier in `id_cols`.")
  }
  .pcat_check_columns(data, id_cols)

  parsed_item <- .pcat_parse_item_id(data$item_id)
  parse_failed <- attr(parsed_item, "parse_failed")
  if (any(parse_failed | is.na(parsed_item) | !parsed_item %in% 1:14)) {
    .pcat_abort(
      "All `item_id` values must be integer-like values from 1 through 14 before widening."
    )
  }
  working <- data
  working$item_id <- parsed_item

  duplicate_key <- .pcat_key(working, c(id_cols, "item_id"))
  if (any(duplicated(duplicate_key))) {
    .pcat_abort(
      "Long data contain duplicate identifier-item rows and cannot be widened safely."
    )
  }

  assessment_key <- .pcat_key(working, id_cols)
  first_rows <- !duplicated(assessment_key)
  out <- working[first_rows, id_cols, drop = FALSE]
  out_key <- assessment_key[first_rows]
  items <- sort(unique(working$item_id))

  for (item in items) {
    direction_col <- sprintf("%s%02d_direction", item_prefix, item)
    effect_col <- sprintf("%s%02d_effect", item_prefix, item)
    out[[direction_col]] <- NA
    out[[effect_col]] <- NA
  }

  destination <- match(assessment_key, out_key)
  for (i in seq_len(nrow(working))) {
    item <- working$item_id[[i]]
    direction_col <- sprintf("%s%02d_direction", item_prefix, item)
    effect_col <- sprintf("%s%02d_effect", item_prefix, item)
    out[[direction_col]][destination[[i]]] <- working$direction[[i]]
    out[[effect_col]][destination[[i]]] <- working$effect[[i]]
  }

  rownames(out) <- NULL
  out
}

#' Read pCAT responses from a CSV file
#'
#' @param path Path to a CSV file.
#' @param layout Input layout: `"auto"`, `"long"`, or `"wide"`.
#' @param item_prefix Prefix before item numbers in wide response columns.
#' @param na Character values interpreted as missing.
#' @return A long data frame when wide input is detected; otherwise the CSV.
#' @rdname pcat_standardize
#' @export
pcat_read_csv <- function(
    path,
    layout = c("auto", "long", "wide"),
    item_prefix = "item",
    na = c("", "NA")) {
  layout <- match.arg(layout)
  if (length(path) != 1L || is.na(path) || !nzchar(path)) {
    .pcat_abort("`path` must be one non-missing CSV file path.")
  }
  if (!file.exists(path)) {
    .pcat_abort(paste0("CSV file does not exist: `", path, "`."))
  }

  out <- utils::read.csv(
    path,
    stringsAsFactors = FALSE,
    check.names = FALSE,
    na.strings = na
  )
  rownames(out) <- NULL

  if (layout == "auto") {
    required_long <- c("respondent_id", "item_id", "direction", "effect")
    has_long <- all(required_long %in% names(out))
    prefix <- .pcat_escape_regex(item_prefix)
    wide_pattern <- paste0("^", prefix, "([0-9]{1,2})_(direction|effect)$")
    has_wide <- any(grepl(wide_pattern, names(out)))
    layout <- if (has_long) {
      "long"
    } else if (has_wide) {
      "wide"
    } else {
      .pcat_abort(
        paste(
          "Could not detect a standard long or wide pCAT CSV layout.",
          "Use `pcat_standardize()` after importing non-standard columns."
        )
      )
    }
  }

  if (layout == "wide") {
    out <- pcat_wide_to_long(out, item_prefix = item_prefix)
  }
  attr(out, "pcat_source_file") <- normalizePath(
    path,
    winslash = "/",
    mustWork = TRUE
  )
  out
}
