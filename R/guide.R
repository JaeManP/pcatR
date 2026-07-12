#' Locate or open the pcatR technical user guide
#'
#' @param format Guide format: `"pdf"` or `"markdown"`.
#' @param open Open the guide with the system's default application.
#' @return The normalized guide path, invisibly.
#' @export
pcat_user_guide <- function(
    format = c("pdf", "markdown"),
    open = interactive()) {
  format <- match.arg(format)
  filename <- if (identical(format, "pdf")) {
    "pcatR_Technical_User_Guide.pdf"
  } else {
    "pcatR_Technical_User_Guide.md"
  }

  path <- system.file("guides", filename, package = "pcatR")
  if (!nzchar(path) || !file.exists(path)) {
    for (root in .pcat_project_candidates()) {
      candidate <- file.path(root, "inst", "guides", filename)
      if (file.exists(candidate)) {
        path <- candidate
        break
      }
    }
  }
  if (!nzchar(path) || !file.exists(path)) {
    .pcat_abort(
      paste0("Could not locate the packaged user guide `", filename, "`.")
    )
  }

  path <- normalizePath(path, winslash = "/", mustWork = TRUE)
  if (isTRUE(open)) {
    utils::browseURL(path)
  }
  invisible(path)
}
