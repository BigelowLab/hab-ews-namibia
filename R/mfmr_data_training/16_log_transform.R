## Log transforming phytoplankton cell abundance data

library(readxl)
library(dplyr)

# here we define a vector of numbers
ok <- c(0, 10, 100, 1000, 10000)

ok

# we can pass the vector to `log10()` to get the log transformed values
log10(ok)

# because log10(0) = -Inf, let's add 1 to each value in the vector
log10(ok+1)

# the distribution of values is now smoother
hist(ok)
hist(log10(ok+1))

# read in the phytoplankton data
cells <- read_excel("Phytoplankton Total Cell_L_2018_2024.xlsx") 

# if we plot the distribution of abundance observations, we can see they are heavily weighted towards 0
hist(cells$`Cells/L`)

# lets transform the `Cells/L` using `log10()`
log_cells <- mutate(cells, `Cells/L` = log10(`Cells/L`+1))

# now the distribution is smoother
hist(log_cells$`Cells/L`)
