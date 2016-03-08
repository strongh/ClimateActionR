## get data, just needs to be run once

#library(rdrop2)
#write.csv(rdrop2::drop_read_csv("/ClimateActionRData/CMIP5_streamflow.csv"),
#          file="CMIP5_streamflow.csv")

library(shiny)
## Assumes that 

shinyUI(fluidPage(
  # Application title
  titlePanel("Mexico Stream Flow"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
       "This first app shows a simple map of
       the station locations where flow is measured, 
       and a timeseries of the flow for the southernmost
       station."
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      tabsetPanel(
       tabPanel("Flow",
                plotOutput("flowTimeSeriesPlot")),
       tabPanel("Map",
                plotOutput("stationMap", height="7in"))
      )
    )
  )
))