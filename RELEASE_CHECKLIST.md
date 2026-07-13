# pcatR release checklist

This file is a reusable blank review template. Version-specific completion
status and evidence are maintained in `CRAN_SUBMISSION.md` and
`RELEASE_VALIDATION.md`.

## Source and methods

- [ ] Confirm exact 14-item wording against the attributed source.
- [ ] Confirm original and updated CFIR mappings, including item 10 secondary
      Funding mapping.
- [ ] Confirm no function or documentation implies a validated overall score.
- [ ] Review response coding, denominators, suppression, and strategy caveats.
- [ ] Update `source_manifest.json` and access/release dates.

## Package quality

- [ ] Update version in `DESCRIPTION`, `NEWS.md`, `inst/CITATION`,
      `CITATION.cff`, and the technical guide.
- [ ] Run `devtools::document()` and inspect NAMESPACE/man changes.
- [ ] Run `devtools::test()`.
- [ ] Run `devtools::check()` with 0 errors and 0 warnings; review all notes.
- [ ] Run spelling and URL checks and review every finding.
- [ ] Run `R CMD build` and confirm the archive is exactly
      `pcatR_1.0.1.tar.gz`.
- [ ] Run `R CMD check --as-cran pcatR_1.0.1.tar.gz`.
- [ ] Inspect the source archive for development-only and release-only files.
- [ ] Build the pkgdown site and inspect every article/reference page.
- [ ] Test installation from the generated `.tar.gz` in a clean R library.
- [ ] Verify Windows, macOS, Linux, and the minimum supported R 4.1 CI jobs.

## Release

- [ ] Merge through a reviewed pull request.
- [ ] Obtain confirmation of the package name and source-content treatment from
      the original instrument authors.
- [ ] Review Win-builder R-devel and R-release results.
- [ ] Recheck the `pcatR` name on CRAN and Bioconductor.
- [ ] Submit only `pcatR_1.0.1.tar.gz` through CRAN's submission form.
- [ ] Confirm CRAN's email and respond to reviewer requests.
- [ ] After acceptance, tag `v1.0.1` and create a GitHub Release.
- [ ] Attach the source archive, technical guide PDF, and checksums.
- [ ] Confirm GitHub renders `CITATION.cff` and the repository license.
- [ ] Archive a release snapshot in a long-term repository when appropriate.
