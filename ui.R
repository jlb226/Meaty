
ecomDataSet <- read.csv("extdata/ecomData.csv", header = TRUE, sep = ",")

buttonWidth <- 220
sideBarWidth <- 250

dashboardPage(
  skin = "blue",
  header = panelTitle(sideBarWidth),
  sidebar = dashboardSidebar(
    width = sideBarWidth,
    shinyjs::useShinyjs(),
    panelSelectInput(buttonWidth)
  ),
  body = dashboardBody(
    tags$head(
      tags$link(
        rel = "stylesheet",
        type = "text/css",
        href = "styleDefinitions.css"
      ),
      tags$style(HTML(".fa{font-size: 18px; opacity: 0.3;}")),
      tags$style(HTML("li{font-size: 18px; color: #ffffff; padding: 10px 30px;}")),
      tags$style(HTML(".city{color:#b3d0ec;}")),
      tags$style(HTML('.col-sm-1{height: 90px;}'))
      ),
    tabsetPanel(
      tabPanel(
        "Inventory Analytics", value = "tab1",
        fluidRow(
          box(width = 12, height = 160, align = "center", collapsible = TRUE,
              valueBoxOutput("revenueKpi", width = 2),
              column(imageOutput("plusSign"), width = 1, height= 90, align = "center"),
              valueBoxOutput("customersKpi", width = 2),
              column(imageOutput("minusSign"), width = 1, height= 90, align = "center"),
              valueBoxOutput("numProductsKpi", width = 2),
              column(imageOutput("equalSign"), width = 1, height= 90, align = "center"),
              valueBoxOutput("numUsersKpi", width = 2)
          )
        ),
        fluidRow(
          box(width = 12, height = 240, align = "center", collapsible = TRUE,
              plotlyOutput("time", height = 200)
          )
        )),
      tabPanel("Raw Data", value = "tab3", DT::DTOutput("rawDataOverview"))
    )
  )
)

