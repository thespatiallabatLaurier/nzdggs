# `nz_convert_datetime_to_tid`: Title

## Description


 Title


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
 list("\n", "convert_datetime_to_tid(strptime( '02-01-1980 00:00:00', \"%d-%m-%Y %H:%M:%S\"),'1y')\n", "#Another Example\n", "start <- as.Date(\"01-01-1980\",format=\"%d-%m-%Y\")\n", "end   <- as.Date(\"01-01-2020\",format=\"%d-%m-%Y\")\n", "\n", "theDate <- start\n", "df <- data.frame()\n", "names(df) <- c(\"time\",\"tid\")\n", "while (theDate <= end)\n", "{\n", "   t <- strptime(paste(format(theDate,\"%d-%m-%Y\"),\" 00:00:00\"), \"%d-%m-%Y %H:%M:%S\")\n", "   tid <- convert_datetime_to_tid(t, \"d\")\n", 
    "   print(tid)\n", "   df <- rbind(df, data.frame(time = t, tid = tid))\n", "   theDate <- seq.Date( theDate, length=2, by='1 years' )[2]\n", "}\n") 
 ``` 

