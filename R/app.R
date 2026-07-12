#' Launch the optional pCAT analysis dashboard
#'
#' The bundled Shiny application imports a standard long- or wide-format CSV,
#' validates and classifies responses, displays summaries and profiles, and
#' exports classified data, item summaries, and action-plan tables. It is not
#' a secure survey-collection platform.
#'
#' @return The value returned by `shiny::runApp()`.
#' @export
pcat_app <- function() {
  if (!requireNamespace("shiny", quietly = TRUE)) {
    .pcat_abort(
      "Install the optional `shiny` package before running `pcat_app()`."
    )
  }
  app_dir <- system.file("shiny", "pcat", package = "pcatR")
  if (!nzchar(app_dir)) {
    app_dir <- file.path("inst", "shiny", "pcat")
  }
  shiny::runApp(app_dir, display.mode = "normal")
}
