# Quick source-tree demonstration after opening pcatR.Rproj.
devtools::load_all(reset = TRUE)
analysis <- pcat_analyse(
  pcat_example_data(),
  group_vars = c("site_id", "timepoint"),
  require_complete = TRUE,
  validation_action = "none"
)
print(analysis)
print(utils::head(analysis$summary))
print(plot_pcat_profile(
  analysis$classified,
  group_vars = c("site_id", "timepoint"),
  label = "cfir_original_construct"
))
