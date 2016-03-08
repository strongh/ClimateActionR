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
       p("This first app shows a simple map of
       the station locations where flow is measured, 
       and a timeseries of the flow for the southernmost
       station."),
       p("The second version adds indicators for the
       amount of water removed each year by the US, and
       also how much is left for Mexico. This is reflected
       both in plots and in text."),
       p("In the third iteration we add a dam, just downstream
       of the gauge, whose behavior is
       controlled by 2 inputs. The inputs are the maximum capacity
       and the percent of inflow kept. How do these
       parameters affect Mexico's water?"),
       sliderInput("damStorageRate",
                   "Dam storage rate",
                   min=0, max=1, value=0.5),
       sliderInput("damSize",
                   "Dam size",
                   min=0, max=1e7, value=1e2),
       checkboxInput("generous",
                     "Pad outflow?", value=FALSE)
    ),
    
    # Show a plot of the generated distribution
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