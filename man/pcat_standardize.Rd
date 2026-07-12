\name{pcat_standardize}
\alias{pcat_standardize}
\alias{pcat_read_csv}
\alias{pcat_template}
\alias{pcat_write_template}
\alias{pcat_wide_to_long}
\alias{pcat_long_to_wide}
\title{Prepare, import, and reshape pCAT data}
\usage{
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
}
\arguments{
\item{path}{Input or output CSV path, depending on the function.}
\item{layout}{Input layout: auto-detected, long, or wide.}
\item{item_prefix}{Prefix used before item numbers in wide response columns.}
\item{na}{Character values interpreted as missing when reading a CSV.}
\item{data}{A data frame.}
\item{respondent_id, item_id, direction, effect}{Source column names, supplied
as character strings, for the four required fields.}
\item{project_id, site_id, team_id, role, timepoint, assessment_date, comment}{
Optional source column names supplied as character strings.}
\item{keep_original}{Logical; retain source columns whose names differ from the
standard names.}
\item{format}{Output layout, either long or wide.}
\item{n_respondents}{Positive number of blank respondent records.}
\item{include_item_text}{Logical; include item wording in a long entry template.}
\item{overwrite}{Logical; replace an existing output file.}
\item{id_cols}{Columns defining one assessment row in wide output.}
}
\description{
Reads standard pCAT CSV files, standardizes user column names, creates
entry templates, writes CSV templates, and converts responses between long and
wide layouts.
}
\details{
Standard long data require \code{respondent_id}, \code{item_id},
\code{direction}, and \code{effect}. Standard wide response names follow
\code{item01_direction}, \code{item01_effect}, through item 14. Free-text
comments should be reviewed for sensitive information before analysis or
sharing.
}
\value{
A data frame, except \code{pcat_write_template()}, which invisibly returns the
normalized output path.
}
\examples{
long <- pcat_template("long", n_respondents = 2)
wide <- pcat_long_to_wide(long, id_cols = c("respondent_id", "timepoint"))
pcat_wide_to_long(wide)

\dontrun{
pcat_write_template("pcat_template.csv", overwrite = TRUE)
imported <- pcat_read_csv("pcat_template.csv")
}
}
