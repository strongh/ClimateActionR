#################################################-
## DOMAIN: LAND USE
## Retrieve land cover data from USGS GAP program
## URL: http://gapanalysis.usgs.gov/gaplandcover/data/
## Author: W. Petry
#################################################-
## Preliminaries
library(rdrop2)

#################################################-
## Download data, unzip, and upload to Dropbox
#################################################-
download.file("https://s3.amazonaws.com/GapFTP/NAT_LC/Regions/GRID/gaplc_swest.zip",
              destfile="GAP_vegcov_SW.zip",mode="wb")

drop_upload("GAP_vegcov_SW.zip",dest="ClimateActionRData/land_use") # unzips to ~1GB!
unlink("GAP_vegcov_SW.zip")
