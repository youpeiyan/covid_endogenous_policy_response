*************************
**** Seperate Groups ****
*************************

** With stay-home/shelter-in-place policy counties and no-policy counties
eststo clear

foreach lhs in y logy {
forval i = 0/1 {
eststo: qui xtreg `lhs' lcc lcn soe sip scs $xctrl1 if no_sip == `i', fe cluster(stateid)
eststo: qui xtreg `lhs' lcc lcn lcn1 soe sip scs $xctrl1 if no_sip == `i', fe cluster(stateid)
}
}

foreach lhs in y logy {
forval i = 0/1 {
eststo: qui xtreg `lhs' lcc lcn soe sip scs $xctrl1 if metro == `i', fe cluster(stateid)
eststo: qui xtreg `lhs' lcc lcn lcn1 soe sip scs $xctrl1 if metro == `i', fe cluster(stateid)
}
}

esttab using $path/results/_bup/group.csv, replace se keep(lcc lcn lcn1 soe sip scs) 

** by population share & increase rates
gen lcc_sip = lcc * sip
gen lcc_pop_sip = lcc_pop * sip

gen lcs_sip = lcs * sip
gen lcs_pop_sip = lcs_pop * sip
gen pop_group = (pop19 >100000)

eststo clear

eststo: qui xtreg logy lcc_pop lcn_pop lcc_pop_sip soe sip scs $xctrl1, fe cluster(stateid)
eststo: qui xtreg logy lcc_pop lcs_pop lcn_pop lcc_pop_sip lcs_pop_sip soe sip scs $xctrl1, fe cluster(stateid)
forval i = 0/1 {
eststo: qui xtreg logy lcc_pop lcn_pop lcc_pop_sip soe sip scs $xctrl1 if pop_group == `i', fe cluster(stateid)
eststo: qui xtreg logy lcc_pop lcs_pop lcn_pop lcc_pop_sip lcs_pop_sip soe sip scs $xctrl1 if pop_group == `i', fe cluster(stateid)
}

eststo: qui xtreg logy lcc lcn cc_rate cn_rate lcc_sip soe sip scs $xctrl1, fe cluster(stateid)
eststo: qui xtreg logy lcc lcn lcn1 cc_rate cn_rate lcc_sip soe sip scs $xctrl1, fe cluster(stateid)

eststo: qui xtreg logy lcc lcs lcn cc_rate cs_rate cn_rate lcc_sip lcs_sip soe sip scs $xctrl1, fe cluster(stateid)
eststo: qui xtreg logy lcc lcs lcn lcn1 cc_rate cs_rate cn_rate lcc_sip lcs_sip soe sip scs $xctrl1, fe cluster(stateid)

esttab using $path/results/_bup/group_pop.csv, replace se drop(_cons $xctrl1)
