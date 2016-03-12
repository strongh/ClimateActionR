library(shiny)
library(ggplot2)
library(magrittr)
library(plyr)
library(dplyr)

## TODO:
## + make sure apps run from scratch
## + break out data preparation script(s)
## + point out how to explain w/ prose
## + improve graph labels
## + plug in actual numbers?
## + do something fancier with map
## + add units
## + clarify when dam should start
## + bug in years reported?
## + "pad" should be more emphasized / radio buttons
## + states polygon


# Define server logic required to draw a histogram
## flow_data <- read.csv("~/code/ClimateActionR/CMIP5_streamflow.csv") 

## coords of southernmost station. not sure this is 
## the right one
south_station_coords <- c("-114.470", "32.880")

## need to figure out how to coordinate these summary calcs
##station_flows <- flow_data %>%
##  filter(lat < 33, GCM=="bcc.csm1.1")
## station_flows <- read.csv("~/code/ClimateActionR/flow_data.csv")
#station_yearly_flows <- ddply(station_flows, .(Year, Scenario), summarise, streamflow=sum(streamflow))
#mean_flow <- ddply(station_yearly_flows, .(Year), summarise,
#                   Scenario="mean",
#                   streamflow=mean(streamflow))
#station_yearly_flows <- rbind(station_yearly_flows, mean_flow)
station_yearly_flows <- read.csv("~/code/ClimateActionR/yearly_flow_scenario.csv")
station.coords <- read.csv("~/code/ClimateActionR/station_coords.csv") # unique(flow_data[, c("long", "lat")])
theme_set(theme_minimal())
#states <- geom_shape("admin_boundaries", "state_boundaries")
US.use <- 3e5 # i just made this up
mexico.use <- 2e5 # and this too


shinyServer(function(input, output) {
  mexicoWaterReactive <- reactive({
    store.rate <- input$damStorageRate
    damSize <- input$damSize
    pad <- input$generous
    inflow <- station_yearly_flows %>% 
      filter(Scenario==input$scenario) %>%
      select(streamflow) %>% .[[1]]

    N <- length(inflow)
    ## calculate outflow at each time point
    outflow <- c(0)
    damLevel <- c(0) # start with no water. new dam.
    for (year in 2:N){
      last.year <- year - 1
      store <- store.rate * inflow[year]
      ## check whether there is enough remaining capacity
      if (damLevel[last.year] + store < damSize){
        damLevel[year] <- damLevel[last.year] + store
        outflow[year] <- inflow[year] - store
      } else { ## in this case, the dam is close to full
        damLevel[year] <- damSize
        outflow[year] <- damLevel[last.year] + inflow[year] - damSize
      }
      if (pad) {
        ## if we are at more than 20% of capacity
        ## and mexico needs more water, send some more water
        ## but always keep at least 20% for ourselves
        if (damLevel[year] > 0.2*damSize & outflow[year] < mexico.use) {
          padding <- min(damLevel[year] - 0.2*damSize, mexico.use - outflow[year])
          outflow[year] <- outflow[year] + padding
          damLevel[year] <- damLevel[year] - padding
        }
      }
    }
    outflow
  })
  
  output$stationMap <- renderPlot({
    ggplot(station.coords, aes(long, lat)) + 
      geom_point(size=3, colour="red") + states
  })
  
  output$waterTreatySummary <- renderText({
    mexico.flow <- mexicoWaterReactive()
    N <- nrow(station_yearly_flows)
    prop.years.fail <- sum(mexico.flow < mexico.use)/N
    sprintf("In %.2f%% of years between 1950 and 2100, there is
            not enough water
            remaining for Mexico.",
            prop.years.fail * 100)
  })
  
  output$flowTimeSeriesPlot <- renderPlot({
    scenario_subset <- station_yearly_flows %>%
      filter(Scenario==input$scenario)
    ggplot(station_yearly_flows,
           aes(Year, streamflow)) + 
           geom_line(data=scenario_subset, size=3, alpha=0.2) +
           geom_line(aes(colour=Scenario))
  })
  
  output$mexicoFlowTimeSeriesPlot <- renderPlot({
    station_yearly_flows$outflow <- mexicoWaterReactive()
    scenario <- input$scenario
    ggplot(station_yearly_flows %>% filter(Scenario==scenario), 
           aes(Year, outflow)) + 
      geom_line() + 
      geom_point(aes(colour=outflow>=mexico.use)) +
      geom_hline(yintercept = mexico.use)
  })
})