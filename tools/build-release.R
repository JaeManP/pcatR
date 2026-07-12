# Build the source archive after all release checks are green.
stopifnot(file.exists("DESCRIPTION"))
if (!requireNamespace("devtools", quietly = TRUE)) stop("Install devtools first.")
devtools::document()
archive <- devtools::build(path = normalizePath("..", winslash = "/"))
message("Built source archive: ", archive)
