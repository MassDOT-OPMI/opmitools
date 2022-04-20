#' Merge GTFS files
#'
#' `gtfs_merge()` combines services from two distinct GTFS files. To read GTFS
#' files into R, try using \code{\link{read_mbta_gtfs}} or
#' \code{\link[tidytransit]{read_gtfs}}.
#'
#' @param gtfs1 A GTFS file stored as a list
#' @param gtfs2 A GTFS file stored as a list
#'
#' @return A GTFS file reflecting services stored in `gtfs1` and `gtfs2`
#' @export
#'
gtfs_merge <- function(gtfs1, gtfs2) {

  # use gtfs structure from gtfs1
  gtfs <- gtfs1

  # merge all the files
  gtfs$agency <- dplyr::bind_rows(gtfs1$agency, gtfs2$agency) %>% dplyr::distinct()
  gtfs$calendar <- dplyr::bind_rows(gtfs1$calendar, gtfs2$calendar) %>% dplyr::distinct()
  gtfs$routes <- dplyr::bind_rows(gtfs1$routes, gtfs2$routes) %>% dplyr::distinct()
  gtfs$shapes <- dplyr::bind_rows(gtfs1$shapes, gtfs2$shapes) %>% dplyr::distinct()
  gtfs$stop_times <- dplyr::bind_rows(gtfs1$stop_times, gtfs2$stop_times) %>% dplyr::distinct()
  gtfs$stops <- dplyr::bind_rows(gtfs1$stops, gtfs2$stops) %>% dplyr::distinct()
  gtfs$trips <- dplyr::bind_rows(gtfs1$trips, gtfs2$trips) %>% dplyr::distinct()

  # if there is a calendar attributes in both files, merge that as well and then return, otherwise just return
  if(!is_null(gtfs1$calendar_attributes) & !is_null(gtfs2$calendar_attributes)) {
    gtfs$calendar_attributes <- dplyr::bind_rows(gtfs1$calendar_attributes, gtfs2$calendar_attributes) %>% distinct()
    gtfs <- gtfs %>% magrittr::extract(c("agency", "calendar", "calendar_attributes", "routes", "shapes", "stop_times", "stops", "trips"))
    gtfs
  } else {
    gtfs <- gtfs %>% magrittr::extract(c("agency", "calendar", "routes", "shapes", "stop_times", "stops", "trips"))
    gtfs
  }

}
