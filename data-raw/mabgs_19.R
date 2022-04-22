## code to prepare `mabgs19` dataset goes here

## Basic Census (ACS) API Pull in R (Sample)
## With Frequently-Used Equity Demographics
## By Julianna Horiuchi

## Pull census data ##
library(dplyr)
library(tidyr)
library(tidycensus)

# Load census key from https://api.census.gov/data/key_signup.html
# census_api_key("") # add your own key

# Load all variables for viewing if needed
# variables <- load_variables(year = 2019, dataset = "acs5")

# Pull BG-level variables
pops <- get_acs(geography = "block group",
                variables = c("B03002_001", "B03002_003", #population variables, _001 is population, _003 is white non-hisp population
                              "B19001_001", # total HH
                              "B19001_002", "B19001_003", #next four lines are income variables, 5k groups by HH, starting with < 10k
                              "B19001_004", "B19001_005", "B19001_006",
                              "B19001_007", "B19001_008", "B19001_009",
                              "B19001_010", # 45-50k
                              "B19013_001", # median income
                              "C16002_004", "C16002_007", "C16002_010", "C16002_013" # limited english (Spanish, other indo-eur, asian-pacific, other)
                ),
                output = "wide",
                state = "MA",
                year = 2019)

# Aggregate BG census variables
pops <-
  pops %>%
  transmute(GEOID,
            pop = B03002_001E,
            minopop = B03002_001E - B03002_003E,
            minopct = minopop/pop,
            tothh = B19001_001E,
            li45hh = B19001_007E + B19001_002E + B19001_003E + #all <= 45k HHs
              B19001_004E + B19001_005E + B19001_006E + B19001_008E +
              B19001_009E,
            li50hh = li45hh + B19001_010E, # can skip depending on def
            li45pct = li45hh/tothh,
            li50pct = li50hh/tothh, # can skip depending on def
            limenghh = C16002_004E + C16002_007E + C16002_010E + C16002_013E,
            MHHI = B19013_001E
  )

# Pull tract-level variables
popstract <- get_acs(geography = "tract",
                     variables = c("B03002_001", # pop
                                   "B08201_001", # hh
                                   "B08201_002", # all no cars,
                                   "B08201_015", # 2 person HH one car
                                   "B08201_021", # 3 person HH one car
                                   "B08201_027", "B08201_028", # 4+ person HH 1-2 car
                                   "B05006_001" # foreign born population
                     ),
                     output = "wide",
                     state = "MA",
                     year = 2019)

# Aggregate tract census variables
popstract <-
  popstract %>%
  transmute(GEOID,
            tractpop = B03002_001E, tractHH = B08201_001E,
            lownocarHH = B08201_002E + B08201_021E + B08201_027E, # no 2p 1-car or 4+p 2-car
            lownocarHHeq = B08201_002E + B08201_015E + B08201_021E + # "eq" includes 2-person HH 1 car and 4+p HH 2 car as limited car
              B08201_027E + B08201_028E,
            foreignbornpop = B05006_001E,
            lownocarHHpct = lownocarHH/tractHH,
            foreignbornrespct = foreignbornpop/tractpop) %>%
  select(GEOID, ends_with("pct"))

# Add tract-level data to BG-level data, apply percents down
BGdemos <- pops %>%
  separate(GEOID, into = c("tract", "bg"), sep = 11) %>%
  left_join(popstract, by = c("tract" = "GEOID")) %>%
  mutate(lownocarhh = lownocarHHpct*tothh,
         foreignbornres = foreignbornrespct*pop) %>%
  unite(col = "GEOID", tract:bg, sep = "")
BGdemos <- BGdemos %>%
  select(-ends_with("pct"))

# Calculate equity percentages (add variables as needed)
BGdemos <-
  BGdemos %>%
  mutate(minopct = minopop/pop
         ,li45pct = li45hh/tothh
         ,li50pct = li50hh/tothh
         ,lownocarpct = lownocarhh/tothh
  )

# Export
mabgs_19 <- BGdemos

usethis::use_data(mabgs_19, overwrite = TRUE)
