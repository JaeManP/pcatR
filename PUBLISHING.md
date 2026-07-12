# Publishing pcatR on GitHub

This checklist is for the repository maintainer. Package users should
follow the README and Technical User Guide instead.

## 1. Create the repository

Create a public repository named `pcatR` under the `JaeManP` account.
Create it without adding a README, license, or `.gitignore`, because
those files are already included in this project.

## 2. Push the prepared source tree

From a terminal opened in the extracted `pcatR` directory:

``` bash
git init
git add .
git commit -m "Release pcatR 1.0.0"
git branch -M main
git remote add origin https://github.com/JaeManP/pcatR.git
git push -u origin main
```

## 3. Require automated checks

Open the repository’s **Actions** tab and confirm that these workflows
complete successfully:

- `R-CMD-check` on Windows, macOS, and Linux;
- `test-coverage`; and
- `pkgdown`.

Do not tag the release until the R CMD check matrix is green. If branch
protection is enabled, require the release-R checks and at least one
Linux check before merging changes to `main`.

## 4. Enable the documentation website

The `pkgdown` workflow deploys the generated site to the `gh-pages`
branch. After its first successful run, open **Settings \> Pages** and
select deployment from the `gh-pages` branch if GitHub has not
configured it automatically. The expected site address is:

``` text
https://jaemanp.github.io/pcatR/
```

## 5. Tag and publish version 1.0.0

``` bash
git tag -a v1.0.0 -m "pcatR 1.0.0"
git push origin v1.0.0
```

Create a GitHub Release from tag `v1.0.0`. Attach:

- `pcatR_1.0.0.tar.gz`;
- `pcatR_Technical_User_Guide_v1.0.0.pdf`;
- `pcatR_Technical_User_Guide_v1.0.0.docx`; and
- `pcatR_1.0.0_SHA256SUMS.txt`.

Use the version 1.0.0 section of `NEWS.md` as the release summary. The
root `CITATION.cff` enables GitHub’s repository citation interface.

## 6. Verify installation from GitHub

In a clean R session:

``` r

install.packages("remotes")
remotes::install_github("JaeManP/pcatR")
library(pcatR)
packageVersion("pcatR")
pcat_self_test()
pcat_user_guide()
```

## 7. Preserve release provenance

Retain the release archive, checksums, verification report, and
generated user guide with the release record. Record the package version
or Git commit in all analyses and manuscripts.
