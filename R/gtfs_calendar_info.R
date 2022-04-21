#' GTFS Calendar Information
#'
#' @param gtfs A GTFS file stored as a list
#' @param write_to_gtfs Logical, whether to return the calendar information
#' as a table or add it to the GTFS as `gtfs$calendar_info`
#'
#' @return If `write_to_gtfs` is TRUE, a GTFS stored as a list. If FALSE,
#' a table
#' @export
#'
gtfs_calendar_info <- function(gtfs, write_to_gtfs = FALSE) {

  calendar_info <-
    gtfs$calendar %>%
    dplyr::mutate(day_type_cal =
                    dplyr::case_when(monday + tuesday + wednesday + thursday + friday == 5 ~ "Weekday",
                              saturday == 1 ~ "Saturday",
                              sunday == 1 ~ "Sunday"),
                  day_type_text =
                    dplyr::case_when(stringr::str_detect(service_id, "Weekday") ~ "Weekday",
                              stringr::str_detect(service_id, "Saturday") ~ "Saturday",
                              stringr::str_detect(service_id, "Sunday") ~ "Sunday"),
                  .after = service_id)

  calendar_info <-
    calendar_info %>%
    dplyr::select(service_id, starts_with("day_type"), ends_with("date")) %>%
    dplyr::mutate(totdays = end_date - start_date + 1)

  if(calendar_info %>% dplyr::filter(day_type_cal != day_type_text) %>% magrittr::use_series(service_id) %>% length() != 0) {
    warning("Disagreement between methods of determining day type")
  }

  if(rlang::is_null(gtfs$calendar_attributes)) {

    calendar_info <-
      calendar_info %>%
      dplyr::mutate(day_type = dplyr::coalesce(day_type_cal, day_type_text), .after = day_type_text) %>%
      dplyr::select(-c(day_type_cal, day_type_text))

    if(write_to_gtfs){
      gtfs$calendar_info <- calendar_info
      gtfs
    } else {
      calendar_info
    }


  } else {
    cal_attr <-
      gtfs$calendar_attributes %>%
      dplyr::select(service_id, service_description, service_schedule_name,  service_schedule_typicality, day_type_attr = service_schedule_type)

    calendar_info <- dplyr::left_join(calendar_info, cal_attr, by = "service_id") %>% dplyr::relocate(day_type_attr, .after = day_type_text)

    if(calendar_info %>% dplyr::filter(day_type_cal != day_type_attr) %>% magrittr::use_series(service_id) %>% length() != 0) {
      warn_service_ids <- calendar_info %>% dplyr::filter(day_type_cal != day_type_attr) %>% magrittr::use_series(service_id)
      message(paste0("Disagreement between methods of determining day type in service_id: ", warn_service_ids,
                     collapse = "\n"))
    }

    calendar_info <-
      calendar_info %>%
      dplyr::mutate(day_type = dplyr::coalesce(day_type_cal, day_type_attr, day_type_text), .after = day_type_text) %>%
      dplyr::select(service_id, day_type, ends_with("date"), totdays, service_description, service_schedule_name, service_schedule_typicality)


    if(write_to_gtfs){
      gtfs$calendar_info <- calendar_info
      gtfs
    } else {
      calendar_info
    }
  }
}
