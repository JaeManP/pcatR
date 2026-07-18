#' Compare pCAT responses across two time points
#'
#' @param data Raw, validated, or classified data.
#' @param timepoint Name of the time-point column.
#' @param from,to Values identifying earlier and later assessments.
#' @param id_cols Columns defining a paired respondent-item record.
#' @return A data frame of paired item transitions.
#' @rdname pcat_summarise
#' @export
pcat_change <- function(
    data,
    timepoint = "timepoint",
    from,
    to,
    id_cols = NULL) {
  classified <- .pcat_as_classified(data, attach_items = TRUE)
  .pcat_check_columns(classified, timepoint)
  if ("pcat_record_eligible" %in% names(classified)) {
    classified <- classified[classified$pcat_record_eligible %in% TRUE, , drop = FALSE]
  }
  if (missing(from) || missing(to)) {
    .pcat_abort("Supply both `from` and `to` time-point values.")
  }
  if (identical(as.character(from), as.character(to))) {
    .pcat_abort("`from` and `to` must identify different time points.")
  }

  if (is.null(id_cols)) {
    id_cols <- intersect(
      c("project_id", "site_id", "team_id", "respondent_id", "item_id"),
      names(classified)
    )
  }
  id_cols <- unique(c(setdiff(as.character(id_cols), timepoint), "respondent_id", "item_id"))
  .pcat_check_columns(classified, id_cols)

  time_value <- as.character(classified[[timepoint]])
  from_df <- classified[!is.na(time_value) & time_value == as.character(from), , drop = FALSE]
  to_df <- classified[!is.na(time_value) & time_value == as.character(to), , drop = FALSE]
  if (nrow(from_df) == 0L || nrow(to_df) == 0L) {
    .pcat_abort("One or both requested time points are absent from `data`.")
  }

  from_key <- .pcat_key(from_df, id_cols)
  to_key <- .pcat_key(to_df, id_cols)
  if (any(duplicated(from_key)) || any(duplicated(to_key))) {
    .pcat_abort("Duplicate paired identifiers were found within a requested time point.")
  }

  combined_ids <- rbind(from_df[id_cols], to_df[id_cols])
  combined_key <- c(from_key, to_key)
  first <- !duplicated(combined_key)
  out <- combined_ids[first, , drop = FALSE]
  all_key <- combined_key[first]

  from_match <- match(all_key, from_key)
  to_match <- match(all_key, to_key)
  values <- c("pcat_class", "pcat_class5", "pcat_display_code", "pcat_side")
  for (value in values) {
    from_value <- from_df[[value]][from_match]
    to_value <- to_df[[value]][to_match]
    if (is.factor(from_value)) from_value <- as.character(from_value)
    if (is.factor(to_value)) to_value <- as.character(to_value)
    out[[paste0("from_", value)]] <- from_value
    out[[paste0("to_", value)]] <- to_value
  }

  from_present <- !is.na(from_match)
  to_present <- !is.na(to_match)
  out$paired_complete <- from_present & to_present &
    !is.na(out$from_pcat_display_code) & !is.na(out$to_pcat_display_code)
  out$delta_display_code <- out$to_pcat_display_code - out$from_pcat_display_code
  out$transition <- "not_comparable"
  out$transition[!from_present & to_present] <- "newly_observed"
  out$transition[from_present & !to_present] <- "followup_missing"
  out$transition[out$paired_complete & out$delta_display_code > 0] <- "toward_facilitation"
  out$transition[out$paired_complete & out$delta_display_code < 0] <- "toward_barrier"
  out$transition[out$paired_complete & out$delta_display_code == 0] <- "no_code_change"
  from_detail <- ifelse(
    !from_present,
    "not_observed",
    ifelse(is.na(out$from_pcat_class), "incomplete_response", out$from_pcat_class)
  )
  to_detail <- ifelse(
    !to_present,
    "not_observed",
    ifelse(is.na(out$to_pcat_class), "incomplete_response", out$to_pcat_class)
  )
  out$transition_detail <- paste0(from_detail, " -> ", to_detail)
  out$from_timepoint <- as.character(from)
  out$to_timepoint <- as.character(to)

  items <- pcat_items("both")
  meta_names <- c(
    "item_text", "cfir_original_construct", "cfir_2022_construct"
  )
  metadata <- items[match(out$item_id, items$item_id), meta_names, drop = FALSE]
  out <- cbind(out, metadata)
  rownames(out) <- NULL
  class(out) <- unique(c("pcat_change", "data.frame"))
  attr(out, "delta_note") <- paste(
    "delta_display_code is descriptive only; positive values indicate movement",
    "toward facilitation and are not interval-scale effect estimates."
  )
  out
}

#' Create a barrier-focused action-plan table
#'
#' @param data Raw/classified data or a pCAT summary.
#' @param group_vars Grouping columns used when summarization is needed.
#' @param barrier_threshold Minimum proportion identifying a barrier.
#' @param strong_barrier_threshold Minimum proportion identifying a strong barrier.
#' @param include_strategy_candidates Join candidate ERIC strategies.
#' @param include_approximate Include an approximate source-table mapping.
#' @return A data frame ready for local action planning.
#' @rdname pcat_summarise
#' @export
pcat_action_plan <- function(
    data,
    group_vars = NULL,
    barrier_threshold = 0.50,
    strong_barrier_threshold = 0.20,
    include_strategy_candidates = TRUE,
    include_approximate = FALSE) {
  .pcat_check_probability_scalar(barrier_threshold, "barrier_threshold")
  .pcat_check_probability_scalar(
    strong_barrier_threshold,
    "strong_barrier_threshold"
  )

  required <- c(
    "item_id", "pct_barrier", "pct_strong_barrier",
    "cfir_original_construct"
  )
  summary_data <- if (all(required %in% names(data))) {
    as.data.frame(data, stringsAsFactors = FALSE, check.names = FALSE)
  } else {
    pcat_summarise(data, group_vars = group_vars)
  }

  barrier_signal <- !is.na(summary_data$pct_barrier) &
    summary_data$pct_barrier >= barrier_threshold
  strong_signal <- !is.na(summary_data$pct_strong_barrier) &
    summary_data$pct_strong_barrier >= strong_barrier_threshold
  keep <- barrier_signal | strong_signal
  out <- summary_data[keep, , drop = FALSE]
  out$barrier_priority <- character(nrow(out))
  both <- !is.na(out$pct_barrier) & !is.na(out$pct_strong_barrier) &
    out$pct_barrier >= barrier_threshold &
    out$pct_strong_barrier >= strong_barrier_threshold
  strong_only <- !both & !is.na(out$pct_strong_barrier) &
    out$pct_strong_barrier >= strong_barrier_threshold
  out$barrier_priority[both] <- "high"
  out$barrier_priority[strong_only] <- "strong_effect_signal"
  out$barrier_priority[!both & !strong_only] <- "barrier_prevalence_signal"

  if (isTRUE(include_strategy_candidates) && nrow(out) > 0L) {
    candidates <- pcat_strategy_candidates(
      include_approximate = include_approximate
    )
    candidate_names <- c(
      "pcat_original_construct", "strategy", "tier", "mapping_status",
      "source_construct", "source_doi"
    )
    candidates <- candidates[candidate_names]
    out$.pcat_order__ <- seq_len(nrow(out))
    out <- merge(
      out,
      candidates,
      by.x = "cfir_original_construct",
      by.y = "pcat_original_construct",
      all.x = TRUE,
      sort = FALSE
    )
    out <- out[order(out$.pcat_order__, out$tier, na.last = TRUE), , drop = FALSE]
    out$.pcat_order__ <- NULL
  } else {
    out$strategy <- rep(NA_character_, nrow(out))
    out$tier <- rep(NA_integer_, nrow(out))
    out$mapping_status <- rep(NA_character_, nrow(out))
    out$source_construct <- rep(NA_character_, nrow(out))
    out$source_doi <- rep(NA_character_, nrow(out))
  }

  out$selected_strategy <- rep(NA_character_, nrow(out))
  out$planned_action <- rep(NA_character_, nrow(out))
  out$local_adaptation <- rep(NA_character_, nrow(out))
  out$owner <- rep(NA_character_, nrow(out))
  out$target_date <- as.Date(rep(NA_character_, nrow(out)))
  out$status <- rep(NA_character_, nrow(out))
  out$action_notes <- rep(NA_character_, nrow(out))

  ordering <- intersect(as.character(group_vars %||% character()), names(out))
  order_args <- lapply(ordering, function(column) out[[column]])
  order_args <- c(
    order_args,
    list(-out$pct_strong_barrier, -out$pct_barrier, out$item_id, out$tier, na.last = TRUE)
  )
  if (nrow(out) > 0L) {
    ord <- do.call(order, order_args)
    out <- out[ord, , drop = FALSE]
  }

  rownames(out) <- NULL
  attr(out, "strategy_note") <- paste(
    "Candidate strategies are discussion prompts derived from the source",
    "table, not automatically selected or validated prescriptions."
  )
  class(out) <- unique(c("pcat_action_plan", "data.frame"))
  out
}
