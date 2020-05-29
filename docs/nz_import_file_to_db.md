# `nz_import_file_to_db`: Import a file to db

## Description


 Import a single csv file to the netezza database. CSV columns must be as with following format "VALUE","DGGID","TID","KEY"


## Usage

```r
nz_import_file_to_db(
  DSN,
  file_path,
  table_name,
  value_type = "varchar",
  createTable = T,
  max_errors = 2
)
```


## Arguments

Argument      |Description
------------- |----------------
```DSN```     |     object extracted from nz_init function
```file_path```     |     the csv file path with following format "VALUE","DGGID","TID","KEY"
```value_type```     |     The type of Value possible options float, varchar, integer, bigint
```createTable```     |     Either make a new table and drop table if exists or append data to the existing table
```max_errors```     |     The maximumn number of rows in the csv which can include error in their values

## Value


 


