#' pcatR: Analyze and Visualize Pragmatic Context Assessment Tool Data
#'
#' `pcatR` provides a reproducible workflow for the 14-item Pragmatic Context
#' Assessment Tool. It preserves the separate direction and effect responses,
#' supports original and updated CFIR mappings, and deliberately avoids
#' treating the instrument as a validated total scale.
#'
#' Start with [pcat_analyse()] for an end-to-end workflow or use the individual
#' validation, classification, summary, consensus, change, and plotting
#' functions directly. Open the full technical guide with [pcat_user_guide()].
#'
#' @keywords internal
"_PACKAGE"

utils::globalVariables(c(
  ".", ".n", ".pcat_group", ".pcat_item", ".pcat_plot_class",
  ".pcat_plot_value", ".pcat_respondent", ".pcat_row", "action_notes",
  "agreement_share", "assessment_n", "barrier_priority",
  "cfir_2022_construct", "cfir_2022_construct_all", "cfir_2022_domain",
  "cfir_2022_mapping_count", "cfir_2022_mapping_note",
  "cfir_2022_secondary_construct", "cfir_2022_subdomain", "cfir_construct",
  "cfir_construct_all", "cfir_domain", "cfir_original_construct",
  "cfir_subdomain", "cfir_version", "delta_display_code", "direction",
  "dominant_side", "effect", "item_id", "item_label", "mapping_role",
  "mapping_status", "n", "n_complete_class", "neutral_label",
  "normalized_entropy", "pcat_class", "pcat_class5", "pcat_display_code",
  "pcat_original_construct", "pcat_record_eligible", "pcat_side",
  "polarized", "prop", "respondent_id", "source_construct", "source_doi",
  "strategy", "tier", "transition", "value"
))
