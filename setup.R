## Namibia HAB Data Setup Script

# Check for installed packages
installed = dplyr::as_tibble(installed.packages())

# Required packages
packages = list(
  cran = c("readr", "dplyr", "ggplot2", "tidyr", "readxl", "forcats", "knitr", "kableExtra", "here")
)

# If a required package isn't installed, install it; load the package
for (package in packages$cran){
  if (!package %in% installed$Package) {
    cat("installing", package, "from CRAN\n")
    install.packages(package)
  }
  suppressPackageStartupMessages(library(package, character.only = TRUE))
}

# project root
here::i_am("setup.R")

read_stations <- function(file = here::here("data", "stations.xlsx")) {
  read_excel(file)
}

st <- read_stations()

add_location_id <- function(x) {
  
  id_lut <- st$code
  names(id_lut) <- st$name
  
  mutate(x, location_id = id_lut[.data[["Station"]]])
}

add_subregion <- function(x) {
  sub_lut <- st$subregion
  names(sub_lut) <- st$name
  
  mutate(x, subregion = sub_lut[.data[["Station"]]])
}

# Phytoplankton monitoring data reader function
read_phyto_data <- function(#file = "data/Phytoplankton Total Cell_L_2018_2024.xlsx",
                            file = here::here("data", "phytoplankton_data.xlsx")) {
  read_excel(file) |>
    add_location_id() |>
    mutate(`Date Collected` = as.Date(`Date Collected`),
           month = format(`Date Collected`, format="%m"),
           week = format(`Date Collected`, format="%U"),
           year = format(`Date Collected`, format="%Y"),
           date = as.Date(`Date Collected`, format="%Y-%m-%d"),
           id = paste(year, week, location_id, sep="_")) |>
    arrange(`Date Collected`) |>
    distinct() |>
    filter(!is.na(`Cells/L`)) |>
    add_subregion()
}

read_toxin_data <- function(file = here::here("data", "biotoxin_data.xlsx")) {
  r <- read_excel(file) |>
    add_location_id() |>
    mutate(`Sampling Date` = as.Date(`Sampling Date`),
           week = format(`Sampling Date`, format="%U"),
           year = format(`Sampling Date`, format="%Y"),
           id = paste(year, week, location_id, sep="_"),
           `Total Okadaic Acid value` = as.numeric(case_when(`Total Okadaic Acid` == "Detected" ~ `Total Okadaic Acid value`,
                                                             `Total Okadaic Acid` == "Not detected" ~ "0",
                                                             `Total Okadaic Acid` == "under detection limit" ~ "0",
                                                             `Total Okadaic Acid` == "Not tested" ~ NA,
                                                             grepl(",", `Total Okadaic Acid value`) ~ gsub(",", ".", `Total Okadaic Acid value`))),
            `Total DTX-1 value` = as.numeric(case_when(`Total DTX-1` == "Detected" ~ `Total DTX-1 value`,
                                                       `Total DTX-1` == "Not Detected" ~ "0",
                                                       `Total DTX-1` == "under detection limit" ~ "0",
                                                       `Total DTX-1` == "Not tested" ~ NA,
                                                       grepl(",", `Total DTX-1 value`) ~ gsub(",", ".", `Total DTX-1 value`))),
           `Yessotoxin value` = as.numeric(case_when(Yessotoxin == "Detected" ~ `Yessotoxin value`,
                                                     Yessotoxin == "Not detected" ~ "0",
                                                     Yessotoxin == "under detection limit" ~ "0",
                                                     Yessotoxin == "Not tested" ~ NA)),
           okadaic_acid = `Total Okadaic Acid value` + `Total DTX-1 value`,
           `PSP Value` = as.numeric(case_when(PSP == "Detected" ~ `PSP Value`,
                                              PSP == "Not detected" ~ 0,
                                              PSP == "under detection limit" ~ 0,
                                              PSP == "Not tested" ~ NA,
                                              PSP == NA ~ NA)),
           `ASP Value` = as.numeric(case_when(ASP == "Detected" ~ `ASP Value`,
                                              ASP == "Not detected" ~ 0,
                                              ASP == "under detection limit" ~ 0,
                                              ASP == "Not tested" ~ NA,
                                              ASP == NA ~ NA)))
  
  return(r)
}

read_env_data <- function(file = here::here("data", "MultiMeter_Spectro-Data.xlsx")) {
  read_excel(file) |>
    mutate(date = as.Date(`Sampling date`, format="%Y-%m-%d")) |>
    select(-`Instrument model`)
}

read_nutrient_data <- function(file = here::here("data", "MultiMeter_Spectro-Data.xlsx")) {
  read_excel(file, sheet=2, range = cell_cols("A:E"))
}

# Alert threshold lookup reader
read_threshold <- function(#file = "data/alert_thresholds.xlsx",
                           file = here::here("data", "alert_thresholds.xlsx")) {
  read_excel(file)
}

read_microbio_data <- function(file = here::here("data", "Microbiology Data for 2025.xlsx")) {
  mb24 <- read_excel(here::here("data", "tbe_Microbiology Data 2024.xlsx"))
  mb25 <- read_excel(file)
  
  r <- bind_rows(mb24, mb25)
  
  return(r)
}

source(here::here("code", "21_phyto_functions.R"))

