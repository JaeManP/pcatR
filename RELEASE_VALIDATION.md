# pcatR 1.0.0 release validation

Validation date: 2026-07-12

## Completed in the artifact environment

- Parsed all 13 package R source files with R 4.3.0 through WebR.
- Executed all 24 built-in `pcat_self_test()` checks successfully.
- Parsed all eight test files.
- Parsed all 12 Rd files and obtained zero `tools::checkRd()` findings.
- Executed core workflows for validation, classification, summary, consensus,
  longitudinal change, action planning, and privacy-aware export.
- Confirmed the 14-item dictionary, 29 CFIR mapping rows, 336-row synthetic
  example, 24 complete synthetic assessments, and packaged guide assets.
- Parsed repository YAML, CFF, and JSON metadata.
- Verified that all NAMESPACE exports and S3 methods resolve to source
  definitions and all exports have Rd aliases.
- Rendered and visually inspected the 21-page technical guide in DOCX and PDF
  form.

## Publication gate performed by GitHub Actions

The repository includes workflows for multi-platform `R CMD check`, test
coverage, and pkgdown deployment. After the repository is pushed, the release
should be tagged only after all required workflows are green.

A native local `R CMD check` with the full CRAN dependency set was not executed
inside the artifact environment. Plot objects also require the imported
`ggplot2` package, which was not installable in the WebR sandbox. The repository
therefore treats successful GitHub Actions execution as the final public-release
quality gate.

## Methodological release boundary

The package does not calculate or endorse a validated overall pCAT total score.
The `-2` to `+2` display code is descriptive only, and implementation-strategy
links are local deliberation prompts rather than prescriptions.
