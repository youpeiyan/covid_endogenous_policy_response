*****************************************
**** Use Days since stay-home policy ****
*****************************************
use "$path/endog_res_final.dta", clear

keep if date >= 21945 & date <= 22026

gen lcc_day_sip = lcc * day_sip
gen lcc_lday_sip = lcc * lday_sip

gen lcc_sip = lcc * sip

eststo clear
foreach lhs in y logy {
eststo: qui xtreg `lhs' lcc lcn soe sip scs lcc_sip lcc_day_sip $xctrl1, fe cluster(stateid) 
eststo: qui xtreg `lhs' lcc lcn soe sip scs lcc_sip day_sip lcc_day_sip $xctrl1, fe cluster(stateid) 

forval i = 0/1 {
eststo: qui xtreg `lhs' lcc lcn soe sip scs lcc_sip lcc_day_sip $xctrl1 if metro == `i', fe cluster(stateid) 
eststo: qui xtreg `lhs' lcc lcn soe sip scs lcc_sip day_sip lcc_day_sip $xctrl1 if metro == `i', fe cluster(stateid) 
}
}

esttab using $path/results/_bup/daysip.csv, replace se drop(_cons $xctrl1)
