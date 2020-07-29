****************************************************
**** Partial Identification Grid - loglog model ****
****************************************************
use "$path/endog_res_final.dta", clear
global xctrl1 precip rmax rmin srad tmin tmax wind_speed week_*  
set more off
keep if date >= 21945 & date <= 22026
drop if y <=192
xtile dbin = device_count, nq(50)

gen lcc_sip = lcc * sip

eststo clear
forval b_lcc = 0.02(0.02)0.15 {
local j = int(100 * `b_lcc')/2
gen logy1 = logy- `b_lcc' * lcc
rename lcc_sip lcc_sip`j'
rename sip sip`j'
eststo: qui reghdfe logy1 lcn lcn1 soe sip`j' scs lcc_sip`j' $xctrl1, absorb(geoid dbin) cluster(stateid) 
drop logy1
rename lcc_sip`j' lcc_sip
rename sip`j' sip
}
esttab using $path/results/_bup/b_lcc.csv, se r2 replace keep(lcn lcn1 soe sip* scs lcc_sip*)

coefplot(est1, keep(lcc_sip1) mcolor(white) msize(medsmall) msymbol(o) ciopts(lwidth(2) lcolor(gs7))) ///
		(est1, keep(sip1) mcolor(gs3) msize(medsmall) msymbol(t) ciopts(lwidth(2) lcolor(gs12))) ///
		(est2, keep(lcc_sip2) mcolor(red) msize(medsmall) msymbol(o) ciopts(lwidth(2) lcolor(gs7))) ///
		(est2, keep(sip2) mcolor(red) msize(medsmall) msymbol(t) ciopts(lwidth(2) lcolor(gs12))) ///
		(est3, keep(lcc_sip3) mcolor(white) msize(medsmall) msymbol(o) ciopts(lwidth(2) lcolor(gs7))) ///
		(est3, keep(sip3) mcolor(gs3) msize(medsmall) msymbol(t) ciopts(lwidth(2) lcolor(gs12))) ///
		(est4, keep(lcc_sip4) mcolor(white) msize(medsmall) msymbol(o) ciopts(lwidth(2) lcolor(gs7))) ///
		(est4, keep(sip4) mcolor(gs3) msize(medsmall) msymbol(t) ciopts(lwidth(2) lcolor(gs12))) ///
		(est5, keep(lcc_sip5) mcolor(white) msize(medsmall) msymbol(o) ciopts(lwidth(2) lcolor(gs7))) ///
		(est5, keep(sip5) mcolor(gs3) msize(medsmall) msymbol(t) ciopts(lwidth(2) lcolor(gs12))) ///
		(est6, keep(lcc_sip6) mcolor(white) msize(medsmall) msymbol(o) ciopts(lwidth(2) lcolor(gs7))) ///
		(est6, keep(sip6) mcolor(gs3) msize(medsmall) msymbol(t) ciopts(lwidth(2) lcolor(gs12))) ///
		(est7, keep(lcc_sip7) mcolor(white) msize(medsmall) msymbol(o) ciopts(lwidth(2) lcolor(gs7))) ///
		(est7, keep(sip7) mcolor(gs3) msize(medsmall) msymbol(t) ciopts(lwidth(2) lcolor(gs12))) ///
		, vertical keep(lcc_sip* lcc*) legend(off) yline(0) xsize(3) ///	
		 coeflabels(lcc_sip1="0.02" sip1= " " ///
					lcc_sip2="0.04" sip2= " " ///
					lcc_sip3="0.06" sip3= " " ///
					lcc_sip4="0.08" sip4= " " ///
					lcc_sip5="0.10" sip5= " " ///
					lcc_sip6="0.12" sip6= " " ///
					lcc_sip7="0.14" sip7= " ") ///
		 ytitle("Crowding-out effect (circle) & stay-at-home policy effect (triangle)", size(medlarge))  yscale(titlegap(*-24)) ///
		 xtitle("Assigned values for log county cases", size(medlarge)) ///
		 ylabel(-0.12(0.04)0.32, labsize(medium) angle(horizontal)) xlabel(, labsize(medium) angle(vertical) notick) graphregion(color(white)) bgcolor(white) nooffset 
graph export $path/results/figures/b_lcc.png, replace	
graph export $path/results/figures/b_lcc.pdf, replace	
	 
cap drop logy1
forval b_sip = 0.08(0.02)0.21 {
local j = (int(100 * `b_sip')-6)/2
gen logy1 = logy - `b_sip' * sip
rename lcc_sip lcc_sip`j'
rename lcc lcc`j'
eststo: qui reghdfe logy1 lcc`j' lcn lcn1 soe scs lcc_sip`j' $xctrl1, absorb(geoid dbin) cluster(stateid) 
drop logy1
rename lcc_sip`j' lcc_sip
rename lcc`j' lcc
}
esttab using $path/results/_bup/b_sip.csv, se r2 replace keep(lcc* lcn lcn1 soe scs lcc_sip*)

coefplot(est8, keep(lcc_sip1) mcolor(white) msize(medsmall) msymbol(o) ciopts(lwidth(2) lcolor(gs7))) ///
		(est8, keep(lcc1) mcolor(gs3) msize(medsmall) msymbol(t) ciopts(lwidth(2) lcolor(gs12))) ///
		(est9, keep(lcc_sip2) mcolor(white) msize(medsmall) msymbol(o) ciopts(lwidth(2) lcolor(gs7))) ///
		(est9, keep(lcc2) mcolor(gs3) msize(medsmall) msymbol(t) ciopts(lwidth(2) lcolor(gs12))) ///
		(est10, keep(lcc_sip3) mcolor(white) msize(medsmall) msymbol(o) ciopts(lwidth(2) lcolor(gs7))) ///
		(est10, keep(lcc3) mcolor(gs3) msize(medsmall) msymbol(t) ciopts(lwidth(2) lcolor(gs12))) ///
		(est11, keep(lcc_sip4) mcolor(white) msize(medsmall) msymbol(o) ciopts(lwidth(2) lcolor(gs7))) ///
		(est11, keep(lcc4) mcolor(gs3) msize(medsmall) msymbol(t) ciopts(lwidth(2) lcolor(gs12))) ///
		(est12, keep(lcc_sip5) mcolor(white) msize(medsmall) msymbol(o) ciopts(lwidth(2) lcolor(gs7))) ///
		(est12, keep(lcc5) mcolor(gs3) msize(medsmall) msymbol(t) ciopts(lwidth(2) lcolor(gs12))) ///
		(est13, keep(lcc_sip6) mcolor(red) msize(medsmall) msymbol(o) ciopts(lwidth(2) lcolor(gs7))) ///
		(est13, keep(lcc6) mcolor(red) msize(medsmall) msymbol(t) ciopts(lwidth(2) lcolor(gs12))) ///
		(est14, keep(lcc_sip7) mcolor(white) msize(medsmall) msymbol(o) ciopts(lwidth(2) lcolor(gs7))) ///
		(est14, keep(lcc7) mcolor(gs3) msize(medsmall) msymbol(t) ciopts(lwidth(2) lcolor(gs12))) ///
		, vertical keep(lcc_sip* lcc*) legend(off) yline(0) xsize(3) ///	
		 coeflabels(lcc_sip1="0.08" lcc1= " " ///
					lcc_sip2="0.10" lcc2= " " ///
					lcc_sip3="0.12" lcc3= " " ///
					lcc_sip4="0.14" lcc4= " " ///
					lcc_sip5="0.16" lcc5= " " ///
					lcc_sip6="0.18" lcc6= " " ///
					lcc_sip7="0.20" lcc7= " ") ///
		 ytitle("Crowding-out effect (circle) & log county case effect (triangle)", size(medlarge)) yscale(titlegap(*-24))  ///
		 xtitle("Assigned values for stay-at-home policy", size(medlarge)) ///
		 ylabel(-0.05(0.01)0.06, labsize(medium) angle(horizontal)) xlabel(, labsize(medium) angle(vertical) notick) graphregion(color(white)) bgcolor(white) nooffset
graph export $path/results/figures/b_sip.png, replace	
graph export $path/results/figures/b_sip.pdf, replace		

