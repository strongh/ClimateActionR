#################################################-
## DOMAIN: DEMOGRAPHY
## Retrieve population projections
## URL: http://www.dof.ca.gov/research/demographic/reports/projections/P-3/
## Author: H. Strong
#################################################-
## Preliminaries
library(dplyr)
library(magrittr)
library(rdrop2)
library(readxl)

file.name <- "P-3_Total_DetailedAge_CAProj_2010-2060.xls"
output.file.name <- "ca_population_projections.csv"
## note: this will fail if file exists already. not sure how to
## tolerate this w/o re-downloading.
drop_get(paste0("ClimateActionRData/", file.name))

## get rid of junk
ex.data <- read_excel(file.name, 2)
names(ex.data) <- ex.data[2,]
ex.data <- ex.data[3:nrow(ex.data),]

## pull out only the total "race" - there are breakdowns by race available.
## also select only the total column. finer breakdowns by age are available.
ex.data <- ex.data %>% filter(Race=="T") %>% 
  select(-starts_with("T-")) %>% 
  select(-Race)

## I'm not sure how to do these with dplyr ops due to " " and "/" in the var names
names(ex.data) <- c("state", "county.code", "year", "total.projected.population")
write.csv(ex.data, output.file.name)
## upload to Dropbox
drop_upload(output.file.name, dest = "ClimateActionRData")
