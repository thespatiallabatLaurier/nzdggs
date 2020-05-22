# `nz_import_file_to_db`: Title

## Description


 Title


## Usage

```r
nz_import_file_to_db(
  DSN,
  file_path,
  table_name,
  value_type = "varchar",
  createTable = T
)
```


## Arguments

Argument      |Description
------------- |----------------
```file_path```     |     the csv file path with following format "VALUE","DGGID","TID","KEY"
```value_type```     |     The type of Value possible options float, varchar, integer, bigint
```createTable```     |     Either make a new table and drop table if exists or make table

## Value


 


