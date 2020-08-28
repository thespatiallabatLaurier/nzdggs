#' Add metadata
#' @describeIn Adds metadata rows to the database. it will remove all the exisiting records.
#' To be able to render a layer you have to call this function on the table. Everytime you update values for
#' a key in the table you also need to call this function
#' @param DSN DSN object extracted from nz_init
#' @param table_name name of the table
#' @param description table description. if you put it NA it will not update description and legend.
#' @param legend legend of the layer.
#'
#' @return
#' @export
#'
#' @examples \dontrun{
#' DSN <- nz_init("NZSQLF","SPATIAL_SCHEMA")
#' nz_add_metadata(DSN,"NLULCDATA")
#' }
nz_add_metadata <- function(DSN, table_name,description=NA,legend=NA){

odbcConnection <- odbcConnect(DSN$DSN_NAME)
uid <- table_name
table_name=dbplyr::in_schema(DSN$SCHEMA, table_name)

#CREATE TABLE SPATIAL_SCHEMA.METADATA2
#( NAME varchar(100), UID varchar(100), Discription varchar(100),avg float, meadian float, sum float, max float, min float, count float, var_pop float, resolution integer, tid bigint, key varchar(100))

query1 <- paste("select Resolution from spatial_schema.FINALGRID2 where dggid in (select DGGID from ",table_name," limit 1)")
res <- sqlQuery(odbcConnection, query1)
res <- res$RESOLUTION
df <- NA
query1 <- paste("delete from SPATIAL_SCHEMA.METADATA2 where UID='",uid,"'",sep = "")
sqlQuery(odbcConnection, query1)
  if (!is.null(res)&isTRUE(res!=0)){
    query1 <- paste("select unique(key) from ",table_name,sep = "")
    keys <- sqlQuery(odbcConnection, query1)
    print(keys)
    for (k in keys$KEY){

      query1 <- paste("select unique(tid) from ",table_name, " where KEY='",k,"'",sep = "")
      tids <- sqlQuery(odbcConnection, query1)
      for (t in tids$TID){
       if(is.numeric(t)){
         query1 <- paste("select avg(VALUE),median(VALUE),sum(VALUE),max(VALUE),min(VALUE),count(VALUE),VAR_POP(VALUE) from ",table_name, " where KEY='",k,"' AND TID=",t,sep = "")

       }else{
         query1 <- paste("select avg(VALUE),median(VALUE),sum(VALUE),max(VALUE),min(VALUE),count(VALUE),VAR_POP(VALUE) from ",table_name, " where KEY='",k,"' AND TID='",t,"'",sep = "")

       }
        data <- sqlQuery(odbcConnection, query1)

        data['RESOLUTION']=res
        data['KEY']=k
        data['TID']=t
        data['UID']=uid
        data['NAME']=uid
        print(data)
        sql <- paste("INSERT INTO SPATIAL_SCHEMA.METADATA2  (AVG, MEDIAN, SUM, MAX, MIN,COUNT, VAR_POP, RESOLUTION, KEY, TID, UID, NAME)
                     VALUES(",data$AVG,",",data$MEDIAN,", ",data$SUM,", ",data$MAX,", ",data$MIN,", ",data$COUNT,", ",data$VAR_POP,", ",data$RESOLUTION,", '",data$KEY,"', ",data$TID,", '",data$UID,"', '",data$NAME,"')",sep="")
        print(sql)
        sqlQuery(odbcConnection, sql)
        #data<- cbind(data,list(res,k,t,uid,uid))
      }

    }

    if(!is.na(legend)& !is.na(description)){
      query1 <- paste("delete from SPATIAL_SCHEMA.tablemetadata where UID='",uid,"'",sep = "")
      sqlQuery(odbcConnection, query1)
      sql <- paste("INSERT INTO SPATIAL_SCHEMA.tablemetadata  (UID, LEGEND,DESCRIPTION)
                     VALUES('",uid,"','",legend,"', '",DESCRIPTION,"')",sep="")
      sqlQuery(odbcConnection, sql)
    }


  }else{
    stop("Cannot find any DGGIDs matching with lookup table")
  }
}

