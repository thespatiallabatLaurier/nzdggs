Integrated Discrete Environmental Analytics System
================
Chiranjib Chaudhuri
2020-07-01

## GitHub Documents

This document explains the analytic capabilities of the IDEAS data
model.

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

    ## Linking to GEOS 3.8.0, GDAL 2.5.0, PROJ 6.3.0

We connect to a table containing spatial-time series of annual extreme
daily climate variables for entire Canada.

``` r
data=tbl(con,"ANUSPLINE3")
head(data)
```

    ## # Source:   lazy query [?? x 4]
    ## # Database: NetezzaConnection
    ##     DGGID KEY      VALUE   TID
    ##     <int> <chr>    <dbl> <int>
    ## 1 2420704 MAX_TEMP  20.4  1950
    ## 2 2374744 MAX_TEMP  23.5  1950
    ## 3 2360784 MAX_TEMP  27.0  1950
    ## 4 2364464 MAX_TEMP  25.6  1950
    ## 5 2311463 MAX_TEMP  30.7  1950
    ## 6 2381424 MAX_TEMP  20.5  1950

Next we slice the data set for annual maximum daily precipitation.

``` r
datap=data%>%filter(KEY=='PRECIPITATION')
head(datap)
```

    ## # Source:   lazy query [?? x 4]
    ## # Database: NetezzaConnection
    ##     DGGID KEY           VALUE   TID
    ##     <int> <chr>         <dbl> <int>
    ## 1 2297589 PRECIPITATION  7.00  1950
    ## 2 2473831 PRECIPITATION 18.1   1950
    ## 3 2393550 PRECIPITATION 24.5   1950
    ## 4 2479111 PRECIPITATION  5.10  1950
    ## 5 2417910 PRECIPITATION  5.45  1950
    ## 6 2493712 PRECIPITATION 11.5   1950

We will calculate time-series of spatial average

``` r
avgs=datap%>%group_by(TID)%>%arrange(TID)%>%summarise(VALUE=mean(VALUE))
head(avgs)
```

    ## Warning: Missing values are always removed in SQL.
    ## Use `mean(x, na.rm = TRUE)` to silence this warning
    ## This warning is displayed only once per session.

    ## # Source:   lazy query [?? x 2]
    ## # Database: NetezzaConnection
    ##     TID VALUE
    ##   <int> <dbl>
    ## 1  1950  17.7
    ## 2  1951  18.0
    ## 3  1952  19.6
    ## 4  1953  20.9
    ## 5  1954  21.1
    ## 6  1955  20.1

We will calculate spatial distribution of temporal
average

``` r
avgt=datap%>%group_by(DGGID)%>%arrange(DGGID)%>%summarise(VALUE=mean(VALUE))
head(avgt)
```

    ## # Source:   lazy query [?? x 2]
    ## # Database: NetezzaConnection
    ##     DGGID VALUE
    ##     <int> <dbl>
    ## 1 2460666  26.7
    ## 2 2277703  27.6
    ## 3 2414025  24.7
    ## 4 2481826  26.2
    ## 5 2266103  34.0
    ## 6 2292943  40.3

Let us plot some of these basic variables.

``` r
avgs=collect(avgs)
plot(avgs$TID,avgs$VALUE)
```

![](./doc/Figure/Time-series%20Plots-1.png)<!-- --> To plot the spatial
variable we need to attach it with the spatial tabls.

``` r
grid=tbl(con,"FINALGRID2")
head(grid)
```

    ## # Source:   lazy query [?? x 6]
    ## # Database: NetezzaConnection
    ##        DGGID RESOLUTION  QUAD     I     J GEOM                                  
    ##        <dbl>      <int> <int> <int> <int> <ODBC_bnr>                            
    ## 1    1.38e11         22     5 68729 95619 010100f0e599f2bc145bc06412aaabad145bc…
    ## 2    1.38e11         22     5 68733 95613 010100b495fa264b145bc0ec7e15e03b145bc…
    ## 3    1.38e11         22     5 68732 95610 0101009cc6accd35145bc02ce6e78626145bc…
    ## 4    1.38e11         22     5 68733 95597 01010068a8401c9a135bc0a434bcd58a135bc…
    ## 5    1.38e11         22     5 68726 95603 0101008cd03a702f145bc000a0ab2920145bc…
    ## 6    1.38e11         22     5 68728 95595 01010004a6fc39bf135bc0986898f3af135bc…

``` r
avgt=avgt%>%inner_join(grid,by=c('DGGID'))%>%mutate(WKT=inza..ST_AsText(GEOM))%>%
  select(DGGID,VALUE,WKT)%>%arrange(DGGID)%>%head(100)%>%collect()

poly=st_as_sf(avgt, wkt='WKT', crs = 4326)
plot(poly['VALUE'])
```

![](./doc/Figure/Spatial%20Plots-1.png)<!-- -->

Lets get a little more complex now. We want to clip the data for one of
the eco-zone over Canada say somwhere over BC, Pacific-Maritime
(ecozone=13)

``` r
ecozone=tbl(con,"ECOZONE_12")%>%filter(VALUE==13)%>%select(DGGID)
head(ecozone)
```

    ## # Source:   lazy query [?? x 1]
    ## # Database: NetezzaConnection
    ##     DGGID
    ##     <int>
    ## 1 2290293
    ## 2 2290292
    ## 3 2212852
    ## 4 2213587
    ## 5 2214331
    ## 6 2216513

``` r
datape=datap%>%inner_join(ecozone,by=c('DGGID'))
head(datape)
```

    ## # Source:   lazy query [?? x 4]
    ## # Database: NetezzaConnection
    ##     DGGID KEY           VALUE   TID
    ##     <int> <chr>         <dbl> <int>
    ## 1 2222341 PRECIPITATION  89.3  1950
    ## 2 2222341 PRECIPITATION  89.3  1950
    ## 3 2231102 PRECIPITATION  34.2  1950
    ## 4 2231102 PRECIPITATION  34.2  1950
    ## 5 2233302 PRECIPITATION  25.0  1950
    ## 6 2233302 PRECIPITATION  25.0  1950
