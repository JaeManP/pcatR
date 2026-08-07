# pcatR 1.0.1 CRAN submission record

This file tracks the initial CRAN submission and the requested technical
correction separately from the immutable GitHub `v1.0.0` release.

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

## CRAN review and correction status

- [x] The first pcatR 1.0.1 submission was uploaded and confirmed on July 25,
      2026.
- [x] CRAN technical feedback, recorded as received on July 26, 2026, requested
      corrections to example controls, demonstrated output paths, and acronym
      quotation in DESCRIPTION.
- [x] Preserve the first-submission source, archive, checksum, GitHub runs, and
      Win-builder results as superseded historical evidence.
- [x] Joint software copyright ownership is implemented consistently in
      `Authors@R`, `LICENSE`, `LICENSE.md`, and `inst/COPYRIGHTS`.
- [x] Retain Lilac Li's final version-specific approval of pcatR 1.0.1,
      including authorship, joint software copyright ownership, Jae Man Park's
      maintainer and CRAN-submitter roles, MIT software licensing, documented
      source-content treatment, and public GitHub and CRAN distribution.
- [x] Formally document the maintainer's decision to rely on CC BY 4.0 for the
      identified source-derived pCAT content and to accept responsibility for
      the descriptive `pcatR` package name without claiming author endorsement.
- [x] Review and merge the CRAN correction pull request.
- [x] Freeze the corrected package source and select one new exact archive.
- [x] Validate the new exact archive locally and in GitHub Actions, then inspect
      its checksum, contents, and exact-check logs.
- [x] Submit those exact corrected bytes to Win-builder R-release and R-devel.
- [ ] Resubmit those same corrected bytes to CRAN and confirm the submission
      email.

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

## Maintainer CC BY 4.0 license-reliance decision

On July 25, 2026, Jae Man Park, the designated package maintainer and CRAN
submitter, formally chose the license-reliance route for the source-derived
pCAT content identified in `LICENSE.note` and `inst/COPYRIGHTS`. For CRAN
submission purposes, the maintainer warrants that this material is used in
accordance with the CC BY 4.0 license granted by its source publications. The
package retains source attribution, links to the applicable license, and clear
notices describing the machine-readable and software-derived adaptations.

The maintainer also accepts responsibility for the descriptive package name
`pcatR`. Current and archived CRAN names and the current Bioconductor software
index must still be rechecked immediately before submission. This decision is
not recorded as confirmation, endorsement, trademark permission, or other
authorization from the original pCAT authors. It resolves the repository's
alternative package-name/source-content gate through documented maintainer
reliance rather than original-author confirmation.

## Corrected frozen archive

The corrected package source was frozen at Git commit
`4115207173266c26141fa87ba1a7bd90c892024d` after CRAN correction pull request
`JaeManP/pcatR#8` was squash-merged. Corrected-freeze provenance is recorded in
`JaeManP/pcatR#9`. GitHub Actions run `31135069391` built the exact corrected
`pcatR_1.0.1.tar.gz`; source artifact `8977657746` contains the archive and
generated checksum file. The frozen archive is 775,499 bytes, has 81 entries,
and has SHA-256
`9ab7aa0ed5d3d58421216b30cbcb8057191f214b667ce09af9bdcc7b7b9d9161`.

The same downloaded bytes passed the exact-archive checks with full PDF
manuals under R-release and R-devel in run `31135069391`; their log artifacts
are `8977718726` and `8978019306`. Coverage run `31135069405` passed with
84.86% line coverage, and pkgdown run `31135069415` built and deployed the
site successfully. Independent inspection confirmed the checksum, the
81-entry archive contents, successful clean installation, 239 passing
`testthat` expectations, 25 passing self-tests, and the absence of private
evidence and release-control files.

Those exact frozen bytes were submitted without rebuilding to Win-builder
R-release and R-devel on August 6, 2026. R-release under R 4.6.1 and R-devel
revision 90366 each completed with 0 errors, 0 warnings, and 1 expected note.
The note records the new submission and requests spelling review of CFIR,
Damschroder, Domlyn, “et al.”, and pCAT; these names, acronyms, and
capitalization are intentional. Both installations, examples, 239 tests,
vignettes, and PDF and HTML manuals completed successfully, and both Windows
binary packages were produced.

This archive is the corrected frozen submission archive for resubmission. It
must be resubmitted to CRAN byte-for-byte and must not be rebuilt or replaced
during the provenance-only record update.

## Superseded first-submission archive

The first-submission package source was frozen at Git commit
`562d45d2bc9f2d135b145e0965e7cb38a69f8bb7`. GitHub Actions run
`30181084279` built `pcatR_1.0.1.tar.gz`; source artifact `8625569721`
contains that archive and its generated checksum file. The retained archive is
772,031 bytes, has 81 entries, and has SHA-256
`a5e834ead4b2a5c4d5a09c0950ffcd2d08a00c3c2eaa2c1a593384cecd128cbb`.

Those downloaded bytes passed exact-archive checks with full PDF manuals
under current R-release and R-devel in run `30181084279`; their log artifacts
are `8625631346` and `8625630473`. Coverage run `30181084286` and pkgdown run
`30181084290` also passed. The exact retained archive was submitted to
Win-builder R-release and R-devel and then to CRAN on July 25, 2026. CRAN
returned technical feedback recorded as received on July 26, 2026. These bytes
are preserved as historical evidence and must not be resubmitted.

The Win-builder R-release result under R 4.6.1 completed with 0 errors, 0
warnings, and 1 note. The note identified the new submission and requested
spelling review of proper author names, “et al.”, and the instrument name
“pCAT”; these terms are intentional. Installation succeeded and a Windows
binary was produced. Win-builder R-devel, revision 90301 dated July 25, 2026,
also completed with 0 errors, 0 warnings, and the same single expected note;
installation succeeded and a Windows binary was produced.

## Registry check recorded August 6, 2026

- `pcatR` was absent from the current CRAN package index.
- CRAN's exact `src/contrib/Archive/pcatR/` path returned HTTP 404, indicating
  no historical archive at that exact case-sensitive name.
- The exact package name was absent from Bioconductor's release package page.

These observations are point-in-time checks, not a reservation or acceptance
decision.
