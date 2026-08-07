## Resubmission

This is a resubmission following CRAN review.

In response to the review:

- all inappropriate `\dontrun{}` wrappers were removed;
- short executable examples now run normally;
- interactive Shiny examples are guarded by `interactive()` and
  `requireNamespace("shiny", quietly = TRUE)`;
- no `\donttest{}` example is retained because every revised noninteractive
  example benchmarks below five seconds;
- file-writing examples and vignettes use `tempfile()` or `tempdir()` and clean
  up their output;
- tests write only under the R temporary directory and clean up generated
  files;
- the writing functions continue to require explicit output paths and do not
  write by default; and
- single quotation marks were removed from the pCAT and CFIR acronyms in
  DESCRIPTION.

The corrected source was frozen after review and merge at Git commit
`4115207173266c26141fa87ba1a7bd90c892024d`. The exact corrected archive is
`pcatR_1.0.1.tar.gz` (775,499 bytes; 81 entries), with SHA-256
`9ab7aa0ed5d3d58421216b30cbcb8057191f214b667ce09af9bdcc7b7b9d9161`.
The same archive bytes were checked in GitHub Actions, downloaded and
inspected independently, submitted to Win-builder R-release and R-devel, and
retained for this CRAN resubmission without rebuilding.

## Test environment

- Local: macOS 26.1 (arm64), R 4.4.2
- GitHub Actions: macOS R-release; Windows R-release; Ubuntu R-devel,
  R-release, R-oldrel-1, and R 4.1
- Exact corrected archive: Ubuntu 24.04.4, R 4.6.1 and R-devel
  (2026-06-21 r90185), with the full PDF manual enabled
- Win-builder: Windows Server 2022, R 4.6.1 and R-devel revision 90366

## Corrected frozen-archive check results

The GitHub exact-archive R-release and R-devel checks completed with:

- 0 errors
- 0 warnings
- 2 notes

The notes were:

1. This is a new submission.
2. HTML validation was skipped because HTML Tidy was unavailable on the
   runner. Rd checks, the PDF manual, examples, tests, and rebuilt vignettes
   all completed successfully.

Win-builder R-release and R-devel checks of the same exact archive each
completed with 0 errors, 0 warnings, and 1 note. The note records the new
submission and requests spelling review of CFIR, Damschroder, Domlyn, “et
al.”, and pCAT. These names, acronyms, and capitalization are intentional.
Both Win-builder runs passed installation, examples, 239 tests, vignettes,
rebuilt vignettes, and PDF and HTML manuals and produced Windows binary
packages.

## Additional checks

- `spelling::spell_check_package()` reported no spelling errors.
- `urlchecker::url_check()` reported all package URLs correct.
- All 239 `testthat` expectations and all 25 package self-tests passed.
- Installed-package timings were 0.001 seconds for guide location, 0.005
  seconds for template writing and reading, 0.051 seconds for analysis export,
  and 1.047 seconds for profile-PDF export.
- The source archive contains the installed PDF and HTML technical guides,
  their editable R Markdown/CSS source and rendering instructions,
  `inst/COPYRIGHTS`, and `inst/WORDLIST`; development and submission files are
  excluded.
- Installation from the source archive into a clean library succeeded. The
  example analysis produced 56 item-summary rows and 56 consensus rows from
  336 synthetic input rows, and all 25 package self-tests passed.
- A clean local pkgdown build completed without warnings and its home,
  reference, article, citation, author, license, attribution, and release pages
  were inspected.
- The installed guide HTML was inspected for the revised examples. All 24
  pages of its regenerated PDF were rendered and visually inspected without
  clipping, overlap, malformed tables, missing glyphs, broken footers, or
  orphaned headings.
Jae Man Park is the package maintainer and a credited package author. The
maintainer retains Lilac Li's written agreement, including her final
version-specific approval of pcatR 1.0.1, her authorship and joint software
copyright-holder role, Jae Man Park's maintainer and CRAN-submitter roles,
licensing, and public GitHub and CRAN distribution. This approval concerns
Lilac Li's own role and authority; it is not recorded as confirmation on behalf
of the original pCAT authors.

For the source-derived pCAT content identified in `LICENSE.note` and
`inst/COPYRIGHTS`, the maintainer relies on the source publications' CC BY 4.0
license and warrants that the material is used in accordance with that license.
The package preserves attribution, license links, adaptation notices, and an
independent-software/no-endorsement statement. This is a maintainer
license-reliance decision, not original-pCAT-author authorization or
endorsement.

The superseded first-submission package source was frozen at Git commit
`562d45d2bc9f2d135b145e0965e7cb38a69f8bb7`. The exact retained archive is
`pcatR_1.0.1.tar.gz` (772,031 bytes; 81 entries), with SHA-256
`a5e834ead4b2a5c4d5a09c0950ffcd2d08a00c3c2eaa2c1a593384cecd128cbb`.
It contains both authors' `cph` roles and the joint MIT copyright-holder
statement. The same archive was submitted without rebuilding to Win-builder
R-release and R-devel on July 25, 2026. Win-builder R-release completed under
R 4.6.1 with 0 errors, 0 warnings, and 1 note for the new submission and
spelling review of intentional proper names/terms. Installation succeeded and
a Windows binary was produced. Win-builder R-devel revision 90301 also
completed with 0 errors, 0 warnings, and the same single expected note;
installation succeeded and a Windows binary was produced. CRAN technical
feedback recorded as received on July 26, 2026 requires corrected source and a
new exact archive; the SHA-256 above must not be reused for resubmission.
