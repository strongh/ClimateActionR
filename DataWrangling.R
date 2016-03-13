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
install.packages(c("tidyr",    # tidy data
                   "dplyr",    # data wrangling
                   "rgdal",    # spatial data tools for vector data
                   "raster",   # spatial data tools for gridded data
                   "shiny",    # interactive web apps
                   "ggplot2")) # plotting

## Load packages
library(tidyr)
library(dplyr)
library(rgdal)
library(raster)
library(shiny)
library(ggplot2)

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
flow_data <- read.csv("CMIP5_streamflow.csv")  # returns error
flow_data <- read.csv("~/catdata/hydrology/CMIP5_streamflow.csv")  # fix to look
                                                                   # in subfolder
View(flow_data) # show in RStudio data viewer (works for data frames)
head(flow_data) # show the first few rows of data
str(flow_data)  # show structure of object (works for any object type)

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
















