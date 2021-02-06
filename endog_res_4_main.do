set more off

clear
global path "/Users/youpei/Downloads/Yale/COVID19_ER" 
global xctrl precip rmax rmin srad tmin tmax wind_speed week_*

use "$path/endog_res_final2.dta", clear

*** 1.lcc: log of county case specification in Table 1.
eststo clear
//basic model
eststo: qui reghdfe logy lcc lcn lcn1 soe sip scs lcc_sip $xctrl crazy, absorb(geoid dbin) cluster(stateid) 
// kitchen sink model with epidemic days FE controled, and deviation of labor share interacted with key variables
eststo: qui reghdfe logy lcc lcc_divEMP* lcn lcn1 soe sip sip_divEMP* scs lcc_sip lcc_sip_divEMP* $xctrl crazy, absorb(geoid dbin epiday_s) cluster(stateid) 

// basic model for no-policy counties, including counties without policy issued and pre-trend of with-order counties 
eststo: qui reghdfe logy lcc lcn lcn1 soe sip scs lcc_sip $xctrl crazy if sip == 0, absorb(geoid dbin) cluster(stateid) 
// kitchen sink model for no-policy counties.
eststo: qui reghdfe logy lcc lcc_divEMP* lcn lcn1 soe sip sip_divEMP* scs lcc_sip lcc_sip_divEMP* $xctrl crazy if sip == 0, absorb(geoid dbin epiday_s) cluster(stateid) 

esttab using $path/results/table1.csv, replace se r2 drop(_cons $xctrl)




*** 1.1 lcc rest: the rest of log of county case specification that are not in Table 1.
eststo clear
// model with epidemic days FE
eststo: qui reghdfe logy lcc lcn lcn1 soe sip scs lcc_sip $xctrl crazy, absorb(geoid dbin epiday_s) cluster(stateid) 
// model with stay-at-home days FE
eststo: qui reghdfe logy lcc lcn lcn1 soe sip scs lcc_sip $xctrl crazy, absorb(geoid dbin day_sip) cluster(stateid) 
// model with daily FE
eststo: qui reghdfe logy lcc lcn lcn1 soe sip scs lcc_sip $xctrl crazy, absorb(geoid dbin date) cluster(stateid) 

// add labor share interactions and daily FE to the basic and kitchen sink models.
eststo: qui reghdfe logy lcc lcc_divEMP* lcn lcn1 soe sip sip_divEMP* scs lcc_sip lcc_sip_divEMP* $xctrl crazy, absorb(geoid dbin) cluster(stateid) 
eststo: qui reghdfe logy lcc lcc_divEMP* lcn lcn1 soe sip sip_divEMP* scs lcc_sip lcc_sip_divEMP* $xctrl crazy, absorb(geoid dbin epiday_s day_sip) cluster(stateid) 
eststo: qui reghdfe logy lcc lcc_divEMP* lcn lcn1 soe sip sip_divEMP* scs lcc_sip lcc_sip_divEMP* $xctrl crazy, absorb(geoid dbin epiday_s date) cluster(stateid) 
eststo: qui reghdfe logy lcc lcc_divEMP* lcn lcn1 soe sip sip_divEMP* scs lcc_sip lcc_sip_divEMP* $xctrl crazy, absorb(geoid dbin epiday_s day_sip date) cluster(stateid) 


// subsamples of no-policy counties for the above six models.
eststo: qui reghdfe logy lcc lcn lcn1 soe sip scs lcc_sip $xctrl crazy if sip == 0, absorb(geoid dbin epiday_s) cluster(stateid) 
eststo: qui reghdfe logy lcc lcn lcn1 soe sip scs lcc_sip $xctrl crazy if sip == 0, absorb(geoid dbin day_sip) cluster(stateid) 
eststo: qui reghdfe logy lcc lcn lcn1 soe sip scs lcc_sip $xctrl crazy if sip == 0, absorb(geoid dbin date) cluster(stateid) 
eststo: qui reghdfe logy lcc lcc_divEMP* lcn lcn1 soe sip sip_divEMP* scs lcc_sip lcc_sip_divEMP* $xctrl crazy if sip == 0, absorb(geoid dbin) cluster(stateid) 
eststo: qui reghdfe logy lcc lcc_divEMP* lcn lcn1 soe sip sip_divEMP* scs lcc_sip lcc_sip_divEMP* $xctrl crazy if sip == 0, absorb(geoid dbin epiday_s day_sip) cluster(stateid) 
eststo: qui reghdfe logy lcc lcc_divEMP* lcn lcn1 soe sip sip_divEMP* scs lcc_sip lcc_sip_divEMP* $xctrl crazy if sip == 0, absorb(geoid dbin epiday_s date) cluster(stateid) 
eststo: qui reghdfe logy lcc lcc_divEMP* lcn lcn1 soe sip sip_divEMP* scs lcc_sip lcc_sip_divEMP* $xctrl crazy if sip == 0, absorb(geoid dbin epiday_s day_sip date) cluster(stateid) 

esttab using $path/results/table_lcc.csv, replace se r2 drop(_cons $xctrl)




*** 1.2 lcc noint: no interaction specification with log of county case
eststo clear
// remove the interaction term between log of cases and stay-at-home order, to examine the overall effects of cases
eststo: qui reghdfe logy lcc lcn lcn1 soe sip scs $xctrl crazy, absorb(geoid dbin) cluster(stateid) 
eststo: qui reghdfe logy lcc lcn lcn1 soe sip scs $xctrl crazy, absorb(geoid dbin epiday_s) cluster(stateid) 
eststo: qui reghdfe logy lcc lcn lcn1 soe sip scs $xctrl crazy, absorb(geoid dbin day_sip) cluster(stateid) 
eststo: qui reghdfe logy lcc lcc_divEMP* lcn lcn1 soe sip sip_divEMP* scs $xctrl crazy, absorb(geoid dbin) cluster(stateid) 
eststo: qui reghdfe logy lcc lcc_divEMP* lcn lcn1 soe sip sip_divEMP* scs $xctrl crazy, absorb(geoid dbin epiday_s) cluster(stateid) 
eststo: qui reghdfe logy lcc lcc_divEMP* lcn lcn1 soe sip sip_divEMP* scs $xctrl crazy, absorb(geoid dbin epiday_s day_sip) cluster(stateid) 

eststo: qui reghdfe logy lcc lcn lcn1 soe sip scs $xctrl crazy if sipd !=., absorb(geoid dbin) cluster(stateid) 
eststo: qui reghdfe logy lcc lcn lcn1 soe sip scs $xctrl crazy if sipd !=., absorb(geoid dbin epiday_s) cluster(stateid) 
eststo: qui reghdfe logy lcc lcn lcn1 soe sip scs $xctrl crazy if sipd !=., absorb(geoid dbin day_sip) cluster(stateid) 
eststo: qui reghdfe logy lcc lcc_divEMP* lcn lcn1 soe sip sip_divEMP* scs $xctrl crazy if sipd !=., absorb(geoid dbin) cluster(stateid) 
eststo: qui reghdfe logy lcc lcc_divEMP* lcn lcn1 soe sip sip_divEMP* scs $xctrl crazy if sipd !=., absorb(geoid dbin epiday_s) cluster(stateid) 
eststo: qui reghdfe logy lcc lcc_divEMP* lcn lcn1 soe sip sip_divEMP* scs $xctrl crazy if sipd !=., absorb(geoid dbin epiday_s day_sip) cluster(stateid) 

esttab using $path/results/table_lccnoint.csv, replace se r2 drop(_cons $xctrl)

