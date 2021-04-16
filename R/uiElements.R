#' UI Elements
#'
#' @param buttonWidth button width
#' @param sideBarWidth (numeric) width of sidebar
#' @param ... UI elements for the box
#'
#' @export
#' @rdname uiElements
box <- function(...){
  shinydashboard::box(...)
}


#' @export
#' @rdname uiElements
panelTitle <- function(sideBarWidth) {
  dashboardHeader(
    title = "Meaty",
    titleWidth = sideBarWidth,
    tags$li(tags$span("Station 01 |"), tags$span("Washington", class = "city"), class = "dropdown")
  )
}

#' @export
#' @rdname uiElements
panelSelectInput <- function(buttonWidth) {
  wellPanel(
    selectizeInput("inputType", "Select input type",
                choices = c("File", "Example Dataset"),
                selected = "Example Dataset"),
    conditionalPanel(
      condition = "input.inputType == 'File' | input.inputType == 'Example Dataset'",
      fileInput(inputId = "file1", label = "File to be uploaded"),
      checkboxInput("header", "Header", TRUE),
      radioButtons("sep", "Separator",
                   choices = c(Comma = ",",
                               Semicolon = ";",
                               Tab = "\t"),
                   selected = ",")
    ),
    conditionalPanel(
      condition = "input.inputType == 'Example Dataset'"
    )
    ,
    style = "color:black"
  )
}


### Shop Level Analytics Elements ###

#' @export
#' @rdname uiElements
shopLevelProductRanking <- function() {
  column(
    width = 5,
    h4("Ranking"),
    box(
      width = 12,
      wellPanel(
        selectInput("numProducts", label = "Top",
                    selected = 0, choices = c(3, 5, 10)),
        dateRangeInput("productsSpanVar", label = "Time Span",
                       start = "2011-01-01", end = "2011-12-31")
      )
    ),
    box(
      width = 6,
      title = "Most Used",
      tableOutput("topProducts")
    ),
    box(
      width = 6,
      title = "Least Used",
      tableOutput("lowProducts")
    )
  )
}


#' @export
#' @rdname uiElements
shopLevelTrendAnalysis <- function() {
  column(
    width = 6,
    h4("Trends"),
    box(
      width = 4,
      wellPanel(
        selectInput("trendVar", label = "Variable",
                    selected = "Costs", choices = c("Sales", "Quantity")),
        dateRangeInput("trendSpanVar", label = "Time Span",
                       start = "2011-01-01", end = "2011-12-31")
      )
    ),
    box(width = 8, plotOutput("trend"))
  )
}


### Individual Level Analysis Elements ###
#' @export
#' @rdname uiElements
customerIdSelection <- function() {
  wellPanel(
    box(
      width = 12,
      selectInput("customerId", "User", choices = "")
    ),
    style = "color:black"
  )
}

