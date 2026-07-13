# Rebuilding the pcatR technical guide

`pcatR_Technical_User_Guide.Rmd` is the editable source for the installed HTML
and PDF technical guides. Its YAML declares self-contained HTML and PDF output,
and `pcatR-guide.css` contains the print layout used by the distributed files.

From this directory, a standard R Markdown installation can create both
formats:

```r
rmarkdown::render(
  "pcatR_Technical_User_Guide.Rmd",
  output_format = "html_document",
  output_file = "../pcatR_Technical_User_Guide.html",
  clean = TRUE
)

rmarkdown::render(
  "pcatR_Technical_User_Guide.Rmd",
  output_format = "pdf_document",
  output_file = "../pcatR_Technical_User_Guide.pdf",
  clean = TRUE
)
```

The release PDF is printed from the self-contained HTML with a Chromium-based
browser so that the CSS page size, footer, page numbers, tables, and code blocks
match the distributed layout. For example, after rendering the HTML:

```text
chrome --headless --disable-gpu --no-pdf-header-footer \
  --print-to-pdf=../pcatR_Technical_User_Guide.pdf \
  file:///absolute/path/to/pcatR_Technical_User_Guide.html
```

Renderers may use different Chrome executable names or paths. Before release,
render every PDF page to images and inspect the complete guide for clipping,
overlap, broken tables, and missing headers or footers.
