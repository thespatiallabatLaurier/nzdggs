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

    ## # Source:   lazy query [?? x 4]
    ## # Database: NetezzaConnection
    ##     DGGID KEY      VALUE   TID
    ##     <int> <chr>    <dbl> <int>
    ## 1 2282814 MAX_TEMP  34.7  1950
    ## 2 2381896 MAX_TEMP  29.6  1950
    ## 3 2402576 MAX_TEMP  17.9  1950
    ## 4 2313375 MAX_TEMP  30.4  1950
    ## 5 2349335 MAX_TEMP  29.6  1950
    ## 6 2354855 MAX_TEMP  30.6  1950

Next we slice the data set for annual maximum daily precipitation.

    ## # Source:   lazy query [?? x 4]
    ## # Database: NetezzaConnection
    ##     DGGID KEY           VALUE   TID
    ##     <int> <chr>         <dbl> <int>
    ## 1 2431499 PRECIPITATION 24.5   1950
    ## 2 2437499 PRECIPITATION  8.82  1950
    ## 3 2437619 PRECIPITATION  3.45  1950
    ## 4 2330337 PRECIPITATION 18.1   1950
    ## 5 2476699 PRECIPITATION 21.4   1950
    ## 6 2319337 PRECIPITATION 23.3   1950

We will calculate time-series of spatial average

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

We will calculate spatial distribution of temporal average

    ## # Source:   lazy query [?? x 2]
    ## # Database: NetezzaConnection
    ##     DGGID VALUE
    ##     <int> <dbl>
    ## 1 2431499 26.6 
    ## 2 2437499 12.1 
    ## 3 2437619  8.82
    ## 4 2330337 17.2 
    ## 5 2476699 30.1 
    ## 6 2319337 24.8

Let us plot some of these basic variables.

![](./doc/Figure/Time-series%20Plots-1.png)<!-- --> To plot the spatial
variable we need to attach it with the spatial tabls.

    ## # Source:   lazy query [?? x 6]
    ## # Database: NetezzaConnection
    ##        DGGID RESOLUTION  QUAD     I     J GEOM                                  
    ##        <dbl>      <int> <int> <int> <int> <ODBC_bnr>                            
    ## 1    1.38e11         22     5 68030 91962 010100380b834b2a9a5ac04040ce661b9a5ac…
    ## 2    1.38e11         22     5 68029 91960 0101000cc3bad0209a5ac0d8b410ec119a5ac…
    ## 3    1.38e11         22     5 68029 91961 010100a801ff6b2b9a5ac078f354871c9a5ac…
    ## 4    1.38e11         22     5 68027 91960 01010098b32548389a5ac030628663299a5ac…
    ## 5    1.38e11         22     5 68024 91946 010100180b8500c7995ac0b05c461cb8995ac…
    ## 6    1.38e11         22     5 68028 91933 010100543772380e995ac064b27e54ff985ac…

![](./doc/Figure/Spatial%20Plots-1.png)<!-- -->

Lets get a little more complex now. We want to clip the data for one of
the eco-zone over Canada say somwhere over BC, Pacific-Maritime
(ecozone=13)

    ## # Source:   lazy query [?? x 1]
    ## # Database: NetezzaConnection
    ##     DGGID
    ##     <int>
    ## 1 2215062
    ## 2 2222328
    ## 3 2217976
    ## 4 2221608
    ## 5 2217255
    ## 6 2225976

    ## # Source:   lazy query [?? x 4]
    ## # Database: NetezzaConnection
    ##     DGGID KEY           VALUE   TID
    ##     <int> <chr>         <dbl> <int>
    ## 1 2255227 PRECIPITATION  26.8  1950
    ## 2 2255227 PRECIPITATION  26.8  1950
    ## 3 2258867 PRECIPITATION  22.3  1950
    ## 4 2258867 PRECIPITATION  22.3  1950
    ## 5 2239187 PRECIPITATION  23.0  1950
    ## 6 2242107 PRECIPITATION  23.0  1950
