# pcatR 1.0.1 CRAN submission record

This file tracks the initial CRAN submission separately from the immutable
GitHub `v1.0.0` release.

## Completed in the source tree

- Package version advanced to 1.0.1.
- DESCRIPTION cites both source articles by DOI.
- Source-derived content and adaptations are documented in `LICENSE.note` and
  installed `inst/COPYRIGHTS`.
- Package citation is generated from DESCRIPTION metadata; both source articles
  have complete author lists.
- Installed technical guides are PDF and HTML, not Markdown source.
- The documented minimum R version is exercised by an R 4.1 CI job.

## Required evidence before submission

- [x] Local source spelling and URL checks reviewed.
- [x] `R CMD build` produces exactly `pcatR_1.0.1.tar.gz`.
- [x] `R CMD check --as-cran pcatR_1.0.1.tar.gz` reviewed with no errors or
      warnings and all notes explained.
- [x] Archive contents inspected for excluded development and release files.
- [ ] GitHub Actions pass on Windows, macOS, Linux, R devel, release, oldrel,
      and R 4.1.
- [ ] Win-builder R-devel and R-release results reviewed.
- [ ] Maintainer obtains confirmation of the package name and source-content
      treatment from the original instrument authors before submission.
- [ ] Maintainer submits only the source archive through CRAN's submission form
      and responds to CRAN's confirmation email.

Registry searches can show that a name is currently unused, but they do not
reserve it. Recheck CRAN and Bioconductor immediately before submission.

## Registry check recorded July 12, 2026

- `pcatR` was absent from the current CRAN package index.
- CRAN's exact `src/contrib/Archive/pcatR/` path returned HTTP 404, indicating
  no historical archive at that exact case-sensitive name.
- The exact package name was absent from Bioconductor's release package page.

These observations are point-in-time checks, not a reservation or acceptance
decision.
