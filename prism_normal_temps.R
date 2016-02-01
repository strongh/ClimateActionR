#################################################-
## DOMAIN: CLIMATE
## PRISM normal temperatures
## URL: https://github.com/ropensci/prism
## Author: H. Strong
#################################################-
## Preliminaries
library(dplyr)
library(magrittr)
library(reshape2)
library(raster)
library(prism)

options(prism.path = "~/data/prism")
## TODO download more data, by changing year range.
## TODO need to add date as a column
## TODO limit to bounding box
get_prism_monthlys(type="tmean", year = 1990:1992, mon = 1:12, keepZip=F)

RS <- prism_stack(ls_prism_data()[60:62,1])

df <- data.frame(rasterToPoints(RS))

m.df <- melt(df, c("x", "y"))
names(m.df)[1:2] <- c("lon", "lat")

## ggplot(m.df[1:100000,], aes(lon, lat)) + geom_raster(aes(fill=value))

write.csv(m.df, "PRISM_temp_normals.csv")