

# ecoli
plot_ecoli <- function(mbdata, station) {
  plot_data <- filter(mbdata, 
                      `Test run` == "Escherichia coli", 
                      Station %in% station) |>
    mutate(Counts = as.numeric(case_when(Counts %in% c("<18", "<18g") ~ 18,
                                         Counts == "Absent" ~ 18,
                                         .default = as.numeric(Counts))))
  
  ggplot(plot_data, aes(x = `Sampling date`, y = Counts)) +
    geom_point() +
    scale_x_datetime(date_labels = "%d-%b-%y", 
                     breaks = plot_data$`Sampling date`) +
    geom_hline(yintercept = 230, color="red") +
    theme_classic()  +
    theme(axis.title = element_blank(), 
          legend.title = element_blank(),
          legend.position="bottom",
          axis.text.x = element_text(angle = 90, vjust=0.5, size=8))
  
}



plot_vibrio <- function(mbdata, 
                        species = c("Vibrio vulnificus", "vibrio vulnificus", "Vibrio vulfunicus", "Vibrio vulfnificus", 
                                    "Vibrio parahaemolyticus", "Vibrio cholera"),
                        station) {
  
  vib_lut <- c("Vibrio vulnificus", "Vibrio vulnificus", "Vibrio vulnificus", "Vibrio vulnificus", "Vibrio cholera", "Vibrio parahaemolyticus", "Vibrio campbelli", "Vibrio alginolyticus")
  names(vib_lut) <- c("Vibrio vulnificus", "Vibrio vulfnificus", "Vibrio vulfunicus", "vibrio vulnificus", "Vibrio cholera", "Vibrio parahaemolyticus", "Vibrio campbelli", "Vibrio alginolyticus")
  
  plot_data <- filter(mbdata, 
                      `Test run` %in% species, 
                      Station %in% station) |>
    mutate(Counts = as.factor(case_when(Counts %in% c("<25", "<25g", "-25", "25g", "Absebt", "Absent", 
                                                      "absent", "<10", "<18", "<18g", "absent/25g", "45g", "Absent/25g") ~ "Absent",
                                        Counts %in% c("Present", "Present/25g", ">25") ~ "Present",
                                        !is.na(as.numeric(Counts)) ~ "Present")),
           species = `Test run`,
           `Test run` = vib_lut[.data[["species"]]])
  
  ggplot(plot_data, aes(x = `Sampling date`, y = `Test run`, color = Counts)) +
    geom_point(shape="square", size=6) +
    scale_x_datetime(date_labels = "%d-%b-%y", 
                     breaks = plot_data$`Sampling date`) +
    scale_color_manual(values = c("Absent" = "blue", "Present" = "red")) +
    theme_classic() +
    theme(axis.title = element_blank(), 
          legend.title = element_blank(),
          legend.position="bottom",
          axis.text.x = element_text(angle = 90, vjust=0.5, size=6))
}

#filter(mbdata, `Test run` %in% species) |> count(Counts)

plot_vibrio_par <- function(mbdata, station) {
  plot_data <- filter(mbdata, 
                      `Test run` %in% c("Vibrio parahaemolyticus"), 
                      Station %in% station) |>
    mutate(counts = as.numeric(case_when(Counts == "<10" ~ 0,
                                         Counts == "Absent" ~ 0,
                                         .default = as.numeric(Counts))), .after=Counts)
  
  ggplot(plot_data, aes(x = `Sampling date`, y = counts)) +
    geom_point() +
    scale_x_datetime(date_labels = "%d-%b-%y", breaks = plot_data$`Sampling date`) +
    geom_hline(yintercept = 100, color = "red") +
    theme_classic() +
    theme(axis.title = element_blank(),
          axis.text.x = element_text(angle = 90, vjust=0.5))
}




