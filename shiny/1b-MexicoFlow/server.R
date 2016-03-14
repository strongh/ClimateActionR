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

station_flows <- read.csv("~/catdata/flow_per_station.csv")

shinyServer(function(input, output) {
  
  output$stationMap <- renderPlot({
    print(input$year)
    print(str(input$year))
    year <- as.numeric( format( input$year, '%Y')) 
  
    sub_station <- station_flows %>% filter(Year==year)
    rownames(sub_station) <- sub_station$Station
    station.coords <- station.coords[c(1:4, 9, 5:8),]
    
    mean_station <- station_flows %>%
       group_by(Station) %>% 
       summarise(total_mean=mean(mean_flow, na.rm=TRUE))
    
    rownames(sub_station) <- sub_station$Station
   sub_station <- merge(mean_station, sub_station)
   sub_station$deviation <- sub_station$mean_flow - sub_station$total_mean
    
   sub_station <- sub_station[station.coords$Station, ]

   ggplot(station.coords, aes(long, lat)) + 
      geom_point(size=3, colour="red") +
      geom_path(aes(size=mean_flow, colour=deviation),
                data=sub_station) + 
      states
  })
  
  output$flowTimeSeriesPlot <- renderPlot({
    ggplot(station_yearly_flows, aes(Year, streamflow)) + 
      geom_line()
  })
})