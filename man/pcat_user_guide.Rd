\name{pcat_user_guide}
\alias{pcat_user_guide}
\title{Locate or open the pcatR technical user guide}
\usage{
pcat_user_guide(format = c("pdf", "html"), open = interactive())
}
\arguments{
\item{format}{Guide format: PDF or HTML.}
\item{open}{Logical; open the guide with the operating system's default
application.}
}
\description{
Locates the technical user guide installed with \code{pcatR}. The guide defines
the package's data schema, validation rules, denominators, descriptive
classification logic, privacy cautions, and reporting expectations.
}
\value{The normalized guide path, invisibly.}
\examples{
\dontrun{
pcat_user_guide()
}

path <- pcat_user_guide("html", open = FALSE)
path
}
