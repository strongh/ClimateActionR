#' Get a dataframe representing a set of Shapefiles
#'
#' Gets shapefiles from Dropbox, and then turns them into
#' a more usable data frame. Base on
#' 
#' https://github.com/hadley/ggplot2/wiki/plotting-polygon-shapefiles
#' 
#' @param df data frame with lat and lon variables
#' @param partial path to shapefiles
#' @export
#' @examples
#' shape.df("basin_boundary", "CRBasin_lower")
shape.df <- function(dir, shape.name) {
  shp.suffixes <- c("shp", "dbf", "shx", "prj")
  for (f in shp.suffixes)
    drop_get(paste0("ClimateActionRData/", dir, "/", shape.name, ".", f), overwrite=TRUE)
  
  shape.name <- readOGR(dsn=".", layer=shape.name)
  shape.name@data$id <- rownames(shape.name@data)
  shape.name.points <- fortify(shape.name, region="id")
  shape.name.df <- join(shape.name.points, shape.name@data, by="id")
  shape.name.df %>% rename(lon=long)
}

#' Create a ggplot geom of shapefiles
#'
#' For easily superimposing polygons onto other maps.
#' 
#' @param df data frame with lat and lon variables
#' @param partial path to shapefiles
#' @export
#' @examples
#' example.data <- drop_read_csv("/ClimateActionRData/PRISM_temperature_normals.csv")
#' ggplot(example.data, aes(lon, lat)) + geom_raster(aes(fill = value)) + geom_shape("basin_boundary", "CRBasin_full")
geom_shape <- function(dir, shape.name) {
  shape.data <- shape.df(dir, shape.name)
  geom_path(data=shape.data, aes(group=group))
}
