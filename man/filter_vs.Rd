% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/filters.R
\name{filter_vs}
\alias{filter_vs}
\title{Filter version season}
\usage{
filter_vs(df, .vs)
}
\arguments{
\item{df}{Data frame. Must have \code{version_season}}

\item{.vs}{Version season.}
}
\value{
Data frame filtered to the specified version seasons
}
\description{
Filters a data set to a specified version season or list of version seasons.
}
\examples{

library(survivoR)
library(dplyr)

confessionals |>
  filter_vs("US47")

}
