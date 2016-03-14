library(shiny)
library(ggplot2)
library(magrittr)
library(dplyr)

station_yearly_flows <-
  read.csv("~/catdata/station_yearly_flows.csv") %>% 
  filter(Scenario=="rcp26")
station.coords <- read.csv("~/catdata/station_coords.csv") # unique(flow_data[, c("long", "lat")])
theme_set(theme_minimal())
state_shapes <- read.csv("~/catdata/state_shapes.csv")
states <- geom_path(data=state_shapes,
                    aes(group=group))

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