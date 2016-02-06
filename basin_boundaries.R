#################################################-
## DOMAIN: UTILITY
## Retrieve shapefile boundaries of Colorado River Basin (full, upper, lower)
## Author: W. Petry
#################################################-
## Preliminaries
library(rdrop2)
library(rgdal)

#################################################-
## Download data
## URL: https://www.sciencebase.gov/catalog/item/4fb697b2e4b03ad19d64b47f
#################################################-
urls<-paste0("https://www.sciencebase.gov/catalog/file/get/4fb697b2e4b03ad19d64b47f?f=__disk__",
             c("a1%2F7f%2Ff9%2Fa17ff9ca94983a23d99088eeb023ab5fdbe1e9a4",
               "f2%2F38%2F14%2Ff23814dc1ab9e1383a01ae01666d8273a14b62b3",
               "0a%2F4a%2F79%2F0a4a798c7053ed3af62dabc3ca1fc44a2e953a95",
               "60%2F07%2F0f%2F60070f7bab7e2f419e578e6f39d6a214a1ed4d9d",
               "0d%2Ffc%2Ff4%2F0dfcf4a2976eb670af7e9c8b0e1493caed3cbad5",
               "67%2F12%2Fea%2F6712ea737c8b9fdb89988ebbf199d5d99cd700a6",
               "46%2F70%2Fb4%2F4670b4f84d103c72cff478ba470db93f1d9a9d77")) # RESTful, I think not
filenames<-paste0("watersheds.",c("shp","dbf","shx","prj","shp.xml","sbn","sbx"))

for(i in 1:length(urls)){
  download.file(urls[i],destfile=filenames[i])
}

#################################################-
## Read in data, reproject
#################################################-
watersheds<-spTransform(readOGR(".","watersheds"),
                        CRS("+proj=longlat +ellps=WGS84 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"))

#################################################-
## Trim to Colorado River Basin
#################################################-
CRBasin_full<-watersheds[!is.na(watersheds$NAW2_EN)&watersheds$NAW2_EN=="Colorado River",]
writeOGR(CRBasin_full,".","CRBasin_full",driver="ESRI Shapefile")
CRBasin_upper<-watersheds[!is.na(watersheds$NAW2_EN)&watersheds$NAW2_EN=="Colorado River"&
                            watersheds$USA_REG==14,]
writeOGR(CRBasin_upper,".","CRBasin_upper",driver="ESRI Shapefile")
CRBasin_lower<-watersheds[!is.na(watersheds$NAW2_EN)&watersheds$NAW2_EN=="Colorado River"&
                            watersheds$USA_REG!=14,]
writeOGR(CRBasin_lower,".","CRBasin_lower",driver="ESRI Shapefile")

# send to Dropbox
for(i in list.files(pattern="CRBasin_")){
  drop_upload(i,dest="ClimateActionRData/basin_boundary")
}

# clean up
unlink(list.files(pattern="^CRBasin_"))
unlink(list.files(pattern="watershed"))
