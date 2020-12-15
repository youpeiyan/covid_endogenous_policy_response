set more off

clear
global path "/Users/youpei/Downloads/Yale/COVID19_ER" 
global xctrl precip rmax rmin srad tmin tmax wind_speed week_*
qui {
use "$path/endog_res_final.dta", clear
 keep if date >= 21945 & date <= 22026
 drop if y <= 192    
 xtile dbin = device_count, nq(50) 
 
 foreach var in lcc lcs ldc lds lncc lncs lcbs ///
				cc cs {
 gen `var'_sip = `var'*sip
}

replace day_sip = 0 if day_sip < 0
replace epiday_s = 0 if epiday_s < 0 

merge n:1 geoid using "$path/employment.dta", nogen 
merge n:1 geoid using "$path/essential_homework.dta", nogen
drop if cc == .

rename employed_pop pop_employed

replace essential = essential/pop_employed
replace at_home_work = at_home_work/pop_employed

foreach emp of varlist emp* {
qui replace `emp' = 0 if `emp' == .
qui replace `emp' = `emp'/pop_employed
}

cap drop crazy
gen crazy = (date == 21995 | date == 21996)

gen emp2101 = 0
gen emp2102 = 0 
gen emp4201 = 0 
gen emp4202 = 0 
gen emp5501 = 0 
gen emp5502 = 0 
gen emp5503 = 0 
gen emp9205 = 0 

foreach i in 11 21 22 23 42 51 52 53 54 55 56 61 62 71 72 81 92 99 3133 4445 4849 {
qui gen EMP`i' = emp`i'01 + emp`i'02 + emp`i'03 + emp`i'05
egen meanEMP`i' = mean(EMP`i')
qui gen divEMP`i' = EMP`i' - meanEMP`i'
}

drop emp*
drop meanEMP*

foreach emp of varlist div* {
foreach var in sip lcc lcc_sip lcs lcs_sip lncc lncc_sip lncs lncs_sip ldc ldc_sip lds lds_sip cc cs cc_sip cs_sip {
qui gen `var'_`emp' = `var' * `emp'
}
}

}
save $path/endog_res_final2.dta, replace
