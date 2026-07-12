test_that("summary percentages are internally consistent", {
  dat <- data.frame(
    respondent_id = paste0("R", 1:4),
    item_id = 1,
    direction = c(1, 1, 2, 3),
    effect = c(1, 0, NA, 1)
  )
  out <- pcat_summarise(dat)
  expect_equal(out$n_valid_direction, 4L)
  expect_equal(out$pct_barrier, 0.5)
  expect_equal(out$pct_neutral, 0.25)
  expect_equal(out$pct_facilitator, 0.25)
})

test_that("polarization is detected", {
  dat <- data.frame(
    respondent_id = paste0("R", 1:10),
    item_id = 1,
    direction = c(rep(1, 5), rep(3, 5)),
    effect = 1
  )
  out <- pcat_consensus(dat, polarization_min = 0.2)
  expect_true(out$polarized)
  expect_equal(out$consensus_label, "polarized")
})

test_that("profile labels remain unique when original constructs repeat", {
  skip_if_not_installed("ggplot2")
  classified <- pcat_classify(pcat_example_data())
  plot <- plot_pcat_profile(
    classified,
    label = "cfir_original_construct"
  )
  labels <- unique(as.character(plot$data$item_label))
  expect_equal(length(labels), 14L)
})

test_that("directional and five-category percentages use distinct denominators", {
  dat <- data.frame(
    respondent_id = paste0("R", 1:4),
    item_id = 1,
    direction = c(1, 1, 2, 3),
    effect = c(1, NA, NA, 0)
  )
  out <- pcat_summarise(dat)

  expect_equal(out$n_valid_direction, 4L)
  expect_equal(out$n_complete_class, 3L)
  expect_equal(out$pct_barrier, 2 / 4)
  expect_equal(out$pct_neutral, 1 / 4)
  expect_equal(out$pct_facilitator, 1 / 4)
  expect_equal(out$pct_strong_barrier, 1 / 3)
  expect_equal(out$pct_weak_facilitator, 1 / 3)
  expect_equal(out$pct_effect_missing, 1 / 4)
  expect_identical(attr(out, "direction_denominator"), "n_valid_direction")
  expect_identical(attr(out, "five_category_denominator"), "n_complete_class")
})

test_that("small-cell suppression masks numeric measures but preserves context", {
  dat <- data.frame(
    respondent_id = paste0("R", 1:3),
    site_id = "SITE_A",
    item_id = 1,
    direction = c(1, 2, 3),
    effect = c(1, NA, 0)
  )
  out <- pcat_summarise(
    dat,
    group_vars = "site_id",
    suppress_below = 4
  )

  expect_true(out$suppressed)
  expect_equal(out$site_id, "SITE_A")
  expect_equal(out$item_id, 1L)
  expect_false(is.na(out$item_text))
  expect_true(is.na(out$n_respondents))
  expect_true(is.na(out$n_valid_direction))
  expect_true(is.na(out$pct_barrier))
  expect_true(is.na(out$mean_display_code))
})

