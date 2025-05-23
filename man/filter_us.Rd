% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/filters.R
\name{filter_us}
\alias{filter_us}
\title{Filter to US seasons}
\usage{
filter_us(df, .season = NULL)
}
\arguments{
\item{df}{Data frame. Must include \code{version} and \code{season}.}

\item{.season}{Season or vector of seasons. If \code{NULL} if will filter to all US seasons.}
}
\value{
Data frame filtered to the specified US seasons
}
\description{
Filter a data set to a specified set of US season or list of seasons. A
shorthand version of \code{filter_vs()} for the US seasons.
}
\examples{

library(survivoR)
library(dplyr)

confessionals |>
  filter_us(47)

}
