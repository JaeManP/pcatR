\name{pcat_app}
\alias{pcat_app}
\title{Launch the optional pCAT analysis dashboard}
\usage{
pcat_app()
}
\description{
Runs a bundled Shiny interface for uploading a non-sensitive long-format CSV,
validating and classifying responses, viewing issues and a profile plot, and
exporting classified data.
}
\details{
The application is an analysis interface, not a secure survey-collection
platform. Do not upload protected health information or sensitive direct
identifiers.
}
\value{The value returned by \code{shiny::runApp()}.}
\examples{
\dontrun{
pcat_app()
}
}
