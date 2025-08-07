## Plotting multimeter data

library(readxl)
library(dplyr)
library(tidyr)
library(ggplot2)

read_excel("MultiMeter_Spectro-Data.xlsx")

mm <- read_excel("MultiMeter_Spectro-Data.xlsx") |>
  select(-`Instrument model`, -`Depth (m) sampled`) |>
  filter(`Salinity (PSU)` < 40) |>
  mutate(month = as.numeric(format(`Sampling date`, format = "%m")))

count(mm, Station) |>
  arrange(desc(n))

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

filter(mm, Station %in% c("Ferm/Tet", "NamOyster", "Beira Aquaculture", "NamAqua")) |>
  select(`Sampling date`, Station, `Dissolved Oxygen (mg/L)`) |>
  ggplot(aes(x = `Sampling date`, y = `Dissolved Oxygen (mg/L)`)) +
  geom_line() +
  facet_grid(rows = vars(Station))


filter(mm, Station %in% c("Ferm/Tet", "NamOyster", "Beira Aquaculture", "NamAqua")) |>
  select(`Sampling date`, Station, `PH (mol/L)`) |>
  ggplot(aes(x = `Sampling date`, y = `PH (mol/L)`)) +
  geom_line() +
  facet_grid(rows = vars(Station))

filter(mm, Station %in% c("Aquapark 4", "Ferm/Tet", "NamOyster", "Beira Aquaculture", "NamAqua")) |>
  select(`Sampling date`, Station, `Temperature (°C)`) |>
  ggplot(aes(x = `Sampling date`, y = `Temperature (°C)`)) +
  geom_line() +
  geom_point() +
  facet_grid(rows = vars(Station))

filter(mm, Station %in% c("Aquapark 4", "NamOyster Salt Pans", "NamOyster")) |>
  select(`Sampling date`, Station, `Temperature (°C)`) |>
  ggplot(aes(x = `Sampling date`, y = `Temperature (°C)`)) +
  geom_line() +
  geom_point() +
  facet_grid(rows = vars(Station))


ggplot(mm, aes(x = `Dissolved Oxygen (mg/L)`, y = `Temperature (°C)`)) +
  geom_point() +
  geom_smooth()

filter(mm, Station == "NamOyster") |>
  select(`Sampling date`, `Dissolved Oxygen (mg/L)`, `Temperature (°C)`) |>
  pivot_longer(cols = 2:3,
               names_to = "param",
               values_to = "value") |>
  ggplot(aes(x=`Sampling date`,
             y = value)) + 
  geom_line() +
  facet_grid(rows = vars(param), scales="free") 
