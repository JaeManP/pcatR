test_that("complete example validates", {
  dat <- pcat_example_data()
  val <- pcat_validate(dat, require_complete = TRUE, action = "none")
  expect_s3_class(val, "pcat_validation")
  expect_true(val$valid)
  expect_equal(val$n_errors, 0L)
})

test_that("five complete response combinations classify correctly", {
  dat <- data.frame(
    respondent_id = paste0("R", 1:5),
    item_id = 1:5,
    direction = c(1, 1, 2, 3, 3),
    effect = c(1, 0, NA, 0, 1)
  )
  out <- pcat_classify(dat)
  expect_equal(
    out$pcat_class,
    c(
      "strong_barrier", "weak_barrier", "neutral",
      "weak_facilitator", "strong_facilitator"
    )
  )
  expect_equal(out$pcat_display_code, c(-2, -1, 0, 1, 2))
})

test_that("strength classification requires valid direction and effect", {
  dat <- data.frame(
    respondent_id = paste0("R", 1:9),
    item_id = 1:9,
    direction = c(4, 1, 1, 1, 2, 2, 3, 3, 3),
    effect = c(1, NA, 0, 1, NA, 1, NA, 0, 1)
  )
  out <- pcat_classify(dat, validation_action = "none")

  expect_equal(out$pcat_side[[1L]], "invalid")
  expect_equal(out$pcat_strength[[1L]], "invalid")
  expect_equal(out$pcat_class[[1L]], "invalid")
  expect_true(is.na(out$pcat_class5[[1L]]))
  expect_true(is.na(out$pcat_display_code[[1L]]))
  expect_equal(
    out$pcat_strength[-1L],
    c(
      "missing", "weak_or_no_effect", "strong_effect", "not_applicable",
      "not_applicable", "missing", "weak_or_no_effect", "strong_effect"
    )
  )
})

test_that("invalid and duplicate rows are reported", {
  dat <- data.frame(
    respondent_id = c("R1", "R1"),
    item_id = c(15, 15),
    direction = c(4, 4),
    effect = c(2, 2)
  )
  val <- pcat_validate(dat, action = "none")
  issues <- pcat_validation_issues(val, "row")
  expect_false(val$valid)
  expect_true(all(c(
    "invalid_item_id", "invalid_direction", "invalid_effect", "duplicate_key"
  ) %in% issues$issue_code))
})

test_that("neutral effect response is a warning", {
  dat <- data.frame(
    respondent_id = "R1", item_id = 1, direction = 2, effect = 1
  )
  val <- pcat_validate(dat, action = "none")
  issues <- pcat_validation_issues(val, "row")
  expect_true("neutral_with_effect" %in% issues$issue_code)
  expect_equal(val$n_errors, 0L)
  expect_equal(val$n_warnings, 1L)
})


test_that("missing effect preserves barrier direction but not five-class code", {
  dat <- data.frame(
    respondent_id = "R1", item_id = 1, direction = 1, effect = NA
  )
  out <- pcat_classify(dat)
  expect_equal(out$pcat_side, "barrier")
  expect_equal(out$pcat_class, "barrier_effect_missing")
  expect_true(is.na(out$pcat_class5))
  expect_true(is.na(out$pcat_display_code))
})

test_that("duplicate keys remain visible but are ineligible for summaries", {
  dat <- data.frame(
    respondent_id = c("R1", "R1"),
    item_id = c(1, 1),
    direction = c(1, 1),
    effect = c(1, 1)
  )
  classified <- pcat_classify(dat)
  expect_true(all(!classified$pcat_record_eligible))
  summary <- pcat_summarise(classified)
  expect_equal(summary$n_rows_input, 2L)
  expect_equal(summary$n_rows_eligible, 0L)
  expect_true(is.na(summary$pct_barrier))
})

test_that("empty input is rejected explicitly", {
  empty <- data.frame(
    respondent_id = character(),
    item_id = integer(),
    direction = integer(),
    effect = integer()
  )
  expect_error(
    pcat_validate(empty, action = "none"),
    class = "pcat_empty_data"
  )
})

test_that("assessment date distinguishes repeated same-timepoint assessments", {
  dat <- data.frame(
    respondent_id = c("R1", "R1"),
    item_id = c(1, 1),
    timepoint = c("planning", "planning"),
    assessment_date = as.Date(c("2026-01-01", "2026-02-01")),
    direction = c(1, 3),
    effect = c(1, 1)
  )
  val <- pcat_validate(dat, action = "none")
  issues <- pcat_validation_issues(val, "row")
  expect_true(val$valid)
  expect_false("duplicate_key" %in% issues$issue_code)
})

test_that("strict validation treats warnings as invalid", {
  dat <- data.frame(
    respondent_id = "R1", item_id = 1, direction = 2, effect = 1
  )
  val <- pcat_validate(dat, strict = TRUE, action = "none")
  expect_false(val$valid)
  expect_equal(val$n_errors, 0L)
  expect_equal(val$n_warnings, 1L)
})

test_that("validation issues are a zero-row data frame when no issues exist", {
  val <- pcat_validate(
    pcat_example_data(),
    require_complete = TRUE,
    action = "none"
  )
  issues <- pcat_validation_issues(val)
  expect_s3_class(issues, "data.frame")
  expect_equal(nrow(issues), 0L)
  expect_true(all(c("issue_code", "severity", "message") %in% names(issues)))
})

test_that("neutral paired with weak or strong effect is flagged", {
  dat <- data.frame(
    respondent_id = c("R1", "R2"),
    item_id = c(1, 1),
    direction = c(2, 2),
    effect = c(0, 1)
  )
  val <- pcat_validate(dat, action = "none")
  issues <- pcat_validation_issues(val, "row")
  expect_equal(val$n_errors, 0L)
  expect_equal(val$n_warnings, 2L)
  expect_equal(sum(issues$issue_code == "neutral_with_effect"), 2L)
})
