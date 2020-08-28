
#' Convert Polygon to DGGS
#' @description Converts a single polygon feature to a dggs data model and stores the results as csv files.
#' This function loops over attributes and stores each attributes data as well.
#'
#' @param SpatialPolygonsDataFrame a SpatialPolygonsDataFrame Object. SRC of input file must be EPSG:4326
#' @param Resolution the resolution of DGGS. An integer value. Higher values for large polygons takes long
#' times to run
#' @param TID TID value, an integer value exported from nz_convert_datetim_to_tid function
#' @param PolygonID The unique id of polygon. it is only used to store csv file with a unique name to avoid csv overwrite
#' @param SaveIn the directory to store csv files. It \strong{Must} end with /
#' @param convertKeys Keys that are supposed to be converted. \strong{all} means converting all the
#' keys. \strong{NA} means does not convert any keys.Use a vector of column names to only convert specific keys
#'
#' @return
#' @export
#'
#' @examples \dontrun{
#' zones = readOGR("ecozones.shp")
#' for(i in seq(1,length(zones))){
#'   print(i)
#'   z = zones[i,]
#'   nz_convert_polygon_to_dggs(z,1,12,i,'D:/UserData/Majid/Desktop/PLOTS/')
#' }
#' library("nzdggs")
#' library("stampr")
#' data(mpb)
#' mpb$dt <- Sys.Date()
#' mpb$YR <- mpb$TGROUP+1996
#' mpb$dt <- as.Date(paste(mpb$YR, '-01-01', sep=""), "%Y-%m-%d")
#' mpb$tid <- nz_convert_datetime_to_tid(mpb$dt, '1y')
#' proj4string(mpb) <- '+proj=aea +lat_1=50 +lat_2=58.5 +lat_0=45 +lon_0=-126 +x_0=1000000 +y_0=0 +ellps=GRS80 +datum=NAD83 +units=m +no_defs'
#' mpb <- spTransform(mpb, CRS("+init=epsg:4326"))
#' mpb <- mpb[,c(1,6)]
#' for(i in seq(1,length(mpb))){
#'   z = mpb[i,]
#'   nz_convert_polygon_to_dggs(z,20,z$tid,z$ID,"E:\\home\\crobertson\\")
#' }
#'
#' DSN <- nz_init("NZSQL","SPATIAL_SCHEMA")
#' nz_import_file_to_db(DSN,"E:/home/majid/cmb/cmb.csv","mpb","double",T,max_errors= 4400)
#' }
nz_convert_polygon_to_dggs <- function(SpatialPolygonsDataFrame, Resolution,TID,PolygonID,SaveIn,convertKeys='all'){

  SaveIn <- paste(SaveIn,"/",sep = "")

  dggs <- dggridR::dgconstruct(res=Resolution, metric=FALSE, resround='nearest',pole_lat_deg = 37,pole_lon_deg =-178)
  info <- dggridR::dggetres(dggs)
  sampsize <- (info[Resolution+1,]$spacing_km*1e-2)*0.5


  samp_points <- sp::spsample(SpatialPolygonsDataFrame, cellsize = sampsize,type="hexagonal",offset=c(0.5,0.5))
  seqnum <- dggridR::dgGEO_to_SEQNUM(dggs,samp_points@coords[,1], samp_points@coords[,2])$seqnum
  iuseqnum <- base::unique(seqnum)

  ring <- as(SpatialPolygonsDataFrame, "SpatialLinesDataFrame")
  n <- gLength(ring)/sampsize
  samp_points <- sp::spsample(ring, n=n, type = "regular",offset=c(0.5))
  seqnum <- dggridR::dgGEO_to_SEQNUM(dggs,samp_points@coords[,1], samp_points@coords[,2])$seqnum
  buseqnum <- base::unique(seqnum)

  dggid <- c(iuseqnum,buseqnum)
  udggid <- base::unique(dggid)
  #"VALUE","DGGID","TID","KEY"

  b <- data.frame(VALUE=rep(0,length(udggid)),DGGID=udggid,TID=rep(TID,length(udggid)),KEY="BOUNDARY")
  b[udggid %in% buseqnum,1] <- 1

  #print("Saving Boundary Key")
  name <- paste(SaveIn,'\\',PolygonID,'_boundary','.csv',sep="")
  write.csv(b,name, row.names=FALSE)
  rm(b)

  if(convertKeys == 'all'){
    keys = names(SpatialPolygonsDataFrame)
  }else if (is.na(convertKeys)){
    keys  <-  c()
  }else{
    keys  <-  intersect(convertKeys,names(SpatialPolygonsDataFrame))
  }

  convert_keys <- function(key) {

    if (class(SpatialPolygonsDataFrame[[key]])=='factor'){
      n_key=paste(key,"__ED",sep="")
    }else{
      n_key=key
    }

    df2 <- data.frame(VALUE=SpatialPolygonsDataFrame[[key]],DGGID=udggid,TID=rep(TID,length(udggid)),KEY=rep(n_key,length(udggid)))
    name<-paste(SaveIn,'\\',PolygonID,"_",n_key,'.csv',sep="")
    write.csv(df2,name, row.names=FALSE)
    rm(df2)
  }

  mapply(convert_keys,keys)

  rm(samp_points,ring,seqnum,buseqnum,udggid,dggid,dggs)


}
