******************************
**** Plot Raw Median Time **** 
******************************

set more off

** Plot raw median time by date
use "$path/endog_res_final.dta", clear
keep if date >= 21945 & date <= 22026

drop if y <= 192

sort date
by date: egen ymean = mean(y)

sort date metro
by date metro: egen ymean2 = mean(y)
format date %tdnn/dd
sort date
twoway (line ymean date)(line ymean2 date if metro == 1)(line ymean2 date if metro == 0), ///
			 xtitle("Date from Jan 31 to April 21, 2020", size(huge)) xlabel(21942(20)22030,labsize(huge)) ylabel(,labsize(huge) angle(horizontal)) ///
			legend(off) ///
			graphregion(color(white)) bgcolor(white) xline(22002 21986, lp(dash) lc(gs7))
graph save fig2a, replace
graph export $path/results/figures/fig2a.png, replace
graph export $path/results/figures/fig2a.pdf, replace

** Plot based on case 
use "$path/endog_res_final.dta", clear
keep if date >= 21945 & date <= 22026

gen cc1day = date - cc1
gen cs1day = date - cs1

sort cc1day
by cc1day: egen ymean = mean(y)
sort cc1day metro
by cc1day metro: egen ymean2 = mean(y)

sort cc1day
twoway (line ymean cc1day if cc1day >=-40 & cc1day <=40)(line ymean2 cc1day if metro == 1 & cc1day >=-40 & cc1day <=40)(line ymean2 cc1day if metro == 0 & cc1day >=-40 & cc1day <=40), ///
			xtitle("Days of the first county case report", size(huge)) xlabel(-40(20)40,labsize(huge)) ylabel(,labsize(huge) angle(horizontal)) ///
			legend(off) ///
			graphregion(color(white)) bgcolor(white) xline(0, lp(dash) lc(gs7))
graph save fig2b, replace
graph export $path/results/figures/fig2b.png, replace
graph export $path/results/figures/fig2b.pdf, replace
drop ymean ymean2 cc1day

sort cs1day
by cs1day: egen ymean = mean(y)
sort cs1day metro
by cs1day metro: egen ymean2 = mean(y)

sort cs1day
twoway (line ymean cs1day if cs1day >=-40 & cs1day <=40)(line ymean2 cs1day if metro == 1 & cs1day >=-40 & cs1day <=40)(line ymean2 cs1day if metro == 0 & cs1day >=-40 & cs1day <=40), ///
			xtitle("Days of the first state case report", size(huge)) xlabel(-40(20)40,labsize(huge)) ylabel(,labsize(huge) angle(horizontal)) ///
			legend(off) ///
			graphregion(color(white)) bgcolor(white) xline(0, lp(dash) lc(gs7)) 
graph save fig2c, replace
graph export $path/results/figures/fig2c.png, replace
graph export $path/results/figures/fig2c.pdf, replace

** Plot based on policies
use "$path/endog_res_final.dta", clear

set more off
keep if date >= 21945 & date <= 22026

gen soeday = date - soed

sort soeday
by soeday: egen ymean = mean(y)

sort soeday metro
by soeday metro: egen ymean2 = mean(y)

sort soeday
twoway (line ymean soeday if soeday >=-40 & soeday <=40)(line ymean2 soeday if metro == 1 & soeday >=-40 & soeday <=40)(line ymean2 soeday if metro == 0 & soeday >=-40 & soeday <=40), ///
			xtitle("Days of the declaration of emergency", size(huge)) xlabel(-40(20)40,labsize(huge)) ylabel(,labsize(huge) angle(horizontal)) ///
			legend(off) ///
			graphregion(color(white)) bgcolor(white) xline(0, lp(dash) lc(gs7)) 
graph save fig2d, replace
graph export $path/results/figures/fig2d.png, replace
graph export $path/results/figures/fig2d.pdf, replace
drop ymean ymean2 soeday

gen sipday = date - sipd
sort sipday
by sipday: egen ymean = mean(y)
sort sipday metro
by sipday metro: egen ymean2 = mean(y)
sort sipday
twoway (line ymean sipday if sipday >=-40 & sipday <=40)(line ymean2 sipday if metro == 1 & sipday >=-40 & sipday <=40)(line ymean2 sipday if metro == 0 & sipday >=-40 & sipday <=40), ///
			xtitle("Days of the stay-at-home policy", size(huge)) xlabel(-40(20)40,labsize(huge)) ylabel(,labsize(huge) angle(horizontal)) ///
			legend(off) ///
			graphregion(color(white)) bgcolor(white) xline(0, lp(dash) lc(gs7)) 
graph save fig2e, replace
graph export $path/results/figures/fig2e.png, replace
graph export $path/results/figures/fig2e.pdf, replace
drop ymean ymean2 sipday

gen scsday = date - scsd
sort scsday
by scsday: egen ymean = mean(y)
sort scsday metro
by scsday metro: egen ymean2 = mean(y)
sort scsday
twoway (line ymean scsday if scsday >=-40 & scsday <= 40)(line ymean2 scsday if metro == 1 & scsday >=-40 & scsday <= 40)(line ymean2 scsday if metro == 0 & scsday >=-40 & scsday <= 40), ///
			xtitle("Days of the school closure", size(huge)) xlabel(-40(20)40,labsize(huge)) ylabel(,labsize(huge) angle(horizontal)) ///
			legend(off) ///
			graphregion(color(white)) bgcolor(white) xline(0, lp(dash) lc(gs7)) 
graph save fig2f, replace
graph export $path/results/figures/fig2f.png, replace
graph export $path/results/figures/fig2f.pdf, replace

graph combine fig2a.gph fig2b.gph fig2c.gph fig2d.gph fig2f.gph fig2e.gph, row(2) graphregion(color(white)) iscale(.33)
graph export $path/results/figures/fig2.pdf, replace
