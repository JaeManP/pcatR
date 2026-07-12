test_that("item dictionary has 14 unique items", {
  items <- pcat_items("both")
  expect_equal(nrow(items), 14L)
  expect_equal(sort(items$item_id), 1:14)
  expect_equal(length(unique(items$item_key)), 14L)
  expect_true(all(nzchar(items$item_text)))
})

test_that("updated primary mapping has one construct per item", {
  items <- pcat_items("2022")
  expect_true(all(nzchar(items$cfir_construct)))
  expect_equal(length(unique(items$cfir_construct)), 14L)
})

test_that("long construct map retains the secondary Funding mapping", {
  updated_all <- pcat_construct_map("2022", include_secondary = TRUE)
  updated_primary <- pcat_construct_map("2022", include_secondary = FALSE)

  expect_equal(nrow(updated_all), 15L)
  expect_equal(nrow(updated_primary), 14L)
  expect_equal(sort(unique(updated_primary$item_id)), 1:14)

  item10 <- updated_all[updated_all$item_id == 10L, , drop = FALSE]
  expect_equal(nrow(item10), 2L)
  expect_true(any(grepl("Materials & Equipment", item10$cfir_construct)))
  expect_true(any(grepl("Funding", item10$cfir_construct)))
  expect_equal(sort(item10$mapping_role), c("primary", "secondary"))
})

test_that("response option dictionary contains both response components", {
  options <- pcat_response_options()
  expect_equal(sum(options$response == "direction"), 3L)
  expect_equal(sum(options$response == "effect"), 2L)
  expect_equal(options$value[options$response == "direction"], 1:3)
  expect_equal(options$value[options$response == "effect"], 0:1)
})
