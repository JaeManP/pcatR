# Interpretation, privacy, and reporting

## Item-level interpretation

`pcatR` classifies complete responses as strong barrier, weak barrier,
neutral, weak facilitator, or strong facilitator. The
`pcat_display_code` from -2 to +2 supports plotting and within-item
transition descriptions only. Do not sum it across items or describe it
as a validated scale.

## Agreement and polarization

``` r

classified <- pcat_classify(pcat_example_data())
summary <- pcat_summarise(
  classified,
  group_vars = c("site_id", "timepoint")
)
consensus <- pcat_consensus(summary)
head(consensus[c(
  "site_id", "timepoint", "item_id", "dominant_side",
  "agreement_share", "polarized", "normalized_entropy", "consensus_label"
)])
#>   site_id timepoint item_id dominant_side agreement_share polarized
#> 1  SITE_A  planning       1   facilitator       1.0000000     FALSE
#> 2  SITE_A  planning       2   facilitator       1.0000000     FALSE
#> 3  SITE_A  planning       3       neutral       0.6666667     FALSE
#> 4  SITE_A  planning       4   facilitator       0.8333333     FALSE
#> 5  SITE_A  planning       5   facilitator       0.8333333     FALSE
#> 6  SITE_A  planning       6       neutral       1.0000000     FALSE
#>   normalized_entropy       consensus_label
#> 1          0.0000000 consensus_facilitator
#> 2          0.0000000 consensus_facilitator
#> 3          0.7896901     consensus_neutral
#> 4          0.4101185 consensus_facilitator
#> 5          0.4101185 consensus_facilitator
#> 6          0.0000000     consensus_neutral
```

Consensus labels are descriptive decision aids. They depend on
user-visible thresholds and should be interpreted with counts and
response distributions.

## Longitudinal comparison

``` r

change <- pcat_change(
  classified,
  from = "planning",
  to = "mid_implementation"
)
head(change[c(
  "respondent_id", "item_id", "from_pcat_class5", "to_pcat_class5",
  "delta_display_code", "transition"
)])
#>   respondent_id item_id from_pcat_class5   to_pcat_class5 delta_display_code
#> 1          R001       1 weak_facilitator          neutral                 -1
#> 2          R001       2 weak_facilitator weak_facilitator                  0
#> 3          R001       3          neutral          neutral                  0
#> 4          R001       4 weak_facilitator weak_facilitator                  0
#> 5          R001       5          neutral weak_facilitator                  1
#> 6          R001       6          neutral          neutral                  0
#>            transition
#> 1      toward_barrier
#> 2      no_code_change
#> 3      no_code_change
#> 4      no_code_change
#> 5 toward_facilitation
#> 6      no_code_change
```

These paired transitions describe ordered category movement. They are
not causal effects and the display-code differences are not
interval-scale change scores.

## Privacy and suppression

Use coded identifiers and review free-text comments for sensitive
content. Respondent heatmaps can reveal individual patterns and should
not be shared for small or identifiable teams. Summary suppression is
available:

``` r

suppressed <- pcat_summarise(
  classified,
  group_vars = c("site_id", "timepoint"),
  suppress_below = 5
)
head(suppressed)
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

Suppression affects the returned summary table only. It does not
transform or de-identify source data, classified responses, heatmaps, or
profile PDFs.

## Reporting checklist

Report the implementation effort assessed, assessment timing, respondent
roles, valid denominators, missing effects, grouping variables,
consensus thresholds, suppression rule, mapping version, and software
version. Describe action-plan strategies as locally reviewed candidates
rather than algorithmically selected recommendations.
