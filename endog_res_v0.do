set more off
clear

global path "/Users/youpei/Downloads/Yale/COVID19"

use "$path/covid19_final.dta", clear
	 
 global xlist_weather pr_precipitation_amount rmax_relative_humidity rmin_relative_humidity surface_downwelling th_wind_from_direction tmmn_air_temperature vs_wind_speed tmmx_air_temperature 
 
 ** Create Variables

gen lcase_county = log(NYTcase_county+1)	
gen lcase_county_se = lcase_county * policy
gen lcase_county_day_se = lcase_county * day_order_se
gen lcase_county_sip = lcase_county * policy_sip
gen lcase_county_day_sip = lcase_county * day_order_sip

gen lcase_nation = log(NYTcase_national / 1000 + 1)
gen lcase_nation_se = lcase_nation * policy
gen lcase_nation_day_se = lcase_nation * day_order_se
gen lcase_nation_sip = lcase_nation * policy_sip
gen lcase_nation_day_sip = lcase_nation * day_order_sip
	
gen ldeath_county = log(NYTdeath_county+1)	
gen ldeath_county_se = ldeath_county * policy
gen ldeath_county_day_se = ldeath_county * day_order_se
gen ldeath_county_sip = ldeath_county * policy_sip
gen ldeath_county_day_sip = ldeath_county * day_order_sip

gen ldeath_nation = log(NYTdeath_national / 1000 + 1)
gen ldeath_nation_se = ldeath_nation * policy
gen ldeath_nation_day_se = ldeath_nation * day_order_se
gen ldeath_nation_sip = ldeath_nation * policy_sip
gen ldeath_nation_day_sip = ldeath_nation * day_order_sip

gen y = median_home_dwell_time
gen logy = log(y+1)

xtset geoid date
*******************
*** Table S1 S2 ***
*******************

** Table 1
global x1_case lcase_county lcase_nation
global x1_death ldeath_county ldeath_nation
global x1_order policy policy_sip

eststo clear
*level-log
eststo: qui xtreg y $x1_case $xlist_weather week_*, fe cluster(State)
eststo: qui xtreg y $x1_case $x1_death $xlist_weather week_*, fe cluster(State)
eststo: qui xtreg y $x1_case $x1_order $xlist_weather week_*, fe cluster(State)
eststo: qui xtreg y $x1_case $x1_death $x1_order $xlist_weather week_*, fe cluster(State)
*log-log
eststo: qui xtreg logy $x1_case $xlist_weather week_*, fe cluster(State)
eststo: qui xtreg logy $x1_case $x1_death $xlist_weather week_*, fe cluster(State)
eststo: qui xtreg logy $x1_case $x1_order $xlist_weather week_*, fe cluster(State)
eststo: qui xtreg logy $x1_case $x1_death $x1_order $xlist_weather week_*, fe cluster(State)

esttab using $path/Table1.csv, replace se keep($x1_case $x1_death $x1_order)


******************
*** Table 1 S3 ***
****************** 
global x2_order1cc policy lcase_county_se
global x2_order2cc policy_sip lcase_county_sip

global x2_order1cn policy lcase_county_se lcase_nation_se
global x2_order2cn policy_sip lcase_county_sip lcase_nation_sip

eststo clear
preserve
keep if date >=21970 // After Feb 25th
* level-log with nation interaction
eststo: qui xtreg y $x1_case $x2_order1cc $xlist_weather week_*, fe cluster(State)
eststo: qui xtreg y $x1_case $x2_order1cn $xlist_weather week_*, fe cluster(State)
eststo: qui xtreg y $x1_case $x2_order1cc $x2_order2cc $xlist_weather week_*, fe cluster(State)
eststo: qui xtreg y $x1_case $x2_order1cn $x2_order2cn $xlist_weather week_*, fe cluster(State)
* log-log with nation interaction
eststo: qui xtreg logy $x1_case $x2_order1cc $xlist_weather week_*, fe cluster(State)
eststo: qui xtreg logy $x1_case $x2_order1cn $xlist_weather week_*, fe cluster(State)
eststo: qui xtreg logy $x1_case $x2_order1cc $x2_order2cc $xlist_weather week_*, fe cluster(State)
eststo: qui xtreg logy $x1_case $x2_order1cn $x2_order2cn $xlist_weather week_*, fe cluster(State)
restore
esttab using $path/Table2.csv, replace se keep($x1_case $x2_order1cn $x2_order2cn)  

** Daily FE (lower bound) for log-log
qui tabulate date, generate(date_)
eststo clear
preserve 
keep if date >=21970
qui xtreg logy $x1_case $x2_order1cc $x2_order2cc $xlist_weather week_* date_*, fe cluster(State)
scalar b1 = _b[lcase_county]
  gen logy1 = logy - b1*lcase_county
  display b1
eststo: qui xtreg logy1 lcase_nation $x2_order1cc $x2_order2cc $xlist_weather week_*, fe cluster(State)
eststo: qui xtreg logy1 lcase_nation $x2_order1cn $x2_order2cn $xlist_weather week_*, fe cluster(State)
esttab using $path/Table2_lb.csv, replace se keep($x1_case $x2_order1cn $x2_order2cn)   
restore
 

*******************
*** Table S4-S8 ***
*******************
global x3a_order1cc policy day_order_se lcase_county_se
global x3a_order2cc policy_sip day_order_sip lcase_county_sip
global x3a_order1cn policy day_order_se lcase_county_se lcase_nation_se
global x3a_order2cn policy_sip day_order_sip lcase_county_sip lcase_nation_sip

preserve
keep if date >=21970
eststo clear
* level-log with nation interaction 
eststo: qui xtreg y $x1_case $x3a_order1cc $x3a_order2cc $xlist_weather week_*, fe cluster(State)
eststo: qui xtreg y $x1_case $x3a_order1cc $x3a_order2cc $xlist_weather week_* if metro == 1, fe cluster(State)
eststo: qui xtreg y $x1_case $x3a_order1cc $x3a_order2cc $xlist_weather week_* if metro == 0, fe cluster(State)
* log-log with nation interaction
eststo: qui xtreg logy $x1_case $x3a_order1cc $x3a_order2cc $xlist_weather week_*, fe cluster(State)
eststo: qui xtreg logy $x1_case $x3a_order1cc $x3a_order2cc $xlist_weather week_* if metro == 1, fe cluster(State)
eststo: qui xtreg logy $x1_case $x3a_order1cc $x3a_order2cc $xlist_weather week_* if metro == 0, fe cluster(State)

* level-log with nation interaction 
eststo: qui xtreg y $x1_case $x3a_order1cn $x3a_order2cn $xlist_weather week_*, fe cluster(State)
eststo: qui xtreg y $x1_case $x3a_order1cn $x3a_order2cn $xlist_weather week_* if metro == 1, fe cluster(State)
eststo: qui xtreg y $x1_case $x3a_order1cn $x3a_order2cn $xlist_weather week_* if metro == 0, fe cluster(State)
* log-log with nation interaction
eststo: qui xtreg logy $x1_case $x3a_order1cn $x3a_order2cn $xlist_weather week_*, fe cluster(State)
eststo: qui xtreg logy $x1_case $x3a_order1cn $x3a_order2cn $xlist_weather week_* if metro == 1, fe cluster(State)
eststo: qui xtreg logy $x1_case $x3a_order1cn $x3a_order2cn $xlist_weather week_* if metro == 0, fe cluster(State)
restore

* S8: full dataset
* level-log with nation interaction 
eststo: qui xtreg y $x1_case $x3a_order1cc $xlist_weather week_*, fe cluster(State)
eststo: qui xtreg y $x1_case $x3a_order1cc $x3a_order2cc $xlist_weather week_*, fe cluster(State)
* level-log with nation interaction 
eststo: qui xtreg logy $x1_case $x3a_order1cc $xlist_weather week_*, fe cluster(State)
eststo: qui xtreg logy $x1_case $x3a_order1cc $x3a_order2cc $xlist_weather week_*, fe cluster(State)
esttab using $path/Table3.csv, replace se keep($x1_case $x3a_order1cc $x3a_order2cc)  

** Daily FE (lower bound) for log-log
eststo clear
preserve
keep if date >=21970
eststo: qui xtreg logy $x1_case $x3a_order1cc $x3a_order2cc $xlist_weather week_* date_*, fe cluster(State)
scalar b1 = _b[lcase_county]
eststo: qui xtreg logy $x1_case $x3a_order1cc $x3a_order2cc $xlist_weather week_* date_* if metro == 1, fe cluster(State)
scalar b2 = _b[lcase_county] 
eststo: qui xtreg logy $x1_case $x3a_order1cc $x3a_order2cc $xlist_weather week_* date_* if metro == 0, fe cluster(State)
scalar b3 = _b[lcase_county] 
  gen logy1 = logy - b1*lcase_county 
  gen logy2 = logy - b2*lcase_county 
  gen logy3 = logy - b3*lcase_county 
eststo: qui xtreg logy1 lcase_nation $x3a_order1cc $x3a_order2cc $xlist_weather week_*, fe cluster(State)
eststo: qui xtreg logy2 lcase_nation $x3a_order1cc $x3a_order2cc $xlist_weather week_* if metro == 1, fe cluster(State)
eststo: qui xtreg logy3 lcase_nation $x3a_order1cc $x3a_order2cc $xlist_weather week_* if metro == 0, fe cluster(State)
esttab using $path/Table3_lb.csv, replace se keep($x1_case $x3a_order1cc $x3a_order2cc)    
restore 

  
****************
*** Figure 4 ***
****************

** Duplicate the policy related variables to later mute in counterfactural
  gen policy_ori = policy
  gen day_order_se_ori = day_order_se
  gen lcase_county_se_ori = lcase_county_se
  gen policy_sip_ori = policy_sip
  gen day_order_sip_ori = day_order_sip 
  gen lcase_county_sip_ori = lcase_county_sip

  qui xtreg logy $x1_case $x3a_order1cc $x3a_order2cc $xlist_weather week_* if metro == 1 & date>=21970, fe cluster(State)
  predict fitted_time_metro_order
  replace policy = 0
  replace day_order_se = 0
  replace lcase_county_se = 0
  replace policy_sip = 0
  replace day_order_sip = 0
  replace lcase_county_sip = 0
  predict fitted_time_metro_order_ctf if e(sample)
  replace policy = policy_ori
  replace day_order_se = day_order_se_ori
  replace lcase_county_se = lcase_county_se_ori
  replace policy_sip = policy_sip_ori
  replace day_order_sip = day_order_sip_ori
  replace lcase_county_sip = lcase_county_sip_ori
  qui xtreg logy $x1_case $x3a_order1cc $x3a_order2cc $xlist_weather week_* if metro == 0 & date>=21970, fe cluster(State)
  predict fitted_time_nonmetro_order
  replace policy = 0
  replace day_order_se = 0
  replace lcase_county_se = 0
  replace policy_sip = 0
  replace day_order_sip = 0
  replace lcase_county_sip = 0
  predict fitted_time_nonmetro_order_ctf if e(sample)
  replace policy = policy_ori
  replace day_order_se = day_order_se_ori
  replace lcase_county_se = lcase_county_se_ori
  replace policy_sip = policy_sip_ori
  replace day_order_sip = day_order_sip_ori
  replace lcase_county_sip = lcase_county_sip_ori
  
qui xtreg logy $x1_case $x3a_order1cc $x3a_order2cc $xlist_weather week_* date_* if metro == 1 & date>=21970, fe cluster(State)
scalar b1 = _b[lcase_county]
qui xtreg logy $x1_case $x3a_order1cc $x3a_order2cc $xlist_weather week_* date_* if metro == 0 & date>=21970,  fe cluster(State)
scalar b2 = _b[lcase_county]
  gen logy1 = logy - b1*lcase_county 
  gen logy2 = logy - b2*lcase_county 
qui xtreg logy1 lcase_nation $x3a_order1cc $x3a_order2cc $xlist_weather week_* if metro == 1 & date>=21970, fe cluster(State) 
  replace policy = 0
  replace day_order_se = 0
  replace lcase_county_se = 0
  replace policy_sip = 0
  replace day_order_sip = 0
  replace lcase_county_sip = 0
  predict fitted_y1 if e(sample)
 gen fitted_metro_lb = fitted_y1  + b1*lcase_county  
  replace policy = policy_ori
  replace day_order_se = day_order_se_ori
  replace lcase_county_se = lcase_county_se_ori
  replace policy_sip = policy_sip_ori
  replace day_order_sip = day_order_sip_ori
  replace lcase_county_sip = lcase_county_sip_ori 
qui xtreg logy2 lcase_nation $x3a_order1cc $x3a_order2cc $xlist_weather week_* if metro == 0 & date>=21970, fe cluster(State)
  replace policy = 0
  replace day_order_se = 0
  replace lcase_county_se = 0
  replace policy_sip = 0
  replace day_order_sip = 0
  replace lcase_county_sip = 0
  predict fitted_y2 if e(sample)
 gen fitted_nonmetro_lb = fitted_y2   + b2*lcase_county 
  replace policy = policy_ori
  replace day_order_se = day_order_se_ori
  replace lcase_county_se = lcase_county_se_ori
  replace policy_sip = policy_sip_ori
  replace day_order_sip = day_order_sip_ori
  replace lcase_county_sip = lcase_county_sip_ori

  gen time_policy = date - Stateofemergency
  sort time_policy
  by time_policy: egen time_mean_metro=mean(exp(fitted_time_metro_order))
  by time_policy: egen time_mean_nonmetro=mean(exp(fitted_time_nonmetro_order))
  by time_policy: egen time_mean_metro_ctf =mean(exp(fitted_time_metro_order_ctf))
  by time_policy: egen time_mean_nonmetro_ctf =mean(exp(fitted_time_nonmetro_order_ctf))
  by time_policy: egen time_mean_metro_lb = mean(exp(fitted_metro_lb))
  by time_policy: egen time_mean_nonmetro_lb = mean(exp(fitted_nonmetro_lb))

twoway line time_mean_metro time_mean_nonmetro time_mean_metro_ctf time_mean_nonmetro_ctf time_mean_metro_lb time_mean_nonmetro_lb time_policy if time_policy <=35 & time_policy >=-25, ytitle(Median time spent at home (min)) xtitle(Days before and after the State of Emergency) lp(solid solid dash dash shortdash_dot shortdash_dot dash dash) lc(edkblue red  edkblue red edkblue*0.58 red*0.58) legend(size(*0.5) pos(11) ring(0) col(2) lab(1 "Metro") lab(2 "Nonmetro") lab(3 "Metro:No-order counterfactural") lab(4 "Nonmetro:No-order counterfactural") lab(5 "Metro:Lower bound response") lab(6 "Nonmetro:Lower bound response")) graphregion(color(white)) bgcolor(white) 
graph export $path/figure4.pdf, replace 
 
*******************
*** Table S9-11 ***
*******************

*** Lagged case regression: Re-generating variables
use "$path/covid19_final.dta", clear
xtset geoid date
gen lcase_county = log(NYTcase_county+1)	
gen lcase_nation = log(NYTcase_national / 1000 + 1)
gen ldeath_county = log(NYTdeath_county+1)	
gen ldeath_nation = log(NYTdeath_national / 1000 + 1)
foreach var in lcase_county lcase_nation ldeath_county ldeath_nation {
sum `var'
gen L`var' = L.`var'
replace `var' = L`var'
drop L`var'
sum `var'
}

gen lcase_county_se = lcase_county * policy
gen lcase_county_day_se = lcase_county * day_order_se
gen lcase_county_sip = lcase_county * policy_sip
gen lcase_county_day_sip = lcase_county * day_order_sip

gen lcase_nation_se = lcase_nation * policy
gen lcase_nation_day_se = lcase_nation * day_order_se
gen lcase_nation_sip = lcase_nation * policy_sip
gen lcase_nation_day_sip = lcase_nation * day_order_sip
	
gen ldeath_county_se = ldeath_county * policy
gen ldeath_county_day_se = ldeath_county * day_order_se
gen ldeath_county_sip = ldeath_county * policy_sip
gen ldeath_county_day_sip = ldeath_county * day_order_sip

gen ldeath_nation_se = ldeath_nation * policy
gen ldeath_nation_day_se = ldeath_nation * day_order_se
gen ldeath_nation_sip = ldeath_nation * policy_sip
gen ldeath_nation_day_sip = ldeath_nation * day_order_sip

gen y = median_home_dwell_time
gen logy = log(y+1)


eststo clear
*log-log S9
eststo: qui xtreg logy $x1_case $xlist_weather week_*, fe cluster(State)
eststo: qui xtreg logy $x1_case $x1_death $xlist_weather week_*, fe cluster(State)
eststo: qui xtreg logy $x1_case $x1_order $xlist_weather week_*, fe cluster(State)
eststo: qui xtreg logy $x1_case $x1_death $x1_order $xlist_weather week_*, fe cluster(State)

preserve
keep if date>=21970
* log-log with nation interaction: S10
eststo: qui xtreg logy $x1_case $x2_order1cc $xlist_weather week_*, fe cluster(State)
eststo: qui xtreg logy $x1_case $x2_order1cn $xlist_weather week_*, fe cluster(State)
eststo: qui xtreg logy $x1_case $x2_order1cc $x2_order2cc $xlist_weather week_*, fe cluster(State)
eststo: qui xtreg logy $x1_case $x2_order1cn $x2_order2cn $xlist_weather week_*, fe cluster(State)

* log-log with nation interaction: S11
eststo: qui xtreg logy $x1_case $x3a_order1cc $x3a_order2cc $xlist_weather week_*, fe cluster(State)
eststo: qui xtreg logy $x1_case $x3a_order1cc $x3a_order2cc $xlist_weather week_* if metro == 1, fe cluster(State)
eststo: qui xtreg logy $x1_case $x3a_order1cc $x3a_order2cc $xlist_weather week_* if metro == 0, fe cluster(State)
restore
esttab using $path/Table4.csv, replace se keep($x1_case $x1_death $x2_order1cn $x2_order2cn $x3a_order1cc $x3a_order2cc)

