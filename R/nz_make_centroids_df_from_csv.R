#' Generate Centroids
#' @description Generate Centroid dataframe from a csv file with the following columns "DGGID","X","Y"
#'
#' @param csvpath input csv file with the following columns "DGGID","X","Y"
#' to reproject data you can use coord2=spTransform(coord2,CRS("+proj=laea +lon_0=0 +lat_0=90 +x_0=0 +y_0=0 +a=6378137 +rf=298.257223563"))
#' @return an object with the df parameter which is a df object of csv and a coords parameter
#' which is an spatial dataframe object
#' @export
#'
#' @examples
#'
nz_make_centroids_df_from_csv <- function(csvpath){

  df <- read.table(csvpath, header = FALSE,sep = ",",col.names=c("DGGID","X","Y"))
  coord_matrix_x<-as.numeric(as.matrix(df$X))
  coord_matrix_y<-as.numeric(as.matrix(df$Y))
  coord2 <- cbind(coord_matrix_x, coord_matrix_y)
  coord2<-as.data.frame(coord2)
  coordinates(coord2)<-c("coord_matrix_x","coord_matrix_y")
  crs(coord2)= "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"
  my_list <- list("df" = df, "coords" = coord2)
  return(my_list)
}

