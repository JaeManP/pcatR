# pcatR

[![R-CMD-check](https://github.com/JaeManP/pcatR/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/JaeManP/pcatR/actions/workflows/R-CMD-check.yaml)
[![test-coverage](https://github.com/JaeManP/pcatR/actions/workflows/test-coverage.yaml/badge.svg)](https://github.com/JaeManP/pcatR/actions/workflows/test-coverage.yaml)
[![pkgdown](https://github.com/JaeManP/pcatR/actions/workflows/pkgdown.yaml/badge.svg)](https://github.com/JaeManP/pcatR/actions/workflows/pkgdown.yaml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

`pcatR` is an independent R package for reproducible analysis of the 14-item
**Pragmatic Context Assessment Tool (pCAT)**. It imports and validates response
data, classifies barriers and facilitators, summarizes item-level patterns,
describes team agreement and disagreement, compares repeated assessments,
creates implementation action-planning tables, and produces publication-ready
figures.

## Read this first

The pCAT was developed as a brief pragmatic reflection and problem-solving tool,
not as a conventional multi-item psychometric scale. Accordingly, `pcatR`:

- reports items and constructs rather than a single overall score;
- **does not calculate or endorse a validated total pCAT scale score**;
- uses the `-2` to `+2` display code only for plotting and within-item transition
  descriptions;
- treats implementation-strategy links as prompts for local deliberation, not
  automated prescriptions; and
- should not replace a fuller contextual assessment when comprehensive CFIR
  determinant evaluation is required.

Read the [Technical User Guide](https://github.com/JaeManP/pcatR/blob/main/TECHNICAL_USER_GUIDE.md) before analyzing study
or operational data. After installation, open the packaged guide with:

```r
pcat_user_guide()
```

## Installation

### From GitHub

```r
install.packages("remotes")
remotes::install_github("JaeManP/pcatR")
```

### From a downloaded source archive

```r
install.packages(
  "pcatR_1.0.0.tar.gz",
  repos = NULL,
  type = "source"
)
```

`pcatR` is a pure-R package. Its required plotting dependency, `ggplot2`, is
installed automatically by standard package installers. The optional Shiny
interface requires `shiny`.

## Sixty-second workflow

```r
library(pcatR)

# Use synthetic example data, or replace this with pcat_read_csv("file.csv").
dat <- pcat_example_data()

analysis <- pcat_analyse(
  dat,
  group_vars = c("site_id", "timepoint"),
  require_complete = TRUE,
  validation_action = "none"
)

analysis
pcat_validation_issues(analysis$validation)
head(analysis$summary)
head(analysis$consensus)
head(analysis$action_plan)

plot_pcat_profile(
  analysis$classified,
  group_vars = c("site_id", "timepoint"),
  label = "cfir_original_construct"
)

pcat_write_analysis(
  analysis,
  path = "pcat_analysis_outputs",
  overwrite = TRUE
)
```

The export directory contains a manifest, validation findings, classified
responses, item summaries, consensus diagnostics, an action-plan worksheet, and
an optional multi-page profile PDF. Set `include_classified = FALSE` when a
respondent-level export is not required.

## Response coding

Each item has two response components:

| Component | Code | Meaning |
|---|---:|---|
| Direction | 1 | Disagree / potential barrier |
| Direction | 2 | Neutral |
| Direction | 3 | Agree / potential facilitator |
| Effect | 0 | Weak or no effect |
| Effect | 1 | Strong effect |

Leave `effect` blank when `direction = 2` (neutral). A neutral response paired
with any effect value is flagged by default.

The five complete descriptive classifications are:

| Direction | Effect | Classification | Display code |
|---:|---:|---|---:|
| 1 | 1 | Strong barrier | -2 |
| 1 | 0 | Weak barrier | -1 |
| 2 | blank | Neutral | 0 |
| 3 | 0 | Weak facilitator | +1 |
| 3 | 1 | Strong facilitator | +2 |

The display code must not be summed across items or treated as an interval-scale
outcome.

## Standard long-format data

Required columns are `respondent_id`, `item_id`, `direction`, and `effect`.
Recommended metadata columns include `project_id`, `site_id`, `team_id`, `role`,
`timepoint`, `assessment_date`, and `comment`.

```r
pcat_write_template(
  "pcat_long_template.csv",
  format = "long",
  n_respondents = 10,
  include_item_text = TRUE
)
```

For non-standard source data, map columns explicitly:

```r
standard <- pcat_standardize(
  raw_data,
  respondent_id = "participant_code",
  item_id = "question_number",
  direction = "barrier_facilitator_response",
  effect = "effect_strength",
  site_id = "clinic",
  timepoint = "wave"
)
```

## Core functions

| Task | Primary functions |
|---|---|
| Instrument and mappings | `pcat_items()`, `pcat_construct_map()`, `pcat_response_options()` |
| Templates and import | `pcat_template()`, `pcat_write_template()`, `pcat_read_csv()`, `pcat_standardize()` |
| Validation | `pcat_validate()`, `pcat_validation_issues()` |
| Classification | `pcat_classify()` |
| End-to-end analysis | `pcat_analyse()` |
| Item summaries | `pcat_summarise()` |
| Agreement/disagreement | `pcat_consensus()` |
| Repeated assessment | `pcat_change()` |
| Action planning | `pcat_action_plan()`, `pcat_strategy_candidates()` |
| Figures | `plot_pcat_profile()`, `plot_pcat_heatmap()`, `plot_pcat_change()` |
| Export | `pcat_write_analysis()`, `pcat_save_profile_pdf()` |
| Technical guide | `pcat_user_guide()` |
| Diagnostic check | `pcat_self_test()` |
| Optional dashboard | `pcat_app()` |

## CFIR mappings

The package retains the original pCAT-to-CFIR mapping and the updated mapping
reported in 2026. Item 10 has two updated-CFIR links in Supplementary Table S3:
`Available Resources: Materials & Equipment` (primary in the package dictionary)
and `Available Resources: Funding` (secondary). Retrieve all links with:

```r
pcat_construct_map("2022", include_secondary = TRUE)
```

## Privacy and operational use

Use coded respondent identifiers. Do not place names, medical-record numbers,
email addresses, or protected health information in pCAT files. Avoid
respondent-level heatmaps for small or identifiable teams. For tabular outputs,
`pcat_summarise(..., suppress_below = 5)` suppresses numerical results below a
user-specified respondent threshold; select the threshold required by your
protocol or organization.

The Shiny interface is an analysis convenience, not a secure survey-collection
platform.

## Citation and attribution

Package authors, in order, are [Lilac Li](https://www.unk.edu/academics/management/lilac-li.php)
and [Jae Man Park](https://www.linkedin.com/in/jae-man-park/). Jae Man Park is
the package maintainer.

Run:

```r
citation("pcatR")
```

Analyses should cite the software, the original pCAT development article, and,
when updated CFIR mappings are used, the 2026 mapping article. Instrument wording
and source-derived mapping content are attributed under CC BY 4.0; package code
is MIT licensed. See [LICENSE.note](LICENSE.note) and
[REFERENCES.md](REFERENCES.md).

This software is independent and is not an official product or endorsement of
the original pCAT authors, the U.S. Department of Veterans Affairs, the CFIR
Leadership Team, or the instrument repository.

## Development

```r
install.packages(c("devtools", "testthat", "pkgdown"))
devtools::document()
devtools::test()
devtools::check()
pkgdown::build_site()
```

See [CONTRIBUTING.md](https://github.com/JaeManP/pcatR/blob/main/CONTRIBUTING.md), [GOVERNANCE.md](https://github.com/JaeManP/pcatR/blob/main/GOVERNANCE.md), and
[SECURITY.md](https://github.com/JaeManP/pcatR/blob/main/SECURITY.md) before contributing.

Before publishing, follow [PUBLISHING.md](https://github.com/JaeManP/pcatR/blob/main/PUBLISHING.md), complete [RELEASE_CHECKLIST.md](https://github.com/JaeManP/pcatR/blob/main/RELEASE_CHECKLIST.md), and require all GitHub Actions jobs to pass. The completed artifact-environment
checks and the remaining CI publication gate are documented in
[RELEASE_VALIDATION.md](RELEASE_VALIDATION.md).
