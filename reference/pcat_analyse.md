# Run the standard pCAT analysis workflow

Validates and classifies responses, creates item-level summaries and
consensus diagnostics, and optionally creates a barrier-focused action
plan.

## Usage

``` r
pcat_analyse(
  data,
  group_vars = NULL,
  respondent_id = "respondent_id",
  key_cols = NULL,
  require_complete = FALSE,
  neutral_effect = c("flag", "allow", "set_missing"),
  validation_action = c("none", "warn", "error"),
  strict = FALSE,
  suppress_below = NULL,
  agreement_threshold = 0.6,
  polarization_min = 0.2,
  minimum_n = 2L,
  include_action_plan = TRUE,
  barrier_threshold = 0.5,
  strong_barrier_threshold = 0.2,
  include_approximate = FALSE
)

# S3 method for class 'pcat_analysis'
print(x, ...)
```

## Arguments

- data:

  Long-format pCAT response data.

- group_vars:

  Optional character vector of grouping columns, such as `site_id` and
  `timepoint`.

- respondent_id:

  Name of the respondent identifier column.

- key_cols:

  Columns defining one assessment for validation. When omitted,
  available project, site, team, timepoint, assessment date, and
  respondent identifiers are used.

- require_complete:

  Logical; require exactly one response to every pCAT item 1–14 within
  each assessment.

- neutral_effect:

  How to handle a neutral direction paired with any recorded effect:
  flag it, allow it, or set the effect to missing.

- validation_action:

  Whether validation findings generate no condition, a warning, or an
  error.

- strict:

  Logical; treat warnings as invalid when setting the validation
  object's `valid` field.

- suppress_below:

  Optional positive minimum respondent count. Numeric summary results
  below this threshold are replaced with missing values.

- agreement_threshold:

  Minimum dominant-side share used for a consensus label.

- polarization_min:

  Minimum barrier and facilitator shares required to label an item
  polarized.

- minimum_n:

  Minimum number of valid direction responses required for a consensus
  label.

- include_action_plan:

  Logical; create a barrier-focused action-plan table.

- barrier_threshold:

  Minimum barrier prevalence for action-plan inclusion.

- strong_barrier_threshold:

  Minimum strong-barrier prevalence for action-plan inclusion.

- include_approximate:

  Logical; include the source table's non-identical Relative Priority to
  Relative Advantage approximation.

- x:

  A `pcat_analysis` object.

- ...:

  Additional arguments, currently ignored by the print method.

## Details

The result retains validation findings and all denominators needed for
transparent reporting. It does not calculate an overall pCAT scale
score. Small-cell suppression applies to summary tables;
respondent-level classified data are retained in the result and must be
governed separately.

## Value

`pcat_analyse()` returns a list of class `pcat_analysis` with components
`validation`, `classified`, `summary`, `consensus`, `action_plan`, and
`settings`. The print method returns `x` invisibly.

## Examples

``` r
analysis <- pcat_analyse(
  pcat_example_data(),
  group_vars = c("site_id", "timepoint"),
  require_complete = TRUE,
  validation_action = "none"
)
analysis
#> <pcat_analysis>
#>   input rows: 336
#>   validation errors: 0
#>   validation warnings: 0
#>   classified rows: 336
#>   summary rows: 56
#>   consensus rows: 56
#>   action-plan rows: 62
#>   grouping: site_id, timepoint
#>   total-score calculation: not performed
head(analysis$summary)
#>   site_id timepoint item_id n_rows_input n_rows_eligible n_rows_excluded
#> 1  SITE_A  planning       1            6               6               0
#> 2  SITE_A  planning       2            6               6               0
#> 3  SITE_A  planning       3            6               6               0
#> 4  SITE_A  planning       4            6               6               0
#> 5  SITE_A  planning       5            6               6               0
#> 6  SITE_A  planning       6            6               6               0
#>   n_respondents n_valid_direction n_complete_class n_barrier n_neutral
#> 1             6                 6                6         0         0
#> 2             6                 6                6         0         0
#> 3             6                 6                6         1         4
#> 4             6                 6                6         0         1
#> 5             6                 6                6         0         1
#> 6             6                 6                6         0         6
#>   n_facilitator n_strong_barrier n_weak_barrier n_barrier_effect_missing
#> 1             6                0              0                        0
#> 2             6                0              0                        0
#> 3             1                1              0                        0
#> 4             5                0              0                        0
#> 5             5                0              0                        0
#> 6             0                0              0                        0
#>   n_weak_facilitator n_strong_facilitator n_facilitator_effect_missing
#> 1                  5                    1                            0
#> 2                  4                    2                            0
#> 3                  1                    0                            0
#> 4                  4                    1                            0
#> 5                  4                    1                            0
#> 6                  0                    0                            0
#>   n_invalid_or_missing      modal_class mean_display_code median_display_code
#> 1                    0 weak_facilitator         1.1666667                   1
#> 2                    0 weak_facilitator         1.3333333                   1
#> 3                    0          neutral        -0.1666667                   0
#> 4                    0 weak_facilitator         1.0000000                   1
#> 5                    0 weak_facilitator         1.0000000                   1
#> 6                    0          neutral         0.0000000                   0
#>   pct_barrier pct_neutral pct_facilitator pct_strong_barrier pct_weak_barrier
#> 1   0.0000000   0.0000000       1.0000000          0.0000000                0
#> 2   0.0000000   0.0000000       1.0000000          0.0000000                0
#> 3   0.1666667   0.6666667       0.1666667          0.1666667                0
#> 4   0.0000000   0.1666667       0.8333333          0.0000000                0
#> 5   0.0000000   0.1666667       0.8333333          0.0000000                0
#> 6   0.0000000   1.0000000       0.0000000          0.0000000                0
#>   pct_neutral_complete pct_strong_facilitator pct_weak_facilitator
#> 1            0.0000000              0.1666667            0.8333333
#> 2            0.0000000              0.3333333            0.6666667
#> 3            0.6666667              0.0000000            0.1666667
#> 4            0.1666667              0.1666667            0.6666667
#> 5            0.1666667              0.1666667            0.6666667
#> 6            1.0000000              0.0000000            0.0000000
#>   pct_effect_missing modal_class_n modal_class_share           item_key
#> 1                  0             5         0.8333333      patient_needs
#> 2                  0             4         0.6666667     communications
#> 3                  0             4         0.6666667      data_tracking
#> 4                  0             4         0.6666667   leadership_goals
#> 5                  0             4         0.6666667   clinician_values
#> 6                  0             6         1.0000000 clinical_processes
#>                                                                                                     item_text
#> 1 People here regularly seek to understand the needs of patients and make changes to better meet those needs.
#> 2                                 I have open lines of communication with everyone needed to make the change.
#> 3                                                    I have access to data to help track changes in outcomes.
#> 4                                                                The change is aligned with leadership goals.
#> 5                                                                The change is aligned with clinician values.
#> 6                                                  The change is compatible with existing clinical processes.
#>   cfir_original_domain   cfir_original_construct cfir_2022_domain
#> 1        Outer Setting Patient Needs & Resources    Inner Setting
#> 2        Inner Setting Networks & Communications    Inner Setting
#> 3              Process   Reflecting & Evaluating          Process
#> 4        Inner Setting          Goals & Feedback    Inner Setting
#> 5        Inner Setting             Compatibility      Individuals
#> 6        Inner Setting             Compatibility    Inner Setting
#>       cfir_2022_subdomain               cfir_2022_construct
#> 1                    <NA>   Culture: Recipient-Centeredness
#> 2                    <NA>                    Communications
#> 3                    <NA>           Reflecting & Evaluating
#> 4                    <NA>                 Mission Alignment
#> 5 Roles & Characteristics Innovation Deliverers: Capability
#> 6                    <NA>                     Compatibility
#>   cfir_2022_secondary_construct           cfir_2022_construct_all
#> 1                          <NA>   Culture: Recipient-Centeredness
#> 2                          <NA>                    Communications
#> 3                          <NA>           Reflecting & Evaluating
#> 4                          <NA>                 Mission Alignment
#> 5                          <NA> Innovation Deliverers: Capability
#> 6                          <NA>                     Compatibility
#>   cfir_2022_mapping_count
#> 1                       1
#> 2                       1
#> 3                       1
#> 4                       1
#> 5                       1
#> 6                       1
#>                                                                                                                                    cfir_2022_mapping_note
#> 1                                                                                   One primary updated-CFIR construct per the article main-text mapping.
#> 2                                                                                   One primary updated-CFIR construct per the article main-text mapping.
#> 3                                                                                   One primary updated-CFIR construct per the article main-text mapping.
#> 4                                                                                   One primary updated-CFIR construct per the article main-text mapping.
#> 5 The article main-text list uses "Innovation Deliverers: Capability"; Supplementary Table S3 uses the singular label "Innovation Deliverer: Capability".
#> 6                                                                                   One primary updated-CFIR construct per the article main-text mapping.
#>   suppressed
#> 1      FALSE
#> 2      FALSE
#> 3      FALSE
#> 4      FALSE
#> 5      FALSE
#> 6      FALSE
```
