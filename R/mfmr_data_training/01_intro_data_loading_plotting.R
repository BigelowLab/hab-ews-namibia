# Introduction to loading and plotting data using tidyverse packages

# install the tidyverse family of packages
install.packages("tidyverse")

# load the packages readr and ggplot2
library(readr)
library(ggplot2)

# reading a csv file
read_csv("aquapark4_phytoplankton_2019.csv")

# read the data and assing it to a variable x
x <- read_csv("aquapark4_phytoplankton_2019.csv")

# take a look at the data in the console
x

# print a summary of the columns in x
summary(x)

# make a point plot of every cell/L observation at Aquapark 4 during 2019
ggplot(data = x, aes(x = date, y = `Cells/L`)) +
  geom_point()


