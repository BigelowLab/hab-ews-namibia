


plot_okadaic <- function(btx, 
                         subregion, 
                         ylab = "Total Okadaic Acid Group mg/kg", 
                         threshold = 0.16) {
  
  plot_data <- filter(btx, subregion %in% !!subregion) |>
    filter(okadaic_acid < 10 & `Sampling Date` < as.Date("2026-01-01")) # some dates are 2026 and values are in the hundreds
  
  if (length(subregion) > 1) {
    p <- ggplot(plot_data, aes(x = `Sampling Date`, y = okadaic_acid)) +
      geom_point(aes(shape = subregion), color="blue") +
      theme_classic() +
      labs(x=NULL, y=ylab) + 
      theme(legend.position = "bottom", legend.title = element_blank())
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



