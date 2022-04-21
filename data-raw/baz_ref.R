## code to prepare `baz_ref` dataset goes here
library(dplyr)
library(readr)

baz_ref <- read_csv("./data-raw/master_baz_ref.csv", col_types = "dcddddcc")
baz_ref <-
  baz_ref %>%
  arrange(baz, blkgrp)

usethis::use_data(baz_ref, overwrite = TRUE)
