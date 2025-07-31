## Plotting multimeter data

library(readxl)
library(dplyr)
library(tidyr)
library(ggplot2)

read_excel("MultiMeter_Spectro-Data.xlsx", sheet=2)

mm <- read_excel("MultiMeter_Spectro-Data.xlsx") |>
  select(-`Instrument model`, -`Depth (m) sampled`) |>
  filter(`Salinity (PSU)` < 40) |>
  mutate(month = as.numeric(format(`Sampling date`, format = "%m")))

count(mm, Station)

# plot one site
filter(mm, Station == "Aquapark 4") |>
  select(-`Conductivity (S/m)`, -`TDS (ppm)`, -`Resistivity (Ω⋅m)`) |>
  pivot_longer(cols = 3:7,
               names_to = "param",
               values_to = "value") |>
  ggplot(aes(x=`Sampling date`,
             y = value)) + 
  geom_line() +
  facet_grid(rows = vars(param), scales="free") 

filter(mm, 
       Station == "Aquapark 4",
       between(`Sampling date`, as.Date("2025-04-01"), as.Date("2025-06-30"))) |>
  select(-`Conductivity (S/m)`, -`TDS (ppm)`, -`Resistivity (Ω⋅m)`) |>
  pivot_longer(cols = 3:7,
               names_to = "param",
               values_to = "value") |>
  ggplot(aes(x=`Sampling date`,
             y = value)) + 
  geom_line() +
  geom_point() +
  facet_grid(rows = vars(param), scales="free") +
  scale_x_datetime(date_labels = "%b %d", date_breaks = "2 week")


filter(mm, Station == "Aquapark 4") |>
  arrange(`Dissolved Oxygen (mg/L)`)

