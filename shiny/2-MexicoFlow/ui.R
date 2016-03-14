library(shiny)

shinyUI(fluidPage(
  # Application title
  titlePanel("Mexico Stream Flow"),
  
  sidebarLayout(
    sidebarPanel(
       p("This first app shows a simple map of
       the station locations where flow is measured, 
       and a timeseries of the flow for the southernmost
       station."),
       p("The second version adds indicators for the
       amount of water removed each year by the US, and
       also how much is left for Mexico. This is reflected
       both in plots and in text.")
    ),
    
    mainPanel(
      tabsetPanel(
       tabPanel("Mexico Flow",
                plotOutput("mexicoFlowTimeSeriesPlot"),
                textOutput("waterTreatySummary")),
       tabPanel("Total Flow",
                plotOutput("flowTimeSeriesPlot")),
       tabPanel("Map",
                plotOutput("stationMap", height="7in"))
      )
    )
  )
))