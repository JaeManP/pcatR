test_that("strategy table exposes direct tier-one candidates", {
  out <- pcat_strategy_candidates(
    "Available Resources", tier = "1"
  )
  expect_true(nrow(out) >= 1L)
  expect_true(all(out$tier == 1L))
  expect_true(all(out$mapping_status == "direct"))
})

test_that("action plan retains barrier items", {
  dat <- data.frame(
    respondent_id = paste0("R", 1:5),
    item_id = 8,
    direction = 1,
    effect = c(1, 1, 1, 0, 0)
  )
  plan <- pcat_action_plan(dat)
  expect_true(nrow(plan) >= 1L)
  expect_true(all(plan$item_id == 8L))
  expect_true("planned_action" %in% names(plan))
})


test_that("action-plan filtering treats missing strong-barrier shares as no signal", {
  summary_data <- data.frame(
    item_id = 1L,
    pct_barrier = 0.10,
    pct_strong_barrier = NA_real_,
    cfir_original_construct = "Patient Needs & Resources"
  )
  plan <- pcat_action_plan(
    summary_data,
    barrier_threshold = 0.50,
    strong_barrier_threshold = 0.20,
    include_strategy_candidates = FALSE
  )
  expect_equal(nrow(plan), 0L)
})

test_that("action-plan probability thresholds require numeric scalars", {
  dat <- data.frame(
    respondent_id = paste0("R", 1:3),
    item_id = 1L,
    direction = c(1, 2, 3),
    effect = c(1, NA, 0)
  )
  invalid <- list(
    c(0.4, 0.6), numeric(), NA_real_, NaN, Inf, -Inf, "0.5", -0.1, 1.1
  )

  for (argument in c("barrier_threshold", "strong_barrier_threshold")) {
    valid_args <- list(data = dat, include_strategy_candidates = FALSE)
    valid_args[[argument]] <- 0.5
    expect_s3_class(do.call(pcat_action_plan, valid_args), "pcat_action_plan")
    for (value in invalid) {
      invalid_args <- list(data = dat, include_strategy_candidates = FALSE)
      invalid_args[[argument]] <- value
      expect_error(
        do.call(pcat_action_plan, invalid_args),
        class = "pcat_invalid_probability"
      )
    }
  }

  expect_s3_class(
    pcat_action_plan(
      dat,
      barrier_threshold = 0,
      strong_barrier_threshold = 1,
      include_strategy_candidates = FALSE
    ),
    "pcat_action_plan"
  )
})
