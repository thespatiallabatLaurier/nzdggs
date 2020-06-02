# `nz_table_as_dplyr`: Netezza Table To dplyr

## Description


 Netezza Table To dplyr


## Usage

```r
nz_table_as_dplyr(DSN, tableName)
```


## Arguments

Argument      |Description
------------- |----------------
```DSN```     |     DSN object extracted from nz_init function
```tableName```     |     the name of the table to read

## Value


 A dplyr object


## Examples

```   
list("", "DSN <- nz_init(\"NZSQL_F\",\"ADMIN\")\n", "mbp <- nz_table_as_dplyr(DSN,\"MPB\")\n", "head(mbp)\n")

 ```   