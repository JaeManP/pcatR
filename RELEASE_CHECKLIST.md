# pcatR release checklist

## Source and methods

Confirm exact 14-item wording against the attributed source.

Confirm original and updated CFIR mappings, including item 10 secondary
Funding mapping.

Confirm no function or documentation implies a validated overall score.

Review response coding, denominators, suppression, and strategy caveats.

Update `source_manifest.json` and access/release dates.

## Package quality

Update version in `DESCRIPTION`, `NEWS.md`, `inst/CITATION`,
`CITATION.cff`, and the technical guide.

Run `devtools::document()` and inspect NAMESPACE/man changes.

Run `devtools::test()`.

Run `devtools::check()` with 0 errors and 0 warnings; review all notes.

Run `rcmdcheck::rcmdcheck(args = c("--as-cran"))`.

Build the pkgdown site and inspect every article/reference page.

Test installation from the generated `.tar.gz` in a clean R library.

Verify Windows, macOS, and Linux CI jobs.

## Release

Merge through a reviewed pull request.

Tag `v1.0.0` and create a GitHub Release.

Attach the source archive, technical guide PDF, and checksums.

Confirm GitHub renders `CITATION.cff` and the repository license.

Archive a release snapshot in a long-term repository when appropriate.
