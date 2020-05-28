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








