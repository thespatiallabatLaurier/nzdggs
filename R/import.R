source(".//timeClass.R")
source("dataImportClass.R")


#' import_to_db
#'
#' @param directory Directory of CSV files
#' @param table_name  Name of the table to import data into
#' @param append add data to an existing table, if it is False we will make a new table
#' @param drop drops table while creating a new table, Default is False
#' @keywords netezza, import
#' @return
#' @export
#'
#' @examples
#' import_to_db()
import_to_db <- function(DSN,directory,table_name,value_type='varchar',createTable=T){

  if(dir.exists(file.path(directory))){
    file_names <- dir(directory, pattern = '*.csv')
    length <-length(file_names)
    importer <- ImporterClass$new()
    importer$setDSN(DSN)
    importer$setTableDetails(table_name,finaltablecolumns=list(name=c('dggid','value','key','tid'),type=c('bigint',value_type,'varchar(100)','integer')),
                             inputfilecolumns=list(name=c('dggid','key','value','tid'),
                                                   type=c('varchar(100)','varchar(100)','varchar(100)','varchar(100)')),
                             insertcolumns=paste('CAST(dggid AS bigint),CAST(value AS ',value_type,' ),key,CAST(tid as integer)',sep=""),
                             createTable = append)


    importer$importDirectory(directory)
  }else{
    print("Directory parameter is not valid")
  }
}

convert_raster_to_dggs <- function(path,centroids_csv){

  if(file.exists(path)){

  }else{
    print('Input file in not valid')
  }

}

convert_shp_to_dggs <- function(){

}



