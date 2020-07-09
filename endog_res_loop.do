****************************************************************************
**** Function of this file: 12 LHS choices & 7 control variable choices ****
****************************************************************************

foreach RC_A in logy y logny ny y_f logy_f ny_f logny_f {
global LHS `RC_A'

eststo clear

foreach RC_B in xctrl1 xctrl3 xctrl4 xctrl5 {
global xctrl $`RC_B'

do $path/endog_res_regression.do 

}
esttab using $savefolder/`RC_A'.csv, replace se drop(_cons $xctrl1 epiDFEs_* sipDFE_*)
}

