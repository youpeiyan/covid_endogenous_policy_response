set more off
clear

******************************************************************************************
******** Please download the necessary data from Google Drive using data_import.R ********
******************************************************************************************
**** Function of this file: Import raw data to dta; Clean; and Merge to the final dta ****
******************************************************************************************

global path "/Users/youpei/Downloads/Yale/COVID19_ER" // You can change it to your local path

******************************************
*** Import New York Times Case Reports ***
******************************************
import delimited "https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-counties.csv", encoding(ISO-8859-1) clear // Note: the data only report cases after the first case occured in a county
gen time = date(date,"YMD")
drop date
rename time date
format date %td
bysort fips: egen first_c_county = min(date)
format first_c_county %td // provide the date of the first case report in a county
rename fips geoid
replace geoid = 36061 if county == "New York City" & state == "New York" & geoid == .	
drop if geoid == .

rename cases case_county
rename deaths death_county

save "$path/NYT.dta", replace

** Import the original version's NYT data for comparison
import excel "/Users/youpei/Downloads/Yale/COVID19_ER/NYT418.xlsx", sheet("Sheet1") firstrow clear
format date %td
bysort fips: egen occ1 = min(date)
format occ1 %td // provide the date of the first case report in a county
rename fips geoid
replace geoid = 36061 if county == "New York City" & state == "New York" & geoid == .	
drop if geoid == .

rename cases occ
rename deaths odc

keep geoid date occ odc occ1
save "$path/NYTo.dta", replace

*******************************************
*** Import County-level Population Data ***
*******************************************
import delimited "https://www2.census.gov/programs-surveys/popest/datasets/2010-2019/counties/totals/co-est2019-alldata.csv", encoding(ISO-8859-1) clear 
gen geoid = state * 1000 + county
drop if county == 0
rename popestimate2019 pop19
keep geoid pop19
save "$path/pop19.dta", replace

***************************
*** Import Weather Data ***
***************************
import delimited "$path/weather_county.csv", encoding(ISO-8859-1) clear
gen time = date(date,"YMD")
format time %td
drop date
rename time date
rename county geoid
save "$path/weather.dta", replace

****************************
*** Import Dwelling Time ***
****************************
import delimited "$path/all_counties_current.csv", encoding(ISO-8859-1)clear
gen time = date(date,"YMD")
format time %td
drop date
rename time date
rename state_name State // to separate from NYT data's state.
save "$path/all_counties.dta", replace

****************************
*** Import County Policy ***
****************************
import excel "$path/sip.xlsx", sheet("Sheet2") clear
rename A state
rename B county
rename C sip
drop D
duplicates drop
sort county state
by county state: egen sip_c2 = min(sip)
drop sip
duplicates drop
format sip_c2 %td
merge 1:1 state county using "$path/county_fips.dta", keep(match) nogen
drop state county
save "$path/county_sip.dta", replace

import delimited "$path/county_policy.csv", encoding(ISO-8859-1) clear // We download this policy data from National Association of Counties. (https://ce.naco.org/?dset=COVID-19&ind=Emergency%20Declaration%20Types)
keep fips countyemergencydeclarationdate saferathomepolicydate businessclosurepolicydate county state
rename fips geoid
rename countyemergencydeclarationdate soe_c
rename saferathomepolicydate sip_c
rename businessclosurepolicydate cnb_c
replace soe_c = subinstr(soe_c," 00:00:00","",.)

foreach day in soe_c sip_c cnb_c {
gen t`day' = date(`day',"YMD")
format t`day' %td
drop `day'
rename t`day' `day'
} 

merge 1:1 geoid using "$path/county_sip.dta", nogen
gen sip_c0 = sip_c
replace sip_c0 = sip_c2 if sip_c2 < sip_c
format sip_c0 %td
drop sip_c sip_c2
rename sip_c0 sip_c
save "$path/county_policy.dta", replace

erase "$path/county_sip.dta"

***************************
*** Import State Policy ***
***************************
import excel "$path/state_policy.xlsx", sheet("State of Emergency") firstrow clear
rename Stateofemergency soe_s
drop if State == "Total with each policy (out of 51 with DC)" | State == ""
keep State soe_s
save "$path/state_soe.dta", replace

import excel "$path/state_policy.xlsx", sheet("Physical Distance Closures") firstrow clear
rename DateclosedK12schools cks_s
rename Closednonessentialbusinesses cnb_s
drop if State == "Total with each policy (out of 51 with DC)" | State == ""
keep State cks_s cnb_s
save "$path/state_pdc.dta", replace

/* There are typos in Raifman's file, we use the updated version from NYT
import excel "$path/state_policy.xlsx", sheet("Stay at Home") firstrow clear
rename Stayathomeshelterinplace sip_s
drop if State == "Total with each policy (out of 51 with DC)" | State == ""
keep State sip_s
save "$path/state_sip.dta", replace
*/
import excel "$path/sip.xlsx", sheet("Sheet1") firstrow clear
rename Stayathomeshelterinplace sip_s
drop if State == "Total with each policy (out of 51 with DC)" | State == ""
keep State sip_s
save "$path/state_sip.dta", replace

import delimited "$path/state_closures.csv", encoding(ISO-8859-1) clear
rename v3 State
drop v1
gen scs = date(v2, "YMD")
format scs %td
keep State scs
save "$path/state_scs.dta", replace

use "$path/state_soe.dta", clear
merge 1:1 State using "$path/state_pdc.dta", nogen
merge 1:1 State using "$path/state_sip.dta", nogen
merge 1:1 State using "$path/state_scs.dta", nogen

foreach day in cks_s sip_s {
gen t`day' = date(`day',"DMY")
format t`day' %td
drop `day'
rename t`day' `day'
} 

foreach order in soe_s cks_s cnb_s sip_s {
gen yr_`order' = yofd(`order') 		   
replace `order' = . if yr_`order' == 1899	
drop yr_`order'	
}
  
save "$path/state_policy.dta", replace

foreach dta in soe pdc sip scs {
erase "$path/state_`dta'.dta"
}

*************************************
*** Import Rural/Metro Definition ***
*************************************
import excel "$path/metro.xls", sheet("Rural-urban Continuum Code 2013") firstrow clear // We adopt the metro/non-metro definitioin from the ERS 2013 Rural-Urban Continuum Codes (https://www.ers.usda.gov/data-products/rural-urban-continuum-codes.aspx)
destring FIPS, replace
rename FIPS geoid
split Description, parse( - )
gen metro =(Description1 == "Metro ")
keep geoid metro
save "$path/metro.dta", replace

***********************************
*** Bordering State Information ***
***********************************
use "$path/border_county.dta", clear
gen borderstate_id = ST2
replace borderstate_id = ST1 if borderstate_id == state_id
rename state_id ownstate_id
keep ownstate_id geoid borderstate_id
sort geoid
sort geoid borderstate_id
 by geoid: gen j = _n
 merge 1:1 geoid j using "$path/geoid_border.dta", nogen
 sort geoid
 by geoid: egen ownstate_id_mean = mean(ownstate_id)
 drop ownstate_id
 rename ownstate_id_mean ownstate_id
 reshape wide borderstate_id, i(geoid ownstate_id) j(j)
// save "$path/bordercounty_id.dta", replace
drop geoid
duplicates drop
rename ownstate_id stateid
save "$path/borderstate_id.dta", replace

**********************
*** Merge Datasets ***
**********************
use "$path/NYT.dta", clear
merge 1:1 geoid date using "$path/NYTo.dta", nogen // merge with the original NYT data, because there are updates for old case/death reports.
merge 1:1 geoid date using "$path/all_counties.dta", nogen
merge 1:1 geoid date using "$path/weather.dta", nogen
merge 1:1 geoid date using "$path/day_visit_sum", nogen //Import Normalized Visits to stores and entertainment sites
sort geoid date
xtset geoid date

replace State = state if State == ""
drop state
merge n:1 State using "$path/state_policy.dta", nogen	
merge n:1 geoid using "$path/county_policy.dta", nogen
merge n:1 geoid using "$path/metro.dta", nogen
merge n:1 geoid using "$path/pop19.dta", nogen
merge n:1 geoid using "$path/scs_c.dta", nogen

/*
replace State = "Alaska" if geoid == 2270
replace State = "South Dakota" if geoid == 46113
replace State = "Virginia" if geoid == 51515
*/

drop county 
gen stateid = int(geoid/1000)
rename case_county cc
rename death_county dc
bysort date State: egen cs = sum(cc) // create state-level cases and deaths
bysort date State: egen ds = sum(dc)
bysort date: egen cn = sum(cc) // create national-level cases and deaths
bysort date: egen dn = sum(dc)

bysort date State: egen ocs = sum(occ) // create state-level cases and deaths
bysort date State: egen ods = sum(odc)
bysort date: egen ocn = sum(occ) // create national-level cases and deaths
bysort date: egen odn = sum(odc)
foreach NYT_var in cc dc occ odc {
replace `NYT_var' = 0 if `NYT_var' == .
} // This step fills the case and death to 0 before the first reported case

bysort geoid: egen cc1 = mean(first_c_county) // fill the missing first-case report date in each county
format cc1 %td // cc1 is the first case reported in a county
bysort stateid: egen cs1 = min(cc1) // cs1 is the first case reported in a state
format cs1 %td
drop first_c_county

merge n:1 stateid using "$path/borderstate_id.dta", nogen

**********************************************
** find states' aggregated cases and deaths ** 
**********************************************

** create a state-level case and death reports dataset 
preserve
keep geoid date cc dc pop19
gen border_stateid = int(geoid / 1000)
collapse (sum) cc dc pop19, by(border_stateid date)
rename cc cbs
rename dc dbs // case and death use to merge as in the border state
rename pop19 pop19bs
gen cbs_pop = cbs/pop19bs
gen dbs_pop = dbs/pop19bs
save "$path/state_cases.dta", replace
restore

forval i = 1/8 {
rename borderstate_id`i' border_stateid
merge n:1 border_stateid date using "$path/state_cases.dta"
drop if _merge == 2
drop _merge
rename border_stateid borderstate_id`i' 
rename cbs cbs`i'
rename dbs dbs`i'
rename pop19bs pop19bs`i'
rename cbs_pop cbs_pop`i'
rename dbs_pop dbs_pop`i'
}
forval i = 1/8 {
drop borderstate_id`i'
replace cbs`i' = 0 if cbs`i' == .
replace dbs`i' = 0 if dbs`i' == .
replace cbs_pop`i' = 0 if cbs_pop`i' == .
replace dbs_pop`i' = 0 if dbs_pop`i' == .
}
gen cbs = cbs1 + cbs2 + cbs3 + cbs4 + cbs5 + cbs6 + cbs7 + cbs8
gen dbs = dbs1 + dbs2 + dbs3 + dbs4 + dbs5 + dbs6 + dbs7 + dbs8
gen cbs_pop = cbs_pop1 + cbs_pop2 + cbs_pop3 + cbs_pop4 + cbs_pop5 + cbs_pop6 + cbs_pop7 + cbs_pop8
gen dbs_pop = dbs_pop1 + dbs_pop2 + dbs_pop3 + dbs_pop4 + dbs_pop5 + dbs_pop6 + dbs_pop7 + dbs_pop8
forval i = 1/8 {
drop cbs`i'
drop dbs`i'
drop pop19bs`i'
drop cbs_pop`i'
drop dbs_pop`i'
}


** create a state-level case and death reports dataset from the original NYT data
preserve
keep geoid date occ odc pop19
gen border_stateid = int(geoid / 1000)
collapse (sum) occ odc pop19, by(border_stateid date)
rename occ ocbs
rename odc odbs // case and death use to merge as in the border state
rename pop19 pop19bs
gen ocbs_pop = ocbs/pop19bs
gen odbs_pop = odbs/pop19bs
save "$path/state_ocases.dta", replace
restore

merge n:1 stateid using "$path/borderstate_id.dta", nogen

forval i = 1/8 {
rename borderstate_id`i' border_stateid
merge n:1 border_stateid date using "$path/state_ocases.dta"
drop if _merge == 2
drop _merge
rename border_stateid borderstate_id`i' 
rename ocbs ocbs`i'
rename odbs odbs`i'
rename pop19bs pop19bs`i'
rename ocbs_pop ocbs_pop`i'
rename odbs_pop odbs_pop`i'
}
forval i = 1/8 {
drop borderstate_id`i'
replace ocbs`i' = 0 if ocbs`i' == .
replace odbs`i' = 0 if odbs`i' == .
replace ocbs_pop`i' = 0 if ocbs_pop`i' == .
replace odbs_pop`i' = 0 if odbs_pop`i' == .
}
gen ocbs = ocbs1 + ocbs2 + ocbs3 + ocbs4 + ocbs5 + ocbs6 + ocbs7 + ocbs8
gen odbs = odbs1 + odbs2 + odbs3 + odbs4 + odbs5 + odbs6 + odbs7 + odbs8
gen ocbs_pop = ocbs_pop1 + ocbs_pop2 + ocbs_pop3 + ocbs_pop4 + ocbs_pop5 + ocbs_pop6 + ocbs_pop7 + ocbs_pop8
gen odbs_pop = odbs_pop1 + odbs_pop2 + odbs_pop3 + odbs_pop4 + odbs_pop5 + odbs_pop6 + odbs_pop7 + odbs_pop8
forval i = 1/8 {
drop ocbs`i'
drop odbs`i'
drop pop19bs`i'
drop ocbs_pop`i'
drop odbs_pop`i'
}

drop if geoid >= 57000 
drop if precip == .
save "$path/endog_res.dta", replace
