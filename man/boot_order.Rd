% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/datasets.R
\docType{data}
\name{boot_order}
\alias{boot_order}
\title{Boot order}
\format{
This data frame contains the following columns:
\describe{
\item{\code{version}}{Country code for the version of the show}
\item{\code{version_season}}{Version season key}
\item{\code{season}}{Season number}
\item{\code{castaway_id}}{ID of the castaway (primary key). Consistent across seasons and name changes e.g. Amber Brkich / Amber Mariano. The first two letters reference the country of the version played e.g. US, AU (TBA).}
\item{\code{castaway}}{Name of castaway. Generally this is the name they were most commonly referred to
or nickname e.g. no one called Coach, Benjamin. He was simply Coach}
\item{\code{episode}}{Episode number}
\item{\code{day}}{Number of days the castaway survived. A missing value indicates they later returned to the game that season}
\item{\code{order}}{Boot order. Order in which castaway was voted out e.g. 5 is the 5th person voted of the island}
\item{\code{result}}{Final result}
}
}
\source{
\url{https://en.wikipedia.org/wiki/Survivor_(American_TV_series)};
\url{https://survivor.fandom.com/wiki/Main_Page};
\code{ack_} features from Matt Stiles \url{https://github.com/stiles/survivor-voteoffs}
}
\usage{
boot_order
}
\description{
Similar to the castaways dataset, \code{boot_order} records the order in which castaways
left the game. If a player was voted out of the game, returned to the game like seasons
such as Redemption Island, and then voted out again, they will have two rows in the table.
}
\examples{
library(dplyr)
castaways \%>\%
  filter(season == 40)
}
\keyword{datasets}
