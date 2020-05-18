convert_raster_to_dggs_by_centroids <- function(path,centroids_csv,tid){

  if(file.exists(path)){

  }else{
    print('Input file in not valid')
  }

}

convert_raster_to_dggs_by_sampling1 <- function(path,resolution,tid){

  if(file.exists(path)){

  }else{
    print('Input file in not valid')
  }

}


#' Title
#'
#' @param centroids centroids dg made by nz_make_centroids_df_from_csv function
#' @param key key
#' @param tid tid value
#' @param rast Raster Object exported from Raster package
#'
#' @return a df which can be stored using   write.csv(df2,name,sep=';', row.names=FALSE,)
#' @export
#'
#' @examples
nz_convert_raster_to_dggs_by_centroid <- function(rast,centroids,key,tid){

  ind=cellFromXY(rast,centroids$coords)
  z=rast[ind]
  flag=(!is.na(z))
  r=z[flag]
  dgid=centroids$df$DGGID[flag]

  df2 = data.frame(VALUE=r,DGGID=dgid,TID=rep(tid,length(dgid)),KEY=rep(key,length(dgid)))
  #n <- paste(key,tid,sep="_")
  #name=paste(outputpath,n,'.csv',sep="")
  #print(name)
  return(df2)
}

#' Title
#'
#' @param csvpath input csv file with the following columns "DGGID","X","Y"
#' to reproject data you can use coord2=spTransform(coord2,CRS("+proj=laea +lon_0=0 +lat_0=90 +x_0=0 +y_0=0 +a=6378137 +rf=298.257223563"))
#' @return an object with the df parameter which is a df object of csv and a coords parameter
#' which is an spatial dataframe object
#' @export
#'
#' @examples
#'
nz_make_centroids_df_from_csv <- function(csvpath){

  df <- read.table(csvpath, header = FALSE,sep = ",",col.names=c("DGGID","X","Y"))
  coord_matrix_x<-as.numeric(as.matrix(df$X))
  coord_matrix_y<-as.numeric(as.matrix(df$Y))
  coord2 <- cbind(coord_matrix_x, coord_matrix_y)
  coord2<-as.data.frame(coord2)
  coordinates(coord2)<-c("coord_matrix_x","coord_matrix_y")
  crs(coord2)= "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"
  my_list <- list("df" = df, "coords" = coord2)
  return(my_list)
}

convert_raster_to_dggs_by_sampling <- function(resolution,raster_path,tid,key){

  if(file.exists(raster_path)){

    dir=dirname(raster_path)

    dggs= dgconstruct(res=resolution, metric=FALSE, resround='nearest',pole_lat_deg = 37,pole_lon_deg =-178)
    info=dggetres(dggs)
    sampsize=info[resolution+1,]$spacing_km*1e-2*0.8

    rast=raster(raster_path)

    if (! identical(proj4string(rast), "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0") ) {
      stop(paste("The imput raster must be in EPSG:4326 projection", "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0","rast = projectRaster(rast, crs = CRS('+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs'))"))
    }

    ind=which(!is.na(rast[]))

    xy = xyFromCell(rast, ind, spatial=FALSE)

    z=rast[ind]
    df = data.frame(VALUE=z)

    df$DGGID = dgGEO_to_SEQNUM(dggs, xy[,1], xy[,2])$seqnum
    df=aggregate(x=df, by=list(df$DGGID) , FUN='mean',simplify = TRUE, drop = TRUE)

    df <- df[c("DGGID","VALUE")]

    df$TID <- tid
    df$KEY <- key

    dir.create(paste(dir,"//csv",sep=""), showWarnings = TRUE, recursive = FALSE, mode = "0777")
    name=paste(dir,"//csv//result.csv",sep="")
    write.csv(df,name,row.names=F)
    return(df)
  }else{
    print('Input file in not valid')
  }




}


convert_shp_to_dggs <- function(){

}



