


#' keylookup table keys
#' @description get the keys in the keylookup table
#' @param DSN Nz information object
#' @param table The teble to get keys from. It can also be NA so it will return entire keylookup table. It only queries keys which ends with __ED
#'
#' @return  a sqlQuery object
#' @export
#'
#' @examples \dontrun{
#' nz_keylookup_getkeys(DSN,table = "TEST_MBPEV")
#' }
nz_keylookup_getkeys <- function(DSN,table=NA){
  odbcConnection <- odbcConnect(DSN$DSN_NAME)
  if(is.na(table)){
    query <- paste("SELECT *  FROM SPATIAL_DB.SPATIAL_SCHEMA.KEYLOOKUPTABLE",sep = "")
  }else{
    query <- paste("SELECT distinct a.*  FROM SPATIAL_DB.SPATIAL_SCHEMA.KEYLOOKUPTABLE as a  left join SPATIAL_DB.",DSN$SCHEMA,'.',table," as b on a.HASH=b.VALUE
  where  SQLEXT.strright(b.key, 4)= '__ED'",sep = "")
  }
  result<-sqlQuery(odbcConnection,query, errors = TRUE)
  return(result)
}
