#' GTFS cleaning functions
#'
#' Functions to remove items from a GTFS if they are not used in either the
#' trips (for routes, shapes, and `service_id`s) or stop_times (for stops)
#' file.
#'
#' @param gtfs A GTFS file stored as a list
#' @param retain_stops Whether to retain the unused stops (in `gtfs$stops_unused`)
#' @param retain_shapes Whether to retain the unused shapes (in `gtfs$shapes_unused`)
#' @param retain_routes Whether to retain the unused routes (in `gtfs$routes_unused`)
#' @param retain_service Whether to retain the unused `service_id`s (in `gtfs$calendar_unused`)
#'
#' @return A GTFS file stored as a list. If `gtfs_remove_all()` is called, stops,
#' shapes, routes, and `service_id`s that are not
#' used by the trips.txt or stop_times.txt files will be removed.
#' Other functions pertain to specific files.
#' @export
#' @examples \dontrun{
#' gtfs_remove_all(gtfs)
#' }
#' @name gtfs_remove_unused
#' @export
remove_unused_stops <- function(gtfs, retain_stops = FALSE) {

  # summarize number of trips by stop
  used_stop_counts <-
    gtfs$stop_times %>%
    dplyr::group_by(stop_id) %>%
    dplyr::summarise(trip_stops = dplyr::n())


  # get list of stops
  distinct_stops <-
    gtfs$stops %>%
    dplyr::select(stop_id) %>%
    dplyr::distinct()

  undefined_stops <-
    used_stop_counts %>%
    dplyr::filter(!(stop_id %in% distinct_stops$stop_id)) %>%
    magrittr::use_series(stop_id)

  if(length(undefined_stops) > 0) {
    stop(paste0("There are stops in stop_times.txt that lack definition in stops.txt.\n  The following stops lack definition: ",
                paste(undefined_stops, collapse = " ")))
  }

  # join number of trips by stop to list of stops
  stop_summary <-
    dplyr::left_join(distinct_stops, used_stop_counts, by = "stop_id")



  # list of unused stops
  unused_stops <-
    stop_summary %>%
    dplyr::filter(is.na(trip_stops)) %>%
    magrittr::use_series(stop_id)

  # if retaining stops, write the unused stops to stops_unused
  if(retain_stops) {
    gtfs$stops_unused <- gtfs$stops %>% dplyr::filter(stop_id %in% unused_stops)
  }

  # overwrite the stops file
  gtfs$stops <-
    gtfs$stops %>%
    dplyr::filter(!(stop_id %in% unused_stops))

  # return the new gtfs
  gtfs

}



#' @rdname gtfs_remove_unused
#' @export
remove_unused_shapes <- function(gtfs, retain_shapes = FALSE) {


  # number of trips by shape
  used_shape_counts <-
    gtfs$trips %>%
    dplyr::group_by(shape_id) %>%
    dplyr::summarize(trip_count = dplyr::n())

  # distinct shapes
  distinct_shapes <-
    gtfs$shapes %>%
    dplyr::select(shape_id) %>%
    dplyr::distinct()

  undefined_shapes <-
    used_shape_counts %>%
    dplyr::filter(!(shape_id %in% distinct_shapes$shape_id)) %>%
    magrittr::use_series(shape_id)


  if(length(undefined_shapes) > 0) {
    stop(paste0("There are shapes in trips.txt that lack definition in shapes.txt.\n  The following shapes lack definition: ",
                paste(undefined_shapes, collapse = " ")))
  }


  # join
  shape_summary <-
    dplyr::left_join(distinct_shapes, used_shape_counts,
                     by = "shape_id")

  # list of unused shapes
  unused_shapes <-
    shape_summary %>%
    dplyr::filter(is.na(trip_count)) %>%
    magrittr::use_series(shape_id)

  # if retaining shapes, write unused shapes to shapes_unused
  if (retain_shapes) {
    gtfs$shapes_unused <- gtfs$shapes %>% dplyr::filter(shape_id %in% unused_shapes)
  }

  # overwrite the shapes file
  gtfs$shapes <-
    gtfs$shapes %>%
    dplyr::filter(!(shape_id %in% unused_shapes))

  # return the new gtfs
  gtfs
}

#' @rdname gtfs_remove_unused
#' @export
remove_unused_routes <- function(gtfs, retain_routes = FALSE) {

  # list of route_ids in trips with trip count
  trips_by_route <-
    gtfs$trips %>%
    dplyr::group_by(route_id) %>%
    dplyr::summarize(trips = dplyr::n())

  # list of route_ids in routes
  distinct_routes <-
    gtfs$routes %>%
    dplyr::transmute(route_id, route_in_routes = TRUE)

  # join route_ids from both
  route_comparison <-
    dplyr::full_join(distinct_routes, trips_by_route, by = "route_id") %>%
    dplyr::mutate(route_in_routes = tidyr::replace_na(route_in_routes, FALSE))

  # throw error if there are route_ids in trips that have no info in routes
  stopifnot(route_comparison %>% dplyr::filter(!route_in_routes) %>% magrittr::use_series(route_id) %>% length() == 0)

  # create list of unused routes
  unused_routes <-
    route_comparison %>%
    dplyr::filter(is.na(trips)) %>%
    magrittr::use_series(route_id)

  # if retaining unused routes, put them in routes_unused
  if(retain_routes) {
    gtfs$routes_unused <-
      gtfs$routes %>%
      dplyr::filter(route_id %in% unused_routes)
  }

  # remove unused routes from routes table
  gtfs$routes <-
    gtfs$routes %>%
    dplyr::filter(!(route_id %in% unused_routes))

  # output gtfs
  gtfs
}


#' @rdname gtfs_remove_unused
#' @export
remove_unused_service <- function(gtfs, retain_service = FALSE) {

  # get count of trips by service_id
  trips_by_service_id <-
    gtfs$trips %>%
    dplyr::group_by(service_id) %>%
    dplyr::summarize(trips = dplyr::n())

  # get service_ids from calendar
  calendar_service_ids <-
    gtfs$calendar %>%
    dplyr::transmute(service_id, defined_in_calendar = TRUE)

  # compare lists
  service_id_comparison <-
    dplyr::full_join(calendar_service_ids, trips_by_service_id, by = "service_id") %>%
    dplyr::mutate(defined_in_calendar = tidyr::replace_na(defined_in_calendar, FALSE))

  # throw error for undefined service ids
  stopifnot(service_id_comparison %>% dplyr::filter(!defined_in_calendar) %>% magrittr::use_series(service_id) %>% length() == 0)

  # list of unused service ids
  unused_service_ids <-
    service_id_comparison %>%
    dplyr::filter(is.na(trips)) %>%
    magrittr::use_series(service_id)

  # if retaining service ids, add to calendar_unused
  if(retain_service) {
    gtfs$calendar_unused <-
      gtfs$calendar %>%
      dplyr::filter(service_id %in% unused_service_ids)
  }

  # filter calendar file
  gtfs$calendar <-
    gtfs$calendar %>%
    dplyr::filter(!(service_id %in% unused_service_ids))

  # filter calendar attributes file if exists
  if(!rlang::is_null(gtfs$calendar_attributes)) {
    gtfs$calendar_attributes <-
      gtfs$calendar_attributes %>%
      dplyr::filter(!(service_id %in% unused_service_ids))
  }

  # return gtfs
  gtfs

}

#' @rdname gtfs_remove_unused
#' @family gtfs cleaning functions
#' @param retain_all Whether to retain removed components
#' @export
gtfs_remove_all <- function(gtfs,
                            retain_all = FALSE,
                            retain_stops = FALSE,
                            retain_shapes = FALSE,
                            retain_routes = FALSE,
                            retain_service = FALSE) {

  if (retain_all) {
    retain_shapes <- TRUE
    retain_stops <- TRUE
    retain_routes <- TRUE
    retain_service <- TRUE
  }

  gtfs <- remove_unused_stops(gtfs, retain_stops = retain_stops)
  gtfs <- remove_unused_shapes(gtfs, retain_shapes = retain_shapes)
  gtfs <- remove_unused_routes(gtfs, retain_routes = retain_routes)
  gtfs <- remove_unused_service(gtfs, retain_service = retain_service)

  gtfs

}
