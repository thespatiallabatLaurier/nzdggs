
#' Netezza Table To dplyr
#'
#' @param DSN DSN object extracted from nz_init function
#' @param tableName the name of the table to read
#'
#' @return A dplyr object
#' @export
#'
#' @examples
#' \dontrun{
#' DSN <- nz_init("NZSQL_F","ADMIN")
#' mbp <- nz_table_as_dplyr(DSN,"MPB")
#' head(mbp)
#' }
#'
nz_table_as_dplyr <- function(DSN,tableName){
  con <- DBI:::dbConnect(RNetezza::Netezza(), dsn=DSN$DSN_NAME)
  data <- tbl(con, dbplyr::in_schema(DSN$SCHEMA, tableName))
  return(data)
}
