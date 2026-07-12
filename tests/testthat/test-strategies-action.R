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
