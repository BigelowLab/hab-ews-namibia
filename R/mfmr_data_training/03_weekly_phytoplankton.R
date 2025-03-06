# plot all DST producing species together
# plot the abundance of all phytoplankton detected in one week
# 6 March 2025


#load packages

library(readr)
library(ggplot2)
library(dplyr)

# read the data
x <- read_csv("aquapark4_phytoplankton_2019.csv")
x<-read_csv("aquapark4_phytoplankton_2019.csv")   #spacing isn't important here
x<-read_csv(   "aquapark4_phytoplankton_2019.csv" )
x

# counting the species and how many times they occur
species <- count(x, Specie)

species

View(species)


# filter only dinophysis

filter(x, Specie == "Dinophysis acuminata")

c("Dinophysis acuminata", "Dinophysis fortii", "Dinophysis sp.")

filter(x, Specie %in% c("Dinophysis acuminata", "Dinophysis fortii", "Dinophysis sp."))

dino <- filter(x, Specie %in% c("Dinophysis acuminata", "Dinophysis fortii", "Dinophysis sp."))


# plot the dinophysis

ggplot(data = dino, aes(x = date, y = `Cells/L`)) +
  geom_line()

# linetype represents species
ggplot(data = dino, aes(x = date, y = `Cells/L`, linetype = Specie)) +
  geom_line()

# line color represents species
ggplot(data = dino, aes(x = date, y = `Cells/L`, colour = Specie)) +
  geom_line()

ggplot(data = dino, aes(x = date, y = `Cells/L`, colour = Specie)) +
  geom_line() +
  geom_hline(yintercept = 1000, linetype = "dashed")


# Weekly Phytoplankton plot

# filter only one week's data
week <- filter(x, date == "2019-03-04")

week

# plot the week's data in a bar plot
ggplot(data = week, aes(x=`Cells/L`, y = Specie)) +
  geom_col()

# highlight the toxin producing species with different colors
ggplot(data = week, aes(x=`Cells/L`, y = Specie, fill=`Toxin producing species`)) +
  geom_col()

# make separate plots for dinoflagellate and diatom groups
ggplot(data = week, aes(x=`Cells/L`, y = Specie, fill=`Toxin producing species`)) +
  geom_col() +
  facet_grid(rows = vars(Groups), scales="free")

# these are the values in the groups column
count(x, Groups)




