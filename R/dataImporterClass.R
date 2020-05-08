#library(R6)
#library(RODBC)
# Class to import text files into netezza db using external table
# @examples

ImporterClass <- R6::R6Class("DataImporter",
                         public = list(
                          debug = FALSE,

                          #' DSN_NAME
                          #'
                          #' @param DSN_NAME
                          #'
                          #' @return
                          #' @export
                          #'
                          #' @examples
                          setDSN = function(DSN_NAME){
                           private$odbcConnection <- odbcConnect(DSN_NAME)
                          },

                          #'
                          #' @param params list of parameters
                          #' @param append wheather append parameter to existing list or replace it
                          #'
                          #' @return
                          #' @export
                          #'
                          #' @examples
                          setExternalTableParams = function(params,append=FALSE){

                           if(append){
                             private$externalTableParams <- append(private$externalTableParams, params)
                           }else{
                             private$externalTableParams <- params
                           }
                         },


#'
#' @param tableName name of final table
#' @param finaltablecolumns column list of final table. this is used to make a new table it must be a list
#' sasme as the following list finaltablecolumns=list(name=c('dggid','value'),type=c('bigint','float'))
#' @param inputfilecolumns column list of text files, it must be as following list  inputfilecolumns=list(name=c('id','value','dggid'),type=c('varchar(100)','varchar(100)','varchar(100)'))
#' @param insertcolumns The type convertion of tables when copying from external table to distanation table. use the following example insertcolumns='CAST(dggid AS bigint),CAST(value AS float )', NOTE: the order of columns are same as @param finaltablecolumns list and column names are as @param inputfilecolumns
#' @param createTable = FALSE If true it drops previus table if exists  and makes a new table
#'
#' @return
#' @export
#'
#' @examples
                          setTableDetails = function(tableName, finaltablecolumns, inputfilecolumns, insertcolumns,
                                                    createTable = FALSE){


                           colList <-toString(unlist(do.call(Map, c(f = paste, unname(finaltablecolumns))), use.names = FALSE))
                           private$tableName <- tableName
                           private$createTable <- createTable
                           private$finaltablecolumns <- finaltablecolumns
                           private$inputfilecolumns <- inputfilecolumns
                           private$insertcolumns <- insertcolumns

                           if(private$createTable){
                             createQuery <- paste("CREATE TABLE", tableName, " (", colList ,"); ")
                             deleteTableQuery <- paste("drop table ", tableName, " if exists;")
                             print(paste("createQuery",createQuery,"drop",deleteTableQuery))
                             sqlQuery(private$odbcConnection, deleteTableQuery, errors = TRUE)
                             sqlQuery(private$odbcConnection, createQuery, errors = TRUE)
                           }
                         },

#'
#' @param path folder name
#' @param extention = "*.csv" file extentions in folder
#'
#' @return
#' @export
#'
#' @examples
                          importDirectory = function(path,  extention="*.csv"){

                            private$filenames <- dir(path, pattern = extention)
                            private$directory <- path
                            length <-length(private$filenames)
                            count = 0
                           for (f in private$filenames){
                             count = count +1
                             print(paste(count, "of",length,"Adding File name",basename(f),sep = ""))
                             self$importFile(paste(path,basename(f),sep = "") )
                             # print(paste(path, fsep = '\\', f, sep = ""))
                           }


                         },

#'
#' @param filename file name
#'
#' @return
#' @export
#'
#' @examples
                          importFile = function(filename){
                           logDir = dirname(file.path(filename))

                           #sql= paste('drop table testexternaltbl1_',private$tableName,' if exists; ',sep="");
                           #sqlQuery(private$odbcConnection, sql, errors = TRUE)

                           cols <- toString(unlist(do.call(Map, c(f = paste, unname( private$inputfilecolumns))), use.names = FALSE))
                           params <- paste(unlist(do.call(Map, c(f = paste, unname( private$externalTableParams ))), use.names = FALSE),collapse = " ")


                           #"VALUE","DGGID","TID","KEY"
                           string =paste("drop table externalname_",private$tableName,",testexternaltbl1_",private$tableName," if exists; create external table externalname_",private$tableName," ( ",
                                         cols ,"  ) USING (  DATAOBJECT(",paste("'",filename,"'",sep = ""),") REMOTESOURCE 'odbc' ",params," LOGDIR ",paste("'",logDir,"'",sep = "")," );create table testexternaltbl1_",private$tableName," as select * from externalname_",private$tableName,"; ",sep = "")
                           # "QUOTEDVALUE 'DOUBLE'  "


                           insert_sql = paste("INSERT INTO ",private$tableName," (",gsub('([[:punct:]])|\\s+',',',toString(unlist(do.call(Map, c(f = paste, unname(private$finaltablecolumns$name))), use.names = FALSE)))," ) SELECT ",private$insertcolumns," FROM testexternaltbl1_",private$tableName,";",sep="")
                           print(paste("ExternalTableSql",string))
                           print(paste("InsertSQL",insert_sql))



                           sqlQuery(private$odbcConnection, string, errors = TRUE)

                           count<-sqlQuery(private$odbcConnection,paste("select count(*) from  testexternaltbl1_",private$tableName,sep = ""), errors = TRUE)
                           print(paste("NumberOFRecordsInExternal",count))

                           countTableNameBefore<-sqlQuery(private$odbcConnection, paste("select count(*) from",private$tableName), errors = TRUE)
                           print(paste("CountBefore",countTableNameBefore))


                           sqlQuery(private$odbcConnection, paste("delete FROM testexternaltbl1_",private$tableName," where dggid='DGGID'",sep=""), errors = TRUE)

                           sqlQuery(private$odbcConnection, insert_sql, errors = TRUE)



                             countTableNameAfter<-sqlQuery(private$odbcConnection, paste("select count(*) from",private$tableName), errors = TRUE)
                             print(paste("countAfter",countTableNameAfter))

                           # if (debug){
                             print(paste('log Directory is',logDir))
                             print(paste("ExternalTableSql",string))
                             print(paste("InsertSQL",insert_sql))
                           # }

                             sqlQuery(private$odbcConnection, paste("drop table externalname_",private$tableName,",testexternaltbl1_",private$tableName," if exists;",sep = ""), errors = F)

                         }

                         ),
                         private = list(  odbcConnection = NA,
                                          filenames = NA,
                                          directory = NA,
                                          tableName = NA,
                                          createTable= FALSE,
                                          finaltablecolumns = NA,
                                          inputfilecolumns = NA,
                                          externalTableParams = list(name=c('SKIPROWS','QUOTEDVALUE','DELIMITER','NullValue'),type=c('1',"'DOUBLE'","','","'NA'")),
                                          insertcolumns = NA)
)



#' import_to_db
#'
#' @param directory Directory of CSV files
#' @param DSN The NZ DSN
#' @param value_type The type of Value possible options
#' float, varchar, integer, bigint
#' @param createTable Either make a new table and drop table if exists or make table
#' @param table_name  Name of the table to import data into
#'
#' @keywords netezza, import
#' @return
#' @export
#'
#' @examples
#' \dontrun{import_to_db()}

import_to_db <- function(DSN,directory,table_name,value_type='varchar',createTable=T){

  if(dir.exists(file.path(directory))){
    file_names <- dir(directory, pattern = '*.csv')
    length <-length(file_names)
    importer <- ImporterClass$new()
    importer$setDSN(DSN)
    importer$setTableDetails(table_name,finaltablecolumns=list(name=c('dggid','value','key','tid'),type=c('bigint',value_type,'varchar(100)','bigint')),
                             inputfilecolumns=list(name=c('value','dggid','tid','key'),
                                                   type=c('varchar(100)','varchar(100)','varchar(100)','varchar(100)')),
                             insertcolumns=paste('CAST(dggid AS bigint),CAST(value AS ',value_type,' ),key,CAST(tid as bigint)',sep=""),
                             createTable = createTable)


    importer$importDirectory(directory)
  }else{
    print("Directory parameter is not valid")
  }
}



