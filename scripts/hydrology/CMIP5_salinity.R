#################################################-
## DOMAIN: HYDROLOGY
## Retrieve and clean salinity data
## Author: W. Petry
## https://bor.colorado.edu/public_web/DataTransfer/4Will/

## UNFINISHED

#################################################-
## Preliminaries
library(rdrop2)
library(dplyr)

#################################################-
## Rename files to R-readable format
#################################################-
## Set file directory
dir<-"~/Desktop/TEST/"

## Delete flow-only files
unlink(paste0(dir,list.files(dir,pattern="Inflow$")))

## Rename remaining salinity files to .txt
file.rename(list.files(dir),gsub("\\.Inflow_Salt_Concentration","\\.txt",x=list.files(dir)))


match.names<-data.frame(name=c("GlenwoodSpgsCO","CameoCO","CiscoUT","GlenCynDam","GrandCyn",
                               "HooverDam","ParkerDam","ImperialDam"),
                        lat.dd=c(39.55,39.148570,38.81056,36.937190,36.097584,36.016326,
                                 34.296608,32.883179),
                        long.dd=c(-107.3203,-108.315071,-109.2928,-111.483766,-112.095493,
                                  -114.737722,-114.139390,-114.465391),
                        prefix=c("UpperColoradoReach","UpperColoradoAboveCameo_GainsAboveCameo",
                                 "UpperColoradoCameoToGunnison_GainsAboveCisco",
                                 "SanJuanPowell_GainsAboveLeesFerry",
                                 "CoRivVirginToMead_GainsAboveHoover",
                                 "CoRivMeadToMohave_GainsAboveDavis",
                                 "CoRivMohaveToHavasu_GainsAboveParker",
                                 "AboveImperialDamColoradoR_GainsOnColoRAboveImperialDam"))




torename<-pmatch(match.names$prefix,list.files(dir))
torename

test<-read.table(".txt",skip=2)








