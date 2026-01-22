# Exports toxic phytoplankton group summary statistics to a csv file

source("setup.R")

x <- read_phyto_data()

y <- get_monthly_stats(x, group="ast")

write_csv(y, "data/pn_monthly_stats.csv")