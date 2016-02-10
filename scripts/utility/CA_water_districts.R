#################################################-
## DOMAIN: UTILITY
## Retrieve California Water District boundaries, subset to those using Colorado River
## URL: https://datahub.io/dataset/california-water-district-boundaries
## Official databases have dead links as of 30 Jan 2015
## Author: W. Petry
#################################################-
## Preliminaries
library(rdrop2)
library(rgdal)
library(maptools)

#################################################-
## Download data, unzip, and upload to Dropbox
#################################################-
download.file("https://ckannet-storage.commondatastorage.googleapis.com/2015-05-08T15:05:19.771Z/usbr-wat-dist-state-2003-03-25.zip",destfile="CA_public_districts.zip",mode="wb")
download.file("https://ckannet-storage.commondatastorage.googleapis.com/2015-05-08T14:33:37.087Z/usbr-wat-dist-priv.zip",destfile="CA_private_districts.zip",mode="wb")

unzip("CA_public_districts.zip")
unlink("CA_public_districts.zip")
ca.pub.wd<-readOGR(".","wdst24",p4s="+proj=utm +zone=10 +datum=NAD27 +units=m +no_defs +ellps=clrk66
+nadgrids=@conus,@alaska,@ntv2_0.gsb,@ntv1_can.dat")
ca.pub.wd<-spChFIDs(ca.pub.wd,as.character(901:938)) # reset polygon IDs to allow merger

unzip("CA_private_districts.zip")
unlink("CA_private_districts.zip")
ca.pri.wd<-readOGR(".","wdpr24")

# merge together public and private water district shapefiles
ca.wd<-spRbind(ca.pub.wd,ca.pri.wd)

# subset to Colorado River users
# from http://www.mwdh2o.com/PDF_NewsRoom/6.4.2_Maps_MemberAgencies.pdf
co.user.names<-c("METROPOLITAN WATER DISTRICT","DESERT WATER AGENCY","COACHELLA VALLEY W.D.",
                 "IMPERIAL I.D.")
co.ca.wd<-ca.wd[ca.wd@data$WDNAME %in% co.user.names,]

# remove component shapefiles
unlink(list.files(pattern="[a-z]{4}24"))

# write output shapefile, send to Dropbox, clean up lingering files
writeOGR(co.ca.wd,".",layer="co.ca.wd",driver="ESRI Shapefile")
for(i in list.files(pattern="co.ca.wd")){
  drop_upload(i,dest="ClimateActionRData/CA_water_districts")
  unlink(i)
}
