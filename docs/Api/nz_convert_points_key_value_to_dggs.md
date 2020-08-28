# `nz_convert_points_key_value_to_dggs`: Convert lat,lon, tid, key,value to a dggs data model

## Description


 Convert lat,lon, tid, key,value to a dggs data model


## Usage

```r
nz_convert_points_key_value_to_dggs(lat, lon, tid, res, key, value, save_in)
```


## Arguments

Argument      |Description
------------- |----------------
```lat```     |     y coordinates of the points (EPSG:4326)
```lon```     |     x coordinates of the points (EPSG:4326)
```tid```     |     TID value, A single integer for all data or a list of integer values
```res```     |     Resolution of the final dggs cells, a single integer value or a list of integer values
```key```     |     a single string as key
```value```     |     a list of value with the length equal to the lat
```save_in```     |     the directory to store outpur csv files.make sure that this directory exist, you have write permission and engough disc space
```df```     |     A dataframe of keys. The number of rows of this dataframe must be equal to the lat,lon rows

## Value


 


## Examples

```r

r <- read.csv('D:/Bathurst_caribou_collars.csv')
nz_convert_points_key_value_to_dggs(r$Latitude,r$Longitude,100,10,\"key\",value,\"C:/result\")
``` 