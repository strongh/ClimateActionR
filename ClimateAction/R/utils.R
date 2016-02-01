#' Region of interest bounding box
#'
#' List with coordinates of bounding box for the southwestern US.
#' 
#' @export
#' @examples
#' 
sw.usa.bounding.box <- list(minLat=31, maxLat=42, minLon=-124, maxLon=-104)


#' Function for subsetting data on a bounding box
#'
#' Assuming that `lat` and `lon` are columns in data.frame df. Bounding box is expected to
#' be a list with minLon/maxLon/minLat/maxLat.
#' 
#' @param df data frame with lat and lon variables
#' @param bounding.box bounding box describing region of interest
#' @export
#' @examples
#' bounding.box.filter(spatial.data)

bounding.box.filter <- function(df, bounding.box=sw.usa.bounding.box){
  with(bounding.box, df %>% filter(minLat < lat, lat < maxLat, minLon < lon, lon < maxLon))
}