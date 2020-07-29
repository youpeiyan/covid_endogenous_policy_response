****************************************************************************
**** Function of this file: 8 LHS choices & 4 control variable choices ****
****************************************************************************

*** Set the left hand side variable to take 8 values: log(dwell time), dwell time, log(non-dwell time), non-dwell time, and their t+1 period's values
*** Set the right hand side controls take the control group 1 (base model: weather and weekday controls), group 2 (add epidemic day FE), group 3 (add stay-home policy day FE), and group 4 (add border states' cases impacts). 

foreach RC_A in logy y logny ny y_f logy_f ny_f logny_f {
global LHS `RC_A'

eststo clear

foreach RC_B in xctrl1 xctrl2 xctrl3 xctrl4 {
global xctrl $`RC_B'

do $path/endog_res_regression.do 

}
esttab using $savefolder/`RC_A'.csv, replace se r2 drop(_cons $xctrl1 epiDFEs_* sipDFE_*)
}

