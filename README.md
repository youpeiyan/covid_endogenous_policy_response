# endogenous_response

1. We use both public datasets and purchased datasets for this research. The step-by-step data importing and cleaning steps are shown in the files:

**endog_res_1_data_import.do** <br/> 
(Data Import) <br/> 
**endog_res_2_clean.do** <br/> 
(Data Cleaning) <br/> 
**endog_res_3_clean_labor.do** <br/> 
(Add labor share information at each county for robustness checks) <br/> 

The data we use include:

(a) New York Times Case Reports<br/>
https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-counties.csv<br/>
(b) Safegraph’s dwell time data at the county-level<br/>
(c) County-level weather data<br/>
(d)County-level policies <br/>
https://ce.naco.org/?dset=COVID-19&ind=Emergency%20Declaration%20Types<br/>
And<br/>
https://docs.google.com/spreadsheets/d/133Lry-k80-BfdPXhlS0VHsLEUQh5_UutqAt7czZd7ek/edit#gid=0<br/>
(e)School closure data from MCH<br/>
(f)State-level policy<br/>
https://docs.google.com/spreadsheets/d/1zu9qEWI8PsOI_i8nI_S29HDGHlIp2lfVMsGxpQ5tvAQ/edit#gid=973655443<br/>
(g)County-level population<br/>
https://www2.census.gov/programs-surveys/popest/datasets/2010-2019/counties/totals/co-est2019-alldata.csv<br/>
(h)Rural/metro county definition from ERS <br/>
https://www.ers.usda.gov/data-products/rural-urban-continuum-codes.aspx<br/>
(i)U.S. Bureau of Labor Statistics <br/> 
https://www.bls.gov/cew/downloadable-data-files.htm  <br/> 


The cleaned dataset is named “**endog_res_final2.dta**”. 

We only upload the cleaned datasets used in this study in the zip file **datasets.zip**. <br/>
https://drive.google.com/file/d/1Oj5MRtexqNVtyTl6N5RKubCc9qBnd1NJ/view?usp=sharing <br/>
It also contains a folder named **figures** that have exported .xls files that can be used to plot maps in **endog_res_10_maps.R** directly. 

If you are interested in any intermediate datasets:<br/>
(a) the links updated on 6/29/2020 is in **endog_res_1_data_import.do** for public datasets. <br/>
(b) contact us for Safegraph datasets information.<br/>

2. You can run the following .do files with the data file “**endog_res_final2.dta**” directly <br/>
**endog_res_4_main.do**: contains the main regression models showed in Table 1, and the related models without interaction term that showed in SI.<br/>
**endog_res_5_robustness.do**: contains all the robustness checks regression showed in SI.<br/>
**endog_res_6_fig2.do**: contains the plot of Figure 2.<br/>
**endog_res_7_fig3.do**: contains the plot of Figure 3.<br/>
**endog_res_8_compensating_case.do**: contains how compensating case is calculated under the preferred kitchen sink model. <br/>

To start: <br/>
(a) Change the path directory to your local folder. <br/>
(b) Drag all the do files in this repo into this folder.<br/>

3. We also build conceptual framework to show the concept of compensating cases with the median and mean county case when the stay-at-home order was in-effect. We also show the Krinsky-Robb confidence interval for the simulated compensating case between 0 to 100. The code is in **endog_res_9_conceptural.R** that does not require any dataset.

4. For the maps created in the study, use **endog_res_10_maps.R** and the corresponding .xls files in the **figures** folder. All the .xls files are derived from **endog_res_final2.dta**, with only key dates of policies or first case report dates for each county. 
 
To run **endog_res_10_maps.R**:

(a) Change the path directory to your local folder. <br/>
(b) Install packages listed in library() if not yet installed.<br/>

5. The methodology of augmented synthetic control is in the corresponding folder. 
