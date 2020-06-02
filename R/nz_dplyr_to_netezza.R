#' Save a dplyr object as netezza table
#'
#' @param DSN A DSN object exported from nz_init function
#' @param dplyr a dplyr object
#' @param outputTable name of the output table to store data
#' @param dropIfExist Drop if the outputTable does exist. Default is False. Use it with cautous since it removes
#' data in the existing outputTable permanently
#'
#' @return A dplyr object from outputTable
#' @export
#'
#' @examples
#' \dontrun{
#' DSN <- nz_init("NZSQL_F","ADMIN")
#' mbp <- nz_table_as_dplyr(DSN,"MPB")
#' head(mbp)
#' mbp2 <- nz_dplyr_to_netezza(DSN,mbp,"mbp2")
#' head(mbp2)
#' }
nz_dplyr_to_netezza <- function(DSN,dplyr,outputTable,dropIfExist=F){
  odbcConnection <- RODBC:::odbcConnect(DSN$DSN_NAME)
  con <- DBI:::dbConnect(RNetezza::Netezza(), dsn=DSN$DSN_NAME)
  qr <- dbplyr::sql_render(dplyr)
  if(dropIfExist){
    sqlDrop(odbcConnection, outputTable,errors = FALSE)
  }

  sql <- paste("create table SPATIAL_DB.",dbplyr::in_schema(DSN$SCHEMA, outputTable)," as ",qr,sep="")
  RODBC:::sqlQuery(odbcConnection, sql)
  data <- tbl(con, dbplyr::in_schema(DSN$SCHEMA, outputTable))
  return(data)
}
