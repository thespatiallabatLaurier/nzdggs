# `nz_init`: make nz db object

## Description


 Makes an Netezza db object for the user. Most of functions that need to interact with th
 netezza database need this object as input.


## Usage

```r
nz_init(DSN_NAME, SCHEMA)
```


## Arguments

Argument      |Description
------------- |----------------
```DSN_NAME```     |     The DSN name for connection
```SCHEMA```     |     The database Schema

## Value


 an nz db object


## Examples

```   
 obj <- nz_init("NZSQL","SPATIAL_SCHEMA")
 ```   