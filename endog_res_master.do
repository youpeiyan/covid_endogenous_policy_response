set more off
clear

***************************************************************************************************
******** Please download and merge the necessary data using data_import.R & data_import.do ******** 
***************************************************************************************************
********************** Please run data_clean.do for the pre-cleaning process **********************
***************************************************************************************************
**** Function of this file: Master file for all  the main regression and the robustness checks ****
***************************************************************************************************

global path "/Users/youpei/Downloads/Yale/COVID19_ER" // You can change it to your local path


//do $path/data_importER.do
//do $path/data_cleanER.do

global xctrl1 precip rmax rmin srad tmin tmax wind_speed week_*     // control group 1: weather and weekday fixed effects
global xctrl2 $xctrl1 DFE_*           								// control group 2: with daily FE (note: this is used for partial identification only
global xctrl3 $xctrl1 epiDFEs_*										// control group 3: with epidemic day's FE (based on county-case report)
global xctrl4 $xctrl1 sipDFE_*										// control group 4: with shelter-in-place (stay-home) policy's day FE
global xctrl5 $xctrl1 $borderc										
//global xctrl6 $xctrl1 $borderd 									// control group 5-7: border states' cases, deaths, and both. We report border states' cases in the main robustness checks only.
//global xctrl7 $xctrl1 $bordercd

global borderc cbs cbs_sip
//global borderd dbs dbs_sip
//global bordercd cbs dbs cbs_sip dbs_sip

use "$path/endog_res_final.dta", clear



**************************************
**** Adjust the Study Period Here ****
**************************************

//keep if date >= 21970 & date <= 22014 // the original submission study period
keep if date >= 21945 & date <= 22026

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

******************************************************
**** Regression: regular level-case/death reports ****
******************************************************

global resultgroup "/Users/youpei/Downloads/Yale/COVID19_ER/results/group1" 
do $path/endog_res_groups.do

****************************************************
**** Regression: regular log-case/death reports ****
****************************************************
// change all the case or death values to its log form.

foreach case in cc cs cn cn1 ///
				dc ds dn dn1 ///
				ncc ncs ncn ///
				ndc nds ndn ///
				cbs dbs {
replace `case' = l`case'	
}

global resultgroup "/Users/youpei/Downloads/Yale/COVID19_ER/results/group2" 
do $path/endog_res_groups.do

*************************************************
**** Other Robustness Checks not in the loop ****
*************************************************

do $path/endog_res_robust_misc.do

********************
**** POI visits ****
********************

do $path/endog_res_robust_misc2.do

***************************************************
**** Partial Identification using the Daily FE ****
***************************************************

do $path/endog_res_robust_misc3.do

*****************************************
**** Use Days since stay-home policy ****
*****************************************

do $path/endog_res_robust_misc4.do
