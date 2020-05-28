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
  SaveIn
)
```


## Arguments

Argument      |Description
------------- |----------------
```SpatialPolygonsDataFrame```     |     a SpatialPolygonsDataFrame Object. SRC of input file must be EPSG:4326
```Resolution```     |     the resolution of DGGS. An integer value. Higher values for large polygons takes long times to run
```TID```     |     TID value, an integer value exported from nz_convert_datetim_to_tid function
```PolygonID```     |     The unique id of polygon. it is only used to store csv file with a unique name to avoid csv overwrite
```SaveIn```     |     the directory to store csv files

## Value


 


## Examples

```   
 list("\n", "zones = readOGR(\"ecozones.shp\")\n", "for(i in seq(1,length(zones))){\n", "  print(i)\n", "  z = zones[i,]\n", "  nz_convert_polygon_to_dggs(z,1,12,i,'D:/UserData/Majid/Desktop/PLOTS/')\n", "}\n") 
 ```   