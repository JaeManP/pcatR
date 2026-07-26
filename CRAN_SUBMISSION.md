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
- [x] Win-builder R-devel and R-release results reviewed.
- [x] Freeze one final source archive and retain its generated `.sha256` file;
      send those exact archive bytes to Win-builder and CRAN without rebuilding.
- [x] Formally document the maintainer's decision to rely on CC BY 4.0 for the
      identified source-derived pCAT content and to accept responsibility for
      the descriptive `pcatR` package name without claiming author endorsement.
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

## Frozen archive evidence

The package source was frozen at Git commit
`562d45d2bc9f2d135b145e0965e7cb38a69f8bb7`. GitHub Actions run
`30181084279` built `pcatR_1.0.1.tar.gz`; source artifact `8625569721`
contains that archive and its generated checksum file. The retained archive is
772,031 bytes, has 81 entries, and has SHA-256
`a5e834ead4b2a5c4d5a09c0950ffcd2d08a00c3c2eaa2c1a593384cecd128cbb`.

The same downloaded bytes passed exact-archive checks with full PDF manuals
under current R-release and R-devel in run `30181084279`; their log artifacts
are `8625631346` and `8625630473`. Coverage run `30181084286` and pkgdown run
`30181084290` also passed. The exact retained archive was submitted to
Win-builder R-release and R-devel on July 25, 2026. Both results were reviewed,
and the archive has not been submitted to CRAN.

The Win-builder R-release result under R 4.6.1 completed with 0 errors, 0
warnings, and 1 note. The note identified the new submission and requested
spelling review of proper author names, “et al.”, and the instrument name
“pCAT”; these terms are intentional. Installation succeeded and a Windows
binary was produced. Win-builder R-devel, revision 90301 dated July 25, 2026,
also completed with 0 errors, 0 warnings, and the same single expected note;
installation succeeded and a Windows binary was produced.

## Registry check recorded July 25, 2026

- `pcatR` was absent from the current CRAN package index.
- CRAN's exact `src/contrib/Archive/pcatR/` path returned HTTP 404, indicating
  no historical archive at that exact case-sensitive name.
- The exact package name was absent from Bioconductor's release package page.

These observations are point-in-time checks, not a reservation or acceptance
decision.
