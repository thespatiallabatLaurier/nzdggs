
Converting a Polygon shape file to DGGS datamodel using sampling.

```r
setwd('D:/UserData/PLOTS')
zones = readOGR("ecozones.shp")
for(i in seq(1,24)){
  print(i)
  z = zones[i,]
  nz_convert_polygon_to_dggs(z,12,12,i,'D:/UserData/Majid/upload')
}

#import data to db under Admin schema
dsn <- nz_init("NZSQLF","ADMIN")

nz_import_dir_to_db(dsn,"D:/UserData/Majid/Desktop/PLOTS/upload/","ECOZONE",'varchar(100)',T)
```

# another example
```r
library("nzdggs")
library("stampr")
data(mpb)
mpb$dt <- Sys.Date()
mpb$YR <- mpb$TGROUP+1996
mpb$dt <- as.Date(paste(mpb$YR, '-01-01', sep=""), "%Y-%m-%d")
mpb$tid <- nz_convert_datetime_to_tid(mpb$dt, '1y')
proj4string(mpb) <- '+proj=aea +lat_1=50 +lat_2=58.5 +lat_0=45 +lon_0=-126 +x_0=1000000 +y_0=0 +ellps=GRS80 +datum=NAD83 +units=m +no_defs'
mpb <- spTransform(mpb, CRS("+init=epsg:4326"))
mpb <- mpb[,c(1,6)]
for(i in seq(1,length(mpb))){
  z = mpb[i,]
  nz_convert_polygon_to_dggs(z,20,z$tid,z$ID,"E:\\home\\crobertson\\")
}

DSN <- nz_init("NZSQL_F","SPATIAL_SCHEMA")
nz_import_file_to_db(DSN,"E:/home/crobertson/cmb/cmb.csv","mpb","double",T,max_errors= 4400)
```