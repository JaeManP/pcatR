#' Classify pCAT responses
#'
#' Combines direction and effect into five complete categories while retaining
#' explicit categories for missing or invalid responses. The numeric display
#' code is descriptive and is not a validated scale score.
#'
#' @param data A long data frame or `pcat_validation` object.
#' @param validation_action Action used if raw data must be validated.
#' @param attach_items Attach item wording and both CFIR mappings.
#' @return A data frame of class `pcat_classified`.
#' @export
pcat_classify <- function(
    data,
    validation_action = c("none", "warn", "error"),
    attach_items = TRUE) {
  validation_action <- match.arg(validation_action)
  validation <- if (inherits(data, "pcat_validation")) {
    data
  } else {
    pcat_validate(data, action = validation_action)
  }
  out <- as.data.frame(validation$data, stringsAsFactors = FALSE, check.names = FALSE)

  direction_invalid <- .pcat_has_issue(out$.pcat_issue_codes, "invalid_direction") |
    (!is.na(out$direction) & !out$direction %in% 1:3)
  effect_invalid <- .pcat_has_issue(out$.pcat_issue_codes, "invalid_effect") |
    (!is.na(out$effect) & !out$effect %in% 0:1)
  item_invalid <- .pcat_has_issue(
    out$.pcat_issue_codes,
    c("missing_item_id", "invalid_item_id")
  ) | is.na(out$item_id) | !out$item_id %in% 1:14
  key_invalid <- .pcat_has_issue(
    out$.pcat_issue_codes,
    c("missing_respondent_id", "duplicate_key")
  )

  out$pcat_side <- rep("invalid", nrow(out))
  out$pcat_side[is.na(out$direction) & !direction_invalid] <- "missing"
  out$pcat_side[!is.na(out$direction) & out$direction == 1L & !direction_invalid] <- "barrier"
  out$pcat_side[!is.na(out$direction) & out$direction == 2L & !direction_invalid] <- "neutral"
  out$pcat_side[!is.na(out$direction) & out$direction == 3L & !direction_invalid] <- "facilitator"

  valid_response <- !direction_invalid & !effect_invalid
  out$pcat_strength <- rep("invalid", nrow(out))
  out$pcat_strength[
    valid_response & !is.na(out$direction) & out$direction == 2L
  ] <- "not_applicable"
  out$pcat_strength[
    valid_response & !is.na(out$direction) & out$direction != 2L &
      is.na(out$effect)
  ] <- "missing"
  out$pcat_strength[
    valid_response & !is.na(out$direction) & out$direction != 2L &
      !is.na(out$effect) & out$effect == 0L
  ] <- "weak_or_no_effect"
  out$pcat_strength[
    valid_response & !is.na(out$direction) & out$direction != 2L &
      !is.na(out$effect) & out$effect == 1L
  ] <- "strong_effect"

  out$pcat_class <- rep("invalid", nrow(out))
  out$pcat_class[valid_response & is.na(out$direction)] <- "missing"
  out$pcat_class[valid_response & !is.na(out$direction) & out$direction == 2L] <- "neutral"
  out$pcat_class[valid_response & !is.na(out$direction) & out$direction == 1L & !is.na(out$effect) & out$effect == 1L] <- "strong_barrier"
  out$pcat_class[valid_response & !is.na(out$direction) & out$direction == 1L & !is.na(out$effect) & out$effect == 0L] <- "weak_barrier"
  out$pcat_class[valid_response & !is.na(out$direction) & out$direction == 1L & is.na(out$effect)] <- "barrier_effect_missing"
  out$pcat_class[valid_response & !is.na(out$direction) & out$direction == 3L & !is.na(out$effect) & out$effect == 0L] <- "weak_facilitator"
  out$pcat_class[valid_response & !is.na(out$direction) & out$direction == 3L & !is.na(out$effect) & out$effect == 1L] <- "strong_facilitator"
  out$pcat_class[valid_response & !is.na(out$direction) & out$direction == 3L & is.na(out$effect)] <- "facilitator_effect_missing"

  valid_levels <- c(
    "strong_barrier", "weak_barrier", "neutral",
    "weak_facilitator", "strong_facilitator"
  )
  class5 <- out$pcat_class
  class5[!class5 %in% valid_levels] <- NA_character_
  out$pcat_class5 <- factor(class5, levels = valid_levels, ordered = TRUE)

  display_lookup <- c(
    strong_barrier = -2,
    weak_barrier = -1,
    neutral = 0,
    weak_facilitator = 1,
    strong_facilitator = 2
  )
  out$pcat_display_code <- unname(display_lookup[out$pcat_class])
  out$pcat_display_code[!out$pcat_class %in% names(display_lookup)] <- NA_real_

  direction_lookup <- c(barrier = -1, neutral = 0, facilitator = 1)
  out$pcat_direction_code <- unname(direction_lookup[out$pcat_side])
  out$pcat_direction_code[!out$pcat_side %in% names(direction_lookup)] <- NA_real_
  out$pcat_is_barrier <- out$pcat_side == "barrier"
  out$pcat_is_facilitator <- out$pcat_side == "facilitator"

  out$pcat_record_eligible <- !item_invalid & !key_invalid
  out$pcat_record_exclusion <- NA_character_
  out$pcat_record_exclusion[item_invalid] <- "invalid_or_missing_item_id"
  missing_respondent <- .pcat_has_issue(out$.pcat_issue_codes, "missing_respondent_id")
  out$pcat_record_exclusion[!item_invalid & missing_respondent] <- "missing_respondent_id"
  duplicate <- .pcat_has_issue(out$.pcat_issue_codes, "duplicate_key")
  out$pcat_record_exclusion[!item_invalid & !missing_respondent & duplicate] <- "duplicate_key"

  if (isTRUE(attach_items)) {
    metadata_names <- c(
      "item_key", "item_text", "cfir_original_domain",
      "cfir_original_construct", "cfir_2022_domain", "cfir_2022_subdomain",
      "cfir_2022_construct", "cfir_2022_secondary_construct",
      "cfir_2022_construct_all", "cfir_2022_mapping_count",
      "cfir_2022_mapping_note", "instrument_version",
      "instrument_source_doi", "mapping_source_doi", "content_license"
    )
    out[intersect(metadata_names, names(out))] <- NULL
    items <- pcat_items("both")
    metadata <- items[match(out$item_id, items$item_id), , drop = FALSE]
    metadata$item_id <- NULL
    out <- cbind(out, metadata)
  }

  rownames(out) <- NULL
  class(out) <- unique(c("pcat_classified", "data.frame"))
  attr(out, "pcat_display_code_note") <- paste(
    "The -2 to +2 display code is descriptive and is not a validated pCAT",
    "scale score. Do not sum it into a purported total score."
  )
  out
}
