
library(rvest)
library(dplyr)
library(stringr)

setwd("E:/UCL/GIS/Assessment3/南京")
page <- as.character(1:14)
House_all <- as.character()
Price_all <- as.character()
lat_all <- as.character()
lng_all <- as.character()
key = "*************"  # Input your Baidu Map Api

for (i in page){
  html_string <- paste("https://nj.lianjia.com/xiaoqu/pukou/pg",i,"/",sep='')
  Website <- read_html(html_string)
  
  # Get House name
  House <- Website %>% html_nodes(".title") %>% html_text()
  House <- House[c(2:(length(House)-5))]
  House <- gsub("[\r\n]", "", House)
  House <-str_trim(House,'both')
  House_all <- append(House_all,House)
  
  # Get House Price
  Price <- Website %>% html_nodes(".totalPrice span") %>% html_text()
  Price_all <- append(Price_all,Price)
}


# Get House lat and lng
for (i in House_all){
  html_string <- paste("http://api.map.baidu.com/geocoder/v2/?ak=",key,
                       "&callback=renderOption&output=xml&address=",i,
                       "&city=南京市",sep='')
  string0 <- read_html(html_string)
  string1 <- str_extract(string0,"(?<=location>).+.(?=</location)") 
  lat  <- str_extract(string0,"(?<=lat>).+.(?=</lat)")
  lng  <- str_extract(string0,"(?<=lng>).+.(?=</lng)")
  lat_all <- append(lat_all,lat)
  lng_all <- append(lng_all,lng)
}

# Create Data Frame
House_info <- data.frame(Name=House_all, Price=Price_all, lat=lat_all, lng=lng_all)
House_info <- House_info[House_info$Price!='暂无',]
House_info <- House_info[complete.cases(House_info), ]

# Export data
write.table(House_info,file="Pukou_House_info.csv",sep = ",",row.names=FALSE)



