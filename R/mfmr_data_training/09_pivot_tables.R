# Pivoting tables between long and wide format, and adding 0 values

install.packages("tidyr")

library(tidyr)
library(dplyr)
library(readr)


x <- read_csv("aquapark4_phytoplankton_2019.csv")

x

# Try pivoting using a small subset of data

h <- select(x, date, Specie, `Cells/L`) |>
  head()

h

# The two arguments you need are `names_from` and `values_from` (the column containing the names and values for new columns)
# In this example, each unique species becomes a new column, and the Cells/L values in their corresponding rows move into them
pivot_wider(data = h,
            names_from = Specie,
            values_from = `Cells/L`)



g <- select(x, date, Specie, `Cells/L`) |>
  pivot_wider(names_from = Specie,
              values_from = `Cells/L`)
# sometimes there are many values matched to the unique identifier columns (like date in this example)
View(g)

# we can pick a single value by supplying a statistic function that returns one (like min, max, mean, etc.)
select(x, date, Specie, `Cells/L`) |>
  pivot_wider(names_from = Specie,
              values_from = `Cells/L`,
              values_fn = max)

# if there are missing values in the new table, we can fill them using the `values_fill` argument
select(x, date, Specie, `Cells/L`) |>
  pivot_wider(names_from = Specie,
              values_from = `Cells/L`,
              values_fn = max,
              values_fill = 0)
