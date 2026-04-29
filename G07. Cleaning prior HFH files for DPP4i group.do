


**** Cleaning DPP4 prior HF hospitalization files 

**** STEP 1: Identifying those with HF hospitalization 10 years prior to DPP4 initiation 
clear
cd "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\AF GLP1"
use af_dpp4glp1_priorhfhospi.dta
gen dof= dofc(DPP4FillTime)
gen admin= dofc(AdmitDateTime)
gen HFH = 1 
keep scrssn dof admin HFH
duplicates drop scrssn, force 
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\dpp4\diabetes_af_dpp4glp1_HFH.dta", replace 
*** 232 patients 


**** STEP 2: Identifying total number of HFH for each patient on DPP4 
clear
cd "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\AF GLP1"
use af_dpp4glp1_priorhfhospi.dta
gen dof= dofc(DPP4FillTime)
gen admin= dofc(AdmitDateTime)
by scrssn, sort: gen scrssn_n = _n
bysort scrssn:egen THFH = max(scrssn_n)
bysort scrssn(scrssn_n):keep if _n==_N
keep scrssn THFH
summarize THFH, detail
gen dpp4 =1 
replace dpp4 = 0 if dpp4==.
**** 232 patients with prior HFH
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\dpp4\diabetes_af_dpp4glp1_prior_HFH.dta", replace 
