#################################################-
## DOMAIN: HYDROLOGY
## Retrieve historic & paleo flow data
## Author: W. Petry
#################################################-
## Preliminaries
library(rdrop2)
library(plyr)
library(dplyr)
library(magrittr)
library(rgdal)
library(stringr)

#################################################-
## Recorded historic flow
#################################################-
# Source is way too messy to clean up programatically -- done manually in Excel (ugh!)
# http://www.usbr.gov/lc/region/g4000/NaturalFlow/NaturalFlows1906-2012_withExtensions_1.8.15.xlsx
# saved as historic_streamflow.csv

#################################################-
## Estimated paleo flow reconstructed from tree rings
## http://treeflow.info/
#################################################-
gauges<-data.frame(Site=c("cisco","leeswoodhouse","glenwood","leesmeko","granby","hotsulphur",
                          "kremmling"),
                   USGS.id=paste0(0,c(09180500,09380000,09072500,09380000,09019500,09034500,09058000)),
                   skipl=c(17,17,17,16,15,13,13))

urls<-paste0("http://treeflow.info/sites/default/files/colorado",gauges$Site,"_0.txt")
paleo<-vector(mode="list")
for(i in 1:nrow(gauges)){
  paleo[[i]]<-read.table(urls[i],header=T,skip=gauges$skipl[i],na.string=-9999)
  paleo[[i]]$USGS.id<-gauges$USGS.id[i]
  names(paleo)[i]<-as.character(gauges$Site[i])
}
paleo<-ldply(paleo,.id="Site") %>% rename(reconst.acreft=Recon,observ.acreft=Observed)
names(paleo) %<>% tolower

# get coordinates for gauges
gauge.coords<-ldply(lapply(gauges$USGS.id,function(x){
  webs<-readLines(paste0("http://waterdata.usgs.gov/nwis/inventory/?site_no=",x,"&agency_cd=USGS"))
  webs.sub<-gsub("[&#,;,']{1,2}",":",webs[grep("Latitude",webs)])
  coords<-gsub("176:","",webs.sub)
  lat<-str_extract_all(coords,"[0-9]+:[0-9]+:[0-9]+")[[1]][1]
  long<-str_extract_all(coords,"[0-9]+:[0-9]+:[0-9]+")[[1]][2]
  lat.dms<-as.numeric(strsplit(lat,":")[[1]])
  long.dms<-as.numeric(strsplit(long,":")[[1]])
  out<-data.frame(usgs.id=x,lat.dd=lat.dms[1]+((lat.dms[2]+(lat.dms[3]/60))/60),
                  long.dd=long.dms[1]+((long.dms[2]+(long.dms[3]/60))/60))
  return(out)}))

paleo.flow<-merge(paleo,gauge.coords)

# upload to Dropbox and clean up
write.csv(paleo.flow,"paleo_streamflow.csv")
drop_upload("paleo_streamflow.csv",dest="/ClimateActionRData")

unlink("paleo_streamflow.csv")
