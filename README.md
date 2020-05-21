[![Build Status](https://travis-ci.com/am2222/nzdggs.svg?branch=master)](https://travis-ci.com/am2222/nzdggs)
# Nzdggs
Manipulate and Run Analysis on Netezza Using IDEAS Model

# Install

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
    year <- year + 1
    create_table <-F
  }
  
 
}


```



# Development
```
install.packages("devtools")
library("devtools")
devtools::install_github("klutometis/roxygen")
library(roxygen2)
setwd("..\")
#create("Nzdggs")
devtools::document()


```
