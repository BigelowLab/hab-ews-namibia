


plot_okadaic <- function(btx, 
                         subregion, 
                         ylab = "Total Okadaic Acid Group mg/kg", 
                         threshold = 0.16) {
  
  plot_data <- filter(btx, subregion %in% !!subregion) # some dates are 2026 and values are in the hundreds
  
  if (length(subregion) > 1) {
    p <- ggplot(plot_data, aes(x = `Sampling Date`, y = okadaic_acid)) +
      geom_point(aes(shape = subregion, color=subregion)) +
      scale_x_date(date_labels = "%d-%b-%y", date_breaks = "3 months") +
      theme_classic() +
      labs(x=NULL, y=ylab) + 
      theme(legend.position = "bottom", 
            legend.title = element_blank(),
            axis.text.x = element_text(angle = 90, vjust=0.5, size=8))
  } else {
    p <- ggplot(plot_data, aes(x = `Sampling Date`, y = okadaic_acid)) +
      geom_point(color="blue") +
      theme_classic() +
      labs(x=NULL, y=ylab) 
  }
  
  
  if (!is.null(threshold)) {
    p <- p + geom_hline(yintercept = threshold, color="red")
  }
  
  p
  
  return(p)
}


plot_yessotoxin <- function(btx, 
                            subregion, 
                            ylab = "Total Yessotoxin Group mg/kg", 
                            threshold) {
  
  plot_data <- filter(btx, subregion %in% !!subregion)
  
  if (length(subregion) > 1) {
    p <- ggplot(plot_data, aes(x = `Sampling Date`, y = `Yessotoxin value`)) +
      geom_point(aes(shape = subregion), color="blue") +
      theme_classic() +
      labs(x=NULL, y=ylab) + 
      theme(legend.position = "bottom", legend.title = element_blank())
  } else {
    p <- ggplot(plot_data, aes(x = `Sampling Date`, y = `Yessotoxin value`)) +
      geom_point(color="blue") +
      theme_classic() +
      labs(x=NULL, y=ylab) 
  }
  return(p)
}


plot_saxitoxin <- function(btx, subregion, threshold = 80, ylab = "PST value ug STX eq/100g") {
  
  plot_data <- filter(btx, subregion %in% !!subregion)
  
  if (length(subregion) > 1) {
    ggplot(plot_data, aes(x = `Sampling Date`, y = `PSP Value`)) +
      geom_point(aes(shape = subregion), color="blue") +
      geom_hline(yintercept = threshold, color = "red") +
      theme_classic() +
      labs(x=NULL, y=ylab) + 
      theme(legend.position = "bottom", legend.title = element_blank())
  } else {
    ggplot(plot_data, aes(x = `Sampling Date`, y = `PSP Value`)) +
      geom_point(color="blue") +
      geom_hline(yintercept = threshold, color = "red") +
      theme_classic() +
      labs(x=NULL, y=ylab)
  }
}


plot_pst_heatmap <- function(y, subregion) {
  
  myColors <- c("blue", "#ffeda0", "#D95F02")
  names(myColors) <- c(0,1,2)
  
  filter(y, subregion == !!subregion) |>
    ggplot(aes(x = doy, y = year, color = pst_class)) +
    geom_point(size=6, shape="square") +
    facet_wrap(vars(Station)) +
    theme_classic() +
    scale_color_manual(name="PST Level", values = myColors, labels=c("0", "<80", ">80")) +
    scale_y_continuous(name = element_blank(), breaks = unique(y$year)) +
    scale_x_continuous(breaks = c(1, 32, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335),
                       labels = month.abb) +
    theme(axis.title = element_blank()) 
}


plot_dst_heatmap <- function(y, subregion) {
  myColors <- c("blue", "#D95F02")
  names(myColors) <- c(0,1)
  
  filter(y, subregion == !!subregion) |>
    ggplot(aes(x = doy, y = year, color = dst_class)) +
    geom_point(size=5, shape="square") +
    facet_wrap(vars(Station)) +
    theme_classic() +
    scale_color_manual(name="Okadaic Acid Level", values = myColors, labels=c("<0.16", ">0.16")) +
    scale_y_continuous(name = element_blank(), breaks = unique(y$year)) +
    scale_x_continuous(breaks = c(1, 32, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335),
                       labels = month.abb) +
    theme(axis.title = element_blank()) 
}


recode_classification <- function(v, 
                                  lut = c(0,0.16), 
                                  na_value = 0){
  na <- is.na(v)
  v[na] <- na_value
  
  ix <- findInterval(v, lut) -1
  
  return(ix)
} 
