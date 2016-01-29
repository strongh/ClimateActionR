#################################################-
## DOMAIN: HYDROLOGY
## Retrieve downsampled CMIP-5 streamflow projections at NCAR stream monitoring sites
## URL: http://gdo-dcp.ucllnl.org/downscaled_cmip_projections/
## Author: W. Petry
#################################################-
## Preliminaries
library(plyr)
library(dplyr)
library(magrittr)
library(rdrop2)
library(tidyr)

#################################################-
## Construct URLs to retrieve Colorado River basin data
#################################################-
# Retrieve site list
site.list<-read.table("ftp://gdo-dcp.ucllnl.org/pub/dcp/archive/cmip5/hydro/routed_streamflow/NCAR_cmip5_streamflow_sites.txt",sep="\t")
names(site.list)<-c("site.abb","lat","long","basin","id","site.name")

# Build FTP URLs
site.list %<>% mutate(FTP=paste0("ftp://gdo-dcp.ucllnl.org/pub/dcp/archive/cmip5/hydro/routed_streamflow/cmip5_ncar_mon/streamflow_cmip5_ncar_month_",site.abb,".csv.zip"),
                      file.name=paste0("streamflow_cmip5_ncar_month_",site.abb,".csv"))

# Filter to desired sites (a) in Colorado River Basin and (b) along the Colorado River proper
crb.sites<-site.list %>% filter(basin=="COLO") # _C_olorado _R_iver _B_asin sites
cr.sites<-crb.sites %>% filter(grepl("^Colorado R",site.name)) # _C_olorado _R_iver sites (sensu stricto)

#################################################-
## Download data to shared Dropbox folder
#################################################-
# Writes separate csv for each monitoring station to working directory
# for(i in 1:nrow(cr.sites)){
#   tf<-tempfile()
#   download.file(cr.sites$FTP[i],tf,mode="wb")
#   unzip(tf,files=paste0("cmip5_ncar_mon/",cr.sites$file.name[i]),junkpaths=T)
#   unlink(tf)
# }

# Combines into single csv containing all monitoring stations, write to Dropbox
dat.list<-vector(mode="list")
for(i in 1:nrow(cr.sites)){
  tf<-tempfile()
  download.file(cr.sites$FTP[i],tf,mode="wb")
  dat.list[[i]]<-read.csv(unz(tf,filename=paste0("cmip5_ncar_mon/",cr.sites$file.name[i])))
  dat.list[[i]]$Station<-as.character(cr.sites$site.abb[i])
  unlink(tf)
}

# Prepare data for output to a single csv file
output.df<-plyr::ldply(dat.list) %>%
  gather(GCM.string,streamflow,access1.0_rcp45_r1i1p1:noresm1.m_rcp85_r1i1p1) %>%
  separate(GCM.string,c("GCM","Scenario","excess"),sep="_",remove=F) %>%
  select(-excess)

write.csv(output.df,"CMIP5_streamflow.csv")
drop_upload("CMIP5_streamflow.csv",dest="ClimateActionRData")

