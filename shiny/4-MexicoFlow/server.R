library(shiny)
library(ggplot2)
library(magrittr)
library(dplyr)

## TODO:
## + make sure apps run from scratch (states polygon)
## + point out how to explain w/ prose
## + plug in actual numbers?
## + do something fancier with map
## + add units

## + version 5: long-term vs short term
## + improve graph labels
## + "pad" should be more emphasized / radio buttons

## DONE:
## + break out data preparation script(s)
## + clarify when dam should start
## + bug in years reported?
station_yearly_flows <- read.csv("~/catdata/yearly_flow_scenario.csv")
station.coords <- read.csv("~/catdata/ClimateActionR/station_coords.csv") # unique(flow_data[, c("long", "lat")])
theme_set(theme_minimal())
#states <- geom_shape("admin_boundaries", "state_boundaries")

## should use source: https://en.wikipedia.org/wiki/Colorado_River_Compact
US.use <- 293 * 3.2804^3 # 3e5 # i just made this up
mexico.use <- US.use /5 # 2e5 # and this too


shinyServer(function(input, output) {
  mexicoWaterReactive <- reactive({
    store.rate <- input$damStorageRate
    damSize <- input$damSize
    pad <- input$generous
    inflow <- station_yearly_flows %>% 
      filter(Scenario==input$scenario) %>%
      mutate(streamflow=streamflow*0.1) %>%
      dplyr::select(streamflow) %>% .[[1]]

    N <- length(inflow)
    ## calculate outflow at each time point
    outflow <- c(0)
    ## Note: we need to keep track of dam level, even though we don't present it
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
    N <- nrow(station_yearly_flows %>% filter(Scenario==input$scenario))
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