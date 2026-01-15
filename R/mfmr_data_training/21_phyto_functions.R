#' Finds monthly stats for groups of phytoplankton taxon
#' @param x tibble of raw phytoplankton monitoring data
#' @param group character string indicating which toxin producing group to use
#' @returns tibble with one row per year, month
#' 
get_monthly_stats <- function(x, group) {
  
  phyto_sp <- switch(group,
                     ast = c("Pseudo-nitzschia sp.", "Pseudo-nitzschia delicatissima gr.", 
                             "Pseudo-nitzschia seriata gr."),
                     dst = c("Dinophysis accuta", "Dinophysis acuminata", "Dinophysis fortii", 
                             "Dinophysis rotundata", "Dinophysis sp."),
                     pst = c("Alexandrium sp.", "Alexandrium tamarense", "Alexandrium catenella", 
                             "Alexandrium minutum"))
    
    filter(x, Species %in% phyto_sp) |>
      group_by(subregion, `Date Collected`) |>
      summarise(cells = sum(cells)) |> # find the weekly sum of all species
      mutate(month = format(`Date Collected`, format = "%m"),
             year = format(`Date Collected`, format = "%Y")) |>
      group_by(subregion, year, month) |> 
      summarise(mean = mean(cells), # find the monthly stats based on weekly values
                med = median(cells),
                max = max(cells),
                sd = sd(cells),
                n = n(),
                se = sd / sqrt(n))
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
    labs(x = (NULL), y= "Average Cells/L") +
    theme_classic() +
    theme(legend.position = "bottom", legend.direction = "horizontal", legend.title = element_blank(), plot.title = element_text(hjust = 0.5)) +
    guides(fill = guide_legend(nrow = 1)) +
    scale_fill_manual(name = "year", values = colors)
}


#' Plots heatmap of monthly cell abundance statistic (ie mean, median, etc)
#' @param x table phytoplankton monitoring data
#' @param group character string indicating which toxin producing group to use
#' @param subregion character string indicating which subregion to make the plot for
#' @returns a ggplot heatmap
plot_phyto_heatmap <- function(x,
                               species,
                               subregion) {
  
  plot_data <- filter(x, subregion == !!subregion, Species == !!species) |>
    mutate(cells = log10(cells+1))
  
  ggplot(plot_data, aes(x = doy, y = year, color = cells)) +
    geom_point(size=6, shape="square") +
    theme_classic() +
    scale_color_fermenter(name = "log cells/L", breaks = c(1,2,3,4,5), palette="Spectral") +
    scale_y_continuous(name = element_blank(), breaks = unique(plot_data$year)) +
    scale_x_continuous(breaks = c(1, 32, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335),
                       labels = month.abb) +
    theme(axis.title = element_blank(), legend.position = "bottom") 
}


plot_phyto_heatmap_facet <- function(x,
                                     species,
                                     station) {
  
  myColors <- brewer.pal(5, "Spectral")
  names(myColors) <- c(0,1)
  
  plot_data <- filter(x, location_id == !!station, Species %in% species) |>
    mutate(cells = log10(cells+1))
  
  cell_breaks <- c(0,1,2,3,4,5)
  myColors <- brewer.pal(length(cell_breaks),"Spectral")
  names(myColors) <- cell_breaks
  
  ggplot(plot_data, aes(x = doy, y = year, color = cells)) +
    geom_point(size=6, shape="square") +
    facet_wrap(vars(Species)) +
    theme_classic() +
    scale_color_fermenter(name = "log cells/L", 
                          breaks = c(0,1,2,3,4,5), 
                          palette="Spectral") +
    #scale_color_manual(name = "log cells/L", values = myColors) +
    scale_y_continuous(name = element_blank(), breaks = unique(plot_data$year)) +
    scale_x_continuous(breaks = c(1, 32, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335),
                       labels = month.abb) +
    theme(axis.title = element_blank(), legend.position = "bottom") 
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
    scale_y_continuous(expand = c(0, 0)) + 
    geom_point(color = "blue") +
    theme_classic() +
    labs(x = "Date", y = "Cells/L")
}


plot_timeseries <- function(x, subregion, threshold, group) {
  
  plot_spec = switch(group,
                     "ast" = c("Pseudo-nitzschia sp.", "Pseudo-nitzschia delicatissima gr.", "Pseudo-nitzschia seriata gr."),
                     "dst" = c("Dinophysis accuta", "Dinophysis acuminata", "Dinophysis fortii", "Dinophysis rotundata", "Dinophysis sp."),
                     "pst" = c("Alexandrium sp.", "Alexandrium tamarense", "Alexandrium catenella", "Alexandrium minutum"))
  
  plot_data <- filter(x, subregion %in% !!subregion)
  
  filter(plot_data, Species %in% plot_spec) |>
    filter(cells > 0) |>
    ggplot(aes(x = `Date Collected`, y = cells)) +
    geom_line(aes(linetype = Species)) +
    theme_classic() +
    labs(x = "Date", y = "Cells/L") +
    theme(legend.position = "bottom")
}



match_phyto_toxin <- function(x, y, group, subregion) {
  phyto_spec = switch(group,
                      dst = c("Dinophysis accuta", "Dinophysis acuminata", "Dinophysis fortii", "Dinophysis rotundata", "Dinophysis sp."),
                      pst = c("Alexandrium sp.", "Alexandrium Tamarense", "Alexandrium catenella", "Alexandrium minutum"))
  
  xx <- filter(x, 
               subregion == !!subregion,
               Species %in% phyto_spec)
  
  yy <- filter(y, subregion %in% !!subregion)
  
  joined = left_join(xx, yy, by=c("id"))
  
  return(joined)
}



#ggplot(plot_data, aes(x=doy, y=cells)) + 
#  geom_point() +
#  theme_classic() +
#  scale_x_continuous(breaks = c(1, 32, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335),
#                     labels = month.abb) +
#  theme(axis.title.x = element_blank(), legend.position = "bottom") +
#  labs(y = "Log Cells/L")


#myColors <- c("#2b83ba", "#abdda4", "#ffffbf", "#fdae61", "#d7191c")

