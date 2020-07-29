*******************************************
**** Partial Identification Regression ****
*******************************************

use "$path/endog_res_final.dta", clear
global xctrl1 precip rmax rmin srad tmin tmax wind_speed week_*  
set more off
keep if date >= 21945 & date <= 22026

drop if y <= 192
xtile dbin = device_count, nq(50)

gen lcc_sip = lcc * sip

egen groups = group(stateid date)


*** State FE * Daily FE & County FE
eststo clear
eststo: qui reghdfe y lcc soe sip scs lcc_sip $xctrl1, absorb(groups geoid dbin) cluster(stateid)
scalar b0 = _b[lcc]
  gen y1 = y - b0*lcc

eststo: qui reghdfe y1 lcn soe sip scs lcc_sip $xctrl1, absorb(geoid dbin) cluster(stateid) 
eststo: qui reghdfe y1 lcn lcn1 soe sip scs lcc_sip $xctrl1, absorb(geoid dbin) cluster(stateid) 
eststo: qui reghdfe y1 lcn1 soe sip scs lcc_sip $xctrl1, absorb(geoid dbin) cluster(stateid) 

eststo: qui reghdfe logy lcc soe sip scs lcc_sip $xctrl1, absorb(groups geoid dbin) cluster(stateid)
scalar b1 = _b[lcc]
  gen logy1 = logy - b1*lcc

eststo: qui reghdfe logy1 lcn soe sip scs lcc_sip $xctrl1, absorb(geoid dbin) cluster(stateid) 
eststo: qui reghdfe logy1 lcn lcn1 soe sip scs lcc_sip $xctrl1, absorb(geoid dbin) cluster(stateid) 
eststo: qui reghdfe logy1 lcn1 soe sip scs lcc_sip $xctrl1, absorb(geoid dbin) cluster(stateid) 
esttab using $path/results/_bup/dfes2.csv, replace se r2 keep(lcc lcn lcn1 soe sip scs lcc_sip)

*** State FE * Daily FE & State FE
eststo clear
eststo: qui reghdfe y lcc soe sip scs lcc_sip $xctrl1, absorb(groups stateid dbin) cluster(stateid)
scalar b0 = _b[lcc]
  gen y2 = y - b0*lcc

eststo: qui reghdfe y2 lcn soe sip scs lcc_sip $xctrl1, absorb(geoid dbin) cluster(stateid) 
eststo: qui reghdfe y2 lcn lcn1 soe sip scs lcc_sip $xctrl1, absorb(geoid dbin) cluster(stateid) 
eststo: qui reghdfe y2 lcn1 soe sip scs lcc_sip $xctrl1, absorb(geoid dbin) cluster(stateid) 

eststo: qui reghdfe logy lcc soe sip scs lcc_sip $xctrl1, absorb(groups stateid dbin) cluster(stateid)
scalar b1 = _b[lcc]
  gen logy2 = logy - b1*lcc

eststo: qui reghdfe logy2 lcn soe sip scs lcc_sip $xctrl1, absorb(geoid dbin) cluster(stateid) 
eststo: qui reghdfe logy2 lcn lcn1 soe sip scs lcc_sip $xctrl1, absorb(geoid dbin) cluster(stateid) 
eststo: qui reghdfe logy2 lcn1 soe sip scs lcc_sip $xctrl1, absorb(geoid dbin) cluster(stateid) 
esttab using $path/results/_bup/dfes.csv, replace se r2 keep(lcc lcn lcn1 soe sip scs lcc_sip)

*** Daily FE & County FE
eststo clear
eststo: qui reghdfe y lcc soe sip scs lcc_sip $xctrl1, absorb(date geoid dbin) cluster(stateid)
scalar b0 = _b[lcc]
  gen y3 = y - b0*lcc

eststo: qui reghdfe y3 lcn soe sip scs lcc_sip $xctrl1, absorb(geoid dbin) cluster(stateid) 
eststo: qui reghdfe y3 lcn lcn1 soe sip scs lcc_sip $xctrl1, absorb(geoid dbin) cluster(stateid) 
eststo: qui reghdfe y3 lcn1 soe sip scs lcc_sip $xctrl1, absorb(geoid dbin) cluster(stateid) 

eststo: qui reghdfe logy lcc soe sip scs lcc_sip $xctrl1, absorb(date geoid dbin) cluster(stateid)
scalar b1 = _b[lcc]
  gen logy3 = logy - b1*lcc
eststo: qui reghdfe logy3 lcn soe sip scs lcc_sip $xctrl1, absorb(geoid dbin) cluster(stateid) 
eststo: qui reghdfe logy3 lcn lcn1 soe sip scs lcc_sip $xctrl1, absorb(geoid dbin) cluster(stateid) 
eststo: qui reghdfe logy3 lcn1 soe sip scs lcc_sip $xctrl1, absorb(geoid dbin) cluster(stateid) 
esttab using $path/results/_bup/dfe.csv, replace se r2 keep(lcc lcn lcn1 soe sip scs lcc_sip)

