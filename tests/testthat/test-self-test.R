test_that("dependency-free self-test passes", {
  expect_silent(result <- pcat_self_test(verbose = FALSE))
  expect_true(all(result$status == "PASS"))
})
