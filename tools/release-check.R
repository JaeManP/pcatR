# Maintainer release checks. Run from the package root.
stopifnot(file.exists("DESCRIPTION"), dir.exists("R"), dir.exists("tests/testthat"))
needed <- c("devtools", "rcmdcheck", "pkgdown")
missing <- needed[!vapply(needed, requireNamespace, logical(1), quietly = TRUE)]
if (length(missing) > 0L) stop("Install before release: ", paste(missing, collapse = ", "))

devtools::document()
devtools::test(stop_on_failure = TRUE)
pcat_self_test()
devtools::check(error_on = "warning")
rcmdcheck::rcmdcheck(args = c("--as-cran", "--no-manual"), error_on = "warning")
pkgdown::build_site(new_process = TRUE)
message("Automated release checks completed. Finish the manual RELEASE_CHECKLIST.md review.")
