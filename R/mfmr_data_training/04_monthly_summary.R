# Make a summary plot for Aquapark 4 showing the monthly mean cell abundance of Pseudo-nitzschia
# 27 March 2025


library(readr)
library(dplyr)
library(ggplot2)


x <- read_csv("aquapark4_phytoplankton_2017_2022.csv")

x

# filtering only Pseudo-nitzschia measurements
filter(x, Specie == "Pseudo-nitzschia sp.")

pn <- filter(x, Specie == "Pseudo-nitzschia sp.")

# point plot showing every observation
ggplot(data=pn, aes(x=`Date Collected`, y=`Cells/L`)) +
  geom_point()


#dates

date1 <- "2025-03-27"     # this is text
date2 <- as.Date(date1)   # this is a date

date1
date2

class(date1)
class(date2)

# date formats in R (https://www.r-bloggers.com/2013/08/date-formats-in-r/)
format(date2, format="%Y")  # format a date as just the year
format(date2, format="%m"). # format a date as just the month number


# make a monthly mean summary table
monthly_mean <- pn |>
  mutate(year = format(`Date Collected`, format="%Y"),
         month = format(`Date Collected`, format="%m")) |>
  group_by(month) |>
  summarise(`Cells/L` = mean(`Cells/L`))

monthly_mean

# plot monthly mean pseudo-nitzschia cells/L at Aquapark 4
ggplot(data = monthly_mean, aes(x=month, y=`Cells/L`)) +
  geom_col()


# make an annual monthly mean summary table
annual_monthly_mean <- pn |>
  mutate(year = format(`Date Collected`, format="%Y"),
         month = format(`Date Collected`, format="%m")) |>
  group_by(year, month) |>
  summarise(`Cells/L` = mean(`Cells/L`))

annual_monthly_mean

#https://r-graph-gallery.com/48-grouped-barplot-with-ggplot2.html

ggplot(data = annual_monthly_mean, aes(x=month, y=`Cells/L`, fill=year)) +
  geom_col(position="dodge", stat="identity")
