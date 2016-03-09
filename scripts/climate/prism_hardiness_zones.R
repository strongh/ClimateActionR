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
library(rdrop2)
#library(ClimateAction)

options(prism.path = "~/data/prism")

output.file.name <- "normal_min_temperatures.csv"

cel.to.farenheit <- function(cel){
  cel * 9 / 5 + 32
}

get_prism_normals(type="tmin", keepZip=TRUE, annual=TRUE, resolution="4km")
file.name <- "PRISM_tmin_30yr_normal_4kmM2_annual_bil"
RS <- prism_stack(file.name) #prism_stack(ls_prism_data()[60:62,1])

df <- data.frame(rasterToPoints(RS))
names(df) <- c("lon", "lat", "normal_min_temp_c")
df$zone <- 7 + 0.1 * cel.to.farenheit(df$normal_min_temp_c)
df$zone_round <- floor(df$zone) 
#m.df <- melt(df, c("x", "y"))

  # i used the below to generate the linear formula from farenheit temp to zone
# lower bound of a
#trivial.map <- data.frame(zone=c(5, 8, 10), f=c(-15, 15, 35))
# lm(zone ~ f, data=trivial.map)
#names(m.df)[1:2] <- c("lon", "lat")

write.csv(df, output.file.name)


drop_upload(output.file.name, dest = "ClimateActionRData")