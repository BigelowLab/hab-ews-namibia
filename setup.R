# Setup file for the workshop: "Introduction to Developing Interactive Shiny Applications in R"

installed = rownames(installed.packages())

cran_packages <- c("dplyr", "ggplot2", "readxl", "knitr", "rmarkdown", "leaflet", "sf", "rnaturalearth")

ix = (cran_packages %in% installed)
for (package in cran_packages[!ix]) {
  install.packages(package)
}

suppressPackageStartupMessages({
  for (package in cran_packages) library(package, character.only = TRUE)
})

source("R/stations.R")