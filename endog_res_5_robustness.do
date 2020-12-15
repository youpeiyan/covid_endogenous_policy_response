set more off

clear
global path "/Users/youpei/Downloads/Yale/COVID19_ER" 
global xctrl precip rmax rmin srad tmin tmax wind_speed week_*

use "$path/endog_res_final2.dta", clear

*** 2.lcs: log of state case specification
eststo clear
eststo: qui reghdfe logy lcs lcn lcn1 soe sip scs lcs_sip $xctrl crazy, absorb(geoid dbin) cluster(stateid) 
eststo: qui reghdfe logy lcs lcn lcn1 soe sip scs lcs_sip $xctrl crazy, absorb(geoid dbin epiday_s) cluster(stateid) 
eststo: qui reghdfe logy lcs lcn lcn1 soe sip scs lcs_sip $xctrl crazy, absorb(geoid dbin day_sip) cluster(stateid) 
eststo: qui reghdfe logy lcs lcs_divEMP* lcn lcn1 soe sip sip_divEMP* scs lcs_sip lcs_sip_divEMP* $xctrl crazy, absorb(geoid dbin) cluster(stateid) 
eststo: qui reghdfe logy lcs lcs_divEMP* lcn lcn1 soe sip sip_divEMP* scs lcs_sip lcs_sip_divEMP* $xctrl crazy, absorb(geoid dbin epiday_s) cluster(stateid) 
eststo: qui reghdfe logy lcs lcs_divEMP* lcn lcn1 soe sip sip_divEMP* scs lcs_sip lcs_sip_divEMP* $xctrl crazy, absorb(geoid dbin epiday_s day_sip) cluster(stateid) 
esttab using $path/results/table_lcs.csv, replace se r2 drop(_cons $xctrl)

*** 3.lcc lcs: specifications with both county and state case
eststo clear
eststo: qui reghdfe logy lcc lcs lcn lcn1 soe sip scs lcc_sip lcs_sip $xctrl crazy, absorb(geoid dbin) cluster(stateid) 
eststo: qui reghdfe logy lcc lcs lcn lcn1 soe sip scs lcc_sip lcs_sip $xctrl crazy, absorb(geoid dbin epiday_s) cluster(stateid) 
eststo: qui reghdfe logy lcc lcs lcn lcn1 soe sip scs lcc_sip lcs_sip $xctrl crazy, absorb(geoid dbin day_sip) cluster(stateid) 
eststo: qui reghdfe logy lcc lcs lcc_divEMP* lcs_divEMP* lcn lcn1 soe sip sip_divEMP* scs lcc_sip lcs_sip lcc_sip_divEMP* lcs_sip_divEMP* $xctrl crazy, absorb(geoid dbin) cluster(stateid) 
eststo: qui reghdfe logy lcc lcs lcc_divEMP* lcs_divEMP* lcn lcn1 soe sip sip_divEMP* scs lcc_sip lcs_sip lcc_sip_divEMP* lcs_sip_divEMP* $xctrl crazy, absorb(geoid dbin epiday_s) cluster(stateid) 
eststo: qui reghdfe logy lcc lcs lcc_divEMP* lcs_divEMP* lcn lcn1 soe sip sip_divEMP* scs lcc_sip lcs_sip lcc_sip_divEMP* lcs_sip_divEMP* $xctrl crazy, absorb(geoid dbin epiday_s day_sip) cluster(stateid) 
esttab using $path/results/table_lcclcs.csv, replace se r2 drop(_cons $xctrl)




*** 3.1 ny for lcc lcs lcc+lcs: non-dwell time as the dependent variable; Repeating the above regression
eststo clear
eststo: qui reghdfe logny lcc lcn lcn1 soe sip scs lcc_sip $xctrl crazy, absorb(geoid dbin) cluster(stateid) 
eststo: qui reghdfe logny lcc lcn lcn1 soe sip scs lcc_sip $xctrl crazy, absorb(geoid dbin epiday_s) cluster(stateid) 
eststo: qui reghdfe logny lcc lcn lcn1 soe sip scs lcc_sip $xctrl crazy, absorb(geoid dbin day_sip) cluster(stateid) 
eststo: qui reghdfe logny lcc lcc_divEMP* lcn lcn1 soe sip sip_divEMP* scs lcc_sip lcc_sip_divEMP* $xctrl crazy, absorb(geoid dbin) cluster(stateid) 
eststo: qui reghdfe logny lcc lcc_divEMP* lcn lcn1 soe sip sip_divEMP* scs lcc_sip lcc_sip_divEMP* $xctrl crazy, absorb(geoid dbin epiday_s) cluster(stateid) 
eststo: qui reghdfe logny lcc lcc_divEMP* lcn lcn1 soe sip sip_divEMP* scs lcc_sip lcc_sip_divEMP* $xctrl crazy, absorb(geoid dbin epiday_s day_sip) cluster(stateid) 

eststo: qui reghdfe logny lcs lcn lcn1 soe sip scs lcs_sip $xctrl crazy, absorb(geoid dbin) cluster(stateid) 
eststo: qui reghdfe logny lcs lcn lcn1 soe sip scs lcs_sip $xctrl crazy, absorb(geoid dbin epiday_s) cluster(stateid) 
eststo: qui reghdfe logny lcs lcn lcn1 soe sip scs lcs_sip $xctrl crazy, absorb(geoid dbin day_sip) cluster(stateid) 
eststo: qui reghdfe logny lcs lcs_divEMP* lcn lcn1 soe sip sip_divEMP* scs lcs_sip lcs_sip_divEMP* $xctrl crazy, absorb(geoid dbin) cluster(stateid) 
eststo: qui reghdfe logny lcs lcs_divEMP* lcn lcn1 soe sip sip_divEMP* scs lcs_sip lcs_sip_divEMP* $xctrl crazy, absorb(geoid dbin epiday_s) cluster(stateid) 
eststo: qui reghdfe logny lcs lcs_divEMP* lcn lcn1 soe sip sip_divEMP* scs lcs_sip lcs_sip_divEMP* $xctrl crazy, absorb(geoid dbin epiday_s day_sip) cluster(stateid) 

eststo: qui reghdfe logny lcc lcs lcn lcn1 soe sip scs lcc_sip lcs_sip $xctrl crazy, absorb(geoid dbin) cluster(stateid) 
eststo: qui reghdfe logny lcc lcs lcn lcn1 soe sip scs lcc_sip lcs_sip $xctrl crazy, absorb(geoid dbin epiday_s) cluster(stateid) 
eststo: qui reghdfe logny lcc lcs lcn lcn1 soe sip scs lcc_sip lcs_sip $xctrl crazy, absorb(geoid dbin day_sip) cluster(stateid) 
eststo: qui reghdfe logny lcc lcs lcc_divEMP* lcs_divEMP* lcn lcn1 soe sip sip_divEMP* scs lcc_sip lcs_sip lcc_sip_divEMP* lcs_sip_divEMP* $xctrl crazy, absorb(geoid dbin) cluster(stateid) 
eststo: qui reghdfe logny lcc lcs lcc_divEMP* lcs_divEMP* lcn lcn1 soe sip sip_divEMP* scs lcc_sip lcs_sip lcc_sip_divEMP* lcs_sip_divEMP* $xctrl crazy, absorb(geoid dbin epiday_s) cluster(stateid) 
eststo: qui reghdfe logny lcc lcs lcc_divEMP* lcs_divEMP* lcn lcn1 soe sip sip_divEMP* scs lcc_sip lcs_sip lcc_sip_divEMP* lcs_sip_divEMP* $xctrl crazy, absorb(geoid dbin epiday_s day_sip) cluster(stateid) 
esttab using $path/results/table_ny.csv, replace se r2 drop(_cons $xctrl)





*** 3.2 level y for cc cs cc+cs: level-level model rather than log-log specification for the above county and state case specifications
eststo clear
eststo: qui reghdfe y cc cn cn1 soe sip scs cc_sip $xctrl crazy, absorb(geoid dbin) cluster(stateid) 
eststo: qui reghdfe y cc cn cn1 soe sip scs cc_sip $xctrl crazy, absorb(geoid dbin epiday_s) cluster(stateid) 
eststo: qui reghdfe y cc cn cn1 soe sip scs cc_sip $xctrl crazy, absorb(geoid dbin day_sip) cluster(stateid) 
eststo: qui reghdfe y cc cc_divEMP* cn cn1 soe sip sip_divEMP* scs cc_sip cc_sip_divEMP* $xctrl crazy, absorb(geoid dbin) cluster(stateid) 
eststo: qui reghdfe y cc cc_divEMP* cn cn1 soe sip sip_divEMP* scs cc_sip cc_sip_divEMP* $xctrl crazy, absorb(geoid dbin epiday_s) cluster(stateid) 
eststo: qui reghdfe y cc cc_divEMP* cn cn1 soe sip sip_divEMP* scs cc_sip cc_sip_divEMP* $xctrl crazy, absorb(geoid dbin epiday_s day_sip) cluster(stateid) 

eststo: qui reghdfe y cs cn cn1 soe sip scs cs_sip $xctrl crazy, absorb(geoid dbin) cluster(stateid) 
eststo: qui reghdfe y cs cn cn1 soe sip scs cs_sip $xctrl crazy, absorb(geoid dbin epiday_s) cluster(stateid) 
eststo: qui reghdfe y cs cn cn1 soe sip scs cs_sip $xctrl crazy, absorb(geoid dbin day_sip) cluster(stateid) 
eststo: qui reghdfe y cs cs_divEMP* cn cn1 soe sip sip_divEMP* scs cs_sip cs_sip_divEMP* $xctrl crazy, absorb(geoid dbin) cluster(stateid) 
eststo: qui reghdfe y cs cs_divEMP* cn cn1 soe sip sip_divEMP* scs cs_sip cs_sip_divEMP* $xctrl crazy, absorb(geoid dbin epiday_s) cluster(stateid) 
eststo: qui reghdfe y cs cs_divEMP* cn cn1 soe sip sip_divEMP* scs cs_sip cs_sip_divEMP* $xctrl crazy, absorb(geoid dbin epiday_s day_sip) cluster(stateid) 

eststo: qui reghdfe y cc cs cn cn1 soe sip scs cc_sip cs_sip $xctrl crazy, absorb(geoid dbin) cluster(stateid) 
eststo: qui reghdfe y cc cs cn cn1 soe sip scs cc_sip cs_sip $xctrl crazy, absorb(geoid dbin epiday_s) cluster(stateid) 
eststo: qui reghdfe y cc cs cn cn1 soe sip scs cc_sip cs_sip $xctrl crazy, absorb(geoid dbin day_sip) cluster(stateid) 
eststo: qui reghdfe y cc cs cc_divEMP* cs_divEMP* cn cn1 soe sip sip_divEMP* scs cc_sip cs_sip cc_sip_divEMP* cs_sip_divEMP* $xctrl crazy, absorb(geoid dbin) cluster(stateid) 
eststo: qui reghdfe y cc cs cc_divEMP* cs_divEMP* cn cn1 soe sip sip_divEMP* scs cc_sip cs_sip cc_sip_divEMP* cs_sip_divEMP* $xctrl crazy, absorb(geoid dbin epiday_s) cluster(stateid) 
eststo: qui reghdfe y cc cs cc_divEMP* cs_divEMP* cn cn1 soe sip sip_divEMP* scs cc_sip cs_sip cc_sip_divEMP* cs_sip_divEMP* $xctrl crazy, absorb(geoid dbin epiday_s day_sip) cluster(stateid) 
esttab using $path/results/table_lvly.csv, replace se r2 drop(_cons $xctrl)





*** 3.3 lcbs: add border state cases in log form to the above representative models.
eststo clear
eststo: qui reghdfe logy lcc lcbs lcn lcn1 soe sip scs lcc_sip lcbs_sip $xctrl crazy, absorb(geoid dbin) cluster(stateid) 
eststo: qui reghdfe logy lcc lcbs lcn lcn1 soe sip scs lcc_sip lcbs_sip $xctrl crazy, absorb(geoid dbin epiday_s) cluster(stateid) 
eststo: qui reghdfe logy lcc lcbs lcn lcn1 soe sip scs lcc_sip lcbs_sip $xctrl crazy, absorb(geoid dbin day_sip) cluster(stateid) 
eststo: qui reghdfe logy lcc lcbs lcc_divEMP* lcn lcn1 soe sip sip_divEMP* scs lcc_sip lcc_sip_divEMP* lcbs_sip $xctrl crazy, absorb(geoid dbin) cluster(stateid) 
eststo: qui reghdfe logy lcc lcbs lcc_divEMP* lcn lcn1 soe sip sip_divEMP* scs lcc_sip lcc_sip_divEMP* lcbs_sip $xctrl crazy, absorb(geoid dbin epiday_s) cluster(stateid) 
eststo: qui reghdfe logy lcc lcbs lcc_divEMP* lcn lcn1 soe sip sip_divEMP* scs lcc_sip lcc_sip_divEMP* lcbs_sip $xctrl crazy, absorb(geoid dbin epiday_s day_sip) cluster(stateid) 

eststo: qui reghdfe logy lcs lcbs lcn lcn1 soe sip scs lcs_sip lcbs_sip $xctrl crazy, absorb(geoid dbin) cluster(stateid) 
eststo: qui reghdfe logy lcs lcbs lcn lcn1 soe sip scs lcs_sip lcbs_sip $xctrl crazy, absorb(geoid dbin epiday_s) cluster(stateid) 
eststo: qui reghdfe logy lcs lcbs lcn lcn1 soe sip scs lcs_sip lcbs_sip $xctrl crazy, absorb(geoid dbin day_sip) cluster(stateid) 
eststo: qui reghdfe logy lcs lcbs lcs_divEMP* lcn lcn1 soe sip sip_divEMP* scs lcs_sip lcs_sip_divEMP* lcbs_sip $xctrl crazy, absorb(geoid dbin) cluster(stateid) 
eststo: qui reghdfe logy lcs lcbs lcs_divEMP* lcn lcn1 soe sip sip_divEMP* scs lcs_sip lcs_sip_divEMP* lcbs_sip $xctrl crazy, absorb(geoid dbin epiday_s) cluster(stateid) 
eststo: qui reghdfe logy lcs lcbs lcs_divEMP* lcn lcn1 soe sip sip_divEMP* scs lcs_sip lcs_sip_divEMP* lcbs_sip $xctrl crazy, absorb(geoid dbin epiday_s day_sip) cluster(stateid) 

eststo: qui reghdfe logy lcc lcbs lcs lcn lcn1 soe sip scs lcc_sip lcs_sip lcbs_sip $xctrl crazy, absorb(geoid dbin) cluster(stateid) 
eststo: qui reghdfe logy lcc lcbs lcs lcn lcn1 soe sip scs lcc_sip lcs_sip lcbs_sip $xctrl crazy, absorb(geoid dbin epiday_s) cluster(stateid) 
eststo: qui reghdfe logy lcc lcbs lcs lcn lcn1 soe sip scs lcc_sip lcs_sip lcbs_sip $xctrl crazy, absorb(geoid dbin day_sip) cluster(stateid) 
eststo: qui reghdfe logy lcc lcbs lcs lcc_divEMP* lcs_divEMP* lcn lcn1 soe sip sip_divEMP* scs lcc_sip lcs_sip lcc_sip_divEMP* lcs_sip_divEMP* lcbs_sip $xctrl crazy, absorb(geoid dbin) cluster(stateid) 
eststo: qui reghdfe logy lcc lcbs lcs lcc_divEMP* lcs_divEMP* lcn lcn1 soe sip sip_divEMP* scs lcc_sip lcs_sip lcc_sip_divEMP* lcs_sip_divEMP* lcbs_sip $xctrl crazy, absorb(geoid dbin epiday_s) cluster(stateid) 
eststo: qui reghdfe logy lcc lcbs lcs lcc_divEMP* lcs_divEMP* lcn lcn1 soe sip sip_divEMP* scs lcc_sip lcs_sip lcc_sip_divEMP* lcs_sip_divEMP* lcbs_sip $xctrl crazy, absorb(geoid dbin epiday_s day_sip) cluster(stateid) 
esttab using $path/results/table_cbs.csv, replace se r2 drop(_cons $xctrl)




*** 4.lncc: log of new county case as the indendent variable rather than cumulative county case
eststo clear
eststo: qui reghdfe logy lncc lncn lncn1 soe sip scs lncc_sip $xctrl crazy, absorb(geoid dbin) cluster(stateid) 
eststo: qui reghdfe logy lncc lncn lncn1 soe sip scs lncc_sip $xctrl crazy, absorb(geoid dbin epiday_s) cluster(stateid) 
eststo: qui reghdfe logy lncc lncn lncn1 soe sip scs lncc_sip $xctrl crazy, absorb(geoid dbin day_sip) cluster(stateid) 
eststo: qui reghdfe logy lncc lncc_divEMP* lncn lncn1 soe sip sip_divEMP* scs lncc_sip lncc_sip_divEMP* $xctrl crazy, absorb(geoid dbin) cluster(stateid) 
eststo: qui reghdfe logy lncc lncc_divEMP* lncn lncn1 soe sip sip_divEMP* scs lncc_sip lncc_sip_divEMP* $xctrl crazy, absorb(geoid dbin epiday_s) cluster(stateid)
eststo: qui reghdfe logy lncc lncc_divEMP* lncn lncn1 soe sip sip_divEMP* scs lncc_sip lncc_sip_divEMP* $xctrl crazy, absorb(geoid dbin epiday_s day_sip) cluster(stateid) 
esttab using $path/results/table_lncc.csv, replace se r2 drop(_cons $xctrl)

*** 5.lncs: log of new state case as the indendent variable rather than cumulative state case
eststo clear
eststo: qui reghdfe logy lncs lncn lncn1 soe sip scs lncs_sip $xctrl crazy, absorb(geoid dbin) cluster(stateid) 
eststo: qui reghdfe logy lncs lncn lncn1 soe sip scs lncs_sip $xctrl crazy, absorb(geoid dbin epiday_s) cluster(stateid) 
eststo: qui reghdfe logy lncs lncn lncn1 soe sip scs lncs_sip $xctrl crazy, absorb(geoid dbin day_sip) cluster(stateid) 
eststo: qui reghdfe logy lncs lncc_divEMP* lncn lncn1 soe sip sip_divEMP* scs lncs_sip lncs_sip_divEMP* $xctrl crazy, absorb(geoid dbin) cluster(stateid) 
eststo: qui reghdfe logy lncs lncc_divEMP* lncn lncn1 soe sip sip_divEMP* scs lncs_sip lncs_sip_divEMP* $xctrl crazy, absorb(geoid dbin epiday_s) cluster(stateid) 
eststo: qui reghdfe logy lncs lncc_divEMP* lncn lncn1 soe sip sip_divEMP* scs lncs_sip lncs_sip_divEMP* $xctrl crazy, absorb(geoid dbin epiday_s day_sip) cluster(stateid) 
esttab using $path/results/table_lncs.csv, replace se r2 drop(_cons $xctrl)

*** 6.lncc lncs: use both log of new county and state case rather than cumulative county and state case
eststo clear
eststo: qui reghdfe logy lncc lncs lncn lncn1 soe sip scs lncc_sip lncs_sip $xctrl crazy, absorb(geoid dbin) cluster(stateid) 
eststo: qui reghdfe logy lncc lncs lncn lncn1 soe sip scs lncc_sip lncs_sip $xctrl crazy, absorb(geoid dbin epiday_s) cluster(stateid) 
eststo: qui reghdfe logy lncc lncs lncn lncn1 soe sip scs lncc_sip lncs_sip $xctrl crazy, absorb(geoid dbin day_sip) cluster(stateid) 
eststo: qui reghdfe logy lncc lncs lncc_divEMP* lncs_divEMP* lncn lncn1 soe sip sip_divEMP* scs lncc_sip lncs_sip lncc_sip_divEMP* lncs_sip_divEMP* $xctrl crazy, absorb(geoid dbin) cluster(stateid) 
eststo: qui reghdfe logy lncc lncs lncc_divEMP* lncs_divEMP* lncn lncn1 soe sip sip_divEMP* scs lncc_sip lncs_sip lncc_sip_divEMP* lncs_sip_divEMP* $xctrl crazy, absorb(geoid dbin epiday_s) cluster(stateid) 
eststo: qui reghdfe logy lncc lncs lncc_divEMP* lncs_divEMP* lncn lncn1 soe sip sip_divEMP* scs lncc_sip lncs_sip lncc_sip_divEMP* lncs_sip_divEMP* $xctrl crazy, absorb(geoid dbin epiday_s day_sip) cluster(stateid) 
esttab using $path/results/table_lncclncs.csv, replace se r2 drop(_cons $xctrl)






*** 7.ldc: log of county death specification (rather than cumulative county case or new case)
eststo clear
eststo: qui reghdfe logy ldc ldn ldn1 soe sip scs ldc_sip $xctrl crazy, absorb(geoid dbin) cluster(stateid) 
eststo: qui reghdfe logy ldc ldn ldn1 soe sip scs ldc_sip $xctrl crazy, absorb(geoid dbin epiday_s) cluster(stateid) 
eststo: qui reghdfe logy ldc ldn ldn1 soe sip scs ldc_sip $xctrl crazy, absorb(geoid dbin day_sip) cluster(stateid) 
eststo: qui reghdfe logy ldc ldc_divEMP* ldn ldn1 soe sip sip_divEMP* scs ldc_sip ldc_sip_divEMP* $xctrl crazy, absorb(geoid dbin) cluster(stateid) 
eststo: qui reghdfe logy ldc ldc_divEMP* ldn ldn1 soe sip sip_divEMP* scs ldc_sip ldc_sip_divEMP* $xctrl crazy, absorb(geoid dbin epiday_s) cluster(stateid) 
eststo: qui reghdfe logy ldc ldc_divEMP* ldn ldn1 soe sip sip_divEMP* scs ldc_sip ldc_sip_divEMP* $xctrl crazy, absorb(geoid dbin epiday_s day_sip) cluster(stateid) 
esttab using $path/results/table_ldc.csv, replace se r2 drop(_cons $xctrl)

*** 8.lds: log of state death specification (rather than cumulative state case or new case)
eststo clear
eststo: qui reghdfe logy lds ldn ldn1 soe sip scs lds_sip $xctrl crazy, absorb(geoid dbin) cluster(stateid) 
eststo: qui reghdfe logy lds ldn ldn1 soe sip scs lds_sip $xctrl crazy, absorb(geoid dbin epiday_s) cluster(stateid) 
eststo: qui reghdfe logy lds ldn ldn1 soe sip scs lds_sip $xctrl crazy, absorb(geoid dbin day_sip) cluster(stateid) 
eststo: qui reghdfe logy lds lds_divEMP* ldn ldn1 soe sip sip_divEMP* scs lds_sip lds_sip_divEMP* $xctrl crazy, absorb(geoid dbin) cluster(stateid) 
eststo: qui reghdfe logy lds lds_divEMP* ldn ldn1 soe sip sip_divEMP* scs lds_sip lds_sip_divEMP* $xctrl crazy, absorb(geoid dbin epiday_s) cluster(stateid) 
eststo: qui reghdfe logy lds lds_divEMP* ldn ldn1 soe sip sip_divEMP* scs lds_sip lds_sip_divEMP* $xctrl crazy, absorb(geoid dbin epiday_s day_sip) cluster(stateid) 
esttab using $path/results/table_lds.csv, replace se r2 drop(_cons $xctrl)

*** 9.ldc lds: both of log of county and state death specification
eststo clear
eststo: qui reghdfe logy ldc lds ldn ldn1 soe sip scs ldc_sip lds_sip $xctrl crazy, absorb(geoid dbin) cluster(stateid) 
eststo: qui reghdfe logy ldc lds ldn ldn1 soe sip scs ldc_sip lds_sip $xctrl crazy, absorb(geoid dbin epiday_s) cluster(stateid) 
eststo: qui reghdfe logy ldc lds ldn ldn1 soe sip scs ldc_sip lds_sip $xctrl crazy, absorb(geoid dbin day_sip) cluster(stateid) 
eststo: qui reghdfe logy ldc lds ldc_divEMP* lds_divEMP* ldn ldn1 soe sip sip_divEMP* scs ldc_sip lds_sip ldc_sip_divEMP* lds_sip_divEMP* $xctrl crazy, absorb(geoid dbin) cluster(stateid)
eststo: qui reghdfe logy ldc lds ldc_divEMP* lds_divEMP* ldn ldn1 soe sip sip_divEMP* scs ldc_sip lds_sip ldc_sip_divEMP* lds_sip_divEMP* $xctrl crazy, absorb(geoid dbin epiday_s) cluster(stateid)  
eststo: qui reghdfe logy ldc lds ldc_divEMP* lds_divEMP* ldn ldn1 soe sip sip_divEMP* scs ldc_sip lds_sip ldc_sip_divEMP* lds_sip_divEMP* $xctrl crazy, absorb(geoid dbin epiday_s day_sip) cluster(stateid) 
esttab using $path/results/table_ldclds.csv, replace se r2 drop(_cons $xctrl)





*** 10. lcc lncc ldc: include county case, new county case, and county death in the same regression
eststo clear
eststo: qui reghdfe logy lcc lcn lcn1 lncc lncn lncn1 ldc ldn ldn1 soe sip scs lcc_sip lncc_sip ldc_sip $xctrl crazy, absorb(geoid dbin) cluster(stateid) 
eststo: qui reghdfe logy lcc lcn lcn1 lncc lncn lncn1 ldc ldn ldn1 soe sip scs lcc_sip lncc_sip ldc_sip $xctrl crazy, absorb(geoid dbin epiday_s) cluster(stateid) 
eststo: qui reghdfe logy lcc lcn lcn1 lncc lncn lncn1 ldc ldn ldn1 soe sip scs lcc_sip lncc_sip ldc_sip $xctrl crazy, absorb(geoid dbin day_sip) cluster(stateid) 
eststo: qui reghdfe logy lcc lcn lcn1 lncc lncn lncn1 ldc ldn ldn1 soe sip scs lcc_sip lncc_sip ldc_sip sip_divEMP* lcc_divEMP* lncc_divEMP* ldc_divEMP* lcc_sip_divEMP* lncc_sip_divEMP* ldc_sip_divEMP* $xctrl crazy, absorb(geoid dbin) cluster(stateid) 
eststo: qui reghdfe logy lcc lcn lcn1 lncc lncn lncn1 ldc ldn ldn1 soe sip scs lcc_sip lncc_sip ldc_sip sip_divEMP* lcc_divEMP* lncc_divEMP* ldc_divEMP* lcc_sip_divEMP* lncc_sip_divEMP* ldc_sip_divEMP* $xctrl crazy, absorb(geoid dbin epiday_s) cluster(stateid) 
eststo: qui reghdfe logy lcc lcn lcn1 lncc lncn lncn1 ldc ldn ldn1 soe sip scs lcc_sip lncc_sip ldc_sip sip_divEMP* lcc_divEMP* lncc_divEMP* ldc_divEMP* lcc_sip_divEMP* lncc_sip_divEMP* ldc_sip_divEMP* $xctrl crazy, absorb(geoid dbin epiday_s day_sip) cluster(stateid) 
esttab using $path/results/table_lcclnccldc.csv, replace se r2 drop(_cons $xctrl)
