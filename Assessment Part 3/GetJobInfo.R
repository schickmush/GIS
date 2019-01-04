library(rvest)
library(dplyr)
library(stringr)

setwd("E:/UCL/GIS/Assessment3/南京/Job_Info")
key = "M4QO5Iqc7DreoQdYewUX7mCW"  # Baidu Map Api
Job_all <- as.character()

html_string <- "http://www.job5156.com/qiye/nanjing-8/pn48/"
Website <- read_html(html_string)

Job <- Website %>% html_nodes("#job_list li .line_com a") %>% html_text()
Job <- Job[-which(Job == '南京')]

Job_all <- append(Job_all,Job)