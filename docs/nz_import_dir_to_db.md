# `nz_import_dir_to_db`: import directory

## Description


 Import a directory into database. The directory must have a set of csv files


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
```DSN```     |     The NZ DSN object made by nz_init
```directory```     |     Directory of CSV files
```table_name```     |     Name of the table to import data into
```value_type```     |     The type of Value possible options float, varchar, integer, bigint
```createTable```     |     Either make a new table and drop table if exists or append data to the existing table

## Value


 


## Examples

```   
 nz_import_dir_to_db() 
 ```   