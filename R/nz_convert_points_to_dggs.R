


#' Convert Point to DGGS
#' @description Converts a set of x and y coordinates to DGGS data model.
#' @param lat y coordinates of the points (EPSG:4326)
#' @param lon x coordinates of the points (EPSG:4326)
#' @param tid TID value, A single integer for all data or a list of integer values
#' @param res Resolution of the final dggs cells, a single integer value or a list of integer values
#' @param df A dataframe of keys. The number of rows of this dataframe must be equal to the lat,lon rows
#' @param save_in the directory to store outpur csv files. make sure that this directory exist, you have write permission and engough disc space
#'
#' @return Data are stored in save_in directory The csv files are per each key.
#' @export
#'
#' @examples
#' \dontrun{
#'  r <- read.csv('D:/Bathurst_caribou_collars.csv')
#'  nz_convert_points_df_to_dggs(r$Latitude,r$Latitude,10,20,r,"C:/result")
#' }
nz_convert_points_df_to_dggs <- function(lat,lon,tid,res,df,save_in){


  if(NROW(lat)== NROW(lon) && NROW(lat) == NROW(df)){

    if(NROW(tid)==1){
      tid=rep(tid,length(lat))
    }

    if(NROW(lat)!= NROW(tid)){
      stop("TID can either be an single integer value or a column of integer values with the same lenght of lat")
    }

    dggs= dgconstruct(res=1, metric=FALSE, resround='nearest',pole_lat_deg = 37,pole_lon_deg =-178)

    if(NROW(res)==1){
      dggs <- dgsetres(dggs,res)
      dgid = dgGEO_to_SEQNUM(dggs, lon, lat)$seqnum
    }else{
      dggs= dgconstruct(res=1, metric=FALSE, resround='nearest',pole_lat_deg = 37,pole_lon_deg =-178)

      res_function <- function(lat,lon,res){
        dggs <- dgsetres(dggs,res)
        dgid <- dgGEO_to_SEQNUM(dggs, lon, lat)$seqnum
        dgid
      }

     dgid <- mapply(res_function, lat,lon,res)

    }

    #loop over keys in df and convert them
    for (i in names(df)){

      value <- df[i]

      if (class(df[[i]])=='factor'){
        n_key=paste(i,"__ED",sep="")
      }else{
        n_key=i
      }

      df2 = data.frame(VALUE=value[[i]],DGGID=dgid,TID=tid,KEY=rep(n_key,length(dgid)))
      name=paste(save_in,'\\',n_key,'.csv',sep="")
      write.csv(df2,name, row.names=FALSE)
    }


  }else{

    stop("Number of rows must be the same for lat, lon and df")
  }


}

#' Convert lat,lon, tid, key,value to a dggs data model
#'
#' @param lat y coordinates of the points (EPSG:4326)
#' @param lon x coordinates of the points (EPSG:4326)
#' @param tid TID value, A single integer for all data or a list of integer values
#' @param res Resolution of the final dggs cells, a single integer value or a list of integer values
#' @param df A dataframe of keys. The number of rows of this dataframe must be equal to the lat,lon rows
#' @param save_in the directory to store outpur csv files.make sure that this directory exist, you have write permission and engough disc space
#'
#' @param key a single string as key
#' @param value a list of value with the length equal to the lat
#'
#' @return
#' @export
#'
#' @examples
#' \dontrun{
#' r <- read.csv('D:/Bathurst_caribou_collars.csv')
#' nz_convert_points_key_value_to_dggs(r$Latitude,r$Longitude,100,10,"key",value,"C:/result")
#'}
nz_convert_points_key_value_to_dggs <- function(lat,lon,tid,res,key,value,save_in){
  df3 <- data.frame(value)
  colnames(df3) <- c(key)
  nzdggs:::nz_convert_points_df_to_dggs(lat,lon,tid,res,df3,save_in)
}

nz_convert_points_to_dggs1 <- function(lat,lon,tid,resolution,df){

  res <- rep(seq(1,5),length(lat)/5)
  l <- list(lat,lon,res)
  r <- read.csv('D:\\UserData\\Majid\\Downloads\\Bathurst_caribou_collars.csv')
  lat <- r$Latitude
  long <- r$Longitude
  df <- r

  value <- rep(200,length(r$Latitude))
  if(NROW(lat) == NROW(long) && NROW(lat) == nrow(df)){
    if(NROW(resolution)==1){
      dggs= dgconstruct(res=resolution, metric=FALSE, resround='nearest',pole_lat_deg = 37,pole_lon_deg =-178)
      dgid = dgGEO_to_SEQNUM(dggs,  long,lat)$seqnum
    }else{

      value <- rep(seq(1,5),length(dgid)/5)
      dggs= dgconstruct(res=res, metric=FALSE, resround='nearest',pole_lat_deg = 37,pole_lon_deg =-178)

      calculate <- function(lat, lon, res) {
        dggs <- dgsetres(dggs, res)
        dgid = dgGEO_to_SEQNUM(dggs, lpn,lat)$seqnum
        return(dgid)
      }

      a <- mapply(calculate,lat, long, resolution)
    }


    if(NROW(tid)==1){
      tid=rep(tid,length(dgid))
    }


    for(i in names(df)){
      value <- df[i]
      df2 = data.frame(VALUE=value[[i]],DGGID=dgid,TID=tid,KEY=rep(i,length(dgid)))
      name=paste(i,'.csv',sep="")
      write.csv(df2,name, row.names=FALSE)
    }

  }


}

