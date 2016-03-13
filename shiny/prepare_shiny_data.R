library(rdrop2)
library(dplyr)
library(magrittr)

## get raw data from Dropbox (this is a little slow because it's a large-ish CSV).
write.csv(rdrop2::drop_read_csv("/ClimateActionRData/CMIP5_streamflow.csv"),
          file="CMIP5_streamflow.csv")

## read the data that we just downloaded.
flow_data <- read.csv("~/catdata/ClimateActionR/CMIP5_streamflow.csv") 

## Compute the smaller CSVs that we need for Shiny.
## + filter to a single GCM (as a simplifying assumption)
## + filter to a single location (Imperial)
## + summarize monthly flow data into annual flow
## + add a new "scenario" which is the average of all scenarios.
## + extract the coordinates of all locations


## first we do the two filtering steps
station_flows <- flow_data %>%
  filter(Station == "IMPRL", GCM=="bcc.csm1.1")

## write out this product to CSV
write.csv(station_flows, "~/catdata/flow_data.csv", row.names = FALSE)

## summarise monthly counts into yearly
station_yearly_flows <- station_flows %>%
  group_by(Year, Scenario) %>%
  summarise(streamflow=sum(streamflow))

## calculate flows under the "mean" scenario
mean_flow <- station_yearly_flows %>%
  group_by(Year) %>%
  summarise(Scenario="mean", streamflow=mean(streamflow))
  
## combind the "mean" scenario with the rest of the dataset
station_yearly_flows <- rbind(station_yearly_flows, mean_flow)

## write to CSV
write.csv(station_yearly_flows,
          "~/catdata/yearly_flow_scenario.csv", row.names = FALSE)

## finally, get coordinates of gauges for the map.
station_coordinates <- flow_data %>% 
  group_by(Station) %>%
  dplyr::select(lat, long) %>%
  distinct(Station)

## write coordinates to CSV
write.csv(station_coordinates,
          "~/catdata/station_coords.csv", row.names = FALSE)
