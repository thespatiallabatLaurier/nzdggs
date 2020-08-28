# `nz_add_metadata`: Add metadata

## Description


 Add metadata for the table


## Usage

```r
nz_add_metadata(DSN, table_name, description = NA, legend = NA)
```


## Arguments

Argument      |Description
------------- |----------------
```DSN```     |     DSN object extracted from nz_init
```table_name```     |     name of the table
```description```     |     table description. if you put it NA it will not update description and legend.
```legend```     |     legend of the layer.

## Value


 


## Examples

```r
DSN <- nz_init("NZSQLF","SPATIAL_SCHEMA")
nz_add_metadata(DSN,"NLULCDATA")
```