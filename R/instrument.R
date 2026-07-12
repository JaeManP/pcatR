#' pCAT item dictionary
#'
#' Returns the 14 pCAT item statements with the original CFIR mapping and the
#' updated CFIR mapping supplied with this package.
#'
#' @param cfir_version One of `"both"`, `"original"`, or `"2022"`.
#' @return A data frame with one row per pCAT item.
#' @export
pcat_items <- function(cfir_version = c("both", "original", "2022")) {
  cfir_version <- match.arg(cfir_version)
  out <- .pcat_read_extdata("pcat_items.csv")
  out$item_id <- as.integer(out$item_id)
  out$cfir_2022_mapping_count <- as.integer(out$cfir_2022_mapping_count)

  if (cfir_version == "original") {
    out$cfir_version <- "original"
    out$cfir_domain <- out$cfir_original_domain
    out$cfir_subdomain <- NA_character_
    out$cfir_construct <- out$cfir_original_construct
    out$cfir_construct_all <- out$cfir_original_construct
  } else if (cfir_version == "2022") {
    out$cfir_version <- "2022"
    out$cfir_domain <- out$cfir_2022_domain
    out$cfir_subdomain <- out$cfir_2022_subdomain
    out$cfir_construct <- out$cfir_2022_construct
    out$cfir_construct_all <- out$cfir_2022_construct_all
  }
  rownames(out) <- NULL
  out
}

#' Long-form original and updated CFIR mappings
#'
#' @param cfir_version One of `"both"`, `"original"`, or `"2022"`.
#' @param include_secondary Include secondary mappings reported in a source.
#' @return A long-format data frame of item-to-CFIR mappings.
#' @rdname pcat_items
#' @export
pcat_construct_map <- function(
    cfir_version = c("both", "original", "2022"),
    include_secondary = TRUE) {
  cfir_version <- match.arg(cfir_version)
  out <- .pcat_read_extdata("pcat_cfir_mappings.csv")
  out$item_id <- as.integer(out$item_id)
  if (cfir_version != "both") {
    out <- out[out$cfir_version == cfir_version, , drop = FALSE]
  }
  if (!isTRUE(include_secondary)) {
    out <- out[out$mapping_role == "primary", , drop = FALSE]
  }
  role_order <- match(out$mapping_role, c("primary", "secondary"), nomatch = 99L)
  out <- out[order(out$item_id, out$cfir_version, role_order), , drop = FALSE]
  rownames(out) <- NULL
  out
}

#' pCAT response options
#'
#' @return A data frame documenting direction and effect response options.
#' @rdname pcat_items
#' @export
pcat_response_options <- function() {
  data.frame(
    response = c("direction", "direction", "direction", "effect", "effect"),
    value = c(1L, 2L, 3L, 0L, 1L),
    label = c(
      "Disagree", "Neutral", "Agree", "Weak/no effect", "Strong effect"
    ),
    interpretation = c(
      "Potential barrier",
      "Neutral condition",
      "Potential facilitator",
      "Barrier or facilitator is expected to have weak or no effect",
      "Barrier or facilitator is expected to have a strong effect"
    ),
    stringsAsFactors = FALSE
  )
}

#' Included example pCAT data
#'
#' @return A complete long-format synthetic example data set.
#' @rdname pcat_items
#' @export
pcat_example_data <- function() {
  out <- .pcat_read_extdata("pcat_example.csv", use_cache = FALSE)
  out$item_id <- as.integer(out$item_id)
  out$direction <- as.integer(out$direction)
  out$effect <- as.integer(out$effect)
  out$assessment_date <- as.Date(out$assessment_date)
  rownames(out) <- NULL
  out
}

#' Candidate ERIC strategies supplied with the pCAT source table
#'
#' Candidate strategies are prompts for local deliberation, not prescriptions.
#'
#' @param construct Optional original-CFIR construct name.
#' @param tier `"all"`, `"1"`, or `"2"`.
#' @param include_approximate Include the source-table Relative Priority to
#'   pCAT Relative Advantage approximation.
#' @return A data frame of candidate implementation strategies.
#' @rdname pcat_items
#' @export
pcat_strategy_candidates <- function(
    construct = NULL,
    tier = c("all", "1", "2"),
    include_approximate = FALSE) {
  tier <- match.arg(tier)
  out <- .pcat_read_extdata("pcat_eric_candidates.csv")
  out$tier <- as.integer(out$tier)

  if (!isTRUE(include_approximate)) {
    out <- out[out$mapping_status == "direct", , drop = FALSE]
  }
  if (!is.null(construct)) {
    construct <- as.character(construct)
    keep <- out$pcat_original_construct %in% construct |
      out$source_construct %in% construct
    out <- out[keep, , drop = FALSE]
  }
  if (tier != "all") {
    out <- out[out$tier == as.integer(tier), , drop = FALSE]
  }
  out <- out[order(out$tier, out$strategy), , drop = FALSE]
  rownames(out) <- NULL
  out
}
