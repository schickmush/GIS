
############################# Prepare Data #############################
setwd("E:/UCL/GIS/Assessment1/data/London_Wifi")

#Get the files names
fileNames <- list.files(pattern = "*.csv")

#First apply read.csv, then rbind
readFiles <- lapply(fileNames, function(x) read.csv(x, stringsAsFactors = F, header = T))
fileBind <- do.call(rbind, readFiles)

setwd("E:/UCL/GIS/Assessment1/data")
write.csv(fileBind, "London_Wifi.csv")

########################## plot ########################################
wifi_all <- read.csv("London_Wifi.csv")
library(ggplot2)
library(ggmap)    # remember to cite
library(RColorBrewer)
register_google(key = "AIzaSyCFZODpkbxJDL1cdfK3ZjrIAIMvQMFWhlg")
base <- get_map(location="london",zoom=10,maptype="roadmap",color="bw",source="google")
ggmap(base) + 
  geom_point(data = wifi_all, aes(x=latitude, y=longitude,color=hotspots,size=hotspots), alpha = .3)+
  scale_size_continuous(range=c(1,9)) +



ggmap(base) + 
  stat_density_2d(data=wifi_all, 
                  aes(x=latitude, y=longitude,fill=stat(level),alpha=stat(level)),
                  geom="polygon",show.legend = F)+
  scale_fill_continuous(low="white", high="#FF0033")


ggmap(base) + 
  stat_contour(data=wifi_all, 
                  aes(x=latitude, y=longitude,z=hotspots,fill = ..level..,alpha = ..level..),
               geom = 'polygon')
