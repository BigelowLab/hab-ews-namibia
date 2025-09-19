## Namibia HAB Data Setup Script

# Check for installed packages
installed = dplyr::as_tibble(installed.packages())

# Required packages
packages = list(
  cran = c("readr", "dplyr", "ggplot2", "tidyr", "readxl", "forcats", "knitr", "kableExtra")
)

# If a required package isn't installed, install it; load the package
for (package in packages$cran){
  if (!package %in% installed$Package) {
    cat("installing", package, "from CRAN\n")
    install.packages(package)
  }
  suppressPackageStartupMessages(library(package, character.only = TRUE))
}

# Phytoplankton monitoring data reader function
read_phyto_data <- function(file = "data/Phytoplankton Total Cell_L_2018_2024.xlsx") {
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

# Alert threshold lookup reader
read_threshold <- function(file = "data/alert_thresholds.xlsx") {
  read_excel(file)
}

