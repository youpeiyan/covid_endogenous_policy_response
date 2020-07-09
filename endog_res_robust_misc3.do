use "$path/endog_res_final.dta", clear

********************
**** DFE_* only ****
********************
keep if date >= 21945 & date <= 22026
forval day = 21945/22026 {
gen DFE_`day' = (date == `day')
}

keep geoid date logy lcc lcs lcn soe sip scs $xctrl2 ///
				lcn1 ldn1 ldc ldn lncc lncs lncn soe sip scs ///
				DFE_* stateid
				
gen lcc_sip = lcc * sip

eststo clear
eststo: qui xtreg logy lcc soe sip scs lcc_sip $xctrl2, fe cluster(stateid)
scalar b1 = _b[lcc]
  gen logy1 = logy - b1*lcc

eststo: qui xtreg logy1 lcn1 soe sip scs lcc_sip $xctrl1, fe cluster(stateid)
eststo: qui xtreg logy1 lcn1 lcn soe sip scs lcc_sip $xctrl1, fe cluster(stateid)

esttab using $path/results/_bup/dfe.csv, replace se drop(_cons $xctrl2)
