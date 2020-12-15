set more off

clear
global path "/Users/youpei/Downloads/Yale/COVID19_ER" 
global xctrl precip rmax rmin srad tmin tmax wind_speed week_*

use "$path/endog_res_final2.dta", clear

*** Figures to compare coefficients across specifications (from the above 1-9 specifications) in a figure
eststo clear
foreach var in lcc sip scs {
rename `var' `var'1a
}
eststo: qui reghdfe logy lcc1a lcn lcn1 soe sip1a scs1a lcc_sip $xctrl crazy, absorb(geoid dbin) cluster(stateid) 
foreach var in lcc sip scs {
rename `var'1a `var'
}
foreach var in lcc sip scs {
rename `var' `var'1b
}
eststo: qui reghdfe logy lcc1b lcc_divEMP* lcn lcn1 soe sip1b sip_divEMP* scs1b lcc_sip lcc_sip_divEMP* $xctrl crazy, absorb(geoid dbin epiday_s) cluster(stateid) 
foreach var in lcc sip scs {
rename `var'1b `var'
}
foreach var in lcs sip scs {
rename `var' `var'2a
}
eststo: qui reghdfe logy lcs2a lcn lcn1 soe sip2a scs2a lcs_sip $xctrl crazy, absorb(geoid dbin) cluster(stateid) 
foreach var in lcs sip scs {
rename `var'2a `var'
}
foreach var in lcs sip scs {
rename `var' `var'2b
}
eststo: qui reghdfe logy lcs2b lcs_divEMP* lcn lcn1 soe sip2b sip_divEMP* scs2b lcs_sip lcs_sip_divEMP* $xctrl crazy, absorb(geoid dbin epiday_s) cluster(stateid) 
foreach var in lcs sip scs {
rename `var'2b `var'
}
foreach var in lcc lcs sip scs {
rename `var' `var'3a
}
eststo: qui reghdfe logy lcc3a lcs3a lcn lcn1 soe sip3a scs3a lcc_sip lcs_sip $xctrl crazy, absorb(geoid dbin) cluster(stateid) 
foreach var in lcc lcs sip scs {
rename `var'3a `var'
}
foreach var in lcc lcs sip scs {
rename `var' `var'3b
}
eststo: qui reghdfe logy lcc3b lcs3b lcc_divEMP* lcs_divEMP* lcn lcn1 soe sip3b sip_divEMP* scs3b lcc_sip lcs_sip lcc_sip_divEMP* lcs_sip_divEMP* $xctrl crazy, absorb(geoid dbin epiday_s) cluster(stateid) 
foreach var in lcc lcs sip scs {
rename `var'3b `var'
}
foreach var in lncc sip scs {
rename `var' `var'4a
}
eststo: qui reghdfe logy lncc4a lncn lncn1 soe sip4a scs4a lncc_sip $xctrl crazy, absorb(geoid dbin) cluster(stateid) 
foreach var in lncc sip scs {
rename `var'4a `var'
}
foreach var in lncc sip scs {
rename `var' `var'4b
}
eststo: qui reghdfe logy lncc4b lncc_divEMP* lncn lncn1 soe sip4b sip_divEMP* scs4b lncc_sip lncc_sip_divEMP* $xctrl crazy, absorb(geoid dbin epiday_s) cluster(stateid) 
foreach var in lncc sip scs {
rename `var'4b `var'
}
foreach var in lncs sip scs {
rename `var' `var'5a
}
eststo: qui reghdfe logy lncs5a lncn lncn1 soe sip5a scs5a lncs_sip $xctrl crazy, absorb(geoid dbin) cluster(stateid) 
foreach var in lncs sip scs {
rename `var'5a `var'
}
foreach var in lncs sip scs {
rename `var' `var'5b
}
eststo: qui reghdfe logy lncs5b lncc_divEMP* lncn lncn1 soe sip5b sip_divEMP* scs5b lncs_sip lncs_sip_divEMP* $xctrl crazy, absorb(geoid dbin epiday_s) cluster(stateid) 
foreach var in lncs sip scs {
rename `var'5b `var'
}
foreach var in lncc lncs sip scs {
rename `var' `var'6a
}
eststo: qui reghdfe logy lncc6a lncs6a lncn lncn1 soe sip6a scs6a lncc_sip lncs_sip $xctrl crazy, absorb(geoid dbin) cluster(stateid) 
foreach var in lncc lncs sip scs {
rename `var'6a `var'
}
foreach var in lncc lncs sip scs {
rename `var' `var'6b
}
eststo: qui reghdfe logy lncc6b lncs6b lncc_divEMP* lncs_divEMP* lncn lncn1 soe sip6b sip_divEMP* scs6b lncc_sip lncs_sip lncc_sip_divEMP* lncs_sip_divEMP* $xctrl crazy, absorb(geoid dbin epiday_s) cluster(stateid) 
foreach var in lncc lncs sip scs {
rename `var'6b `var'
}
foreach var in ldc sip scs {
rename `var' `var'7a
}
eststo: qui reghdfe logy ldc7a ldn ldn1 soe sip7a scs7a ldc_sip $xctrl crazy, absorb(geoid dbin) cluster(stateid) 
foreach var in ldc sip scs {
rename `var'7a `var'
}
foreach var in ldc sip scs {
rename `var' `var'7b
}
eststo: qui reghdfe logy ldc7b ldc_divEMP* ldn ldn1 soe sip7b sip_divEMP* scs7b ldc_sip ldc_sip_divEMP* $xctrl crazy, absorb(geoid dbin epiday_s) cluster(stateid) 
foreach var in ldc sip scs {
rename `var'7b `var'
}
foreach var in lds sip scs {
rename `var' `var'8a
}
eststo: qui reghdfe logy lds8a ldn ldn1 soe sip8a scs8a lds_sip $xctrl crazy, absorb(geoid dbin) cluster(stateid) 
foreach var in lds sip scs {
rename `var'8a `var'
}
foreach var in lds sip scs {
rename `var' `var'8b
}
eststo: qui reghdfe logy lds8b lds_divEMP* ldn ldn1 soe sip8b sip_divEMP* scs8b lds_sip lds_sip_divEMP* $xctrl crazy, absorb(geoid dbin epiday_s) cluster(stateid) 
foreach var in lds sip scs {
rename `var'8b `var'
}
foreach var in ldc lds sip scs {
rename `var' `var'9a
}
eststo: qui reghdfe logy ldc9a lds9a ldn ldn1 soe sip9a scs9a ldc_sip lds_sip $xctrl crazy, absorb(geoid dbin) cluster(stateid) 
foreach var in ldc lds sip scs {
rename `var'9a `var'
}
foreach var in ldc lds sip scs {
rename `var' `var'9b
}
eststo: qui reghdfe logy ldc9b lds9b ldc_divEMP* lds_divEMP* ldn ldn1 soe sip9b sip_divEMP* scs9b ldc_sip lds_sip ldc_sip_divEMP* lds_sip_divEMP* $xctrl crazy, absorb(geoid dbin epiday_s) cluster(stateid) 
foreach var in ldc lds sip scs {
rename `var'9b `var'
}
esttab using $path/R2_regression_1124/results/table_figure.csv, replace se r2 drop(_cons $xctrl)



coefplot(est1, keep(sip1a) mcolor(gs3) msize(small) msymbol(t) ciopts(lwidth(1) lcolor(gs12))) ///
		(est2, keep(sip1b) mcolor(gs3) msize(small) msymbol(t) ciopts(lwidth(1) lcolor(gs12))) ///
		(est3, keep(sip2a) mcolor(gs3) msize(small) msymbol(t) ciopts(lwidth(1) lcolor(gs12))) ///
		(est4, keep(sip2b) mcolor(gs3) msize(small) msymbol(t) ciopts(lwidth(1) lcolor(gs12))) ///
		(est5, keep(sip3a) mcolor(gs3) msize(small) msymbol(t) ciopts(lwidth(1) lcolor(gs12))) ///
		(est6, keep(sip3b) mcolor(gs3) msize(small) msymbol(t) ciopts(lwidth(1) lcolor(gs12))) ///
		(est7, keep(sip4a) mcolor(gs3) msize(small) msymbol(t) ciopts(lwidth(1) lcolor(gs12))) ///
		(est8, keep(sip4b) mcolor(gs3) msize(small) msymbol(t) ciopts(lwidth(1) lcolor(gs12))) ///
		(est9, keep(sip5a) mcolor(gs3) msize(small) msymbol(t) ciopts(lwidth(1) lcolor(gs12))) ///
		(est10, keep(sip5b) mcolor(gs3) msize(small) msymbol(t) ciopts(lwidth(1) lcolor(gs12))) ///
		(est11, keep(sip6a) mcolor(gs3) msize(small) msymbol(t) ciopts(lwidth(1) lcolor(gs12))) ///
		(est12, keep(sip6b) mcolor(gs3) msize(small) msymbol(t) ciopts(lwidth(1) lcolor(gs12))) ///
		(est13, keep(sip7a) mcolor(gs3) msize(small) msymbol(t) ciopts(lwidth(1) lcolor(gs12))) ///
		(est14, keep(sip7b) mcolor(gs3) msize(small) msymbol(t) ciopts(lwidth(1) lcolor(gs12))) ///
		(est15, keep(sip8a) mcolor(gs3) msize(small) msymbol(t) ciopts(lwidth(1) lcolor(gs12))) ///
		(est16, keep(sip8b) mcolor(gs3) msize(small) msymbol(t) ciopts(lwidth(1) lcolor(gs12))) ///
		(est17, keep(sip9a) mcolor(gs3) msize(small) msymbol(t) ciopts(lwidth(1) lcolor(gs12))) ///
		(est18, keep(sip9b) mcolor(gs3) msize(small) msymbol(t) ciopts(lwidth(1) lcolor(gs12))) ///	
,  legend(off) ///	
	coeflabels(sip1a = "Model 1-a" ///
			   sip1b = "Model 1-b" ///
			   sip2a = "Model 2-a" ///
			   sip2b = "Model 2-b" ///
			   sip3a = "Model 3-a" ///
			   sip3b = "Model 3-b" ///
			   sip4a = "Model 4-a" ///
			   sip4b = "Model 4-b" ///
			   sip5a = "Model 5-a" ///
			   sip5b = "Model 5-b" ///
			   sip6a = "Model 6-a" ///
			   sip6b = "Model 6-b" ///
			   sip7a = "Model 7-a" ///
			   sip7b = "Model 7-b" ///
			   sip8a = "Model 8-a" ///
			   sip8b = "Model 8-b" ///
			   sip9a = "Model 9-a" ///
			   sip9b = "Model 9-b") ///
		 xtitle("coefficient comparison: stay-at-home order",size(large)) xlabel(, labsize(large)) ylabel(, labsize(large)) nooffsets graphregion(color(white)) bgcolor(white) 
graph export $path/results/fig_sip.png, replace
graph export $path/results/fig_sip.pdf, replace


coefplot(est1, keep(scs1a) mcolor(gs3) msize(small) msymbol(t) ciopts(lwidth(1) lcolor(gs12))) ///
		(est2, keep(scs1b) mcolor(gs3) msize(small) msymbol(t) ciopts(lwidth(1) lcolor(gs12))) ///
		(est3, keep(scs2a) mcolor(gs3) msize(small) msymbol(t) ciopts(lwidth(1) lcolor(gs12))) ///
		(est4, keep(scs2b) mcolor(gs3) msize(small) msymbol(t) ciopts(lwidth(1) lcolor(gs12))) ///
		(est5, keep(scs3a) mcolor(gs3) msize(small) msymbol(t) ciopts(lwidth(1) lcolor(gs12))) ///
		(est6, keep(scs3b) mcolor(gs3) msize(small) msymbol(t) ciopts(lwidth(1) lcolor(gs12))) ///
		(est7, keep(scs4a) mcolor(gs3) msize(small) msymbol(t) ciopts(lwidth(1) lcolor(gs12))) ///
		(est8, keep(scs4b) mcolor(gs3) msize(small) msymbol(t) ciopts(lwidth(1) lcolor(gs12))) ///
		(est9, keep(scs5a) mcolor(gs3) msize(small) msymbol(t) ciopts(lwidth(1) lcolor(gs12))) ///
		(est10, keep(scs5b) mcolor(gs3) msize(small) msymbol(t) ciopts(lwidth(1) lcolor(gs12))) ///
		(est11, keep(scs6a) mcolor(gs3) msize(small) msymbol(t) ciopts(lwidth(1) lcolor(gs12))) ///
		(est12, keep(scs6b) mcolor(gs3) msize(small) msymbol(t) ciopts(lwidth(1) lcolor(gs12))) ///
		(est13, keep(scs7a) mcolor(gs3) msize(small) msymbol(t) ciopts(lwidth(1) lcolor(gs12))) ///
		(est14, keep(scs7b) mcolor(gs3) msize(small) msymbol(t) ciopts(lwidth(1) lcolor(gs12))) ///
		(est15, keep(scs8a) mcolor(gs3) msize(small) msymbol(t) ciopts(lwidth(1) lcolor(gs12))) ///
		(est16, keep(scs8b) mcolor(gs3) msize(small) msymbol(t) ciopts(lwidth(1) lcolor(gs12))) ///
		(est17, keep(scs9a) mcolor(gs3) msize(small) msymbol(t) ciopts(lwidth(1) lcolor(gs12))) ///
		(est18, keep(scs9b) mcolor(gs3) msize(small) msymbol(t) ciopts(lwidth(1) lcolor(gs12))) ///	
,  legend(off) ///	
	coeflabels(scs1a = "Model 1-a" ///
			   scs1b = "Model 1-b" ///
			   scs2a = "Model 2-a" ///
			   scs2b = "Model 2-b" ///
			   scs3a = "Model 3-a" ///
			   scs3b = "Model 3-b" ///
			   scs4a = "Model 4-a" ///
			   scs4b = "Model 4-b" ///
			   scs5a = "Model 5-a" ///
			   scs5b = "Model 5-b" ///
			   scs6a = "Model 6-a" ///
			   scs6b = "Model 6-b" ///
			   scs7a = "Model 7-a" ///
			   scs7b = "Model 7-b" ///
			   scs8a = "Model 8-a" ///
			   scs8b = "Model 8-b" ///
			   scs9a = "Model 9-a" ///
			   scs9b = "Model 9-b") ///
		 xtitle("coefficient comparison: school closure",size(large)) xlabel(, labsize(large)) ylabel(, labsize(large)) nooffsets graphregion(color(white)) bgcolor(white) 
graph export $path/results/fig_scs.png, replace
graph export $path/results/fig_scs.pdf, replace

coefplot(est1, keep(lcc1a) mcolor(gs3) msize(small) msymbol(t) ciopts(lwidth(1) lcolor(gs12))) ///
		(est2, keep(lcc1b) mcolor(gs3) msize(small) msymbol(t) ciopts(lwidth(1) lcolor(gs12))) ///
		(est5, keep(lcc3a) mcolor(gs3) msize(small) msymbol(t) ciopts(lwidth(1) lcolor(gs12))) ///
		(est6, keep(lcc3b) mcolor(gs3) msize(small) msymbol(t) ciopts(lwidth(1) lcolor(gs12))) ///
		(est7, keep(lncc4a) mcolor(gs3) msize(small) msymbol(o) ciopts(lwidth(1) lcolor(gs12))) ///
		(est8, keep(lncc4b) mcolor(gs3) msize(small) msymbol(o) ciopts(lwidth(1) lcolor(gs12))) ///
		(est11, keep(lncc6a) mcolor(gs3) msize(small) msymbol(o) ciopts(lwidth(1) lcolor(gs12))) ///
		(est12, keep(lncc6b) mcolor(gs3) msize(small) msymbol(o) ciopts(lwidth(1) lcolor(gs12))) ///
		(est13, keep(ldc7a) mcolor(gs3) msize(small) msymbol(s) ciopts(lwidth(1) lcolor(gs12))) ///
		(est14, keep(ldc7b) mcolor(gs3) msize(small) msymbol(s) ciopts(lwidth(1) lcolor(gs12))) ///
		(est17, keep(ldc9a) mcolor(gs3) msize(small) msymbol(s) ciopts(lwidth(1) lcolor(gs12))) ///
		(est18, keep(ldc9b) mcolor(gs3) msize(small) msymbol(s) ciopts(lwidth(1) lcolor(gs12))) ///	
,  legend(off) ///	
	coeflabels(lcc1a = "Model 1-a" ///
			   lcc1b = "Model 1-b" ///
			   lcc3a = "Model 3-a" ///
			   lcc3b = "Model 3-b" ///
			   lncc4a = "Model 4-a" ///
			   lncc4b = "Model 4-b" ///
			   lncc6a = "Model 6-a" ///
			   lncc6b = "Model 6-b" ///
			   ldc7a = "Model 7-a" ///
			   ldc7b = "Model 7-b" ///
			   ldc9a = "Model 9-a" ///
			   ldc9b = "Model 9-b") ///
		 xtitle("coefficient comparison: cumulative county case," "new county case, and county death",size(large)) xlabel(, labsize(large)) ylabel(, labsize(large)) nooffsets graphregion(color(white)) bgcolor(white) 
graph export $path/results/fig_lcc.png, replace
graph export $path/results/fig_lcc.pdf, replace

coefplot(est3, keep(lcs2a) mcolor(gs3) msize(small) msymbol(t) ciopts(lwidth(1) lcolor(gs12))) ///
		(est4, keep(lcs2b) mcolor(gs3) msize(small) msymbol(t) ciopts(lwidth(1) lcolor(gs12))) ///
		(est5, keep(lcs3a) mcolor(gs3) msize(small) msymbol(t) ciopts(lwidth(1) lcolor(gs12))) ///
		(est6, keep(lcs3b) mcolor(gs3) msize(small) msymbol(t) ciopts(lwidth(1) lcolor(gs12))) ///
		(est9, keep(lncs5a) mcolor(gs3) msize(small) msymbol(o) ciopts(lwidth(1) lcolor(gs12))) ///
		(est10, keep(lncs5b) mcolor(gs3) msize(small) msymbol(o) ciopts(lwidth(1) lcolor(gs12))) ///
		(est11, keep(lncs6a) mcolor(gs3) msize(small) msymbol(o) ciopts(lwidth(1) lcolor(gs12))) ///
		(est12, keep(lncs6b) mcolor(gs3) msize(small) msymbol(o) ciopts(lwidth(1) lcolor(gs12))) ///
		(est15, keep(lds8a) mcolor(gs3) msize(small) msymbol(s) ciopts(lwidth(1) lcolor(gs12))) ///
		(est16, keep(lds8b) mcolor(gs3) msize(small) msymbol(s) ciopts(lwidth(1) lcolor(gs12))) ///
		(est17, keep(lds9a) mcolor(gs3) msize(small) msymbol(s) ciopts(lwidth(1) lcolor(gs12))) ///
		(est18, keep(lds9b) mcolor(gs3) msize(small) msymbol(s) ciopts(lwidth(1) lcolor(gs12))) ///	
,  legend(off)  ///	
	coeflabels(lcs2a = "Model 2-a" ///
			   lcs2b = "Model 2-b" ///
			   lcs3a = "Model 3-a" ///
			   lcs3b = "Model 3-b" ///
			   lncs5a = "Model 5-a" ///
			   lncs5b = "Model 5-b" ///
			   lncs6a = "Model 6-a" ///
			   lncs6b = "Model 6-b" ///
			   lds8a = "Model 8-a" ///
			   lds8b = "Model 8-b" ///
			   lds9a = "Model 9-a" ///
			   lds9b = "Model 9-b") ///
		 xtitle("coefficient comparison: cumulative state case," "new state case, and state death",size(large)) xlabel(, labsize(large)) ylabel(, labsize(large)) nooffsets graphregion(color(white)) bgcolor(white) 
graph export $path/results/fig_lcs.png, replace
graph export $path/results/fig_lcs.pdf, replace
