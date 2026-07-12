# Locate or open the pcatR technical user guide

Locates the technical user guide installed with `pcatR`. The guide
defines the package's data schema, validation rules, denominators,
descriptive classification logic, privacy cautions, and reporting
expectations.

## Usage

``` r
pcat_user_guide(format = c("pdf", "markdown"), open = interactive())
```

## Arguments

- format:

  Guide format: PDF or Markdown.

- open:

  Logical; open the guide with the operating system's default
  application.

## Value

The normalized guide path, invisibly.

## Examples

``` r
if (FALSE) { # \dontrun{
pcat_user_guide()
} # }

path <- pcat_user_guide("markdown", open = FALSE)
path
#> [1] "/home/runner/work/_temp/Library/pcatR/guides/pcatR_Technical_User_Guide.md"
```
