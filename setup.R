## Namibia HAB Data Setup Script

# Check for installed packages
installed = dplyr::as_tibble(installed.packages())

# Required packages
packages = list(
  cran = c("readr", "dplyr", "ggplot2", "tidyr", "readxl", "forcats", "knitr", "kableExtra", "here", "RColorBrewer")
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

add_groups <- function(x, file = here::here("data", "plankton_groups.csv")) {
  groups <- read_csv(file)
  group_lut <- groups$Groups
  names(group_lut) <- groups$Specie
  
  mutate(x, Groups = group_lut[.data[["Species"]]])
}

add_tps <- function(x, file = here::here("data", "toxin_producing_species.csv")) {
  tps <- read_csv(file)
  tps_lut <- tps$`Toxin producing species`
  names(tps_lut) <- tps$Specie
  
  mutate(x, `Toxin producing species` = tps_lut[.data[["Species"]]])
}

fix_species <- function(x, lut_file = here::here("data", "phyto_lut.xlsx")) {
  phyto_spec = read_excel(lut_file)
  
  lut = phyto_spec$new_species
  names(lut) = phyto_spec$Species
  
  mutate(x, Specie = lut[.data[["Specie"]]])
}

# Phytoplankton monitoring data reader function
read_phyto_data <- function(file = here::here("data", "phytoplankton_data.xlsx")) {
  zz <- read_excel(file) |>
    select(-`SumOfTransect Count`,     # remove columns that we won't use
           -Groups, 
           -`Toxin producing species`,
           -`Microscope fields`) |>
    mutate(Depth = tolower(Depth)) |>
    fix_species() |>
    pivot_wider(names_from = Specie, # columns that contains the names of the new columns
                values_from = `Cells/L`, # column that contains the values for the new columns
                values_fn = max, 
                values_fill = 0) |>
    pivot_longer(cols = !all_of(c("Date Collected", "Station", "Depth")),
                 names_to = "Species",
                 values_to = "cells") |>
    add_location_id() |>
    add_subregion() |>
    add_tps() |>
    add_groups() |>
    mutate(`Date Collected` = as.Date(`Date Collected`),
           month = format(`Date Collected`, format="%m"),
           week = format(`Date Collected`, format="%U"),
           year = format(`Date Collected`, format="%Y"),
           date = as.Date(`Date Collected`, format="%Y-%m-%d"),
           id = paste(year, week, subregion, sep="_")) |>
    arrange(`Date Collected`) |>
    distinct() 
}

read_toxin_data <- function(file = here::here("data", "tbe_Biotoxin Tests_2019_2024.xlsx")) {
  r <- read_excel(file) |>
    add_location_id() |>
    add_subregion() |>
    rowwise() |>
    mutate(`Sampling Date` = as.Date(`Sampling Date`),
           week = format(`Sampling Date`, format="%U"),
           year = format(`Sampling Date`, format="%Y"),
           id = paste(year, week, subregion, sep="_"),
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
           okadaic_acid = sum(`Total Okadaic Acid value`,`Total DTX-1 value`, na.rm=TRUE),
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
    select(-`Instrument model`) |>
    add_subregion()
}

read_nutrient_data <- function(file = here::here("data", "MultiMeter_Spectro-Data.xlsx")) {
  read_excel(file, sheet=2, range = cell_cols("A:E")) |>
    rename(Station = `Sample Site`) |>
    add_subregion()
}

# Alert threshold lookup reader
read_threshold <- function(#file = "data/alert_thresholds.xlsx",
                           file = here::here("data", "alert_thresholds.xlsx")) {
  read_excel(file)
}

read_microbio_data <- function() {
  mb24 <- read_excel(here::here("data", "tbe_Microbiology Data 2024.xlsx"))
  mb25 <- read_excel(here::here("data", "Microbiology Data for 2025.xlsx"))
  
  r <- bind_rows(mb24, mb25)
  
  return(r)
}

source(here::here("code", "21_phyto_functions.R"))
source(here::here("code", "23_biotoxin_functions.R"))
source(here::here("code", "phyto_toxin_functions.R"))


