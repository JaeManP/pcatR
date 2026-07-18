.pcat_cache <- new.env(parent = emptyenv())

`%||%` <- function(x, y) {
  if (is.null(x) || length(x) == 0L) y else x
}

.pcat_abort <- function(message, class = NULL) {
  classes <- unique(c(class, "pcat_error", "error", "condition"))
  condition <- structure(
    list(message = as.character(message), call = sys.call(-1L)),
    class = classes
  )
  stop(condition)
}

.pcat_warn <- function(message, class = NULL) {
  classes <- unique(c(class, "pcat_warning", "warning", "condition"))
  condition <- structure(
    list(message = as.character(message), call = sys.call(-1L)),
    class = classes
  )
  warning(condition)
}

.pcat_check_probability_scalar <- function(x, name) {
  if (
    !is.numeric(x) ||
      length(x) != 1L ||
      is.na(x) ||
      !is.finite(x) ||
      x < 0 ||
      x > 1
  ) {
    .pcat_abort(
      paste0("`", name, "` must be one finite number between 0 and 1."),
      "pcat_invalid_probability"
    )
  }
  invisible(x)
}

.pcat_check_data_frame <- function(data) {
  if (!is.data.frame(data)) {
    .pcat_abort("`data` must be a data frame.", "pcat_bad_data")
  }
  invisible(TRUE)
}

.pcat_check_columns <- function(data, columns, argument = "data") {
  columns <- unique(as.character(columns))
  columns <- columns[!is.na(columns) & nzchar(columns)]
  missing_columns <- setdiff(columns, names(data))
  if (length(missing_columns) > 0L) {
    .pcat_abort(
      paste0(
        "Missing required column",
        if (length(missing_columns) > 1L) "s" else "",
        " in `", argument, "`: ",
        paste(missing_columns, collapse = ", "), "."
      ),
      "pcat_missing_columns"
    )
  }
  invisible(TRUE)
}

.pcat_project_candidates <- function() {
  configured <- getOption("pcatR.source_dir", "")
  candidates <- character()
  if (length(configured) == 1L && !is.na(configured) && nzchar(configured)) {
    candidates <- c(candidates, configured)
  }

  current <- normalizePath(getwd(), winslash = "/", mustWork = FALSE)
  candidates <- c(candidates, current)
  for (i in seq_len(6L)) {
    parent <- dirname(current)
    if (identical(parent, current)) break
    candidates <- c(candidates, parent)
    current <- parent
  }
  unique(candidates)
}

.pcat_extdata_path <- function(file) {
  installed <- system.file("extdata", file, package = "pcatR")
  if (nzchar(installed) && file.exists(installed)) {
    return(installed)
  }

  for (root in .pcat_project_candidates()) {
    candidate <- file.path(root, "inst", "extdata", file)
    if (file.exists(candidate)) {
      return(candidate)
    }
  }

  .pcat_abort(
    paste0("Could not locate packaged data file `", file, "`."),
    "pcat_missing_internal_data"
  )
}

.pcat_read_extdata <- function(file, use_cache = TRUE) {
  key <- paste0("file::", file)
  if (isTRUE(use_cache) && exists(key, envir = .pcat_cache, inherits = FALSE)) {
    return(get(key, envir = .pcat_cache, inherits = FALSE))
  }
  out <- utils::read.csv(
    .pcat_extdata_path(file),
    stringsAsFactors = FALSE,
    check.names = FALSE,
    na.strings = c("", "NA")
  )
  rownames(out) <- NULL
  if (isTRUE(use_cache)) {
    assign(key, out, envir = .pcat_cache)
  }
  out
}

.pcat_normalize_text <- function(x) {
  x <- as.character(x)
  x <- trimws(tolower(x))
  x[x %in% c("", "na", "n/a", "missing", ".")] <- NA_character_
  x
}

.pcat_parse_direction <- function(x) {
  txt <- .pcat_normalize_text(x)
  out <- rep(NA_integer_, length(txt))
  out[txt %in% c("disagree", "barrier", "potential barrier")] <- 1L
  out[txt %in% c("neutral", "neither", "neither agree nor disagree")] <- 2L
  out[txt %in% c("agree", "facilitator", "potential facilitator")] <- 3L

  num <- suppressWarnings(as.numeric(txt))
  integerish <- !is.na(num) & abs(num - round(num)) < .Machine$double.eps^0.5
  fill <- is.na(out) & integerish
  out[fill] <- as.integer(round(num[fill]))

  attr(out, "parse_failed") <- !is.na(txt) & is.na(out)
  out
}

.pcat_parse_effect <- function(x) {
  txt <- .pcat_normalize_text(x)
  out <- rep(NA_integer_, length(txt))
  out[txt %in% c(
    "weak", "weak effect", "no effect", "weak/no effect",
    "weak or no effect", "weak_no_effect"
  )] <- 0L
  out[txt %in% c("strong", "strong effect", "strong_effect")] <- 1L

  num <- suppressWarnings(as.numeric(txt))
  integerish <- !is.na(num) & abs(num - round(num)) < .Machine$double.eps^0.5
  fill <- is.na(out) & integerish
  out[fill] <- as.integer(round(num[fill]))

  attr(out, "parse_failed") <- !is.na(txt) & is.na(out)
  out
}

.pcat_parse_item_id <- function(x) {
  txt <- .pcat_normalize_text(x)
  num <- suppressWarnings(as.numeric(txt))
  integerish <- !is.na(num) & abs(num - round(num)) < .Machine$double.eps^0.5
  out <- rep(NA_integer_, length(txt))
  out[integerish] <- as.integer(round(num[integerish]))
  attr(out, "parse_failed") <- !is.na(txt) & is.na(out)
  out
}

.pcat_issue_message <- function(code) {
  messages <- c(
    missing_respondent_id = "Respondent identifier is missing.",
    missing_item_id = "Item identifier is missing.",
    invalid_item_id = "Item identifier must be an integer from 1 through 14.",
    missing_direction = "Direction response is missing.",
    invalid_direction = "Direction must be 1, 2, or 3 (or a recognized label).",
    invalid_effect = "Effect must be 0 or 1 (or a recognized label).",
    missing_effect = "A barrier or facilitator response requires an effect response.",
    effect_without_direction = "An effect response was supplied without a direction response.",
    neutral_with_effect = "A neutral direction was paired with an effect response; leave effect blank for neutral responses.",
    neutral_with_strong_effect = "A neutral direction was paired with a strong effect (legacy issue code).",
    duplicate_key = "Duplicate respondent-assessment-item key.",
    incomplete_assessment = "Assessment does not contain exactly one response for every item 1 through 14."
  )
  result <- unname(messages[code])
  result[is.na(result)] <- code[is.na(result)]
  result
}

.pcat_has_issue <- function(issue_codes, wanted) {
  issue_codes <- as.character(issue_codes)
  vapply(issue_codes, function(codes) {
    if (is.na(codes) || !nzchar(codes)) return(FALSE)
    any(strsplit(codes, ";", fixed = TRUE)[[1L]] %in% wanted)
  }, logical(1))
}

.pcat_mode <- function(x) {
  x <- as.character(x)
  x <- x[!is.na(x) & nzchar(x)]
  if (length(x) == 0L) return(NA_character_)
  tab <- table(x)
  winners <- names(tab)[tab == max(tab)]
  if (length(winners) > 1L) return("tie")
  winners[[1L]]
}

.pcat_entropy <- function(probabilities) {
  probabilities <- as.numeric(probabilities)
  probabilities <- probabilities[is.finite(probabilities) & probabilities > 0]
  if (length(probabilities) == 0L) return(NA_real_)
  if (length(probabilities) == 1L) return(0)
  -sum(probabilities * log(probabilities)) / log(3)
}

.pcat_divide <- function(numerator, denominator) {
  out <- rep(NA_real_, max(length(numerator), length(denominator)))
  numerator <- rep(numerator, length.out = length(out))
  denominator <- rep(denominator, length.out = length(out))
  ok <- !is.na(denominator) & denominator > 0
  out[ok] <- numerator[ok] / denominator[ok]
  out
}

.pcat_wrap <- function(x, width = 42L) {
  vapply(
    as.character(x),
    function(one) {
      if (is.na(one)) return(NA_character_)
      paste(strwrap(one, width = width), collapse = "\n")
    },
    character(1)
  )
}

.pcat_as_classified <- function(data, validation_action = "none", attach_items = TRUE) {
  if (inherits(data, "pcat_classified")) return(data)
  pcat_classify(
    data,
    validation_action = validation_action,
    attach_items = attach_items
  )
}

.pcat_group_label <- function(data, group_vars) {
  if (length(group_vars) == 0L) return(rep("Overall", nrow(data)))
  pieces <- lapply(group_vars, function(column) {
    value <- as.character(data[[column]])
    value[is.na(value) | !nzchar(value)] <- "(missing)"
    paste0(column, "=", value)
  })
  do.call(paste, c(pieces, sep = " | "))
}

.pcat_escape_regex <- function(x) {
  gsub("([][{}()+*^$|\\?.])", "\\\\\\1", x)
}

.pcat_key <- function(data, columns) {
  if (length(columns) == 0L) return(rep("__all__", nrow(data)))
  pieces <- lapply(columns, function(column) {
    value <- as.character(data[[column]])
    value[is.na(value)] <- "<NA>"
    value <- gsub("\\u001f", "<US>", value, fixed = TRUE)
    paste0(column, "=", value)
  })
  do.call(paste, c(pieces, sep = "\u001f"))
}

.pcat_unique_rows <- function(data, columns) {
  if (length(columns) == 0L) return(data.frame(.pcat_dummy = 1L)[, FALSE, drop = FALSE])
  data[!duplicated(.pcat_key(data, columns)), columns, drop = FALSE]
}

.pcat_bind_rows <- function(parts) {
  parts <- Filter(
    function(part) !is.null(part) && is.data.frame(part),
    parts
  )
  if (length(parts) == 0L) return(data.frame(stringsAsFactors = FALSE))
  all_names <- unique(unlist(lapply(parts, names), use.names = FALSE))
  normalized <- lapply(parts, function(part) {
    missing <- setdiff(all_names, names(part))
    for (column in missing) part[[column]] <- rep(NA, nrow(part))
    part[all_names]
  })
  out <- do.call(rbind, normalized)
  rownames(out) <- NULL
  out
}

.pcat_left_join <- function(x, y, by) {
  if (length(by) == 0L) .pcat_abort("Join keys cannot be empty.")
  .pcat_check_columns(x, names(by) %||% by)
  if (is.null(names(by)) || any(!nzchar(names(by)))) {
    x_keys <- y_keys <- by
  } else {
    x_keys <- names(by)
    y_keys <- unname(by)
  }
  .pcat_check_columns(y, y_keys)

  x$.pcat_order__ <- seq_len(nrow(x))
  # merge preserves all x rows and expands one-to-many matches.
  out <- merge(
    x, y,
    by.x = x_keys,
    by.y = y_keys,
    all.x = TRUE,
    sort = FALSE,
    suffixes = c("", ".y")
  )
  out <- out[order(out$.pcat_order__), , drop = FALSE]
  out$.pcat_order__ <- NULL
  rownames(out) <- NULL
  out
}

.pcat_require_namespace <- function(package, feature) {
  if (!requireNamespace(package, quietly = TRUE)) {
    .pcat_abort(
      paste0(
        "Package `", package, "` is required for ", feature,
        ". Install it with install.packages(\"", package, "\")."
      ),
      "pcat_optional_dependency_missing"
    )
  }
  invisible(TRUE)
}
