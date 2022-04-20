#' Check for unused GTFS components
#'
#' @param gtfs A GTFS file stored as a list
#'
#' @return Either a list containing unused stops, shapes, routes, or `service_id`s or a message.
#' @export
#'
#' @family gtfs cleaning functions
gtfs_removal_check <- function(gtfs) {
  gtfs <- remove_unused_routes(gtfs, retain_routes = TRUE)
  gtfs <- remove_unused_service(gtfs, retain_service = TRUE)
  gtfs <- remove_unused_shapes(gtfs, retain_shapes = TRUE)
  gtfs <- remove_unused_stops(gtfs, retain_stops = TRUE)

  gtfs <-
    gtfs[c("routes_unused", "calendar_unused", "shapes_unused", "stops_unused")]

  gtfs_removal <- purrr::map(gtfs, ~nrow(.x)) %>% unlist() %>% unname()

  if (gtfs_removal[gtfs_removal > 0] %>% length() == 0) {
    print("No routes, service_ids, shapes, or stops are not found in trips or stop_times")
  } else{
    gtfs %>% magrittr::extract(which(gtfs_removal > 0))
  }
}
