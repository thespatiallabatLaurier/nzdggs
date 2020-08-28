# `nz_keylookup_getkeys`: keylookup table keys

## Description


 get the keys in the keylookup table


## Usage

```r
nz_keylookup_getkeys(DSN, table = NA)
```


## Arguments

Argument      |Description
------------- |----------------
```DSN```     |     Nz information object
```table```     |     The teble to get keys from. It can also be NA so it will return entire keylookup table. It only queries keys which ends with **__ED**

## Value


 a sqlQuery object


## Examples

```r
nz_keylookup_getkeys(DSN,table = "TEST_MBPEV")
```