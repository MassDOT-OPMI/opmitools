
<!-- README.md is generated from README.Rmd. Please edit that file -->

# opmitools

<!-- badges: start -->
<!-- badges: end -->

`opmitools` serves 3 primary purposes:

1.  Functions for cleaning and merging GTFS files (building on
    [`tidytransit`](https://github.com/r-transit/tidytransit))
2.  Presenting data consistent with OPMI’s Office Theme (building on
    [`ggplot2`](https://ggplot2.tidyverse.org/))
    1.  This part of the package draws on “[Creating corporate colour
        palettes for
        ggplot2](https://drsimonj.svbtle.com/creating-corporate-colour-palettes-for-ggplot2)”
3.  Access to common reference tables

## Installation

You can install the development version of opmitools from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("kmeakinmbta/opmitools")
```

And load/attach opmitools as you would any other package with:

``` r
library(opmitools)
```

## Usage

### GTFS Files

Read the current MBTA GTFS from [mbta.com](https://www.mbta.com/) with:

``` r
mbta_gtfs <- read_mbta_gtfs()
#> File downloaded to C:\Users\meakink\AppData\Local\Temp\Rtmp6bDri4\gtfs322479da5b13.zip.
#> Unzipped the following files to C:\Users\meakink\AppData\Local\Temp\Rtmp6bDri4/gtfsio:
#>   * agency.txt
#>   * calendar.txt
#>   * calendar_attributes.txt
#>   * calendar_dates.txt
#>   * checkpoints.txt
#>   * directions.txt
#>   * facilities.txt
#>   * facilities_properties.txt
#>   * facilities_properties_definitions.txt
#>   * feed_info.txt
#>   * levels.txt
#>   * lines.txt
#>   * linked_datasets.txt
#>   * multi_route_trips.txt
#>   * pathways.txt
#>   * route_patterns.txt
#>   * routes.txt
#>   * shapes.txt
#>   * stop_times.txt
#>   * stops.txt
#>   * transfers.txt
#>   * trips.txt
#> Reading agency.txt
#> Reading calendar.txt
#> Reading calendar_attributes.txt
#>   - File undocumented. Trying to read it as a csv.
#> Reading calendar_dates.txt
#> Reading checkpoints.txt
#>   - File undocumented. Trying to read it as a csv.
#> Reading directions.txt
#>   - File undocumented. Trying to read it as a csv.
#> Reading facilities.txt
#>   - File undocumented. Trying to read it as a csv.
#> Reading facilities_properties.txt
#>   - File undocumented. Trying to read it as a csv.
#> Reading facilities_properties_definitions.txt
#>   - File undocumented. Trying to read it as a csv.
#> Reading feed_info.txt
#> Reading levels.txt
#> Reading lines.txt
#>   - File undocumented. Trying to read it as a csv.
#> Reading linked_datasets.txt
#>   - File undocumented. Trying to read it as a csv.
#> Reading multi_route_trips.txt
#>   - File undocumented. Trying to read it as a csv.
#> Reading pathways.txt
#> Reading route_patterns.txt
#>   - File undocumented. Trying to read it as a csv.
#> Reading routes.txt
#> Reading shapes.txt
#> Reading stop_times.txt
#> Reading stops.txt
#> Reading transfers.txt
#> Reading trips.txt
```

`read_mbta_gtfs()` is a wrapper for `tidytransit::read_gtfs()`. It
stores the individual tables in a list and enforces column types as
specified in the GTFS standard.

For some downstream trip planners and other applications, it is
useful/necessary to remove all extraneous stops, shapes, routes, and
`service_id`s (i.e., those that are not used in the either `trips.txt`
or `stop_times.txt`). You can check for extraneous components with
`gtfs_removal_check()`:

``` r
gtfs_removal_check(mbta_gtfs)
#> $routes_unused
#> # A tibble: 48 x 13
#>    route_id   agency_id route_short_name route_long_name   route_desc route_type
#>    <chr>      <chr>     <chr>            <chr>             <chr>           <int>
#>  1 CR-Foxboro 1         ""               Foxboro Event Se~ Commuter ~          2
#>  2 72         1         "72"             Aberdeen Avenue ~ Local Bus           3
#>  3 79         1         "79"             Arlington Height~ Local Bus           3
#>  4 84         1         "84"             Arlmont Village ~ Commuter ~          3
#>  5 136        1         "136"            Reading Depot - ~ Local Bus           3
#>  6 170        1         "170"            Waltham Center -~ Commuter ~          3
#>  7 195        1         "195"            Lemuel Shattuck ~ Supplemen~          3
#>  8 212        1         "212"            Quincy Center St~ Commuter ~          3
#>  9 214        1         "214"            Germantown - Qui~ Local Bus           3
#> 10 221        1         "221"            Fort Point - Qui~ Commuter ~          3
#> # ... with 38 more rows, and 7 more variables: route_url <chr>,
#> #   route_color <chr>, route_text_color <chr>, route_sort_order <int>,
#> #   route_fare_class <chr>, line_id <chr>, listed_route <chr>
#> 
#> $stops_unused
#> # A tibble: 2,366 x 19
#>    stop_id stop_code stop_name stop_desc platform_code stop_lat stop_lon zone_id
#>    <chr>   <chr>     <chr>     <chr>     <chr>            <dbl>    <dbl> <chr>  
#>  1 31258   "31258"   88 Black~ "88 Blac~ ""                42.3    -71.0 ""     
#>  2 place-~ ""        Wareham ~ ""        ""                41.8    -70.7 "CF-zo~
#>  3 CM-049~ ""        Wareham ~ "Wareham~ "1"               41.8    -70.7 "CF-zo~
#>  4 place-~ ""        Buzzards~ ""        ""                41.7    -70.6 "CF-zo~
#>  5 CM-054~ ""        Buzzards~ "Buzzard~ "1"               41.7    -70.6 "CF-zo~
#>  6 place-~ ""        Bourne    ""        ""                41.7    -70.6 "CF-zo~
#>  7 CM-056~ ""        Bourne    "Bourne ~ "1"               41.7    -70.6 "CF-zo~
#>  8 place-~ ""        Hyannis   ""        ""                41.7    -70.3 "CF-zo~
#>  9 CM-079~ ""        Hyannis   "Hyannis~ "1"               41.7    -70.3 "CF-zo~
#> 10 place-~ ""        Readville ""        ""                42.2    -71.1 "CR-zo~
#> # ... with 2,356 more rows, and 11 more variables: stop_url <chr>,
#> #   level_id <chr>, location_type <int>, parent_station <chr>,
#> #   wheelchair_boarding <int>, platform_name <chr>, stop_address <chr>,
#> #   municipality <chr>, on_street <chr>, at_street <chr>, vehicle_type <chr>
```

And remove those components with `gtfs_remove_all()`:

``` r
route_count_pre <- length(mbta_gtfs$routes$route_id)
mbta_gtfs <- gtfs_remove_all(mbta_gtfs)
route_count_post <- length(mbta_gtfs$routes$route_id)
paste0("Route count prior to removal: ", route_count_pre)
#> [1] "Route count prior to removal: 249"
paste0("Route count after removal: ", route_count_post)
#> [1] "Route count after removal: 201"
```

Other use cases might include getting some useful information out of the
`calendar.txt` file:

``` r
mbta_calendar_info <- gtfs_calendar_info(mbta_gtfs)
head(mbta_calendar_info)
#> # A tibble: 6 x 5
#>   service_id             day_type start_date end_date   totdays
#>   <chr>                  <chr>    <date>     <date>     <drtn> 
#> 1 BUS222-hba22pt1-Wdy-02 <NA>     2022-04-18 2022-04-18 1 days 
#> 2 BUS222-hba22sn1-Wdy-02 <NA>     2022-04-19 2022-04-22 4 days 
#> 3 BUS222-hbb22ns1-Wdy-02 Weekday  2022-04-18 2022-04-22 5 days 
#> 4 BUS222-hbc22ns1-Wdy-02 Weekday  2022-04-18 2022-04-22 5 days 
#> 5 BUS222-hbf22ns1-Wdy-02 Weekday  2022-04-18 2022-04-22 5 days 
#> 6 BUS222-hbg22ns1-Wdy-02 Weekday  2022-04-18 2022-04-22 5 days
```

Note that `opmitools` is not yet capable of handling GTFS-Pathways – it
is only set up to handle the required GTFS files used by the MBTA:
agency, calendar, routes, shapes, stop_times, stops, and trips. While
some functions will work without `tidytransit`, it is recommended to
install and attach `tidytransit` in conjunction with `opmitools`.

### Plotting

`opmitools` contains several convenience functions for making
“OPMI-themed” plots. As an example, we can plot information from
`rt_ridership`, which is included in the package.

The following code creates a simple ggplot showing fall average weekday
ridership on rapid transit.

``` r
library(tidyverse) # load & attach tidyverse for data wrangling with dplyr and plotting with ggplot2
#> -- Attaching packages --------------------------------------- tidyverse 1.3.1 --
#> v ggplot2 3.3.5     v purrr   0.3.4
#> v tibble  3.1.6     v dplyr   1.0.8
#> v tidyr   1.2.0     v stringr 1.4.0
#> v readr   2.1.2     v forcats 0.5.1
#> -- Conflicts ------------------------------------------ tidyverse_conflicts() --
#> x dplyr::filter() masks stats::filter()
#> x dplyr::lag()    masks stats::lag()

(ridership_plot <-
    rt_ridership %>%  
    filter(day_type_name == "weekday") %>% 
    ggplot(aes(x = rating, y = tot_ons, fill = route_id)) +
    geom_col(position = position_dodge()))
```

<img src="man/figures/README-unnamed-chunk-7-1.png" width="100%" />

Then, we could add the OPMI theme with `theme_opmi()`:

``` r
(ridership_plot <-
   ridership_plot +
   labs(x = "Rating", y = "Average\nWeekday\nBoardings") +
   theme_opmi())
```

<img src="man/figures/README-unnamed-chunk-8-1.png" width="100%" />

And use colors that make sense with `scale_fill_opmi()`:

``` r
ridership_plot +
  scale_fill_opmi(palette = "rt", guide = "none")
```

<img src="man/figures/README-unnamed-chunk-9-1.png" width="100%" />
