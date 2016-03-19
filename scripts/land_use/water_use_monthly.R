###########################################################
## DOMAIN: LAND USE
## Retrieve California water use data by water district, monthly June 2014 - January 2015
## URL: http://www.waterboards.ca.gov/water_issues/programs/conservation_portal/conservation_reporting.shtml
## Author: W. Petry
###########################################################
## Preliminaries
library(readxl)
library(dplyr)
library(magrittr)
library(tidyr)

###########################################################
download.file("http://www.waterboards.ca.gov/water_issues/programs/conservation_portal/docs/2016feb/uw_supplier_data022516.xlsx",destfile="ca_waterdist_2014-2016.xlsx")

water_use<-read_excel("ca_waterdist_2014-2016.xlsx")

str(water_use)  # rename columns manually (REP=reported, CALC=calculated)
names(water_use)<-c("water_district","stage_invoked","mandatory_restrictions","month",
                       "REP.total_water_production","REP.total_water_production2013",
                       "REP.commercial_water_production","REP.agricultural_use",
                       "REP.agricultural_use2013","REP.recycled_water",
                       "rep.units","qualification","population","rep.residential_gpcd",
                       "enforcement_actions","implementation","conserv_standard",
                       "aqricultural_exclusion_cert",
                       "CALC.total_water_production","CALC.potable_water_production2013",
                       "CALC.commercial_water_production","calc.residential_gpcd",
                       "percent_residential_use","corrections","hydrologic_region",
                       "watering_days_per_week","complaint_count","complaint_followup_count",
                       "warnings_issued_count","rate_penalties_assessed","penalties_assessed",
                       "enforcement_comments")

water_use %<>%
  mutate(CALC.commercial_water_production=as.numeric(ifelse(CALC.commercial_water_production=="Null",NA,CALC.commercial_water_production))) %>%
  mutate(unit.mult=ifelse(rep.units=="AF",325851.427,ifelse(rep.units=="CCF",748.052,
                          ifelse(rep.units=="G",1,ifelse(rep.units=="MG",1000000,NA))))) %>%
  mutate_each(funs(.*unit.mult),matches("^[A-Z]{3,4}\\.",ignore.case=F)) %>%
  gather("method","water_volume_gal",matches("^[A-Z]{3,4}\\.",ignore.case=F)) %>%
  separate(method,c("method","variable"),sep="\\.")

write.csv(water_use,"ca_water_use_monthly.csv")

drop_upload("ca_water_use_monthly.csv",dest="ClimateActionRData/land_use")

unlink("ca_water_use_monthly.csv")
unlink("ca_waterdist_2014-2016.xlsx")

###########################################################
## Add shapefile for water districts
# http://cehtp.org/page/water/download

## MANUALLY DOWNLOADED because of login requirement

water_dists<-readOGR(".","ca_water_districts")

