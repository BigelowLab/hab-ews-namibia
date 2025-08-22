## Join together phytoplankton monitoring data with physical and nutrient observations

# isntalling ggpubr
#install.packages("ggpubr")

library(dplyr)
library(readr)
library(readxl)
library(ggplot2)
library(ggpubr)

# read in each data type
cells <- read_excel("Phytoplankton Total Cell_L_2018_2024.xlsx") |>
  rename(date = `Date Collected`,
         station = Station)

mm <- read_excel("MultiMeter_Spectro-Data.xlsx") |>
  select(-`Instrument model`, -`Depth (m) sampled`) |>
  filter(`Salinity (PSU)` < 40) |>
  rename(station = Station,
         date = `Sampling date`) |>
  distinct()

nt <- read_excel("MultiMeter_Spectro-Data.xlsx", sheet=2, range = cell_cols("A:E")) |>
  rename(station = `Sample Site`,
         date = `Sample Date`)


# join the multimeter and nutrient data into one table first
# we tell the join function which tables we want to merge, and which columns we should join them by
left_join(x = mm, y = nt, by = join_by(station, date))

j <- left_join(mm, nt, by = join_by(station, date))

# the left_join shows us some warnings because there are some station/date combinations that appear more than once
count(mm, station, date) |>
  arrange(desc(n))

View(mm)

# now lets add the environmental data to the cell counts
left_join(cells, j)

z <- left_join(cells, j)

View(z)

# notice that there are a lot of NA values because we dont have environmental data for all the cell counts
summary(z)

count(mm, station)

count(nt, station)

# now we can filter the big table to make a plot for a specific site and group or species
filter(z, station == "Aquapark 4" & Groups == "Diatoms" & `Cells/L` < 3000000) |> 
  ggplot(aes(x = `Temperature (°C)`,
             y = `Cells/L`)) +
  geom_point()

filter(z, station == "Aquapark 4" & Groups == "Diatoms") |> 
  ggplot(aes(x = `Temperature (°C)`,
             y = `Cells/L`)) +
  geom_point()

filter(z, station == "Aquapark 4" & Groups == "Diatoms" & `Cells/L` < 3000000) |> 
  ggplot(aes(x = `Dissolved Oxygen (mg/L)`,
             y = `Cells/L`)) +
  geom_point()

filter(z, station == "Aquapark 4" & Groups == "Dinoflagellates") |> 
  ggplot(aes(x = `Dissolved Oxygen (mg/L)`,
             y = `Cells/L`)) +
  geom_point()


filter(z, station == "Aquapark 4" & Groups == "Diatoms" & `Cells/L` < 3000000) |> 
  ggplot(aes(x = `Dissolved Oxygen (mg/L)`,
             y = `Temperature (°C)`)) +
  geom_point() 

filter(z, station == "Aquapark 4" & Groups == "Diatoms" & `Cells/L` < 3000000) |> 
  ggplot(aes(x = `Silicate`,
             y = `Cells/L`)) +
  geom_point() +
  stat_cor()

filter(z, station == "Swakopmund Jetty" & Groups == "Diatoms" & `Cells/L` < 250000) |> 
  ggplot(aes(x = `Silicate`,
             y = `Cells/L`)) +
  geom_point()


filter(z, station == "Aquapark 4" & Groups == "Dinoflagellates") |> 
  ggplot(aes(x = `Nitrate`,
             y = `Cells/L`)) +
  geom_point()

filter(z, Groups == "Dinoflagellates" & `Cells/L` < 2500000) |> 
  ggplot(aes(x = `Silicate`,
             y = `Cells/L`)) +
  geom_point()

filter(z, Groups == "Diatoms" & `Cells/L` < 2500000) |> 
  ggplot(aes(x = `Silicate`,
             y = `Cells/L`)) +
  geom_point() 


# adding correlation coefficients

filter(z, station == "Aquapark 4" & Groups == "Diatoms" & `Cells/L` < 3000000) |> 
  ggplot(aes(x = `Temperature (°C)`,
             y = `Cells/L`)) +
  geom_point() +
  stat_cor()

filter(z, station == "Aquapark 4" & Groups == "Diatoms" & `Cells/L` < 3000000) |> 
  ggplot(aes(x = `Dissolved Oxygen (mg/L)`,
             y = `Cells/L`)) +
  geom_point() +
  stat_cor()

filter(z, Groups == "Diatoms" & `Cells/L` < 2500000) |> 
  ggplot(aes(x = `Silicate`,
             y = `Cells/L`)) +
  geom_point() +
  stat_cor()

# summarise phytoplankton cell counts by group (ie diatom, dinoflagellate)

grouped_cells <- cells |>
  group_by(station, date, Groups) |>
  summarise(`Cells/L` = sum(`Cells/L`))

zz <- left_join(grouped_cells, j)

filter(zz, Groups == "Diatoms" & `Cells/L` < 2500000) |> 
  ggplot(aes(x = `Silicate`,
             y = `Cells/L`)) +
  geom_point() +
  stat_cor()

