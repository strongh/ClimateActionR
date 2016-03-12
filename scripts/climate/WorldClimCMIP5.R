#################################################-
## DOMAIN: CLIMATE
## Retrieve and crop CMIP5 climate projections
## Author: W. Petry
#################################################-
## Preliminaries
library(rdrop2)
library(dplyr)
library(rgdal)
library(raster)

options(timeout=1000)

#################################################-
## Get model output, crop to focal region, write output
#################################################-
mods<-expand.grid(var=c("tn","tx","pr"),
                  rcp=c(26,45,60,85),
                  model=c("AC","BC","CC","CE","CN","GF","GD","GS","HD","HG","HE","IN","IP",
                          "MI","MR","MC","MP","MG","NO"),
                  year=c(50,70),
                  res="2_5m") %>%
  mutate(filename=paste0(tolower(model),rcp,var,year),
         url=paste0("http://biogeo.ucdavis.edu/data/climate/cmip5/",res,"/",filename,".zip"))

path<-"~/Desktop/WorldClim/"
dir.create(path)
urls<-mods$url

dwnldfxn<-function(aurl,filename){
  try(raster:::.download(aurl,filename))
}
urls<-mods$url
zipfile<-paste0(path,substr(urls,nchar(urls)-12+1,nchar(urls)))
mapply(dwnldfxn,aurl=urls,filename=zipfile)

###########################################################
## Subset files
###########################################################
zfs<-list.files(path,pattern="zip",full.names=T)

# Check that all files were downloaded
counts<-c(2,4,4,1,3,3,3,4,4,2,4,2,4,4,4,4,3,4,4)*3*2
names(counts)<-c("ac","bc","cc","ce","cn","gf","gd","gs","hd","hg","he","in","ip","mi","mr","mc","mp","mg","no")
counts
table(substr(zfs,1,2))


cat.bbox<-bbox(matrix(c(-124,-104,31,42),nrow=2,byrow=F))

for(i in zfs){
  unzip(i,exdir=path)  # unzip file
  unlink(i)  # remove zip file
  patt<-substr(i,nchar(i)-12+1,nchar(i)-4)
  gtifs<-list.files(dir,pattern=patt,full.names=T)[c(1,5:12,2,3,4)]  # get tif filenames + reorder files to correct sequence of months
  tempstack<-stack(gtifs)
  ctempstack<-crop(tempstack,cat.bbox)
  writeRaster(ctempstack,paste0(dir,"/",patt,".grd"),"raster")
  unlink(gtifs)
  print(paste0("Finished with file ",patt," (",which(zfs==i)," out of ",length(zfs),")"))
}

## No data upload step for these -- handled manually






