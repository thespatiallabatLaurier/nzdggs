# `nz_convert_df_to_dggs`: dataframe to dggs

## Description


 Converts a dataframe with a DGGID/TID column and set of other columns (keys) to csv
 datasets to be able to import them into netezza. You can import csv files to the database using nz_import_dir_to_db function


## Usage

```r
nz_convert_df_to_dggs(DGGID, TID, df, SaveIn, convertKeys = "all")
```


## Arguments

Argument      |Description
------------- |----------------
```DGGID```     |     A dataframe column containing DGGIDs
```TID```     |     An integer or dataframe column
```df```     |     dataframe with the remaining keys. Remove DGGID/TID columns from it
```SaveIn```     |     The directory path to store data there. It must exist
```convertKeys```     |     Keys that are supposed to be converted. all means converting all the keys. NA means does not convert any keys.Use a vector of column names to only convert specific keys

## Value


 


## Examples

```r

csv<-read.csv2("D:\\UserData\\Majid\\Downloads\\mpb-ev.csv",sep=",")
head(csv)
nz_convert_df_to_dggs(csv$DGGID,-1,csv,"E:\\home\\crobertson")\
#importing to the db
DSN <- nz_init("NZSQLF","SPATIAL_SCHEMA")
nz_import_dir_to_db(DSN,"/home/crobertson/import/","mbpev","varchar(100)")
```
