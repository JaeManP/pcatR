# Data standards and validation

## Standard long format

One row represents one respondent-item response within one assessment.
The required columns are `respondent_id`, `item_id`, `direction`, and
`effect`. Recommended metadata include project, site, team, role,
timepoint, and assessment date.

``` r

template <- pcat_template("long", n_respondents = 2)
head(template)
#>   project_id respondent_id site_id team_id role timepoint assessment_date
#> 1 PROJECT_01          R001 SITE_01    <NA> <NA>  planning            <NA>
#> 2 PROJECT_01          R001 SITE_01    <NA> <NA>  planning            <NA>
#> 3 PROJECT_01          R001 SITE_01    <NA> <NA>  planning            <NA>
#> 4 PROJECT_01          R001 SITE_01    <NA> <NA>  planning            <NA>
#> 5 PROJECT_01          R001 SITE_01    <NA> <NA>  planning            <NA>
#> 6 PROJECT_01          R001 SITE_01    <NA> <NA>  planning            <NA>
#>   item_id
#> 1       1
#> 2       2
#> 3       3
#> 4       4
#> 5       5
#> 6       6
#>                                                                                                     item_text
#> 1 People here regularly seek to understand the needs of patients and make changes to better meet those needs.
#> 2                                 I have open lines of communication with everyone needed to make the change.
#> 3                                                    I have access to data to help track changes in outcomes.
#> 4                                                                The change is aligned with leadership goals.
#> 5                                                                The change is aligned with clinician values.
#> 6                                                  The change is compatible with existing clinical processes.
#>   direction effect comment
#> 1        NA     NA    <NA>
#> 2        NA     NA    <NA>
#> 3        NA     NA    <NA>
#> 4        NA     NA    <NA>
#> 5        NA     NA    <NA>
#> 6        NA     NA    <NA>
```

Direction is coded 1 = potential barrier, 2 = neutral, and 3 = potential
facilitator. Effect is coded 0 = weak/no effect and 1 = strong effect.
Leave effect missing when direction is neutral.

## Import standard files

``` r

raw <- pcat_read_csv("completed_pcat.csv", layout = "auto")
```

For non-standard source columns, import with a general CSV reader and
map them explicitly.

``` r

standard <- pcat_standardize(
  raw_data,
  respondent_id = "participant_code",
  item_id = "question_number",
  direction = "direction_response",
  effect = "effect_response",
  site_id = "clinic",
  timepoint = "wave"
)
```

## Validation

``` r

validation <- pcat_validate(
  pcat_example_data(),
  require_complete = TRUE,
  action = "none"
)
validation
#> <pcat_validation>
#>   valid: yes
#>   rows: 336
#>   errors: 0
#>   warnings: 0
#>   complete assessments required: yes
pcat_validation_issues(validation)
#> [1] .pcat_row  issue_code severity   message   
#> <0 rows> (or 0-length row.names)
```

The default flags a neutral response with any recorded effect. A barrier
or facilitator without an effect remains directionally informative but
cannot be placed in one of the five complete categories.

## Duplicate keys and completeness

By default, an assessment key is assembled from available project, site,
team, timepoint, assessment date, and respondent identifiers. Supply
`key_cols` explicitly when your design uses different boundaries.

``` r

pcat_validate(
  data,
  key_cols = c("project_id", "site_id", "timepoint", "respondent_id"),
  require_complete = TRUE,
  action = "error"
)
```

## Denominators

Directional percentages use all eligible records with a valid direction
and therefore use `n_valid_direction`. Complete five-category
percentages use only eligible records with a complete
direction-plus-effect classification and use `n_complete_class`.
`pct_complete_class` is `n_complete_class` divided by
`n_valid_direction` and describes the share of valid-direction records
with a complete five-category classification. The directional
`n_neutral` count can exceed `n_neutral_complete` when a neutral
direction has an invalid effect value. Report both denominators rather
than silently treating missing or invalid effects as complete
classifications.
