#' GTFS Calendar Information
#'
#' @param gtfs A GTFS file stored as a list
#' @param write_to_gtfs Logical, whether to return the calendar information
#' as a table or add it to the GTFS as `gtfs$calendar_info`
#'
#' @return If `write_to_gtfs` is TRUE, a GTFS stored as a list. If FALSE,
#' a table
#' @export
#' @importFrom tidyselect starts_with ends_with
#' @importFrom rlang .data
gtfs_calendar_info <- function(gtfs, write_to_gtfs = FALSE) {

  calendar_info <-
    gtfs$calendar %>%
    dplyr::mutate(day_type_cal =
                    dplyr::case_when(monday + tuesday + wednesday + thursday + friday == 5 ~ "Weekday",
                              saturday == 1 ~ "Saturday",
                              sunday == 1 ~ "Sunday"),
                  day_type_text =
                    dplyr::case_when(stringr::str_detect(.data$service_id, "Weekday") ~ "Weekday",
                              stringr::str_detect(.data$service_id, "Saturday") ~ "Saturday",
                              stringr::str_detect(.data$service_id, "Sunday") ~ "Sunday"),
                  .after = .data$service_id)

  calendar_info <-
    calendar_info %>%
    dplyr::select(.data$service_id, starts_with("day_type"), ends_with("date")) %>%
    dplyr::mutate(totdays = .data$end_date - .data$start_date + 1)

  if(calendar_info %>% dplyr::filter(.data$day_type_cal != .data$day_type_text) %>%
     magrittr::use_series(.data$service_id) %>% length() != 0) {
    warning("Disagreement between methods of determining day type")
  }

  if(rlang::is_null(gtfs$calendar_attributes)) {

    calendar_info <-
      calendar_info %>%
      dplyr::mutate(day_type = dplyr::coalesce(.data$day_type_cal, .data$day_type_text), .after = .data$day_type_text) %>%
      dplyr::select(-c(.data$day_type_cal, .data$day_type_text))

    if(write_to_gtfs){
      gtfs$calendar_info <- calendar_info
      gtfs
    } else {
      calendar_info
    }


  } else {
    cal_attr <-
      gtfs$calendar_attributes %>%
      dplyr::select(.data$service_id,
                    .data$service_description,
                    .data$service_schedule_name,
                    .data$service_schedule_typicality,
                    day_type_attr = .data$service_schedule_type)

    calendar_info <- dplyr::left_join(calendar_info, cal_attr, by = "service_id") %>%
      dplyr::relocate(.data$day_type_attr, .after = .data$day_type_text)

    if(calendar_info %>% dplyr::filter(.data$day_type_cal != .data$day_type_attr) %>% magrittr::use_series(.data$service_id) %>% length() != 0) {
      warn_service_ids <- calendar_info %>% dplyr::filter(.data$day_type_cal != .data$day_type_attr) %>% magrittr::use_series(.data$service_id)
      message(paste0("Disagreement between methods of determining day type in service_id: ", warn_service_ids,
                     collapse = "\n"))
    }

    calendar_info <-
      calendar_info %>%
      dplyr::mutate(day_type = dplyr::coalesce(.data$day_type_cal, .data$day_type_attr, .data$day_type_text),
                    .after = .data$day_type_text) %>%
      dplyr::select(.data$service_id, .data$day_type, ends_with("date"), .data$totdays,
                    .data$service_description, .data$service_schedule_name, .data$service_schedule_typicality)


    if(write_to_gtfs){
      gtfs$calendar_info <- calendar_info
      gtfs
    } else {
      calendar_info
    }
  }
}
