*********************************************************************
**** Plot the model predicted values and various counterfactural ****
*********************************************************************
set more off

use "$path/endog_res_final.dta", clear
global xctrl1 precip rmax rmin srad tmin tmax wind_speed week_*  

keep if date >= 21945 & date <= 22026
drop if y <= 192

xtile dbin = device_count, nq(50)
gen lcs_sip = lcs*sip

** Preserve the original values
foreach var in sip soe scs lcs_sip lcs lcn lcn1 {
gen `var'_ori = `var'
}

** Run the basic log-log model regression
qui reghdfe logy lcs lcn lcn1 soe sip scs lcs_sip $xctrl1, absorb(geoid dbin) cluster(stateid)
predict logy1

** counterfactural: no policies & policy interaction
replace sip = 0
replace soe = 0
replace scs = 0
replace lcs_sip = 0
predict logy2 if e(sample)
replace sip = sip_ori
replace soe = soe_ori
replace scs = scs_ori
replace lcs_sip = lcs_sip_ori

** counterfactural: no case reports & policy interaction
replace lcs = 0
replace lcn = 0
replace lcn1 = 0
replace lcs_sip = 0
predict logy3 if e(sample)
replace lcs = lcs_ori
replace lcn = lcn_ori
replace lcn1 = lcn1_ori
replace lcs_sip = lcs_sip_ori

** counterfactural: no policy interaction (additive results)
replace lcs_sip = 0
predict logy4 if e(sample)
replace lcs_sip = lcs_sip_ori

** counterfactural: no stay-home policy & policy interaction
replace sip = 0
replace lcs_sip = 0
predict logy5 if e(sample)
replace sip = sip_ori
replace lcs_sip = lcs_sip_ori

** counterfactural: no stay-home policy & policy interaction, & no school closure
replace sip = 0
replace scs = 0
replace lcs_sip = 0
predict logy6 if e(sample)
replace sip = sip_ori
replace scs = scs_ori
replace lcs_sip = lcs_sip_ori

** counterfactural: no state case report & policy interaction
replace lcs = 0
replace lcs_sip = 0
predict logy7 if e(sample)
replace lcs = lcs_ori
replace lcs_sip = lcs_sip_ori

** Plot the results based on the stay-home policy issued date
gen sipday = date - sipd
sort sipday
by sipday: egen y1 = mean(exp(logy1)-1)
by sipday: egen y2 = mean(exp(logy2)-1)
by sipday: egen y3 = mean(exp(logy3)-1)
by sipday: egen y4 = mean(exp(logy4)-1)
by sipday: egen y5 = mean(exp(logy5)-1)
by sipday: egen y6 = mean(exp(logy6)-1)
by sipday: egen y7 = mean(exp(logy7)-1)

twoway line y1 y2 y6 y5 y3 y7 y4 sipday if sipday <=20 & sipday >= -40, ///
		ytitle(Median time spent at home (min)) xtitle(Days before and after the stay-at-home policy) ///
		lp(solid dash dash dash dash dash dash) ///
			lc(gs7 edkblue red edkblue*0.58 maroon purple green) ///
			legend(off) ///
			graphregion(color(white)) bgcolor(white) 
graph export $path/results/figures/fig5b.png, replace 
graph export $path/results/figures/fig5b.pdf, replace 

/*
twoway line y1 y2 y6 y5 y3 y7 y4 sipday if sipday <=20 & sipday >= -40, ///
		ytitle(Median time spent at home (min)) xtitle(Days before and after the stay-home policy) ///
		lp(solid dash dash dash dash dash dash) ///
			lc(gs7 edkblue red edkblue*0.58 maroon purple green) ///
			legend(size(*0.5) pos(11) ring(0) col(1) ///
			lab(1 "Model predicted value") lab(2 "no policies")  ///
			lab(3 "no stay-home policy & school closure") lab(4 "no stay-home policy") ///
			lab(5 "no case reports") lab(6 "no state-case reports") ///
			lab(7 "no interaction") ) ///
			graphregion(color(white)) bgcolor(white) 
graph export $path/results/figures/fig5_state.png, replace 
*/
