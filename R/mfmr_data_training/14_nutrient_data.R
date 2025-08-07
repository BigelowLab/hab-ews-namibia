## Plotting nutrient analysis data

library(readxl)
library(dplyr)
library(tidyr)
library(ggplot2)


# mutrient data

read_excel("MultiMeter_Spectro-Data.xlsx", sheet=2)

nt <- read_excel("MultiMeter_Spectro-Data.xlsx", sheet=2, range = cell_cols("A:E")) 

count(nt, `Sample Site`)

# plot one site
filter(nt, `Sample Site` == "Aquapark 4") |>
  pivot_longer(cols = 3:5,
               names_to = "nutrient",
               values_to = "value") |>
  ggplot(aes(x=`Sample Date`, y=value)) +
  geom_line() +
  #scale_x_date(date_breaks = "3 month", date_labels = "%b %Y", limits = c(as.Date("2024-03-01", as.Date("2025-09-01")))) +
  #scale_x_datetime(date_breaks = "3 month", date_labels = "%b %Y") +
  facet_grid(rows = vars(nutrient),
             scales="free")
