#' Export centroids
#' @description Export centroids from Netezza FinalGrid table for specific resolution.
#' @param DSN NZODBC DSN object made by nz_init function
#' @param output_directory The output directory to store csv file (like F:\\data\\store)it should be available on the disc
#' @param resolution the resolution of the data
#'
#' @return
#' @export
#'
#' @examples
nz_export_centroids_from_db <- function(DSN, output_directory,resolution){

  if(dir.exists(output_directory)){
    query <- paste("CREATE EXTERNAL TABLE '",output_directory,"\\centroids.csv' USING (	DELIMITER ','	ENCODING 'internal'	REMOTESOURCE 'ODBC'	ESCAPECHAR '\') AS select DGGID,  inza..ST_X(inza..st_Centroid(geom)) as x, inza..ST_Y(inza..st_Centroid(geom)) as y  from SPATIAL_SCHEMA.FINALGRID1 where resolution=",resolution,sep="")
    odbcConnection <- odbcConnect(DSN$DSN_NAME)
    sqlQuery(odbcConnection, query, errors = TRUE)

  }else{
    print("Input directory does not exist")
  }

}

