# `nz_dplyr_to_netezza`: dplyr to Netezza table

## Description


 Save a dplyr object as netezza table. It can drop table when it already exists.


## Usage

```r
nz_dplyr_to_netezza(DSN, dplyr, outputTable, dropIfExist = F)
```


## Arguments

Argument      |Description
------------- |----------------
```DSN```     |     A DSN object exported from nz_init function
```dplyr```     |     a dplyr object
```outputTable```     |     name of the output table to store data
```dropIfExist```     |     Drop if the outputTable does exist. Default is False. Use it with cautious since it removes data in the existing outputTable permanently

## Value


 A dplyr object from outputTable


## Examples

```   
list("", "DSN <- nz_init(\"NZSQL_F\",\"ADMIN\")\n", "mbp <- nz_table_as_dplyr(DSN,\"MPB\")\n", "head(mbp)\n", "mbp2 <- nz_dplyr_to_netezza(DSN,mbp,\"mbp2\")\n", "head(mbp2)\n")
 ```   