[![Build Status](https://travis-ci.com/am2222/nzdggs.svg?branch=master)](https://travis-ci.com/am2222/nzdggs) [![Documentation Status](https://readthedocs.org/projects/nzdggs/badge/?version=latest)](https://nzdggs.readthedocs.io/en/latest/?badge=latest)


# Nzdggs
Manipulate and Run Analysis on Netezza Using IDEAS Model

# Documentations


```
https://rdrr.io/github/am2222/nzdggs/
https://nzdggs.readthedocs.io/en/latest/
```

# Install

```r
devtools::install_github("am2222/nzdggs")

```

# Examples

Importing `.nc` files into db using centroids of resolution 9 

```r
library(rgdal)
library(raster)
library(rgeos)
library(sp)
library(dggridR)
library(ncdf4)
library(nzdggs)

dir <- "F:\\carbon_emissions_landuse\\"
setwd(dir)

cnt <- nz_make_centroids_df_from_csv("F:\\Converter\\centroids\\res9_centroids.csv")

files=list.files(pattern=".nc")


create_table <- T
for (f in files) {
  rast=raster(f)
  year <- 1850
  for(i in seq(1,156)){
    rast=raster(f, varname = "carbon_emission",band=i)
    tid <- nz_convert_datetime_to_tid(strptime( paste('02-01-',year,' 00:00:00',sep=""), "%d-%m-%Y %H:%M:%S"), '1y')
    
    res_df <- nz_convert_raster_to_dggs_by_centroid(rast,cnt,"carbon_emission",tid)
  
    name=paste(year,'.csv',sep="")
    write.csv(res_df,name, row.names=FALSE)
    print(name)
    nz_import_file_to_db(
      "NZSQL_M",
      paste("F:\\carbon_emissions_landuse\\",name,sep=""),
      "CARBONEMISSIONS",
      value_type = "double",
      createTable = create_table
    )
    file.remove(paste("F:\\carbon_emissions_landuse\\",name,sep=""))
    year <- year + 1
    create_table <-F
  }
  
 
}


```


Converting a csv file of lat,lon points to DGGS data model

```r
r <- read.csv('D:/Bathurst_caribou_collars.csv')
nz_convert_points_df_to_dggs(r$Latitude,r$Latitude,10,20,r,"C:/result")

```

Converting a Polygon shape file to DGGS datamodel using sampling. 

```r
setwd('D:/UserData/PLOTS')
zones = readOGR("ecozones.shp")
for(i in seq(1,24)){
  print(i)
  z = zones[i,]
  nz_convert_polygon_to_dggs(z,12,12,i,'D:/UserData/Majid/upload')
}

#import data to db under Admin schema
dsn <- nz_init("NZSQL_F","ADMIN")

nz_import_dir_to_db(dsn,"D:/UserData/Majid/Desktop/PLOTS/upload/","ECOZONE",'varchar(100)',T)

# another example
library("nzdggs")
library("stampr")
data(mpb)
mpb$dt <- Sys.Date()
mpb$YR <- mpb$TGROUP+1996
mpb$dt <- as.Date(paste(mpb$YR, '-01-01', sep=""), "%Y-%m-%d")
mpb$tid <- nz_convert_datetime_to_tid(mpb$dt, '1y')
proj4string(mpb) <- '+proj=aea +lat_1=50 +lat_2=58.5 +lat_0=45 +lon_0=-126 +x_0=1000000 +y_0=0 +ellps=GRS80 +datum=NAD83 +units=m +no_defs'
mpb <- spTransform(mpb, CRS("+init=epsg:4326"))
mpb <- mpb[,c(1,6)]
for(i in seq(1,length(mpb))){
  z = mpb[i,]
  nz_convert_polygon_to_dggs(z,20,z$tid,z$ID,"E:\\home\\crobertson\\")
}

DSN <- nz_init("NZSQL_F","SPATIAL_SCHEMA")
nz_import_file_to_db(DSN,"E:/home/crobertson/cmb/cmb.csv","mpb","double",T,max_errors= 4400)

```

Converting and importing a csv to the netezza

```r
#Assume we have a csv file with following columns. X,DGGID,EVENT (two keys)
csv<-read.csv2("mpb-ev.csv",sep=",")
head(csv)
  X       DGGID EVENT
1 1 14772025795 CONTR
2 2 14772084845 CONTR
3 3 14772084846 CONTR
4 4 14772143895 CONTR
5 5 14772143896 CONTR
6 6 14772143897 CONTR
#Make a dataframe with following columns. The order of columns are important
df <- data.frame(VALUE=csv$EVENT,DGGID=csv$DGGID,TID=rep(-1,length(csv$DGGID)),KEY=rep("EVENT",length(csv$DGGID)))

#save the dataframe as a csv with row.names=F and seperator ="," . Use write.csv instead of write.csv2
write.csv(df,row.names = F, "import//event.csv",sep=",")

#another dataframe for the second key
df2 <- data.frame(VALUE=csv$X,DGGID=csv$DGGID,TID=rep(-1,length(csv$DGGID)),KEY=rep("ID",length(csv$DGGID)))
#save in the same folder with diffrent name
write.csv(df2,row.names = F,"import//id.csv",sep=",")
#init DSN object for data import. Define SCHEMA based on your user
DSN <- nz_init("NZSQL","SCHEMA")
#impord data from folder to the database. The key type is varchar(100) for multiple keys.
nz_import_dir_to_db(DSN,"/home/[user]/import/","mbpev","varchar(100)")
```



# Development
```
install.packages("devtools")
library("devtools")
devtools::install_github("klutometis/roxygen")
library(roxygen2)
setwd("..\")
devtools::document()
mkdocs gh-deploy
#makedocs documentation
library(stringr)
files <- dir("E:/Personal/Lab/pkg/nzdggs/man/", pattern ="*.Rd")

lapply(files, function(x) {
  outfile = paste("E:/Personal/Lab/pkg/nzdggs/docs/",str_replace(x, ".Rd", ".md"),sep = "/")
  rdfile = paste("E:/Personal/Lab/pkg/nzdggs/man/",x,sep = "/")
  Rd2md::Rd2markdown(rdfile = rdfile, outfile = outfile)
  })


```
