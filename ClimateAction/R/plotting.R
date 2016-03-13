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
  require(magrittr)
  shp.suffixes <- c("shp", "dbf", "shx", "prj")
  for (f in shp.suffixes)
    rdrop2::drop_get(paste0("ClimateActionRData/", dir, "/", shape.name, ".", f), overwrite=TRUE)

  shape.name <- rgdal::readOGR(dsn=".", layer=shape.name)
  shape.name@data$id <- rownames(shape.name@data)
  shape.name.points <- ggplot2::fortify(shape.name, region="id")
  shape.name.df <- dplyr::left_join(shape.name.points, shape.name@data, by="id")
  shape.name.df #%>% dplyr::rename(long=lon)
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
  require(ggplot2)
  shape.data <- shape.df(dir, shape.name)
  geom_path(data=shape.data, aes(group=group))
}
