library(rgdal)
library(raster)
library(rgeos)
library(sp)
library(dggridR)



setwd("F:/Chiranjib/DGGS_Conversion/DGGS_Conversion")
# 
# dem=raster("GRAD_DEM_UTM17N.tif")
# slope=raster("GRAD_DEM_UTM17N_slope.tif")
# n=raster("LULC_manningsN.tif")
# hand=raster("Hand_17N.tif")

r=23
dggs= dgconstruct(res=r, metric=FALSE, resround='nearest',pole_lat_deg = 37,pole_lon_deg =-178)
info=dggetres(dggs)
sampsize=info[r+1,]$spacing_km*1e-2*0.8
# 
# catch = readOGR("catch.shp")
# 
# for (i in 1:length(catch)){
# 
#   samp_points = spsample(catch[i,], cellsize = sampsize,type="hexagonal")
#   seqnum = dgGEO_to_SEQNUM(dggs,samp_points@coords[,1], samp_points@coords[,2])$seqnum
#   useqnum=unique(seqnum)
# 
#   data=data.frame(DGGID=useqnum,CATID=rep(catch[i,]$cat_id,length(useqnum)))
#   name=paste('./Catchment/',catch[i,]$cat_id,'.csv',sep="")
#   write.csv(data,name)
# 
# }


dem=raster("GRAD_DEM_UTM17N.tif")
slope=raster("GRAD_DEM_UTM17N_slope.tif")
n=raster("LULC_manningsN.tif")
hand=raster("Hand_17N.tif")

rast=n
rast = projectRaster(rast, crs = CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"))

ind=which(!is.na(rast[]))
xy = xyFromCell(rast, ind, spatial=FALSE)
z=rast[ind]
df = data.frame(VALUE=z)


df$DGGID = dgGEO_to_SEQNUM(dggs, xy[,1], xy[,2])$seqnum

df=aggregate(x=df, by=list(df$DGGID) , FUN='mean',simplify = TRUE, drop = TRUE)

name=paste('N.csv',sep="")
write.csv(df,name)



