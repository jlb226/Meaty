
function(input, output, session) {
  ### Input Data ###
  inputType <- reactive({
    input$inputType
  })

  getExampleData <- reactive({
    ecomData()
  })

  getDataUser <- reactive({
    req(input$file1)
    ecomData <- read.csv(input$file1$datapath,
                         header = input$header,
                         sep = input$sep)
    ecomData
  })

  getRawData <- reactive({
    if (inputType() == "Example Dataset"){
      getExampleData()
    }
    else{
      getDataUser()
    }
  })

  getData <- reactive({
    prepData(getRawData())
  })

  output$blank <- renderImage({
    list(src = "www/blank.png",
         contentType = 'image/png',
         width = 30,
         height = 90,
         alt = "")
  },
  deleteFile=FALSE)

  output$plusSign <- renderImage({
    list(src = "www/plus_sign.png",
         contentType = 'image/png',
         width = 30,
         height = 90,
         alt = "Plus")
  },
  deleteFile=FALSE)

  output$minusSign <- renderImage({
    list(src = "www/minus_sign.png",
         contentType = 'image/png',
         width = 30,
         height = 90,
         alt = "Minus")
  },
  deleteFile=FALSE)

  output$equalSign <- renderImage({
    list(src = "www/equal_sign.png",
         contentType = 'image/png',
         width = 30,
         height = 90,
         alt = "Equals")
  },
  deleteFile=FALSE)


  ### Shop Level Analytics ###
  getRevenueKpi <- reactive({
    calcRevenueShop(getData())
  })

  output$revenueKpi <- renderPrint({
    revenue <- getRevenueKpi()
    valueBox(21, "Current", icon = icon("suitcase"),
            color = "black", width = 12)
    # infoBox(title = "Current", revenue, icon = icon("calendar"),
    #         color = "black", width = 12)
  })

  getCustomersKpi <- reactive({
    calcCustomersShop(getData())
  })

  output$customersKpi <- renderPrint({
    customers <- getCustomersKpi()
    valueBox(2, "New", icon = icon("archive"),
             color = "black", width = 12)
    # infoBox("New", customers, icon = icon("box"),
    #         color = "black", width = 12)
  })

  getNumProductsKpi <- reactive({
    calcNumProdsShop(getData())
  })

  output$numProductsKpi <- renderPrint({
    numProducts <- getNumProductsKpi()
    valueBox(4, "Closed", icon = icon("cube"),
             color = "black", width = 12)
    # infoBox("Closed", numProducts, icon = icon("cube"),
    #         color = "black", width = 12)
  })

  getNumUsersKpi <- reactive({
    calcNumUsers(getData())
  })

  output$numUsersKpi <- renderPrint({
    numUsers <- getNumUsersKpi()
    valueBox(19, "Ending", icon = icon("box"),
             color = "black", width = 12)
    # infoBox("Total", numUsers, icon = icon("box"),
    #         color = "black", width = 12)
  })


  getTopProducts <- reactive({
    calcTopProductsShop(getData(), numProducts = input$numProducts,
                        dateSpan = input$productsSpanVar)
  })

  output$topProducts <- renderTable({
    getTopProducts()
  })

  getLowProducts <- reactive({
    calcLowProductsShop(getData(), numProducts = input$numProducts,
                        dateSpan = input$productsSpanVar)
  })

  output$lowProducts <- renderTable({
    getLowProducts()
  })

  output$trend <- renderPlot({
    trendDist(getData(), dateSpan = input$trendSpanVar,
              trendVar = input$trendVar)
  })

  output$time <- renderPlotly({
    ecomDataSet <- read.csv("extdata/ecomData.csv", header = TRUE, sep = ",")
    fig <- plot_ly(ecomDataSet, x = seq(1:20), y = ~Quantity[1:20], type="bar",
            marker = list(color = '#b3d0ec'))
    fig <- fig %>% layout(#title = 'Quantity vs. Time',
                          xaxis = list(title = "Time"),
                          yaxis = list(title = "Quantity", range = c(0, 50)))
      })

  ### Individual Level Analysis ###
  outVar <- reactive({
    ecomData <- getData()
    sort(unique(as.character(ecomData$CustomerID)))
  })

  observe({
    updateSelectInput(session, "customerId", choices = outVar())
  })

  getRevenueKpiI <- reactive({
    calcRevenueI(getData(), customerID = input$customerId)
  })

  output$revenueKpiI <- renderPrint({
    revenue <- getRevenueKpiI()
    infoBox(title = "Current", revenue, icon = icon("calendar"),
            color = "black", width = 12)
  })

  getQuantileKpiI <- reactive({
    calcQuantileI(getData(), customerID = input$customerId)
  })

  output$quantileKpiI <- renderPrint({
    quantile <- getQuantileKpiI()
    infoBox("New", paste0("Top ", quantile, "%"),
            icon = icon("tachometer"), color = "black", width = 12)
  })

  getNumProductsKpiI <- reactive({
    calcNumProdsI(getData(), customerID = input$customerId)
  })

  output$numProductsKpiI <- renderPrint({
    numProducts <- getNumProductsKpiI()
    infoBox("Closed", numProducts, icon = icon("cube"),
            color = "black", width = 12)
  })

  getNumUsersKpiI <- reactive({
    calcNumUsers(getData(), customerID = input$customerId)
  })

  output$numUsersKpiI <- renderPrint({
    users <- getNumUsersKpiI()
    infoBox("Total", paste0("Top ", quantile, "%"),
            icon = icon("tachometer"), color = "black", width = 12)
  })

  getTopProductsI <- reactive({
    calcTopProductsI(getData(), customerID = input$customerId,
                     numProducts = input$numProductsI,
                     dateSpan = input$productsSpanVarI)
  })

  output$topProductsI <- renderTable({
    getTopProductsI()
  })

  getLowProductsI <- reactive({
    calcLowProductsI(getData(), customerID = input$customerId,
                     numProducts = input$numProducts,
                     dateSpan = input$productsSpanVarI)
  })

  output$lowProductsI <- renderTable({
    getLowProductsI()
  })

  output$trendI <- renderPlot({
    trendDistI(getData(), customerID = input$customerId,
               dateSpan = input$trendSpanVarI,
               trendVarI = input$trendVarI)
  })

  output$timeI <- renderPlot({
    timeDistI(getData(), customerID = input$customerId,
              timeVarI = input$timeVarI)
  })

  ### Raw Data ###
  output$rawDataOverview <- DT::renderDT({
    DT::datatable(getData(),
                  options = list(scrollX = TRUE))
  })

  ### Observing Actions ###
  observeEvent(getData(), {
    updateTabsetPanel(session, "User", selected = "tab1")
  })

}
