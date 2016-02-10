#################################################-
## DOMAIN: LAND USE
## Retrieve California water use data 1985-2010
## URL: http://waterdata.usgs.gov/ca/nwis/wu
## Author: W. Petry
#################################################-
## Preliminaries
library(rdrop2)
library(dplyr)
library(tidyr)

#################################################-
## Download data, unzip, and upload to Dropbox
#################################################-
data.url<-"http://waterdata.usgs.gov/ca/nwis/water_use?format=rdb&rdb_compression=value&wu_area=County&wu_year=ALL&wu_county=ALL&wu_category=TP%2CPS%2CCO%2CDO%2CIN%2CPT%2CLI%2CIT%2CIC%2CIG%2CHY%2CWW&wu_county_nms=--ALL%2BCounties--&wu_category_nms=Total%2BPopulation%252CPublic%2BSupply%252CCommercial%252CDomestic%252CIndustrial%252CTotal%2BThermoelectric%2BPower%252CLivestock%252CIrrigation%252C%2BTotal%252CIrrigation%252C%2BCrop%252CIrrigation%252C%2BGolf%2BCourses%252CHydroelectric%2BPower%252CWastewater%2BTreatment"
water.use<-read.table(data.url,header=F,skip=165,sep="\t",na.strings=c("-","na"),col.names=)
names(water.use)<-names(read.table(data.url,header=T,skip=163,nrows=1,sep="\t"))

# Extract water use data
water.withdrawals<-water.use %>%
  select(-contains("state_")) %>%
  rename(total.population=Total.Population.total.population.of.area..in.thousands) %>%
  mutate(total.population=total.population*1000) %>%
  group_by(county_cd,county_nm,year,total.population) %>%
  select(contains("in.Mgal")) %>%
  mutate_each(funs(as.numeric)) %>%
  rename_(.dots=setNames(names(.),tolower(gsub("\\.{1,2}in\\.[A-z]gal\\.d$","",names(.))))) %>%
  gather(key=use.category,value=Mgal.d,-county_cd,-county_nm,-year,-total.population)

# Extract irrigation area data
irrigated.area<-water.use %>%
  select(-contains("state_")) %>%
  group_by(county_cd,county_nm,year) %>%
  select(contains("acres")) %>%
  rename_(.dots=setNames(names(.),tolower(gsub("^Irrigation\\.{1,2}","",names(.))))) %>%
  rename_(.dots=setNames(names(.),tolower(gsub("\\.{1,2}in\\.thousand\\.acres$","",names(.))))) %>%
  gather(key=use.category,value=thousand.acres,-county_cd,-county_nm,-year)

# Upload to Dropbox and clean up
write.csv(water.withdrawals,"water_withdrawals.csv")
drop_upload("water_withdrawals.csv",dest="ClimateActionRData")
unlink("water_withdrawals.csv")
write.csv(irrigated.area,"irrigated_area.csv")
drop_upload("irrigated_area.csv",dest="ClimateActionRData")
unlink("irrigated_area.csv")


