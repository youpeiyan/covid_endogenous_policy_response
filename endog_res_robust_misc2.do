********************
**** POI VISITS ****
********************
use "$path/endog_res_final.dta", clear
gen lcc_sip = lcc * sip
merge 1:1 geoid date using "$path/day_visit_sum.dta", nogen

eststo clear
/*
foreach ind in 7225 7139 4461 4531 4511 4471 7121 4539 4533 4522 4481 4532 ///
			   4421 4431 4483 7132 4512 4452 4482 4422 4411 4413 4237 7224 ///
			   7131 4246 4244 4238 4242 4239 4453 4441 4451 4523 {
			   */
			   /*
foreach ind in 4461 4511 4471 4539 4533 4522 4481 ///
			   4532 4421 4431 4483 4512 4452 4482 ///
			   4422 4451 4523 {
			   */
			   
/*			   
foreach ind in 4431 4452 4483 4421 4482 4422 4512 ///
			   4533 4539 4532 4461 4522 4481 4523 ///
			   4451 4511 4471 {		   
eststo: qui xtreg dvc`ind' lcc lcn lcn1 soe sip scs lcc_sip $xctrl1, fe cluster(stateid)
}
			   	   
esttab using $path/results/_bup/POI.csv, replace se keep(lcc lcn lcn1 soe sip scs lcc_sip)


sum dvc4461 dvc4511 dvc4471 dvc4539 dvc4533 dvc4522 dvc4481 ///
	dvc4532 dvc4421 dvc4431 dvc4483 dvc4512 dvc4452 dvc4482 ///
	dvc4422 dvc4451 dvc4523
*/

		   
foreach ind in 4471	4511	4451	4523	4481	4522	4461 ///
			   4532	4539	4533	4512	4422	4482	4421 ///
			   4483	4452	4431 {		   
rename lcc lcc_`ind'
rename lcc_sip lccsip_`ind'
eststo: qui xtreg dvc`ind' lcc_`ind' lcn lcn1 soe sip scs lccsip_`ind' $xctrl1, fe cluster(stateid)
rename lcc_`ind' lcc 
rename lccsip_`ind' lcc_sip 
}


coefplot (est1) (est2) (est3)(est4) (est5) (est6)(est7) (est8) (est9)(est10) (est11) (est12) ///
		 (est13) (est14) (est15)(est16) (est17), ///
		 keep(lcc_* lccsip_*) xline(0) msymbol(o) msize(small) mcolor(white) ciopts(lwidth(1) lcolor(gs7)) legend(off) ///
		coeflabels(lcc_4471 = "Gasoline stations" ///
				   lcc_4511 = "Sporting goods, hobby, & musical instrument" ///
				   lcc_4451 = "Grocery stores" ///
				   lcc_4523 = "General merchandise stores" ///
				   lcc_4539 = "Other miscellaneous store retailers" ///
				   lcc_4461 = "Health & personal care stores" ///
				   lcc_4533 = "Used merchandise stores" ///
				   lcc_4532 = "Office supplies, stationery, & gift stores" ///
				   lcc_4452 = "Specialty food stores" ///
				   lcc_4421 = "Furniture Stores" ///
				   lcc_4481 = "Clothing Stores" ///
				   lcc_4431 = "Electronics & appliance stores" ///
				   lcc_4422 = "Home furnishings stores" ///
				   lcc_4512 = "Book stores & news dealers" ///
				   lcc_4483 = "Jewelry, luggage, & leather goods stores" ///
				   lcc_4522 = "Department stores" ///
				   lcc_4482 = "Shoe stores" ///
				   lccsip_4471 = "(total visits: )" ///
				   lccsip_4511 = "(total visits: )" ///
				   lccsip_4451 = "(total visits: )" ///
				   lccsip_4523 = "(total visits: )" ///
				   lccsip_4539 = "(total visits: )" ///
				   lccsip_4461 = "(total visits: )" ///
				   lccsip_4533 = "(total visits: )" ///
				   lccsip_4532 = "(total visits: )" ///
				   lccsip_4452 = "(total visits: )" ///
				   lccsip_4421 = "(total visits: )" ///
				   lccsip_4481 = "(total visits: )" ///
				   lccsip_4431 = "(total visits: )" ///
				   lccsip_4422 = "(total visits: )" ///
				   lccsip_4512 = "(total visits: )" ///
				   lccsip_4483 = "(total visits: )" ///
				   lccsip_4522 = "(total visits: )" ///
				   lccsip_4482 = "(total visits: )" ///
				   ,wrap(40)) ///
		 xtitle("county-case effects vs. stay-home's crowding out effects to visits per device") ylabel(, labsize(vsmall)) nooffsets graphregion(color(white)) bgcolor(white) 

graph export $path/results/figures/poi.png, replace
