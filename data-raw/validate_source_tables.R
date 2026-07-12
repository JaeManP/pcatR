# Maintainer checks for bundled source-derived tables.
items <- utils::read.csv("inst/extdata/pcat_items.csv", check.names = FALSE)
mapping <- utils::read.csv("inst/extdata/pcat_cfir_mappings.csv", check.names = FALSE)
strategies <- utils::read.csv("inst/extdata/pcat_eric_candidates.csv", check.names = FALSE)
example <- utils::read.csv("inst/extdata/pcat_example.csv", check.names = FALSE)

stopifnot(
  nrow(items) == 14L,
  identical(sort(as.integer(items$item_id)), 1:14),
  length(unique(items$item_key)) == 14L,
  all(nzchar(items$item_text)),
  sum(mapping$cfir_version == "original" & mapping$mapping_role == "primary") == 14L,
  sum(mapping$cfir_version == "2022" & mapping$mapping_role == "primary") == 14L,
  sum(mapping$cfir_version == "2022" & mapping$mapping_role == "secondary") == 1L,
  all(c("strategy", "tier", "mapping_status", "source_doi") %in% names(strategies)),
  nrow(example) == 336L
)

message("Bundled source-derived tables passed structural checks.")
