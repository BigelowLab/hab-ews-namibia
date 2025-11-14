#' Finds monthly stats for groups of phytoplankton taxon
#' @param x tibble of raw phytoplankton monitoring data
#' @param group character string indicating which toxin producing group to use
#' @returns tibble with one row per year, month
#' 
get_monthly_stats <- function(x, group) {
  
  phyto_sp <- switch(group,
                     ast = c("Pseudo-nitzschia sp.", "Pseudo-nitzschia delicatissima gr.", "Pseudo-nitzschia seriata gr."),
                     dst = c("Dinophysis accuta", "Dinophysis acuminata", "Dinophysis fortii", "Dinophysis rotundata", "Dinophysis sp."),
                     pst = c("Alexandrium sp.", "Alexandrium tamarense", "Alexandrium catenella", "Alexandrium minutum"))

  filter(x, Species %in% phyto_sp) |>
    group_by(subregion, year, month) |>
    summarise(mean = mean(cells),
              med = median(cells),
              max = max(cells),
              sd = sd(cells, na.rm = TRUE),  # Standard deviation
              n = n(),                       # Number of observations
              se = sd / sqrt(n),             # Standard error
              .groups = "drop")
}

#' Plots heatmap of monthly cell abundance statistic (ie mean, median, etc)
#' @param monthly_phyto table of computed cell abundance statistics, one row per year, month
#' @param subregion character string indicating which subregion to make the plot for
#' @returns a ggplot barplot
plot_phyto_barplot <- function(monthly_phyto,
                               colors = myColors,
                               subregion) {
  
  filter(monthly_phyto, subregion == !!subregion) |>
    ggplot(aes(x = month, y = mean, fill = year)) +
    geom_bar(stat = "identity", position = "dodge") +
    scale_y_continuous(expand = c(0, 0)) + 
    scale_x_discrete(labels = function(x) month.abb[as.numeric(x)]) +
    labs(x=element_blank(), y=element_blank()) +
    theme_classic() +
    theme(legend.position = "bottom", legend.direction = "horizontal", legend.title = element_blank()) +
    guides(fill = guide_legend(nrow = 1)) +
    scale_fill_manual(name = "year", values = colors)
}


#' Plots heatmap of monthly cell abundance statistic (ie mean, median, etc)
#' @param monthly_phyto table of computed cell abundance statistics, one row per year, month
#' @param group character string indicating which toxin producing group to use
#' @param subregion character string indicating which subregion to make the plot for
#' @returns a ggplot heatmap
plot_phyto_heatmap <- function(monthly_phyto,
                               #mapping = ,
                               group = c("ast", "dst", "pst")[1],
                               subregion) {
  
  breaks = switch(group,
                  "ast" = c(0,500, 1000, 10000,100000), 
                  "dst" = c(0,500,1000,1500,2000), 
                  "pst" = c(100,200,500,1000))
  
  filter(monthly_phyto, subregion == !!subregion) |>
    ggplot(aes(x=month, y=year, fill=mean)) +
    geom_tile() +
    scale_x_discrete(labels=month.abb) +
    scale_fill_fermenter(breaks = breaks, palette="Spectral") +
    theme_classic() +
    theme(axis.title = element_blank(), legend.title=element_blank())
}


plot_phyto_scatter <- function(x, subregion, threshold, group) {
  
  plot_spec = switch(group,
                     "ast" = c("Pseudo-nitzschia sp.", "Pseudo-nitzschia delicatissima gr.", "Pseudo-nitzschia seriata gr."),
                     "dst" = c("Dinophysis accuta", "Dinophysis acuminata", "Dinophysis fortii", "Dinophysis rotundata", "Dinophysis sp."),
                     "pst" = c("Alexandrium sp.", "Alexandrium tamarense", "Alexandrium catenella", "Alexandrium minutum"))
  
  plot_data <- filter(x, subregion %in% !!subregion)
  
  filter(plot_data, Species %in% plot_spec) |>
    filter(cells > 0) |>
    ggplot(aes(x = `Date Collected`, y = cells)) +
    geom_point(color = "blue") +
    theme_classic() +
    labs(x = "Date", y = "Cells/L")
}

