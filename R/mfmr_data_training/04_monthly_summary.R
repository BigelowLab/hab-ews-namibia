# Make a summary plot for Aquapark 4 showing the monthly mean cell abundance of Pseudo-nitzschia (or another species)
# 27 March 2025 + 3 April 2025
# ggplot cheat sheet https://rstudio.github.io/cheatsheets/data-visualization.pdf
# R date format codes https://www.r-bloggers.com/2013/08/date-formats-in-r/


library(readr)
library(dplyr)
library(ggplot2)


x <- read_csv("aquapark4_phytoplankton_2017_2022.csv")

x

# filtering only Pseudo-nitzschia measurements
filter(x, Specie == "Pseudo-nitzschia sp.")

#filter one species name
pn <- filter(x, Specie == "Pseudo-nitzschia sp.")

# filter multiple species names
pn <- filter(x, Specie %in% c("Pseudo-nitzschia sp.", "Pseudo-nitzschia seriata gr.", "Pseudo-nitzschia delicatissima gr."))

# count all of the species values in x
species <- count(x, Specie)

count(pn, Specie)

View(species)

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
format(date2, format="%a") # format a date as just the month number


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

# bar plot for annual monthly cell abundance
ggplot(data = annual_monthly_mean, aes(x=month, y=`Cells/L`, fill=year)) +
  geom_col(position="dodge")

# line plot for annual monthly cell abundance
ggplot(data = annual_monthly_mean, aes(x=month, y=`Cells/L`, fill=year)) +
  geom_line(aes(group=year, color=year))

# heatmap for annual monthly cell abundance

ggplot(data = annual_monthly_mean, aes(x=month, y=year, fill=`Cells/L`)) +
  geom_tile()

ggplot(data = annual_monthly_mean, aes(x=month, y=year, fill=`Cells/L`)) +
  geom_tile() +
  scale_fill_viridis_b()

ggplot(data = annual_monthly_mean, aes(x=month, y=year, fill=`Cells/L`)) +
  geom_tile() +
  scale_fill_fermenter(breaks=c(0, 500, 1000, 5000, 10000, 100000), palette="Spectral")

ggplot(data = annual_monthly_mean, aes(x=month, y=year, fill=`Cells/L`)) +
  geom_tile() +
  scale_fill_fermenter(breaks=c(0, 500, 1000, 5000, 10000, 100000), palette="Spectral") +
  scale_x_discrete(labels=month.abb)


# change to weekly
annual_weekly_mean <- pn |>
  mutate(year = format(`Date Collected`, format="%Y"),
         week = format(`Date Collected`, format="%U")) |>
  group_by(year, week) |>
  summarise(`Cells/L` = mean(`Cells/L`))


ggplot(data = annual_weekly_mean, aes(x=week, y=year, fill=`Cells/L`)) +
  geom_tile() +
  scale_fill_fermenter(breaks=c(0, 500, 1000, 5000, 10000, 100000), palette="Spectral")


# change species to alexanrium
al <- filter(x, Specie == "Alexandrium sp.")


annual_monthly_mean <- al |>
  mutate(year = format(`Date Collected`, format="%Y"),
         month = format(`Date Collected`, format="%m")) |>
  group_by(year, month) |>
  summarise(`Cells/L` = mean(`Cells/L`))


ggplot(data = annual_monthly_mean, aes(x=month, y=year, fill=`Cells/L`)) +
  geom_tile() +
  scale_fill_fermenter(breaks=c(0, 800, 1600, 5000), palette="Spectral") + # we changed the breaks here
  scale_x_discrete(labels=month.abb)
