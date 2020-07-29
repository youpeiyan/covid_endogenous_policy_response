set more off
clear

*** May need the following package installation
//ssc install ftools
//ssc install reghdfe

*** Do data importing & cleaning 
//do $path/endog_res_data_import.do
//do $path/endog_res_clean.do

global path "/Users/youpei/Downloads/Yale/COVID19_ER" // You can change it to your local path

***************************************************************************************************
******** Please download and merge the necessary data using data_import.R & data_import.do ******** 
***************************************************************************************************
********************** Please run above 2 files for the pre-cleaning process **********************
***************************************************************************************************
**** Function of this file: Master file for all  the main regression and the robustness checks ****
***************************************************************************************************

use "$path/endog_res_final.dta", clear

*******************************************
**** Set the global group of variables ****
*******************************************

global xctrl1 precip rmax rmin srad tmin tmax wind_speed week_*     // control group 1: weather and weekday fixed effects
global xctrl2 $xctrl1 epiDFEs_*										// control group 2: with epidemic day's FE (based on county-case report)
global xctrl3 $xctrl1 sipDFE_*										// control group 3: with shelter-in-place (stay-home) policy's day FE
global xctrl4 $xctrl1 $borderc									    // control group 4: border states' cases. We report border states' cases in the main robustness checks only. For border death or both, If needed, set "global borderc dbs dbs_sip" or "global borderc cbs dbs cbs_sip dbs_sip"

global borderc cbs cbs_sip

*** Create Epidemic Daily FE 

gen epiDFEs_0 = (epiday_s<0)
forval day = 1/92 {   
gen epiDFEs_`day'= (epiday_s == `day')
}

*** Create Stay-home Daily FE

gen sipDFE_0 = (day_sip == 0)
forval day = 1/42 {   
gen sipDFE_`day'= (day_sip == `day')
}


******************************************************************
**** Adjust the Study Period and Add additional cleaning Here ****
******************************************************************

keep if date >= 21945 & date <= 22026 // two weeks before the earliest state of emergency & two weeks after the latest stay-home/shelter-in-place policy

drop if y <= 192					  // Remove the lowest 1% of dwell-time reports, because these data maybe mis-reported.
xtile dbin = device_count, nq(50)	  // Set the 50 bins based on device count in each county in a day

qui tab dbin, gen(dbin_)


************************************************************************************************************************************************************************
************************************************************************************************************************************************************************
************************************************************************************************************************************************************************


***********************************************************
**** Main Regression: regular level-case/death reports ****
***********************************************************
global resultgroup "$path/results/group1" 
do $path/endog_res_groups.do

*****************************************************************************************************************************************
**** Main Regression: regular level-case/death reports. To avoid bins of device_count create collinearity under the function reghdfe ****
*****************************************************************************************************************************************
global resultgroup "$path/results/group1" 
do $path/endog_res_groups_nobin.do



*********************************************************
**** Main Regression: regular log-case/death reports ****
*********************************************************
// change all the case or death values to its log form.

foreach case in cc cs cn cn1 ///
				dc ds dn dn1 ///
				ncc ncs ncn ncn1 ///
				ndc nds ndn ///
				cbs dbs {
replace `case' = l`case'	
}

global resultgroup "$path/results/group2" 
do $path/endog_res_groups.do

**************************************************************************************************************************************
**** Main Regression: regular log-case/death reports To avoid bins of device_count create collinearity under the function reghdfe ****
**************************************************************************************************************************************
// change all the case or death values to its log form.

foreach case in cc cs cn cn1 ///
				dc ds dn dn1 ///
				ncc ncs ncn ncn1 ///
				ndc nds ndn ///
				cbs dbs {
replace `case' = l`case'	
}

global resultgroup "$path/results/group2" 
do $path/endog_res_groups_nobin.do


************************************************************************************************************************************************************************
************************************************************************************************************************************************************************
************************************************************************************************************************************************************************

** The following do files can be run independently. You do not have to start from the beginning.

*************************************************
**** Other Robustness Checks not in the loop ****
*************************************************

do $path/endog_res_robust_group.do 						// separate by county groups & by population size. The population-share results are included

do $path/endog_res_robust_dcncc.do					 	// confirm that including death case & new county case along with cumulative county case will cause mis-identification

do $path/endog_res_robust_daysip.do 					// use days since stay-home policy in the control variable


**********************************
**** Point of Interest Visits ****
**********************************

do $path/endog_res_robust_POI.do


***************************************************
**** Partial Identification using the Daily FE ****
***************************************************

do $path/endog_res_robust_partial.do 					// Partial identification regression

do $path/endog_res_robust_partial_plot_loglog.do 		// The partial identification experiment plot (Figure 3 in the main text) using the log-log model.


***************
**** Plots ****
***************

do $path/endog_res_plot_fig2.do

do $path/endog_res_plot_fig5.do 						// Use the county-case report for counterfactural analysis
do $path/endog_res_plot_fig5_state.do 				    // Use the state-case report for counterfactural analysis

