# Write a function that reads the phytoplankton data and handles any QC steps

library(readxl)
library(dplyr)

x <- read_excel("Phytoplankton Total Cell_L_2018_2024.xlsx") |>
  mutate(`Date Collected` = as.Date(`Date Collected`)) |>
  arrange(`Date Collected`)

summary(x)

# drop duplicates
x <- distinct(x)

# some Cell/L observations are NA
filter(x, is.na(`Cells/L`))

filter(x, !is.na(`Cells/L`))

# count unique stations - are any the same?
st <- count(x, Station)
View(st)
# count unique species - are any the same?
sp <- count(x, Specie)
View(sp)

# make a unique ID for each sample

x <- mutate(x, id = paste(`Date Collected`, Station, Specie, Depth, sep="_"))

count(x, id)

id_counts <- count(x, id) |>
  arrange(desc(n)) |>
  filter(n>1)


# now we can write a function combining all of the QC steps
read_phyto_data <- function(file = "Phytoplankton Total Cell_L_2018_2024.xlsx") {
  read_excel(file) |>
    mutate(`Date Collected` = as.Date(`Date Collected`)) |>
    arrange(`Date Collected`) |>
    distinct() |>
    filter(!is.na(`Cells/L`))
}

# call it like this
read_phyto_data()

