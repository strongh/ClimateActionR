#################################################-
## DOMAIN: CLIMATE
## Retrieve Palmer drought index data
## Author: W. Petry
## http://www.ncdc.noaa.gov/temp-and-precip/drought/historical-palmers/
## http://www1.ncdc.noaa.gov/pub/data/cirs/climdiv/
#################################################-
## Preliminaries
library(rdrop2)
library(dplyr)
library(tidyr)
library(rgdal)
library(magrittr)

#################################################-
## Download data
#################################################-
# Shapefile of monitoring areas, subset to focal area
download.file("http://www1.ncdc.noaa.gov/pub/data/cirs/climdiv/CONUS_CLIMATE_DIVISIONS.shp.zip",destfile="pdi_divs.zip")
unzip("pdi_divs.zip")
pdi.shp<-readOGR(".","GIS.OFFICIAL_CLIM_DIVISIONS")
pdi.shp<-spTransform(pdi.shp,CRS("+proj=longlat +ellps=WGS84 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"))

pdi.shp.sub<-pdi.shp[pdi.shp$STATE %in% c("California","Nevada","Arizona","Utah","Colorado",
                                          "New Mexico","Wyoming"),]
pdi.shp.sub@data<-droplevels(pdi.shp.sub@data)


# Timeseries data, subset to focal area
pdi.ts<-read.table("http://www1.ncdc.noaa.gov/pub/data/cirs/climdiv/climdiv-pdsidv-v1.0.0-20160304",header=F,colClasses=c("character",rep("numeric",12))) %>%
  rename(CLIMDIV=V1,m01=V2,m02=V3,m03=V4,m04=V5,m05=V6,m06=V7,m07=V8,m08=V9,m09=V10,m10=V11,
         m11=V12,m12=V13) %>%
  mutate(year=substr(CLIMDIV,nchar(CLIMDIV)-3,nchar(CLIMDIV)),
         CLIMDIV=substr(CLIMDIV,1,nchar(CLIMDIV)-6)) %>%
  filter(CLIMDIV %in% as.character(pdi.shp.sub@data$FIPS_CD)) %>%
  gather("month","PalmerDroughtIndex",starts_with("m")) %>%
  mutate(month=as.numeric(substr(month,2,3)))

#################################################-
## Upload files and clean up
#################################################-
writeOGR(pdi.shp.sub,".","palmerDI_regions",driver="ESRI Shapefile")
write.csv(pdi.ts,"palmerDI_timeseries.csv")

for(i in list.files(pattern="palmer")){
  drop_upload(i,dest="ClimateActionRData/climate")
}

unlink(list.files(pattern="palmer"))
unlink(list.files(pattern="GIS.OFFICIAL"))
unlink(list.files(pattern="pdi.divs"))
