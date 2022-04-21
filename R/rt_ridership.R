#' MBTA Rapid Transit Ridership
#'
#' Dataset showing average fall ridership on Red, Orange, Green, and Blue Lines.
#'
#'
#' @format A data frame with 36 rows and 4 columns.
#' \describe{
#'   \item{rating}{character, Applicable fall rating}
#'   \item{route_id}{Factor, Route ID of service}
#'   \item{day_type_name}{Character, day type of service}
#'   \item{tot_ons}{Numeric, average total boardings of service}
#' }
#'
#' @source \url{https://mbta-massdot.opendata.arcgis.com/datasets/MassDOT::mbta-rail-ridership-by-time-period-season-route-line-and-stop/explore}
"rt_ridership"
