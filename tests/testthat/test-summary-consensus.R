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

test_that("consensus probability thresholds require numeric scalars", {
  dat <- data.frame(
    respondent_id = paste0("R", 1:3),
    item_id = 1L,
    direction = c(1, 2, 3),
    effect = c(1, NA, 0)
  )
  invalid <- list(
    c(0.4, 0.6), numeric(), NA_real_, NaN, Inf, -Inf, "0.5", -0.1, 1.1
  )

  for (argument in c("agreement_threshold", "polarization_min")) {
    valid_args <- list(data = dat)
    valid_args[[argument]] <- 0.5
    expect_s3_class(do.call(pcat_consensus, valid_args), "pcat_consensus")
    for (value in invalid) {
      invalid_args <- list(data = dat)
      invalid_args[[argument]] <- value
      expect_error(
        do.call(pcat_consensus, invalid_args),
        class = "pcat_invalid_probability"
      )
    }
  }

  expect_s3_class(
    pcat_consensus(dat, agreement_threshold = 0, polarization_min = 1),
    "pcat_consensus"
  )
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
  expect_equal(out$pct_complete_class, 3 / 4)
  expect_equal(out$n_neutral_complete, 1L)
  expect_equal(out$pct_barrier, 2 / 4)
  expect_equal(out$pct_neutral, 1 / 4)
  expect_equal(out$pct_facilitator, 1 / 4)
  expect_equal(out$pct_strong_barrier, 1 / 3)
  expect_equal(out$pct_weak_facilitator, 1 / 3)
  expect_equal(out$pct_effect_missing, 1 / 4)
  expect_identical(attr(out, "direction_denominator"), "n_valid_direction")
  expect_identical(attr(out, "five_category_denominator"), "n_complete_class")
})

test_that("complete categories form a five-part partition", {
  dat <- data.frame(
    respondent_id = paste0("R", 1:4),
    item_id = 1L,
    direction = c(1, 2, 2, 3),
    effect = c(1, NA, 2, 0)
  )
  out <- pcat_summarise(dat)

  expect_equal(out$n_valid_direction, 4L)
  expect_equal(out$n_neutral, 2L)
  expect_equal(out$n_complete_class, 3L)
  expect_equal(out$n_neutral_complete, 1L)
  expect_equal(out$pct_neutral, 2 / 4)
  expect_equal(out$pct_complete_class, 3 / 4)
  expect_equal(out$pct_neutral_complete, 1 / 3)

  complete_counts <- out[c(
    "n_strong_barrier", "n_weak_barrier", "n_neutral_complete",
    "n_weak_facilitator", "n_strong_facilitator"
  )]
  complete_percentages <- out[c(
    "pct_strong_barrier", "pct_weak_barrier", "pct_neutral_complete",
    "pct_weak_facilitator", "pct_strong_facilitator"
  )]
  expect_equal(rowSums(complete_counts), out$n_complete_class)
  expect_equal(rowSums(complete_percentages), 1, tolerance = 1e-12)
  expect_true(all(unlist(complete_percentages) >= 0))
  expect_true(all(unlist(complete_percentages) <= 1))
})

test_that("zero complete-category denominators produce missing percentages", {
  dat <- data.frame(
    respondent_id = c("R1", "R2"),
    item_id = 1L,
    direction = c(1, 3),
    effect = c(NA, 2)
  )
  out <- pcat_summarise(dat)
  percentage_names <- c(
    "pct_strong_barrier", "pct_weak_barrier", "pct_neutral_complete",
    "pct_weak_facilitator", "pct_strong_facilitator"
  )
  percentages <- unlist(out[percentage_names], use.names = FALSE)

  expect_equal(out$n_complete_class, 0L)
  expect_equal(out$pct_complete_class, 0)
  expect_true(all(is.na(percentages)))
  expect_false(any(is.nan(percentages)))
  expect_false(any(is.infinite(percentages)))
})

test_that("completeness percentage is missing without valid directions", {
  dat <- data.frame(
    respondent_id = c("R1", "R2"),
    item_id = 1L,
    direction = c(NA, 4),
    effect = c(NA, 1)
  )
  out <- pcat_summarise(dat)

  expect_equal(out$n_valid_direction, 0L)
  expect_equal(out$n_complete_class, 0L)
  expect_type(out$pct_complete_class, "double")
  expect_true(is.na(out$pct_complete_class))
})

test_that("complete-category partition holds for grouped example summaries", {
  out <- pcat_summarise(
    pcat_example_data(),
    group_vars = c("site_id", "timepoint")
  )
  complete_counts <- out[c(
    "n_strong_barrier", "n_weak_barrier", "n_neutral_complete",
    "n_weak_facilitator", "n_strong_facilitator"
  )]
  complete_percentages <- out[c(
    "pct_strong_barrier", "pct_weak_barrier", "pct_neutral_complete",
    "pct_weak_facilitator", "pct_strong_facilitator"
  )]

  expect_equal(rowSums(complete_counts), out$n_complete_class)
  valid_direction <- !is.na(out$n_valid_direction) & out$n_valid_direction > 0L
  expect_equal(
    out$pct_complete_class[valid_direction],
    out$n_complete_class[valid_direction] /
      out$n_valid_direction[valid_direction]
  )
  expect_true(all(out$pct_complete_class[valid_direction] >= 0))
  expect_true(all(out$pct_complete_class[valid_direction] <= 1))
  expect_true(all(is.na(out$pct_complete_class[!valid_direction])))
  positive <- out$n_complete_class > 0L
  expect_equal(
    unname(rowSums(complete_percentages[positive, , drop = FALSE])),
    rep(1, sum(positive)),
    tolerance = 1e-12
  )
})

test_that("small-cell suppression masks analytic measures but preserves context", {
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
  expect_true(is.na(out$pct_complete_class))
  expect_true(is.na(out$mean_display_code))
  expect_true(is.na(out$modal_class))

  visible <- pcat_summarise(dat, group_vars = "site_id")
  expect_false(is.na(visible$modal_class))
})

test_that("polarization is unknown when summary shares are unavailable", {
  dat <- data.frame(
    respondent_id = paste0("R", 1:3),
    site_id = "SITE_A",
    item_id = 1L,
    direction = c(1, 2, 3),
    effect = c(1, NA, 0)
  )
  suppressed <- pcat_summarise(
    dat,
    group_vars = "site_id",
    suppress_below = 4
  )
  out <- pcat_consensus(suppressed)

  expect_true(is.na(out$polarized))
  expect_equal(out$consensus_label, "insufficient_data")
})
