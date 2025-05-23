% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/datasets.R
\docType{data}
\name{screen_time}
\alias{screen_time}
\title{Screen Time}
\format{
This data frame contains the following columns:
\describe{
\item{\code{version_season}}{Version season key}
\item{\code{episode}}{Episode number}
\item{\code{castaway_id}}{ID of the castaway (primary key). Also includes
two special IDs of host (i.e. Jeff Probst) or unknown (the image detection
couldn't identify the face with sufficient accuracy)}
\item{\code{screen_time}}{Estimated screen time for the individual in seconds.}
}
}
\usage{
screen_time
}
\description{
A dataset summarising the screen time of contestants on the TV show Survivor.
Currently only contains Season 1-4 and 42.
}
\details{
Individuals' screen time is calculated, at a high-level, via the following process:

\enumerate{
\item Frames are sampled from episodes on a 1 second time interval
\item MTCNN detects the human faces within each frame
\item VGGFace2 converts each detected face into a 512d vector space
\item A training set of labelled images (1 for each contestant + 3 for
Jeff Probst) is processed in the same way to determine where they sit in
the vector space.
TODO: This could be made more accurate by increasing the number of training
images per contestant.
\item The Euclidean distance is calculated for the faces detected in the frame
to each of the contestants in the season (+Jeff). If the minimum distance is
greater than 1.2 the face is labelled as "unknown".
TODO: Review how robust this distance cutoff truly is - currently based on
manual review of Season 42.
\item A multi-class SVM is trained on the training set to label faces. For
any face not identified as "unknown", the vector embedding is run into this
model and a label is generated.
\item All labelled faces are aggregated together, with an assumption of 1
full second of screen time each time a face is seen.
}
}
\keyword{datasets}
