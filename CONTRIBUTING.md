# Contributing to pcatR

Thank you for contributing. Changes should be focused, reproducible, and
methodologically explicit.

## Development setup

``` r

install.packages(c(
  "devtools", "roxygen2", "testthat", "knitr", "rmarkdown", "pkgdown"
))
devtools::load_all()
devtools::test()
devtools::check()
```

## Pull-request requirements

1.  Open or reference an issue describing the problem and intended
    behavior.
2.  Add or update tests for every behavioral change.
3.  Update roxygen documentation, README/guide text, and `NEWS.md` when
    relevant.
4.  Run `devtools::document()`, `devtools::test()`, and
    `devtools::check()`.
5.  Do not commit real respondent data, direct identifiers, credentials,
    or generated local libraries.
6.  Preserve CC BY attribution for source-derived instrument content.

## Methodological changes

Changes to item wording, response coding, CFIR mappings, summary
denominators, consensus rules, longitudinal pairing, or strategy
mappings require primary source verification. Do not introduce an
overall pCAT score without published validation and a clear versioned
specification.

## Style

Use explicit namespace calls for external packages, base R data frames
for public return objects, stable snake_case column names, and
actionable error messages. Public functions require examples, tests, and
documented return values.
