## code to prepare `mbta_service_area` dataset goes here
library(readr)
library(dplyr)

mbta_service_area_input <- read_csv("./data-raw/mbta_service_area_input.csv")

mbta_service_area <-
  mbta_service_area_input %>%
  transmute(muni_name,
            mbta65 = mbta65 == 1,
            mbta175 = mbta175 == 1)

usethis::use_data(mbta_service_area, overwrite = TRUE)
