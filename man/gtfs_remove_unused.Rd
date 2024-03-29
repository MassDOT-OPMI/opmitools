% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/gtfs_remove_functions.R
\name{gtfs_remove_unused}
\alias{gtfs_remove_unused}
\alias{remove_unused_stops}
\alias{remove_unused_shapes}
\alias{remove_unused_routes}
\alias{remove_unused_service}
\alias{gtfs_remove_all}
\title{GTFS cleaning functions}
\usage{
remove_unused_stops(gtfs, retain_stops = FALSE)

remove_unused_shapes(gtfs, retain_shapes = FALSE)

remove_unused_routes(gtfs, retain_routes = FALSE)

remove_unused_service(gtfs, retain_service = FALSE)

gtfs_remove_all(
  gtfs,
  retain_all = FALSE,
  retain_stops = FALSE,
  retain_shapes = FALSE,
  retain_routes = FALSE,
  retain_service = FALSE
)
}
\arguments{
\item{gtfs}{A GTFS file stored as a list}

\item{retain_stops}{Whether to retain the unused stops (in \code{gtfs$stops_unused})}

\item{retain_shapes}{Whether to retain the unused shapes (in \code{gtfs$shapes_unused})}

\item{retain_routes}{Whether to retain the unused routes (in \code{gtfs$routes_unused})}

\item{retain_service}{Whether to retain the unused \code{service_id}s (in \code{gtfs$calendar_unused})}

\item{retain_all}{Whether to retain removed components}
}
\value{
A GTFS file stored as a list. If \code{gtfs_remove_all()} is called, stops,
shapes, routes, and \code{service_id}s that are not
used by the trips.txt or stop_times.txt files will be removed.
Other functions pertain to specific files.
}
\description{
Functions to remove items from a GTFS if they are not used in either the
trips (for routes, shapes, and \code{service_id}s) or stop_times (for stops)
file.
}
\examples{
\dontrun{
gtfs_remove_all(gtfs)
}
}
\seealso{
Other gtfs cleaning functions: 
\code{\link{gtfs_removal_check}()}
}
\concept{gtfs cleaning functions}
