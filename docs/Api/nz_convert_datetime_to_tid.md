# `nz_convert_datetime_to_tid`: Convert Datetime To Tid

## Description


 Converts a data and time object to tid. Use this function to make a datatime object `strptime( '02-01-1980 00:00:00', "%d-%m-%Y %H:%M:%S")` 


## Usage

```r
nz_convert_datetime_to_tid(datetime, scale)
```


## Arguments

Argument      |Description
------------- |----------------
```datetime```     |     a date and time value in string format like '2016-01-02 00:00:00'. It must be between "1000-01-01 00:00:00" and "3000-01-01 00:00:00"
```scale```     |     the scale for TID. Must be one the following items '1000y','500y','100y','50y','10y','1y','m','w','d','12h','6h','3h','h','min','s'

## Value


 TID in an Integer format


## Examples

```r
convert_datetime_to_tid(strptime( '02-01-1980 00:00:00', "%d-%m-%Y %H:%M:%S"),'1y')
#Another Example
start <- as.Date("01-01-1980",format="%d-%m-%Y")
end   <- as.Date("01-01-2020",format="%d-%m-%Y")
theDate <- startdf <- data.frame()names(df) <- c("time","tid") 
while (theDate <= end) {   
    t <- strptime(paste(format(theDate,"%d-%m-%Y")," 00:00:00"), "%d-%m-%Y %H:%M:%S")    
    tid <- convert_datetime_to_tid(t, "d") 
    print(tid)    
    df <- rbind(df, data.frame(time = t, tid = tid))    
    theDate <- seq.Date( theDate, length=2, by='1 years' )[2] 
}

```