# Install the package from this source directory.
if (!requireNamespace("devtools", quietly = TRUE)) install.packages("devtools")
devtools::document()
devtools::install(dependencies = TRUE, upgrade = FALSE)
library(pcatR)
pcat_self_test()
message("pcatR installed and the built-in self-test passed.")
