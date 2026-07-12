\name{pcat_items}
\alias{pcat_items}
\alias{pcat_construct_map}
\alias{pcat_response_options}
\alias{pcat_example_data}
\alias{pcat_strategy_candidates}
\title{Instrument metadata, CFIR mappings, and included example data}
\usage{
pcat_items(cfir_version = c("both", "original", "2022"))

pcat_construct_map(
  cfir_version = c("both", "original", "2022"),
  include_secondary = TRUE
)

pcat_response_options()

pcat_example_data()

pcat_strategy_candidates(
  construct = NULL,
  tier = c("all", "1", "2"),
  include_approximate = FALSE
)
}
\arguments{
\item{cfir_version}{Mapping version to return: both source versions, the
original CFIR, or the updated 2022 CFIR.}
\item{include_secondary}{Logical; retain secondary item-to-construct links.
The 2026 supplementary mapping gives item 10 a secondary Funding link.}
\item{construct}{Optional original-CFIR or source-table construct name used to
filter candidate strategies.}
\item{tier}{Candidate strategy endorsement tier: all, tier 1, or tier 2.}
\item{include_approximate}{Logical; include the source table's non-identical
Relative Priority to Relative Advantage approximation.}
}
\description{
Returns the 14-item pCAT dictionary, a long-form mapping table, response-code
definitions, synthetic example data, or source-derived candidate ERIC
strategy links.
}
\details{
\code{pcat_items()} keeps one primary updated-CFIR construct per item for
item-level reporting. \code{pcat_construct_map()} exposes every retained
item-construct link. Candidate strategies are prompts for local deliberation,
not automatically selected or validated prescriptions.
}
\value{
A data frame. \code{pcat_items()} has one row per pCAT item;
\code{pcat_construct_map()} has one row per item-construct link.
}
\examples{
pcat_items("both")
pcat_construct_map("2022")
pcat_response_options()
head(pcat_example_data())
pcat_strategy_candidates("Available Resources", tier = "1")
}
