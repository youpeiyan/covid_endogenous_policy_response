rm(list=ls())
library("lubridate")
library("viridis")
library("readxl")
library("usmap")
library("ggplot2")
library("maps")
library("readxl")
library("maptools")
library("rgdal")
library("ggrepel")
library(pacman)
p_load(tidyverse,USAboundaries,sf,readxl)

path<-"/Users/youpei/Downloads/Yale/COVID19_ER/results/figures/"


#### 1. Map: Stay-at-home order in-effect date
cc_data <- read_excel(paste0(path,"date_plot_dif2.xls")) %>%
  rename(fips=geoid)
p_breaks <- pretty(cc_data$sip)
states <- plot_usmap("states", color = "black", fill = NA)

counties <- plot_usmap(data = cc_data %>% mutate(sip=as.numeric(sip)), values = "sip", color=NA, size=.01)  

ggplot() +
  counties$layers[[1]] +
  states$layers[[1]] +
  scale_fill_viridis(name="",breaks=as.numeric(p_breaks),labels=format(p_breaks,"%b-%d"),na.value="white") +
  theme_void() +
  coord_equal() +
  theme(legend.position = "right",
        legend.key.size = unit(1.2, "cm"),
        legend.key.width = unit(0.7,"cm"),
        legend.title = element_text(size = 18))  

ggsave("sip.pdf")

#### 2. Map: first case reported date
p_breaks <- pretty(cc_data$cc1)
counties <- plot_usmap(data = cc_data %>% mutate(cc1=as.numeric(cc1)), values = "cc1", color=NA, size=.01)  

ggplot() +
  counties$layers[[1]] +
  states$layers[[1]] +
  scale_fill_viridis(name="",breaks=as.numeric(p_breaks),labels=format(p_breaks,"%b"),na.value="white") +
  theme_void() +
  coord_equal() +
  theme(legend.position = "right",
        legend.key.size = unit(1.2, "cm"),
        legend.key.width = unit(0.7,"cm"),
        legend.title = element_text(size = 18))  

ggsave("cc1.pdf")


#### 3. Map: county cases when the stay-at-home order kicks in (black for no-case counties)
ce_dat <- read_excel(paste0(path,"ccstar.xls"),col_types = c("text","numeric")) %>%
  mutate(geoid=str_pad(geoid,5,"left",0))
skimr::skim(ce_dat)
us_co <- us_counties(resolution = "low") %>%
  filter(!(state_abbr %in% c("AK","HI","PR"))) %>%
  select(geoid) %>%
  st_transform(5070)

us_st <- us_states(resolution = "low") %>%
  filter(!(stusps %in% c("AK","HI","PR"))) %>%
  select(geoid) %>%
  st_transform(5070)

to_map <- inner_join(us_co,ce_dat)

ggplot() +
  geom_sf(data=to_map %>% filter(ccstar>0),aes(fill=ccstar),color=NA) +
  geom_sf(data=to_map %>% filter(ccstar==0),fill="black",color=NA) +
  geom_sf(data=us_st,fill=NA,color="darkgray",size=.1) +
  scale_fill_viridis_c(name="") +
  theme_void(base_size = 10) +  theme(legend.position = "right", legend.key.size = unit(1.2, "cm"), legend.key.width = unit(0.7,"cm"), legend.title = element_text(size = 18))  

ggsave("ccstar_map.pdf")

#### 4. Map: equivalent case reports 
cc_data <- read_excel(paste0(path,"plotsim.xls")) %>%
  rename(fips=geoid)
states <- plot_usmap("states", color = "black", fill = NA)

p_breaks <- pretty(cc_data$plot_sim_sink0)
counties <- plot_usmap(data = cc_data %>% mutate(plot_sim_sink0=as.numeric(plot_sim_sink0)), values = "plot_sim_sink0", color=NA, size=.01)  
ggplot() +
  counties$layers[[1]] +
  states$layers[[1]] +
  scale_fill_viridis(name="",breaks=p_breaks,na.value="white") +
  theme_void() +
  coord_equal() +
  theme(legend.position = "right",
        legend.key.size = unit(1.2, "cm"),
        legend.key.width = unit(0.7,"cm"),
        legend.title = element_text(size = 18))  
ggsave("plot_sim_sink0.pdf")

#### 5. Map: days of case reports before declaration of emergency (cc_dif is the difference between the declaration of emergency and the first case report)

cc_data <- read_excel(paste0(path,"date_plot_dif2.xls")) %>%
  rename(fips=geoid)
states <- plot_usmap("states", color = "black", fill = NA)

p_breaks <- pretty(cc_data$cc_dif)
counties <- plot_usmap(data = cc_data %>% mutate(cc_dif=as.numeric(cc_dif)), values = "cc_dif", color=NA, size=.01)  
ggplot() +
  counties$layers[[1]] +
  states$layers[[1]] +
  scale_fill_viridis(name="",breaks=p_breaks,na.value="white") +
  theme_void() +
  coord_equal() +
  theme(legend.position = "right",
        legend.key.size = unit(1.2, "cm"),
        legend.key.width = unit(0.7,"cm"),
        legend.title = element_text(size = 18))  
ggsave("ccdif.pdf")

#### 6. Map: days of case reports before school closure (cc_dif2 is the difference between the school closure order and the first case report)

cc_data <- read_excel(paste0(path,"date_plot_dif2.xls")) %>%
  rename(fips=geoid)
states <- plot_usmap("states", color = "black", fill = NA)

p_breaks <- pretty(cc_data$cc_dif2)
counties <- plot_usmap(data = cc_data %>% mutate(cc_dif2=as.numeric(cc_dif2)), values = "cc_dif2", color=NA, size=.01)  
ggplot() +
  counties$layers[[1]] +
  states$layers[[1]] +
  scale_fill_viridis(name="",breaks=p_breaks,na.value="white") +
  theme_void() +
  coord_equal() +
  theme(legend.position = "right",
        legend.key.size = unit(1.2, "cm"),
        legend.key.width = unit(0.7,"cm"),
        legend.title = element_text(size = 18))  
ggsave("ccdif2.pdf")
