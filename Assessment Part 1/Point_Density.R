
setwd("D:/Documents/GitHub/GIS/Assessment Part 1")

library(spatstat)
library(sp)
library(rgeos)
library(maptools)
library(GISTools)
library(tmap)
library(geojsonio)
library(tmaptools)

# load Borough data
BoroughMap <- read_shape('LondonBorough/LondonBouroughs.shp',as.sf=FALSE)
summary(BoroughMap)
BNG = "+init=epsg:27700"
BoroughMapBNG <- spTransform(BoroughMap,BNG)

# load wifi data
LondonWifi <- read.csv("London_Wifi.csv", header = T, sep = ",")
coordinates(LondonWifi) <- ~latitude + longitude
proj4string(LondonWifi) = CRS("+init=epsg:4326")
WifiBNG <- spTransform(LondonWifi,BNG)
WifiBNG <- remove.duplicates(WifiBNG)
WifiBNG <- WifiBNG[BoroughMapBNG,]

# quick plot
tmap_mode("view")
tm_shape(BoroughMapBNG) +
  tm_polygons(col = NA, alpha = 0.5) +
  tm_shape(WifiBNG) +
  tm_dots(col = "blue")

# now set a window as the borough boundary
window <- as.owin(BoroughMapBNG)
plot(window)

# create a point pattern (ppp) object.
Wifi.ppp <- ppp(x=WifiBNG@coords[,1],y=WifiBNG@coords[,2],window=window)
plot(Wifi.ppp,pch=16,cex=0.5, main="London Wifi")


# produce a KDE (Kernel Density Estimation ) map from a ppp object using the density function.
plot(density(Wifi.ppp,sigma = 2000,weights=),main = "London Wifi Density")






