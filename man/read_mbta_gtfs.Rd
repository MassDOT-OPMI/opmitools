% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/read_mbta_gtfs.R
\name{read_mbta_gtfs}
\alias{read_mbta_gtfs}
\title{Read MBTA GTFS}
\usage{
read_mbta_gtfs(..., minimal = TRUE)
}
\arguments{
\item{...}{arguments passed on to \code{\link[tidytransit]{read_gtfs}}}

\item{minimal}{A logical value, indicating whether the GTFS should contain
only files indicated above}
}
\value{
A GTFS object
}
\description{
\code{read_mbta_gtfs} reads the current GTFS from the MBTA website.
Optionally, it filters to a minimal GTFS, containing only
agency.txt, calendar.txt, routes.txt, shapes.txt,
stop_times.txt, stops.txt, and trips.txt
}
