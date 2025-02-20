# Plot Dinophysis abundance at Aquapark 4 during 2019
# 20 February 2025

# loading packages
library(readr)
library(ggplot2)

library(dplyr)

# read the data into a variable called "x"
x <- read_csv("aquapark4_phytoplankton_2019.csv")

x

# counting the values in the columns "Station" and "Specie"
count(x, Station)

count(x, Specie)

# save the species counts into a variable called "species"
species <- count(x, Specie)

species

# Viewing the table
View(species)

# filter only dinophysis observations
filter(x, Specie == "Dinophysis acuminata")

dino <- filter(x, Specie == "Dinophysis acuminata")

dino

# plot the dinophysis data

ggplot(data = dino, mapping = aes(x = date, y = `Cells/L`)) +
  geom_line()

# add a line to show the alert threshold
ggplot(data = dino, mapping = aes(x = date, y = `Cells/L`)) +
  geom_line() +
  geom_hline(yintercept = 1000)

# makes the alert threshold line red
ggplot(data = dino, mapping = aes(x = date, y = `Cells/L`)) +
  geom_line() +
  geom_hline(yintercept = 1000, color = "red") 

# make the alert threshold line dashed
ggplot(data = dino, mapping = aes(x = date, y = `Cells/L`)) +
  geom_line() +
  geom_hline(yintercept = 1000, color = "red", linetype = "dashed") 

# adds points to the plot
ggplot(data = dino, mapping = aes(x = date, y = `Cells/L`)) +
  geom_line() +
  geom_point() + # adds points
  geom_hline(yintercept = 1000, color = "red", linetype = "dashed")

# add labels for the x,y axis and a title
ggplot(data = dino, mapping = aes(x = date, y = `Cells/L`)) +
  geom_line() +
  geom_point() + 
  geom_hline(yintercept = 1000, color = "red", linetype = "dashed") +
  labs(x = "Sampling Date",
       y = "Cell Abundance (cells/L)",
       title = "2019 Dinohysis acuminata monitoring at Aquapark 4")

# save the plot as an image
ggsave("dinphysis_aquapark4_2019.jpg")


