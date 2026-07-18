# pcatR 1.0.1

## CRAN preparation release

- Added complete source attribution and copyright notices for bundled
  source-derived instrument content.
- Made the software citation derive its version and authors from package
  metadata and completed the author list for the 2026 updated-CFIR article.
- Added an installed HTML technical guide alongside the PDF guide.
- Added a dedicated R 4.1 continuous-integration check for the documented
  minimum R version.
- Updated release metadata and submission checks for an initial CRAN review.
- Corrected the complete five-category partition by adding
  `n_neutral_complete` and deriving all five category counts from
  `pcat_class5`, while retaining directional `n_neutral`.
- Extended small-cell suppression to derived modal classifications.
- Required valid direction and effect parsing before assigning a non-invalid
  strength category.
- Added validation of every page before failure-safe multi-page profile PDF
  writing, so a late page error cannot leave or replace a partial target.
- Enforced true finite scalar validation for consensus and action-plan
  probability thresholds and repaired broken links in the source archive.

# pcatR 1.0.0

## Stable GitHub release

- Added `pcat_analyse()` and a structured `pcat_analysis` result object.
- Added `pcat_write_analysis()` for reproducible export of validation issues,
  classified responses, item summaries, consensus diagnostics, action plans,
  an analysis manifest, and an optional multi-page profile PDF.
- Rebuilt visualization with `ggplot2`, shared legends, readable facet labels,
  explicit neutral labels and denominators, and device-independent output.
- Improved profile defaults for multi-panel readability and expanded absent item
  records explicitly in respondent and change heatmaps.
- Added `pcat_save_profile_pdf()` to place one grouping combination per page.
- Added original and updated CFIR mapping metadata, including item 10's
  secondary Funding mapping from the 2026 supplementary table.
- Added user-defined small-cell suppression in `pcat_summarise()`.
- Clarified denominators: directional percentages use valid direction responses;
  five-category strength percentages use complete direction/effect responses.
- Added a packaged technical user guide accessible through
  `pcat_user_guide()`.
- Added GitHub Actions, pkgdown configuration, citation metadata, issue and pull
  request templates, security/support/governance policies, and release tools.
- Added automated tests and `pcat_self_test()`.
- Added privacy-aware export controls, analysis settings/session provenance, and
  deterministic cleanup of stale package-generated output files.
- Preserved the methodological boundary that item display codes must not be
  summed into a purported validated total pCAT score.

# pcatR 0.1.2

- Corrected restoration of graphics parameters in early base-graphics plots.

# pcatR 0.1.1

- Corrected early development-test and installation issues.

# pcatR 0.1.0

- Initial development release.
