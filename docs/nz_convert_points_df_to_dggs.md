# `nz_convert_points_df_to_dggs`: Convert Point to DGGS

## Description


 Converts a set of x and y coordinates to DGGS data model.


## Usage

```r
nz_convert_points_df_to_dggs(lat, lon, tid, res, df, save_in)
```


## Arguments

Argument      |Description
------------- |----------------
```lat```     |     y coordinates of the points (EPSG:4326)
```lon```     |     x coordinates of the points (EPSG:4326)
```tid```     |     TID value, A single integer for all data or a list of integer values
```res```     |     Resolution of the final dggs cells, a single integer value or a list of integer values
```df```     |     A dataframe of keys. The number of rows of this dataframe must be equal to the lat,lon rows
```save_in```     |     the directory to store outpur csv files. make sure that this directory exist, you have write permission and engough disc space

## Value


 Data are stored in save_in directory The csv files are per each key.


## Examples

```   
 list("\n", " r <- read.csv('D:/Bathurst_caribou_collars.csv')\n", " nz_convert_points_df_to_dggs(r$Latitude,r$Latitude,10,20,r,\"C:/result\")\n") 
 ```   