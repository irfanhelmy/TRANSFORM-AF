**** STEP 1: Cleaning admission diagnosis with AF hospitalization file for GLP1 patients
clear all
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\AF GLP1\diabetes_af_glp1_afafter.dta"
rename  ScrSSN scrssn
gen dof= dofc(GLP1FillTime)
gen admission= dofc(AdmitDateTime)
drop if admission - dof < 8
by scrssn admission, sort: gen scrssn_n = _n
keep if scrssn_n == 1
duplicates drop scrssn, force
keep scrssn admission 
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\glp1\diabetes_af_glp1_af_admission.dta", replace 
*** 161 hospitalizations for AF

**** STEP 2: Cardioversion GLP1
clear all
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\AF GLP1\diabetes_af_glp1_cardioafter.dta"
gen dof= dofc(GLP1FillTime)
gen admission= dofc(ICDProcedureDateTime)
drop if admission - dof < 8
by scrssn admission, sort: gen scrssn_n = _n
keep if scrssn_n == 1
duplicates drop scrssn, force
keep scrssn admission 
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\glp1\diabetes_af_glp1_cvafter.dta", replace 
***57

**** STEP 3: Ablation Procedure Codes GLP1
clear all
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\AF GLP1\diabetes_af_glp1_abprocafter.dta"
gen dof= dofc(GLP1FillTime)
gen admission= dofc(ICDProcedureDateTime)
drop if admission - dof < 8
by scrssn admission, sort: gen scrssn_n = _n
keep if scrssn_n == 1
duplicates drop scrssn, force
keep scrssn admission 
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\glp1\diabetes_af_glp1_abprocafter.dta", replace 

**** STEP 4 : Ablation DPP4GLP1
clear all
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\AF GLP1\diabetes_af_dpp4glp1_abprocafter.dta"
gen dof= dofc(DPP4FillTime)
gen admission= dofc(ICDProcedureDateTime)
drop if admission - dof < 8
by scrssn admission, sort: gen scrssn_n = _n
keep if scrssn_n == 1
duplicates drop scrssn, force
keep scrssn admission 
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\dpp4\diabetes_af_dpp4glp1_abprocafter.dta", replace 
***42

**** STEP 5: Cardioversion DPP4GLP1
clear all
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\AF GLP1\diabetes_af_dpp4glp1_cvafter.dta"
gen dof= dofc(DPP4FillTime)
gen admission= dofc(ICDProcedureDateTime)
drop if admission - dof < 8
by scrssn admission, sort: gen scrssn_n = _n
keep if scrssn_n == 1
duplicates drop scrssn, force
keep scrssn admission 
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\dpp4\diabetes_af_dpp4glp1_cvafter.dta", replace 
***83

**** STEP 6: Cleaning admission diagnosis with AF hospitalization file for DPP4 patients
clear all
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\AF GLP1\Diabetes_af_dpp4glp1_afafter.dta", clear
rename  ScrSSN scrssn
gen dof= dofc(DPP4FillTime)
gen admission= dofc(AdmitDateTime)
drop if admission - dof < 8
by scrssn admission, sort: gen scrssn_n = _n
keep if scrssn_n == 1
duplicates drop scrssn, force
keep scrssn admission
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\dpp4\diabetes_af_dpp4glp1_af_admission.dta", replace 
*** 271 hospitalizations for AF

**** STEP 7: Merge all GLP1 Files
clear all
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\glp1\diabetes_af_glp1_af_admission.dta"
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\glp1\diabetes_af_glp1_cvafter.dta"
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\glp1\diabetes_af_glp1_abprocafter.dta"
drop _merge
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\glp1\diabetes_af_glp1_finalAF.dta", replace
*** 182

**** STEP 8: Merge all DPP4 Files
clear all
use  "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\dpp4\diabetes_af_dpp4glp1_af_admission.dta"
merge 1:1 scrssn using  "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\dpp4\diabetes_af_dpp4glp1_cvafter.dta"
drop _merge
merge 1:1 scrssn using  "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\dpp4\diabetes_af_dpp4glp1_abprocafter.dta"
drop _merge
save  "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\dpp4\diabetes_af_dpp4glp1_finalAF.dta", replace
*** 292

**** STEP 9: Merging  GLP1 and DPP4i HF hospitalizations 
clear all
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\glp1\diabetes_af_glp1_finalAF.dta",
gen treatment =1
merge 1:m scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\dpp4\diabetes_af_dpp4glp1_finalAF.dta"
drop if _merge ==3
replace treatment = 0 if treatment ==.
drop _merge 
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\diabetes_af_dpp4glp1_glp1_finalAF.dta", replace 
**** 466 hospitalizations 





