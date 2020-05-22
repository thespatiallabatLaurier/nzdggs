# `nz_make_centroids_df_from_csv`: Generate Centroid dataframe

## Description


 Generate Centroid dataframe


## Usage

```r
nz_make_centroids_df_from_csv(csvpath)
```


## Arguments

Argument      |Description
------------- |----------------
```csvpath```     |     input csv file with the following columns "DGGID","X","Y" to reproject data you can use coord2=spTransform(coord2,CRS("+proj=laea +lon_0=0 +lat_0=90 +x_0=0 +y_0=0 +a=6378137 +rf=298.257223563"))

## Value


 an object with the df parameter which is a df object of csv and a coords parameter
 which is an spatial dataframe object


## Examples

```r 
 
 ``` 

