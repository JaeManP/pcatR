# Validate pCAT response data

Checks identifiers, item numbers, direction and effect values, duplicate
keys, neutral responses with recorded effects, missing effects for
barrier or facilitator directions, and optional 14-item completeness.

## Usage

``` r
pcat_validate(
  data,
  key_cols = NULL,
  require_complete = FALSE,
  neutral_effect = c("flag", "allow", "set_missing"),
  action = c("warn", "error", "none"),
  strict = FALSE
)

# S3 method for class 'pcat_validation'
print(x, ...)

pcat_validation_data(x, valid_rows_only = FALSE)

pcat_validation_issues(x, level = c("all", "row", "assessment"))
```

## Arguments

- data:

  Long-format pCAT response data. Required columns are `respondent_id`,
  `item_id`, `direction`, and `effect`.

- key_cols:

  Columns defining one assessment. When omitted, available project,
  site, team, timepoint, assessment date, and respondent identifiers are
  used.

- require_complete:

  Logical; require exactly one row for every item 1–14 within each
  assessment.

- neutral_effect:

  How to handle a neutral direction paired with any recorded effect:
  flag it, allow it, or set the effect to missing.

- action:

  Whether validation findings generate a warning, an error, or no
  condition.

- strict:

  Logical; treat warnings as invalid when setting the object's `valid`
  field.

- x:

  A `pcat_validation` object.

- ...:

  Additional arguments, currently ignored by the print method.

- valid_rows_only:

  Logical; retain only rows without row-level errors.

- level:

  Return all issues, row-level issues, or assessment-completeness
  issues.

## Details

The default behavior flags a neutral response paired with either effect
code as a warning because effect strength is not applicable when
direction is neutral. Validation findings remain available in structured
form even when `action = "none"`.

## Value

`pcat_validate()` returns a `pcat_validation` object. The extractor
functions return data frames. The print method returns `x` invisibly.

## Examples

``` r
dat <- pcat_example_data()
val <- pcat_validate(dat, require_complete = TRUE, action = "none")
val
#> <pcat_validation>
#>   valid: yes
#>   rows: 336
#>   errors: 0
#>   warnings: 0
#>   complete assessments required: yes
head(pcat_validation_data(val))
#>   project_id respondent_id site_id      role timepoint assessment_date item_id
#> 1  PCAT_DEMO          R001  SITE_A clinician  planning      2026-01-15       1
#> 2  PCAT_DEMO          R001  SITE_A clinician  planning      2026-01-15       2
#> 3  PCAT_DEMO          R001  SITE_A clinician  planning      2026-01-15       3
#> 4  PCAT_DEMO          R001  SITE_A clinician  planning      2026-01-15       4
#> 5  PCAT_DEMO          R001  SITE_A clinician  planning      2026-01-15       5
#> 6  PCAT_DEMO          R001  SITE_A clinician  planning      2026-01-15       6
#>   direction effect comment .pcat_row_error .pcat_row_warning .pcat_issue_codes
#> 1         3      0      NA           FALSE             FALSE                  
#> 2         3      0      NA           FALSE             FALSE                  
#> 3         2     NA      NA           FALSE             FALSE                  
#> 4         3      0      NA           FALSE             FALSE                  
#> 5         2     NA      NA           FALSE             FALSE                  
#> 6         2     NA      NA           FALSE             FALSE                  
pcat_validation_issues(val)
#> [1] .pcat_row  issue_code severity   message   
#> <0 rows> (or 0-length row.names)
```
