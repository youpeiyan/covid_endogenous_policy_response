********************
**** POI VISITS ****
********************

use "$path/endog_res_final.dta", clear
gen lcc_sip = lcc * sip

drop if y <= 192
xtile dbin = device_count, nq(50)
gen ld = log(device_count)

merge 1:1 geoid date using "$path/day_visit_sum_all.dta", nogen
		   
foreach ind in 4431 4452 4483 4421 4482 4422 4512 ///
			   4533 4539 4532 4461 4522 4481 4523 ///
			   4451 4511 4471 {	
replace dvc`ind' = 0 if dvc`ind' == .	   
}
keep if date >= 21945 & date <= 22026

eststo clear


** We plot the major POI-visit results below due to the space limits.
  
foreach ind in 4511 4471 4523 4522 4481 4539 4451 ///
			   4461 4532 4533 4512 4421 4482 4483 ///
			   4452 {			   
eststo: qui reghdfe dvc`ind' lcc lcn lcn1 soe sip scs lcc_sip $xctrl1, absorb(geoid dbin) cluster(stateid) 
}
			   	   
esttab using $path/results/_bup/POI.csv, replace se r2 keep(lcc lcn lcn1 soe sip scs lcc_sip)

eststo clear
  
foreach ind in 4511 4471 4523 4522 4481 4539 4451 ///
			   4461 4532 4533 4512 4421 4482 4483 ///
			   4452 {		   
rename lcc lcc_`ind'
rename lcc_sip lccsip_`ind'
eststo: qui reghdfe dvc`ind' lcc_`ind' lcn lcn1 soe sip scs lccsip_`ind' $xctrl1, absorb(geoid dbin) cluster(stateid) 
rename lcc_`ind' lcc 
rename lccsip_`ind' lcc_sip 
}

coefplot(est1, keep(lcc_*) mcolor(gs3) msize(small) msymbol(t) ciopts(lwidth(1.5) lcolor(gs12))) ///
		(est1, keep(lccsip*) mcolor(white) msize(small) msymbol(o) ciopts(lwidth(1.5) lcolor(gs7))) ///		
		(est2, keep(lcc_*) mcolor(gs3) msize(small) msymbol(t) ciopts(lwidth(1.5) lcolor(gs12))) ///
		(est2, keep(lccsip*) mcolor(white) msize(small) msymbol(o) ciopts(lwidth(1.5) lcolor(gs7))) ///		
		(est3, keep(lcc_*) mcolor(gs3) msize(small) msymbol(t) ciopts(lwidth(1.5) lcolor(gs12))) ///
		(est3, keep(lccsip*) mcolor(white) msize(small) msymbol(o) ciopts(lwidth(1.5) lcolor(gs7))) ///		
		(est4, keep(lcc_*) mcolor(gs3) msize(small) msymbol(t) ciopts(lwidth(1.5) lcolor(gs12))) ///
		(est4, keep(lccsip*) mcolor(white) msize(small) msymbol(o) ciopts(lwidth(1.5) lcolor(gs7))) ///		
		(est5, keep(lcc_*) mcolor(gs3) msize(small) msymbol(t) ciopts(lwidth(1.5) lcolor(gs12))) ///
		(est5, keep(lccsip*) mcolor(white) msize(small) msymbol(o) ciopts(lwidth(1.5) lcolor(gs7))) ///		
		(est6, keep(lcc_*) mcolor(gs3) msize(small) msymbol(t) ciopts(lwidth(1.5) lcolor(gs12))) ///
		(est6, keep(lccsip*) mcolor(white) msize(small) msymbol(o) ciopts(lwidth(1.5) lcolor(gs7))) ///		
		(est7, keep(lcc_*) mcolor(gs3) msize(small) msymbol(t) ciopts(lwidth(1.5) lcolor(gs12))) ///
		(est7, keep(lccsip*) mcolor(white) msize(small) msymbol(o) ciopts(lwidth(1.5) lcolor(gs7))) ///		
		(est8, keep(lcc_*) mcolor(gs3) msize(small) msymbol(t) ciopts(lwidth(1.5) lcolor(gs12))) ///
		(est8, keep(lccsip*) mcolor(white) msize(small) msymbol(o) ciopts(lwidth(1.5) lcolor(gs7))) ///		
		(est9, keep(lcc_*) mcolor(gs3) msize(small) msymbol(t) ciopts(lwidth(1.5) lcolor(gs12))) ///
		(est9, keep(lccsip*) mcolor(white) msize(small) msymbol(o) ciopts(lwidth(1.5) lcolor(gs7))) ///		
		(est10, keep(lcc_*) mcolor(gs3) msize(small) msymbol(t) ciopts(lwidth(1.5) lcolor(gs12))) ///
		(est10, keep(lccsip*) mcolor(white) msize(small) msymbol(o) ciopts(lwidth(1.5) lcolor(gs7))) ///		
		(est11, keep(lcc_*) mcolor(gs3) msize(small) msymbol(t) ciopts(lwidth(1.5) lcolor(gs12))) ///
		(est11, keep(lccsip*) mcolor(white) msize(small) msymbol(o) ciopts(lwidth(1.5) lcolor(gs7))) ///		
		(est12, keep(lcc_*) mcolor(gs3) msize(small) msymbol(t) ciopts(lwidth(1.5) lcolor(gs12))) ///
		(est12, keep(lccsip*) mcolor(white) msize(small) msymbol(o) ciopts(lwidth(1.5) lcolor(gs7))) ///		
		(est13, keep(lcc_*) mcolor(gs3) msize(small) msymbol(t) ciopts(lwidth(1.5) lcolor(gs12))) ///
		(est13, keep(lccsip*) mcolor(white) msize(small) msymbol(o) ciopts(lwidth(1.5) lcolor(gs7))) ///		
		(est14, keep(lcc_*) mcolor(gs3) msize(small) msymbol(t) ciopts(lwidth(1.5) lcolor(gs12))) ///
		(est14, keep(lccsip*) mcolor(white) msize(small) msymbol(o) ciopts(lwidth(1.5) lcolor(gs7))) ///		
		(est15, keep(lcc_*) mcolor(gs3) msize(small) msymbol(t) ciopts(lwidth(1.5) lcolor(gs12))) ///
		(est15, keep(lccsip*) mcolor(white) msize(small) msymbol(o) ciopts(lwidth(1.5) lcolor(gs7))) ///
		, keep(lccsip_* lcc_*) legend(off) xline(0) ///	
		coeflabels(lcc_4471 = "Gasoline stations" ///
				   lcc_4511 = "Sporting goods, hobby, & musical" ///
				   lcc_4451 = "Grocery stores" ///
				   lcc_4523 = "General merchandise stores" ///
				   lcc_4539 = "Other miscellaneous store retailers" ///
				   lcc_4461 = "Health & personal care stores" ///
				   lcc_4533 = "Used merchandise stores" ///
				   lcc_4532 = "Office supplies, stationery, &" ///
				   lcc_4452 = "Specialty food stores" ///
				   lcc_4421 = "Furniture Stores" ///
				   lcc_4481 = "Clothing Stores" ///
				   lcc_4512 = "Book stores & news dealers" ///
				   lcc_4483 = "Jewelry, luggage, & leather goods stores" ///
				   lcc_4522 = "Department stores" ///
				   lcc_4482 = "Shoe stores" ///
				   lccsip_4471 = "(446.86)" ///
				   lccsip_4511 = "instrument (178.37)" ///
				   lccsip_4451 = "(460.67)" ///
				   lccsip_4523 = "(506.78)" ///
				   lccsip_4539 = "(121.46)" ///
				   lccsip_4461 = "(205.75)" ///
				   lccsip_4533 = "(79.88)" ///
				   lccsip_4532 = "gift stores (70.27)" ///
				   lccsip_4452 = "(26.61)" ///
				   lccsip_4421 = "(38.63)" ///
				   lccsip_4481 = "(69.14)" ///
				   lccsip_4512 = "(29.33)" ///
				   lccsip_4483 = "(23.53)" ///
				   lccsip_4522 = "(97.67)" ///
				   lccsip_4482 = "(13.65)" ///
				   ,wrap(40)) ///
		 xtitle("county-case vs. stay-home crowding-out" "effects to visits/device") ylabel(, labsize(small)) nooffsets graphregion(color(white)) bgcolor(white) 
graph export $path/results/figures/poi.png, replace
graph export $path/results/figures/poi.pdf, replace
