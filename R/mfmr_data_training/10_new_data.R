# steps for cleaning and preparing new data for annual report writing
# 12 June 2025

# install the package readxl
install.packages("readxl")

# load packages
library(readxl)
library(dplyr)
library(tidyr)

read_excel("Phytoplankton Total Cell_L_2018_2024.xlsx")


x <- read_excel("Phytoplankton Total Cell_L_2018_2024.xlsx") |>
  mutate(`Date Collected` = as.Date(`Date Collected`)) |>
  arrange(`Date Collected`)

x

View(x)

# remove duplicates
y <- distinct(x)

# remove rows with NA cells/L values
y <- filter(y, !is.na(`Cells/L`))

# pivot the table into wide form with one column per species
z <- select(y, -`SumOfTransect Count`, -Groups, -`Toxin producing species`, -`Microscope fields`) |>
  pivot_wider(names_from = Specie,
              values_from = `Cells/L`,
              values_fn = max, # for samples with two values, keep the larger
              values_fill = 0) # for species not detected on a specific date/site, add a 0

# we'll use this table for the report moving forward
z

View(z)


library(ggplot2)

# plot all of the Dinophysis acuminata in the new table
ggplot(z, aes(x=`Date Collected`, y=`Dinophysis acuminata`)) +
  geom_point() +
  geom_line()

# plot all of the Dinophysis acuminata in the new table at Aquapark 4
filter(z, Station == "Aquapark 4") |>
  ggplot(aes(x=`Date Collected`, y=`Dinophysis acuminata`)) +
  geom_point() +
  geom_line()

