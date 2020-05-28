
#' Find duplicates
#' @description  Find duplicate cells in a table. If the returned dataframe is empty it does not have any duplicate cells.
#'
#' @param DSN Nz information object
#' @param table table name in format of
#' @param limit Whether to show all the duplicates or only show 100 result. It can cause performance issue on large
#' tables if you set it to FALSE. Default is TRUE
#'
#' @return a sqlQuery object
#' @export
#'
#' @examples
nz_find_duplicates <- function(DSN,table,limit = T){
  odbcConnection <- odbcConnect(DSN$DSN_NAME)
  if(limit==T){
    query <- paste("SELECT DGGID, TID, VALUE, KEY, COUNT(1) AS Cnt FROM SPATIAL_DB.",DSN$SCHEMA,'.',table,"  GROUP BY DGGID, TID, VALUE, KEY HAVING Cnt > 1  ORDER BY Cnt DESC LIMIT 100",sep = "")
  }else{
    query <- paste("SELECT DGGID, TID, VALUE, KEY, COUNT(1) AS Cnt FROM SPATIAL_DB.",DSN$SCHEMA,'.',table,"   GROUP BY DGGID, TID, VALUE, KEY HAVING Cnt > 1  ORDER BY Cnt DESC",sep = "")
  }
  result<-sqlQuery(odbcConnection,query, errors = TRUE)
  return(result)
}
