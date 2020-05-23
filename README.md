[![Build Status](https://travis-ci.com/am2222/nzdggs.svg?branch=master)](https://travis-ci.com/am2222/nzdggs) [![Documentation Status](https://readthedocs.org/projects/nzdggs/badge/?version=latest)](https://nzdggs.readthedocs.io/en/latest/?badge=latest)


# Nzdggs
Manipulate and Run Analysis on Netezza Using IDEAS Model

#Documentations


```
https://rdrr.io/github/am2222/nzdggs/
https://nzdggs.readthedocs.io/en/latest/
```

#Install

```
devtools::install_github("am2222/nzdggs")

```

#Examples

Importing `.nc` files into db using centroids of resolution 9 

```
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

```
r <- read.csv('D:/Bathurst_caribou_collars.csv')
nz_convert_points_df_to_dggs(r$Latitude,r$Latitude,10,20,r,"C:/result")

```


# Development
```
install.packages("devtools")
library("devtools")
devtools::install_github("klutometis/roxygen")
library(roxygen2)
setwd("..\")
devtools::document()

#makedocs documentation
library(stringr)
files <- dir("E:/Personal/Lab/pkg/nzdggs/man/", pattern ="*.Rd")

lapply(files, function(x) {
  outfile = paste("E:/Personal/Lab/pkg/nzdggs/docs/",str_replace(x, ".Rd", ".md"),sep = "/")
  rdfile = paste("E:/Personal/Lab/pkg/nzdggs/man/",x,sep = "/")
  Rd2md::Rd2markdown(rdfile = rdfile, outfile = outfile)
  })


```
