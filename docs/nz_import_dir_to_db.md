# `nz_import_dir_to_db`: nz_import_dir_to_db

## Description


 nz_import_dir_to_db


## Usage

```r
nz_import_dir_to_db(
  DSN,
  directory,
  table_name,
  value_type = "varchar",
  createTable = T
)
```


## Arguments

Argument      |Description
------------- |----------------
```DSN```     |     The NZ DSN
```directory```     |     Directory of CSV files
```table_name```     |     Name of the table to import data into
```value_type```     |     The type of Value possible options float, varchar, integer, bigint
```createTable```     |     Either make a new table and drop table if exists or make table

## Value


 


## Examples

```r 
 nz_import_dir_to_db() 
 ``` 

