% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/datasets.R
\docType{data}
\name{confessionals}
\alias{confessionals}
\title{Confessionals}
\format{
This data frame contains the following columns:
\describe{
\item{\code{version}}{Country code for the version of the show}
\item{\code{version_season}}{Version season key}
\item{\code{season}}{The season number}
\item{\code{episode}}{Episode number}
\item{\code{castaway}}{Name of the castaway}
\item{\code{castaway_id}}{ID of the castaway (primary key). Consistent across seasons and name changes e.g. Amber Brkich / Amber Mariano. The first two letters reference the country of the version played e.g. US, AU.}
\item{\code{confessional_count}}{The count of confessionals for the castaway during the episode}
\item{\code{confessional_time}}{The total time for all confessionals for the episode for each castaway}
\item{\code{exp_count}}{The expected confessional counts. See details.}
\item{\code{exp_time}}{The expected confessional time. See details.}
}
}
\usage{
confessionals
}
\description{
A dataset containing the count of confessionals per castaway per episode. A confessional is when
the castaway is speaking directly to the camera about their game.
}
\details{
Confessional data has been counted by contributors of the survivoR R package and consolidated
with external sources. The aim is to establish consistency in confessional counts in the absence of official
sources. Given the subjective nature of the counts and the potential for clerical error no single source is
more valid than another. Therefore, it is reasonable to average across all sources.

In the case of double or extended episodes, if the episode only has one title it is considered a single episode. This
means the average number of confessionals per person is likely to be higher for this episode given it's length. If
there are two episode titles the confessionals are counted for the appropriate episode. This is to ensure consistency
across all other datasets.

In the case of recap episodes, this episode is left blank.

The fields \code{exp_count} and \code{exp_time} are the expected values given the game events. For example players that attend
tribal council, find advantages, go on rewards, and if it's their boot episode typically get more confessionals - we
should expect them to get more as well. This enables analysis of the observed and expected confessionals and those
that received more or fewer than expected.

If you also count confessionals, please get in touch and I'll add them into the package.
}
\keyword{datasets}
