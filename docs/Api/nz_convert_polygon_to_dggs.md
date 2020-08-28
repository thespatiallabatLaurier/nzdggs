# `nz_convert_polygon_to_dggs`: Convert Polygon to DGGS

## Description


 Converts a single polygon feature to a dggs data model and stores the results as csv files.
 This function loops over attributes and stores each attributes data as well.


## Usage

```r
nz_convert_polygon_to_dggs(
  SpatialPolygonsDataFrame,
  Resolution,
  TID,
  PolygonID,
  SaveIn,
  convertKeys = "all"
)
```


## Arguments

Argument      |Description
------------- |----------------
```SpatialPolygonsDataFrame```     |     a SpatialPolygonsDataFrame Object. SRC of input file must be EPSG:4326
```Resolution```     |     the resolution of DGGS. An integer value. Higher values for large polygons takes long times to run
```TID```     |     TID value, an integer value exported from nz_convert_datetim_to_tid function
```PolygonID```     |     The unique id of polygon. it is only used to store csv file with a unique name to avoid csv overwrite
```SaveIn```     |     the directory to store csv files. It Must end with /
```convertKeys```     |     Keys that are supposed to be converted. all means converting all the keys. NA means does not convert any keys.Use a vector of column names to only convert specific keys

## Value


 


## Examples

```r

zones = readOGR("ecozones.shp")\n", "for(i in seq(1,length(zones)))
i= 1
  
  print(i)
  z = zones[i,]
  nz_convert_polygon_to_dggs(z,1,12,i,'D:/UserData/Majid/Desktop/PLOTS/')

  library("nzdggs")
  library("stampr")
  data(mpb)
  mpb$dt <- Sys.Date()\n", "mpb$YR <- mpb$TGROUP+1996
  mpb$dt <- as.Date(paste(mpb$YR, '-01-01', sep=""), "%Y-%m-%d")
  mpb$tid <- nz_convert_datetime_to_tid(mpb$dt, '1y')
  proj4string(mpb) <- '+proj=aea +lat_1=50 +lat_2=58.5 +lat_0=45 +lon_0=-126 +x_0=1000000 +y_0=0 +ellps=GRS80 +datum=NAD83 +units=m +no_defs'
  mpb <- spTransform(mpb, CRS("+init=epsg:4326")
  mpb <- mpb[,c(1,6)]
  for(i in seq(1,length(mpb))){
  z = mpb[i,]
    nz_convert_polygon_to_dggs(z,20,z$tid,z$ID,"E:\\\\home\\\\crobertson\\\\")
  }

  DSN <- nz_init("NZSQL","SPATIAL_SCHEMA")
  nz_import_file_to_db(DSN,"E:/home/majid/cmb/cmb.csv","mpb","double",T,max_errors= 4400)
```