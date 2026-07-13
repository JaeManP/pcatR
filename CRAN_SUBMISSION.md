# pcatR 1.0.1 CRAN submission record

This file tracks the initial CRAN submission separately from the
immutable GitHub `v1.0.0` release.

## Completed in the source tree

- Package version advanced to 1.0.1.
- DESCRIPTION cites both source articles by DOI.
- Source-derived content and adaptations are documented in
  `LICENSE.note` and installed `inst/COPYRIGHTS`.
- Package citation is generated from DESCRIPTION metadata; both source
  articles have complete author lists.
- Installed technical guides include PDF and self-contained HTML plus
  editable R Markdown source, CSS, and rendering instructions.
- Unreleased-version metadata identifies the guide as a CRAN submission
  candidate rather than assigning version 1.0.1 a release date.
- The documented minimum R version is exercised by an R 4.1 CI job.

## Required evidence before submission

Local source spelling and URL checks reviewed.

`R CMD build` produces exactly `pcatR_1.0.1.tar.gz`.

`R CMD check --as-cran pcatR_1.0.1.tar.gz` reviewed with no errors or
warnings and all notes explained.

Archive contents inspected for excluded development and release files.

GitHub Actions pass on Windows, macOS, Linux, R devel, release, oldrel,
and R 4.1.

The exact uploaded source archive passes full-manual `--as-cran` checks
under current R-release and R-devel.

A clean local pkgdown build was inspected for its home, reference,
article, citation, author, license, attribution, and release pages.

Joint software copyright ownership is implemented consistently in
`Authors@R`, `LICENSE`, `LICENSE.md`, and `inst/COPYRIGHTS`.

Retain Lilac Li’s written approval of her authorship and
copyright-holder role, Jae Man Park’s maintainer role, the MIT and CC BY
4.0 licensing treatment, public distribution, and submission to CRAN.

Win-builder R-devel and R-release results reviewed.

Freeze one final source archive and retain its generated `.sha256` file;
send those exact archive bytes to Win-builder and CRAN without
rebuilding.

Maintainer obtains confirmation of the package name and source-content
treatment from the original instrument authors before submission.

Maintainer submits only the source archive through CRAN’s submission
form and responds to CRAN’s confirmation email.

Registry searches can show that a name is currently unused, but they do
not reserve it. Recheck CRAN and Bioconductor immediately before
submission.

## Pre-freeze automated evidence

Candidate workflows have successfully checked exact uploaded archives
under current R-release and R-devel with full PDF manuals. The workflow
now stores a generated `.sha256` file beside each archive and verifies
it before both checks.

The final source head, run IDs, and SHA-256 are deliberately pending.
Record them only after the external approvals are retained, the source
is frozen, and one exact archive is selected for Win-builder and CRAN
submission.

## Registry check recorded July 12, 2026

- `pcatR` was absent from the current CRAN package index.
- CRAN’s exact `src/contrib/Archive/pcatR/` path returned HTTP 404,
  indicating no historical archive at that exact case-sensitive name.
- The exact package name was absent from Bioconductor’s release package
  page.

These observations are point-in-time checks, not a reservation or
acceptance decision.
