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
bysort date state: egen case_state = sum(case_county) // create state-level cases and deaths
bysort date state: egen death_state = sum(death_county)
bysort date: egen case_national = sum(case_county) // create national-level cases and deaths
bysort date: egen death_national = sum(death_county)

save "$path/NYT.dta", replace

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
import delimited "$path/county_policy.csv", encoding(ISO-8859-1) clear // We download this policy data from National Association of Counties. (https://ce.naco.org/?dset=COVID-19&ind=Emergency%20Declaration%20Types)
keep fips countyemergencydeclarationdate saferathomepolicydate businessclosurepolicydate
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
save "$path/county_policy.dta", replace

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

import excel "$path/state_policy.xlsx", sheet("Stay at Home") firstrow clear
rename Stayathomeshelterinplace sip_s
drop if State == "Total with each policy (out of 51 with DC)" | State == ""
keep State sip_s
save "$path/state_sip.dta", replace

use "$path/state_soe.dta", clear
merge 1:1 State using "$path/state_pdc.dta", nogen
merge 1:1 State using "$path/state_sip.dta", nogen

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

foreach dta in soe pdc sip {
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

**********************
*** Merge Datasets ***
**********************
use "$path/NYT.dta", clear
merge 1:1 geoid date using "$path/all_counties.dta", nogen
merge 1:1 geoid date using "$path/weather.dta", nogen
sort geoid date
xtset geoid date
foreach NYT_var in case_county death_county case_state death_state case_national death_national {
replace `NYT_var' = 0 if `NYT_var' == .
} // This step fills the case and death to 0 before the first reported case
replace State = state if State == ""
drop state
merge n:1 State using "$path/state_policy.dta", nogen	
merge n:1 geoid using "$path/county_policy.dta", nogen
merge n:1 geoid using "$path/metro.dta", nogen

replace State = "Alaska" if geoid == 2270
replace State = "South Dakota" if geoid == 46113
replace State = "Virginia" if geoid == 51515
drop county 
gen stateid = int(geoid/1000)
save "$path/endog_res.dta", replace
