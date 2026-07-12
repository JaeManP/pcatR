# Install development dependencies and run local development checks.
required <- c(
  "devtools", "roxygen2", "testthat", "knitr", "rmarkdown", "pkgdown",
  "rcmdcheck", "covr"
)
missing <- required[!vapply(required, requireNamespace, logical(1), quietly = TRUE)]
if (length(missing) > 0L) install.packages(missing)

devtools::document()
devtools::load_all(reset = TRUE)
devtools::test(stop_on_failure = TRUE)
pcat_self_test()
message("Development setup and tests completed. Run devtools::check() next.")
