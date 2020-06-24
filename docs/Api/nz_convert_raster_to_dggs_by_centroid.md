# `nz_convert_raster_to_dggs_by_centroid`: Raster to dggs

## Description


 Convert Raster object to dggs by centroids. You have to save csv file by yourself.Like using which write.csv(df2,name,sep=';', row.names=FALSE,)


## Usage

```r
nz_convert_raster_to_dggs_by_centroid(rast, centroids, key, tid)
```


## Arguments

Argument      |Description
------------- |----------------
```rast```     |     Raster Object exported from Raster package
```centroids```     |     centroids dg made by nz_make_centroids_df_from_csv function
```key```     |     key
```tid```     |     tid value

## Value


 A dataframe object


