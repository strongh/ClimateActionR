#################################################-
## DOMAIN: UTILITY
## Retrieve administrative boundaries from US Census Bureau
## Author: W. Petry
#################################################-
## Preliminaries
library(rdrop2)
library(dplyr)
library(rgdal)

#################################################-
## States (& equivalents)
## https://www.census.gov/geo/maps-data/data/tiger-line.html
#################################################-
download.file("ftp://ftp2.census.gov/geo/tiger/TIGER2015/STATE/tl_2015_us_state.zip",
              destfile="tl_2015_us_state.zip",mode="wb")
unzip("tl_2015_us_state.zip")

states<-readOGR(".","tl_2015_us_state")
# subset to focal states
states<-states[states@data$NAME %in% c("California","Nevada","Arizona","New Mexico",
                                       "Utah","Colorado","Wyoming"),]
# spatial transform and export
states<-spTransform(states,CRS("+proj=longlat +ellps=WGS84 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"))
writeOGR(states,".","state_boundaries",driver="ESRI Shapefile")

# send to Dropbox
for(i in list.files(pattern="state_boundaries")){
  drop_upload(i,dest="ClimateActionRData/admin_boundaries")
}

# clean up
unlink(list.files(pattern="state_boundaries"))
unlink(list.files(pattern="tl_2015_us_state"))

#################################################-
## Counties (& equivalents)
## https://www.census.gov/geo/maps-data/data/tiger-line.html
#################################################-
download.file("ftp://ftp2.census.gov/geo/tiger/TIGER2015/COUNTY/tl_2015_us_county.zip",
              destfile="tl_2015_us_county.zip",mode="wb")
unzip("tl_2015_us_county.zip")

counties<-readOGR(".","tl_2015_us_county")
# subset to focal states
counties<-counties[counties@data$STATEFP %in% c("04","06","08","32","35","49","56"),]
# spatial transform and export
counties<-spTransform(counties,CRS("+proj=longlat +ellps=WGS84 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"))
writeOGR(counties,".","county_boundaries",driver="ESRI Shapefile")

# send to Dropbox
for(i in list.files(pattern="county_boundaries")){
  drop_upload(i,dest="ClimateActionRData/admin_boundaries")
}

# clean up
unlink(list.files(pattern="county_boundaries"))
unlink(list.files(pattern="tl_2015_us_county"))


