set more off

clear
global path "/Users/youpei/Downloads/Yale/COVID19_ER" 
global xctrl precip rmax rmin srad tmin tmax wind_speed week_*

use "$path/endog_res_final2.dta", clear

** This is using the preferred model, kitchen sink (with labor share interaction and epidemic day FE), coefficients to get each county's equivalent case and compensating case numbers.
scalar drop _all
reghdfe logy lcc lcc_divEMP* lcn lcn1 soe sip sip_divEMP* scs lcc_sip lcc_sip_divEMP* $xctrl crazy, absorb(geoid dbin epiday_s) cluster(stateid) 

foreach var of varlist lcc lcc_divEMP* sip sip_divEMP*  lcc_sip lcc_sip_divEMP* {
scalar b_`var'_sink = _b[`var']
}

gen coef0 = b_lcc_sink
foreach var of varlist divEMP* {
replace coef0 = coef0 + b_lcc_`var'_sink * `var'
}

gen coef1 = b_sip_sink
foreach var of varlist divEMP* {
replace coef1 = coef1 + b_sip_`var'_sink * `var'
}

gen coef2 = b_lcc_sip_sink
foreach var of varlist divEMP* {
replace coef2 = coef2 + b_lcc_sip_`var'_sink * `var'
}

gen cc_star = cc if sipd == date
sort geoid
by geoid: egen ccstar = mean(cc_star)

gen sim_compensating_sink0 = exp((log(ccstar+1) * coef0 + ///
								  coef1 + ///
								  log(ccstar+1) * coef2) ///
								  /coef0)-1
				  
gen sim_sink0 = sim_compensating_sink0 - ccstar


qui sum sim_sink0, detail

gen plot_sim_sink0 = sim_sink0
replace plot_sim_sink0 = 0 if sim_sink0 <= 0
replace plot_sim_sink0 = r(p95) if sim_sink0 >= r(p95) & sim_sink0 !=.
replace plot_sim_sink0 = 3553.654 if plot_sim_sink0 == . & ccstar !=. // 3553.654 is r(p95), this step is to double-check


preserve
keep geoid plot_sim_sink0
duplicates drop
export excel using "$path/results/figures/plotsim.xls", firstrow(variables) replace
restore
