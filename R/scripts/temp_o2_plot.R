

library(readxl)
library(ggplot2)
library(dplyr)

# update your path below
x <- read_excel("~/Documents/Bigelow/data/namibia/Mariculture multi-meter raw data.xlsx")

ap1 <- x |>
  filter(Station == "Aquapark 1")

ap4 <- x |>
  filter(Station == "Aquapark 4")

ggplot(data=ap4, aes(x=`Dissolved Oxygen (mg/L)`, y=`Temperature (°C)`)) +
  geom_point()

ggsave(filename = "temp_o2_second.jpg")
