\name{pcat_validate}
\alias{pcat_validate}
\alias{print.pcat_validation}
\alias{pcat_validation_data}
\alias{pcat_validation_issues}
\title{Validate pCAT response data}
\usage{
pcat_validate(
  data,
  key_cols = NULL,
  require_complete = FALSE,
  neutral_effect = c("flag", "allow", "set_missing"),
  action = c("warn", "error", "none"),
  strict = FALSE
)

\method{print}{pcat_validation}(x, ...)

pcat_validation_data(x, valid_rows_only = FALSE)

pcat_validation_issues(x, level = c("all", "row", "assessment"))
}
\arguments{
\item{data}{Long-format pCAT response data. Required columns are
\code{respondent_id}, \code{item_id}, \code{direction}, and \code{effect}.}
\item{key_cols}{Columns defining one assessment. When omitted, available
project, site, team, timepoint, assessment date, and respondent identifiers are
used.}
\item{require_complete}{Logical; require exactly one row for every item 1--14
within each assessment.}
\item{neutral_effect}{How to handle a neutral direction paired with any recorded
effect: flag it, allow it, or set the effect to missing.}
\item{action}{Whether validation findings generate a warning, an error, or no
condition.}
\item{strict}{Logical; treat warnings as invalid when setting the object's
\code{valid} field.}
\item{x}{A \code{pcat_validation} object.}
\item{...}{Additional arguments, currently ignored by the print method.}
\item{valid_rows_only}{Logical; retain only rows without row-level errors.}
\item{level}{Return all issues, row-level issues, or assessment-completeness
issues.}
}
\description{
Checks identifiers, item numbers, direction and effect values, duplicate keys,
neutral responses with recorded effects, missing effects for barrier or
facilitator directions, and optional 14-item completeness.
}
\details{
The default behavior flags a neutral response paired with either effect code as
a warning because effect strength is not applicable when direction is neutral.
Validation findings remain available in structured form even when
\code{action = "none"}.
}
\value{
\code{pcat_validate()} returns a \code{pcat_validation} object. The extractor
functions return data frames. The print method returns \code{x} invisibly.
}
\examples{
dat <- pcat_example_data()
val <- pcat_validate(dat, require_complete = TRUE, action = "none")
val
head(pcat_validation_data(val))
pcat_validation_issues(val)
}
