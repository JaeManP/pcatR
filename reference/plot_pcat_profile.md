# Default pCAT plotting palette

Creates a publication-quality diverging bar chart. Barriers are plotted
to the left, facilitators to the right, and the neutral share is printed
at the center. Percentages use complete five-category responses as the
denominator.

## Usage

``` r
pcat_palette()

plot_pcat_profile(
  data,
  group_vars = NULL,
  label = c("cfir_original_construct", "cfir_2022_construct", "item_text", "item_id"),
  label_width = 42L,
  facet_ncol = NULL,
  facet_label = c("values", "names_values"),
  show_neutral = TRUE,
  show_n = TRUE,
  base_size = 11,
  label_size = 8.5,
  legend_position = "bottom",
  title = "pCAT barrier-facilitator profile",
  subtitle = NULL,
  caption = NULL,
  palette = pcat_palette()
)

plot_pcat_heatmap(
  data,
  respondent_id = "respondent_id",
  facet_vars = NULL,
  facet_ncol = NULL,
  facet_label = c("values", "names_values"),
  base_size = 11,
  title = "pCAT respondent-by-item profile",
  subtitle = NULL,
  caption = paste("Missing, invalid, effect-incomplete, or absent item records are",
    "shown in light grey."),
  palette = pcat_palette()
)

plot_pcat_change(
  data,
  from = NULL,
  to = NULL,
  respondent_id = "respondent_id",
  facet_vars = NULL,
  display = c("transition", "delta"),
  facet_ncol = NULL,
  facet_label = c("values", "names_values"),
  base_size = 11,
  title = "Paired pCAT change",
  subtitle = NULL,
  caption = NULL,
  ...
)
```

## Arguments

- data:

  Output from
  [`pcat_change()`](https://jaemanp.github.io/pcatR/reference/pcat_summarise.md)
  or classified data.

- group_vars:

  Optional grouping columns used for facets.

- label:

  Item label field.

- label_width:

  Approximate character width used to wrap item labels.

- facet_ncol:

  Number of facet columns.

- facet_label:

  Whether facet strips show values only or names and values.

- show_neutral:

  Print the neutral percentage at the center.

- show_n:

  Include the complete-response denominator in the neutral label.

- base_size:

  Base text size.

- label_size:

  Text size for item labels.

- legend_position:

  Position of the shared legend.

- title, subtitle, caption:

  Optional plot annotations.

- palette:

  Named color vector. See `pcat_palette()`.

- respondent_id:

  Respondent identifier column in paired output.

- facet_vars:

  Optional grouping columns used for facets.

- from, to:

  Required only when `data` have not already been paired.

- display:

  Display transition categories or the descriptive delta code.

- ...:

  Passed to
  [`pcat_change()`](https://jaemanp.github.io/pcatR/reference/pcat_summarise.md)
  when pairing is needed.

## Value

A named character vector of color values.

A `ggplot` object.

A `ggplot` object.

A `ggplot` object.
