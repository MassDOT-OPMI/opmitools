#' BAZ Reference
#'
#' One row per BAZ - block group - reporting geography. BAZes in Boston are
#' assigned to two reporting geographies -- Boston and a specific
#' neighborhood.
#'
#' @format A data frame with 4183 rows and 8 variables:
#' \describe{
#'  \item{baz}{BAZ ID}
#'  \itme{baz_name}{name of BAZ}
#'  \item{lat}{Latitude}
#'  \item{lon}{Longitude}
#'  \item{blkgrp}{Block Group GEOID}
#'  \item{blkgrp_sqmi}{Area of Block Group, in square miles}
#'  \item{municipality}{Municipality (not included for non-BAZ Block Groups)}
#'  \item{reportingGeography}{Reporting Geography (not included for non-BAZ
#'  Block Groups)}
#' }
"baz_ref"
