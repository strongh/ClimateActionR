library(shiny)
library(ggplot2)
library(magrittr)
library(dplyr)
library(ClimateAction)

station_yearly_flows <- read.csv("~/catdata/station_yearly_flows.csv")
station.coords <- read.csv("~/catdata/station_coords.csv") # unique(flow_data[, c("long", "lat")])
theme_set(theme_minimal())
state_shapes <- read.csv("~/catdata/state_shapes.csv")
states <- geom_path(data=state_shapes,
                    aes(group=group))

# 200000000 * 3.2804^3 = 7,060,092,731: size of imperial reservoir in cf.
## source: https://en.wikipedia.org/wiki/Colorado_River_Compact
US.use <- 293 * 3.2804^3
mexico.use <- US.use / 5
min.percent.target <- 0.2

shinyServer(function(input, output) {
  mexicoWaterReactive <- reactive({
    store.rate <- input$damStorageRate
    damSize <- input$damSize
    pad <- input$share
  

    inflow <- station_yearly_flows %>% 
      filter(Scenario==input$scenario) %>%
      mutate(streamflow=pmax(0, streamflow/2-US.use)) %>%
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
        if (damLevel[year] > min.percent.target*damSize & outflow[year] < mexico.use) {
          padding <- min(damLevel[year] - min.percent.target*damSize,
                         mexico.use - outflow[year])
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