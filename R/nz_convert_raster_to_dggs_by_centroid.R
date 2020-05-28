#' Raster to dggs
#' @description Convert Raster object to dggs by centroids. You have to save csv file by yourself.Like using which write.csv(df2,name,sep=';', row.names=FALSE,)
#' @param centroids centroids dg made by nz_make_centroids_df_from_csv function
#' @param key key
#' @param tid tid value
#' @param rast Raster Object exported from Raster package
#'
#' @return A dataframe object
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
