# Interactive installation helper for a downloaded pcatR source archive.
archive <- file.choose()
install.packages(archive, repos = NULL, type = "source")
library(pcatR)
print(packageVersion("pcatR"))
pcat_self_test()
message("Open the technical guide with pcat_user_guide().")
