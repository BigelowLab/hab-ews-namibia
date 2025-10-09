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

# Phytoplankton monitoring data reader function
read_phyto_data <- function(#file = "data/Phytoplankton Total Cell_L_2018_2024.xlsx",
                            file = here::here("data", "Phytoplankton Total Cell_L_2018_2024.xlsx")) {
  read_excel(file) |>
    mutate(`Date Collected` = as.Date(`Date Collected`),
           month = format(`Date Collected`, format="%m"),
           week = format(`Date Collected`, format="%U"),
           year = format(`Date Collected`, format="%Y"),
           date = as.Date(`Date Collected`, format="%Y-%m-%d")) |>
    arrange(`Date Collected`) |>
    distinct() |>
    filter(!is.na(`Cells/L`))
}

read_toxin_data <- function(file = here::here("data", "tbe_Biotoxin Tests_2019_2024.xlsx")) {
  r <- read_excel(file) |>
    mutate(`Sampling Date` = as.Date(`Sampling Date`),
           week = format(`Sampling Date`, format="%U"),
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
           okadaic_acid = `Total Okadaic Acid value` + `Total DTX-1 value`)
  
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



