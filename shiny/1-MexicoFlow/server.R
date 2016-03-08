#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
#flow_data <- read.csv("~/code/ClimateActionR/CMIP5_streamflow.csv") 

## coords of southernmost station. not sure this is 
## the right one
south_station_coords <- c("-114.470", "32.880")

## need to figure out how to coordinate these summary calcs
 station_flows <- flow_data %>%
  filter(lat < 33, Scenario=="rcp26", GCM=="bcc.csm1.1")
## station_flows <- read.csv("~/code/ClimateActionR/flow_data.csv")
## station_yearly_flows <- ddply(station_flows, .(Year), summarise, streamflow=sum(streamflow))
station_yearly_flows <- read.csv("~/code/ClimateActionR/yearly_flow.csv")
station.coords <- read.csv("~/code/ClimateActionR/station_coords.csv") # unique(flow_data[, c("long", "lat")])
theme_set(theme_minimal())
#states <- geom_shape("admin_boundaries", "state_boundaries")
shinyServer(function(input, output) {
  
  output$stationMap <- renderPlot({
    ggplot(station.coords, aes(long, lat)) + 
      geom_point(size=3, colour="red") + states
  })
  
  output$flowTimeSeriesPlot <- renderPlot({
    ggplot(station_yearly_flows, aes(Year, streamflow)) + 
      geom_line()
  })
})