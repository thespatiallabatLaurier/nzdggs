#' dataframe to dggs
#'
#' @description Converts a dataframe with a DGGID/TID column and set of other columns (keys) to csv
#' datasets to be able to import them into netezza. You can import csv files to the database using nz_import_dir_to_db function
#' @param DGGID A dataframe column containing DGGIDs
#' @param TID An integer or dataframe column
#' @param df dataframe with the remaining keys. Remove DGGID/TID columns from it
#' @param SaveIn The directory path to store data there. It must exist
#' @param convertKeys  Keys that are supposed to be converted. \strong{all} means converting all the
#' keys. \strong{NA} means does not convert any keys.Use a vector of column names to only convert specific keys
#
#'
#' @return
#' @export
#'
#' @examples \dontrun{
#' csv<-read.csv2("D:\\UserData\\Majid\\Downloads\\mpb-ev.csv",sep=",")
#' head(csv)
#' nz_convert_df_to_dggs(csv$DGGID,-1,csv,"E:\\home\\crobertson")
#' #importing to the db
#' DSN <- nz_init("NZSQLF","SPATIAL_SCHEMA")
#' nz_import_dir_to_db(DSN,"/home/crobertson/import/","mbpev","varchar(100)")
#'
#' }
nz_convert_df_to_dggs <- function(DGGID,TID,df,SaveIn,convertKeys='all'){

  SaveIn <- paste(SaveIn,"/",sep = "")

  #"VALUE","DGGID","TID","KEY"

  if(convertKeys == 'all'){
    keys = names(df)
  }else if (is.na(convertKeys)){
    keys  <-  c()
  }else{
    keys  <-  intersect(convertKeys,names(df))
  }

  if(NROW(TID)==1){
    TID=rep(TID,length(DGGID))
  }

  convert_keys <- function(key) {
    df2 <- data.frame(VALUE=df[[key]],DGGID=DGGID,TID=TID,KEY=rep(key,length(DGGID)))
    name<-paste(SaveIn,'\\',"_",key,'.csv',sep="")
    write.csv(df2,name, row.names=FALSE)
    rm(df2)
  }

  mapply(convert_keys,keys)


}





