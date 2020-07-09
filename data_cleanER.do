set more off
clear

***************************************************************************************************
******** Please download and merge the necessary data using data_import.R & data_import.do ********
***************************************************************************************************
************************ Function of this file: Create necessary variables ************************
***************************************************************************************************

use "$path/endog_res.dta", clear

******************************************	 
** generate log terms of cases & deaths **
******************************************	

** generate newly cases and deaths at the county, state, and national level
xtset geoid date
gen ncc = d.cc
gen ncs = d.cs
gen ncn = d.cn	 
gen ncbs = d.cbs

gen ndc = d.dc
gen nds = d.ds
gen ndn = d.dn	
gen ndbs = d.dbs 

/*
gen nocc = d.occ
gen nocs = d.ocs
gen nocn = d.ocn	 
gen nocbs = d.ocbs

gen nodc = d.odc
gen nods = d.ods
gen nodn = d.odn	
gen nodbs = d.odbs 
*/

** since some are negative, we create a dummy to represent the negativity of them.
foreach var in ncc ncs ndc nds  {
gen l`var'_ng = (`var' < 0)
replace `var' = 0 if `var' < 0
}
	 
foreach case in cc dc cs ds cn dn ///
				ncc ndc ncs nds ncn ndn ///
				cbs dbs {
gen l`case' = log(`case' + 1)			
}

*****************************************
** generate log terms of dwelling time **
*****************************************
rename median_home_dwell_time y 
rename median_non_home_dwell_time ny

gen logy = log(y+1)
gen logny = log(ny+1)

** create the lead of the dependent variables, so the regression can be done for lagged case reports
xtset geoid date
foreach lhs in y ny logy logny {
gen `lhs'_f = f.`lhs'
}

*********************************************
** generate case/death share by population **
*********************************************
sort stateid date
by stateid date: egen state_pop = sum(pop19)
sort date
by date: egen national_pop = sum(pop19)

foreach case in cc dc ncc ndc {
gen `case'_pop = `case'/ pop19	
gen l`case'_pop = log(`case'_pop + 1)	
}
foreach case in cs ds ncs nds  {
gen `case'_pop = `case'/ state_pop	
gen l`case'_pop = log(`case'_pop + 1)	
}
foreach case in cn dn ncn ndn  {
gen `case'_pop = `case'/ national_pop	
gen l`case'_pop = log(`case'_pop + 1)	
}

foreach case in cbs dbs {
gen l`case'_pop = log(`case'_pop + 1)	
}

foreach case in ncc ncs ndc nds {
replace l`case'_pop = 0 if l`case'_ng == 1
}

***************************************
** generate case/death increase rate **
***************************************
xtset geoid date
foreach case in cc cs cn ///
				dc ds dn ///
				cbs dbs {
gen `case'_rate = n`case'/l.`case'
replace `case'_rate = 0 if l.`case' == 0
}

**************************************************************
** generate policy dummies and days since the policy issued **
**************************************************************
rename scs scs_s
foreach order in soe sip cnb scs {
gen no_`order' = (`order'_s == . & `order'_c == .)

gen `order'd = `order'_s
replace `order'd = `order'_c if `order'_c < `order'_s         // replace the state-level state-of-emergency, shelter-in-place/stay-at-home, close non-essential business order to the county-level, if the county-level policies are ealier
gen `order' = (date>=`order'd)                                // create the policy dummy for dates after the policy is issued
//replace `order' = 0 if no_`order' == 1
gen day_`order' = date - `order'd                             // generate days since the policy issued
replace day_`order' = 0 if day_`order' < 0 | no_`order' == 1  // replace the negative days to 0
gen lday_`order' = log(day_`order' + 1)                       // the log term of the days since the policy issued
} 

****************************
** generate weekday dummy **
****************************
gen weekday = dow(date)
qui tabulate weekday, generate(week_)
drop weekday week_7

**************************************************************************
** generate days since the first case at the county and the state level ** // later can be used to create epidemic day's daily fixed effects
**************************************************************************
gen epiday_c = (date - cc1 + 1)
gen epiday_s = (date - cs1 + 1)


************************************************************************************
** generate interaction of national case and the first report at the county-level **
************************************************************************************

gen cc1y = (date >= cc1)
gen cn1 = cn * cc1y
gen lcn1 = lcn * cc1y
gen cn1_pop = cn1/national_pop
gen lcn1_pop = log(cn1_pop + 1)

gen dn1 = dn * cc1y
gen ldn1 = ldn * cc1y

save "$path/endog_res_final.dta", replace
