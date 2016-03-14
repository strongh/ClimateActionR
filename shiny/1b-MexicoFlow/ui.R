library(shiny)

shinyUI(fluidPage(
  # Application title
  titlePanel("Mexico Stream Flow"),
  
  sidebarLayout(
    sidebarPanel(
       "This first app shows a simple map of
       the station locations where flow is measured, 
       and a timeseries of the flow for the southernmost
       station."
    ),
    
    mainPanel(
      tabsetPanel(
       tabPanel("Flow",
                plotOutput("flowTimeSeriesPlot")),
       tabPanel("Map",
                dateInput("year", "Year", format="yyyy"),
                plotOutput("stationMap", height="7in"))
      )
    )
  )
))