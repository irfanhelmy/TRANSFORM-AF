
**** Cleaning SGLT2 prior HF hospitalization files 

**** STEP 1: Identifying those with HF hospitalization 10 year prior to DPP4 initiation 
clear
cd "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\AF SGLT2"
use af_sglt2_priorhfhospi.dta
gen dof= dofc(sglt2filltime)
gen admin= dofc(AdmitDateTime)
gen HFH = 1
keep scrssn dof admin HFH
keep if HFH ==1
keep scrssn dof admin HFH
duplicates drop scrssn, force 
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\sglt2\diabetes_af_SGLT2_HFH.dta", replace 
**** 938 patients with HFH within 12 months prior to glp1 initiation 

**** STEP 2: Identifying total number of HFH for each patient on DPP4 
clear
cd "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\AF SGLT2"
use af_sglt2_priorhfhospi.dta
gen dof= dofc(sglt2filltime)
gen admin= dofc(AdmitDateTime)
by scrssn, sort: gen scrssn_n = _n
bysort scrssn:egen THFH = max(scrssn_n)
bysort scrssn(scrssn_n):keep if _n==_N
keep scrssn THFH
summarize THFH, detail
gen glp1 =1 
replace glp1 = 0 if glp1==.
**** 938 patients with prior HFH
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\sglt2\diabetes_af_sglt2_prior_HFH.dta", replace