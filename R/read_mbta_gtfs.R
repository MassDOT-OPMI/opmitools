#' Read MBTA GTFS
#'
#' \code{read_mbta_gtfs} reads the current GTFS from the MBTA website.
#' Optionally, it filters to a minimal GTFS, containing only
#' agency.txt, calendar.txt, routes.txt, shapes.txt,
#' stop_times.txt, stops.txt, and trips.txt
#'
#' @param ... arguments passed on to \code{\link[tidytransit]{read_gtfs}}
#' @param minimal A logical value, indicating whether the GTFS should contain
#' only files indicated above
#'
#' @return A GTFS object
#' @export
#'
read_mbta_gtfs <- function(..., minimal = TRUE) {

  gtfs <- tidytransit::read_gtfs("https://cdn.mbta.com/MBTA_GTFS.zip", quiet = FALSE)

  if (minimal) {
    gtfs <- gtfs[c("agency", "calendar", "routes", "shapes", "stop_times", "stops", "trips")]
  }

  gtfs
}
