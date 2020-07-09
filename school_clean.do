import delimited "/Users/youpei/Downloads/Yale/_COVID19_old/MCH_COVID19_School_Closings_List.csv", encoding(ISO-8859-1)clear
rename state state_id
replace city = subinstr(city,"Saint ","St. ",.)
replace city = subinstr(city,"St ","St. ",.)

replace city = "Acme" if city == "ACME"
replace city = "Ada" if city == "ADA"
replace city = "Arco" if city == "ARCO"

replace city = "Au Gres" if city == "AU Gres"
replace city = "Au Sable Forks" if city == "AU Sable Forks"
merge n:1 city state_id using  "/Users/youpei/Downloads/Yale/COVID19_RE/protest/cities/uscities.dta"

gen scs_c = date(physicalcloseddate, "MDY")
format scs_c %td
rename county_fips geoid
keep scs_c geoid enrollment state_name
keep if geoid != .
gen count = 1
replace enrollment = 0 if enrollment == .

rename state_name State
merge n:1 State using "/Users/youpei/Downloads/Yale/COVID19_ER/state_policy.dta", nogen
replace scs_c = scs if scs_c == .

collapse (sum) count enrollment, by(scs_c geoid)
sort geoid

drop if scs_c == .

by geoid: egen max_count = max(count)
by geoid: egen max_enroll = max(enrollment)

gen keep1 = (count == max_count)
gen keep2 = (enrollment == max_enroll)

gen y = (keep1 == keep2)
drop if y == 0 & enrollment == 0

drop if keep2 == 0

keep geoid scs_c
save "/Users/youpei/Downloads/Yale/COVID19_ER/scs_c.dta", replace
