% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/add.R
\name{add_lgbt}
\alias{add_lgbt}
\title{Add LGBTQIA+ status}
\usage{
add_lgbt(df)
}
\arguments{
\item{df}{Data frame. Requires \code{castaway_id} and \code{version_season}.}
}
\value{
Data frame with the LGBTQIA+ flag added.
}
\description{
Adds the LGBTQIA+ flag to the data frame.
}
\examples{

library(survivoR)
library(dplyr)

get_cast("US47") |>
  add_lgbt()

}
