#################################################-
## DOMAIN: HYDROLOGY
## Retrieve Colorado River Shapefile
## Author: W. Petry
## http://www.nohrsc.noaa.gov/gisdatasets/
#################################################-
## Preliminaries
library(rdrop2)
library(rgdal)

#################################################-
## Download file + import
#################################################-
download.file("http://www.nohrsc.noaa.gov/data/vector/master/rivs_cbrfc.tar.gz",
              destfile="rivs_cbrfc.tar.gz")
untar("rivs_cbrfc.tar.gz")

CRB_rivers<-readOGR(".","rivs_cbrfc")
plot(CRB_rivers)

#################################################-
## Reproject
#################################################-
CRB_rivers<-spTransform(CRB_rivers,CRS("+proj=longlat +ellps=WGS84 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"))

#################################################-
## Export, upload, clean up
#################################################-
writeOGR(CRB_rivers,".","CRB_rivers",driver="ESRI Shapefile")

for(i in list.files(pattern="CRB_rivers")){
  drop_upload(i,dest="ClimateActionRData")
}

unlink(list.files(pattern="rivs_cbrfc"))
unlink(list.files(pattern="CRB_rivers"))
