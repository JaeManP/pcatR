# Classify pCAT responses

Combines direction and effect responses into strong barrier, weak
barrier, neutral, weak facilitator, and strong facilitator categories.
It retains explicit states for invalid responses and missing effect
responses.

## Usage

``` r
pcat_classify(
  data,
  validation_action = c("none", "warn", "error"),
  attach_items = TRUE
)
```

## Arguments

- data:

  Long-format response data or a `pcat_validation` object.

- validation_action:

  Condition behavior used when raw data must first be validated.

- attach_items:

  Logical; attach item wording and CFIR metadata.

## Details

Strength categories are assigned only when both direction and effect
validation are valid. A neutral row with an invalid effect remains
directionally neutral but has an invalid strength and no complete
five-category classification.

The numeric `pcat_display_code` ranges from -2 to +2 and is supplied
only for descriptive plotting and transition displays. It is not a
validated scale score and should not be summed into an overall pCAT
score.

## Value

A data frame of class `pcat_classified`.

## Examples

``` r
classified <- pcat_classify(pcat_example_data())
head(classified)
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
#>     pcat_side     pcat_strength       pcat_class      pcat_class5
#> 1 facilitator weak_or_no_effect weak_facilitator weak_facilitator
#> 2 facilitator weak_or_no_effect weak_facilitator weak_facilitator
#> 3     neutral    not_applicable          neutral          neutral
#> 4 facilitator weak_or_no_effect weak_facilitator weak_facilitator
#> 5     neutral    not_applicable          neutral          neutral
#> 6     neutral    not_applicable          neutral          neutral
#>   pcat_display_code pcat_direction_code pcat_is_barrier pcat_is_facilitator
#> 1                 1                   1           FALSE                TRUE
#> 2                 1                   1           FALSE                TRUE
#> 3                 0                   0           FALSE               FALSE
#> 4                 1                   1           FALSE                TRUE
#> 5                 0                   0           FALSE               FALSE
#> 6                 0                   0           FALSE               FALSE
#>   pcat_record_eligible pcat_record_exclusion           item_key
#> 1                 TRUE                  <NA>      patient_needs
#> 2                 TRUE                  <NA>     communications
#> 3                 TRUE                  <NA>      data_tracking
#> 4                 TRUE                  <NA>   leadership_goals
#> 5                 TRUE                  <NA>   clinician_values
#> 6                 TRUE                  <NA> clinical_processes
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
#>           instrument_version      instrument_source_doi
#> 1 pCAT 14-item final version 10.1186/s43058-022-00380-5
#> 2 pCAT 14-item final version 10.1186/s43058-022-00380-5
#> 3 pCAT 14-item final version 10.1186/s43058-022-00380-5
#> 4 pCAT 14-item final version 10.1186/s43058-022-00380-5
#> 5 pCAT 14-item final version 10.1186/s43058-022-00380-5
#> 6 pCAT 14-item final version 10.1186/s43058-022-00380-5
#>           mapping_source_doi content_license
#> 1 10.1186/s43058-026-00956-5       CC BY 4.0
#> 2 10.1186/s43058-026-00956-5       CC BY 4.0
#> 3 10.1186/s43058-026-00956-5       CC BY 4.0
#> 4 10.1186/s43058-026-00956-5       CC BY 4.0
#> 5 10.1186/s43058-026-00956-5       CC BY 4.0
#> 6 10.1186/s43058-026-00956-5       CC BY 4.0
```
