library(rdrop2)
library(dplyr)
library(magrittr)
library(ClimateAction)


## read the data that we already downloaded.
flow_data <- read.csv("~/catdata/hydrology/CMIP5_streamflow.csv") 

## Compute the smaller CSVs that we need for Shiny.
## + filter to a single GCM (as a simplifying assumption)
## + filter to a single location (Imperial)
## + summarize monthly flow data into annual flow
## + add a new "scenario" which is the average of all scenarios.
## + extract the coordinates of all locations

## want flow per station per year
sy <- flow_data %>% group_by(Station, Year) %>% 
  summarise(mean_flow=mean(streamflow), lat=first(lat), lon=first(long)) %>% 
  rename(long=lon)
write.csv(sy, "~/catdata/flow_per_station.csv")

## first we do the two filtering steps
station_flows <- flow_data %>%
  filter(Station == "IMPRL", GCM=="bcc.csm1.1")

## write out this product to CSV
write.csv(station_flows, "~/catdata/flow_data.csv", row.names = FALSE)

## summarise monthly counts into yearly
station_yearly_flows <- station_flows %>%
  group_by(Year, Scenario) %>%
  summarise(streamflow=mean(streamflow))

## calculate flows under the "mean" scenario
mean_flow <- station_yearly_flows %>%
  group_by(Year) %>%
  summarise(Scenario="mean", streamflow=mean(streamflow))
  
## combind the "mean" scenario with the rest of the dataset
station_yearly_flows <- rbind(station_yearly_flows, mean_flow)

## write to CSV
write.csv(station_yearly_flows,
          "~/catdata/station_yearly_flows.csv", row.names = FALSE)

## finally, get coordinates of gauges for the map.
station_coordinates <- flow_data %>% 
  group_by(Station) %>%
  dplyr::select(lat, long) %>%
  distinct(Station)

## write coordinates to CSV
write.csv(station_coordinates,
          "~/catdata/station_coords.csv", row.names = FALSE)

## write shapes as CSV
state_shapes <- shape.df("admin_boundaries", "state_boundaries")
write.csv(state_shapes, "~/catdata/state_shapes.csv", row.names = FALSE)