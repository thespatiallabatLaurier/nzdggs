
library(tidyverse)
library(ggplot2)
library(rgeos)
library(sf)
library(dplyr)
require(gridExtra)
library(dggridR)
library(magrittr)
library(spatialEco)



workdir <- "F:\\Majid\\wildfire\\case study\\"
setwd(workdir)
firePolygons <- readOGR("Landsat Data\\baundaries.shp")



# reading points
df <- read.table("F:\\Majid\\wildfire\\Lookup table\\ltable.csv", header = FALSE,sep = ",",col.names=c("DGGID","X","Y"))

coord_matrix_x<-as.numeric(as.matrix(df$X))
coord_matrix_y<-as.numeric(as.matrix(df$Y))
coord2 <- cbind(coord_matrix_x, coord_matrix_y)
coord2<-as.data.frame(coord2)
coordinates(coord2)<-c("coord_matrix_x","coord_matrix_y")


firePolygons_sf <-  st_as_sf(firePolygons)
st_is_valid(firePolygons_sf)

#
coords <- df[ , c("X", "Y")]   # coordinates
data   <- df[ , c("DGGID")]          # data
crs    <- CRS("+init=epsg:4326") # proj4string of coords

# make the spatial points data frame object
spdf <- SpatialPointsDataFrame(coords = coords,
                               data = as.data.frame(data), 
                               proj4string = crs)

# firePolygons_sf <-   select(firePolygons_sf,BURN_CLASS)

out <- st_intersection(coordinates, firePolygons_sf)
new_shape <- point.in.poly(spdf, firePolygons_sf)

