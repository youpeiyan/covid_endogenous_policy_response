*****************************************
**** Use Days since stay-home policy ****
*****************************************
use "$path/endog_res_final.dta", clear

keep if date >= 21945 & date <= 22026
global xctrl1 precip rmax rmin srad tmin tmax wind_speed week_*  
drop if y <= 192
xtile dbin = device_count, nq(50)

gen lcc_day_sip = lcc * day_sip
gen lcc_lday_sip = lcc * lday_sip

gen lcc_sip = lcc * sip

eststo clear
foreach lhs in y logy {
eststo: qui reghdfe `lhs' lcc lcn soe sip scs lcc_sip lcc_day_sip $xctrl1, absorb(geoid dbin) cluster(stateid) 
eststo: qui reghdfe `lhs' lcc lcn soe sip scs lcc_sip day_sip lcc_day_sip $xctrl1, absorb(geoid dbin) cluster(stateid) 

forval i = 0/1 {
eststo: qui reghdfe `lhs' lcc lcn soe sip scs lcc_sip lcc_day_sip $xctrl1 if metro == `i', absorb(geoid dbin) cluster(stateid) 
eststo: qui reghdfe `lhs' lcc lcn soe sip scs lcc_sip day_sip lcc_day_sip $xctrl1 if metro == `i', absorb(geoid dbin) cluster(stateid) 
}
}

esttab using $path/results/_bup/daysip.csv, replace se r2 drop(_cons $xctrl1)
