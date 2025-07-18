# Script for producing dissolved oxygen reports for multiple shellfish growers/production sites

library(rmarkdown)

stations <- c("Beira Aquaculture", "Fermar Seafoods CC (109)", "NamAqua", "NamOysters cc Aquapark 1 (101)")

for (s in stations) {
  render(input = "12_oxygen_report.Rmd", 
         output_file = paste("oxygen_report", s, sep="_"),
         params = list(station = s))
}
