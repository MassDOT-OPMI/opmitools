
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
devtools::install_github("MassDOT-OPMI/opmitools")
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
#> # A tibble: 31 × 14
#>    route_id      agenc…¹ route…² route…³ route…⁴ route…⁵ route…⁶ route…⁷ route…⁸
#>    <chr>         <chr>   <chr>   <chr>   <chr>     <int> <chr>   <chr>   <chr>  
#>  1 195           1       195     "Lemue… Supple…       3 "https… FFC72C  000000 
#>  2 Shuttle-Gene… 1       Shuttle ""      Rail R…       3 ""      FFC72C  000000 
#>  3 Shuttle-Gene… 1       Blue L… ""      Rail R…       3 ""      FFC72C  000000 
#>  4 Shuttle-Gene… 1       Commut… ""      Rail R…       3 ""      FFC72C  000000 
#>  5 Shuttle-Gene… 1       North … ""      Rail R…       3 ""      FFC72C  000000 
#>  6 Shuttle-Gene… 1       South … ""      Rail R…       3 ""      FFC72C  000000 
#>  7 Shuttle-Gene… 1       Elevat… ""      Rail R…       3 ""      FFC72C  000000 
#>  8 Shuttle-Gene… 1       Fairmo… ""      Rail R…       3 ""      FFC72C  000000 
#>  9 Shuttle-Gene… 1       Fitchb… ""      Rail R…       3 ""      FFC72C  000000 
#> 10 Shuttle-Gene… 1       Frankl… ""      Rail R…       3 ""      FFC72C  000000 
#> # … with 21 more rows, 5 more variables: route_sort_order <int>,
#> #   route_fare_class <chr>, line_id <chr>, listed_route <chr>,
#> #   network_id <chr>, and abbreviated variable names ¹​agency_id,
#> #   ²​route_short_name, ³​route_long_name, ⁴​route_desc, ⁵​route_type, ⁶​route_url,
#> #   ⁷​route_color, ⁸​route_text_color
#> 
#> $shapes_unused
#> # A tibble: 2,053 × 5
#>    shape_id shape_pt_lat shape_pt_lon shape_pt_sequence shape_dist_traveled
#>    <chr>           <dbl>        <dbl>             <int>               <dbl>
#>  1 pull0141         42.3        -71.1             10001                  NA
#>  2 pull0141         42.3        -71.1             10002                  NA
#>  3 pull0141         42.3        -71.1             10003                  NA
#>  4 pull0141         42.3        -71.1             10004                  NA
#>  5 pull0141         42.3        -71.1             10005                  NA
#>  6 pull0141         42.3        -71.1             10006                  NA
#>  7 pull0141         42.3        -71.1             10007                  NA
#>  8 pull0141         42.3        -71.1             10008                  NA
#>  9 pull0141         42.3        -71.1             10009                  NA
#> 10 pull0141         42.3        -71.1             10010                  NA
#> # … with 2,043 more rows
#> 
#> $stops_unused
#> # A tibble: 2,349 × 19
#>    stop_id       stop_…¹ stop_…² stop_…³ platf…⁴ stop_…⁵ stop_…⁶ zone_id stop_…⁷
#>    <chr>         <chr>   <chr>   <chr>   <chr>     <dbl>   <dbl> <chr>   <chr>  
#>  1 Boat-George   ""      George… "Georg… ""         42.3   -70.9 Boat-G… https:…
#>  2 Boat-Long-So… ""      Long W… "Long … "4"        42.4   -71.0 Boat-L… https:…
#>  3 place-CM-0493 ""      Wareha… ""      ""         41.8   -70.7 CF-zon… https:…
#>  4 place-CM-0547 ""      Buzzar… ""      ""         41.7   -70.6 CF-zon… https:…
#>  5 place-CM-0564 ""      Bourne  ""      ""         41.7   -70.6 CF-zon… https:…
#>  6 place-CM-0790 ""      Hyannis ""      ""         41.7   -70.3 CF-zon… https:…
#>  7 place-DB-0095 ""      Readvi… ""      ""         42.2   -71.1 CR-zon… https:…
#>  8 DB-0095       ""      Readvi… "Readv… ""         42.2   -71.1 CR-zon… https:…
#>  9 place-DB-2205 ""      Fairmo… ""      ""         42.3   -71.1 CR-zon… https:…
#> 10 DB-2205       ""      Fairmo… "Fairm… ""         42.3   -71.1 CR-zon… https:…
#> # … with 2,339 more rows, 10 more variables: level_id <chr>,
#> #   location_type <int>, parent_station <chr>, wheelchair_boarding <int>,
#> #   platform_name <chr>, stop_address <chr>, municipality <chr>,
#> #   on_street <chr>, at_street <chr>, vehicle_type <chr>, and abbreviated
#> #   variable names ¹​stop_code, ²​stop_name, ³​stop_desc, ⁴​platform_code,
#> #   ⁵​stop_lat, ⁶​stop_lon, ⁷​stop_url
```

And remove those components with `gtfs_remove_all()`:

``` r
route_count_pre <- length(mbta_gtfs$routes$route_id)
mbta_gtfs <- gtfs_remove_all(mbta_gtfs)
route_count_post <- length(mbta_gtfs$routes$route_id)
paste0("Route count prior to removal: ", route_count_pre)
#> [1] "Route count prior to removal: 220"
paste0("Route count after removal: ", route_count_post)
#> [1] "Route count after removal: 189"
```

Other use cases might include getting some useful information out of the
`calendar.txt` file:

``` r
mbta_calendar_info <- gtfs_calendar_info(mbta_gtfs)
head(mbta_calendar_info)
#> # A tibble: 6 × 5
#>   service_id             day_type start_date end_date   totdays
#>   <chr>                  <chr>    <date>     <date>     <drtn> 
#> 1 BUS423-hbs43sf1-Wdy-02 <NA>     2023-11-24 2023-11-24  1 days
#> 2 BUS423-hbs43sn1-Wdy-02 <NA>     2023-11-10 2023-11-10  1 days
#> 3 BUS423-hbs43sp1-Wdy-02 <NA>     2023-11-20 2023-11-22  3 days
#> 4 BUS423-hbs43sp6-Sa-02  Saturday 2023-11-18 2023-11-25  8 days
#> 5 BUS423-hbs43sp7-Su-02  Sunday   2023-11-19 2023-11-26  8 days
#> 6 BUS423-hbs43sw1-Wdy-02 Weekday  2023-10-11 2023-12-15 66 days
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

(ridership_plot <-
    rt_ridership %>%  
    filter(day_type_name == "weekday") %>% 
    ggplot(aes(x = rating, y = tot_ons, fill = route_id)) +
    geom_col(position = position_dodge()))
```

<img src="man/figures/README-unnamed-chunk-7-1.png" width="100%" />

Then, we can add the OPMI theme with `theme_opmi()`:

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

### Included Data

`opmitools` contains several reference tables that may be useful,
including a table describing the MBTA service area:

``` r
head(mbta_service_area)
#> # A tibble: 6 × 3
#>   muni_name mbta65 mbta175
#>   <chr>     <lgl>  <lgl>  
#> 1 Arlington TRUE   TRUE   
#> 2 Bedford   TRUE   TRUE   
#> 3 Belmont   TRUE   TRUE   
#> 4 Beverly   TRUE   TRUE   
#> 5 Boston    TRUE   TRUE   
#> 6 Braintree TRUE   TRUE
```

And frequently used demographic information by MA block group:

``` r
head(mabgs_19)
#> # A tibble: 6 × 14
#>   GEOID   pop minopop tothh li45hh li50hh limen…¹   MHHI lowno…² forei…³ minopct
#>   <chr> <dbl>   <dbl> <dbl>  <dbl>  <dbl>   <dbl>  <dbl>   <dbl>   <dbl>   <dbl>
#> 1 2501…   571     231   228     38     46       0  73000    17.7    64.9   0.405
#> 2 2501…  1270     610   327     73     73       0 132750   227.    349.    0.480
#> 3 2501…  2605     290  1064    254    281      98 113800   149.    425.    0.111
#> 4 2502…  1655     578   560     88     88      11 133636   220.    569.    0.349
#> 5 2502…   659     501   234    113    156      30  45370    92.0   227.    0.760
#> 6 2502…  1452     246   700    177    193      26 130645   227.     71.1   0.169
#> # … with 3 more variables: li45pct <dbl>, li50pct <dbl>, lownocarpct <dbl>, and
#> #   abbreviated variable names ¹​limenghh, ²​lownocarhh, ³​foreignbornres
```
