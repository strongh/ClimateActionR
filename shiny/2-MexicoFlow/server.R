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

US.use <- 1e4 # i made this up
mexico.use <- 2e4 # and this

shinyServer(function(input, output) {
  
  output$stationMap <- renderPlot({
    ggplot(station.coords, aes(long, lat)) + 
      geom_point(size=3, colour="red") + states
  })
  
  output$waterTreatySummary <- renderText({
    mexico.flow <- station_yearly_flows$streamflow - US.use
    N <- nrow(station_yearly_flows)
    prop.years.fail <- sum(mexico.flow < mexico.use)/N
    sprintf("In %.2f%% of years between 1950 and 2100, there is
            not enough water
            remaining for Mexio.", 
            prop.years.fail * 100)
  })

  output$flowTimeSeriesPlot <- renderPlot({
    ggplot(station_yearly_flows, aes(Year, streamflow)) + 
      geom_line()
  })
  
  output$mexicoFlowTimeSeriesPlot <- renderPlot({
    ggplot(station_yearly_flows, aes(Year, streamflow-US.use)) + 
      geom_line() + geom_hline(yintercept = mexico.use)
  })
})