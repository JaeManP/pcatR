\name{pcat_summarise}
\alias{pcat_summarise}
\alias{pcat_consensus}
\alias{pcat_change}
\alias{pcat_action_plan}
\title{Summarize, compare, and plan from pCAT data}
\usage{
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
}
\arguments{
\item{data}{Raw, validated, classified, or previously summarized pCAT data, as
appropriate for the function.}
\item{group_vars}{Optional character vector of grouping columns such as site
and timepoint.}
\item{respondent_id}{Respondent identifier column name.}
\item{suppress_below}{Optional positive minimum respondent count. Numeric
analytic measures and the derived \code{modal_class} below it are replaced
with missing values and \code{suppressed} is set to \code{TRUE}.}
\item{agreement_threshold}{One finite number from zero through one giving the
minimum dominant-side share used for a consensus label.}
\item{polarization_min}{One finite number from zero through one giving the
minimum barrier and facilitator shares required to label an item polarized.}
\item{minimum_n}{Minimum number of valid direction responses.}
\item{timepoint}{Timepoint column name.}
\item{from, to}{Earlier and later timepoint values.}
\item{id_cols}{Columns identifying paired respondent-item records.}
\item{barrier_threshold}{One finite number from zero through one giving the
minimum barrier prevalence for action-plan inclusion.}
\item{strong_barrier_threshold}{One finite number from zero through one giving
the minimum strong-barrier prevalence for action-plan inclusion.}
\item{include_strategy_candidates}{Logical; join source-derived candidate ERIC
strategies where a direct construct link is available.}
\item{include_approximate}{Logical; include the non-identical Relative Priority
to Relative Advantage approximation.}
}
\description{
Creates item-level summaries, team agreement and disagreement diagnostics,
paired longitudinal transitions, and barrier-focused action-plan tables.
}
\details{
Directional percentages (\code{pct_barrier}, \code{pct_neutral},
\code{pct_facilitator}, and \code{pct_effect_missing}) use eligible records
with a valid direction and denominator \code{n_valid_direction}. Complete
five-category percentages use only eligible records with a complete
direction-plus-effect classification and denominator \code{n_complete_class}.
The directional \code{n_neutral} count can therefore exceed
\code{n_neutral_complete} when a neutral direction has an invalid effect.
All five complete-category counts are derived from \code{pcat_class5} and
partition \code{n_complete_class}. Report both denominators when they differ.

Means, medians, and change values based on \code{pcat_display_code} are
strictly descriptive. Candidate strategies require local stakeholder review
and are not automatic prescriptions. Small-cell suppression hides numeric
analytic measures and \code{modal_class}; it applies only to the returned
summary table and does not de-identify source or classified data.
}
\value{A data frame with a function-specific class and documented denominator
attributes where applicable.}
\examples{
classified <- pcat_classify(pcat_example_data())
summary <- pcat_summarise(
  classified,
  group_vars = c("site_id", "timepoint")
)
pcat_consensus(summary)

pcat_change(
  classified,
  from = "planning",
  to = "mid_implementation"
)

pcat_action_plan(
  summary,
  group_vars = c("site_id", "timepoint")
)
}
