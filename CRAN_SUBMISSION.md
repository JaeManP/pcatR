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
- [ ] The software copyright-holder arrangement is confirmed in writing and
      `Authors@R`, `LICENSE`, `LICENSE.md`, and `inst/COPYRIGHTS` agree.
- [ ] Lilac Li confirms her authorship, Jae Man Park's maintainer role, the
      licensing arrangement, public distribution, and CRAN submission.
- [ ] Win-builder R-devel and R-release results reviewed.
- [ ] Maintainer obtains confirmation of the package name and source-content
      treatment from the original instrument authors before submission.
- [ ] Maintainer submits only the source archive through CRAN's submission form
      and responds to CRAN's confirmation email.

Registry searches can show that a name is currently unused, but they do not
reserve it. Recheck CRAN and Bioconductor immediately before submission.

## GitHub candidate evidence recorded July 12, 2026

- Candidate source head: `3a919edb77b50ba7634737c61a5755a7b3e09119`
- R-CMD-check run: `29215546944`
- pkgdown run: `29215546939`
- test-coverage run: `29215546943`
- Candidate source archive SHA-256:
  `f5d907a6733b5b3d271cc5a97dc5fcc20b884b7338d548be6f91897eaf4db8df`
- Exact-archive R 4.6.1 check: 0 errors, 0 warnings, 2 notes.
- Exact-archive R-devel check (2026-06-21 r90185): 0 errors, 0 warnings,
  2 notes.

The notes identify the new submission and the GitHub Ubuntu runner's missing
HTML Tidy executable. Both checks built the PDF manual successfully. This hash
is a candidate hash, not the final frozen-submission hash: selecting the legal
copyright-holder arrangement will change package-source files.

## Registry check recorded July 12, 2026

- `pcatR` was absent from the current CRAN package index.
- CRAN's exact `src/contrib/Archive/pcatR/` path returned HTTP 404, indicating
  no historical archive at that exact case-sensitive name.
- The exact package name was absent from Bioconductor's release package page.

These observations are point-in-time checks, not a reservation or acceptance
decision.
