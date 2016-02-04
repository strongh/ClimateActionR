#################################################-
## DOMAIN: UTILITY
## Retrieve shapefile boundaries of Colorado River Basin (full, upper, lower)
## Author: W. Petry
#################################################-
## Preliminaries
library(rdrop2)
library(rgdal)

#################################################-
## Full Colorado River Basin boundary
## URL: http://www.nohrsc.noaa.gov/gisdatasets/
#################################################-
download.file("http://www.nohrsc.noaa.gov/data/vector/master/b_cbrfc.tar.gz",destfile="b_cbrfc.tar.gz")
untar("b_cbrfc.tar.gz")
full.crb<-spTransform(readOGR(".",layer="b_cbrfc"),
                      CRS("+proj=longlat +ellps=WGS84 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"))
writeOGR(full.crb,".","CRB_boundary_full",driver="ESRI Shapefile")
for(i in list.files(pattern="CRB_boundary_full")){
  drop_upload(i,dest="ClimateActionRData/basin_boundary")
  unlink(i)
}
unlink(list.files(pattern="b_cbrfc")) # clean up
#################################################-
## Upper Colorado River Basin boundary
## URL: https://www.sciencebase.gov/catalog/item/4f4e4a38e4b07f02db61cebb
#################################################-
download.file("https://www.sciencebase.gov/catalog/file/get/4f4e4a38e4b07f02db61cebb?facet=Upper_Colorado_River_Basin_Boundary",destfile="upper_crb.zip")
unzip("upper_crb.zip")
upper.crb<-spTransform(readOGR(".","Upper_Colorado_River_Basin_Boundary"),
                       CRS("+proj=longlat +ellps=WGS84 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"))
writeOGR(full.crb,".","CRB_boundary_upper",driver="ESRI Shapefile")
for(i in list.files(pattern="CRB_boundary_upper")){
  drop_upload(i,dest="ClimateActionRData/basin_boundary")
  unlink(i)
}

#################################################-
## Lower Colorado River Basin boundary
## URL: https://nccwsc.usgs.gov/display-project/5050cb0ee4b0be20bb30eac0/50a64d73e4b0d446a665ca7c
#################################################-
# Lower Colorado River Basin
download.file("https://www.sciencebase.gov/catalog/file/get/50a64d73e4b0d446a665ca7c?facet=LCRstudyarea",
              destfile="lower_crb.zip")
unzip("lower_crb.zip")
lower.crb<-spTransform(readOGR(".","LCRstudyarea"),
                       CRS("+proj=longlat +ellps=WGS84 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"))
writeOGR(full.crb,".","CRB_boundary_lower",driver="ESRI Shapefile")
for(i in list.files(pattern="CRB_boundary_lower")){
  drop_upload(i,dest="ClimateActionRData/basin_boundary")
  unlink(i)
}
