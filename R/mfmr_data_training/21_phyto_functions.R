#' Finds monthly stats for groups of phytoplankton taxon
#' @param x tibble of raw phytoplankton monitoring data
#' @param group character string indicating which toxin producing group to use
#' @returns tibble with one row per year, month
#' 
monthly_stats <- function(x, group) {
  
  phyto_sp <- switch(group,
                     ast = c("Pseudo-nitzschia sp.", "Pseudo-nitzschia delicatissima gr.", "Pseudo-nitzschia seriata gr."),
                     dst = c("Dinophysis accuta", "Dinophysis acuminata", "Dinophysis fortii", "Dinophysis rotundata", "Dinophysis sp."),
                     pst = c("Alexandrium sp.", "Alexandrium Tamarense", "Alexandrium catenella", "Alexandrium minutum"))

  x |>
    select(-`SumOfTransect Count`, 
           -Groups, 
           -`Toxin producing species`,
           -`Microscope fields`) |> # remove columns that we won't use
    pivot_wider(names_from = Specie, # columns that contains the names of the new columns
                values_from = `Cells/L`, # column that contains the values for the new columns
                values_fn = max, 
                values_fill = 0) |>
    select(all_of(c("year", "month", "Station", ast_spec))) |>
    pivot_longer(cols = ast_spec,
                 names_to = "Species",
                 values_to = "cells") |>
    group_by(Station, year, month) |>
    summarise(mean_cells = mean(cells),
              med_cells = median(cells),
              sd = sd(cells, na.rm = TRUE),  # Standard deviation
              n = n(),                       # Number of observations
              se = sd / sqrt(n),             # Standard error
              .groups = "drop")
}


plot_phyto_barplot <- function(monthly_phyto,
                               station) {
  
  filter(pn_monthly_mean, Station == station) |>
    ggplot(aes(x = month, y = `Cells/L`, fill = year)) +
    geom_bar(stat = "identity", position = "dodge") +
    scale_y_continuous(expand = c(0, 0)) + 
    scale_x_discrete(labels = function(x) month.abb[as.numeric(x)]) +
    labs(x = "Month", y = mean_cells, fill = "Year") +
    theme_classic() +
    theme(legend.position = "bottom", legend.direction = "horizontal", legend.title = element_blank()) +
    guides(fill = guide_legend(nrow = 1)) +
    scale_fill_manual(name = "year", values = myColors)
}


plot_phyto_heatmap <- function(monthly_phyto,
                               station,
                               group = c("ast", "dst", "pst")[1]) {
  
  breaks = switch(group,
                  "ast" = c(0,1000,10000,100000), 
                  "dst" = c(0,500,1000,1500,2000), 
                  "pst" = c(100,200,500,1000))
  
  filter(monthly_phyto, Station == station) |>
    ggplot(aes(x=month, y = year, fill = mean_cells)) +
    geom_tile() +
    scale_x_discrete(labels=month.abb) +
    scale_fill_fermenter(breaks = breaks, palette="Spectral") +
    theme_classic() +
    theme(axis.title = element_blank())
}