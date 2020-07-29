****************************************************************************************
**** Function of this file: Lists of Regressions for all possible Robustness Checks ****
****************************************************************************************

eststo: qui reghdfe $LHS $case soe sip scs $case_sip $xctrl, absorb(geoid dbin) cluster(stateid) 
eststo: qui reghdfe $LHS $case1 soe sip scs $case_sip $xctrl, absorb(geoid dbin) cluster(stateid) 

/* OLD MODELS. If the reviewers are interested in any of the following model specifications, simply move the corresponding model above
** Regression: no interaction
eststo: qui reghdfe $LHS $case soe sip scs $xctrl, absorb(geoid dbin) cluster(stateid) 
eststo: qui reghdfe $LHS $case soe sip scs day_sip $xctrl, absorb(geoid dbin) cluster(stateid) 
eststo: qui reghdfe $LHS $case soe sip scsay_sip $xctrl, absorb(geoid dbin) cluster(stateid) 

** Regression: interact policy dummy
eststo: qui reghdfe $LHS $case soe sip scs $case_sip $xctrl, absorb(geoid dbin) cluster(stateid)  
eststo: qui reghdfe $LHS $case soe sip scs $case_soe $case_sip $xctrl, absorb(geoid dbin) cluster(stateid)  
 
** Regression: interact policy day
eststo: qui reghdfe $LHS $case soe sip scs $case_day_sip $xctrl, absorb(geoid dbin) cluster(stateid)  
eststo: qui reghdfe $LHS $case soe scs $case_lday_sip $xctrl, absorb(geoid dbin) cluster(stateid)  
eststo: qui reghdfe $LHS $case soe sip scs $case_lday_sip $xctrl, absorb(geoid dbin) cluster(stateid)  
eststo: qui reghdfe $LHS $case soe sip scs $case_day_soe $case_day_sip $xctrl, absorb(geoid dbin) cluster(stateid)  
eststo: qui reghdfe $LHS $case soe sip scs $case_lday_soe $case_lday_sip $xctrl, absorb(geoid dbin) cluster(stateid)  
 

** Regression + national interaction: interact policy 
eststo: qui reghdfe $LHS $case soe sip scs $case_sip $ncase_sip $xctrl, absorb(geoid dbin) cluster(stateid)  
eststo: qui reghdfe $LHS $case soe sip scs $case_soe $case_sip $ncase_soe $ncase_sip $xctrl, absorb(geoid dbin) cluster(stateid)  
 
** Regression + national interaction: interact policy day
eststo: qui reghdfe $LHS $case soe sip scs $case_day_sip $ncase_day_sip $xctrl, absorb(geoid dbin) cluster(stateid)  
eststo: qui reghdfe $LHS $case soe sip scs $case_lday_sip $ncase_lday_sip $xctrl, absorb(geoid dbin) cluster(stateid)  
eststo: qui reghdfe $LHS $case soe sip scs $case_day_soe $case_day_sip $ncase_day_soe $ncase_day_sip $xctrl, absorb(geoid dbin) cluster(stateid)  
eststo: qui reghdfe $LHS $case soe sip scs $case_lday_soe $case_lday_sip $ncase_lday_soe $ncase_lday_sip $xctrl, absorb(geoid dbin) cluster(stateid)  
*/
