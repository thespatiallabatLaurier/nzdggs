# Load RJDBC library
#library(RODBC)

library(dplyr)
library(dggridR)


library(rgeos)
library(rgdal)
library(raster)

library(sf)
library(sp)

library(SpaDES)

library(parallel)
library(foreach)
library(doSNOW)

###############################################################


setwd('F:/DGG/Bio/Tsue_GIS')

# ####################odbc connect#############################
# channel=odbcConnect("NZSQL_C", uid="thespatiallab", pwd="Seymour29")
# cmd="drop table gridint if exists; create table DEM22 (DGGID bigint, VALUE DECIMAL)"
# sqlQuery(channel,cmd)
# cmd="drop table DEM22tmp if exists;"
# sqlQuery(channel,cmd)
############################saving raster###################################
rast=raster("Dem.tif")
path=paste('F:/DGG/Bio/Tsue_GIS')

ncpu=detectCores()
cl=makeCluster(ncpu-1)
registerDoSNOW(cl)
rlist=splitRaster(rast, nx=50, ny=50, 0,buffer = c(2, 2), path=path,cl=cl)

#rast = projectRaster(rast, crs = "+proj=longlat +ellps=GRS80 +units=m +datum=WGS84")
dggs= dgconstruct(res=22, metric=FALSE, resround='nearest',pole_lat_deg = 37,pole_lon_deg =-178)




clusterEvalQ(cl, library(dggridR)) 
clusterEvalQ(cl, library(raster))

foreach (i=1:2500) %dopar% {
#for (i in 1:100){
ind=which(!is.na(rlist[[i]][]))

if (length(ind)>0){
xy = xyFromCell(rlist[[i]], ind, spatial=FALSE)
z=rlist[[i]][ind]
df = data.frame(VALUE=z)


df$dggid = dgGEO_to_SEQNUM(dggs, xy[,1], xy[,2])$seqnum

data=aggregate.data.frame(df, by=list(df$dggid),mean)

data$Group.1=NULL

name=paste(path,'/RAST_22_',i,'.csv',sep="")
write.csv(data,name,sep=';', row.names=FALSE)

# cmd=paste("drop table tmptable if exists; drop table DEM22tmp if exists; create external table tmptable(DGGID numeric, VALUE numeric) using(dataobject('",name,"') REMOTESOURCE 'odbc' DELIMITER ',' SKIPROWS 1 MAXERRORS 1000 LOGDIR 'F:/DGG/Bio/Tsue_GIS/Log';create table DEM22tmp as select * from tmptable;",sept="")
# sqlQuery(channel,cmd)

}
print (i)
}
stopCluster(cl)


# ############################saving to sql###################################
# odbcConnection=odbcConnect("NZSQL", uid="admin", pwd="password")
# listoftables=sqlTables(odbcConnection)
# print(listoftables)
# 
# 
# 
# fname='Flowline.shp'
# 
# cgrid=readOGR(fname)
# 
# for (i in 1:lengt  cmd=paste("SELECT DGGID,I,J,inza..ST_AsText(geom) as geom from SPATIAL_DB.SPATIAL_SCHEMA.16 WHERE RESOLUTION=16 and inza..ST_INTERSECTS(geom, inza..ST_WKTToSQL(",c,"))=TRUE",sep="")
# h(cgrid)){
#   c=writeWKT(cgrid[i,])
#   cmd=paste("SELECT DGGID,I,J,inza..ST_AsText(geom) as geom from SPATIAL_DB.SPATIAL_SCHEMA.16 WHERE RESOLUTION=16 and inza..ST_INTERSECTS(geom, inza..ST_WKTToSQL())=TRUE",sep="")
#   
#   #cmd=paste('INSERT INTO DGG_GRID (RESOLUTION,DGG_ID,QUAD,I,J,DGG_WKT) VALUES (',r,',',GRID[i,]@polygons[[1]]@ID[[1]],',',DI$quad,',',DI$i,',',DI$j,',',wkt,')',sep="")
#   sqlQuery(odbcConnection,cmd)
#   
# }


n=10

d=0
for (i in 1:(n-1)){
  
  d=d+3^i
}


d=2*(3^n-d)

print(d)





