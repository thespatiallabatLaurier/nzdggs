#' make nz db object
#' @description Makes an Netezza db object for the user. Most of functions that need to interact with th
#' netezza database need this object as input.
#' @param DSN_NAME The DSN name for connection
#' @param SCHEMA The database Schema
#'
#' @return an nz db object
#' @export
#'
#' @examples
#' obj <- nz_init("NZSQL","SPATIAL_SCHEMA")
nz_init <- function(DSN_NAME,SCHEMA){
  list <- list(DSN_NAME=DSN_NAME,SCHEMA=SCHEMA)
  return(list)
}
