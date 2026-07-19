test_that("standard analysis wrapper returns all core components", {
  result <- pcat_analyse(
    pcat_example_data(),
    group_vars = c("site_id", "timepoint"),
    require_complete = TRUE
  )

  expect_s3_class(result, "pcat_analysis")
  expect_s3_class(result$validation, "pcat_validation")
  expect_s3_class(result$classified, "pcat_classified")
  expect_s3_class(result$summary, "pcat_summary")
  expect_s3_class(result$consensus, "pcat_consensus")
  expect_s3_class(result$action_plan, "pcat_action_plan")
  expect_equal(nrow(result$summary), 56L)
  expect_equal(nrow(result$consensus), 56L)
})

test_that("analysis export writes reproducible component files", {
  result <- pcat_analyse(
    pcat_example_data(),
    group_vars = c("site_id", "timepoint"),
    require_complete = TRUE
  )
  path <- tempfile("pcat_export_")
  output <- pcat_write_analysis(
    result,
    path,
    include_profile_pdf = FALSE
  )

  expect_true(dir.exists(output))
  expect_true(file.exists(file.path(output, "00_manifest.csv")))
  expect_true(file.exists(file.path(output, "01_validation_issues.csv")))
  expect_true(file.exists(file.path(output, "02_classified_responses.csv")))
  expect_true(file.exists(file.path(output, "03_item_summary.csv")))
  expect_true(file.exists(file.path(output, "04_consensus_diagnostics.csv")))
  expect_true(file.exists(file.path(output, "05_action_plan.csv")))
  expect_true(file.exists(file.path(output, "07_analysis_settings.csv")))
  expect_true(file.exists(file.path(output, "08_session_info.txt")))
  expect_true(file.exists(file.path(output, "README.txt")))
})

test_that("export can omit classified data and cleans stale generated files", {
  result <- pcat_analyse(
    pcat_example_data(),
    group_vars = c("site_id", "timepoint"),
    require_complete = TRUE
  )
  path <- tempfile("pcat_export_cleanup_")
  pcat_write_analysis(
    result,
    path,
    include_profile_pdf = FALSE,
    include_classified = TRUE
  )
  expect_true(file.exists(file.path(path, "02_classified_responses.csv")))
  expect_true(file.exists(file.path(path, "05_action_plan.csv")))

  no_plan <- pcat_analyse(
    pcat_example_data(),
    group_vars = c("site_id", "timepoint"),
    require_complete = TRUE,
    include_action_plan = FALSE
  )
  pcat_write_analysis(
    no_plan,
    path,
    overwrite = TRUE,
    include_profile_pdf = FALSE,
    include_classified = FALSE
  )
  expect_false(file.exists(file.path(path, "02_classified_responses.csv")))
  expect_false(file.exists(file.path(path, "05_action_plan.csv")))
  expect_true(file.exists(file.path(path, "07_analysis_settings.csv")))
  expect_true(file.exists(file.path(path, "08_session_info.txt")))
})

test_that("profile plot uses readable neutral labels and shared facets", {
  classified <- pcat_classify(pcat_example_data())
  plot <- plot_pcat_profile(
    classified,
    group_vars = c("site_id", "timepoint"),
    label = "cfir_original_construct"
  )

  is_plot <- if ("is_ggplot" %in% getNamespaceExports("ggplot2")) {
    ggplot2::is_ggplot(plot)
  } else {
    inherits(plot, "ggplot")
  }
  expect_true(is_plot)
  expect_equal(length(unique(as.character(plot$data$item_label))), 14L)
  expect_true(all(grepl("Item ", as.character(plot$data$item_label), fixed = TRUE)))
})

test_that("heatmap and change plot return ggplot objects", {
  classified <- pcat_classify(pcat_example_data())
  heatmap <- plot_pcat_heatmap(
    classified,
    facet_vars = c("site_id", "timepoint")
  )
  change <- pcat_change(
    classified,
    from = "planning",
    to = "mid_implementation"
  )
  change_plot <- plot_pcat_change(change, facet_vars = "site_id")

  is_plot <- function(x) {
    if ("is_ggplot" %in% getNamespaceExports("ggplot2")) {
      ggplot2::is_ggplot(x)
    } else {
      inherits(x, "ggplot")
    }
  }
  expect_true(is_plot(heatmap))
  expect_true(is_plot(change_plot))
})

test_that("profile PDF exporter creates a non-empty PDF", {
  classified <- pcat_classify(pcat_example_data())
  path <- tempfile(fileext = ".pdf")
  output <- pcat_save_profile_pdf(
    classified,
    path,
    group_vars = c("site_id", "timepoint"),
    label = "item_id",
    overwrite = TRUE
  )

  expect_true(file.exists(output))
  expect_gt(file.info(output)$size, 1000)
  expect_identical(
    output,
    normalizePath(path, winslash = "/", mustWork = TRUE)
  )
})

test_that("profile PDF preflight leaves no new partial target", {
  parent <- tempfile("pcat_pdf_failure_")
  dir.create(parent)
  on.exit(unlink(parent, recursive = TRUE, force = TRUE), add = TRUE)
  target <- file.path(parent, "profiles.pdf")
  dat <- data.frame(
    respondent_id = c("R1", "R2"),
    site_id = c("A", "B"),
    item_id = 1L,
    direction = c(1, 1),
    effect = c(1, NA)
  )

  expect_error(
    pcat_save_profile_pdf(
      dat,
      target,
      group_vars = "site_id",
      label = "item_id"
    ),
    regexp = "group `B`",
    class = "pcat_no_complete_plot_data"
  )
  expect_false(file.exists(target))
  expect_length(
    list.files(parent, pattern = "^\\.pcat-profile-", all.files = TRUE),
    0L
  )
})

test_that("profile PDF preflight preserves an existing target byte for byte", {
  parent <- tempfile("pcat_pdf_existing_")
  dir.create(parent)
  on.exit(unlink(parent, recursive = TRUE, force = TRUE), add = TRUE)
  target <- file.path(parent, "profiles.pdf")
  sentinel <- charToRaw("existing-profile-sentinel")
  writeBin(sentinel, target)
  dat <- data.frame(
    respondent_id = c("R1", "R2"),
    site_id = c("A", "B"),
    item_id = 1L,
    direction = c(1, 3),
    effect = c(1, NA)
  )

  expect_error(
    pcat_save_profile_pdf(
      dat,
      target,
      group_vars = "site_id",
      overwrite = TRUE,
      label = "item_id"
    ),
    class = "pcat_no_complete_plot_data"
  )
  expect_identical(
    readBin(target, what = "raw", n = file.info(target)$size),
    sentinel
  )
  expect_length(
    list.files(parent, pattern = "^\\.pcat-profile-", all.files = TRUE),
    0L
  )
})

test_that("profile PDF exporter rejects a directory-valued target safely", {
  parent <- tempfile("pcat_pdf_directory_", tmpdir = tempdir())
  dir.create(parent)
  on.exit(unlink(parent, recursive = TRUE, force = TRUE), add = TRUE)
  target <- file.path(parent, "profiles.pdf")
  dir.create(target)
  sentinel_path <- file.path(target, "sentinel.bin")
  sentinel <- charToRaw("directory-target-sentinel")
  writeBin(sentinel, sentinel_path)

  expect_error(
    pcat_save_profile_pdf(
      pcat_example_data(),
      target,
      overwrite = TRUE,
      label = "item_id"
    ),
    regexp = "not a directory",
    class = "pcat_profile_export_error"
  )
  expect_true(dir.exists(target))
  expect_identical(
    readBin(sentinel_path, what = "raw", n = file.info(sentinel_path)$size),
    sentinel
  )
  expect_length(
    list.files(
      parent,
      pattern = "^\\.pcat-profile(-backup)?-",
      all.files = TRUE
    ),
    0L
  )
})

test_that("profile PDF exporter rejects infinite page dimensions", {
  for (dimension in c("width", "height")) {
    for (value in c(Inf, -Inf)) {
      target <- tempfile(fileext = ".pdf")
      arguments <- list(
        data = pcat_example_data(),
        path = target,
        label = "item_id"
      )
      arguments[[dimension]] <- value
      expect_error(
        do.call(pcat_save_profile_pdf, arguments),
        regexp = "positive finite numbers",
        class = "pcat_profile_export_error"
      )
      expect_false(file.exists(target))
    }
  }
})

test_that("profile export warns when tabular suppression is active", {
  result <- pcat_analyse(
    pcat_example_data(),
    group_vars = c("site_id", "timepoint"),
    suppress_below = 10
  )
  path <- tempfile("pcat_suppressed_export_")

  expect_warning(
    pcat_write_analysis(
      result,
      path,
      include_profile_pdf = TRUE
    ),
    regexp = "does not inherit small-cell suppression",
    class = "pcat_profile_suppression_warning"
  )
  expect_true(file.exists(file.path(path, "06_profile.pdf")))
})

test_that("packaged technical guide can be located", {
  pdf_path <- pcat_user_guide("pdf", open = FALSE)
  html_path <- pcat_user_guide("html", open = FALSE)
  source_path <- system.file(
    "guides", "source", "pcatR_Technical_User_Guide.Rmd",
    package = "pcatR"
  )
  expect_true(file.exists(pdf_path))
  expect_true(file.exists(html_path))
  expect_true(file.exists(source_path))
  html <- paste(readLines(html_path, warn = FALSE), collapse = "\n")
  expect_match(
    html,
    '<html(?: xmlns="http://www\\.w3\\.org/1999/xhtml")? lang="en-US" xml:lang="en-US">'
  )
})


test_that("heatmap expands absent items as explicit missing cells", {
  classified <- pcat_classify(pcat_example_data())
  one_assessment <- classified[
    classified$respondent_id == "R001" &
      classified$site_id == "SITE_A" &
      classified$timepoint == "planning",
    ,
    drop = FALSE
  ]
  one_assessment <- one_assessment[one_assessment$item_id != 14L, , drop = FALSE]

  plot <- plot_pcat_heatmap(one_assessment)
  expect_equal(nrow(plot$data), 14L)
  missing_cell <- plot$data[plot$data$item_id == 14L, , drop = FALSE]
  expect_equal(as.character(missing_cell$.pcat_plot_class), "missing_or_incomplete")
})

test_that("change heatmap expands absent paired items as not comparable", {
  classified <- pcat_classify(pcat_example_data())
  one_person <- classified[
    classified$respondent_id == "R001" & classified$site_id == "SITE_A",
    ,
    drop = FALSE
  ]
  one_person <- one_person[one_person$item_id != 14L, , drop = FALSE]
  change <- pcat_change(
    one_person,
    from = "planning",
    to = "mid_implementation"
  )
  plot <- plot_pcat_change(change, display = "transition")
  expect_equal(nrow(plot$data), 14L)
  absent_cell <- plot$data[plot$data$item_id == 14L, , drop = FALSE]
  expect_equal(as.character(absent_cell$.pcat_plot_value), "not_comparable")
})
