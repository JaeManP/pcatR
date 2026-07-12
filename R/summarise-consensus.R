#' Summarize pCAT responses by item
#'
#' @param data Raw, validated, or classified long-format data.
#' @param group_vars Optional grouping columns such as site and time point.
#' @param respondent_id Respondent identifier column.
#' @param suppress_below Optional minimum respondent count.
#' @return A data frame of class `pcat_summary`.
#' @export
pcat_summarise <- function(
    data,
    group_vars = NULL,
    respondent_id = "respondent_id",
    suppress_below = NULL) {
  classified <- .pcat_as_classified(data, attach_items = TRUE)
  group_vars <- unique(as.character(group_vars %||% character()))
  .pcat_check_columns(classified, c(group_vars, respondent_id, "item_id"))
  grouping <- unique(c(group_vars, "item_id"))

  if (!"pcat_record_eligible" %in% names(classified)) {
    classified$pcat_record_eligible <- TRUE
  }
  classified$pcat_record_eligible[is.na(classified$pcat_record_eligible)] <- FALSE
  keep <- !is.na(classified$item_id) & classified$item_id %in% 1:14
  working <- classified[keep, , drop = FALSE]

  if (nrow(working) == 0L) {
    out <- data.frame(stringsAsFactors = FALSE)
    class(out) <- c("pcat_summary", "data.frame")
    attr(out, "no_total_score") <- TRUE
    return(out)
  }

  keys <- .pcat_key(working, grouping)
  unique_keys <- unique(keys)
  parts <- vector("list", length(unique_keys))

  for (j in seq_along(unique_keys)) {
    idx <- which(keys == unique_keys[[j]])
    one <- working[idx, , drop = FALSE]
    eligible <- one$pcat_record_eligible %in% TRUE
    valid_side <- eligible & one$pcat_side %in% c("barrier", "neutral", "facilitator")
    complete_class <- eligible & !is.na(one$pcat_class5)

    respondent_values <- as.character(one[[respondent_id]][eligible])
    respondent_values <- respondent_values[!is.na(respondent_values) & nzchar(respondent_values)]

    part <- one[1L, grouping, drop = FALSE]
    part$n_rows_input <- nrow(one)
    part$n_rows_eligible <- sum(eligible)
    part$n_rows_excluded <- sum(!eligible)
    part$n_respondents <- length(unique(respondent_values))
    part$n_valid_direction <- sum(valid_side)
    part$n_complete_class <- sum(complete_class)
    part$n_barrier <- sum(eligible & one$pcat_side == "barrier", na.rm = TRUE)
    part$n_neutral <- sum(eligible & one$pcat_side == "neutral", na.rm = TRUE)
    part$n_facilitator <- sum(eligible & one$pcat_side == "facilitator", na.rm = TRUE)
    part$n_strong_barrier <- sum(eligible & one$pcat_class == "strong_barrier", na.rm = TRUE)
    part$n_weak_barrier <- sum(eligible & one$pcat_class == "weak_barrier", na.rm = TRUE)
    part$n_barrier_effect_missing <- sum(
      eligible & one$pcat_class == "barrier_effect_missing",
      na.rm = TRUE
    )
    part$n_weak_facilitator <- sum(
      eligible & one$pcat_class == "weak_facilitator",
      na.rm = TRUE
    )
    part$n_strong_facilitator <- sum(
      eligible & one$pcat_class == "strong_facilitator",
      na.rm = TRUE
    )
    part$n_facilitator_effect_missing <- sum(
      eligible & one$pcat_class == "facilitator_effect_missing",
      na.rm = TRUE
    )
    part$n_invalid_or_missing <- sum(
      eligible & one$pcat_side %in% c("invalid", "missing"),
      na.rm = TRUE
    )

    class_values <- as.character(one$pcat_class5[eligible])
    part$modal_class <- .pcat_mode(class_values)
    display_values <- one$pcat_display_code[eligible]
    part$mean_display_code <- if (
      length(display_values) == 0L || all(is.na(display_values))
    ) NA_real_ else mean(display_values, na.rm = TRUE)
    part$median_display_code <- if (
      length(display_values) == 0L || all(is.na(display_values))
    ) NA_real_ else stats::median(display_values, na.rm = TRUE)
    parts[[j]] <- part
  }

  out <- .pcat_bind_rows(parts)
  integer_columns <- grep("^n_", names(out), value = TRUE)
  for (column in integer_columns) out[[column]] <- as.integer(out[[column]])

  out$pct_barrier <- .pcat_divide(out$n_barrier, out$n_valid_direction)
  out$pct_neutral <- .pcat_divide(out$n_neutral, out$n_valid_direction)
  out$pct_facilitator <- .pcat_divide(out$n_facilitator, out$n_valid_direction)
  # Five-category percentages use complete direction-plus-effect responses.
  # Directional percentages above use every valid direction response.
  out$pct_strong_barrier <- .pcat_divide(out$n_strong_barrier, out$n_complete_class)
  out$pct_weak_barrier <- .pcat_divide(out$n_weak_barrier, out$n_complete_class)
  out$pct_neutral_complete <- .pcat_divide(out$n_neutral, out$n_complete_class)
  out$pct_strong_facilitator <- .pcat_divide(
    out$n_strong_facilitator,
    out$n_complete_class
  )
  out$pct_weak_facilitator <- .pcat_divide(
    out$n_weak_facilitator,
    out$n_complete_class
  )
  out$pct_effect_missing <- .pcat_divide(
    out$n_barrier_effect_missing + out$n_facilitator_effect_missing,
    out$n_valid_direction
  )

  out$modal_class_n <- vapply(seq_len(nrow(out)), function(i) {
    current <- out$modal_class[[i]]
    if (is.na(current) || identical(current, "tie")) return(NA_integer_)
    column <- paste0("n_", current)
    if (!column %in% names(out)) return(NA_integer_)
    as.integer(out[[column]][[i]])
  }, integer(1))
  out$modal_class_share <- .pcat_divide(out$modal_class_n, out$n_complete_class)

  item_meta <- pcat_items("both")
  metadata_names <- c(
    "item_key", "item_text", "cfir_original_domain",
    "cfir_original_construct", "cfir_2022_domain", "cfir_2022_subdomain",
    "cfir_2022_construct", "cfir_2022_secondary_construct",
    "cfir_2022_construct_all", "cfir_2022_mapping_count",
    "cfir_2022_mapping_note"
  )
  metadata_names <- setdiff(metadata_names, names(out))
  if (length(metadata_names) > 0L) {
    matched <- item_meta[match(out$item_id, item_meta$item_id), metadata_names, drop = FALSE]
    out <- cbind(out, matched)
  }

  out$suppressed <- FALSE
  if (!is.null(suppress_below)) {
    suppress_below <- suppressWarnings(as.integer(suppress_below))
    if (length(suppress_below) != 1L || is.na(suppress_below) || suppress_below < 1L) {
      .pcat_abort("`suppress_below` must be a positive integer or NULL.")
    }
    suppress <- !is.na(out$n_respondents) & out$n_respondents < suppress_below
    out$suppressed[suppress] <- TRUE
    protected <- c(
      grouping, "item_key", "item_text", "cfir_original_domain",
      "cfir_original_construct", "cfir_2022_domain", "cfir_2022_subdomain",
      "cfir_2022_construct", "cfir_2022_secondary_construct",
      "cfir_2022_construct_all", "cfir_2022_mapping_count",
      "cfir_2022_mapping_note", "suppressed"
    )
    numeric_measures <- names(out)[vapply(out, is.numeric, logical(1))]
    numeric_measures <- setdiff(numeric_measures, protected)
    for (column in numeric_measures) out[[column]][suppress] <- NA
  }

  rownames(out) <- NULL
  class(out) <- unique(c("pcat_summary", "data.frame"))
  attr(out, "no_total_score") <- TRUE
  attr(out, "direction_denominator") <- "n_valid_direction"
  attr(out, "five_category_denominator") <- "n_complete_class"
  attr(out, "denominator_note") <- paste(
    "pct_barrier, pct_neutral, pct_facilitator, and pct_effect_missing use",
    "n_valid_direction; five-category strength percentages use n_complete_class."
  )
  out
}

#' Assess team agreement and disagreement
#'
#' @param data Raw/classified data or output from [pcat_summarise()].
#' @param group_vars Passed to [pcat_summarise()] when needed.
#' @param agreement_threshold Minimum share for a consensus label.
#' @param polarization_min Minimum share on both barrier and facilitator sides.
#' @param minimum_n Minimum valid directions required.
#' @return A pCAT summary with consensus diagnostics.
#' @rdname pcat_summarise
#' @export
pcat_consensus <- function(
    data,
    group_vars = NULL,
    agreement_threshold = 0.60,
    polarization_min = 0.20,
    minimum_n = 2L) {
  for (value in c(agreement_threshold, polarization_min)) {
    if (length(value) != 1L || is.na(value) || value < 0 || value > 1) {
      .pcat_abort("Consensus thresholds must be single numbers between 0 and 1.")
    }
  }
  minimum_n <- suppressWarnings(as.integer(minimum_n))
  if (length(minimum_n) != 1L || is.na(minimum_n) || minimum_n < 1L) {
    .pcat_abort("`minimum_n` must be a positive integer.")
  }

  required <- c("pct_barrier", "pct_neutral", "pct_facilitator", "n_valid_direction")
  out <- if (all(required %in% names(data))) {
    as.data.frame(data, stringsAsFactors = FALSE, check.names = FALSE)
  } else {
    pcat_summarise(data, group_vars = group_vars)
  }

  if (nrow(out) == 0L) {
    class(out) <- c("pcat_consensus", "data.frame")
    return(out)
  }

  out$agreement_share <- NA_real_
  out$dominant_side <- NA_character_
  out$polarized <- FALSE
  out$normalized_entropy <- NA_real_
  out$consensus_label <- NA_character_

  for (i in seq_len(nrow(out))) {
    probabilities <- c(
      barrier = out$pct_barrier[[i]],
      neutral = out$pct_neutral[[i]],
      facilitator = out$pct_facilitator[[i]]
    )
    if (!all(is.na(probabilities))) {
      out$agreement_share[[i]] <- max(probabilities, na.rm = TRUE)
      comparable <- probabilities
      comparable[is.na(comparable)] <- -Inf
      winners <- names(comparable)[comparable == max(comparable)]
      out$dominant_side[[i]] <- if (length(winners) == 1L) winners[[1L]] else "tie"
    }
    out$polarized[[i]] <- !is.na(out$pct_barrier[[i]]) &&
      !is.na(out$pct_facilitator[[i]]) &&
      out$pct_barrier[[i]] >= polarization_min &&
      out$pct_facilitator[[i]] >= polarization_min
    out$normalized_entropy[[i]] <- .pcat_entropy(probabilities)

    out$consensus_label[[i]] <- if (
      is.na(out$n_valid_direction[[i]]) || out$n_valid_direction[[i]] < minimum_n
    ) {
      "insufficient_data"
    } else if (isTRUE(out$polarized[[i]])) {
      "polarized"
    } else if (
      !is.na(out$agreement_share[[i]]) &&
        out$agreement_share[[i]] >= agreement_threshold &&
        !identical(out$dominant_side[[i]], "tie")
    ) {
      paste0("consensus_", out$dominant_side[[i]])
    } else {
      "mixed"
    }
  }

  rownames(out) <- NULL
  class(out) <- unique(c("pcat_consensus", "pcat_summary", "data.frame"))
  out
}
