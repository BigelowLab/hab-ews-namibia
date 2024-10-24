#' Retrieves a table of location information for HAB monitoring stations
#' @return tibble of locations
get_stations <- function() {
  dplyr::tribble(
    ~station_id,  ~station,               ~lat,       ~lon,
    "pa1",        "Production Area 1",    -22.9205,   14.46789,
    "pa1b",       "Production Area 1b",   -22.9179,   14.4056,
    "pa2",        "Production Area 2",    -22.9264,   14.45032,
    "pa2b",       "Production Area 2b",   -22.9661,   14.42395,
    "pa3",        "Production Area 3",    -26.6492,   15.1397,
    "pa3b",       "Prodiction Area 3b",   -26.6642,   15.14705,
    "pa4",        "Production Area 4",    -26.6167,   15.16523,
    "pa5",        "Production Area 5",    -26.6729,   15.14705
  )
}


get_regions <- function() {
  dplyr::tribble(
    ~name,       ~xmin,   ~ymin,    ~xmax,  ~ymax,    ~longname,
    "namibia",   10,      -30,       25,     -15,       "Namibia Coast",
    "wb",        14.4,    -22.9,     14.48,  -23.0,     "Walvis Bay",
    "lz",        15.1,    -26.7,     15.2,  -26.60,     "Luderitz"
  )
}