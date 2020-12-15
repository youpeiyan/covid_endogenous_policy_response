#devtools::install_github("ebenmichael/augsynth")
library(pacman)
p_load(tidyverse,haven,augsynth,lubridate,furrr)
conflict_prefer("filter", "dplyr")

if(!dir.exists("augsynth/cache")){
  dir.create("augsynth/cache")
}

###################################
#Load Stata dataset
dist_df <- haven::read_dta("augsynth/augsynth_data.dta") 

#Define the set of counties that do (and never) get shelter in place policies
county_list <- dist_df %>%
  group_by(geoid) %>%
  summarize(across(c(soe,sip,scs),~max(.,na.rm = T))) %>%
  arrange(sip) 

#Subset of counties that get treated
trt_county <- county_list %>%
  filter(sip==1) 

#Subset of counties that never get treated
control_county <- county_list %>%
  filter(sip==0) 

#Define future for parallel estimation
plan(multisession(workers = 4))

#Loop 
future_map(
  c(1:1000),
  function(i){
             
    #Set seed for reproducibility
    set.seed(i)
    
    #Define iteration treatment and control set
    x=trt_county[sample.int(nrow(trt_county),200),]
    z=control_county[sample.int(nrow(trt_county),200),]
    
    #Define df for estimation
    analysis_df <- dist_df %>% 
      dplyr::filter(geoid %in% c(x$geoid,z$geoid),
                    date<=as_date("2020-04-15"),
                    date>=as_date("2020-03-02")) %>%
      mutate(sdate=as.integer(date) - as.integer(as_date("2020-03-01")),
             geoid=factor(geoid),
             sipd=as_date(sipd)) %>%
      select(geoid,date,sdate,logy,sip,soe,scs,lcc,precip,rmax,rmin,tmin,tmax,wind_speed,week_1:week_6) #%>%
    
    #Estimate model
    temp <- multisynth(logy ~ sip | lcc + soe + scs + precip + rmax + rmin + tmin + tmax + wind_speed +
                         week_1 + week_2 + week_3 + week_4 + week_5 + week_6, 
                       unit = geoid, 
                       time = sdate, 
                       data = analysis_df %>% select(logy,sip,soe,scs,lcc,precip,rmax,rmin,tmin,tmax,wind_speed,week_1:week_6,geoid,sdate), 
                       fixedeff = T,
                       time_cohort = F)
  
    #Save results to cache
    saveRDS(temp,file = str_c("augsynth/cache/reg_out_",i,".rds"))
  },.progress=T)


###################################################################
#Load all cached results
results_all <- 
  dir("augsynth/cache",pattern = "reg_out",full.names = T) %>%
  map_dfr(function(x){
    
    temp <- readRDS(x)
    att <- predict(temp, att=T)

    to_plot <- tibble(avg=att[,1]) %>%
      mutate(time=row_number()-temp$n_lags-1) %>%
      add_column(run=str_remove(tools::file_path_sans_ext(x),"augsynth/cache/"))
    
    return(to_plot)
    
  })

saveRDS(results_all,file = "augsynth/cache/results_all.rds")

#################################################################
#Load cached results
results_all <- readRDS("augsynth/cache/results_all.rds")

#Construct bs mean and se
se_rib_bs <- results_all %>% 
  group_by(time) %>%
  summarize(avg_mean=mean(avg,na.rm=T),
            ci_l=quantile(avg,probs = .025,na.rm = T),
            ci_h=quantile(avg,probs = .975,na.rm = T))

#Plot
ggplot(se_rib_bs,aes(x=time)) +
  geom_line(aes(y=avg_mean)) +
  geom_point(aes(y=avg_mean),size=1) +
  geom_ribbon(aes(ymin=ci_l,ymax=ci_h),alpha=.1) +
  geom_vline(xintercept = 0,linetype="dashed") +
  geom_hline(yintercept = 0,linetype="dashed") +
  labs(x="Time Relative to Treatment",y="Estimate") +
  theme_light(base_size = 10)

#Save
ggsave("augsynth_bs.png",width = 8.7,height = 6,units = "cm")
ggsave("augsynth_bs.pdf",width = 8.7,height = 6,units = "cm")

