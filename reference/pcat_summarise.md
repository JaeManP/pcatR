# Summarize, compare, and plan from pCAT data

Creates item-level summaries, team agreement and disagreement
diagnostics, paired longitudinal transitions, and barrier-focused
action-plan tables.

## Usage

``` r
pcat_summarise(
  data,
  group_vars = NULL,
  respondent_id = "respondent_id",
  suppress_below = NULL
)

pcat_consensus(
  data,
  group_vars = NULL,
  agreement_threshold = 0.6,
  polarization_min = 0.2,
  minimum_n = 2L
)

pcat_change(
  data,
  timepoint = "timepoint",
  from,
  to,
  id_cols = NULL
)

pcat_action_plan(
  data,
  group_vars = NULL,
  barrier_threshold = 0.5,
  strong_barrier_threshold = 0.2,
  include_strategy_candidates = TRUE,
  include_approximate = FALSE
)
```

## Arguments

- data:

  Raw, validated, classified, or previously summarized pCAT data, as
  appropriate for the function.

- group_vars:

  Optional character vector of grouping columns such as site and
  timepoint.

- respondent_id:

  Respondent identifier column name.

- suppress_below:

  Optional positive minimum respondent count. Numerical summary measures
  below it are replaced with missing values and `suppressed` is set to
  `TRUE`.

- agreement_threshold:

  Minimum dominant-side share used for a consensus label.

- polarization_min:

  Minimum barrier and facilitator shares required to label an item
  polarized.

- minimum_n:

  Minimum number of valid direction responses.

- timepoint:

  Timepoint column name.

- from, to:

  Earlier and later timepoint values.

- id_cols:

  Columns identifying paired respondent-item records.

- barrier_threshold:

  Minimum barrier prevalence for action-plan inclusion.

- strong_barrier_threshold:

  Minimum strong-barrier prevalence for action-plan inclusion.

- include_strategy_candidates:

  Logical; join source-derived candidate ERIC strategies where a direct
  construct link is available.

- include_approximate:

  Logical; include the non-identical Relative Priority to Relative
  Advantage approximation.

## Details

Directional percentages (`pct_barrier`, `pct_neutral`,
`pct_facilitator`, and `pct_effect_missing`) use `n_valid_direction`.
Five-category strength percentages use `n_complete_class`, because
barrier and facilitator responses require a nonmissing effect to be
fully classified. Report both denominators when they differ.

Means, medians, and change values based on `pcat_display_code` are
strictly descriptive. Candidate strategies require local stakeholder
review and are not automatic prescriptions. Small-cell suppression
applies only to the returned summary table and does not de-identify
source or classified data.

## Value

A data frame with a function-specific class and documented denominator
attributes where applicable.

## Examples

``` r
classified <- pcat_classify(pcat_example_data())
summary <- pcat_summarise(
  classified,
  group_vars = c("site_id", "timepoint")
)
pcat_consensus(summary)
#>    site_id          timepoint item_id n_rows_input n_rows_eligible
#> 1   SITE_A           planning       1            6               6
#> 2   SITE_A           planning       2            6               6
#> 3   SITE_A           planning       3            6               6
#> 4   SITE_A           planning       4            6               6
#> 5   SITE_A           planning       5            6               6
#> 6   SITE_A           planning       6            6               6
#> 7   SITE_A           planning       7            6               6
#> 8   SITE_A           planning       8            6               6
#> 9   SITE_A           planning       9            6               6
#> 10  SITE_A           planning      10            6               6
#> 11  SITE_A           planning      11            6               6
#> 12  SITE_A           planning      12            6               6
#> 13  SITE_A           planning      13            6               6
#> 14  SITE_A           planning      14            6               6
#> 15  SITE_A mid_implementation       1            6               6
#> 16  SITE_A mid_implementation       2            6               6
#> 17  SITE_A mid_implementation       3            6               6
#> 18  SITE_A mid_implementation       4            6               6
#> 19  SITE_A mid_implementation       5            6               6
#> 20  SITE_A mid_implementation       6            6               6
#> 21  SITE_A mid_implementation       7            6               6
#> 22  SITE_A mid_implementation       8            6               6
#> 23  SITE_A mid_implementation       9            6               6
#> 24  SITE_A mid_implementation      10            6               6
#> 25  SITE_A mid_implementation      11            6               6
#> 26  SITE_A mid_implementation      12            6               6
#> 27  SITE_A mid_implementation      13            6               6
#> 28  SITE_A mid_implementation      14            6               6
#> 29  SITE_B           planning       1            6               6
#> 30  SITE_B           planning       2            6               6
#> 31  SITE_B           planning       3            6               6
#> 32  SITE_B           planning       4            6               6
#> 33  SITE_B           planning       5            6               6
#> 34  SITE_B           planning       6            6               6
#> 35  SITE_B           planning       7            6               6
#> 36  SITE_B           planning       8            6               6
#> 37  SITE_B           planning       9            6               6
#> 38  SITE_B           planning      10            6               6
#> 39  SITE_B           planning      11            6               6
#> 40  SITE_B           planning      12            6               6
#> 41  SITE_B           planning      13            6               6
#> 42  SITE_B           planning      14            6               6
#> 43  SITE_B mid_implementation       1            6               6
#> 44  SITE_B mid_implementation       2            6               6
#> 45  SITE_B mid_implementation       3            6               6
#> 46  SITE_B mid_implementation       4            6               6
#> 47  SITE_B mid_implementation       5            6               6
#> 48  SITE_B mid_implementation       6            6               6
#> 49  SITE_B mid_implementation       7            6               6
#> 50  SITE_B mid_implementation       8            6               6
#> 51  SITE_B mid_implementation       9            6               6
#> 52  SITE_B mid_implementation      10            6               6
#> 53  SITE_B mid_implementation      11            6               6
#> 54  SITE_B mid_implementation      12            6               6
#> 55  SITE_B mid_implementation      13            6               6
#> 56  SITE_B mid_implementation      14            6               6
#>    n_rows_excluded n_respondents n_valid_direction n_complete_class n_barrier
#> 1                0             6                 6                6         0
#> 2                0             6                 6                6         0
#> 3                0             6                 6                6         1
#> 4                0             6                 6                6         0
#> 5                0             6                 6                6         0
#> 6                0             6                 6                6         0
#> 7                0             6                 6                6         5
#> 8                0             6                 6                6         5
#> 9                0             6                 6                6         5
#> 10               0             6                 6                6         6
#> 11               0             6                 6                6         0
#> 12               0             6                 6                6         0
#> 13               0             6                 6                6         0
#> 14               0             6                 6                6         1
#> 15               0             6                 6                6         0
#> 16               0             6                 6                6         0
#> 17               0             6                 6                6         0
#> 18               0             6                 6                6         0
#> 19               0             6                 6                6         0
#> 20               0             6                 6                6         1
#> 21               0             6                 6                6         2
#> 22               0             6                 6                6         2
#> 23               0             6                 6                6         2
#> 24               0             6                 6                6         1
#> 25               0             6                 6                6         1
#> 26               0             6                 6                6         0
#> 27               0             6                 6                6         0
#> 28               0             6                 6                6         0
#> 29               0             6                 6                6         0
#> 30               0             6                 6                6         0
#> 31               0             6                 6                6         6
#> 32               0             6                 6                6         0
#> 33               0             6                 6                6         0
#> 34               0             6                 6                6         1
#> 35               0             6                 6                6         6
#> 36               0             6                 6                6         6
#> 37               0             6                 6                6         5
#> 38               0             6                 6                6         5
#> 39               0             6                 6                6         1
#> 40               0             6                 6                6         0
#> 41               0             6                 6                6         6
#> 42               0             6                 6                6         6
#> 43               0             6                 6                6         0
#> 44               0             6                 6                6         0
#> 45               0             6                 6                6         6
#> 46               0             6                 6                6         0
#> 47               0             6                 6                6         0
#> 48               0             6                 6                6         0
#> 49               0             6                 6                6         1
#> 50               0             6                 6                6         3
#> 51               0             6                 6                6         3
#> 52               0             6                 6                6         2
#> 53               0             6                 6                6         0
#> 54               0             6                 6                6         0
#> 55               0             6                 6                6         3
#> 56               0             6                 6                6         3
#>    n_neutral n_facilitator n_strong_barrier n_weak_barrier
#> 1          0             6                0              0
#> 2          0             6                0              0
#> 3          4             1                1              0
#> 4          1             5                0              0
#> 5          1             5                0              0
#> 6          6             0                0              0
#> 7          1             0                5              0
#> 8          1             0                5              0
#> 9          1             0                5              0
#> 10         0             0                6              0
#> 11         6             0                0              0
#> 12         0             6                0              0
#> 13         5             1                0              0
#> 14         4             1                1              0
#> 15         1             5                0              0
#> 16         0             6                0              0
#> 17         5             1                0              0
#> 18         1             5                0              0
#> 19         1             5                0              0
#> 20         5             0                1              0
#> 21         4             0                2              0
#> 22         3             1                2              0
#> 23         3             1                2              0
#> 24         5             0                1              0
#> 25         5             0                0              1
#> 26         1             5                0              0
#> 27         2             4                0              0
#> 28         2             4                0              0
#> 29         1             5                0              0
#> 30         1             5                0              0
#> 31         0             0                1              5
#> 32         0             6                0              0
#> 33         1             5                0              0
#> 34         4             1                1              0
#> 35         0             0                6              0
#> 36         0             0                6              0
#> 37         1             0                5              0
#> 38         1             0                5              0
#> 39         4             1                0              1
#> 40         1             5                0              0
#> 41         0             0                6              0
#> 42         0             0                6              0
#> 43         1             5                0              0
#> 44         1             5                0              0
#> 45         0             0                1              5
#> 46         0             6                0              0
#> 47         0             6                0              0
#> 48         5             1                0              0
#> 49         5             0                1              0
#> 50         3             0                3              0
#> 51         3             0                3              0
#> 52         4             0                2              0
#> 53         5             1                0              0
#> 54         1             5                0              0
#> 55         2             1                3              0
#> 56         3             0                3              0
#>    n_barrier_effect_missing n_weak_facilitator n_strong_facilitator
#> 1                         0                  5                    1
#> 2                         0                  4                    2
#> 3                         0                  1                    0
#> 4                         0                  4                    1
#> 5                         0                  4                    1
#> 6                         0                  0                    0
#> 7                         0                  0                    0
#> 8                         0                  0                    0
#> 9                         0                  0                    0
#> 10                        0                  0                    0
#> 11                        0                  0                    0
#> 12                        0                  0                    6
#> 13                        0                  0                    1
#> 14                        0                  0                    1
#> 15                        0                  4                    1
#> 16                        0                  4                    2
#> 17                        0                  0                    1
#> 18                        0                  4                    1
#> 19                        0                  4                    1
#> 20                        0                  0                    0
#> 21                        0                  0                    0
#> 22                        0                  0                    1
#> 23                        0                  0                    1
#> 24                        0                  0                    0
#> 25                        0                  0                    0
#> 26                        0                  0                    5
#> 27                        0                  0                    4
#> 28                        0                  0                    4
#> 29                        0                  3                    2
#> 30                        0                  4                    1
#> 31                        0                  0                    0
#> 32                        0                  4                    2
#> 33                        0                  3                    2
#> 34                        0                  1                    0
#> 35                        0                  0                    0
#> 36                        0                  0                    0
#> 37                        0                  0                    0
#> 38                        0                  0                    0
#> 39                        0                  1                    0
#> 40                        0                  0                    5
#> 41                        0                  0                    0
#> 42                        0                  0                    0
#> 43                        0                  3                    2
#> 44                        0                  5                    0
#> 45                        0                  0                    0
#> 46                        0                  4                    2
#> 47                        0                  4                    2
#> 48                        0                  0                    1
#> 49                        0                  0                    0
#> 50                        0                  0                    0
#> 51                        0                  0                    0
#> 52                        0                  0                    0
#> 53                        0                  1                    0
#> 54                        0                  0                    5
#> 55                        0                  0                    1
#> 56                        0                  0                    0
#>    n_facilitator_effect_missing n_invalid_or_missing        modal_class
#> 1                             0                    0   weak_facilitator
#> 2                             0                    0   weak_facilitator
#> 3                             0                    0            neutral
#> 4                             0                    0   weak_facilitator
#> 5                             0                    0   weak_facilitator
#> 6                             0                    0            neutral
#> 7                             0                    0     strong_barrier
#> 8                             0                    0     strong_barrier
#> 9                             0                    0     strong_barrier
#> 10                            0                    0     strong_barrier
#> 11                            0                    0            neutral
#> 12                            0                    0 strong_facilitator
#> 13                            0                    0            neutral
#> 14                            0                    0            neutral
#> 15                            0                    0   weak_facilitator
#> 16                            0                    0   weak_facilitator
#> 17                            0                    0            neutral
#> 18                            0                    0   weak_facilitator
#> 19                            0                    0   weak_facilitator
#> 20                            0                    0            neutral
#> 21                            0                    0            neutral
#> 22                            0                    0            neutral
#> 23                            0                    0            neutral
#> 24                            0                    0            neutral
#> 25                            0                    0            neutral
#> 26                            0                    0 strong_facilitator
#> 27                            0                    0 strong_facilitator
#> 28                            0                    0 strong_facilitator
#> 29                            0                    0   weak_facilitator
#> 30                            0                    0   weak_facilitator
#> 31                            0                    0       weak_barrier
#> 32                            0                    0   weak_facilitator
#> 33                            0                    0   weak_facilitator
#> 34                            0                    0            neutral
#> 35                            0                    0     strong_barrier
#> 36                            0                    0     strong_barrier
#> 37                            0                    0     strong_barrier
#> 38                            0                    0     strong_barrier
#> 39                            0                    0            neutral
#> 40                            0                    0 strong_facilitator
#> 41                            0                    0     strong_barrier
#> 42                            0                    0     strong_barrier
#> 43                            0                    0   weak_facilitator
#> 44                            0                    0   weak_facilitator
#> 45                            0                    0       weak_barrier
#> 46                            0                    0   weak_facilitator
#> 47                            0                    0   weak_facilitator
#> 48                            0                    0            neutral
#> 49                            0                    0            neutral
#> 50                            0                    0                tie
#> 51                            0                    0                tie
#> 52                            0                    0            neutral
#> 53                            0                    0            neutral
#> 54                            0                    0 strong_facilitator
#> 55                            0                    0     strong_barrier
#> 56                            0                    0                tie
#>    mean_display_code median_display_code pct_barrier pct_neutral
#> 1          1.1666667                   1   0.0000000   0.0000000
#> 2          1.3333333                   1   0.0000000   0.0000000
#> 3         -0.1666667                   0   0.1666667   0.6666667
#> 4          1.0000000                   1   0.0000000   0.1666667
#> 5          1.0000000                   1   0.0000000   0.1666667
#> 6          0.0000000                   0   0.0000000   1.0000000
#> 7         -1.6666667                  -2   0.8333333   0.1666667
#> 8         -1.6666667                  -2   0.8333333   0.1666667
#> 9         -1.6666667                  -2   0.8333333   0.1666667
#> 10        -2.0000000                  -2   1.0000000   0.0000000
#> 11         0.0000000                   0   0.0000000   1.0000000
#> 12         2.0000000                   2   0.0000000   0.0000000
#> 13         0.3333333                   0   0.0000000   0.8333333
#> 14         0.0000000                   0   0.1666667   0.6666667
#> 15         1.0000000                   1   0.0000000   0.1666667
#> 16         1.3333333                   1   0.0000000   0.0000000
#> 17         0.3333333                   0   0.0000000   0.8333333
#> 18         1.0000000                   1   0.0000000   0.1666667
#> 19         1.0000000                   1   0.0000000   0.1666667
#> 20        -0.3333333                   0   0.1666667   0.8333333
#> 21        -0.6666667                   0   0.3333333   0.6666667
#> 22        -0.3333333                   0   0.3333333   0.5000000
#> 23        -0.3333333                   0   0.3333333   0.5000000
#> 24        -0.3333333                   0   0.1666667   0.8333333
#> 25        -0.1666667                   0   0.1666667   0.8333333
#> 26         1.6666667                   2   0.0000000   0.1666667
#> 27         1.3333333                   2   0.0000000   0.3333333
#> 28         1.3333333                   2   0.0000000   0.3333333
#> 29         1.1666667                   1   0.0000000   0.1666667
#> 30         1.0000000                   1   0.0000000   0.1666667
#> 31        -1.1666667                  -1   1.0000000   0.0000000
#> 32         1.3333333                   1   0.0000000   0.0000000
#> 33         1.1666667                   1   0.0000000   0.1666667
#> 34        -0.1666667                   0   0.1666667   0.6666667
#> 35        -2.0000000                  -2   1.0000000   0.0000000
#> 36        -2.0000000                  -2   1.0000000   0.0000000
#> 37        -1.6666667                  -2   0.8333333   0.1666667
#> 38        -1.6666667                  -2   0.8333333   0.1666667
#> 39         0.0000000                   0   0.1666667   0.6666667
#> 40         1.6666667                   2   0.0000000   0.1666667
#> 41        -2.0000000                  -2   1.0000000   0.0000000
#> 42        -2.0000000                  -2   1.0000000   0.0000000
#> 43         1.1666667                   1   0.0000000   0.1666667
#> 44         0.8333333                   1   0.0000000   0.1666667
#> 45        -1.1666667                  -1   1.0000000   0.0000000
#> 46         1.3333333                   1   0.0000000   0.0000000
#> 47         1.3333333                   1   0.0000000   0.0000000
#> 48         0.3333333                   0   0.0000000   0.8333333
#> 49        -0.3333333                   0   0.1666667   0.8333333
#> 50        -1.0000000                  -1   0.5000000   0.5000000
#> 51        -1.0000000                  -1   0.5000000   0.5000000
#> 52        -0.6666667                   0   0.3333333   0.6666667
#> 53         0.1666667                   0   0.0000000   0.8333333
#> 54         1.6666667                   2   0.0000000   0.1666667
#> 55        -0.6666667                  -1   0.5000000   0.3333333
#> 56        -1.0000000                  -1   0.5000000   0.5000000
#>    pct_facilitator pct_strong_barrier pct_weak_barrier pct_neutral_complete
#> 1        1.0000000          0.0000000        0.0000000            0.0000000
#> 2        1.0000000          0.0000000        0.0000000            0.0000000
#> 3        0.1666667          0.1666667        0.0000000            0.6666667
#> 4        0.8333333          0.0000000        0.0000000            0.1666667
#> 5        0.8333333          0.0000000        0.0000000            0.1666667
#> 6        0.0000000          0.0000000        0.0000000            1.0000000
#> 7        0.0000000          0.8333333        0.0000000            0.1666667
#> 8        0.0000000          0.8333333        0.0000000            0.1666667
#> 9        0.0000000          0.8333333        0.0000000            0.1666667
#> 10       0.0000000          1.0000000        0.0000000            0.0000000
#> 11       0.0000000          0.0000000        0.0000000            1.0000000
#> 12       1.0000000          0.0000000        0.0000000            0.0000000
#> 13       0.1666667          0.0000000        0.0000000            0.8333333
#> 14       0.1666667          0.1666667        0.0000000            0.6666667
#> 15       0.8333333          0.0000000        0.0000000            0.1666667
#> 16       1.0000000          0.0000000        0.0000000            0.0000000
#> 17       0.1666667          0.0000000        0.0000000            0.8333333
#> 18       0.8333333          0.0000000        0.0000000            0.1666667
#> 19       0.8333333          0.0000000        0.0000000            0.1666667
#> 20       0.0000000          0.1666667        0.0000000            0.8333333
#> 21       0.0000000          0.3333333        0.0000000            0.6666667
#> 22       0.1666667          0.3333333        0.0000000            0.5000000
#> 23       0.1666667          0.3333333        0.0000000            0.5000000
#> 24       0.0000000          0.1666667        0.0000000            0.8333333
#> 25       0.0000000          0.0000000        0.1666667            0.8333333
#> 26       0.8333333          0.0000000        0.0000000            0.1666667
#> 27       0.6666667          0.0000000        0.0000000            0.3333333
#> 28       0.6666667          0.0000000        0.0000000            0.3333333
#> 29       0.8333333          0.0000000        0.0000000            0.1666667
#> 30       0.8333333          0.0000000        0.0000000            0.1666667
#> 31       0.0000000          0.1666667        0.8333333            0.0000000
#> 32       1.0000000          0.0000000        0.0000000            0.0000000
#> 33       0.8333333          0.0000000        0.0000000            0.1666667
#> 34       0.1666667          0.1666667        0.0000000            0.6666667
#> 35       0.0000000          1.0000000        0.0000000            0.0000000
#> 36       0.0000000          1.0000000        0.0000000            0.0000000
#> 37       0.0000000          0.8333333        0.0000000            0.1666667
#> 38       0.0000000          0.8333333        0.0000000            0.1666667
#> 39       0.1666667          0.0000000        0.1666667            0.6666667
#> 40       0.8333333          0.0000000        0.0000000            0.1666667
#> 41       0.0000000          1.0000000        0.0000000            0.0000000
#> 42       0.0000000          1.0000000        0.0000000            0.0000000
#> 43       0.8333333          0.0000000        0.0000000            0.1666667
#> 44       0.8333333          0.0000000        0.0000000            0.1666667
#> 45       0.0000000          0.1666667        0.8333333            0.0000000
#> 46       1.0000000          0.0000000        0.0000000            0.0000000
#> 47       1.0000000          0.0000000        0.0000000            0.0000000
#> 48       0.1666667          0.0000000        0.0000000            0.8333333
#> 49       0.0000000          0.1666667        0.0000000            0.8333333
#> 50       0.0000000          0.5000000        0.0000000            0.5000000
#> 51       0.0000000          0.5000000        0.0000000            0.5000000
#> 52       0.0000000          0.3333333        0.0000000            0.6666667
#> 53       0.1666667          0.0000000        0.0000000            0.8333333
#> 54       0.8333333          0.0000000        0.0000000            0.1666667
#> 55       0.1666667          0.5000000        0.0000000            0.3333333
#> 56       0.0000000          0.5000000        0.0000000            0.5000000
#>    pct_strong_facilitator pct_weak_facilitator pct_effect_missing modal_class_n
#> 1               0.1666667            0.8333333                  0             5
#> 2               0.3333333            0.6666667                  0             4
#> 3               0.0000000            0.1666667                  0             4
#> 4               0.1666667            0.6666667                  0             4
#> 5               0.1666667            0.6666667                  0             4
#> 6               0.0000000            0.0000000                  0             6
#> 7               0.0000000            0.0000000                  0             5
#> 8               0.0000000            0.0000000                  0             5
#> 9               0.0000000            0.0000000                  0             5
#> 10              0.0000000            0.0000000                  0             6
#> 11              0.0000000            0.0000000                  0             6
#> 12              1.0000000            0.0000000                  0             6
#> 13              0.1666667            0.0000000                  0             5
#> 14              0.1666667            0.0000000                  0             4
#> 15              0.1666667            0.6666667                  0             4
#> 16              0.3333333            0.6666667                  0             4
#> 17              0.1666667            0.0000000                  0             5
#> 18              0.1666667            0.6666667                  0             4
#> 19              0.1666667            0.6666667                  0             4
#> 20              0.0000000            0.0000000                  0             5
#> 21              0.0000000            0.0000000                  0             4
#> 22              0.1666667            0.0000000                  0             3
#> 23              0.1666667            0.0000000                  0             3
#> 24              0.0000000            0.0000000                  0             5
#> 25              0.0000000            0.0000000                  0             5
#> 26              0.8333333            0.0000000                  0             5
#> 27              0.6666667            0.0000000                  0             4
#> 28              0.6666667            0.0000000                  0             4
#> 29              0.3333333            0.5000000                  0             3
#> 30              0.1666667            0.6666667                  0             4
#> 31              0.0000000            0.0000000                  0             5
#> 32              0.3333333            0.6666667                  0             4
#> 33              0.3333333            0.5000000                  0             3
#> 34              0.0000000            0.1666667                  0             4
#> 35              0.0000000            0.0000000                  0             6
#> 36              0.0000000            0.0000000                  0             6
#> 37              0.0000000            0.0000000                  0             5
#> 38              0.0000000            0.0000000                  0             5
#> 39              0.0000000            0.1666667                  0             4
#> 40              0.8333333            0.0000000                  0             5
#> 41              0.0000000            0.0000000                  0             6
#> 42              0.0000000            0.0000000                  0             6
#> 43              0.3333333            0.5000000                  0             3
#> 44              0.0000000            0.8333333                  0             5
#> 45              0.0000000            0.0000000                  0             5
#> 46              0.3333333            0.6666667                  0             4
#> 47              0.3333333            0.6666667                  0             4
#> 48              0.1666667            0.0000000                  0             5
#> 49              0.0000000            0.0000000                  0             5
#> 50              0.0000000            0.0000000                  0            NA
#> 51              0.0000000            0.0000000                  0            NA
#> 52              0.0000000            0.0000000                  0             4
#> 53              0.0000000            0.1666667                  0             5
#> 54              0.8333333            0.0000000                  0             5
#> 55              0.1666667            0.0000000                  0             3
#> 56              0.0000000            0.0000000                  0            NA
#>    modal_class_share             item_key
#> 1          0.8333333        patient_needs
#> 2          0.6666667       communications
#> 3          0.6666667        data_tracking
#> 4          0.6666667     leadership_goals
#> 5          0.6666667     clinician_values
#> 6          1.0000000   clinical_processes
#> 7          0.8333333  structures_policies
#> 8          0.8333333                space
#> 9          0.8333333                 time
#> 10         1.0000000      other_resources
#> 11         1.0000000   tension_for_change
#> 12         1.0000000   relative_advantage
#> 13         0.8333333 higher_level_leaders
#> 14         0.6666667      closest_leaders
#> 15         0.6666667        patient_needs
#> 16         0.6666667       communications
#> 17         0.8333333        data_tracking
#> 18         0.6666667     leadership_goals
#> 19         0.6666667     clinician_values
#> 20         0.8333333   clinical_processes
#> 21         0.6666667  structures_policies
#> 22         0.5000000                space
#> 23         0.5000000                 time
#> 24         0.8333333      other_resources
#> 25         0.8333333   tension_for_change
#> 26         0.8333333   relative_advantage
#> 27         0.6666667 higher_level_leaders
#> 28         0.6666667      closest_leaders
#> 29         0.5000000        patient_needs
#> 30         0.6666667       communications
#> 31         0.8333333        data_tracking
#> 32         0.6666667     leadership_goals
#> 33         0.5000000     clinician_values
#> 34         0.6666667   clinical_processes
#> 35         1.0000000  structures_policies
#> 36         1.0000000                space
#> 37         0.8333333                 time
#> 38         0.8333333      other_resources
#> 39         0.6666667   tension_for_change
#> 40         0.8333333   relative_advantage
#> 41         1.0000000 higher_level_leaders
#> 42         1.0000000      closest_leaders
#> 43         0.5000000        patient_needs
#> 44         0.8333333       communications
#> 45         0.8333333        data_tracking
#> 46         0.6666667     leadership_goals
#> 47         0.6666667     clinician_values
#> 48         0.8333333   clinical_processes
#> 49         0.8333333  structures_policies
#> 50                NA                space
#> 51                NA                 time
#> 52         0.6666667      other_resources
#> 53         0.8333333   tension_for_change
#> 54         0.8333333   relative_advantage
#> 55         0.5000000 higher_level_leaders
#> 56                NA      closest_leaders
#>                                                                                                      item_text
#> 1  People here regularly seek to understand the needs of patients and make changes to better meet those needs.
#> 2                                  I have open lines of communication with everyone needed to make the change.
#> 3                                                     I have access to data to help track changes in outcomes.
#> 4                                                                 The change is aligned with leadership goals.
#> 5                                                                 The change is aligned with clinician values.
#> 6                                                   The change is compatible with existing clinical processes.
#> 7                                      The structures and policies in place here enable us to make the change.
#> 8                                                          We have sufficient space to accommodate the change.
#> 9                                                        We have sufficient time dedicated to make the change.
#> 10                           We have other needed resources to make the change (staff, money, supplies, etc.).
#> 11                         People here see the current situation as intolerable and that the change is needed.
#> 12                     People here see the advantage of implementing this change versus an alternative change.
#> 13                  Higher level leaders are committed, involved, and accountable for the planned improvement.
#> 14      Leaders I work with most closely are committed, involved, and accountable for the planned improvement.
#> 15 People here regularly seek to understand the needs of patients and make changes to better meet those needs.
#> 16                                 I have open lines of communication with everyone needed to make the change.
#> 17                                                    I have access to data to help track changes in outcomes.
#> 18                                                                The change is aligned with leadership goals.
#> 19                                                                The change is aligned with clinician values.
#> 20                                                  The change is compatible with existing clinical processes.
#> 21                                     The structures and policies in place here enable us to make the change.
#> 22                                                         We have sufficient space to accommodate the change.
#> 23                                                       We have sufficient time dedicated to make the change.
#> 24                           We have other needed resources to make the change (staff, money, supplies, etc.).
#> 25                         People here see the current situation as intolerable and that the change is needed.
#> 26                     People here see the advantage of implementing this change versus an alternative change.
#> 27                  Higher level leaders are committed, involved, and accountable for the planned improvement.
#> 28      Leaders I work with most closely are committed, involved, and accountable for the planned improvement.
#> 29 People here regularly seek to understand the needs of patients and make changes to better meet those needs.
#> 30                                 I have open lines of communication with everyone needed to make the change.
#> 31                                                    I have access to data to help track changes in outcomes.
#> 32                                                                The change is aligned with leadership goals.
#> 33                                                                The change is aligned with clinician values.
#> 34                                                  The change is compatible with existing clinical processes.
#> 35                                     The structures and policies in place here enable us to make the change.
#> 36                                                         We have sufficient space to accommodate the change.
#> 37                                                       We have sufficient time dedicated to make the change.
#> 38                           We have other needed resources to make the change (staff, money, supplies, etc.).
#> 39                         People here see the current situation as intolerable and that the change is needed.
#> 40                     People here see the advantage of implementing this change versus an alternative change.
#> 41                  Higher level leaders are committed, involved, and accountable for the planned improvement.
#> 42      Leaders I work with most closely are committed, involved, and accountable for the planned improvement.
#> 43 People here regularly seek to understand the needs of patients and make changes to better meet those needs.
#> 44                                 I have open lines of communication with everyone needed to make the change.
#> 45                                                    I have access to data to help track changes in outcomes.
#> 46                                                                The change is aligned with leadership goals.
#> 47                                                                The change is aligned with clinician values.
#> 48                                                  The change is compatible with existing clinical processes.
#> 49                                     The structures and policies in place here enable us to make the change.
#> 50                                                         We have sufficient space to accommodate the change.
#> 51                                                       We have sufficient time dedicated to make the change.
#> 52                           We have other needed resources to make the change (staff, money, supplies, etc.).
#> 53                         People here see the current situation as intolerable and that the change is needed.
#> 54                     People here see the advantage of implementing this change versus an alternative change.
#> 55                  Higher level leaders are committed, involved, and accountable for the planned improvement.
#> 56      Leaders I work with most closely are committed, involved, and accountable for the planned improvement.
#>            cfir_original_domain    cfir_original_construct cfir_2022_domain
#> 1                 Outer Setting  Patient Needs & Resources    Inner Setting
#> 2                 Inner Setting  Networks & Communications    Inner Setting
#> 3                       Process    Reflecting & Evaluating          Process
#> 4                 Inner Setting           Goals & Feedback    Inner Setting
#> 5                 Inner Setting              Compatibility      Individuals
#> 6                 Inner Setting              Compatibility    Inner Setting
#> 7                 Inner Setting Structural Characteristics    Inner Setting
#> 8                 Inner Setting        Available Resources    Inner Setting
#> 9                 Inner Setting        Available Resources      Individuals
#> 10                Inner Setting        Available Resources    Inner Setting
#> 11                Inner Setting         Tension for Change    Inner Setting
#> 12 Intervention Characteristics         Relative Advantage       Innovation
#> 13                Inner Setting      Leadership Engagement      Individuals
#> 14                Inner Setting      Leadership Engagement      Individuals
#> 15                Outer Setting  Patient Needs & Resources    Inner Setting
#> 16                Inner Setting  Networks & Communications    Inner Setting
#> 17                      Process    Reflecting & Evaluating          Process
#> 18                Inner Setting           Goals & Feedback    Inner Setting
#> 19                Inner Setting              Compatibility      Individuals
#> 20                Inner Setting              Compatibility    Inner Setting
#> 21                Inner Setting Structural Characteristics    Inner Setting
#> 22                Inner Setting        Available Resources    Inner Setting
#> 23                Inner Setting        Available Resources      Individuals
#> 24                Inner Setting        Available Resources    Inner Setting
#> 25                Inner Setting         Tension for Change    Inner Setting
#> 26 Intervention Characteristics         Relative Advantage       Innovation
#> 27                Inner Setting      Leadership Engagement      Individuals
#> 28                Inner Setting      Leadership Engagement      Individuals
#> 29                Outer Setting  Patient Needs & Resources    Inner Setting
#> 30                Inner Setting  Networks & Communications    Inner Setting
#> 31                      Process    Reflecting & Evaluating          Process
#> 32                Inner Setting           Goals & Feedback    Inner Setting
#> 33                Inner Setting              Compatibility      Individuals
#> 34                Inner Setting              Compatibility    Inner Setting
#> 35                Inner Setting Structural Characteristics    Inner Setting
#> 36                Inner Setting        Available Resources    Inner Setting
#> 37                Inner Setting        Available Resources      Individuals
#> 38                Inner Setting        Available Resources    Inner Setting
#> 39                Inner Setting         Tension for Change    Inner Setting
#> 40 Intervention Characteristics         Relative Advantage       Innovation
#> 41                Inner Setting      Leadership Engagement      Individuals
#> 42                Inner Setting      Leadership Engagement      Individuals
#> 43                Outer Setting  Patient Needs & Resources    Inner Setting
#> 44                Inner Setting  Networks & Communications    Inner Setting
#> 45                      Process    Reflecting & Evaluating          Process
#> 46                Inner Setting           Goals & Feedback    Inner Setting
#> 47                Inner Setting              Compatibility      Individuals
#> 48                Inner Setting              Compatibility    Inner Setting
#> 49                Inner Setting Structural Characteristics    Inner Setting
#> 50                Inner Setting        Available Resources    Inner Setting
#> 51                Inner Setting        Available Resources      Individuals
#> 52                Inner Setting        Available Resources    Inner Setting
#> 53                Inner Setting         Tension for Change    Inner Setting
#> 54 Intervention Characteristics         Relative Advantage       Innovation
#> 55                Inner Setting      Leadership Engagement      Individuals
#> 56                Inner Setting      Leadership Engagement      Individuals
#>        cfir_2022_subdomain                             cfir_2022_construct
#> 1                     <NA>                 Culture: Recipient-Centeredness
#> 2                     <NA>                                  Communications
#> 3                     <NA>                         Reflecting & Evaluating
#> 4                     <NA>                               Mission Alignment
#> 5  Roles & Characteristics               Innovation Deliverers: Capability
#> 6                     <NA>                                   Compatibility
#> 7                     <NA> Structural Characteristics: Work Infrastructure
#> 8                     <NA>                      Available Resources: Space
#> 9  Roles & Characteristics              Innovation Deliverers: Opportunity
#> 10                    <NA>      Available Resources: Materials & Equipment
#> 11                    <NA>                              Tension for Change
#> 12                    <NA>                   Innovation Relative Advantage
#> 13 Roles & Characteristics                  High-Level Leaders: Motivation
#> 14 Roles & Characteristics                   Mid-Level Leaders: Motivation
#> 15                    <NA>                 Culture: Recipient-Centeredness
#> 16                    <NA>                                  Communications
#> 17                    <NA>                         Reflecting & Evaluating
#> 18                    <NA>                               Mission Alignment
#> 19 Roles & Characteristics               Innovation Deliverers: Capability
#> 20                    <NA>                                   Compatibility
#> 21                    <NA> Structural Characteristics: Work Infrastructure
#> 22                    <NA>                      Available Resources: Space
#> 23 Roles & Characteristics              Innovation Deliverers: Opportunity
#> 24                    <NA>      Available Resources: Materials & Equipment
#> 25                    <NA>                              Tension for Change
#> 26                    <NA>                   Innovation Relative Advantage
#> 27 Roles & Characteristics                  High-Level Leaders: Motivation
#> 28 Roles & Characteristics                   Mid-Level Leaders: Motivation
#> 29                    <NA>                 Culture: Recipient-Centeredness
#> 30                    <NA>                                  Communications
#> 31                    <NA>                         Reflecting & Evaluating
#> 32                    <NA>                               Mission Alignment
#> 33 Roles & Characteristics               Innovation Deliverers: Capability
#> 34                    <NA>                                   Compatibility
#> 35                    <NA> Structural Characteristics: Work Infrastructure
#> 36                    <NA>                      Available Resources: Space
#> 37 Roles & Characteristics              Innovation Deliverers: Opportunity
#> 38                    <NA>      Available Resources: Materials & Equipment
#> 39                    <NA>                              Tension for Change
#> 40                    <NA>                   Innovation Relative Advantage
#> 41 Roles & Characteristics                  High-Level Leaders: Motivation
#> 42 Roles & Characteristics                   Mid-Level Leaders: Motivation
#> 43                    <NA>                 Culture: Recipient-Centeredness
#> 44                    <NA>                                  Communications
#> 45                    <NA>                         Reflecting & Evaluating
#> 46                    <NA>                               Mission Alignment
#> 47 Roles & Characteristics               Innovation Deliverers: Capability
#> 48                    <NA>                                   Compatibility
#> 49                    <NA> Structural Characteristics: Work Infrastructure
#> 50                    <NA>                      Available Resources: Space
#> 51 Roles & Characteristics              Innovation Deliverers: Opportunity
#> 52                    <NA>      Available Resources: Materials & Equipment
#> 53                    <NA>                              Tension for Change
#> 54                    <NA>                   Innovation Relative Advantage
#> 55 Roles & Characteristics                  High-Level Leaders: Motivation
#> 56 Roles & Characteristics                   Mid-Level Leaders: Motivation
#>    cfir_2022_secondary_construct
#> 1                           <NA>
#> 2                           <NA>
#> 3                           <NA>
#> 4                           <NA>
#> 5                           <NA>
#> 6                           <NA>
#> 7                           <NA>
#> 8                           <NA>
#> 9                           <NA>
#> 10  Available Resources: Funding
#> 11                          <NA>
#> 12                          <NA>
#> 13                          <NA>
#> 14                          <NA>
#> 15                          <NA>
#> 16                          <NA>
#> 17                          <NA>
#> 18                          <NA>
#> 19                          <NA>
#> 20                          <NA>
#> 21                          <NA>
#> 22                          <NA>
#> 23                          <NA>
#> 24  Available Resources: Funding
#> 25                          <NA>
#> 26                          <NA>
#> 27                          <NA>
#> 28                          <NA>
#> 29                          <NA>
#> 30                          <NA>
#> 31                          <NA>
#> 32                          <NA>
#> 33                          <NA>
#> 34                          <NA>
#> 35                          <NA>
#> 36                          <NA>
#> 37                          <NA>
#> 38  Available Resources: Funding
#> 39                          <NA>
#> 40                          <NA>
#> 41                          <NA>
#> 42                          <NA>
#> 43                          <NA>
#> 44                          <NA>
#> 45                          <NA>
#> 46                          <NA>
#> 47                          <NA>
#> 48                          <NA>
#> 49                          <NA>
#> 50                          <NA>
#> 51                          <NA>
#> 52  Available Resources: Funding
#> 53                          <NA>
#> 54                          <NA>
#> 55                          <NA>
#> 56                          <NA>
#>                                                     cfir_2022_construct_all
#> 1                                           Culture: Recipient-Centeredness
#> 2                                                            Communications
#> 3                                                   Reflecting & Evaluating
#> 4                                                         Mission Alignment
#> 5                                         Innovation Deliverers: Capability
#> 6                                                             Compatibility
#> 7                           Structural Characteristics: Work Infrastructure
#> 8                                                Available Resources: Space
#> 9                                        Innovation Deliverers: Opportunity
#> 10 Available Resources: Materials & Equipment; Available Resources: Funding
#> 11                                                       Tension for Change
#> 12                                            Innovation Relative Advantage
#> 13                                           High-Level Leaders: Motivation
#> 14                                            Mid-Level Leaders: Motivation
#> 15                                          Culture: Recipient-Centeredness
#> 16                                                           Communications
#> 17                                                  Reflecting & Evaluating
#> 18                                                        Mission Alignment
#> 19                                        Innovation Deliverers: Capability
#> 20                                                            Compatibility
#> 21                          Structural Characteristics: Work Infrastructure
#> 22                                               Available Resources: Space
#> 23                                       Innovation Deliverers: Opportunity
#> 24 Available Resources: Materials & Equipment; Available Resources: Funding
#> 25                                                       Tension for Change
#> 26                                            Innovation Relative Advantage
#> 27                                           High-Level Leaders: Motivation
#> 28                                            Mid-Level Leaders: Motivation
#> 29                                          Culture: Recipient-Centeredness
#> 30                                                           Communications
#> 31                                                  Reflecting & Evaluating
#> 32                                                        Mission Alignment
#> 33                                        Innovation Deliverers: Capability
#> 34                                                            Compatibility
#> 35                          Structural Characteristics: Work Infrastructure
#> 36                                               Available Resources: Space
#> 37                                       Innovation Deliverers: Opportunity
#> 38 Available Resources: Materials & Equipment; Available Resources: Funding
#> 39                                                       Tension for Change
#> 40                                            Innovation Relative Advantage
#> 41                                           High-Level Leaders: Motivation
#> 42                                            Mid-Level Leaders: Motivation
#> 43                                          Culture: Recipient-Centeredness
#> 44                                                           Communications
#> 45                                                  Reflecting & Evaluating
#> 46                                                        Mission Alignment
#> 47                                        Innovation Deliverers: Capability
#> 48                                                            Compatibility
#> 49                          Structural Characteristics: Work Infrastructure
#> 50                                               Available Resources: Space
#> 51                                       Innovation Deliverers: Opportunity
#> 52 Available Resources: Materials & Equipment; Available Resources: Funding
#> 53                                                       Tension for Change
#> 54                                            Innovation Relative Advantage
#> 55                                           High-Level Leaders: Motivation
#> 56                                            Mid-Level Leaders: Motivation
#>    cfir_2022_mapping_count
#> 1                        1
#> 2                        1
#> 3                        1
#> 4                        1
#> 5                        1
#> 6                        1
#> 7                        1
#> 8                        1
#> 9                        1
#> 10                       2
#> 11                       1
#> 12                       1
#> 13                       1
#> 14                       1
#> 15                       1
#> 16                       1
#> 17                       1
#> 18                       1
#> 19                       1
#> 20                       1
#> 21                       1
#> 22                       1
#> 23                       1
#> 24                       2
#> 25                       1
#> 26                       1
#> 27                       1
#> 28                       1
#> 29                       1
#> 30                       1
#> 31                       1
#> 32                       1
#> 33                       1
#> 34                       1
#> 35                       1
#> 36                       1
#> 37                       1
#> 38                       2
#> 39                       1
#> 40                       1
#> 41                       1
#> 42                       1
#> 43                       1
#> 44                       1
#> 45                       1
#> 46                       1
#> 47                       1
#> 48                       1
#> 49                       1
#> 50                       1
#> 51                       1
#> 52                       2
#> 53                       1
#> 54                       1
#> 55                       1
#> 56                       1
#>                                                                                                                                                                    cfir_2022_mapping_note
#> 1                                                                                                                   One primary updated-CFIR construct per the article main-text mapping.
#> 2                                                                                                                   One primary updated-CFIR construct per the article main-text mapping.
#> 3                                                                                                                   One primary updated-CFIR construct per the article main-text mapping.
#> 4                                                                                                                   One primary updated-CFIR construct per the article main-text mapping.
#> 5                                 The article main-text list uses "Innovation Deliverers: Capability"; Supplementary Table S3 uses the singular label "Innovation Deliverer: Capability".
#> 6                                                                                                                   One primary updated-CFIR construct per the article main-text mapping.
#> 7                                                                                                                   One primary updated-CFIR construct per the article main-text mapping.
#> 8                                                                                                                   One primary updated-CFIR construct per the article main-text mapping.
#> 9                               The article main-text list uses "Innovation Deliverers: Opportunity"; Supplementary Table S3 uses the singular label "Innovation Deliverer: Opportunity".
#> 10 Supplementary Table S3 maps this item to both Available Resources: Materials & Equipment and Funding; the article main-text list of 14 primary constructs names Materials & Equipment.
#> 11                                                                                                                  One primary updated-CFIR construct per the article main-text mapping.
#> 12                                                   The article main-text list uses "Innovation Relative Advantage"; Supplementary Table S3 uses the shorter label "Relative Advantage".
#> 13                                                                                                                  One primary updated-CFIR construct per the article main-text mapping.
#> 14                                                                                                                  One primary updated-CFIR construct per the article main-text mapping.
#> 15                                                                                                                  One primary updated-CFIR construct per the article main-text mapping.
#> 16                                                                                                                  One primary updated-CFIR construct per the article main-text mapping.
#> 17                                                                                                                  One primary updated-CFIR construct per the article main-text mapping.
#> 18                                                                                                                  One primary updated-CFIR construct per the article main-text mapping.
#> 19                                The article main-text list uses "Innovation Deliverers: Capability"; Supplementary Table S3 uses the singular label "Innovation Deliverer: Capability".
#> 20                                                                                                                  One primary updated-CFIR construct per the article main-text mapping.
#> 21                                                                                                                  One primary updated-CFIR construct per the article main-text mapping.
#> 22                                                                                                                  One primary updated-CFIR construct per the article main-text mapping.
#> 23                              The article main-text list uses "Innovation Deliverers: Opportunity"; Supplementary Table S3 uses the singular label "Innovation Deliverer: Opportunity".
#> 24 Supplementary Table S3 maps this item to both Available Resources: Materials & Equipment and Funding; the article main-text list of 14 primary constructs names Materials & Equipment.
#> 25                                                                                                                  One primary updated-CFIR construct per the article main-text mapping.
#> 26                                                   The article main-text list uses "Innovation Relative Advantage"; Supplementary Table S3 uses the shorter label "Relative Advantage".
#> 27                                                                                                                  One primary updated-CFIR construct per the article main-text mapping.
#> 28                                                                                                                  One primary updated-CFIR construct per the article main-text mapping.
#> 29                                                                                                                  One primary updated-CFIR construct per the article main-text mapping.
#> 30                                                                                                                  One primary updated-CFIR construct per the article main-text mapping.
#> 31                                                                                                                  One primary updated-CFIR construct per the article main-text mapping.
#> 32                                                                                                                  One primary updated-CFIR construct per the article main-text mapping.
#> 33                                The article main-text list uses "Innovation Deliverers: Capability"; Supplementary Table S3 uses the singular label "Innovation Deliverer: Capability".
#> 34                                                                                                                  One primary updated-CFIR construct per the article main-text mapping.
#> 35                                                                                                                  One primary updated-CFIR construct per the article main-text mapping.
#> 36                                                                                                                  One primary updated-CFIR construct per the article main-text mapping.
#> 37                              The article main-text list uses "Innovation Deliverers: Opportunity"; Supplementary Table S3 uses the singular label "Innovation Deliverer: Opportunity".
#> 38 Supplementary Table S3 maps this item to both Available Resources: Materials & Equipment and Funding; the article main-text list of 14 primary constructs names Materials & Equipment.
#> 39                                                                                                                  One primary updated-CFIR construct per the article main-text mapping.
#> 40                                                   The article main-text list uses "Innovation Relative Advantage"; Supplementary Table S3 uses the shorter label "Relative Advantage".
#> 41                                                                                                                  One primary updated-CFIR construct per the article main-text mapping.
#> 42                                                                                                                  One primary updated-CFIR construct per the article main-text mapping.
#> 43                                                                                                                  One primary updated-CFIR construct per the article main-text mapping.
#> 44                                                                                                                  One primary updated-CFIR construct per the article main-text mapping.
#> 45                                                                                                                  One primary updated-CFIR construct per the article main-text mapping.
#> 46                                                                                                                  One primary updated-CFIR construct per the article main-text mapping.
#> 47                                The article main-text list uses "Innovation Deliverers: Capability"; Supplementary Table S3 uses the singular label "Innovation Deliverer: Capability".
#> 48                                                                                                                  One primary updated-CFIR construct per the article main-text mapping.
#> 49                                                                                                                  One primary updated-CFIR construct per the article main-text mapping.
#> 50                                                                                                                  One primary updated-CFIR construct per the article main-text mapping.
#> 51                              The article main-text list uses "Innovation Deliverers: Opportunity"; Supplementary Table S3 uses the singular label "Innovation Deliverer: Opportunity".
#> 52 Supplementary Table S3 maps this item to both Available Resources: Materials & Equipment and Funding; the article main-text list of 14 primary constructs names Materials & Equipment.
#> 53                                                                                                                  One primary updated-CFIR construct per the article main-text mapping.
#> 54                                                   The article main-text list uses "Innovation Relative Advantage"; Supplementary Table S3 uses the shorter label "Relative Advantage".
#> 55                                                                                                                  One primary updated-CFIR construct per the article main-text mapping.
#> 56                                                                                                                  One primary updated-CFIR construct per the article main-text mapping.
#>    suppressed agreement_share dominant_side polarized normalized_entropy
#> 1       FALSE       1.0000000   facilitator     FALSE          0.0000000
#> 2       FALSE       1.0000000   facilitator     FALSE          0.0000000
#> 3       FALSE       0.6666667       neutral     FALSE          0.7896901
#> 4       FALSE       0.8333333   facilitator     FALSE          0.4101185
#> 5       FALSE       0.8333333   facilitator     FALSE          0.4101185
#> 6       FALSE       1.0000000       neutral     FALSE          0.0000000
#> 7       FALSE       0.8333333       barrier     FALSE          0.4101185
#> 8       FALSE       0.8333333       barrier     FALSE          0.4101185
#> 9       FALSE       0.8333333       barrier     FALSE          0.4101185
#> 10      FALSE       1.0000000       barrier     FALSE          0.0000000
#> 11      FALSE       1.0000000       neutral     FALSE          0.0000000
#> 12      FALSE       1.0000000   facilitator     FALSE          0.0000000
#> 13      FALSE       0.8333333       neutral     FALSE          0.4101185
#> 14      FALSE       0.6666667       neutral     FALSE          0.7896901
#> 15      FALSE       0.8333333   facilitator     FALSE          0.4101185
#> 16      FALSE       1.0000000   facilitator     FALSE          0.0000000
#> 17      FALSE       0.8333333       neutral     FALSE          0.4101185
#> 18      FALSE       0.8333333   facilitator     FALSE          0.4101185
#> 19      FALSE       0.8333333   facilitator     FALSE          0.4101185
#> 20      FALSE       0.8333333       neutral     FALSE          0.4101185
#> 21      FALSE       0.6666667       neutral     FALSE          0.5793802
#> 22      FALSE       0.5000000       neutral     FALSE          0.9206198
#> 23      FALSE       0.5000000       neutral     FALSE          0.9206198
#> 24      FALSE       0.8333333       neutral     FALSE          0.4101185
#> 25      FALSE       0.8333333       neutral     FALSE          0.4101185
#> 26      FALSE       0.8333333   facilitator     FALSE          0.4101185
#> 27      FALSE       0.6666667   facilitator     FALSE          0.5793802
#> 28      FALSE       0.6666667   facilitator     FALSE          0.5793802
#> 29      FALSE       0.8333333   facilitator     FALSE          0.4101185
#> 30      FALSE       0.8333333   facilitator     FALSE          0.4101185
#> 31      FALSE       1.0000000       barrier     FALSE          0.0000000
#> 32      FALSE       1.0000000   facilitator     FALSE          0.0000000
#> 33      FALSE       0.8333333   facilitator     FALSE          0.4101185
#> 34      FALSE       0.6666667       neutral     FALSE          0.7896901
#> 35      FALSE       1.0000000       barrier     FALSE          0.0000000
#> 36      FALSE       1.0000000       barrier     FALSE          0.0000000
#> 37      FALSE       0.8333333       barrier     FALSE          0.4101185
#> 38      FALSE       0.8333333       barrier     FALSE          0.4101185
#> 39      FALSE       0.6666667       neutral     FALSE          0.7896901
#> 40      FALSE       0.8333333   facilitator     FALSE          0.4101185
#> 41      FALSE       1.0000000       barrier     FALSE          0.0000000
#> 42      FALSE       1.0000000       barrier     FALSE          0.0000000
#> 43      FALSE       0.8333333   facilitator     FALSE          0.4101185
#> 44      FALSE       0.8333333   facilitator     FALSE          0.4101185
#> 45      FALSE       1.0000000       barrier     FALSE          0.0000000
#> 46      FALSE       1.0000000   facilitator     FALSE          0.0000000
#> 47      FALSE       1.0000000   facilitator     FALSE          0.0000000
#> 48      FALSE       0.8333333       neutral     FALSE          0.4101185
#> 49      FALSE       0.8333333       neutral     FALSE          0.4101185
#> 50      FALSE       0.5000000           tie     FALSE          0.6309298
#> 51      FALSE       0.5000000           tie     FALSE          0.6309298
#> 52      FALSE       0.6666667       neutral     FALSE          0.5793802
#> 53      FALSE       0.8333333       neutral     FALSE          0.4101185
#> 54      FALSE       0.8333333   facilitator     FALSE          0.4101185
#> 55      FALSE       0.5000000       barrier     FALSE          0.9206198
#> 56      FALSE       0.5000000           tie     FALSE          0.6309298
#>          consensus_label
#> 1  consensus_facilitator
#> 2  consensus_facilitator
#> 3      consensus_neutral
#> 4  consensus_facilitator
#> 5  consensus_facilitator
#> 6      consensus_neutral
#> 7      consensus_barrier
#> 8      consensus_barrier
#> 9      consensus_barrier
#> 10     consensus_barrier
#> 11     consensus_neutral
#> 12 consensus_facilitator
#> 13     consensus_neutral
#> 14     consensus_neutral
#> 15 consensus_facilitator
#> 16 consensus_facilitator
#> 17     consensus_neutral
#> 18 consensus_facilitator
#> 19 consensus_facilitator
#> 20     consensus_neutral
#> 21     consensus_neutral
#> 22                 mixed
#> 23                 mixed
#> 24     consensus_neutral
#> 25     consensus_neutral
#> 26 consensus_facilitator
#> 27 consensus_facilitator
#> 28 consensus_facilitator
#> 29 consensus_facilitator
#> 30 consensus_facilitator
#> 31     consensus_barrier
#> 32 consensus_facilitator
#> 33 consensus_facilitator
#> 34     consensus_neutral
#> 35     consensus_barrier
#> 36     consensus_barrier
#> 37     consensus_barrier
#> 38     consensus_barrier
#> 39     consensus_neutral
#> 40 consensus_facilitator
#> 41     consensus_barrier
#> 42     consensus_barrier
#> 43 consensus_facilitator
#> 44 consensus_facilitator
#> 45     consensus_barrier
#> 46 consensus_facilitator
#> 47 consensus_facilitator
#> 48     consensus_neutral
#> 49     consensus_neutral
#> 50                 mixed
#> 51                 mixed
#> 52     consensus_neutral
#> 53     consensus_neutral
#> 54 consensus_facilitator
#> 55                 mixed
#> 56                 mixed

pcat_change(
  classified,
  from = "planning",
  to = "mid_implementation"
)
#>     project_id site_id respondent_id item_id    from_pcat_class
#> 1    PCAT_DEMO  SITE_A          R001       1   weak_facilitator
#> 2    PCAT_DEMO  SITE_A          R001       2   weak_facilitator
#> 3    PCAT_DEMO  SITE_A          R001       3            neutral
#> 4    PCAT_DEMO  SITE_A          R001       4   weak_facilitator
#> 5    PCAT_DEMO  SITE_A          R001       5            neutral
#> 6    PCAT_DEMO  SITE_A          R001       6            neutral
#> 7    PCAT_DEMO  SITE_A          R001       7     strong_barrier
#> 8    PCAT_DEMO  SITE_A          R001       8     strong_barrier
#> 9    PCAT_DEMO  SITE_A          R001       9            neutral
#> 10   PCAT_DEMO  SITE_A          R001      10     strong_barrier
#> 11   PCAT_DEMO  SITE_A          R001      11            neutral
#> 12   PCAT_DEMO  SITE_A          R001      12 strong_facilitator
#> 13   PCAT_DEMO  SITE_A          R001      13            neutral
#> 14   PCAT_DEMO  SITE_A          R001      14            neutral
#> 15   PCAT_DEMO  SITE_A          R002       1   weak_facilitator
#> 16   PCAT_DEMO  SITE_A          R002       2 strong_facilitator
#> 17   PCAT_DEMO  SITE_A          R002       3   weak_facilitator
#> 18   PCAT_DEMO  SITE_A          R002       4   weak_facilitator
#> 19   PCAT_DEMO  SITE_A          R002       5   weak_facilitator
#> 20   PCAT_DEMO  SITE_A          R002       6            neutral
#> 21   PCAT_DEMO  SITE_A          R002       7     strong_barrier
#> 22   PCAT_DEMO  SITE_A          R002       8     strong_barrier
#> 23   PCAT_DEMO  SITE_A          R002       9     strong_barrier
#> 24   PCAT_DEMO  SITE_A          R002      10     strong_barrier
#> 25   PCAT_DEMO  SITE_A          R002      11            neutral
#> 26   PCAT_DEMO  SITE_A          R002      12 strong_facilitator
#> 27   PCAT_DEMO  SITE_A          R002      13            neutral
#> 28   PCAT_DEMO  SITE_A          R002      14 strong_facilitator
#> 29   PCAT_DEMO  SITE_A          R003       1 strong_facilitator
#> 30   PCAT_DEMO  SITE_A          R003       2   weak_facilitator
#> 31   PCAT_DEMO  SITE_A          R003       3            neutral
#> 32   PCAT_DEMO  SITE_A          R003       4            neutral
#> 33   PCAT_DEMO  SITE_A          R003       5 strong_facilitator
#> 34   PCAT_DEMO  SITE_A          R003       6            neutral
#> 35   PCAT_DEMO  SITE_A          R003       7     strong_barrier
#> 36   PCAT_DEMO  SITE_A          R003       8            neutral
#> 37   PCAT_DEMO  SITE_A          R003       9     strong_barrier
#> 38   PCAT_DEMO  SITE_A          R003      10     strong_barrier
#> 39   PCAT_DEMO  SITE_A          R003      11            neutral
#> 40   PCAT_DEMO  SITE_A          R003      12 strong_facilitator
#> 41   PCAT_DEMO  SITE_A          R003      13            neutral
#> 42   PCAT_DEMO  SITE_A          R003      14            neutral
#> 43   PCAT_DEMO  SITE_A          R004       1   weak_facilitator
#> 44   PCAT_DEMO  SITE_A          R004       2   weak_facilitator
#> 45   PCAT_DEMO  SITE_A          R004       3            neutral
#> 46   PCAT_DEMO  SITE_A          R004       4 strong_facilitator
#> 47   PCAT_DEMO  SITE_A          R004       5   weak_facilitator
#> 48   PCAT_DEMO  SITE_A          R004       6            neutral
#> 49   PCAT_DEMO  SITE_A          R004       7     strong_barrier
#> 50   PCAT_DEMO  SITE_A          R004       8     strong_barrier
#> 51   PCAT_DEMO  SITE_A          R004       9     strong_barrier
#> 52   PCAT_DEMO  SITE_A          R004      10     strong_barrier
#> 53   PCAT_DEMO  SITE_A          R004      11            neutral
#> 54   PCAT_DEMO  SITE_A          R004      12 strong_facilitator
#> 55   PCAT_DEMO  SITE_A          R004      13 strong_facilitator
#> 56   PCAT_DEMO  SITE_A          R004      14            neutral
#> 57   PCAT_DEMO  SITE_A          R005       1   weak_facilitator
#> 58   PCAT_DEMO  SITE_A          R005       2   weak_facilitator
#> 59   PCAT_DEMO  SITE_A          R005       3     strong_barrier
#> 60   PCAT_DEMO  SITE_A          R005       4   weak_facilitator
#> 61   PCAT_DEMO  SITE_A          R005       5   weak_facilitator
#> 62   PCAT_DEMO  SITE_A          R005       6            neutral
#> 63   PCAT_DEMO  SITE_A          R005       7            neutral
#> 64   PCAT_DEMO  SITE_A          R005       8     strong_barrier
#> 65   PCAT_DEMO  SITE_A          R005       9     strong_barrier
#> 66   PCAT_DEMO  SITE_A          R005      10     strong_barrier
#> 67   PCAT_DEMO  SITE_A          R005      11            neutral
#> 68   PCAT_DEMO  SITE_A          R005      12 strong_facilitator
#> 69   PCAT_DEMO  SITE_A          R005      13            neutral
#> 70   PCAT_DEMO  SITE_A          R005      14     strong_barrier
#> 71   PCAT_DEMO  SITE_A          R006       1   weak_facilitator
#> 72   PCAT_DEMO  SITE_A          R006       2 strong_facilitator
#> 73   PCAT_DEMO  SITE_A          R006       3            neutral
#> 74   PCAT_DEMO  SITE_A          R006       4   weak_facilitator
#> 75   PCAT_DEMO  SITE_A          R006       5   weak_facilitator
#> 76   PCAT_DEMO  SITE_A          R006       6            neutral
#> 77   PCAT_DEMO  SITE_A          R006       7     strong_barrier
#> 78   PCAT_DEMO  SITE_A          R006       8     strong_barrier
#> 79   PCAT_DEMO  SITE_A          R006       9     strong_barrier
#> 80   PCAT_DEMO  SITE_A          R006      10     strong_barrier
#> 81   PCAT_DEMO  SITE_A          R006      11            neutral
#> 82   PCAT_DEMO  SITE_A          R006      12 strong_facilitator
#> 83   PCAT_DEMO  SITE_A          R006      13            neutral
#> 84   PCAT_DEMO  SITE_A          R006      14            neutral
#> 85   PCAT_DEMO  SITE_B          R007       1 strong_facilitator
#> 86   PCAT_DEMO  SITE_B          R007       2            neutral
#> 87   PCAT_DEMO  SITE_B          R007       3       weak_barrier
#> 88   PCAT_DEMO  SITE_B          R007       4   weak_facilitator
#> 89   PCAT_DEMO  SITE_B          R007       5 strong_facilitator
#> 90   PCAT_DEMO  SITE_B          R007       6   weak_facilitator
#> 91   PCAT_DEMO  SITE_B          R007       7     strong_barrier
#> 92   PCAT_DEMO  SITE_B          R007       8     strong_barrier
#> 93   PCAT_DEMO  SITE_B          R007       9     strong_barrier
#> 94   PCAT_DEMO  SITE_B          R007      10     strong_barrier
#> 95   PCAT_DEMO  SITE_B          R007      11            neutral
#> 96   PCAT_DEMO  SITE_B          R007      12 strong_facilitator
#> 97   PCAT_DEMO  SITE_B          R007      13     strong_barrier
#> 98   PCAT_DEMO  SITE_B          R007      14     strong_barrier
#> 99   PCAT_DEMO  SITE_B          R008       1   weak_facilitator
#> 100  PCAT_DEMO  SITE_B          R008       2   weak_facilitator
#> 101  PCAT_DEMO  SITE_B          R008       3       weak_barrier
#> 102  PCAT_DEMO  SITE_B          R008       4 strong_facilitator
#> 103  PCAT_DEMO  SITE_B          R008       5   weak_facilitator
#> 104  PCAT_DEMO  SITE_B          R008       6            neutral
#> 105  PCAT_DEMO  SITE_B          R008       7     strong_barrier
#> 106  PCAT_DEMO  SITE_B          R008       8     strong_barrier
#> 107  PCAT_DEMO  SITE_B          R008       9     strong_barrier
#> 108  PCAT_DEMO  SITE_B          R008      10     strong_barrier
#> 109  PCAT_DEMO  SITE_B          R008      11   weak_facilitator
#> 110  PCAT_DEMO  SITE_B          R008      12 strong_facilitator
#> 111  PCAT_DEMO  SITE_B          R008      13     strong_barrier
#> 112  PCAT_DEMO  SITE_B          R008      14     strong_barrier
#> 113  PCAT_DEMO  SITE_B          R009       1            neutral
#> 114  PCAT_DEMO  SITE_B          R009       2   weak_facilitator
#> 115  PCAT_DEMO  SITE_B          R009       3     strong_barrier
#> 116  PCAT_DEMO  SITE_B          R009       4   weak_facilitator
#> 117  PCAT_DEMO  SITE_B          R009       5   weak_facilitator
#> 118  PCAT_DEMO  SITE_B          R009       6            neutral
#> 119  PCAT_DEMO  SITE_B          R009       7     strong_barrier
#> 120  PCAT_DEMO  SITE_B          R009       8     strong_barrier
#> 121  PCAT_DEMO  SITE_B          R009       9     strong_barrier
#> 122  PCAT_DEMO  SITE_B          R009      10     strong_barrier
#> 123  PCAT_DEMO  SITE_B          R009      11            neutral
#> 124  PCAT_DEMO  SITE_B          R009      12            neutral
#> 125  PCAT_DEMO  SITE_B          R009      13     strong_barrier
#> 126  PCAT_DEMO  SITE_B          R009      14     strong_barrier
#> 127  PCAT_DEMO  SITE_B          R010       1   weak_facilitator
#> 128  PCAT_DEMO  SITE_B          R010       2 strong_facilitator
#> 129  PCAT_DEMO  SITE_B          R010       3       weak_barrier
#> 130  PCAT_DEMO  SITE_B          R010       4   weak_facilitator
#> 131  PCAT_DEMO  SITE_B          R010       5   weak_facilitator
#> 132  PCAT_DEMO  SITE_B          R010       6     strong_barrier
#> 133  PCAT_DEMO  SITE_B          R010       7     strong_barrier
#> 134  PCAT_DEMO  SITE_B          R010       8     strong_barrier
#> 135  PCAT_DEMO  SITE_B          R010       9     strong_barrier
#> 136  PCAT_DEMO  SITE_B          R010      10            neutral
#> 137  PCAT_DEMO  SITE_B          R010      11            neutral
#> 138  PCAT_DEMO  SITE_B          R010      12 strong_facilitator
#> 139  PCAT_DEMO  SITE_B          R010      13     strong_barrier
#> 140  PCAT_DEMO  SITE_B          R010      14     strong_barrier
#> 141  PCAT_DEMO  SITE_B          R011       1 strong_facilitator
#> 142  PCAT_DEMO  SITE_B          R011       2   weak_facilitator
#> 143  PCAT_DEMO  SITE_B          R011       3       weak_barrier
#> 144  PCAT_DEMO  SITE_B          R011       4   weak_facilitator
#> 145  PCAT_DEMO  SITE_B          R011       5 strong_facilitator
#> 146  PCAT_DEMO  SITE_B          R011       6            neutral
#> 147  PCAT_DEMO  SITE_B          R011       7     strong_barrier
#> 148  PCAT_DEMO  SITE_B          R011       8     strong_barrier
#> 149  PCAT_DEMO  SITE_B          R011       9     strong_barrier
#> 150  PCAT_DEMO  SITE_B          R011      10     strong_barrier
#> 151  PCAT_DEMO  SITE_B          R011      11       weak_barrier
#> 152  PCAT_DEMO  SITE_B          R011      12 strong_facilitator
#> 153  PCAT_DEMO  SITE_B          R011      13     strong_barrier
#> 154  PCAT_DEMO  SITE_B          R011      14     strong_barrier
#> 155  PCAT_DEMO  SITE_B          R012       1   weak_facilitator
#> 156  PCAT_DEMO  SITE_B          R012       2   weak_facilitator
#> 157  PCAT_DEMO  SITE_B          R012       3       weak_barrier
#> 158  PCAT_DEMO  SITE_B          R012       4 strong_facilitator
#> 159  PCAT_DEMO  SITE_B          R012       5            neutral
#> 160  PCAT_DEMO  SITE_B          R012       6            neutral
#> 161  PCAT_DEMO  SITE_B          R012       7     strong_barrier
#> 162  PCAT_DEMO  SITE_B          R012       8     strong_barrier
#> 163  PCAT_DEMO  SITE_B          R012       9            neutral
#> 164  PCAT_DEMO  SITE_B          R012      10     strong_barrier
#> 165  PCAT_DEMO  SITE_B          R012      11            neutral
#> 166  PCAT_DEMO  SITE_B          R012      12 strong_facilitator
#> 167  PCAT_DEMO  SITE_B          R012      13     strong_barrier
#> 168  PCAT_DEMO  SITE_B          R012      14     strong_barrier
#>          to_pcat_class   from_pcat_class5     to_pcat_class5
#> 1              neutral   weak_facilitator            neutral
#> 2     weak_facilitator   weak_facilitator   weak_facilitator
#> 3              neutral            neutral            neutral
#> 4     weak_facilitator   weak_facilitator   weak_facilitator
#> 5     weak_facilitator            neutral   weak_facilitator
#> 6              neutral            neutral            neutral
#> 7              neutral     strong_barrier            neutral
#> 8       strong_barrier     strong_barrier     strong_barrier
#> 9              neutral            neutral            neutral
#> 10             neutral     strong_barrier            neutral
#> 11             neutral            neutral            neutral
#> 12             neutral strong_facilitator            neutral
#> 13  strong_facilitator            neutral strong_facilitator
#> 14             neutral            neutral            neutral
#> 15    weak_facilitator   weak_facilitator   weak_facilitator
#> 16  strong_facilitator strong_facilitator strong_facilitator
#> 17             neutral   weak_facilitator            neutral
#> 18    weak_facilitator   weak_facilitator   weak_facilitator
#> 19    weak_facilitator   weak_facilitator   weak_facilitator
#> 20      strong_barrier            neutral     strong_barrier
#> 21      strong_barrier     strong_barrier     strong_barrier
#> 22             neutral     strong_barrier            neutral
#> 23             neutral     strong_barrier            neutral
#> 24             neutral     strong_barrier            neutral
#> 25             neutral            neutral            neutral
#> 26  strong_facilitator strong_facilitator strong_facilitator
#> 27             neutral            neutral            neutral
#> 28  strong_facilitator strong_facilitator strong_facilitator
#> 29  strong_facilitator strong_facilitator strong_facilitator
#> 30    weak_facilitator   weak_facilitator   weak_facilitator
#> 31             neutral            neutral            neutral
#> 32    weak_facilitator            neutral   weak_facilitator
#> 33  strong_facilitator strong_facilitator strong_facilitator
#> 34             neutral            neutral            neutral
#> 35             neutral     strong_barrier            neutral
#> 36             neutral            neutral            neutral
#> 37      strong_barrier     strong_barrier     strong_barrier
#> 38             neutral     strong_barrier            neutral
#> 39        weak_barrier            neutral       weak_barrier
#> 40  strong_facilitator strong_facilitator strong_facilitator
#> 41  strong_facilitator            neutral strong_facilitator
#> 42  strong_facilitator            neutral strong_facilitator
#> 43    weak_facilitator   weak_facilitator   weak_facilitator
#> 44    weak_facilitator   weak_facilitator   weak_facilitator
#> 45             neutral            neutral            neutral
#> 46  strong_facilitator strong_facilitator strong_facilitator
#> 47             neutral   weak_facilitator            neutral
#> 48             neutral            neutral            neutral
#> 49             neutral     strong_barrier            neutral
#> 50      strong_barrier     strong_barrier     strong_barrier
#> 51  strong_facilitator     strong_barrier strong_facilitator
#> 52             neutral     strong_barrier            neutral
#> 53             neutral            neutral            neutral
#> 54  strong_facilitator strong_facilitator strong_facilitator
#> 55  strong_facilitator strong_facilitator strong_facilitator
#> 56             neutral            neutral            neutral
#> 57    weak_facilitator   weak_facilitator   weak_facilitator
#> 58    weak_facilitator   weak_facilitator   weak_facilitator
#> 59  strong_facilitator     strong_barrier strong_facilitator
#> 60    weak_facilitator   weak_facilitator   weak_facilitator
#> 61    weak_facilitator   weak_facilitator   weak_facilitator
#> 62             neutral            neutral            neutral
#> 63      strong_barrier            neutral     strong_barrier
#> 64             neutral     strong_barrier            neutral
#> 65             neutral     strong_barrier            neutral
#> 66      strong_barrier     strong_barrier     strong_barrier
#> 67             neutral            neutral            neutral
#> 68  strong_facilitator strong_facilitator strong_facilitator
#> 69             neutral            neutral            neutral
#> 70  strong_facilitator     strong_barrier strong_facilitator
#> 71    weak_facilitator   weak_facilitator   weak_facilitator
#> 72  strong_facilitator strong_facilitator strong_facilitator
#> 73             neutral            neutral            neutral
#> 74             neutral   weak_facilitator            neutral
#> 75    weak_facilitator   weak_facilitator   weak_facilitator
#> 76             neutral            neutral            neutral
#> 77             neutral     strong_barrier            neutral
#> 78  strong_facilitator     strong_barrier strong_facilitator
#> 79      strong_barrier     strong_barrier     strong_barrier
#> 80             neutral     strong_barrier            neutral
#> 81             neutral            neutral            neutral
#> 82  strong_facilitator strong_facilitator strong_facilitator
#> 83  strong_facilitator            neutral strong_facilitator
#> 84  strong_facilitator            neutral strong_facilitator
#> 85  strong_facilitator strong_facilitator strong_facilitator
#> 86    weak_facilitator            neutral   weak_facilitator
#> 87        weak_barrier       weak_barrier       weak_barrier
#> 88    weak_facilitator   weak_facilitator   weak_facilitator
#> 89  strong_facilitator strong_facilitator strong_facilitator
#> 90             neutral   weak_facilitator            neutral
#> 91             neutral     strong_barrier            neutral
#> 92      strong_barrier     strong_barrier     strong_barrier
#> 93      strong_barrier     strong_barrier     strong_barrier
#> 94             neutral     strong_barrier            neutral
#> 95             neutral            neutral            neutral
#> 96  strong_facilitator strong_facilitator strong_facilitator
#> 97  strong_facilitator     strong_barrier strong_facilitator
#> 98      strong_barrier     strong_barrier     strong_barrier
#> 99    weak_facilitator   weak_facilitator   weak_facilitator
#> 100   weak_facilitator   weak_facilitator   weak_facilitator
#> 101       weak_barrier       weak_barrier       weak_barrier
#> 102 strong_facilitator strong_facilitator strong_facilitator
#> 103   weak_facilitator   weak_facilitator   weak_facilitator
#> 104            neutral            neutral            neutral
#> 105            neutral     strong_barrier            neutral
#> 106            neutral     strong_barrier            neutral
#> 107            neutral     strong_barrier            neutral
#> 108     strong_barrier     strong_barrier     strong_barrier
#> 109            neutral   weak_facilitator            neutral
#> 110 strong_facilitator strong_facilitator strong_facilitator
#> 111     strong_barrier     strong_barrier     strong_barrier
#> 112     strong_barrier     strong_barrier     strong_barrier
#> 113   weak_facilitator            neutral   weak_facilitator
#> 114   weak_facilitator   weak_facilitator   weak_facilitator
#> 115     strong_barrier     strong_barrier     strong_barrier
#> 116   weak_facilitator   weak_facilitator   weak_facilitator
#> 117   weak_facilitator   weak_facilitator   weak_facilitator
#> 118            neutral            neutral            neutral
#> 119            neutral     strong_barrier            neutral
#> 120     strong_barrier     strong_barrier     strong_barrier
#> 121     strong_barrier     strong_barrier     strong_barrier
#> 122            neutral     strong_barrier            neutral
#> 123            neutral            neutral            neutral
#> 124 strong_facilitator            neutral strong_facilitator
#> 125            neutral     strong_barrier            neutral
#> 126            neutral     strong_barrier            neutral
#> 127   weak_facilitator   weak_facilitator   weak_facilitator
#> 128            neutral strong_facilitator            neutral
#> 129       weak_barrier       weak_barrier       weak_barrier
#> 130   weak_facilitator   weak_facilitator   weak_facilitator
#> 131   weak_facilitator   weak_facilitator   weak_facilitator
#> 132 strong_facilitator     strong_barrier strong_facilitator
#> 133            neutral     strong_barrier            neutral
#> 134     strong_barrier     strong_barrier     strong_barrier
#> 135            neutral     strong_barrier            neutral
#> 136            neutral            neutral            neutral
#> 137            neutral            neutral            neutral
#> 138 strong_facilitator strong_facilitator strong_facilitator
#> 139     strong_barrier     strong_barrier     strong_barrier
#> 140     strong_barrier     strong_barrier     strong_barrier
#> 141 strong_facilitator strong_facilitator strong_facilitator
#> 142   weak_facilitator   weak_facilitator   weak_facilitator
#> 143       weak_barrier       weak_barrier       weak_barrier
#> 144   weak_facilitator   weak_facilitator   weak_facilitator
#> 145 strong_facilitator strong_facilitator strong_facilitator
#> 146            neutral            neutral            neutral
#> 147     strong_barrier     strong_barrier     strong_barrier
#> 148            neutral     strong_barrier            neutral
#> 149            neutral     strong_barrier            neutral
#> 150     strong_barrier     strong_barrier     strong_barrier
#> 151   weak_facilitator       weak_barrier   weak_facilitator
#> 152 strong_facilitator strong_facilitator strong_facilitator
#> 153     strong_barrier     strong_barrier     strong_barrier
#> 154            neutral     strong_barrier            neutral
#> 155            neutral   weak_facilitator            neutral
#> 156   weak_facilitator   weak_facilitator   weak_facilitator
#> 157       weak_barrier       weak_barrier       weak_barrier
#> 158 strong_facilitator strong_facilitator strong_facilitator
#> 159   weak_facilitator            neutral   weak_facilitator
#> 160            neutral            neutral            neutral
#> 161            neutral     strong_barrier            neutral
#> 162            neutral     strong_barrier            neutral
#> 163     strong_barrier            neutral     strong_barrier
#> 164            neutral     strong_barrier            neutral
#> 165            neutral            neutral            neutral
#> 166            neutral strong_facilitator            neutral
#> 167            neutral     strong_barrier            neutral
#> 168            neutral     strong_barrier            neutral
#>     from_pcat_display_code to_pcat_display_code from_pcat_side to_pcat_side
#> 1                        1                    0    facilitator      neutral
#> 2                        1                    1    facilitator  facilitator
#> 3                        0                    0        neutral      neutral
#> 4                        1                    1    facilitator  facilitator
#> 5                        0                    1        neutral  facilitator
#> 6                        0                    0        neutral      neutral
#> 7                       -2                    0        barrier      neutral
#> 8                       -2                   -2        barrier      barrier
#> 9                        0                    0        neutral      neutral
#> 10                      -2                    0        barrier      neutral
#> 11                       0                    0        neutral      neutral
#> 12                       2                    0    facilitator      neutral
#> 13                       0                    2        neutral  facilitator
#> 14                       0                    0        neutral      neutral
#> 15                       1                    1    facilitator  facilitator
#> 16                       2                    2    facilitator  facilitator
#> 17                       1                    0    facilitator      neutral
#> 18                       1                    1    facilitator  facilitator
#> 19                       1                    1    facilitator  facilitator
#> 20                       0                   -2        neutral      barrier
#> 21                      -2                   -2        barrier      barrier
#> 22                      -2                    0        barrier      neutral
#> 23                      -2                    0        barrier      neutral
#> 24                      -2                    0        barrier      neutral
#> 25                       0                    0        neutral      neutral
#> 26                       2                    2    facilitator  facilitator
#> 27                       0                    0        neutral      neutral
#> 28                       2                    2    facilitator  facilitator
#> 29                       2                    2    facilitator  facilitator
#> 30                       1                    1    facilitator  facilitator
#> 31                       0                    0        neutral      neutral
#> 32                       0                    1        neutral  facilitator
#> 33                       2                    2    facilitator  facilitator
#> 34                       0                    0        neutral      neutral
#> 35                      -2                    0        barrier      neutral
#> 36                       0                    0        neutral      neutral
#> 37                      -2                   -2        barrier      barrier
#> 38                      -2                    0        barrier      neutral
#> 39                       0                   -1        neutral      barrier
#> 40                       2                    2    facilitator  facilitator
#> 41                       0                    2        neutral  facilitator
#> 42                       0                    2        neutral  facilitator
#> 43                       1                    1    facilitator  facilitator
#> 44                       1                    1    facilitator  facilitator
#> 45                       0                    0        neutral      neutral
#> 46                       2                    2    facilitator  facilitator
#> 47                       1                    0    facilitator      neutral
#> 48                       0                    0        neutral      neutral
#> 49                      -2                    0        barrier      neutral
#> 50                      -2                   -2        barrier      barrier
#> 51                      -2                    2        barrier  facilitator
#> 52                      -2                    0        barrier      neutral
#> 53                       0                    0        neutral      neutral
#> 54                       2                    2    facilitator  facilitator
#> 55                       2                    2    facilitator  facilitator
#> 56                       0                    0        neutral      neutral
#> 57                       1                    1    facilitator  facilitator
#> 58                       1                    1    facilitator  facilitator
#> 59                      -2                    2        barrier  facilitator
#> 60                       1                    1    facilitator  facilitator
#> 61                       1                    1    facilitator  facilitator
#> 62                       0                    0        neutral      neutral
#> 63                       0                   -2        neutral      barrier
#> 64                      -2                    0        barrier      neutral
#> 65                      -2                    0        barrier      neutral
#> 66                      -2                   -2        barrier      barrier
#> 67                       0                    0        neutral      neutral
#> 68                       2                    2    facilitator  facilitator
#> 69                       0                    0        neutral      neutral
#> 70                      -2                    2        barrier  facilitator
#> 71                       1                    1    facilitator  facilitator
#> 72                       2                    2    facilitator  facilitator
#> 73                       0                    0        neutral      neutral
#> 74                       1                    0    facilitator      neutral
#> 75                       1                    1    facilitator  facilitator
#> 76                       0                    0        neutral      neutral
#> 77                      -2                    0        barrier      neutral
#> 78                      -2                    2        barrier  facilitator
#> 79                      -2                   -2        barrier      barrier
#> 80                      -2                    0        barrier      neutral
#> 81                       0                    0        neutral      neutral
#> 82                       2                    2    facilitator  facilitator
#> 83                       0                    2        neutral  facilitator
#> 84                       0                    2        neutral  facilitator
#> 85                       2                    2    facilitator  facilitator
#> 86                       0                    1        neutral  facilitator
#> 87                      -1                   -1        barrier      barrier
#> 88                       1                    1    facilitator  facilitator
#> 89                       2                    2    facilitator  facilitator
#> 90                       1                    0    facilitator      neutral
#> 91                      -2                    0        barrier      neutral
#> 92                      -2                   -2        barrier      barrier
#> 93                      -2                   -2        barrier      barrier
#> 94                      -2                    0        barrier      neutral
#> 95                       0                    0        neutral      neutral
#> 96                       2                    2    facilitator  facilitator
#> 97                      -2                    2        barrier  facilitator
#> 98                      -2                   -2        barrier      barrier
#> 99                       1                    1    facilitator  facilitator
#> 100                      1                    1    facilitator  facilitator
#> 101                     -1                   -1        barrier      barrier
#> 102                      2                    2    facilitator  facilitator
#> 103                      1                    1    facilitator  facilitator
#> 104                      0                    0        neutral      neutral
#> 105                     -2                    0        barrier      neutral
#> 106                     -2                    0        barrier      neutral
#> 107                     -2                    0        barrier      neutral
#> 108                     -2                   -2        barrier      barrier
#> 109                      1                    0    facilitator      neutral
#> 110                      2                    2    facilitator  facilitator
#> 111                     -2                   -2        barrier      barrier
#> 112                     -2                   -2        barrier      barrier
#> 113                      0                    1        neutral  facilitator
#> 114                      1                    1    facilitator  facilitator
#> 115                     -2                   -2        barrier      barrier
#> 116                      1                    1    facilitator  facilitator
#> 117                      1                    1    facilitator  facilitator
#> 118                      0                    0        neutral      neutral
#> 119                     -2                    0        barrier      neutral
#> 120                     -2                   -2        barrier      barrier
#> 121                     -2                   -2        barrier      barrier
#> 122                     -2                    0        barrier      neutral
#> 123                      0                    0        neutral      neutral
#> 124                      0                    2        neutral  facilitator
#> 125                     -2                    0        barrier      neutral
#> 126                     -2                    0        barrier      neutral
#> 127                      1                    1    facilitator  facilitator
#> 128                      2                    0    facilitator      neutral
#> 129                     -1                   -1        barrier      barrier
#> 130                      1                    1    facilitator  facilitator
#> 131                      1                    1    facilitator  facilitator
#> 132                     -2                    2        barrier  facilitator
#> 133                     -2                    0        barrier      neutral
#> 134                     -2                   -2        barrier      barrier
#> 135                     -2                    0        barrier      neutral
#> 136                      0                    0        neutral      neutral
#> 137                      0                    0        neutral      neutral
#> 138                      2                    2    facilitator  facilitator
#> 139                     -2                   -2        barrier      barrier
#> 140                     -2                   -2        barrier      barrier
#> 141                      2                    2    facilitator  facilitator
#> 142                      1                    1    facilitator  facilitator
#> 143                     -1                   -1        barrier      barrier
#> 144                      1                    1    facilitator  facilitator
#> 145                      2                    2    facilitator  facilitator
#> 146                      0                    0        neutral      neutral
#> 147                     -2                   -2        barrier      barrier
#> 148                     -2                    0        barrier      neutral
#> 149                     -2                    0        barrier      neutral
#> 150                     -2                   -2        barrier      barrier
#> 151                     -1                    1        barrier  facilitator
#> 152                      2                    2    facilitator  facilitator
#> 153                     -2                   -2        barrier      barrier
#> 154                     -2                    0        barrier      neutral
#> 155                      1                    0    facilitator      neutral
#> 156                      1                    1    facilitator  facilitator
#> 157                     -1                   -1        barrier      barrier
#> 158                      2                    2    facilitator  facilitator
#> 159                      0                    1        neutral  facilitator
#> 160                      0                    0        neutral      neutral
#> 161                     -2                    0        barrier      neutral
#> 162                     -2                    0        barrier      neutral
#> 163                      0                   -2        neutral      barrier
#> 164                     -2                    0        barrier      neutral
#> 165                      0                    0        neutral      neutral
#> 166                      2                    0    facilitator      neutral
#> 167                     -2                    0        barrier      neutral
#> 168                     -2                    0        barrier      neutral
#>     paired_complete delta_display_code          transition
#> 1              TRUE                 -1      toward_barrier
#> 2              TRUE                  0      no_code_change
#> 3              TRUE                  0      no_code_change
#> 4              TRUE                  0      no_code_change
#> 5              TRUE                  1 toward_facilitation
#> 6              TRUE                  0      no_code_change
#> 7              TRUE                  2 toward_facilitation
#> 8              TRUE                  0      no_code_change
#> 9              TRUE                  0      no_code_change
#> 10             TRUE                  2 toward_facilitation
#> 11             TRUE                  0      no_code_change
#> 12             TRUE                 -2      toward_barrier
#> 13             TRUE                  2 toward_facilitation
#> 14             TRUE                  0      no_code_change
#> 15             TRUE                  0      no_code_change
#> 16             TRUE                  0      no_code_change
#> 17             TRUE                 -1      toward_barrier
#> 18             TRUE                  0      no_code_change
#> 19             TRUE                  0      no_code_change
#> 20             TRUE                 -2      toward_barrier
#> 21             TRUE                  0      no_code_change
#> 22             TRUE                  2 toward_facilitation
#> 23             TRUE                  2 toward_facilitation
#> 24             TRUE                  2 toward_facilitation
#> 25             TRUE                  0      no_code_change
#> 26             TRUE                  0      no_code_change
#> 27             TRUE                  0      no_code_change
#> 28             TRUE                  0      no_code_change
#> 29             TRUE                  0      no_code_change
#> 30             TRUE                  0      no_code_change
#> 31             TRUE                  0      no_code_change
#> 32             TRUE                  1 toward_facilitation
#> 33             TRUE                  0      no_code_change
#> 34             TRUE                  0      no_code_change
#> 35             TRUE                  2 toward_facilitation
#> 36             TRUE                  0      no_code_change
#> 37             TRUE                  0      no_code_change
#> 38             TRUE                  2 toward_facilitation
#> 39             TRUE                 -1      toward_barrier
#> 40             TRUE                  0      no_code_change
#> 41             TRUE                  2 toward_facilitation
#> 42             TRUE                  2 toward_facilitation
#> 43             TRUE                  0      no_code_change
#> 44             TRUE                  0      no_code_change
#> 45             TRUE                  0      no_code_change
#> 46             TRUE                  0      no_code_change
#> 47             TRUE                 -1      toward_barrier
#> 48             TRUE                  0      no_code_change
#> 49             TRUE                  2 toward_facilitation
#> 50             TRUE                  0      no_code_change
#> 51             TRUE                  4 toward_facilitation
#> 52             TRUE                  2 toward_facilitation
#> 53             TRUE                  0      no_code_change
#> 54             TRUE                  0      no_code_change
#> 55             TRUE                  0      no_code_change
#> 56             TRUE                  0      no_code_change
#> 57             TRUE                  0      no_code_change
#> 58             TRUE                  0      no_code_change
#> 59             TRUE                  4 toward_facilitation
#> 60             TRUE                  0      no_code_change
#> 61             TRUE                  0      no_code_change
#> 62             TRUE                  0      no_code_change
#> 63             TRUE                 -2      toward_barrier
#> 64             TRUE                  2 toward_facilitation
#> 65             TRUE                  2 toward_facilitation
#> 66             TRUE                  0      no_code_change
#> 67             TRUE                  0      no_code_change
#> 68             TRUE                  0      no_code_change
#> 69             TRUE                  0      no_code_change
#> 70             TRUE                  4 toward_facilitation
#> 71             TRUE                  0      no_code_change
#> 72             TRUE                  0      no_code_change
#> 73             TRUE                  0      no_code_change
#> 74             TRUE                 -1      toward_barrier
#> 75             TRUE                  0      no_code_change
#> 76             TRUE                  0      no_code_change
#> 77             TRUE                  2 toward_facilitation
#> 78             TRUE                  4 toward_facilitation
#> 79             TRUE                  0      no_code_change
#> 80             TRUE                  2 toward_facilitation
#> 81             TRUE                  0      no_code_change
#> 82             TRUE                  0      no_code_change
#> 83             TRUE                  2 toward_facilitation
#> 84             TRUE                  2 toward_facilitation
#> 85             TRUE                  0      no_code_change
#> 86             TRUE                  1 toward_facilitation
#> 87             TRUE                  0      no_code_change
#> 88             TRUE                  0      no_code_change
#> 89             TRUE                  0      no_code_change
#> 90             TRUE                 -1      toward_barrier
#> 91             TRUE                  2 toward_facilitation
#> 92             TRUE                  0      no_code_change
#> 93             TRUE                  0      no_code_change
#> 94             TRUE                  2 toward_facilitation
#> 95             TRUE                  0      no_code_change
#> 96             TRUE                  0      no_code_change
#> 97             TRUE                  4 toward_facilitation
#> 98             TRUE                  0      no_code_change
#> 99             TRUE                  0      no_code_change
#> 100            TRUE                  0      no_code_change
#> 101            TRUE                  0      no_code_change
#> 102            TRUE                  0      no_code_change
#> 103            TRUE                  0      no_code_change
#> 104            TRUE                  0      no_code_change
#> 105            TRUE                  2 toward_facilitation
#> 106            TRUE                  2 toward_facilitation
#> 107            TRUE                  2 toward_facilitation
#> 108            TRUE                  0      no_code_change
#> 109            TRUE                 -1      toward_barrier
#> 110            TRUE                  0      no_code_change
#> 111            TRUE                  0      no_code_change
#> 112            TRUE                  0      no_code_change
#> 113            TRUE                  1 toward_facilitation
#> 114            TRUE                  0      no_code_change
#> 115            TRUE                  0      no_code_change
#> 116            TRUE                  0      no_code_change
#> 117            TRUE                  0      no_code_change
#> 118            TRUE                  0      no_code_change
#> 119            TRUE                  2 toward_facilitation
#> 120            TRUE                  0      no_code_change
#> 121            TRUE                  0      no_code_change
#> 122            TRUE                  2 toward_facilitation
#> 123            TRUE                  0      no_code_change
#> 124            TRUE                  2 toward_facilitation
#> 125            TRUE                  2 toward_facilitation
#> 126            TRUE                  2 toward_facilitation
#> 127            TRUE                  0      no_code_change
#> 128            TRUE                 -2      toward_barrier
#> 129            TRUE                  0      no_code_change
#> 130            TRUE                  0      no_code_change
#> 131            TRUE                  0      no_code_change
#> 132            TRUE                  4 toward_facilitation
#> 133            TRUE                  2 toward_facilitation
#> 134            TRUE                  0      no_code_change
#> 135            TRUE                  2 toward_facilitation
#> 136            TRUE                  0      no_code_change
#> 137            TRUE                  0      no_code_change
#> 138            TRUE                  0      no_code_change
#> 139            TRUE                  0      no_code_change
#> 140            TRUE                  0      no_code_change
#> 141            TRUE                  0      no_code_change
#> 142            TRUE                  0      no_code_change
#> 143            TRUE                  0      no_code_change
#> 144            TRUE                  0      no_code_change
#> 145            TRUE                  0      no_code_change
#> 146            TRUE                  0      no_code_change
#> 147            TRUE                  0      no_code_change
#> 148            TRUE                  2 toward_facilitation
#> 149            TRUE                  2 toward_facilitation
#> 150            TRUE                  0      no_code_change
#> 151            TRUE                  2 toward_facilitation
#> 152            TRUE                  0      no_code_change
#> 153            TRUE                  0      no_code_change
#> 154            TRUE                  2 toward_facilitation
#> 155            TRUE                 -1      toward_barrier
#> 156            TRUE                  0      no_code_change
#> 157            TRUE                  0      no_code_change
#> 158            TRUE                  0      no_code_change
#> 159            TRUE                  1 toward_facilitation
#> 160            TRUE                  0      no_code_change
#> 161            TRUE                  2 toward_facilitation
#> 162            TRUE                  2 toward_facilitation
#> 163            TRUE                 -2      toward_barrier
#> 164            TRUE                  2 toward_facilitation
#> 165            TRUE                  0      no_code_change
#> 166            TRUE                 -2      toward_barrier
#> 167            TRUE                  2 toward_facilitation
#> 168            TRUE                  2 toward_facilitation
#>                            transition_detail from_timepoint       to_timepoint
#> 1                weak_facilitator -> neutral       planning mid_implementation
#> 2       weak_facilitator -> weak_facilitator       planning mid_implementation
#> 3                         neutral -> neutral       planning mid_implementation
#> 4       weak_facilitator -> weak_facilitator       planning mid_implementation
#> 5                neutral -> weak_facilitator       planning mid_implementation
#> 6                         neutral -> neutral       planning mid_implementation
#> 7                  strong_barrier -> neutral       planning mid_implementation
#> 8           strong_barrier -> strong_barrier       planning mid_implementation
#> 9                         neutral -> neutral       planning mid_implementation
#> 10                 strong_barrier -> neutral       planning mid_implementation
#> 11                        neutral -> neutral       planning mid_implementation
#> 12             strong_facilitator -> neutral       planning mid_implementation
#> 13             neutral -> strong_facilitator       planning mid_implementation
#> 14                        neutral -> neutral       planning mid_implementation
#> 15      weak_facilitator -> weak_facilitator       planning mid_implementation
#> 16  strong_facilitator -> strong_facilitator       planning mid_implementation
#> 17               weak_facilitator -> neutral       planning mid_implementation
#> 18      weak_facilitator -> weak_facilitator       planning mid_implementation
#> 19      weak_facilitator -> weak_facilitator       planning mid_implementation
#> 20                 neutral -> strong_barrier       planning mid_implementation
#> 21          strong_barrier -> strong_barrier       planning mid_implementation
#> 22                 strong_barrier -> neutral       planning mid_implementation
#> 23                 strong_barrier -> neutral       planning mid_implementation
#> 24                 strong_barrier -> neutral       planning mid_implementation
#> 25                        neutral -> neutral       planning mid_implementation
#> 26  strong_facilitator -> strong_facilitator       planning mid_implementation
#> 27                        neutral -> neutral       planning mid_implementation
#> 28  strong_facilitator -> strong_facilitator       planning mid_implementation
#> 29  strong_facilitator -> strong_facilitator       planning mid_implementation
#> 30      weak_facilitator -> weak_facilitator       planning mid_implementation
#> 31                        neutral -> neutral       planning mid_implementation
#> 32               neutral -> weak_facilitator       planning mid_implementation
#> 33  strong_facilitator -> strong_facilitator       planning mid_implementation
#> 34                        neutral -> neutral       planning mid_implementation
#> 35                 strong_barrier -> neutral       planning mid_implementation
#> 36                        neutral -> neutral       planning mid_implementation
#> 37          strong_barrier -> strong_barrier       planning mid_implementation
#> 38                 strong_barrier -> neutral       planning mid_implementation
#> 39                   neutral -> weak_barrier       planning mid_implementation
#> 40  strong_facilitator -> strong_facilitator       planning mid_implementation
#> 41             neutral -> strong_facilitator       planning mid_implementation
#> 42             neutral -> strong_facilitator       planning mid_implementation
#> 43      weak_facilitator -> weak_facilitator       planning mid_implementation
#> 44      weak_facilitator -> weak_facilitator       planning mid_implementation
#> 45                        neutral -> neutral       planning mid_implementation
#> 46  strong_facilitator -> strong_facilitator       planning mid_implementation
#> 47               weak_facilitator -> neutral       planning mid_implementation
#> 48                        neutral -> neutral       planning mid_implementation
#> 49                 strong_barrier -> neutral       planning mid_implementation
#> 50          strong_barrier -> strong_barrier       planning mid_implementation
#> 51      strong_barrier -> strong_facilitator       planning mid_implementation
#> 52                 strong_barrier -> neutral       planning mid_implementation
#> 53                        neutral -> neutral       planning mid_implementation
#> 54  strong_facilitator -> strong_facilitator       planning mid_implementation
#> 55  strong_facilitator -> strong_facilitator       planning mid_implementation
#> 56                        neutral -> neutral       planning mid_implementation
#> 57      weak_facilitator -> weak_facilitator       planning mid_implementation
#> 58      weak_facilitator -> weak_facilitator       planning mid_implementation
#> 59      strong_barrier -> strong_facilitator       planning mid_implementation
#> 60      weak_facilitator -> weak_facilitator       planning mid_implementation
#> 61      weak_facilitator -> weak_facilitator       planning mid_implementation
#> 62                        neutral -> neutral       planning mid_implementation
#> 63                 neutral -> strong_barrier       planning mid_implementation
#> 64                 strong_barrier -> neutral       planning mid_implementation
#> 65                 strong_barrier -> neutral       planning mid_implementation
#> 66          strong_barrier -> strong_barrier       planning mid_implementation
#> 67                        neutral -> neutral       planning mid_implementation
#> 68  strong_facilitator -> strong_facilitator       planning mid_implementation
#> 69                        neutral -> neutral       planning mid_implementation
#> 70      strong_barrier -> strong_facilitator       planning mid_implementation
#> 71      weak_facilitator -> weak_facilitator       planning mid_implementation
#> 72  strong_facilitator -> strong_facilitator       planning mid_implementation
#> 73                        neutral -> neutral       planning mid_implementation
#> 74               weak_facilitator -> neutral       planning mid_implementation
#> 75      weak_facilitator -> weak_facilitator       planning mid_implementation
#> 76                        neutral -> neutral       planning mid_implementation
#> 77                 strong_barrier -> neutral       planning mid_implementation
#> 78      strong_barrier -> strong_facilitator       planning mid_implementation
#> 79          strong_barrier -> strong_barrier       planning mid_implementation
#> 80                 strong_barrier -> neutral       planning mid_implementation
#> 81                        neutral -> neutral       planning mid_implementation
#> 82  strong_facilitator -> strong_facilitator       planning mid_implementation
#> 83             neutral -> strong_facilitator       planning mid_implementation
#> 84             neutral -> strong_facilitator       planning mid_implementation
#> 85  strong_facilitator -> strong_facilitator       planning mid_implementation
#> 86               neutral -> weak_facilitator       planning mid_implementation
#> 87              weak_barrier -> weak_barrier       planning mid_implementation
#> 88      weak_facilitator -> weak_facilitator       planning mid_implementation
#> 89  strong_facilitator -> strong_facilitator       planning mid_implementation
#> 90               weak_facilitator -> neutral       planning mid_implementation
#> 91                 strong_barrier -> neutral       planning mid_implementation
#> 92          strong_barrier -> strong_barrier       planning mid_implementation
#> 93          strong_barrier -> strong_barrier       planning mid_implementation
#> 94                 strong_barrier -> neutral       planning mid_implementation
#> 95                        neutral -> neutral       planning mid_implementation
#> 96  strong_facilitator -> strong_facilitator       planning mid_implementation
#> 97      strong_barrier -> strong_facilitator       planning mid_implementation
#> 98          strong_barrier -> strong_barrier       planning mid_implementation
#> 99      weak_facilitator -> weak_facilitator       planning mid_implementation
#> 100     weak_facilitator -> weak_facilitator       planning mid_implementation
#> 101             weak_barrier -> weak_barrier       planning mid_implementation
#> 102 strong_facilitator -> strong_facilitator       planning mid_implementation
#> 103     weak_facilitator -> weak_facilitator       planning mid_implementation
#> 104                       neutral -> neutral       planning mid_implementation
#> 105                strong_barrier -> neutral       planning mid_implementation
#> 106                strong_barrier -> neutral       planning mid_implementation
#> 107                strong_barrier -> neutral       planning mid_implementation
#> 108         strong_barrier -> strong_barrier       planning mid_implementation
#> 109              weak_facilitator -> neutral       planning mid_implementation
#> 110 strong_facilitator -> strong_facilitator       planning mid_implementation
#> 111         strong_barrier -> strong_barrier       planning mid_implementation
#> 112         strong_barrier -> strong_barrier       planning mid_implementation
#> 113              neutral -> weak_facilitator       planning mid_implementation
#> 114     weak_facilitator -> weak_facilitator       planning mid_implementation
#> 115         strong_barrier -> strong_barrier       planning mid_implementation
#> 116     weak_facilitator -> weak_facilitator       planning mid_implementation
#> 117     weak_facilitator -> weak_facilitator       planning mid_implementation
#> 118                       neutral -> neutral       planning mid_implementation
#> 119                strong_barrier -> neutral       planning mid_implementation
#> 120         strong_barrier -> strong_barrier       planning mid_implementation
#> 121         strong_barrier -> strong_barrier       planning mid_implementation
#> 122                strong_barrier -> neutral       planning mid_implementation
#> 123                       neutral -> neutral       planning mid_implementation
#> 124            neutral -> strong_facilitator       planning mid_implementation
#> 125                strong_barrier -> neutral       planning mid_implementation
#> 126                strong_barrier -> neutral       planning mid_implementation
#> 127     weak_facilitator -> weak_facilitator       planning mid_implementation
#> 128            strong_facilitator -> neutral       planning mid_implementation
#> 129             weak_barrier -> weak_barrier       planning mid_implementation
#> 130     weak_facilitator -> weak_facilitator       planning mid_implementation
#> 131     weak_facilitator -> weak_facilitator       planning mid_implementation
#> 132     strong_barrier -> strong_facilitator       planning mid_implementation
#> 133                strong_barrier -> neutral       planning mid_implementation
#> 134         strong_barrier -> strong_barrier       planning mid_implementation
#> 135                strong_barrier -> neutral       planning mid_implementation
#> 136                       neutral -> neutral       planning mid_implementation
#> 137                       neutral -> neutral       planning mid_implementation
#> 138 strong_facilitator -> strong_facilitator       planning mid_implementation
#> 139         strong_barrier -> strong_barrier       planning mid_implementation
#> 140         strong_barrier -> strong_barrier       planning mid_implementation
#> 141 strong_facilitator -> strong_facilitator       planning mid_implementation
#> 142     weak_facilitator -> weak_facilitator       planning mid_implementation
#> 143             weak_barrier -> weak_barrier       planning mid_implementation
#> 144     weak_facilitator -> weak_facilitator       planning mid_implementation
#> 145 strong_facilitator -> strong_facilitator       planning mid_implementation
#> 146                       neutral -> neutral       planning mid_implementation
#> 147         strong_barrier -> strong_barrier       planning mid_implementation
#> 148                strong_barrier -> neutral       planning mid_implementation
#> 149                strong_barrier -> neutral       planning mid_implementation
#> 150         strong_barrier -> strong_barrier       planning mid_implementation
#> 151         weak_barrier -> weak_facilitator       planning mid_implementation
#> 152 strong_facilitator -> strong_facilitator       planning mid_implementation
#> 153         strong_barrier -> strong_barrier       planning mid_implementation
#> 154                strong_barrier -> neutral       planning mid_implementation
#> 155              weak_facilitator -> neutral       planning mid_implementation
#> 156     weak_facilitator -> weak_facilitator       planning mid_implementation
#> 157             weak_barrier -> weak_barrier       planning mid_implementation
#> 158 strong_facilitator -> strong_facilitator       planning mid_implementation
#> 159              neutral -> weak_facilitator       planning mid_implementation
#> 160                       neutral -> neutral       planning mid_implementation
#> 161                strong_barrier -> neutral       planning mid_implementation
#> 162                strong_barrier -> neutral       planning mid_implementation
#> 163                neutral -> strong_barrier       planning mid_implementation
#> 164                strong_barrier -> neutral       planning mid_implementation
#> 165                       neutral -> neutral       planning mid_implementation
#> 166            strong_facilitator -> neutral       planning mid_implementation
#> 167                strong_barrier -> neutral       planning mid_implementation
#> 168                strong_barrier -> neutral       planning mid_implementation
#>                                                                                                       item_text
#> 1   People here regularly seek to understand the needs of patients and make changes to better meet those needs.
#> 2                                   I have open lines of communication with everyone needed to make the change.
#> 3                                                      I have access to data to help track changes in outcomes.
#> 4                                                                  The change is aligned with leadership goals.
#> 5                                                                  The change is aligned with clinician values.
#> 6                                                    The change is compatible with existing clinical processes.
#> 7                                       The structures and policies in place here enable us to make the change.
#> 8                                                           We have sufficient space to accommodate the change.
#> 9                                                         We have sufficient time dedicated to make the change.
#> 10                            We have other needed resources to make the change (staff, money, supplies, etc.).
#> 11                          People here see the current situation as intolerable and that the change is needed.
#> 12                      People here see the advantage of implementing this change versus an alternative change.
#> 13                   Higher level leaders are committed, involved, and accountable for the planned improvement.
#> 14       Leaders I work with most closely are committed, involved, and accountable for the planned improvement.
#> 15  People here regularly seek to understand the needs of patients and make changes to better meet those needs.
#> 16                                  I have open lines of communication with everyone needed to make the change.
#> 17                                                     I have access to data to help track changes in outcomes.
#> 18                                                                 The change is aligned with leadership goals.
#> 19                                                                 The change is aligned with clinician values.
#> 20                                                   The change is compatible with existing clinical processes.
#> 21                                      The structures and policies in place here enable us to make the change.
#> 22                                                          We have sufficient space to accommodate the change.
#> 23                                                        We have sufficient time dedicated to make the change.
#> 24                            We have other needed resources to make the change (staff, money, supplies, etc.).
#> 25                          People here see the current situation as intolerable and that the change is needed.
#> 26                      People here see the advantage of implementing this change versus an alternative change.
#> 27                   Higher level leaders are committed, involved, and accountable for the planned improvement.
#> 28       Leaders I work with most closely are committed, involved, and accountable for the planned improvement.
#> 29  People here regularly seek to understand the needs of patients and make changes to better meet those needs.
#> 30                                  I have open lines of communication with everyone needed to make the change.
#> 31                                                     I have access to data to help track changes in outcomes.
#> 32                                                                 The change is aligned with leadership goals.
#> 33                                                                 The change is aligned with clinician values.
#> 34                                                   The change is compatible with existing clinical processes.
#> 35                                      The structures and policies in place here enable us to make the change.
#> 36                                                          We have sufficient space to accommodate the change.
#> 37                                                        We have sufficient time dedicated to make the change.
#> 38                            We have other needed resources to make the change (staff, money, supplies, etc.).
#> 39                          People here see the current situation as intolerable and that the change is needed.
#> 40                      People here see the advantage of implementing this change versus an alternative change.
#> 41                   Higher level leaders are committed, involved, and accountable for the planned improvement.
#> 42       Leaders I work with most closely are committed, involved, and accountable for the planned improvement.
#> 43  People here regularly seek to understand the needs of patients and make changes to better meet those needs.
#> 44                                  I have open lines of communication with everyone needed to make the change.
#> 45                                                     I have access to data to help track changes in outcomes.
#> 46                                                                 The change is aligned with leadership goals.
#> 47                                                                 The change is aligned with clinician values.
#> 48                                                   The change is compatible with existing clinical processes.
#> 49                                      The structures and policies in place here enable us to make the change.
#> 50                                                          We have sufficient space to accommodate the change.
#> 51                                                        We have sufficient time dedicated to make the change.
#> 52                            We have other needed resources to make the change (staff, money, supplies, etc.).
#> 53                          People here see the current situation as intolerable and that the change is needed.
#> 54                      People here see the advantage of implementing this change versus an alternative change.
#> 55                   Higher level leaders are committed, involved, and accountable for the planned improvement.
#> 56       Leaders I work with most closely are committed, involved, and accountable for the planned improvement.
#> 57  People here regularly seek to understand the needs of patients and make changes to better meet those needs.
#> 58                                  I have open lines of communication with everyone needed to make the change.
#> 59                                                     I have access to data to help track changes in outcomes.
#> 60                                                                 The change is aligned with leadership goals.
#> 61                                                                 The change is aligned with clinician values.
#> 62                                                   The change is compatible with existing clinical processes.
#> 63                                      The structures and policies in place here enable us to make the change.
#> 64                                                          We have sufficient space to accommodate the change.
#> 65                                                        We have sufficient time dedicated to make the change.
#> 66                            We have other needed resources to make the change (staff, money, supplies, etc.).
#> 67                          People here see the current situation as intolerable and that the change is needed.
#> 68                      People here see the advantage of implementing this change versus an alternative change.
#> 69                   Higher level leaders are committed, involved, and accountable for the planned improvement.
#> 70       Leaders I work with most closely are committed, involved, and accountable for the planned improvement.
#> 71  People here regularly seek to understand the needs of patients and make changes to better meet those needs.
#> 72                                  I have open lines of communication with everyone needed to make the change.
#> 73                                                     I have access to data to help track changes in outcomes.
#> 74                                                                 The change is aligned with leadership goals.
#> 75                                                                 The change is aligned with clinician values.
#> 76                                                   The change is compatible with existing clinical processes.
#> 77                                      The structures and policies in place here enable us to make the change.
#> 78                                                          We have sufficient space to accommodate the change.
#> 79                                                        We have sufficient time dedicated to make the change.
#> 80                            We have other needed resources to make the change (staff, money, supplies, etc.).
#> 81                          People here see the current situation as intolerable and that the change is needed.
#> 82                      People here see the advantage of implementing this change versus an alternative change.
#> 83                   Higher level leaders are committed, involved, and accountable for the planned improvement.
#> 84       Leaders I work with most closely are committed, involved, and accountable for the planned improvement.
#> 85  People here regularly seek to understand the needs of patients and make changes to better meet those needs.
#> 86                                  I have open lines of communication with everyone needed to make the change.
#> 87                                                     I have access to data to help track changes in outcomes.
#> 88                                                                 The change is aligned with leadership goals.
#> 89                                                                 The change is aligned with clinician values.
#> 90                                                   The change is compatible with existing clinical processes.
#> 91                                      The structures and policies in place here enable us to make the change.
#> 92                                                          We have sufficient space to accommodate the change.
#> 93                                                        We have sufficient time dedicated to make the change.
#> 94                            We have other needed resources to make the change (staff, money, supplies, etc.).
#> 95                          People here see the current situation as intolerable and that the change is needed.
#> 96                      People here see the advantage of implementing this change versus an alternative change.
#> 97                   Higher level leaders are committed, involved, and accountable for the planned improvement.
#> 98       Leaders I work with most closely are committed, involved, and accountable for the planned improvement.
#> 99  People here regularly seek to understand the needs of patients and make changes to better meet those needs.
#> 100                                 I have open lines of communication with everyone needed to make the change.
#> 101                                                    I have access to data to help track changes in outcomes.
#> 102                                                                The change is aligned with leadership goals.
#> 103                                                                The change is aligned with clinician values.
#> 104                                                  The change is compatible with existing clinical processes.
#> 105                                     The structures and policies in place here enable us to make the change.
#> 106                                                         We have sufficient space to accommodate the change.
#> 107                                                       We have sufficient time dedicated to make the change.
#> 108                           We have other needed resources to make the change (staff, money, supplies, etc.).
#> 109                         People here see the current situation as intolerable and that the change is needed.
#> 110                     People here see the advantage of implementing this change versus an alternative change.
#> 111                  Higher level leaders are committed, involved, and accountable for the planned improvement.
#> 112      Leaders I work with most closely are committed, involved, and accountable for the planned improvement.
#> 113 People here regularly seek to understand the needs of patients and make changes to better meet those needs.
#> 114                                 I have open lines of communication with everyone needed to make the change.
#> 115                                                    I have access to data to help track changes in outcomes.
#> 116                                                                The change is aligned with leadership goals.
#> 117                                                                The change is aligned with clinician values.
#> 118                                                  The change is compatible with existing clinical processes.
#> 119                                     The structures and policies in place here enable us to make the change.
#> 120                                                         We have sufficient space to accommodate the change.
#> 121                                                       We have sufficient time dedicated to make the change.
#> 122                           We have other needed resources to make the change (staff, money, supplies, etc.).
#> 123                         People here see the current situation as intolerable and that the change is needed.
#> 124                     People here see the advantage of implementing this change versus an alternative change.
#> 125                  Higher level leaders are committed, involved, and accountable for the planned improvement.
#> 126      Leaders I work with most closely are committed, involved, and accountable for the planned improvement.
#> 127 People here regularly seek to understand the needs of patients and make changes to better meet those needs.
#> 128                                 I have open lines of communication with everyone needed to make the change.
#> 129                                                    I have access to data to help track changes in outcomes.
#> 130                                                                The change is aligned with leadership goals.
#> 131                                                                The change is aligned with clinician values.
#> 132                                                  The change is compatible with existing clinical processes.
#> 133                                     The structures and policies in place here enable us to make the change.
#> 134                                                         We have sufficient space to accommodate the change.
#> 135                                                       We have sufficient time dedicated to make the change.
#> 136                           We have other needed resources to make the change (staff, money, supplies, etc.).
#> 137                         People here see the current situation as intolerable and that the change is needed.
#> 138                     People here see the advantage of implementing this change versus an alternative change.
#> 139                  Higher level leaders are committed, involved, and accountable for the planned improvement.
#> 140      Leaders I work with most closely are committed, involved, and accountable for the planned improvement.
#> 141 People here regularly seek to understand the needs of patients and make changes to better meet those needs.
#> 142                                 I have open lines of communication with everyone needed to make the change.
#> 143                                                    I have access to data to help track changes in outcomes.
#> 144                                                                The change is aligned with leadership goals.
#> 145                                                                The change is aligned with clinician values.
#> 146                                                  The change is compatible with existing clinical processes.
#> 147                                     The structures and policies in place here enable us to make the change.
#> 148                                                         We have sufficient space to accommodate the change.
#> 149                                                       We have sufficient time dedicated to make the change.
#> 150                           We have other needed resources to make the change (staff, money, supplies, etc.).
#> 151                         People here see the current situation as intolerable and that the change is needed.
#> 152                     People here see the advantage of implementing this change versus an alternative change.
#> 153                  Higher level leaders are committed, involved, and accountable for the planned improvement.
#> 154      Leaders I work with most closely are committed, involved, and accountable for the planned improvement.
#> 155 People here regularly seek to understand the needs of patients and make changes to better meet those needs.
#> 156                                 I have open lines of communication with everyone needed to make the change.
#> 157                                                    I have access to data to help track changes in outcomes.
#> 158                                                                The change is aligned with leadership goals.
#> 159                                                                The change is aligned with clinician values.
#> 160                                                  The change is compatible with existing clinical processes.
#> 161                                     The structures and policies in place here enable us to make the change.
#> 162                                                         We have sufficient space to accommodate the change.
#> 163                                                       We have sufficient time dedicated to make the change.
#> 164                           We have other needed resources to make the change (staff, money, supplies, etc.).
#> 165                         People here see the current situation as intolerable and that the change is needed.
#> 166                     People here see the advantage of implementing this change versus an alternative change.
#> 167                  Higher level leaders are committed, involved, and accountable for the planned improvement.
#> 168      Leaders I work with most closely are committed, involved, and accountable for the planned improvement.
#>        cfir_original_construct                             cfir_2022_construct
#> 1    Patient Needs & Resources                 Culture: Recipient-Centeredness
#> 2    Networks & Communications                                  Communications
#> 3      Reflecting & Evaluating                         Reflecting & Evaluating
#> 4             Goals & Feedback                               Mission Alignment
#> 5                Compatibility               Innovation Deliverers: Capability
#> 6                Compatibility                                   Compatibility
#> 7   Structural Characteristics Structural Characteristics: Work Infrastructure
#> 8          Available Resources                      Available Resources: Space
#> 9          Available Resources              Innovation Deliverers: Opportunity
#> 10         Available Resources      Available Resources: Materials & Equipment
#> 11          Tension for Change                              Tension for Change
#> 12          Relative Advantage                   Innovation Relative Advantage
#> 13       Leadership Engagement                  High-Level Leaders: Motivation
#> 14       Leadership Engagement                   Mid-Level Leaders: Motivation
#> 15   Patient Needs & Resources                 Culture: Recipient-Centeredness
#> 16   Networks & Communications                                  Communications
#> 17     Reflecting & Evaluating                         Reflecting & Evaluating
#> 18            Goals & Feedback                               Mission Alignment
#> 19               Compatibility               Innovation Deliverers: Capability
#> 20               Compatibility                                   Compatibility
#> 21  Structural Characteristics Structural Characteristics: Work Infrastructure
#> 22         Available Resources                      Available Resources: Space
#> 23         Available Resources              Innovation Deliverers: Opportunity
#> 24         Available Resources      Available Resources: Materials & Equipment
#> 25          Tension for Change                              Tension for Change
#> 26          Relative Advantage                   Innovation Relative Advantage
#> 27       Leadership Engagement                  High-Level Leaders: Motivation
#> 28       Leadership Engagement                   Mid-Level Leaders: Motivation
#> 29   Patient Needs & Resources                 Culture: Recipient-Centeredness
#> 30   Networks & Communications                                  Communications
#> 31     Reflecting & Evaluating                         Reflecting & Evaluating
#> 32            Goals & Feedback                               Mission Alignment
#> 33               Compatibility               Innovation Deliverers: Capability
#> 34               Compatibility                                   Compatibility
#> 35  Structural Characteristics Structural Characteristics: Work Infrastructure
#> 36         Available Resources                      Available Resources: Space
#> 37         Available Resources              Innovation Deliverers: Opportunity
#> 38         Available Resources      Available Resources: Materials & Equipment
#> 39          Tension for Change                              Tension for Change
#> 40          Relative Advantage                   Innovation Relative Advantage
#> 41       Leadership Engagement                  High-Level Leaders: Motivation
#> 42       Leadership Engagement                   Mid-Level Leaders: Motivation
#> 43   Patient Needs & Resources                 Culture: Recipient-Centeredness
#> 44   Networks & Communications                                  Communications
#> 45     Reflecting & Evaluating                         Reflecting & Evaluating
#> 46            Goals & Feedback                               Mission Alignment
#> 47               Compatibility               Innovation Deliverers: Capability
#> 48               Compatibility                                   Compatibility
#> 49  Structural Characteristics Structural Characteristics: Work Infrastructure
#> 50         Available Resources                      Available Resources: Space
#> 51         Available Resources              Innovation Deliverers: Opportunity
#> 52         Available Resources      Available Resources: Materials & Equipment
#> 53          Tension for Change                              Tension for Change
#> 54          Relative Advantage                   Innovation Relative Advantage
#> 55       Leadership Engagement                  High-Level Leaders: Motivation
#> 56       Leadership Engagement                   Mid-Level Leaders: Motivation
#> 57   Patient Needs & Resources                 Culture: Recipient-Centeredness
#> 58   Networks & Communications                                  Communications
#> 59     Reflecting & Evaluating                         Reflecting & Evaluating
#> 60            Goals & Feedback                               Mission Alignment
#> 61               Compatibility               Innovation Deliverers: Capability
#> 62               Compatibility                                   Compatibility
#> 63  Structural Characteristics Structural Characteristics: Work Infrastructure
#> 64         Available Resources                      Available Resources: Space
#> 65         Available Resources              Innovation Deliverers: Opportunity
#> 66         Available Resources      Available Resources: Materials & Equipment
#> 67          Tension for Change                              Tension for Change
#> 68          Relative Advantage                   Innovation Relative Advantage
#> 69       Leadership Engagement                  High-Level Leaders: Motivation
#> 70       Leadership Engagement                   Mid-Level Leaders: Motivation
#> 71   Patient Needs & Resources                 Culture: Recipient-Centeredness
#> 72   Networks & Communications                                  Communications
#> 73     Reflecting & Evaluating                         Reflecting & Evaluating
#> 74            Goals & Feedback                               Mission Alignment
#> 75               Compatibility               Innovation Deliverers: Capability
#> 76               Compatibility                                   Compatibility
#> 77  Structural Characteristics Structural Characteristics: Work Infrastructure
#> 78         Available Resources                      Available Resources: Space
#> 79         Available Resources              Innovation Deliverers: Opportunity
#> 80         Available Resources      Available Resources: Materials & Equipment
#> 81          Tension for Change                              Tension for Change
#> 82          Relative Advantage                   Innovation Relative Advantage
#> 83       Leadership Engagement                  High-Level Leaders: Motivation
#> 84       Leadership Engagement                   Mid-Level Leaders: Motivation
#> 85   Patient Needs & Resources                 Culture: Recipient-Centeredness
#> 86   Networks & Communications                                  Communications
#> 87     Reflecting & Evaluating                         Reflecting & Evaluating
#> 88            Goals & Feedback                               Mission Alignment
#> 89               Compatibility               Innovation Deliverers: Capability
#> 90               Compatibility                                   Compatibility
#> 91  Structural Characteristics Structural Characteristics: Work Infrastructure
#> 92         Available Resources                      Available Resources: Space
#> 93         Available Resources              Innovation Deliverers: Opportunity
#> 94         Available Resources      Available Resources: Materials & Equipment
#> 95          Tension for Change                              Tension for Change
#> 96          Relative Advantage                   Innovation Relative Advantage
#> 97       Leadership Engagement                  High-Level Leaders: Motivation
#> 98       Leadership Engagement                   Mid-Level Leaders: Motivation
#> 99   Patient Needs & Resources                 Culture: Recipient-Centeredness
#> 100  Networks & Communications                                  Communications
#> 101    Reflecting & Evaluating                         Reflecting & Evaluating
#> 102           Goals & Feedback                               Mission Alignment
#> 103              Compatibility               Innovation Deliverers: Capability
#> 104              Compatibility                                   Compatibility
#> 105 Structural Characteristics Structural Characteristics: Work Infrastructure
#> 106        Available Resources                      Available Resources: Space
#> 107        Available Resources              Innovation Deliverers: Opportunity
#> 108        Available Resources      Available Resources: Materials & Equipment
#> 109         Tension for Change                              Tension for Change
#> 110         Relative Advantage                   Innovation Relative Advantage
#> 111      Leadership Engagement                  High-Level Leaders: Motivation
#> 112      Leadership Engagement                   Mid-Level Leaders: Motivation
#> 113  Patient Needs & Resources                 Culture: Recipient-Centeredness
#> 114  Networks & Communications                                  Communications
#> 115    Reflecting & Evaluating                         Reflecting & Evaluating
#> 116           Goals & Feedback                               Mission Alignment
#> 117              Compatibility               Innovation Deliverers: Capability
#> 118              Compatibility                                   Compatibility
#> 119 Structural Characteristics Structural Characteristics: Work Infrastructure
#> 120        Available Resources                      Available Resources: Space
#> 121        Available Resources              Innovation Deliverers: Opportunity
#> 122        Available Resources      Available Resources: Materials & Equipment
#> 123         Tension for Change                              Tension for Change
#> 124         Relative Advantage                   Innovation Relative Advantage
#> 125      Leadership Engagement                  High-Level Leaders: Motivation
#> 126      Leadership Engagement                   Mid-Level Leaders: Motivation
#> 127  Patient Needs & Resources                 Culture: Recipient-Centeredness
#> 128  Networks & Communications                                  Communications
#> 129    Reflecting & Evaluating                         Reflecting & Evaluating
#> 130           Goals & Feedback                               Mission Alignment
#> 131              Compatibility               Innovation Deliverers: Capability
#> 132              Compatibility                                   Compatibility
#> 133 Structural Characteristics Structural Characteristics: Work Infrastructure
#> 134        Available Resources                      Available Resources: Space
#> 135        Available Resources              Innovation Deliverers: Opportunity
#> 136        Available Resources      Available Resources: Materials & Equipment
#> 137         Tension for Change                              Tension for Change
#> 138         Relative Advantage                   Innovation Relative Advantage
#> 139      Leadership Engagement                  High-Level Leaders: Motivation
#> 140      Leadership Engagement                   Mid-Level Leaders: Motivation
#> 141  Patient Needs & Resources                 Culture: Recipient-Centeredness
#> 142  Networks & Communications                                  Communications
#> 143    Reflecting & Evaluating                         Reflecting & Evaluating
#> 144           Goals & Feedback                               Mission Alignment
#> 145              Compatibility               Innovation Deliverers: Capability
#> 146              Compatibility                                   Compatibility
#> 147 Structural Characteristics Structural Characteristics: Work Infrastructure
#> 148        Available Resources                      Available Resources: Space
#> 149        Available Resources              Innovation Deliverers: Opportunity
#> 150        Available Resources      Available Resources: Materials & Equipment
#> 151         Tension for Change                              Tension for Change
#> 152         Relative Advantage                   Innovation Relative Advantage
#> 153      Leadership Engagement                  High-Level Leaders: Motivation
#> 154      Leadership Engagement                   Mid-Level Leaders: Motivation
#> 155  Patient Needs & Resources                 Culture: Recipient-Centeredness
#> 156  Networks & Communications                                  Communications
#> 157    Reflecting & Evaluating                         Reflecting & Evaluating
#> 158           Goals & Feedback                               Mission Alignment
#> 159              Compatibility               Innovation Deliverers: Capability
#> 160              Compatibility                                   Compatibility
#> 161 Structural Characteristics Structural Characteristics: Work Infrastructure
#> 162        Available Resources                      Available Resources: Space
#> 163        Available Resources              Innovation Deliverers: Opportunity
#> 164        Available Resources      Available Resources: Materials & Equipment
#> 165         Tension for Change                              Tension for Change
#> 166         Relative Advantage                   Innovation Relative Advantage
#> 167      Leadership Engagement                  High-Level Leaders: Motivation
#> 168      Leadership Engagement                   Mid-Level Leaders: Motivation

pcat_action_plan(
  summary,
  group_vars = c("site_id", "timepoint")
)
#>       cfir_original_construct site_id          timepoint item_id n_rows_input
#> 1  Structural Characteristics  SITE_A mid_implementation       7            6
#> 2         Available Resources  SITE_A mid_implementation       8            6
#> 3         Available Resources  SITE_A mid_implementation       8            6
#> 4         Available Resources  SITE_A mid_implementation       8            6
#> 5         Available Resources  SITE_A mid_implementation       9            6
#> 6         Available Resources  SITE_A mid_implementation       9            6
#> 7         Available Resources  SITE_A mid_implementation       9            6
#> 8         Available Resources  SITE_A           planning      10            6
#> 9         Available Resources  SITE_A           planning      10            6
#> 10        Available Resources  SITE_A           planning      10            6
#> 11 Structural Characteristics  SITE_A           planning       7            6
#> 12        Available Resources  SITE_A           planning       8            6
#> 13        Available Resources  SITE_A           planning       8            6
#> 14        Available Resources  SITE_A           planning       8            6
#> 15        Available Resources  SITE_A           planning       9            6
#> 16        Available Resources  SITE_A           planning       9            6
#> 17        Available Resources  SITE_A           planning       9            6
#> 18        Available Resources  SITE_B mid_implementation       8            6
#> 19        Available Resources  SITE_B mid_implementation       8            6
#> 20        Available Resources  SITE_B mid_implementation       8            6
#> 21        Available Resources  SITE_B mid_implementation       9            6
#> 22        Available Resources  SITE_B mid_implementation       9            6
#> 23        Available Resources  SITE_B mid_implementation       9            6
#> 24      Leadership Engagement  SITE_B mid_implementation      13            6
#> 25      Leadership Engagement  SITE_B mid_implementation      13            6
#> 26      Leadership Engagement  SITE_B mid_implementation      13            6
#> 27      Leadership Engagement  SITE_B mid_implementation      13            6
#> 28      Leadership Engagement  SITE_B mid_implementation      13            6
#> 29      Leadership Engagement  SITE_B mid_implementation      13            6
#> 30      Leadership Engagement  SITE_B mid_implementation      14            6
#> 31      Leadership Engagement  SITE_B mid_implementation      14            6
#> 32      Leadership Engagement  SITE_B mid_implementation      14            6
#> 33      Leadership Engagement  SITE_B mid_implementation      14            6
#> 34      Leadership Engagement  SITE_B mid_implementation      14            6
#> 35      Leadership Engagement  SITE_B mid_implementation      14            6
#> 36        Available Resources  SITE_B mid_implementation      10            6
#> 37        Available Resources  SITE_B mid_implementation      10            6
#> 38        Available Resources  SITE_B mid_implementation      10            6
#> 39    Reflecting & Evaluating  SITE_B mid_implementation       3            6
#> 40 Structural Characteristics  SITE_B           planning       7            6
#> 41        Available Resources  SITE_B           planning       8            6
#> 42        Available Resources  SITE_B           planning       8            6
#> 43        Available Resources  SITE_B           planning       8            6
#> 44      Leadership Engagement  SITE_B           planning      13            6
#> 45      Leadership Engagement  SITE_B           planning      13            6
#> 46      Leadership Engagement  SITE_B           planning      13            6
#> 47      Leadership Engagement  SITE_B           planning      13            6
#> 48      Leadership Engagement  SITE_B           planning      13            6
#> 49      Leadership Engagement  SITE_B           planning      13            6
#> 50      Leadership Engagement  SITE_B           planning      14            6
#> 51      Leadership Engagement  SITE_B           planning      14            6
#> 52      Leadership Engagement  SITE_B           planning      14            6
#> 53      Leadership Engagement  SITE_B           planning      14            6
#> 54      Leadership Engagement  SITE_B           planning      14            6
#> 55      Leadership Engagement  SITE_B           planning      14            6
#> 56        Available Resources  SITE_B           planning       9            6
#> 57        Available Resources  SITE_B           planning       9            6
#> 58        Available Resources  SITE_B           planning       9            6
#> 59        Available Resources  SITE_B           planning      10            6
#> 60        Available Resources  SITE_B           planning      10            6
#> 61        Available Resources  SITE_B           planning      10            6
#> 62    Reflecting & Evaluating  SITE_B           planning       3            6
#>    n_rows_eligible n_rows_excluded n_respondents n_valid_direction
#> 1                6               0             6                 6
#> 2                6               0             6                 6
#> 3                6               0             6                 6
#> 4                6               0             6                 6
#> 5                6               0             6                 6
#> 6                6               0             6                 6
#> 7                6               0             6                 6
#> 8                6               0             6                 6
#> 9                6               0             6                 6
#> 10               6               0             6                 6
#> 11               6               0             6                 6
#> 12               6               0             6                 6
#> 13               6               0             6                 6
#> 14               6               0             6                 6
#> 15               6               0             6                 6
#> 16               6               0             6                 6
#> 17               6               0             6                 6
#> 18               6               0             6                 6
#> 19               6               0             6                 6
#> 20               6               0             6                 6
#> 21               6               0             6                 6
#> 22               6               0             6                 6
#> 23               6               0             6                 6
#> 24               6               0             6                 6
#> 25               6               0             6                 6
#> 26               6               0             6                 6
#> 27               6               0             6                 6
#> 28               6               0             6                 6
#> 29               6               0             6                 6
#> 30               6               0             6                 6
#> 31               6               0             6                 6
#> 32               6               0             6                 6
#> 33               6               0             6                 6
#> 34               6               0             6                 6
#> 35               6               0             6                 6
#> 36               6               0             6                 6
#> 37               6               0             6                 6
#> 38               6               0             6                 6
#> 39               6               0             6                 6
#> 40               6               0             6                 6
#> 41               6               0             6                 6
#> 42               6               0             6                 6
#> 43               6               0             6                 6
#> 44               6               0             6                 6
#> 45               6               0             6                 6
#> 46               6               0             6                 6
#> 47               6               0             6                 6
#> 48               6               0             6                 6
#> 49               6               0             6                 6
#> 50               6               0             6                 6
#> 51               6               0             6                 6
#> 52               6               0             6                 6
#> 53               6               0             6                 6
#> 54               6               0             6                 6
#> 55               6               0             6                 6
#> 56               6               0             6                 6
#> 57               6               0             6                 6
#> 58               6               0             6                 6
#> 59               6               0             6                 6
#> 60               6               0             6                 6
#> 61               6               0             6                 6
#> 62               6               0             6                 6
#>    n_complete_class n_barrier n_neutral n_facilitator n_strong_barrier
#> 1                 6         2         4             0                2
#> 2                 6         2         3             1                2
#> 3                 6         2         3             1                2
#> 4                 6         2         3             1                2
#> 5                 6         2         3             1                2
#> 6                 6         2         3             1                2
#> 7                 6         2         3             1                2
#> 8                 6         6         0             0                6
#> 9                 6         6         0             0                6
#> 10                6         6         0             0                6
#> 11                6         5         1             0                5
#> 12                6         5         1             0                5
#> 13                6         5         1             0                5
#> 14                6         5         1             0                5
#> 15                6         5         1             0                5
#> 16                6         5         1             0                5
#> 17                6         5         1             0                5
#> 18                6         3         3             0                3
#> 19                6         3         3             0                3
#> 20                6         3         3             0                3
#> 21                6         3         3             0                3
#> 22                6         3         3             0                3
#> 23                6         3         3             0                3
#> 24                6         3         2             1                3
#> 25                6         3         2             1                3
#> 26                6         3         2             1                3
#> 27                6         3         2             1                3
#> 28                6         3         2             1                3
#> 29                6         3         2             1                3
#> 30                6         3         3             0                3
#> 31                6         3         3             0                3
#> 32                6         3         3             0                3
#> 33                6         3         3             0                3
#> 34                6         3         3             0                3
#> 35                6         3         3             0                3
#> 36                6         2         4             0                2
#> 37                6         2         4             0                2
#> 38                6         2         4             0                2
#> 39                6         6         0             0                1
#> 40                6         6         0             0                6
#> 41                6         6         0             0                6
#> 42                6         6         0             0                6
#> 43                6         6         0             0                6
#> 44                6         6         0             0                6
#> 45                6         6         0             0                6
#> 46                6         6         0             0                6
#> 47                6         6         0             0                6
#> 48                6         6         0             0                6
#> 49                6         6         0             0                6
#> 50                6         6         0             0                6
#> 51                6         6         0             0                6
#> 52                6         6         0             0                6
#> 53                6         6         0             0                6
#> 54                6         6         0             0                6
#> 55                6         6         0             0                6
#> 56                6         5         1             0                5
#> 57                6         5         1             0                5
#> 58                6         5         1             0                5
#> 59                6         5         1             0                5
#> 60                6         5         1             0                5
#> 61                6         5         1             0                5
#> 62                6         6         0             0                1
#>    n_weak_barrier n_barrier_effect_missing n_weak_facilitator
#> 1               0                        0                  0
#> 2               0                        0                  0
#> 3               0                        0                  0
#> 4               0                        0                  0
#> 5               0                        0                  0
#> 6               0                        0                  0
#> 7               0                        0                  0
#> 8               0                        0                  0
#> 9               0                        0                  0
#> 10              0                        0                  0
#> 11              0                        0                  0
#> 12              0                        0                  0
#> 13              0                        0                  0
#> 14              0                        0                  0
#> 15              0                        0                  0
#> 16              0                        0                  0
#> 17              0                        0                  0
#> 18              0                        0                  0
#> 19              0                        0                  0
#> 20              0                        0                  0
#> 21              0                        0                  0
#> 22              0                        0                  0
#> 23              0                        0                  0
#> 24              0                        0                  0
#> 25              0                        0                  0
#> 26              0                        0                  0
#> 27              0                        0                  0
#> 28              0                        0                  0
#> 29              0                        0                  0
#> 30              0                        0                  0
#> 31              0                        0                  0
#> 32              0                        0                  0
#> 33              0                        0                  0
#> 34              0                        0                  0
#> 35              0                        0                  0
#> 36              0                        0                  0
#> 37              0                        0                  0
#> 38              0                        0                  0
#> 39              5                        0                  0
#> 40              0                        0                  0
#> 41              0                        0                  0
#> 42              0                        0                  0
#> 43              0                        0                  0
#> 44              0                        0                  0
#> 45              0                        0                  0
#> 46              0                        0                  0
#> 47              0                        0                  0
#> 48              0                        0                  0
#> 49              0                        0                  0
#> 50              0                        0                  0
#> 51              0                        0                  0
#> 52              0                        0                  0
#> 53              0                        0                  0
#> 54              0                        0                  0
#> 55              0                        0                  0
#> 56              0                        0                  0
#> 57              0                        0                  0
#> 58              0                        0                  0
#> 59              0                        0                  0
#> 60              0                        0                  0
#> 61              0                        0                  0
#> 62              5                        0                  0
#>    n_strong_facilitator n_facilitator_effect_missing n_invalid_or_missing
#> 1                     0                            0                    0
#> 2                     1                            0                    0
#> 3                     1                            0                    0
#> 4                     1                            0                    0
#> 5                     1                            0                    0
#> 6                     1                            0                    0
#> 7                     1                            0                    0
#> 8                     0                            0                    0
#> 9                     0                            0                    0
#> 10                    0                            0                    0
#> 11                    0                            0                    0
#> 12                    0                            0                    0
#> 13                    0                            0                    0
#> 14                    0                            0                    0
#> 15                    0                            0                    0
#> 16                    0                            0                    0
#> 17                    0                            0                    0
#> 18                    0                            0                    0
#> 19                    0                            0                    0
#> 20                    0                            0                    0
#> 21                    0                            0                    0
#> 22                    0                            0                    0
#> 23                    0                            0                    0
#> 24                    1                            0                    0
#> 25                    1                            0                    0
#> 26                    1                            0                    0
#> 27                    1                            0                    0
#> 28                    1                            0                    0
#> 29                    1                            0                    0
#> 30                    0                            0                    0
#> 31                    0                            0                    0
#> 32                    0                            0                    0
#> 33                    0                            0                    0
#> 34                    0                            0                    0
#> 35                    0                            0                    0
#> 36                    0                            0                    0
#> 37                    0                            0                    0
#> 38                    0                            0                    0
#> 39                    0                            0                    0
#> 40                    0                            0                    0
#> 41                    0                            0                    0
#> 42                    0                            0                    0
#> 43                    0                            0                    0
#> 44                    0                            0                    0
#> 45                    0                            0                    0
#> 46                    0                            0                    0
#> 47                    0                            0                    0
#> 48                    0                            0                    0
#> 49                    0                            0                    0
#> 50                    0                            0                    0
#> 51                    0                            0                    0
#> 52                    0                            0                    0
#> 53                    0                            0                    0
#> 54                    0                            0                    0
#> 55                    0                            0                    0
#> 56                    0                            0                    0
#> 57                    0                            0                    0
#> 58                    0                            0                    0
#> 59                    0                            0                    0
#> 60                    0                            0                    0
#> 61                    0                            0                    0
#> 62                    0                            0                    0
#>       modal_class mean_display_code median_display_code pct_barrier pct_neutral
#> 1         neutral        -0.6666667                   0   0.3333333   0.6666667
#> 2         neutral        -0.3333333                   0   0.3333333   0.5000000
#> 3         neutral        -0.3333333                   0   0.3333333   0.5000000
#> 4         neutral        -0.3333333                   0   0.3333333   0.5000000
#> 5         neutral        -0.3333333                   0   0.3333333   0.5000000
#> 6         neutral        -0.3333333                   0   0.3333333   0.5000000
#> 7         neutral        -0.3333333                   0   0.3333333   0.5000000
#> 8  strong_barrier        -2.0000000                  -2   1.0000000   0.0000000
#> 9  strong_barrier        -2.0000000                  -2   1.0000000   0.0000000
#> 10 strong_barrier        -2.0000000                  -2   1.0000000   0.0000000
#> 11 strong_barrier        -1.6666667                  -2   0.8333333   0.1666667
#> 12 strong_barrier        -1.6666667                  -2   0.8333333   0.1666667
#> 13 strong_barrier        -1.6666667                  -2   0.8333333   0.1666667
#> 14 strong_barrier        -1.6666667                  -2   0.8333333   0.1666667
#> 15 strong_barrier        -1.6666667                  -2   0.8333333   0.1666667
#> 16 strong_barrier        -1.6666667                  -2   0.8333333   0.1666667
#> 17 strong_barrier        -1.6666667                  -2   0.8333333   0.1666667
#> 18            tie        -1.0000000                  -1   0.5000000   0.5000000
#> 19            tie        -1.0000000                  -1   0.5000000   0.5000000
#> 20            tie        -1.0000000                  -1   0.5000000   0.5000000
#> 21            tie        -1.0000000                  -1   0.5000000   0.5000000
#> 22            tie        -1.0000000                  -1   0.5000000   0.5000000
#> 23            tie        -1.0000000                  -1   0.5000000   0.5000000
#> 24 strong_barrier        -0.6666667                  -1   0.5000000   0.3333333
#> 25 strong_barrier        -0.6666667                  -1   0.5000000   0.3333333
#> 26 strong_barrier        -0.6666667                  -1   0.5000000   0.3333333
#> 27 strong_barrier        -0.6666667                  -1   0.5000000   0.3333333
#> 28 strong_barrier        -0.6666667                  -1   0.5000000   0.3333333
#> 29 strong_barrier        -0.6666667                  -1   0.5000000   0.3333333
#> 30            tie        -1.0000000                  -1   0.5000000   0.5000000
#> 31            tie        -1.0000000                  -1   0.5000000   0.5000000
#> 32            tie        -1.0000000                  -1   0.5000000   0.5000000
#> 33            tie        -1.0000000                  -1   0.5000000   0.5000000
#> 34            tie        -1.0000000                  -1   0.5000000   0.5000000
#> 35            tie        -1.0000000                  -1   0.5000000   0.5000000
#> 36        neutral        -0.6666667                   0   0.3333333   0.6666667
#> 37        neutral        -0.6666667                   0   0.3333333   0.6666667
#> 38        neutral        -0.6666667                   0   0.3333333   0.6666667
#> 39   weak_barrier        -1.1666667                  -1   1.0000000   0.0000000
#> 40 strong_barrier        -2.0000000                  -2   1.0000000   0.0000000
#> 41 strong_barrier        -2.0000000                  -2   1.0000000   0.0000000
#> 42 strong_barrier        -2.0000000                  -2   1.0000000   0.0000000
#> 43 strong_barrier        -2.0000000                  -2   1.0000000   0.0000000
#> 44 strong_barrier        -2.0000000                  -2   1.0000000   0.0000000
#> 45 strong_barrier        -2.0000000                  -2   1.0000000   0.0000000
#> 46 strong_barrier        -2.0000000                  -2   1.0000000   0.0000000
#> 47 strong_barrier        -2.0000000                  -2   1.0000000   0.0000000
#> 48 strong_barrier        -2.0000000                  -2   1.0000000   0.0000000
#> 49 strong_barrier        -2.0000000                  -2   1.0000000   0.0000000
#> 50 strong_barrier        -2.0000000                  -2   1.0000000   0.0000000
#> 51 strong_barrier        -2.0000000                  -2   1.0000000   0.0000000
#> 52 strong_barrier        -2.0000000                  -2   1.0000000   0.0000000
#> 53 strong_barrier        -2.0000000                  -2   1.0000000   0.0000000
#> 54 strong_barrier        -2.0000000                  -2   1.0000000   0.0000000
#> 55 strong_barrier        -2.0000000                  -2   1.0000000   0.0000000
#> 56 strong_barrier        -1.6666667                  -2   0.8333333   0.1666667
#> 57 strong_barrier        -1.6666667                  -2   0.8333333   0.1666667
#> 58 strong_barrier        -1.6666667                  -2   0.8333333   0.1666667
#> 59 strong_barrier        -1.6666667                  -2   0.8333333   0.1666667
#> 60 strong_barrier        -1.6666667                  -2   0.8333333   0.1666667
#> 61 strong_barrier        -1.6666667                  -2   0.8333333   0.1666667
#> 62   weak_barrier        -1.1666667                  -1   1.0000000   0.0000000
#>    pct_facilitator pct_strong_barrier pct_weak_barrier pct_neutral_complete
#> 1        0.0000000          0.3333333        0.0000000            0.6666667
#> 2        0.1666667          0.3333333        0.0000000            0.5000000
#> 3        0.1666667          0.3333333        0.0000000            0.5000000
#> 4        0.1666667          0.3333333        0.0000000            0.5000000
#> 5        0.1666667          0.3333333        0.0000000            0.5000000
#> 6        0.1666667          0.3333333        0.0000000            0.5000000
#> 7        0.1666667          0.3333333        0.0000000            0.5000000
#> 8        0.0000000          1.0000000        0.0000000            0.0000000
#> 9        0.0000000          1.0000000        0.0000000            0.0000000
#> 10       0.0000000          1.0000000        0.0000000            0.0000000
#> 11       0.0000000          0.8333333        0.0000000            0.1666667
#> 12       0.0000000          0.8333333        0.0000000            0.1666667
#> 13       0.0000000          0.8333333        0.0000000            0.1666667
#> 14       0.0000000          0.8333333        0.0000000            0.1666667
#> 15       0.0000000          0.8333333        0.0000000            0.1666667
#> 16       0.0000000          0.8333333        0.0000000            0.1666667
#> 17       0.0000000          0.8333333        0.0000000            0.1666667
#> 18       0.0000000          0.5000000        0.0000000            0.5000000
#> 19       0.0000000          0.5000000        0.0000000            0.5000000
#> 20       0.0000000          0.5000000        0.0000000            0.5000000
#> 21       0.0000000          0.5000000        0.0000000            0.5000000
#> 22       0.0000000          0.5000000        0.0000000            0.5000000
#> 23       0.0000000          0.5000000        0.0000000            0.5000000
#> 24       0.1666667          0.5000000        0.0000000            0.3333333
#> 25       0.1666667          0.5000000        0.0000000            0.3333333
#> 26       0.1666667          0.5000000        0.0000000            0.3333333
#> 27       0.1666667          0.5000000        0.0000000            0.3333333
#> 28       0.1666667          0.5000000        0.0000000            0.3333333
#> 29       0.1666667          0.5000000        0.0000000            0.3333333
#> 30       0.0000000          0.5000000        0.0000000            0.5000000
#> 31       0.0000000          0.5000000        0.0000000            0.5000000
#> 32       0.0000000          0.5000000        0.0000000            0.5000000
#> 33       0.0000000          0.5000000        0.0000000            0.5000000
#> 34       0.0000000          0.5000000        0.0000000            0.5000000
#> 35       0.0000000          0.5000000        0.0000000            0.5000000
#> 36       0.0000000          0.3333333        0.0000000            0.6666667
#> 37       0.0000000          0.3333333        0.0000000            0.6666667
#> 38       0.0000000          0.3333333        0.0000000            0.6666667
#> 39       0.0000000          0.1666667        0.8333333            0.0000000
#> 40       0.0000000          1.0000000        0.0000000            0.0000000
#> 41       0.0000000          1.0000000        0.0000000            0.0000000
#> 42       0.0000000          1.0000000        0.0000000            0.0000000
#> 43       0.0000000          1.0000000        0.0000000            0.0000000
#> 44       0.0000000          1.0000000        0.0000000            0.0000000
#> 45       0.0000000          1.0000000        0.0000000            0.0000000
#> 46       0.0000000          1.0000000        0.0000000            0.0000000
#> 47       0.0000000          1.0000000        0.0000000            0.0000000
#> 48       0.0000000          1.0000000        0.0000000            0.0000000
#> 49       0.0000000          1.0000000        0.0000000            0.0000000
#> 50       0.0000000          1.0000000        0.0000000            0.0000000
#> 51       0.0000000          1.0000000        0.0000000            0.0000000
#> 52       0.0000000          1.0000000        0.0000000            0.0000000
#> 53       0.0000000          1.0000000        0.0000000            0.0000000
#> 54       0.0000000          1.0000000        0.0000000            0.0000000
#> 55       0.0000000          1.0000000        0.0000000            0.0000000
#> 56       0.0000000          0.8333333        0.0000000            0.1666667
#> 57       0.0000000          0.8333333        0.0000000            0.1666667
#> 58       0.0000000          0.8333333        0.0000000            0.1666667
#> 59       0.0000000          0.8333333        0.0000000            0.1666667
#> 60       0.0000000          0.8333333        0.0000000            0.1666667
#> 61       0.0000000          0.8333333        0.0000000            0.1666667
#> 62       0.0000000          0.1666667        0.8333333            0.0000000
#>    pct_strong_facilitator pct_weak_facilitator pct_effect_missing modal_class_n
#> 1               0.0000000                    0                  0             4
#> 2               0.1666667                    0                  0             3
#> 3               0.1666667                    0                  0             3
#> 4               0.1666667                    0                  0             3
#> 5               0.1666667                    0                  0             3
#> 6               0.1666667                    0                  0             3
#> 7               0.1666667                    0                  0             3
#> 8               0.0000000                    0                  0             6
#> 9               0.0000000                    0                  0             6
#> 10              0.0000000                    0                  0             6
#> 11              0.0000000                    0                  0             5
#> 12              0.0000000                    0                  0             5
#> 13              0.0000000                    0                  0             5
#> 14              0.0000000                    0                  0             5
#> 15              0.0000000                    0                  0             5
#> 16              0.0000000                    0                  0             5
#> 17              0.0000000                    0                  0             5
#> 18              0.0000000                    0                  0            NA
#> 19              0.0000000                    0                  0            NA
#> 20              0.0000000                    0                  0            NA
#> 21              0.0000000                    0                  0            NA
#> 22              0.0000000                    0                  0            NA
#> 23              0.0000000                    0                  0            NA
#> 24              0.1666667                    0                  0             3
#> 25              0.1666667                    0                  0             3
#> 26              0.1666667                    0                  0             3
#> 27              0.1666667                    0                  0             3
#> 28              0.1666667                    0                  0             3
#> 29              0.1666667                    0                  0             3
#> 30              0.0000000                    0                  0            NA
#> 31              0.0000000                    0                  0            NA
#> 32              0.0000000                    0                  0            NA
#> 33              0.0000000                    0                  0            NA
#> 34              0.0000000                    0                  0            NA
#> 35              0.0000000                    0                  0            NA
#> 36              0.0000000                    0                  0             4
#> 37              0.0000000                    0                  0             4
#> 38              0.0000000                    0                  0             4
#> 39              0.0000000                    0                  0             5
#> 40              0.0000000                    0                  0             6
#> 41              0.0000000                    0                  0             6
#> 42              0.0000000                    0                  0             6
#> 43              0.0000000                    0                  0             6
#> 44              0.0000000                    0                  0             6
#> 45              0.0000000                    0                  0             6
#> 46              0.0000000                    0                  0             6
#> 47              0.0000000                    0                  0             6
#> 48              0.0000000                    0                  0             6
#> 49              0.0000000                    0                  0             6
#> 50              0.0000000                    0                  0             6
#> 51              0.0000000                    0                  0             6
#> 52              0.0000000                    0                  0             6
#> 53              0.0000000                    0                  0             6
#> 54              0.0000000                    0                  0             6
#> 55              0.0000000                    0                  0             6
#> 56              0.0000000                    0                  0             5
#> 57              0.0000000                    0                  0             5
#> 58              0.0000000                    0                  0             5
#> 59              0.0000000                    0                  0             5
#> 60              0.0000000                    0                  0             5
#> 61              0.0000000                    0                  0             5
#> 62              0.0000000                    0                  0             5
#>    modal_class_share             item_key
#> 1          0.6666667  structures_policies
#> 2          0.5000000                space
#> 3          0.5000000                space
#> 4          0.5000000                space
#> 5          0.5000000                 time
#> 6          0.5000000                 time
#> 7          0.5000000                 time
#> 8          1.0000000      other_resources
#> 9          1.0000000      other_resources
#> 10         1.0000000      other_resources
#> 11         0.8333333  structures_policies
#> 12         0.8333333                space
#> 13         0.8333333                space
#> 14         0.8333333                space
#> 15         0.8333333                 time
#> 16         0.8333333                 time
#> 17         0.8333333                 time
#> 18                NA                space
#> 19                NA                space
#> 20                NA                space
#> 21                NA                 time
#> 22                NA                 time
#> 23                NA                 time
#> 24         0.5000000 higher_level_leaders
#> 25         0.5000000 higher_level_leaders
#> 26         0.5000000 higher_level_leaders
#> 27         0.5000000 higher_level_leaders
#> 28         0.5000000 higher_level_leaders
#> 29         0.5000000 higher_level_leaders
#> 30                NA      closest_leaders
#> 31                NA      closest_leaders
#> 32                NA      closest_leaders
#> 33                NA      closest_leaders
#> 34                NA      closest_leaders
#> 35                NA      closest_leaders
#> 36         0.6666667      other_resources
#> 37         0.6666667      other_resources
#> 38         0.6666667      other_resources
#> 39         0.8333333        data_tracking
#> 40         1.0000000  structures_policies
#> 41         1.0000000                space
#> 42         1.0000000                space
#> 43         1.0000000                space
#> 44         1.0000000 higher_level_leaders
#> 45         1.0000000 higher_level_leaders
#> 46         1.0000000 higher_level_leaders
#> 47         1.0000000 higher_level_leaders
#> 48         1.0000000 higher_level_leaders
#> 49         1.0000000 higher_level_leaders
#> 50         1.0000000      closest_leaders
#> 51         1.0000000      closest_leaders
#> 52         1.0000000      closest_leaders
#> 53         1.0000000      closest_leaders
#> 54         1.0000000      closest_leaders
#> 55         1.0000000      closest_leaders
#> 56         0.8333333                 time
#> 57         0.8333333                 time
#> 58         0.8333333                 time
#> 59         0.8333333      other_resources
#> 60         0.8333333      other_resources
#> 61         0.8333333      other_resources
#> 62         0.8333333        data_tracking
#>                                                                                                 item_text
#> 1                                 The structures and policies in place here enable us to make the change.
#> 2                                                     We have sufficient space to accommodate the change.
#> 3                                                     We have sufficient space to accommodate the change.
#> 4                                                     We have sufficient space to accommodate the change.
#> 5                                                   We have sufficient time dedicated to make the change.
#> 6                                                   We have sufficient time dedicated to make the change.
#> 7                                                   We have sufficient time dedicated to make the change.
#> 8                       We have other needed resources to make the change (staff, money, supplies, etc.).
#> 9                       We have other needed resources to make the change (staff, money, supplies, etc.).
#> 10                      We have other needed resources to make the change (staff, money, supplies, etc.).
#> 11                                The structures and policies in place here enable us to make the change.
#> 12                                                    We have sufficient space to accommodate the change.
#> 13                                                    We have sufficient space to accommodate the change.
#> 14                                                    We have sufficient space to accommodate the change.
#> 15                                                  We have sufficient time dedicated to make the change.
#> 16                                                  We have sufficient time dedicated to make the change.
#> 17                                                  We have sufficient time dedicated to make the change.
#> 18                                                    We have sufficient space to accommodate the change.
#> 19                                                    We have sufficient space to accommodate the change.
#> 20                                                    We have sufficient space to accommodate the change.
#> 21                                                  We have sufficient time dedicated to make the change.
#> 22                                                  We have sufficient time dedicated to make the change.
#> 23                                                  We have sufficient time dedicated to make the change.
#> 24             Higher level leaders are committed, involved, and accountable for the planned improvement.
#> 25             Higher level leaders are committed, involved, and accountable for the planned improvement.
#> 26             Higher level leaders are committed, involved, and accountable for the planned improvement.
#> 27             Higher level leaders are committed, involved, and accountable for the planned improvement.
#> 28             Higher level leaders are committed, involved, and accountable for the planned improvement.
#> 29             Higher level leaders are committed, involved, and accountable for the planned improvement.
#> 30 Leaders I work with most closely are committed, involved, and accountable for the planned improvement.
#> 31 Leaders I work with most closely are committed, involved, and accountable for the planned improvement.
#> 32 Leaders I work with most closely are committed, involved, and accountable for the planned improvement.
#> 33 Leaders I work with most closely are committed, involved, and accountable for the planned improvement.
#> 34 Leaders I work with most closely are committed, involved, and accountable for the planned improvement.
#> 35 Leaders I work with most closely are committed, involved, and accountable for the planned improvement.
#> 36                      We have other needed resources to make the change (staff, money, supplies, etc.).
#> 37                      We have other needed resources to make the change (staff, money, supplies, etc.).
#> 38                      We have other needed resources to make the change (staff, money, supplies, etc.).
#> 39                                               I have access to data to help track changes in outcomes.
#> 40                                The structures and policies in place here enable us to make the change.
#> 41                                                    We have sufficient space to accommodate the change.
#> 42                                                    We have sufficient space to accommodate the change.
#> 43                                                    We have sufficient space to accommodate the change.
#> 44             Higher level leaders are committed, involved, and accountable for the planned improvement.
#> 45             Higher level leaders are committed, involved, and accountable for the planned improvement.
#> 46             Higher level leaders are committed, involved, and accountable for the planned improvement.
#> 47             Higher level leaders are committed, involved, and accountable for the planned improvement.
#> 48             Higher level leaders are committed, involved, and accountable for the planned improvement.
#> 49             Higher level leaders are committed, involved, and accountable for the planned improvement.
#> 50 Leaders I work with most closely are committed, involved, and accountable for the planned improvement.
#> 51 Leaders I work with most closely are committed, involved, and accountable for the planned improvement.
#> 52 Leaders I work with most closely are committed, involved, and accountable for the planned improvement.
#> 53 Leaders I work with most closely are committed, involved, and accountable for the planned improvement.
#> 54 Leaders I work with most closely are committed, involved, and accountable for the planned improvement.
#> 55 Leaders I work with most closely are committed, involved, and accountable for the planned improvement.
#> 56                                                  We have sufficient time dedicated to make the change.
#> 57                                                  We have sufficient time dedicated to make the change.
#> 58                                                  We have sufficient time dedicated to make the change.
#> 59                      We have other needed resources to make the change (staff, money, supplies, etc.).
#> 60                      We have other needed resources to make the change (staff, money, supplies, etc.).
#> 61                      We have other needed resources to make the change (staff, money, supplies, etc.).
#> 62                                               I have access to data to help track changes in outcomes.
#>    cfir_original_domain cfir_2022_domain     cfir_2022_subdomain
#> 1         Inner Setting    Inner Setting                    <NA>
#> 2         Inner Setting    Inner Setting                    <NA>
#> 3         Inner Setting    Inner Setting                    <NA>
#> 4         Inner Setting    Inner Setting                    <NA>
#> 5         Inner Setting      Individuals Roles & Characteristics
#> 6         Inner Setting      Individuals Roles & Characteristics
#> 7         Inner Setting      Individuals Roles & Characteristics
#> 8         Inner Setting    Inner Setting                    <NA>
#> 9         Inner Setting    Inner Setting                    <NA>
#> 10        Inner Setting    Inner Setting                    <NA>
#> 11        Inner Setting    Inner Setting                    <NA>
#> 12        Inner Setting    Inner Setting                    <NA>
#> 13        Inner Setting    Inner Setting                    <NA>
#> 14        Inner Setting    Inner Setting                    <NA>
#> 15        Inner Setting      Individuals Roles & Characteristics
#> 16        Inner Setting      Individuals Roles & Characteristics
#> 17        Inner Setting      Individuals Roles & Characteristics
#> 18        Inner Setting    Inner Setting                    <NA>
#> 19        Inner Setting    Inner Setting                    <NA>
#> 20        Inner Setting    Inner Setting                    <NA>
#> 21        Inner Setting      Individuals Roles & Characteristics
#> 22        Inner Setting      Individuals Roles & Characteristics
#> 23        Inner Setting      Individuals Roles & Characteristics
#> 24        Inner Setting      Individuals Roles & Characteristics
#> 25        Inner Setting      Individuals Roles & Characteristics
#> 26        Inner Setting      Individuals Roles & Characteristics
#> 27        Inner Setting      Individuals Roles & Characteristics
#> 28        Inner Setting      Individuals Roles & Characteristics
#> 29        Inner Setting      Individuals Roles & Characteristics
#> 30        Inner Setting      Individuals Roles & Characteristics
#> 31        Inner Setting      Individuals Roles & Characteristics
#> 32        Inner Setting      Individuals Roles & Characteristics
#> 33        Inner Setting      Individuals Roles & Characteristics
#> 34        Inner Setting      Individuals Roles & Characteristics
#> 35        Inner Setting      Individuals Roles & Characteristics
#> 36        Inner Setting    Inner Setting                    <NA>
#> 37        Inner Setting    Inner Setting                    <NA>
#> 38        Inner Setting    Inner Setting                    <NA>
#> 39              Process          Process                    <NA>
#> 40        Inner Setting    Inner Setting                    <NA>
#> 41        Inner Setting    Inner Setting                    <NA>
#> 42        Inner Setting    Inner Setting                    <NA>
#> 43        Inner Setting    Inner Setting                    <NA>
#> 44        Inner Setting      Individuals Roles & Characteristics
#> 45        Inner Setting      Individuals Roles & Characteristics
#> 46        Inner Setting      Individuals Roles & Characteristics
#> 47        Inner Setting      Individuals Roles & Characteristics
#> 48        Inner Setting      Individuals Roles & Characteristics
#> 49        Inner Setting      Individuals Roles & Characteristics
#> 50        Inner Setting      Individuals Roles & Characteristics
#> 51        Inner Setting      Individuals Roles & Characteristics
#> 52        Inner Setting      Individuals Roles & Characteristics
#> 53        Inner Setting      Individuals Roles & Characteristics
#> 54        Inner Setting      Individuals Roles & Characteristics
#> 55        Inner Setting      Individuals Roles & Characteristics
#> 56        Inner Setting      Individuals Roles & Characteristics
#> 57        Inner Setting      Individuals Roles & Characteristics
#> 58        Inner Setting      Individuals Roles & Characteristics
#> 59        Inner Setting    Inner Setting                    <NA>
#> 60        Inner Setting    Inner Setting                    <NA>
#> 61        Inner Setting    Inner Setting                    <NA>
#> 62              Process          Process                    <NA>
#>                                cfir_2022_construct
#> 1  Structural Characteristics: Work Infrastructure
#> 2                       Available Resources: Space
#> 3                       Available Resources: Space
#> 4                       Available Resources: Space
#> 5               Innovation Deliverers: Opportunity
#> 6               Innovation Deliverers: Opportunity
#> 7               Innovation Deliverers: Opportunity
#> 8       Available Resources: Materials & Equipment
#> 9       Available Resources: Materials & Equipment
#> 10      Available Resources: Materials & Equipment
#> 11 Structural Characteristics: Work Infrastructure
#> 12                      Available Resources: Space
#> 13                      Available Resources: Space
#> 14                      Available Resources: Space
#> 15              Innovation Deliverers: Opportunity
#> 16              Innovation Deliverers: Opportunity
#> 17              Innovation Deliverers: Opportunity
#> 18                      Available Resources: Space
#> 19                      Available Resources: Space
#> 20                      Available Resources: Space
#> 21              Innovation Deliverers: Opportunity
#> 22              Innovation Deliverers: Opportunity
#> 23              Innovation Deliverers: Opportunity
#> 24                  High-Level Leaders: Motivation
#> 25                  High-Level Leaders: Motivation
#> 26                  High-Level Leaders: Motivation
#> 27                  High-Level Leaders: Motivation
#> 28                  High-Level Leaders: Motivation
#> 29                  High-Level Leaders: Motivation
#> 30                   Mid-Level Leaders: Motivation
#> 31                   Mid-Level Leaders: Motivation
#> 32                   Mid-Level Leaders: Motivation
#> 33                   Mid-Level Leaders: Motivation
#> 34                   Mid-Level Leaders: Motivation
#> 35                   Mid-Level Leaders: Motivation
#> 36      Available Resources: Materials & Equipment
#> 37      Available Resources: Materials & Equipment
#> 38      Available Resources: Materials & Equipment
#> 39                         Reflecting & Evaluating
#> 40 Structural Characteristics: Work Infrastructure
#> 41                      Available Resources: Space
#> 42                      Available Resources: Space
#> 43                      Available Resources: Space
#> 44                  High-Level Leaders: Motivation
#> 45                  High-Level Leaders: Motivation
#> 46                  High-Level Leaders: Motivation
#> 47                  High-Level Leaders: Motivation
#> 48                  High-Level Leaders: Motivation
#> 49                  High-Level Leaders: Motivation
#> 50                   Mid-Level Leaders: Motivation
#> 51                   Mid-Level Leaders: Motivation
#> 52                   Mid-Level Leaders: Motivation
#> 53                   Mid-Level Leaders: Motivation
#> 54                   Mid-Level Leaders: Motivation
#> 55                   Mid-Level Leaders: Motivation
#> 56              Innovation Deliverers: Opportunity
#> 57              Innovation Deliverers: Opportunity
#> 58              Innovation Deliverers: Opportunity
#> 59      Available Resources: Materials & Equipment
#> 60      Available Resources: Materials & Equipment
#> 61      Available Resources: Materials & Equipment
#> 62                         Reflecting & Evaluating
#>    cfir_2022_secondary_construct
#> 1                           <NA>
#> 2                           <NA>
#> 3                           <NA>
#> 4                           <NA>
#> 5                           <NA>
#> 6                           <NA>
#> 7                           <NA>
#> 8   Available Resources: Funding
#> 9   Available Resources: Funding
#> 10  Available Resources: Funding
#> 11                          <NA>
#> 12                          <NA>
#> 13                          <NA>
#> 14                          <NA>
#> 15                          <NA>
#> 16                          <NA>
#> 17                          <NA>
#> 18                          <NA>
#> 19                          <NA>
#> 20                          <NA>
#> 21                          <NA>
#> 22                          <NA>
#> 23                          <NA>
#> 24                          <NA>
#> 25                          <NA>
#> 26                          <NA>
#> 27                          <NA>
#> 28                          <NA>
#> 29                          <NA>
#> 30                          <NA>
#> 31                          <NA>
#> 32                          <NA>
#> 33                          <NA>
#> 34                          <NA>
#> 35                          <NA>
#> 36  Available Resources: Funding
#> 37  Available Resources: Funding
#> 38  Available Resources: Funding
#> 39                          <NA>
#> 40                          <NA>
#> 41                          <NA>
#> 42                          <NA>
#> 43                          <NA>
#> 44                          <NA>
#> 45                          <NA>
#> 46                          <NA>
#> 47                          <NA>
#> 48                          <NA>
#> 49                          <NA>
#> 50                          <NA>
#> 51                          <NA>
#> 52                          <NA>
#> 53                          <NA>
#> 54                          <NA>
#> 55                          <NA>
#> 56                          <NA>
#> 57                          <NA>
#> 58                          <NA>
#> 59  Available Resources: Funding
#> 60  Available Resources: Funding
#> 61  Available Resources: Funding
#> 62                          <NA>
#>                                                     cfir_2022_construct_all
#> 1                           Structural Characteristics: Work Infrastructure
#> 2                                                Available Resources: Space
#> 3                                                Available Resources: Space
#> 4                                                Available Resources: Space
#> 5                                        Innovation Deliverers: Opportunity
#> 6                                        Innovation Deliverers: Opportunity
#> 7                                        Innovation Deliverers: Opportunity
#> 8  Available Resources: Materials & Equipment; Available Resources: Funding
#> 9  Available Resources: Materials & Equipment; Available Resources: Funding
#> 10 Available Resources: Materials & Equipment; Available Resources: Funding
#> 11                          Structural Characteristics: Work Infrastructure
#> 12                                               Available Resources: Space
#> 13                                               Available Resources: Space
#> 14                                               Available Resources: Space
#> 15                                       Innovation Deliverers: Opportunity
#> 16                                       Innovation Deliverers: Opportunity
#> 17                                       Innovation Deliverers: Opportunity
#> 18                                               Available Resources: Space
#> 19                                               Available Resources: Space
#> 20                                               Available Resources: Space
#> 21                                       Innovation Deliverers: Opportunity
#> 22                                       Innovation Deliverers: Opportunity
#> 23                                       Innovation Deliverers: Opportunity
#> 24                                           High-Level Leaders: Motivation
#> 25                                           High-Level Leaders: Motivation
#> 26                                           High-Level Leaders: Motivation
#> 27                                           High-Level Leaders: Motivation
#> 28                                           High-Level Leaders: Motivation
#> 29                                           High-Level Leaders: Motivation
#> 30                                            Mid-Level Leaders: Motivation
#> 31                                            Mid-Level Leaders: Motivation
#> 32                                            Mid-Level Leaders: Motivation
#> 33                                            Mid-Level Leaders: Motivation
#> 34                                            Mid-Level Leaders: Motivation
#> 35                                            Mid-Level Leaders: Motivation
#> 36 Available Resources: Materials & Equipment; Available Resources: Funding
#> 37 Available Resources: Materials & Equipment; Available Resources: Funding
#> 38 Available Resources: Materials & Equipment; Available Resources: Funding
#> 39                                                  Reflecting & Evaluating
#> 40                          Structural Characteristics: Work Infrastructure
#> 41                                               Available Resources: Space
#> 42                                               Available Resources: Space
#> 43                                               Available Resources: Space
#> 44                                           High-Level Leaders: Motivation
#> 45                                           High-Level Leaders: Motivation
#> 46                                           High-Level Leaders: Motivation
#> 47                                           High-Level Leaders: Motivation
#> 48                                           High-Level Leaders: Motivation
#> 49                                           High-Level Leaders: Motivation
#> 50                                            Mid-Level Leaders: Motivation
#> 51                                            Mid-Level Leaders: Motivation
#> 52                                            Mid-Level Leaders: Motivation
#> 53                                            Mid-Level Leaders: Motivation
#> 54                                            Mid-Level Leaders: Motivation
#> 55                                            Mid-Level Leaders: Motivation
#> 56                                       Innovation Deliverers: Opportunity
#> 57                                       Innovation Deliverers: Opportunity
#> 58                                       Innovation Deliverers: Opportunity
#> 59 Available Resources: Materials & Equipment; Available Resources: Funding
#> 60 Available Resources: Materials & Equipment; Available Resources: Funding
#> 61 Available Resources: Materials & Equipment; Available Resources: Funding
#> 62                                                  Reflecting & Evaluating
#>    cfir_2022_mapping_count
#> 1                        1
#> 2                        1
#> 3                        1
#> 4                        1
#> 5                        1
#> 6                        1
#> 7                        1
#> 8                        2
#> 9                        2
#> 10                       2
#> 11                       1
#> 12                       1
#> 13                       1
#> 14                       1
#> 15                       1
#> 16                       1
#> 17                       1
#> 18                       1
#> 19                       1
#> 20                       1
#> 21                       1
#> 22                       1
#> 23                       1
#> 24                       1
#> 25                       1
#> 26                       1
#> 27                       1
#> 28                       1
#> 29                       1
#> 30                       1
#> 31                       1
#> 32                       1
#> 33                       1
#> 34                       1
#> 35                       1
#> 36                       2
#> 37                       2
#> 38                       2
#> 39                       1
#> 40                       1
#> 41                       1
#> 42                       1
#> 43                       1
#> 44                       1
#> 45                       1
#> 46                       1
#> 47                       1
#> 48                       1
#> 49                       1
#> 50                       1
#> 51                       1
#> 52                       1
#> 53                       1
#> 54                       1
#> 55                       1
#> 56                       1
#> 57                       1
#> 58                       1
#> 59                       2
#> 60                       2
#> 61                       2
#> 62                       1
#>                                                                                                                                                                    cfir_2022_mapping_note
#> 1                                                                                                                   One primary updated-CFIR construct per the article main-text mapping.
#> 2                                                                                                                   One primary updated-CFIR construct per the article main-text mapping.
#> 3                                                                                                                   One primary updated-CFIR construct per the article main-text mapping.
#> 4                                                                                                                   One primary updated-CFIR construct per the article main-text mapping.
#> 5                               The article main-text list uses "Innovation Deliverers: Opportunity"; Supplementary Table S3 uses the singular label "Innovation Deliverer: Opportunity".
#> 6                               The article main-text list uses "Innovation Deliverers: Opportunity"; Supplementary Table S3 uses the singular label "Innovation Deliverer: Opportunity".
#> 7                               The article main-text list uses "Innovation Deliverers: Opportunity"; Supplementary Table S3 uses the singular label "Innovation Deliverer: Opportunity".
#> 8  Supplementary Table S3 maps this item to both Available Resources: Materials & Equipment and Funding; the article main-text list of 14 primary constructs names Materials & Equipment.
#> 9  Supplementary Table S3 maps this item to both Available Resources: Materials & Equipment and Funding; the article main-text list of 14 primary constructs names Materials & Equipment.
#> 10 Supplementary Table S3 maps this item to both Available Resources: Materials & Equipment and Funding; the article main-text list of 14 primary constructs names Materials & Equipment.
#> 11                                                                                                                  One primary updated-CFIR construct per the article main-text mapping.
#> 12                                                                                                                  One primary updated-CFIR construct per the article main-text mapping.
#> 13                                                                                                                  One primary updated-CFIR construct per the article main-text mapping.
#> 14                                                                                                                  One primary updated-CFIR construct per the article main-text mapping.
#> 15                              The article main-text list uses "Innovation Deliverers: Opportunity"; Supplementary Table S3 uses the singular label "Innovation Deliverer: Opportunity".
#> 16                              The article main-text list uses "Innovation Deliverers: Opportunity"; Supplementary Table S3 uses the singular label "Innovation Deliverer: Opportunity".
#> 17                              The article main-text list uses "Innovation Deliverers: Opportunity"; Supplementary Table S3 uses the singular label "Innovation Deliverer: Opportunity".
#> 18                                                                                                                  One primary updated-CFIR construct per the article main-text mapping.
#> 19                                                                                                                  One primary updated-CFIR construct per the article main-text mapping.
#> 20                                                                                                                  One primary updated-CFIR construct per the article main-text mapping.
#> 21                              The article main-text list uses "Innovation Deliverers: Opportunity"; Supplementary Table S3 uses the singular label "Innovation Deliverer: Opportunity".
#> 22                              The article main-text list uses "Innovation Deliverers: Opportunity"; Supplementary Table S3 uses the singular label "Innovation Deliverer: Opportunity".
#> 23                              The article main-text list uses "Innovation Deliverers: Opportunity"; Supplementary Table S3 uses the singular label "Innovation Deliverer: Opportunity".
#> 24                                                                                                                  One primary updated-CFIR construct per the article main-text mapping.
#> 25                                                                                                                  One primary updated-CFIR construct per the article main-text mapping.
#> 26                                                                                                                  One primary updated-CFIR construct per the article main-text mapping.
#> 27                                                                                                                  One primary updated-CFIR construct per the article main-text mapping.
#> 28                                                                                                                  One primary updated-CFIR construct per the article main-text mapping.
#> 29                                                                                                                  One primary updated-CFIR construct per the article main-text mapping.
#> 30                                                                                                                  One primary updated-CFIR construct per the article main-text mapping.
#> 31                                                                                                                  One primary updated-CFIR construct per the article main-text mapping.
#> 32                                                                                                                  One primary updated-CFIR construct per the article main-text mapping.
#> 33                                                                                                                  One primary updated-CFIR construct per the article main-text mapping.
#> 34                                                                                                                  One primary updated-CFIR construct per the article main-text mapping.
#> 35                                                                                                                  One primary updated-CFIR construct per the article main-text mapping.
#> 36 Supplementary Table S3 maps this item to both Available Resources: Materials & Equipment and Funding; the article main-text list of 14 primary constructs names Materials & Equipment.
#> 37 Supplementary Table S3 maps this item to both Available Resources: Materials & Equipment and Funding; the article main-text list of 14 primary constructs names Materials & Equipment.
#> 38 Supplementary Table S3 maps this item to both Available Resources: Materials & Equipment and Funding; the article main-text list of 14 primary constructs names Materials & Equipment.
#> 39                                                                                                                  One primary updated-CFIR construct per the article main-text mapping.
#> 40                                                                                                                  One primary updated-CFIR construct per the article main-text mapping.
#> 41                                                                                                                  One primary updated-CFIR construct per the article main-text mapping.
#> 42                                                                                                                  One primary updated-CFIR construct per the article main-text mapping.
#> 43                                                                                                                  One primary updated-CFIR construct per the article main-text mapping.
#> 44                                                                                                                  One primary updated-CFIR construct per the article main-text mapping.
#> 45                                                                                                                  One primary updated-CFIR construct per the article main-text mapping.
#> 46                                                                                                                  One primary updated-CFIR construct per the article main-text mapping.
#> 47                                                                                                                  One primary updated-CFIR construct per the article main-text mapping.
#> 48                                                                                                                  One primary updated-CFIR construct per the article main-text mapping.
#> 49                                                                                                                  One primary updated-CFIR construct per the article main-text mapping.
#> 50                                                                                                                  One primary updated-CFIR construct per the article main-text mapping.
#> 51                                                                                                                  One primary updated-CFIR construct per the article main-text mapping.
#> 52                                                                                                                  One primary updated-CFIR construct per the article main-text mapping.
#> 53                                                                                                                  One primary updated-CFIR construct per the article main-text mapping.
#> 54                                                                                                                  One primary updated-CFIR construct per the article main-text mapping.
#> 55                                                                                                                  One primary updated-CFIR construct per the article main-text mapping.
#> 56                              The article main-text list uses "Innovation Deliverers: Opportunity"; Supplementary Table S3 uses the singular label "Innovation Deliverer: Opportunity".
#> 57                              The article main-text list uses "Innovation Deliverers: Opportunity"; Supplementary Table S3 uses the singular label "Innovation Deliverer: Opportunity".
#> 58                              The article main-text list uses "Innovation Deliverers: Opportunity"; Supplementary Table S3 uses the singular label "Innovation Deliverer: Opportunity".
#> 59 Supplementary Table S3 maps this item to both Available Resources: Materials & Equipment and Funding; the article main-text list of 14 primary constructs names Materials & Equipment.
#> 60 Supplementary Table S3 maps this item to both Available Resources: Materials & Equipment and Funding; the article main-text list of 14 primary constructs names Materials & Equipment.
#> 61 Supplementary Table S3 maps this item to both Available Resources: Materials & Equipment and Funding; the article main-text list of 14 primary constructs names Materials & Equipment.
#> 62                                                                                                                  One primary updated-CFIR construct per the article main-text mapping.
#>    suppressed          barrier_priority
#> 1       FALSE      strong_effect_signal
#> 2       FALSE      strong_effect_signal
#> 3       FALSE      strong_effect_signal
#> 4       FALSE      strong_effect_signal
#> 5       FALSE      strong_effect_signal
#> 6       FALSE      strong_effect_signal
#> 7       FALSE      strong_effect_signal
#> 8       FALSE                      high
#> 9       FALSE                      high
#> 10      FALSE                      high
#> 11      FALSE                      high
#> 12      FALSE                      high
#> 13      FALSE                      high
#> 14      FALSE                      high
#> 15      FALSE                      high
#> 16      FALSE                      high
#> 17      FALSE                      high
#> 18      FALSE                      high
#> 19      FALSE                      high
#> 20      FALSE                      high
#> 21      FALSE                      high
#> 22      FALSE                      high
#> 23      FALSE                      high
#> 24      FALSE                      high
#> 25      FALSE                      high
#> 26      FALSE                      high
#> 27      FALSE                      high
#> 28      FALSE                      high
#> 29      FALSE                      high
#> 30      FALSE                      high
#> 31      FALSE                      high
#> 32      FALSE                      high
#> 33      FALSE                      high
#> 34      FALSE                      high
#> 35      FALSE                      high
#> 36      FALSE      strong_effect_signal
#> 37      FALSE      strong_effect_signal
#> 38      FALSE      strong_effect_signal
#> 39      FALSE barrier_prevalence_signal
#> 40      FALSE                      high
#> 41      FALSE                      high
#> 42      FALSE                      high
#> 43      FALSE                      high
#> 44      FALSE                      high
#> 45      FALSE                      high
#> 46      FALSE                      high
#> 47      FALSE                      high
#> 48      FALSE                      high
#> 49      FALSE                      high
#> 50      FALSE                      high
#> 51      FALSE                      high
#> 52      FALSE                      high
#> 53      FALSE                      high
#> 54      FALSE                      high
#> 55      FALSE                      high
#> 56      FALSE                      high
#> 57      FALSE                      high
#> 58      FALSE                      high
#> 59      FALSE                      high
#> 60      FALSE                      high
#> 61      FALSE                      high
#> 62      FALSE barrier_prevalence_signal
#>                                     strategy tier mapping_status
#> 1                                       <NA>   NA           <NA>
#> 2                         Access new funding    1         direct
#> 3    Change physical structure and equipment    2         direct
#> 4          Capture and share local knowledge    2         direct
#> 5                         Access new funding    1         direct
#> 6    Change physical structure and equipment    2         direct
#> 7          Capture and share local knowledge    2         direct
#> 8                         Access new funding    1         direct
#> 9    Change physical structure and equipment    2         direct
#> 10         Capture and share local knowledge    2         direct
#> 11                                      <NA>   NA           <NA>
#> 12                        Access new funding    1         direct
#> 13   Change physical structure and equipment    2         direct
#> 14         Capture and share local knowledge    2         direct
#> 15                        Access new funding    1         direct
#> 16   Change physical structure and equipment    2         direct
#> 17         Capture and share local knowledge    2         direct
#> 18                        Access new funding    1         direct
#> 19   Change physical structure and equipment    2         direct
#> 20         Capture and share local knowledge    2         direct
#> 21                        Access new funding    1         direct
#> 22   Change physical structure and equipment    2         direct
#> 23         Capture and share local knowledge    2         direct
#> 24      Alter incentive/allowance structures    2         direct
#> 25       Conduct local consensus discussions    2         direct
#> 26            Identify and prepare champions    2         direct
#> 27                           Increase demand    2         direct
#> 28 Develop a formal implementation blueprint    2         direct
#> 29                  Involve executive boards    2         direct
#> 30      Alter incentive/allowance structures    2         direct
#> 31       Conduct local consensus discussions    2         direct
#> 32            Identify and prepare champions    2         direct
#> 33                           Increase demand    2         direct
#> 34 Develop a formal implementation blueprint    2         direct
#> 35                  Involve executive boards    2         direct
#> 36                        Access new funding    1         direct
#> 37   Change physical structure and equipment    2         direct
#> 38         Capture and share local knowledge    2         direct
#> 39                                      <NA>   NA           <NA>
#> 40                                      <NA>   NA           <NA>
#> 41                        Access new funding    1         direct
#> 42   Change physical structure and equipment    2         direct
#> 43         Capture and share local knowledge    2         direct
#> 44      Alter incentive/allowance structures    2         direct
#> 45       Conduct local consensus discussions    2         direct
#> 46            Identify and prepare champions    2         direct
#> 47                           Increase demand    2         direct
#> 48 Develop a formal implementation blueprint    2         direct
#> 49                  Involve executive boards    2         direct
#> 50      Alter incentive/allowance structures    2         direct
#> 51       Conduct local consensus discussions    2         direct
#> 52            Identify and prepare champions    2         direct
#> 53                           Increase demand    2         direct
#> 54 Develop a formal implementation blueprint    2         direct
#> 55                  Involve executive boards    2         direct
#> 56                        Access new funding    1         direct
#> 57   Change physical structure and equipment    2         direct
#> 58         Capture and share local knowledge    2         direct
#> 59                        Access new funding    1         direct
#> 60   Change physical structure and equipment    2         direct
#> 61         Capture and share local knowledge    2         direct
#> 62                                      <NA>   NA           <NA>
#>         source_construct                 source_doi selected_strategy
#> 1                   <NA>                       <NA>              <NA>
#> 2    Available Resources 10.1186/s43058-022-00380-5              <NA>
#> 3    Available Resources 10.1186/s43058-022-00380-5              <NA>
#> 4    Available Resources 10.1186/s43058-022-00380-5              <NA>
#> 5    Available Resources 10.1186/s43058-022-00380-5              <NA>
#> 6    Available Resources 10.1186/s43058-022-00380-5              <NA>
#> 7    Available Resources 10.1186/s43058-022-00380-5              <NA>
#> 8    Available Resources 10.1186/s43058-022-00380-5              <NA>
#> 9    Available Resources 10.1186/s43058-022-00380-5              <NA>
#> 10   Available Resources 10.1186/s43058-022-00380-5              <NA>
#> 11                  <NA>                       <NA>              <NA>
#> 12   Available Resources 10.1186/s43058-022-00380-5              <NA>
#> 13   Available Resources 10.1186/s43058-022-00380-5              <NA>
#> 14   Available Resources 10.1186/s43058-022-00380-5              <NA>
#> 15   Available Resources 10.1186/s43058-022-00380-5              <NA>
#> 16   Available Resources 10.1186/s43058-022-00380-5              <NA>
#> 17   Available Resources 10.1186/s43058-022-00380-5              <NA>
#> 18   Available Resources 10.1186/s43058-022-00380-5              <NA>
#> 19   Available Resources 10.1186/s43058-022-00380-5              <NA>
#> 20   Available Resources 10.1186/s43058-022-00380-5              <NA>
#> 21   Available Resources 10.1186/s43058-022-00380-5              <NA>
#> 22   Available Resources 10.1186/s43058-022-00380-5              <NA>
#> 23   Available Resources 10.1186/s43058-022-00380-5              <NA>
#> 24 Leadership Engagement 10.1186/s43058-022-00380-5              <NA>
#> 25 Leadership Engagement 10.1186/s43058-022-00380-5              <NA>
#> 26 Leadership Engagement 10.1186/s43058-022-00380-5              <NA>
#> 27 Leadership Engagement 10.1186/s43058-022-00380-5              <NA>
#> 28 Leadership Engagement 10.1186/s43058-022-00380-5              <NA>
#> 29 Leadership Engagement 10.1186/s43058-022-00380-5              <NA>
#> 30 Leadership Engagement 10.1186/s43058-022-00380-5              <NA>
#> 31 Leadership Engagement 10.1186/s43058-022-00380-5              <NA>
#> 32 Leadership Engagement 10.1186/s43058-022-00380-5              <NA>
#> 33 Leadership Engagement 10.1186/s43058-022-00380-5              <NA>
#> 34 Leadership Engagement 10.1186/s43058-022-00380-5              <NA>
#> 35 Leadership Engagement 10.1186/s43058-022-00380-5              <NA>
#> 36   Available Resources 10.1186/s43058-022-00380-5              <NA>
#> 37   Available Resources 10.1186/s43058-022-00380-5              <NA>
#> 38   Available Resources 10.1186/s43058-022-00380-5              <NA>
#> 39                  <NA>                       <NA>              <NA>
#> 40                  <NA>                       <NA>              <NA>
#> 41   Available Resources 10.1186/s43058-022-00380-5              <NA>
#> 42   Available Resources 10.1186/s43058-022-00380-5              <NA>
#> 43   Available Resources 10.1186/s43058-022-00380-5              <NA>
#> 44 Leadership Engagement 10.1186/s43058-022-00380-5              <NA>
#> 45 Leadership Engagement 10.1186/s43058-022-00380-5              <NA>
#> 46 Leadership Engagement 10.1186/s43058-022-00380-5              <NA>
#> 47 Leadership Engagement 10.1186/s43058-022-00380-5              <NA>
#> 48 Leadership Engagement 10.1186/s43058-022-00380-5              <NA>
#> 49 Leadership Engagement 10.1186/s43058-022-00380-5              <NA>
#> 50 Leadership Engagement 10.1186/s43058-022-00380-5              <NA>
#> 51 Leadership Engagement 10.1186/s43058-022-00380-5              <NA>
#> 52 Leadership Engagement 10.1186/s43058-022-00380-5              <NA>
#> 53 Leadership Engagement 10.1186/s43058-022-00380-5              <NA>
#> 54 Leadership Engagement 10.1186/s43058-022-00380-5              <NA>
#> 55 Leadership Engagement 10.1186/s43058-022-00380-5              <NA>
#> 56   Available Resources 10.1186/s43058-022-00380-5              <NA>
#> 57   Available Resources 10.1186/s43058-022-00380-5              <NA>
#> 58   Available Resources 10.1186/s43058-022-00380-5              <NA>
#> 59   Available Resources 10.1186/s43058-022-00380-5              <NA>
#> 60   Available Resources 10.1186/s43058-022-00380-5              <NA>
#> 61   Available Resources 10.1186/s43058-022-00380-5              <NA>
#> 62                  <NA>                       <NA>              <NA>
#>    planned_action local_adaptation owner target_date status action_notes
#> 1            <NA>             <NA>  <NA>        <NA>   <NA>         <NA>
#> 2            <NA>             <NA>  <NA>        <NA>   <NA>         <NA>
#> 3            <NA>             <NA>  <NA>        <NA>   <NA>         <NA>
#> 4            <NA>             <NA>  <NA>        <NA>   <NA>         <NA>
#> 5            <NA>             <NA>  <NA>        <NA>   <NA>         <NA>
#> 6            <NA>             <NA>  <NA>        <NA>   <NA>         <NA>
#> 7            <NA>             <NA>  <NA>        <NA>   <NA>         <NA>
#> 8            <NA>             <NA>  <NA>        <NA>   <NA>         <NA>
#> 9            <NA>             <NA>  <NA>        <NA>   <NA>         <NA>
#> 10           <NA>             <NA>  <NA>        <NA>   <NA>         <NA>
#> 11           <NA>             <NA>  <NA>        <NA>   <NA>         <NA>
#> 12           <NA>             <NA>  <NA>        <NA>   <NA>         <NA>
#> 13           <NA>             <NA>  <NA>        <NA>   <NA>         <NA>
#> 14           <NA>             <NA>  <NA>        <NA>   <NA>         <NA>
#> 15           <NA>             <NA>  <NA>        <NA>   <NA>         <NA>
#> 16           <NA>             <NA>  <NA>        <NA>   <NA>         <NA>
#> 17           <NA>             <NA>  <NA>        <NA>   <NA>         <NA>
#> 18           <NA>             <NA>  <NA>        <NA>   <NA>         <NA>
#> 19           <NA>             <NA>  <NA>        <NA>   <NA>         <NA>
#> 20           <NA>             <NA>  <NA>        <NA>   <NA>         <NA>
#> 21           <NA>             <NA>  <NA>        <NA>   <NA>         <NA>
#> 22           <NA>             <NA>  <NA>        <NA>   <NA>         <NA>
#> 23           <NA>             <NA>  <NA>        <NA>   <NA>         <NA>
#> 24           <NA>             <NA>  <NA>        <NA>   <NA>         <NA>
#> 25           <NA>             <NA>  <NA>        <NA>   <NA>         <NA>
#> 26           <NA>             <NA>  <NA>        <NA>   <NA>         <NA>
#> 27           <NA>             <NA>  <NA>        <NA>   <NA>         <NA>
#> 28           <NA>             <NA>  <NA>        <NA>   <NA>         <NA>
#> 29           <NA>             <NA>  <NA>        <NA>   <NA>         <NA>
#> 30           <NA>             <NA>  <NA>        <NA>   <NA>         <NA>
#> 31           <NA>             <NA>  <NA>        <NA>   <NA>         <NA>
#> 32           <NA>             <NA>  <NA>        <NA>   <NA>         <NA>
#> 33           <NA>             <NA>  <NA>        <NA>   <NA>         <NA>
#> 34           <NA>             <NA>  <NA>        <NA>   <NA>         <NA>
#> 35           <NA>             <NA>  <NA>        <NA>   <NA>         <NA>
#> 36           <NA>             <NA>  <NA>        <NA>   <NA>         <NA>
#> 37           <NA>             <NA>  <NA>        <NA>   <NA>         <NA>
#> 38           <NA>             <NA>  <NA>        <NA>   <NA>         <NA>
#> 39           <NA>             <NA>  <NA>        <NA>   <NA>         <NA>
#> 40           <NA>             <NA>  <NA>        <NA>   <NA>         <NA>
#> 41           <NA>             <NA>  <NA>        <NA>   <NA>         <NA>
#> 42           <NA>             <NA>  <NA>        <NA>   <NA>         <NA>
#> 43           <NA>             <NA>  <NA>        <NA>   <NA>         <NA>
#> 44           <NA>             <NA>  <NA>        <NA>   <NA>         <NA>
#> 45           <NA>             <NA>  <NA>        <NA>   <NA>         <NA>
#> 46           <NA>             <NA>  <NA>        <NA>   <NA>         <NA>
#> 47           <NA>             <NA>  <NA>        <NA>   <NA>         <NA>
#> 48           <NA>             <NA>  <NA>        <NA>   <NA>         <NA>
#> 49           <NA>             <NA>  <NA>        <NA>   <NA>         <NA>
#> 50           <NA>             <NA>  <NA>        <NA>   <NA>         <NA>
#> 51           <NA>             <NA>  <NA>        <NA>   <NA>         <NA>
#> 52           <NA>             <NA>  <NA>        <NA>   <NA>         <NA>
#> 53           <NA>             <NA>  <NA>        <NA>   <NA>         <NA>
#> 54           <NA>             <NA>  <NA>        <NA>   <NA>         <NA>
#> 55           <NA>             <NA>  <NA>        <NA>   <NA>         <NA>
#> 56           <NA>             <NA>  <NA>        <NA>   <NA>         <NA>
#> 57           <NA>             <NA>  <NA>        <NA>   <NA>         <NA>
#> 58           <NA>             <NA>  <NA>        <NA>   <NA>         <NA>
#> 59           <NA>             <NA>  <NA>        <NA>   <NA>         <NA>
#> 60           <NA>             <NA>  <NA>        <NA>   <NA>         <NA>
#> 61           <NA>             <NA>  <NA>        <NA>   <NA>         <NA>
#> 62           <NA>             <NA>  <NA>        <NA>   <NA>         <NA>
```
