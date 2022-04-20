read_mbta_gtfs <- function(..., minimal = TRUE) {

  gtfs <- tidytransit::read_gtfs("https://cdn.mbta.com/MBTA_GTFS.zip", quiet = FALSE)

  if (minimal) {
    gtfs <- gtfs[c("agency", "calendar", "routes", "shapes", "stop_times", "stops", "trips")]
  }

  gtfs
}
