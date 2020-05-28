
#' Convert Polygon to DGGS
#' @description Converts a single polygon feature to a dggs data model and stores the results as csv files.
#' This function loops over attributes and stores each attributes data as well.
#' @param SpatialPolygonsDataFrame a SpatialPolygonsDataFrame Object. SRC of input file must be EPSG:4326
#' @param Resolution the resolution of DGGS. An integer value. Higher values for large polygons takes long
#' times to run
#' @param TID TID value, an integer value exported from nz_convert_datetim_to_tid function
#' @param PolygonID The unique id of polygon. it is only used to store csv file with a unique name to avoid csv overwrite
#' @param SaveIn the directory to store csv files
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
#' }
nz_convert_polygon_to_dggs <- function(SpatialPolygonsDataFrame, Resolution,TID,PolygonID,SaveIn){

  dggs= dggridR::dgconstruct(res=Resolution, metric=FALSE, resround='nearest',pole_lat_deg = 37,pole_lon_deg =-178)
  info= dggridR::dggetres(dggs)
  sampsize=(info[Resolution+1,]$spacing_km*1e-2)*0.5


  samp_points = sp::spsample(SpatialPolygonsDataFrame, cellsize = sampsize,type="hexagonal",offset=c(0.5,0.5))
  seqnum = dggridR::dgGEO_to_SEQNUM(dggs,samp_points@coords[,1], samp_points@coords[,2])$seqnum
  iuseqnum=base::unique(seqnum)

  ring=as(SpatialPolygonsDataFrame, "SpatialLinesDataFrame")
  n=gLength(ring)/sampsize
  samp_points = sp::spsample(ring, n=n, type = "regular",offset=c(0.5))
  seqnum = dggridR::dgGEO_to_SEQNUM(dggs,samp_points@coords[,1], samp_points@coords[,2])$seqnum
  buseqnum=base::unique(seqnum)

  dggid=c(iuseqnum,buseqnum)
  udggid=base::unique(dggid)
  #"VALUE","DGGID","TID","KEY"

  b=data.frame(VALUE=rep(0,length(udggid)),DGGID=udggid,TID=rep(TID,length(udggid)),KEY="BOUNDARY")
  b[udggid %in% buseqnum,1]=1

  print("Saving Boundary Key")
  name=paste(SaveIn,'\\',PolygonID,'_boundary','.csv',sep="")
  write.csv(b,name, row.names=FALSE)


  for (n in names(SpatialPolygonsDataFrame)){
    print(paste("Saving ",n," Key"))

    df2 = data.frame(VALUE=rep(SpatialPolygonsDataFrame[[n]],length(udggid)),DGGID=udggid,TID=rep(TID,length(udggid)),KEY=rep(n,length(udggid)))
    name=paste(SaveIn,'\\',PolygonID,"_",n,'.csv',sep="")
    write.csv(df2,name, row.names=FALSE)
  }

}
