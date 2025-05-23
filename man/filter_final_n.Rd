% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/filters.R
\name{filter_final_n}
\alias{filter_final_n}
\title{Filter final \code{n}}
\usage{
filter_final_n(df, .final_n)
}
\arguments{
\item{df}{Input data frame. Must have \code{version_season}}

\item{.final_n}{An integer to represent the final \code{n}.}
}
\value{
A data frame filtered to only the final \code{n}
}
\description{
Filters to the final n players e.g. the final 4.
}
\examples{

library(survivoR)
library(dplyr)

confessionals |>
  filter_us(47) |>
  filter_final_n(6) |>
  group_by(castaway) |>
  summarise(n = sum(confessional_count))

}
