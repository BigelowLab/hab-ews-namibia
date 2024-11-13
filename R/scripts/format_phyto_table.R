# Script for formatting the phytoplankton monitoring data (using only Aquapark 4 as an example)
# adds 0 value for species not reported
# need to standardize station, species cols

library(readxl)
library(dplyr)
library(tidyr)
library(readr)

x <- read_excel("~/Documents/Bigelow/data/namibia/Qry_Aquapark 4 (Four).xlsx")

stations <- count(x, Station)

species <- count(x, Specie)

id_counts <- x |>
  filter(Station %in% c("Aquapark 4", "Aquapark 4 (112)", "Aquapark 4 112")) |>
  mutate(`Date Collected` = as.Date(`Date Collected`, format="%Y-%m-%d"),
         id = paste(`Date Collected`, Specie, sep="_")) |>
  select(-all_of(c("Station", "Depth", "Microscope fields", "SumOfTransect Count", "Groups", "Toxin producing species"))) |>
  count(id) |>
  arrange(desc(n))


t <- x |>
  filter(Station %in% c("Aquapark 4", "Aquapark 4 (112)", "Aquapark 4 112")) |>
  mutate(`Date Collected` = as.Date(`Date Collected`, format="%Y-%m-%d"),
         id = paste(`Date Collected`, Specie, sep="_")) |>
  select(-all_of(c("Depth", "Microscope fields", "SumOfTransect Count", "Groups", "Toxin producing species"))) |>
  distinct(id, .keep_all=TRUE)


data_wide <- pivot_wider(t, id_cols = `Date Collected`, names_from = Specie, values_from = `Cells/L`, values_fill=0) |>
  arrange(`Date Collected`)

write_csv(data_wide, "aquapark_4_phyto_2017_2022_wide.csv")

data_long <- data_wide |>
  pivot_longer(cols=colnames(r)[2:ncol(r)],
               names_to = "Specie",
               values_to = "Cells/L")

write_csv(data_long, "aquapark_4_phyto_2017_2022_long.csv")
