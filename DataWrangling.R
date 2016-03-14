#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## Climate Action Training Workshop
## Part I: Overview of data wrangling
## Presenter: Will Petry
## Goals:
## - introduce R by example
## - highlight capabilities that are relevant to this workshop
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## Preliminaries ----
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## Install packages (run this once)
install.packages(c("rgdal",    # spatial data tools for vector data
                   "raster",   # spatial data tools for gridded data
                   "shiny",    # interactive web apps
                   "ggplot2",  # plotting
                   "tidyr",    # tidy data
                   "dplyr"))   # data wrangling

## Load packages
library(rgdal)
library(raster)
library(shiny)
library(ggplot2)
library(tidyr)
library(dplyr)

## Set up a folder to hold all the data we'll use
dir.create("~/catdata")
setwd("~/catdata")   # tells R to look in this folder for data
                     # unless told to look elsewhere

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## Data download ----
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## Download climate change projections for Colorado River stream flow (hydrology)
# https://github.com/strongh/ClimateActionR/blob/master/README.md

download.file("https://www.dropbox.com/s/oirr54cvt4jo0s5/hydrology.zip?dl=0",
              destfile = "hydrology.zip")  # this file will now be in ~/catdata
download.file("https://www.dropbox.com/s/wkajdtrv6xr0e8c/agriculture.zip?dl=0",
              destfile = "agriculture.zip")
download.file("https://www.dropbox.com/s/nodgg6ckh2ppvja/utility.zip?dl=0",
              destfile = "utility.zip")

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## 1. File handling, data I/O, and data exploration ----
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## 1.1 Exploring available files
# (a) RStudio file pane
# (b) using the command line
list.files()  # look in the working directory
list.files("~/Desktop/")  # look in a different directory

## 1.2 Unzipping files (.zip)
?unzip  # open help file

unzip("hydrology.zip", list = TRUE)  # get a list of files within the .zip archive

unzip("hydrology.zip")  # extract the full archive
unzip("utility.zip")  # extract the full archive
unzip("agriculture.zip", files = "agriculture/CA_crops_2014.tif") # extract a single file

## 1.3 Importing files: comma-separated values (.csv)
proj_flow <- read.csv("CMIP5_streamflow.csv")  # returns error
proj_flow <- read.csv("~/catdata/hydrology/CMIP5_streamflow.csv")  # fix to look
                                                                   # in subfolder
View(proj_flow) # show in RStudio data viewer (works for data frames)
head(proj_flow) # show the first few rows of data
str(proj_flow)  # show structure of object (works for any object type)

## 1.4 Importing files: vector spatial data (.shp)
# read in shapefile [sub-folder, filename]
states <- readOGR("utility", "state_boundaries")
basinbdy <- readOGR("utility", "CRBasin_full")

plot(states)  # quick visualization of shapefile contents

states  # dataset properties

View(states@data)  # show associated data frame in RStudio viewer

## 1.5 Importing files: gridded spatial data ("rasters")
# read in raster dataset
cal_agri <- raster("~/catdata/agriculture/CA_crops_2014.tif")

plot(cal_agri)  # quick visualization

cal_agri  # dataset properties

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## Data wrangling with tidyr and dplyr
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
str(proj_flow)  # remember the projected streamflow dataset

## What is the projected annual flow at each site for the year 2050 under a worst-case
## emissions scenario (rcp+8.5) averaged across all GCMs? [pipes, filter, summarize]
stream_summary2050rcp85 <- proj_flow %>%                    # start with original data
  filter(Year==2050 & Scenario=="rcp85") %>%                # filter to focal data
  group_by(Station, GCM) %>%                                # calculate annual flow
  summarize(AnnualStreamFlow = sum(streamflow)) %>%
  group_by(Station) %>%                                     # calculate mean and CV across
  summarize(AnnualStreamFlow_mean = mean(AnnualStreamFlow), #    all GCMs
            AnnualStreamFlow_cv = sd(AnnualStreamFlow)/AnnualStreamFlow_mean)

stream_summary2050rcp85

## How well do GCM projections match observed annual streamflow? [joins]
obs_flow <- read.csv("~/catdata/hydrology/historic_streamflow.csv")  # read in historic
                                                                     # flow data
proj_flow_annual <- proj_flow %>%       # filter projected flow data like before,
  filter(Scenario=="rcp85") %>%         # but keep all years
  group_by(Station, GCM, Year) %>%
  summarize(AnnualStreamFlow = sum(streamflow)) %>%
  group_by(Station, Year) %>%
  summarize(AnnualStreamFlow_proj = mean(AnnualStreamFlow)) %>%
  ungroup() %>%
  mutate(Station = as.character(Station))

obs_flow_annual <- obs_flow %>%
  group_by(Station, Year) %>%
  summarize(AnnualStreamFlow_obs = sum(Flow.acreft)) %>%
  ungroup() %>%
  mutate(Station = as.character(Station))

recon_flow_annual <- proj_flow_annual %>%
  inner_join(., obs_flow_annual) %>%  # use an "inner join" to select only rows
                                           # where both datasets have data
  mutate(PercDiff = 100 * (AnnualStreamFlow_obs - AnnualStreamFlow_proj)/AnnualStreamFlow_obs)

View(recon_flow_annual)  # Do they match?  Meta-data?

# convert ft^3/sec to acrefeet (2592000 seconds/month, 1 ft^3 = 2.29569e-5 acrefeet)
recon_flow_annual <- proj_flow_annual %>%  # same as before, but convert units
  mutate(AnnualStreamFlow_proj = AnnualStreamFlow_proj * 2592000 * 2.29569e-5) %>%
  inner_join(., obs_flow_annual) %>%
  mutate(PercDiff = 100 * (AnnualStreamFlow_obs - AnnualStreamFlow_proj)/AnnualStreamFlow_obs)

View(recon_flow_annual)

# tidy the data for plotting --> we have two columns with flow data
plot_recon_flow <- recon_flow_annual %>%
  gather("DataSource", "AnnualStreamFlow", AnnualStreamFlow_proj:AnnualStreamFlow_obs) %>%
  mutate(DataSource = ifelse(DataSource=="AnnualStreamFlow_proj", "Projected", "Observed"))

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## Making plots with ggplot2 ----
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## Make a histogram of observed monthly stream flow
flow_histo <- ggplot(obs_flow, aes(x = Flow.acreft)) +
  geom_histogram() +
  theme_minimal()
flow_histo

## Make a timeseries of observed vs. projected stream flow at Imperial Dam
recon_timeseries <- ggplot(plot_recon_flow %>% filter(Station=="IMPRL"),
                           aes(x = Year, y = AnnualStreamFlow, color = DataSource)) +
  geom_line(size = 2) +
  theme_minimal()
recon_timeseries















