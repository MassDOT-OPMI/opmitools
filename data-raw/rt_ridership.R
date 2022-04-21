## code to prepare `rt_ridership` dataset goes here
library(readr)
library(dplyr)
library(stringr)
rt_csv <- read_csv("./data-raw/Line,_and_Stop.csv")

rt_ridership <-
  rt_csv %>%
  group_by(fall_yr = as.numeric(str_remove(season, "Fall ")), route_id, day_type_name) %>%
  summarize(tot_ons = sum(average_ons))
rt_ridership <-
  rt_ridership %>%
  mutate(route_id = factor(route_id, levels = c("Red", "Orange", "Green", "Blue"))) %>%
  ungroup()
usethis::use_data(rt_ridership, overwrite = TRUE)
