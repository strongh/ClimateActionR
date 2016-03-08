library(shiny)

# Define server logic required to draw a histogram
#flow_data <- read.csv("~/code/ClimateActionR/CMIP5_streamflow.csv") 

## coords of southernmost station. not sure this is 
## the right one
south_station_coords <- c("-114.470", "32.880")

## need to figure out how to coordinate these summary calcs
## station_flows <- flow_data %>%
##  filter(lat < 33, Scenario=="rcp26", GCM=="bcc.csm1.1")
## station_flows <- read.csv("~/code/ClimateActionR/flow_data.csv")
## station_yearly_flows <- ddply(station_flows, .(Year), summarise, streamflow=sum(streamflow))
station_yearly_flows <- read.csv("~/code/ClimateActionR/yearly_flow.csv")
station.coords <- read.csv("~/code/ClimateActionR/station_coords.csv") # unique(flow_data[, c("long", "lat")])
theme_set(theme_minimal())
#states <- geom_shape("admin_boundaries", "state_boundaries")
US.use <- 3e5 # i just made this up
mexico.use <- 1e5
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