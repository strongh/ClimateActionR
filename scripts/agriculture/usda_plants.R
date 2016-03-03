## Not clear how to scrpe this
## http://plants.usda.gov/adv_search.html
## but i downloaded a file with agricultural crops in the SW US states
## with columns drought tolerance, salinity toerance, and min temp. i will upload it.

usda.raw <- read.csv("scripts/agriculture/usda_plants.csv")

usda.raw <- usda.raw[, c(3:8)]
names(usda.raw) <- c("scientific.name", "common.name", "drought.tolerance", "moisture.use", "salinity.tolerance", "min.temperature")
