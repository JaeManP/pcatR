# Launch the optional pCAT analysis dashboard

Runs a bundled Shiny interface for uploading a non-sensitive long-format
CSV, validating and classifying responses, viewing issues and a profile
plot, and exporting classified data.

## Usage

``` r
pcat_app()
```

## Details

The application is an analysis interface, not a secure survey-collection
platform. Do not upload protected health information or sensitive direct
identifiers.

## Value

The value returned by
[`shiny::runApp()`](https://rdrr.io/pkg/shiny/man/runApp.html).

## Examples

``` r
if (FALSE) { # \dontrun{
pcat_app()
} # }
```
