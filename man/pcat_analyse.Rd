\name{pcat_analyse}
\alias{pcat_analyse}
\alias{print.pcat_analysis}
\title{Run the standard pCAT analysis workflow}
\usage{
pcat_analyse(
  data,
  group_vars = NULL,
  respondent_id = "respondent_id",
  key_cols = NULL,
  require_complete = FALSE,
  neutral_effect = c("flag", "allow", "set_missing"),
  validation_action = c("none", "warn", "error"),
  strict = FALSE,
  suppress_below = NULL,
  agreement_threshold = 0.6,
  polarization_min = 0.2,
  minimum_n = 2L,
  include_action_plan = TRUE,
  barrier_threshold = 0.5,
  strong_barrier_threshold = 0.2,
  include_approximate = FALSE
)

\method{print}{pcat_analysis}(x, ...)
}
\arguments{
\item{data}{Long-format pCAT response data.}
\item{group_vars}{Optional character vector of grouping columns, such as
\code{site_id} and \code{timepoint}.}
\item{respondent_id}{Name of the respondent identifier column.}
\item{key_cols}{Columns defining one assessment for validation. When omitted,
available project, site, team, timepoint, assessment date, and respondent
identifiers are used.}
\item{require_complete}{Logical; require exactly one response to every pCAT
item 1--14 within each assessment.}
\item{neutral_effect}{How to handle a neutral direction paired with any recorded
effect: flag it, allow it, or set the effect to missing.}
\item{validation_action}{Whether validation findings generate no condition, a
warning, or an error.}
\item{strict}{Logical; treat warnings as invalid when setting the validation
object's \code{valid} field.}
\item{suppress_below}{Optional positive minimum respondent count. Numeric
summary results below this threshold are replaced with missing values.}
\item{agreement_threshold}{Minimum dominant-side share used for a consensus
label.}
\item{polarization_min}{Minimum barrier and facilitator shares required to
label an item polarized.}
\item{minimum_n}{Minimum number of valid direction responses required for a
consensus label.}
\item{include_action_plan}{Logical; create a barrier-focused action-plan table.}
\item{barrier_threshold}{Minimum barrier prevalence for action-plan inclusion.}
\item{strong_barrier_threshold}{Minimum strong-barrier prevalence for
action-plan inclusion.}
\item{include_approximate}{Logical; include the source table's non-identical
Relative Priority to Relative Advantage approximation.}
\item{x}{A \code{pcat_analysis} object.}
\item{...}{Additional arguments, currently ignored by the print method.}
}
\description{
Validates and classifies responses, creates item-level summaries and consensus
diagnostics, and optionally creates a barrier-focused action plan.
}
\details{
The result retains validation findings and all denominators needed for
transparent reporting. It does not calculate an overall pCAT scale score.
Small-cell suppression applies to summary tables; respondent-level classified
data are retained in the result and must be governed separately.
}
\value{
\code{pcat_analyse()} returns a list of class \code{pcat_analysis} with
components \code{validation}, \code{classified}, \code{summary},
\code{consensus}, \code{action_plan}, and \code{settings}. The print method
returns \code{x} invisibly.
}
\examples{
analysis <- pcat_analyse(
  pcat_example_data(),
  group_vars = c("site_id", "timepoint"),
  require_complete = TRUE,
  validation_action = "none"
)
analysis
head(analysis$summary)
}
