test_that("long-wide-long preserves response values", {
  long <- pcat_template("long", n_respondents = 2, include_item_text = FALSE)
  long$direction <- rep(c(1L, 3L), length.out = nrow(long))
  long$effect <- rep(c(0L, 1L), length.out = nrow(long))
  wide <- pcat_long_to_wide(long)
  back <- pcat_wide_to_long(wide)
  back <- back[order(back$respondent_id, back$item_id), ]
  long <- long[order(long$respondent_id, long$item_id), ]
  expect_equal(back$direction, long$direction)
  expect_equal(back$effect, long$effect)
})

test_that("paired change identifies movement toward facilitation", {
  dat <- data.frame(
    respondent_id = c("R1", "R1"),
    item_id = c(1, 1),
    timepoint = c("planning", "mid"),
    direction = c(1, 3),
    effect = c(1, 1)
  )
  out <- pcat_change(dat, from = "planning", to = "mid")
  expect_equal(out$delta_display_code, 4)
  expect_equal(out$transition, "toward_facilitation")
})

test_that("wide-to-long works when no identifier columns are present", {
  wide <- data.frame(
    item01_direction = 1,
    item01_effect = 1,
    item02_direction = 3,
    item02_effect = 0
  )
  long <- pcat_wide_to_long(wide)
  expect_equal(long$item_id, c(1L, 2L))
  expect_equal(long$direction, c(1, 3))
  expect_equal(long$effect, c(1, 0))
})

test_that("CSV reader detects standard wide and long layouts", {
  long <- data.frame(
    respondent_id = "R1",
    item_id = 1,
    direction = 1,
    effect = 1
  )
  long_path <- tempfile(fileext = ".csv")
  utils::write.csv(long, long_path, row.names = FALSE)
  expect_equal(nrow(pcat_read_csv(long_path)), 1L)

  wide <- data.frame(
    respondent_id = "R1",
    item01_direction = 1,
    item01_effect = 1
  )
  wide_path <- tempfile(fileext = ".csv")
  utils::write.csv(wide, wide_path, row.names = FALSE)
  imported <- pcat_read_csv(wide_path)
  expect_equal(imported$item_id, 1L)
  expect_equal(imported$direction, 1)
  expect_equal(imported$effect, 1)
})


test_that("reshape functions reject item identifiers outside 1 through 14", {
  expect_error(
    pcat_wide_to_long(data.frame(item15_direction = 1, item15_effect = 1)),
    regexp = "item numbers 1 through 14"
  )
  expect_error(
    pcat_long_to_wide(data.frame(
      respondent_id = "R1", item_id = 15, direction = 1, effect = 1
    )),
    regexp = "1 through 14"
  )
})

test_that("wide input rejects duplicate aliases for one item component", {
  dat <- data.frame(
    item1_direction = 1,
    item01_direction = 1,
    item01_effect = 1,
    check.names = FALSE
  )
  expect_error(
    pcat_wide_to_long(dat),
    regexp = "duplicate response columns"
  )
})
