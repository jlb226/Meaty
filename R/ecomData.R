#' Load example dataset
#' 
#' @export
ecomData <- function() {
  filename <- system.file("extdata", "ecomData.csv", package = "Meaty")
  ecomData <- read.csv(filename)
}
