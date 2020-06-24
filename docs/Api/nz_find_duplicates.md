# `nz_find_duplicates`: Find duplicates

## Description


 Find duplicate cells in a table. If the returned dataframe is empty it does not have any duplicate cells.


## Usage

```r
nz_find_duplicates(DSN, table, limit = T)
```


## Arguments

Argument      |Description
------------- |----------------
```DSN```     |     Nz information object
```table```     |     table name in format of
```limit```     |     Whether to show all the duplicates or only show 100 result. It can cause performance issue on large tables if you set it to FALSE. Default is TRUE

## Value


 a sqlQuery object


