
***********************************************************************************************
**** Function of this file: 12 regression case/death/new case groups for robustness checks ****
***********************************************************************************************



***************************************************************
**** Create Different Variable Lists for Robustness Checks ****
***************************************************************

***************************************************
*** generate interaction terms: case and policy ***
***************************************************

foreach case in cc cs cn ///
				dc ds dn ///
				ncc ncs ncn ///
				ndc nds ndn ///
				cbs dbs {
gen `case'_sip = `case' * sip	
}

**********************************
*** check 12 case/death groups ***
**********************************

// We listed more global group of variables (and regression models in endog_res_loop.do than we show in the paper). You can try various combinations if interested.

*** 1.Case Group 1: county case & national case
global savefolder $resultgroup/list1

global ncase_soe	    cn_soe
global ncase_sip	    cn_sip
global ncase_day_soe	cn_daysoe
global ncase_lday_soe	cn_ldaysoe
global ncase_day_sip	cn_daysip
global ncase_lday_sip	cn_ldaysip

global case	            cc cn
global case_soe	        cc_soe
global case_sip	        cc_sip
global case_day_soe	    cc_daysoe
global case_lday_soe	cc_ldaysoe
global case_day_sip	    cc_daysip
global case_lday_sip	cc_ldaysip

global case1			cc cn cn1

do $path/endog_res_loop.do


*** 2.Case Group 2: state case & national case
global savefolder $resultgroup/list2

global case         	cs cn
global case_soe	        cs_soe
global case_sip	        cs_sip
global case_day_soe	    cs_daysoe
global case_lday_soe	cs_ldaysoe
global case_day_sip	    cs_daysip
global case_lday_sip	cs_ldaysip

global case1			cs cn cn1

do $path/endog_res_loop.do


*** 3.Case Group 3: county case & state & national case
global savefolder $resultgroup/list3

global case	            cc cs cn
global case_soe			cc_soe cs_soe
global case_sip			cc_sip cs_sip
global case_day_soe		cc_daysoe cs_daysoe
global case_lday_soe	cc_ldaysoe cs_ldaysoe
global case_day_sip		cc_daysip cs_daysip
global case_lday_sip	cc_ldaysip cs_ldaysip

global case1			cc cs cn cn1

do $path/endog_res_loop.do

/*
// Note: Group 4-6 are not shown in the final paper due to the mis-specification. 
*** 4.Case Group 4: county case & national case + new county case & national case
global savefolder $resultgroup/list4

global ncase_soe		cn_soe ncn_soe
global ncase_sip		cn_sip ncn_sip
global ncase_day_soe	cn_daysoe ncn_daysoe
global ncase_lday_soe	cn_ldaysoe ncn_ldaysoe
global ncase_day_sip	cn_daysip ncn_daysip
global ncase_lday_sip	cn_ldaysip ncn_ldaysip

global case				cc cn ncc ncn
global case_soe			cc_soe ncc_soe
global case_sip			cc_sip ncc_sip
global case_day_soe		cc_daysoe ncc_daysip
global case_lday_soe	cc_ldaysoe ncc_ldaysoe
global case_day_sip		cc_daysip ncc_daysip
global case_lday_sip	cc_ldaysip ncc_ldaysip

global case1			cc cn cn1 ncc ncn

do $path/endog_res_loop.do


*** 5.Case Group 5: state case & national case + new state case & national case
global savefolder $resultgroup/list5

global case				cs cn ncs ncn
global case_soe			cs_soe ncs_soe
global case_sip			cs_sip ncs_sip
global case_day_soe		cs_daysoe ncs_daysip
global case_lday_soe	cs_ldaysoe ncs_ldaysoe
global case_day_sip		cs_daysip ncs_daysip
global case_lday_sip	cs_ldaysip ncs_ldaysip

global case1			cs cn cn1 ncs ncn

do $path/endog_res_loop.do


*** 6.Case Group 6: county case & state & national case + county case & state & national case
global savefolder $resultgroup/list6

global case				cc cs cn ncc ncs ncn
global case_soe			cc_soe ncc_soe cs_soe ncs_soe
global case_sip			cc_sip ncc_sip cs_sip ncs_sip
global case_day_soe		cc_daysoe ncc_daysip cs_daysoe ncs_daysip
global case_lday_soe	cc_ldaysoe ncc_ldaysoe cs_ldaysoe ncs_ldaysoe
global case_day_sip		cc_daysip ncc_daysip cs_daysip ncs_daysip
global case_lday_sip	cc_ldaysip ncc_ldaysip cs_ldaysip ncs_ldaysip

global case1			cc cs cn cn1 ncc ncs ncn ncn1

do $path/endog_res_loop.do

*/

*** 7.Death Group 1: county case & national case
global savefolder $resultgroup/list7

global ncase_soe	    dn_soe
global ncase_sip	    dn_sip
global ncase_day_soe	dn_daysoe
global ncase_lday_soe	dn_ldaysoe
global ncase_day_sip	dn_daysip
global ncase_lday_sip	dn_ldaysip

global case	            dc dn
global case_soe	        dc_soe
global case_sip	        dc_sip
global case_day_soe	    dc_daysoe
global case_lday_soe	dc_ldaysoe
global case_day_sip	    dc_daysip
global case_lday_sip	dc_ldaysip

global case1	        dc dn dn1

do $path/endog_res_loop.do


*** 8.Death Group 2: state case & national case
global savefolder $resultgroup/list8

global case         	ds dn
global case_soe	        ds_soe
global case_sip	        ds_sip
global case_day_soe	    ds_daysoe
global case_lday_soe	ds_ldaysoe
global case_day_sip	    ds_daysip
global case_lday_sip	ds_ldaysip

global case1	        ds dn dn1

do $path/endog_res_loop.do


*** 9.Death Group 3: county case & state & national case
global savefolder $resultgroup/list9

global case	            dc ds dn
global case_soe			dc_soe ds_soe
global case_sip			dc_sip ds_sip
global case_day_soe		dc_daysoe ds_daysoe
global case_lday_soe	dc_ldaysoe ds_ldaysoe
global case_day_sip		dc_daysip ds_daysip
global case_lday_sip	dc_ldaysip ds_ldaysip

global case1	        dc ds dn dn1

do $path/endog_res_loop.do

*** 10.New Case Group 1: new county case & national case
global savefolder $resultgroup/list10

global ncase_soe		ncn_soe
global ncase_sip		ncn_sip
global ncase_day_soe	ncn_daysoe
global ncase_lday_soe	ncn_ldaysoe
global ncase_day_sip	ncn_daysip
global ncase_lday_sip	ncn_ldaysip

global case				ncc ncn
global case_soe			ncc_soe
global case_sip			ncc_sip
global case_day_soe		ncc_daysip
global case_lday_soe	ncc_ldaysoe
global case_day_sip		ncc_daysip
global case_lday_sip	ncc_ldaysip


global case1			ncc ncn ncn1
do $path/endog_res_loop.do

*** 11.New Case Group 1: new state case & national case
global savefolder $resultgroup/list11

global case				ncs ncn
global case_soe			ncs_soe
global case_sip			ncs_sip
global case_day_soe		ncs_daysip
global case_lday_soe	ncs_ldaysoe
global case_day_sip		ncs_daysip
global case_lday_sip	ncs_ldaysip

global case1			ncs ncn ncn1
do $path/endog_res_loop.do

*** 12.New Case Group 1: new county & state case & national case
global savefolder $resultgroup/list12

global case				ncc ncs ncn
global case_soe			ncc_soe ncs_soe
global case_sip			ncc_sip ncs_sip
global case_day_soe		ncc_daysip ncs_daysip
global case_lday_soe	ncc_ldaysoe ncs_ldaysoe
global case_day_sip		ncc_daysip ncs_daysip
global case_lday_sip	ncc_ldaysip ncs_ldaysip

global case1				ncc ncs ncn ncn1

do $path/endog_res_loop.do



***********************************************
*** drop interaction terms: case and policy ***
***********************************************


foreach case in cc cs cn ///
				dc ds dn ///
				ncc ncs ncn ///
				ndc nds ndn ///
				cbs dbs {
drop `case'_sip
}
				
				
				
