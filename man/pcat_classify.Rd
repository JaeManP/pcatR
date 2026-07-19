\name{pcat_classify}
\alias{pcat_classify}
\title{Classify pCAT responses}
\usage{
pcat_classify(
  data,
  validation_action = c("none", "warn", "error"),
  attach_items = TRUE
)
}
\arguments{
\item{data}{Long-format response data or a \code{pcat_validation} object.}
\item{validation_action}{Condition behavior used when raw data must first be
validated.}
\item{attach_items}{Logical; attach item wording and CFIR metadata.}
}
\description{
Combines direction and effect responses into strong barrier, weak barrier,
neutral, weak facilitator, and strong facilitator categories. It retains
explicit states for invalid responses and missing effect responses.
}
\details{
Strength categories are assigned only when both direction and effect
validation are valid. A neutral row with an invalid effect remains
directionally neutral but has an invalid strength and no complete
five-category classification.

The numeric \code{pcat_display_code} ranges from -2 to +2 and is supplied only
for descriptive plotting and transition displays. It is not a validated scale
score and should not be summed into an overall pCAT score.
}
\value{A data frame of class \code{pcat_classified}.}
\examples{
classified <- pcat_classify(pcat_example_data())
head(classified)
}
