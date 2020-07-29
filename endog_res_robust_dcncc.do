*********************************************
**** Death & New cases Robustness Checks ****
*********************************************

use "$path/endog_res_final.dta", clear
global xctrl1 precip rmax rmin srad tmin tmax wind_speed week_*  
set more off
keep if date >= 21945 & date <= 22026
drop if y <= 192
xtile dbin = device_count, nq(50)

gen lcc_sip = lcc * sip
gen ldc_sip = ldc * sip
gen lncc_sip = lncc * sip

xtset geoid date
eststo clear

eststo: qui reghdfe logy lcc lcn soe sip scs lcc_sip $xctrl1, absorb(geoid dbin) cluster(stateid) 
eststo: qui reghdfe logy lcc lcn lcn1 soe sip scs lcc_sip $xctrl1, absorb(geoid dbin) cluster(stateid)

eststo: qui reghdfe logy lcc lcn ldc ldn soe sip scs lcc_sip ldc_sip $xctrl1, absorb(geoid dbin) cluster(stateid)
eststo: qui reghdfe logy lcc lcn lcn1 ldc ldn ldn1 soe sip scs lcc_sip ldc_sip $xctrl1, absorb(geoid dbin) cluster(stateid)

eststo: qui reghdfe logy lcc lcn lncc lncn soe sip scs lcc_sip lncc_sip $xctrl1, absorb(geoid dbin) cluster(stateid)
eststo: qui reghdfe logy lcc lcn lcn1 lncc lncn lncn1 soe sip scs lcc_sip lncc_sip $xctrl1, absorb(geoid dbin) cluster(stateid)

eststo: qui reghdfe logy lcc lcn ldc ldn lncc lncn soe sip scs lcc_sip ldc_sip lncc_sip $xctrl1, absorb(geoid dbin) cluster(stateid)
eststo: qui reghdfe logy lcc lcn lcn1 ldc ldn ldn1 lncc lncn lncn1 soe sip scs lcc_sip ldc_sip lncc_sip $xctrl1, absorb(geoid dbin) cluster(stateid)
esttab using $path/results/_bup/dc_ncc.csv, se r2 replace drop(_cons $xctrl1)
