# Prepare, import, and reshape pCAT data

Reads standard pCAT CSV files, standardizes user column names, creates
entry templates, writes CSV templates, and converts responses between
long and wide layouts.

## Usage

``` r
pcat_read_csv(
  path,
  layout = c("auto", "long", "wide"),
  item_prefix = "item",
  na = c("", "NA")
)

pcat_standardize(
  data,
  respondent_id = "respondent_id",
  item_id = "item_id",
  direction = "direction",
  effect = "effect",
  project_id = NULL,
  site_id = NULL,
  team_id = NULL,
  role = NULL,
  timepoint = NULL,
  assessment_date = NULL,
  comment = NULL,
  keep_original = TRUE
)

pcat_template(
  format = c("long", "wide"),
  n_respondents = 1L,
  include_item_text = TRUE
)

pcat_write_template(
  path,
  format = c("long", "wide"),
  n_respondents = 1L,
  include_item_text = TRUE,
  overwrite = FALSE
)

pcat_wide_to_long(data, item_prefix = "item")

pcat_long_to_wide(data, id_cols = NULL, item_prefix = "item")
```

## Arguments

- path:

  Input or output CSV path, depending on the function.

- layout:

  Input layout: auto-detected, long, or wide.

- item_prefix:

  Prefix used before item numbers in wide response columns.

- na:

  Character values interpreted as missing when reading a CSV.

- data:

  A data frame.

- respondent_id, item_id, direction, effect:

  Source column names, supplied as character strings, for the four
  required fields.

- project_id, site_id, team_id, role, timepoint, assessment_date,
  comment:

  Optional source column names supplied as character strings.

- keep_original:

  Logical; retain source columns whose names differ from the standard
  names.

- format:

  Output layout, either long or wide.

- n_respondents:

  Positive number of blank respondent records.

- include_item_text:

  Logical; include item wording in a long entry template.

- overwrite:

  Logical; replace an existing output file.

- id_cols:

  Columns defining one assessment row in wide output.

## Details

Standard long data require `respondent_id`, `item_id`, `direction`, and
`effect`. Standard wide response names follow `item01_direction`,
`item01_effect`, through item 14. Free-text comments should be reviewed
for sensitive information before analysis or sharing.

## Value

A data frame, except `pcat_write_template()`, which invisibly returns
the normalized output path.

## Examples

``` r
long <- pcat_template("long", n_respondents = 2)
wide <- pcat_long_to_wide(long, id_cols = c("respondent_id", "timepoint"))
pcat_wide_to_long(wide)
#>    respondent_id timepoint item_id direction effect
#> 1           R001  planning       1        NA     NA
#> 2           R001  planning       2        NA     NA
#> 3           R001  planning       3        NA     NA
#> 4           R001  planning       4        NA     NA
#> 5           R001  planning       5        NA     NA
#> 6           R001  planning       6        NA     NA
#> 7           R001  planning       7        NA     NA
#> 8           R001  planning       8        NA     NA
#> 9           R001  planning       9        NA     NA
#> 10          R001  planning      10        NA     NA
#> 11          R001  planning      11        NA     NA
#> 12          R001  planning      12        NA     NA
#> 13          R001  planning      13        NA     NA
#> 14          R001  planning      14        NA     NA
#> 15          R002  planning       1        NA     NA
#> 16          R002  planning       2        NA     NA
#> 17          R002  planning       3        NA     NA
#> 18          R002  planning       4        NA     NA
#> 19          R002  planning       5        NA     NA
#> 20          R002  planning       6        NA     NA
#> 21          R002  planning       7        NA     NA
#> 22          R002  planning       8        NA     NA
#> 23          R002  planning       9        NA     NA
#> 24          R002  planning      10        NA     NA
#> 25          R002  planning      11        NA     NA
#> 26          R002  planning      12        NA     NA
#> 27          R002  planning      13        NA     NA
#> 28          R002  planning      14        NA     NA

if (FALSE) { # \dontrun{
pcat_write_template("pcat_template.csv", overwrite = TRUE)
imported <- pcat_read_csv("pcat_template.csv")
} # }
```
