#' GTFS Agreement Check
#'
#' Checks for agreement between stop_times.txt and trips.txt
#'
#' @param gtfs A GTFS file stored as a list
#'
#' @return Either a table of trip_ids found in trips but not stop_times (or vice versa) or a message
#' @export
#'
gtfs_agreement_check <- function(gtfs) {

  # get list of trips from stop_times
  stop_times_trips <-
    gtfs$stop_times$trip_id %>% unique()

  # get list of trips from trips
  trips_trips <-
    gtfs$trips$trip_id %>% unique()

  # create output table
  agreement_check_tibble <-
    tibble::tibble(trip_id = trips_trips, trips_trips = trips_trips) %>%
    dplyr::full_join(tibble::tibble(trip_id = stop_times_trips, stop_times_trips = stop_times_trips),
                     by = "trip_id") %>%
    dplyr:: filter(trips_trips != stop_times_trips | is.na(trips_trips) | is.na(stop_times_trips))

  if(length(agreement_check_tibble$trip_id) > 0) {
    agreement_check_tibble
  } else {
    print("No trip_ids were found in trips but not stop_times and vice versa")
  }
}
