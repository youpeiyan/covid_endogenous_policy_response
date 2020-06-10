rm(list=ls())

library("googledrive")
library("vroom")
library("data.table")

## set it to your local path
pathER<-"/Users/youpei/Downloads/Yale/COVID19_ER" 

############## Download the Dataset ################

## weather data

drive_download(file = as_id("https://drive.google.com/open?id=1d2F2zYUIMpSrNkoNUiBBfr87ZZOLWJ4B"),
               path = paste0(pathER,"/weather_county.csv"),
               overwrite = TRUE)

## county dwell time
drive_download(file = as_id("https://drive.google.com/open?id=1wz9zKZGS5lME9odtfwTnERrIxWCTEqSB"),
               path = paste0(pathER,"/all_counties_current.csv"),
               overwrite = TRUE)

## county-level policy
drive_download(file = as_id("https://drive.google.com/open?id=1CmH6sseHX4dwnP5zmt7hYS2n8OiTuvmn"),
               path = paste0(pathER,"/county_policy.csv"),
               overwrite = TRUE)

## state_level policy
drive_download(file = as_id("https://drive.google.com/open?id=1zu9qEWI8PsOI_i8nI_S29HDGHlIp2lfVMsGxpQ5tvAQ"),
               path = paste0(pathER,"/state_policy.xlsx"),
               overwrite = TRUE)

## rural/metro definition
drive_download(file = as_id("https://drive.google.com/open?id=1xTQxPCSZsOE_uHiBDU-3Mwg30ZOvThsl"),
               path = paste0(pathER,"/metro.xls"),
               overwrite = TRUE)

