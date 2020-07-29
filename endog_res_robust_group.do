*********************************
**** Heterogeneity by Groups ****
*********************************
use "$path/endog_res_final.dta", clear
global xctrl1 precip rmax rmin srad tmin tmax wind_speed week_*  
set more off
keep if date >= 21945 & date <= 22026

drop if y <= 192
xtile dbin = device_count, nq(50)
gen lcc_sip = lcc * sip

** With stay-home/shelter-in-place policy counties and no-policy counties
eststo clear

foreach lhs in y logy {
forval i = 0/1 {
eststo: qui reghdfe `lhs' lcc lcn soe sip scs $xctrl1 if no_sip == `i', absorb(geoid dbin) cluster(stateid) 
eststo: qui reghdfe `lhs' lcc lcn lcn1 soe sip scs $xctrl1 if no_sip == `i', absorb(geoid dbin) cluster(stateid) 

eststo: qui reghdfe `lhs' lcc lcn soe sip scs $xctrl1 lcc_sip if no_sip == `i', absorb(geoid dbin) cluster(stateid) 
eststo: qui reghdfe `lhs' lcc lcn lcn1 soe sip scs $xctrl1 lcc_sip if no_sip == `i', absorb(geoid dbin) cluster(stateid) 
}
}

esttab using $path/results/_bup/group.csv, replace se r2 keep(lcc lcn lcn1 soe sip scs lcc_sip) 


** With metro/non-metro counties
eststo clear

foreach lhs in y logy {
forval i = 0/1 {
eststo: qui reghdfe `lhs' lcc lcn soe sip scs $xctrl1 if metro == `i', absorb(geoid dbin) cluster(stateid) 
eststo: qui reghdfe `lhs' lcc lcn lcn1 soe sip scs $xctrl1 if metro == `i', absorb(geoid dbin) cluster(stateid) 

eststo: qui reghdfe `lhs' lcc lcn soe sip scs lcc_sip $xctrl1 if metro == `i', absorb(geoid dbin) cluster(stateid) 
eststo: qui reghdfe `lhs' lcc lcn lcn1 soe sip scs lcc_sip $xctrl1 if metro == `i', absorb(geoid dbin) cluster(stateid) 
}
}
esttab using $path/results/_bup/group2.csv, replace se r2 keep(lcc lcn lcn1 soe sip scs lcc_sip) 



** by population share & increase rates

gen lcc_pop_sip = lcc_pop * sip

gen lcs_sip = lcs * sip
gen lcs_pop_sip = lcs_pop * sip
gen pop_group = (pop19 >100000)

eststo clear

eststo: qui reghdfe logy lcc_pop lcn_pop lcc_pop_sip soe sip scs $xctrl1, absorb(geoid dbin) cluster(stateid) 
eststo: qui reghdfe logy lcc_pop lcs_pop lcn_pop lcc_pop_sip lcs_pop_sip soe sip scs $xctrl1, absorb(geoid dbin) cluster(stateid) 
forval i = 0/1 {
eststo: qui reghdfe logy lcc_pop lcn_pop lcc_pop_sip soe sip scs $xctrl1 if pop_group == `i', absorb(geoid dbin) cluster(stateid) 
eststo: qui reghdfe logy lcc_pop lcs_pop lcn_pop lcc_pop_sip lcs_pop_sip soe sip scs $xctrl1 if pop_group == `i', absorb(geoid dbin) cluster(stateid) 
}

eststo: qui reghdfe logy lcc lcn cc_rate cn_rate lcc_sip soe sip scs $xctrl1, absorb(geoid dbin) cluster(stateid) 
eststo: qui reghdfe logy lcc lcn lcn1 cc_rate cn_rate lcc_sip soe sip scs $xctrl1, absorb(geoid dbin) cluster(stateid) 

eststo: qui reghdfe logy lcc lcs lcn cc_rate cs_rate cn_rate lcc_sip lcs_sip soe sip scs $xctrl1, absorb(geoid dbin) cluster(stateid) 
eststo: qui reghdfe logy lcc lcs lcn lcn1 cc_rate cs_rate cn_rate lcc_sip lcs_sip soe sip scs $xctrl1, absorb(geoid dbin) cluster(stateid) 

esttab using $path/results/_bup/group_pop.csv, replace se r2 drop(_cons $xctrl1)
