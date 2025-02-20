# Prepares an example dataset of phytoplankton abundance data from "aquapark 4" during 2019

library(readxl)
library(readr)
library(ggplot2)

ap_4 <- read_excel("~/Documents/data/namibia/Qry_Aquapark 4 (Four).xlsx") |>
  filter(Station == "Aquapark 4" & between(`Date Collected`, as.Date("2019-01-01"), as.Date("2019-12-31"))) |>
  arrange(`Date Collected`) |>
  mutate(date = as.Date(`Date Collected`), .before=`Date Collected`) |>
  select(-`Date Collected`)

write_csv(ap_4, "aquapark4_phyto_2019.csv")
