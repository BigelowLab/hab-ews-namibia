# Examples of renaming columns of a data frame
# 24 April 2025

library(readr)
library(dplyr)

x <- read_csv("aquapark4_phytoplankton_2019.csv")

x

# subsetting columns - only keep the ones listed

select(x, date, Specie, `Cells/L`)

x |> 
  select(date, Specie, `Cells/L`, `Microscope fields`)


# subsetting columns - drop the ones listed using `-`

select(x, -Station, -Depth, -`Microscope fields`, -`SumOfTransect Count`)

# renaming columns - the format is "new name = old name"

rename(x, 
       cells = `Cells/L`,
       fields = `Microscope fields`)

x |> 
  select(date, Specie, `Cells/L`) |>
  rename(cells = `Cells/L`)


glimpse(x)



