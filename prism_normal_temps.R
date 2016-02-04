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
library(ClimateAction)

options(prism.path = "~/data/prism")

output.file.name <- "PRISM_temperature_normals.csv"

## TODO download more data, by changing year range.
## TODO need to add date as a column

get_prism_monthlys(type="tmean", year = 1990:1992, mon = 1:12, keepZip=T)

RS <- prism_stack(ls_prism_data()[60:62,1])

df <- data.frame(rasterToPoints(RS))

m.df <- melt(df, c("x", "y"))
names(m.df)[1:2] <- c("lon", "lat")

write.csv(m.df, "PRISM_temp_normals.csv")

sw.usa.df <- bounding.box.filter(m.df)
write.csv(sw.usa.df, output.file.name)
drop_upload(output.file.name, dest = "ClimateActionRData")
