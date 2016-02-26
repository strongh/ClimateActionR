# Climate Action Training Workshop Tools & Datasets

# Data variables
+ `lat` - latitude
+ `lon` - longitude

# Spatial conventions
+ latitude: 31 to 42
+ longitude: -124 to -104
+ R bounding box object `list(minLat=31, maxLat=42, minLon=-124, maxLon=-104)`
+ see `ClimateAction` R package for function to perform subsetting to region of interest.
+ coordinate system: `+proj=longlat +ellps=WGS84 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs`

# R conventions
File names end in `*.R'.

# Install R package
The `ClimateAction` R package can be installed using the following command (requires `devtools` to be installed).

```r
devtools::install_github("strongh/ClimateActionR", subdir="ClimateAction")
```

# Data domains

## Climate
| Data file name | Short description | Data type | Data generation | Temporal coverage | Temporal Resolution | Spatial coverage | Spatial resolution | Metadata URL |
| -------------- | ----------------- | --------- | --------------- | ----------------- | ------------------- | ---------------- | ------------------ | ------------ |
| PRISM_temperature_normals.csv | Spatial temperature norms | Raster | PRISM | 1981-2010 | monthly | SW USA over | 4km grid squares | http://www.prism.oregonstate.edu/normals/ |

## Hydrology
| Data file name | Short description | Data type | Data generation | Temporal coverage | Temporal Resolution | Spatial coverage | Spatial resolution | Metadata URL |
| -------------- | ----------------- | --------- | --------------- | ----------------- | ------------------- | ---------------- | ------------------ | ------------ |
| CMIP5_streamflow.csv | Colorado River stream flow projections under multiple climate models/scenarios | Table | Model | 1950-2099 | Monthly | 9 georeferenced stations | N/A | http://gdo-dcp.ucllnl.org/downscaled_cmip_projections/ |
| paleo_streamflow.csv | Colorado River stream flow reconstructions from distant past | Table | Tree ring analysis | varies by site, >400 years | Annual | 7 georeferenced stations | N/A | http://treeflow.info/ |
| historic_streamflow.csv | Colorado River stream flow from recent past | Table | Stream gauges | 1906-2012 | Monthly | 9 stations | N/A | http://www.usbr.gov/lc/region/g4000/NaturalFlow/current.html |

## Ecology
| Data file name | Short description | Data type | Data generation | Temporal coverage | Temporal Resolution | Spatial coverage | Spatial resolution | Metadata URL |
| -------------- | ----------------- | --------- | --------------- | ----------------- | ------------------- | ---------------- | ------------------ | ------------ |

## Demography
| Data file name | Short description | Data type | Data generation | Temporal coverage | Temporal Resolution | Spatial coverage | Spatial resolution | Metadata URL |
| -------------- | ----------------- | --------- | --------------- | ----------------- | ------------------- | ---------------- | ------------------ | ------------ |
| ca_pop_projections.csv | Human population projections statewide & by county | Table | Demographic projection | 2010-2060 | Yearly | California | County | http://www.dof.ca.gov/research/demographic/reports/projections/ |

## Land use
| Data file name | Short description | Data type | Data generation | Temporal coverage | Temporal Resolution | Spatial coverage | Spatial resolution | Metadata URL |
| -------------- | ----------------- | --------- | --------------- | ----------------- | ------------------- | ---------------- | ------------------ | ------------ |
| GAP_landcover_CA.img | USGS GAP vegetation cover of California | Raster | Aerial image analysis | 1999-2001 | N/A | California | 30 m | http://gapanalysis.usgs.gov/gaplandcover/data/ |
| irrigated_area.csv | USGS water use irrigated land by category | Table | Data compilation | 1985-2010 | 5 years | California | County | http://waterdata.usgs.gov/ca/nwis/wu |
| water_withdrawals.csv | USGS water use by category | Table | Data compilation | 1985-2010 | 5 years | California | County | http://waterdata.usgs.gov/ca/nwis/wu |
| CA_crops_{YYYY}.tif | USDA crop cover | Raster | Aerial image analysis | 2007-2014 | Annual | California | 30 m | https://catalog.data.gov/dataset/cropscape-cropland-data-layer |

# Utility data

| Data file name | Short description | Data type | Data generation | Temporal coverage | Temporal Resolution | Spatial coverage | Spatial resolution | Metadata URL |
| -------------- | ----------------- | --------- | --------------- | ----------------- | ------------------- | ---------------- | ------------------ | ------------ |
| co.ca.wd.{shp} | Boundaries of Colorado River-using water districts in California | Shapefile | Administrative | N/A | N/A | N/A | N/A | https://datahub.io/dataset/california-water-district-boundaries |
| CRBasin_full.{shp} | Boundary of Colorado River Basin | Shapefile | Administrative | N/A | N/A | N/A | N/A | https://www.sciencebase.gov/catalog/item/4fb697b2e4b03ad19d64b47f |
| CRBasin_upper.{shp} | Boundary of Upper Colorado River Basin | Shapefile | Administrative | N/A | N/A | N/A | N/A | https://www.sciencebase.gov/catalog/item/4fb697b2e4b03ad19d64b47f |
| CRBasin_lower.{shp} | Boundary of Lower Colorado River Basin | Shapefile | Administrative | N/A | N/A | N/A | N/A | https://www.sciencebase.gov/catalog/item/4fb697b2e4b03ad19d64b47f |
| state_boundaries.{shp} | Boundaries of US states | Shapefile | Administrative | N/A | N/A | N/A | N/A | https://www.census.gov/geo/maps-data/data/tiger-line.html |
| county_boundaries.{shp} | Boundaries of US counties and equivalents | Shapefile | Administrative | N/A | N/A | N/A | N/A | https://www.census.gov/geo/maps-data/data/tiger-line.html |
