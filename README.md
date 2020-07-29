# endogenous_response
1. We use both public datasets and purchased datasets for this research. The step-by-step data importing and cleaning steps are shown in the files:

**endog_res_data_import.do**<br/>
(Data Import)<br/>
**endog_res_clean.do**<br/>
(Data Cleaning)<br/>

The cleaned dataset is named as **endog_res_final.dta**. 

We only upload the cleaned dataset used in this study. 

If you are interested in any intermediate datasets:<br/>
(a) the links updated on 6/29/2020 is in **endog_res_data_import.do** for public datasets.<br/>
(b) contact us for Safegraph datasets information.<br/>

2. You can run **endog_res_master.do** with the data file **endog_res_final.dta** directly. To start:

(a) Change the path directory to your local folder.<br/>
(b) Drag all the do files in this repo into this folder.<br/>
(c) Create a results folder. In the folder, create four subfolders named

***_bup*** <br/>
(For regression results of figures and partial identification checks)<br/>
***figures*** <br/>
(For figures produced in this research)<br/>
***group1***<br/>
(For robustness check results with right-hand-side case report variables all in the level form)<br/>
***group2***<br/>
(For robustness check results with right-hand-side case report variables all in the log form)

In group1 and group2 folders, create 12 subfolders named from ***list1***, ***list2***, …, to ***list12***. 

3. Although we put selected tables in the main text and SI, the following robustness checks are asked by reviewers and are performed in the results in each list:

***list1***: county case and national case<br/>
***list2***: state case and national case<br/>
***list3***: county case, state case, and national case<br/>
***list4***: county case and national case + new county case and new national case<br/>
***list5***: state case and national case + new state case and new national case<br/>
***list6***: county case, state case, and national case + new county case, new state case, and new national case<br/>
***list7***: county death and national death<br/>
***list8***: state death and national death<br/>
***list9***: county death, state death, and national death<br/>
***list10***: new county case and new national case<br/>
***list11***: new state case and new national case<br/>
***list12***: new county case, new state case, and new national case<br/>

4. In each ***list*** folder under each ***group*** folder, you will see 8 csv files after running. 

y.csv: with dwell-time (y) as the dependent variable.<br/>
ny.csv: with non dwell-time (ny) as the dependent variable.<br/>
logy.csv: with log(dwell-time + 1) (logy) as the dependent variable.<br/>
logny.csv: with log(non dwell-time + 1) (logny) as the dependent variable.<br/>

y_f.csv, ny_f.csv, logy_f.csv, logny_f.csv are the corresponding results for using the corresponding dependent variables at the t+1 time period. These robustness checks are used to reduce possible reverse causality and allow certain response time.

5. Because we use county fixed effects and bins of device count fixed effects, to avoid bins of device_count create collinearity under the regression function *reghdfe* for the daily-updated data now or in the future, we create parallel do. files: 

**endog_res_groups_nobin.do** for **endog_res_groups.do**<br/>
(We use the same regression model for different variable group setup in -global-. These two files set up global variable lists for the 12 list groups)<br/>
**endog_res_loop_nobin.do** for **endog_res_loop.do**<br/>
(We set the left hand side variable to take 8 values: log(dwell time), dwell time, log(non-dwell time), non-dwell time, and their t+1 period's values; And we set the right hand side controls take the control group 1 (base model: weather and weekday controls), group 2 (add epidemic day FE), group 3 (add stay-home policy day FE), and group 4 (add border states' cases impacts).<br/>
The loop is created in these two files.)<br/>
**endog_res_regression_nobin.do** for **endog_res_regression.do**<br/>
(The main regression models, one with the interaction of national case and the dummy for first county case report, one without this term.)

Those files with -nobin- in the titles run the same regression models but with bins of device count fixed effects manually added in the regression. The regression results should be the same to those above (if no collinearity issue), but with -nb- at the end of the file name. (For example, y_nb.csv)

6. For the maps created in the research, use **date_plot.xls** and **date_plot.R**.

**date_plot.xls** is derived from **endog_res_final.dta**, with only key dates of policies or first case report dates for each county. 
 
To run **date_plot.R**:

(a) Change the path directory to your local folder.
(b) Install packages listed in library() if not yet installed.

7. Two final datasets: **endog_res_final.dta** and **date_plot.xls** are in google drive
https://drive.google.com/file/d/1a9u14k7inb0sDmkw2VdLho2pRWlLrsq7 



