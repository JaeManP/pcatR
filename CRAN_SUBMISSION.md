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
- Installed technical guides include PDF and self-contained HTML plus editable
  R Markdown source, CSS, and rendering instructions.
- Unreleased-version metadata identifies the guide as a CRAN submission
  candidate rather than assigning version 1.0.1 a release date.
- The documented minimum R version is exercised by an R 4.1 CI job.
- The candidate underwent pre-CRAN analytical and privacy hardening covering
  complete-category partitioning, small-cell modal suppression, response
  validity, probability thresholds, an explicit complete-classification
  diagnostic, unknown-polarization semantics, and failure-safe profile export
  with directory-path and finite-dimension validation.

## Required evidence before submission

- [x] Local source spelling and URL checks reviewed.
- [x] `R CMD build` produces exactly `pcatR_1.0.1.tar.gz`.
- [x] `R CMD check --as-cran pcatR_1.0.1.tar.gz` reviewed with no errors or
      warnings and all notes explained.
- [x] Archive contents inspected for excluded development and release files.
- [x] GitHub Actions pass on Windows, macOS, Linux, R devel, release, oldrel,
      and R 4.1.
- [x] The exact uploaded source archive passes full-manual `--as-cran` checks
      under current R-release and R-devel.
- [x] A clean local pkgdown build was inspected for its home, reference,
      article, citation, author, license, attribution, and release pages.
- [x] Joint software copyright ownership is implemented consistently in
      `Authors@R`, `LICENSE`, `LICENSE.md`, and `inst/COPYRIGHTS`.
- [x] Retain Lilac Li's final version-specific approval of pcatR 1.0.1,
      including authorship, joint software copyright ownership, Jae Man Park's
      maintainer and CRAN-submitter roles, MIT software licensing, documented
      source-content treatment, and public GitHub and CRAN distribution.
- [ ] Win-builder R-devel and R-release results reviewed.
- [ ] Freeze one final source archive and retain its generated `.sha256` file;
      send those exact archive bytes to Win-builder and CRAN without rebuilding.
- [ ] Obtain and retain the original pCAT authors' package-name and
      source-content confirmation, or formally document the final
      license-reliance decision before submission.
- [ ] Maintainer submits only the source archive through CRAN's submission form
      and responds to CRAN's confirmation email.

Registry searches can show that a name is currently unused, but they do not
reserve it. Recheck CRAN and Bioconductor immediately before submission.

Lilac Li's initial written authorization is dated July 13, 2026. She provided
final version-specific approval of pcatR 1.0.1 on July 19, 2026. The combined
retained evidence covers her roles as first package author and joint software
copyright holder; Jae Man Park's roles as second package author, joint software
copyright holder, maintainer, and CRAN submitter; MIT licensing of original
package code; the documented attribution and licensing treatment of
source-derived content; and public GitHub and CRAN distribution.
The final approval applies to the package candidate represented by Git commit
`36ca2da22ab80a938509dfb7f06b59ecf1a3ca75`.

This approval concerns Lilac Li's own role and authority and is not recorded as
confirmation on behalf of the original pCAT authors. The maintainer retains the
original evidence privately because it contains personal communication and
metadata; it is excluded from Git and package source builds.

## Pre-freeze automated evidence

Candidate workflows have successfully checked exact uploaded archives under
current R-release and R-devel with full PDF manuals. The workflow now stores a
generated `.sha256` file beside each archive and verifies it before both checks.

The final source head, run IDs, and SHA-256 are deliberately pending. Record
them only after the remaining external approval is retained, the source is
frozen, and one exact archive is selected for Win-builder and CRAN submission.

## Registry check recorded July 12, 2026

- `pcatR` was absent from the current CRAN package index.
- CRAN's exact `src/contrib/Archive/pcatR/` path returned HTTP 404, indicating
  no historical archive at that exact case-sensitive name.
- The exact package name was absent from Bioconductor's release package page.

These observations are point-in-time checks, not a reservation or acceptance
decision.
