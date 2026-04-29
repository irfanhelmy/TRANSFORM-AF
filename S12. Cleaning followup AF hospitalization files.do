**** STEP 1: Cleaning admission diagnosis with AF hospitalization file for SGLT2 patients
clear all
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\AF SGLT2\diabetes_af_sglt2_afafter.dta"
rename  ScrSSN scrssn
gen dof= dofc(SGLT2FillTime)
gen admission= dofc(AdmitDateTime)
drop if admission - dof < 8
by scrssn admission, sort: gen scrssn_n = _n
keep if scrssn_n == 1
duplicates drop scrssn, force
keep scrssn admission 
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\sglt2\diabetes_af_sglt2_af_admission.dta", replace 
*** 356 hospitalizations for AF --> 465

**** STEP 2: Cardioversion SGLT2
clear all
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\AF SGLT2\diabetes_af_sglt2_cardioafter.dta"
gen dof= dofc(sglt2filltime)
gen admission= dofc(ICDProcedureDateTime)
drop if admission - dof < 8
by scrssn admission, sort: gen scrssn_n = _n
keep if scrssn_n == 1
duplicates drop scrssn, force
keep scrssn admission 
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\sglt2\diabetes_af_sglt2_cvafter.dta", replace 
***145 --> 183

**** STEP 3: Ablation Procedure Codes SGLT2
clear all
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\AF SGLT2\diabetes_af_sglt2_abprocafter.dta"
gen dof= dofc(sglt2filltime)
gen admission= dofc(ICDProcedureDateTime)
drop if admission - dof < 8
by scrssn admission, sort: gen scrssn_n = _n
keep if scrssn_n == 1
duplicates drop scrssn, force
keep scrssn admission 
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\sglt2\diabetes_af_sglt2_abprocafter.dta", replace 
** 69 patients** --> 84

**** STEP 4 : Ablation dpp4
clear all
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\AF SGLT2\diabetes_af_dpp4_abprocafter.dta"
gen dof= dofc(DPP4FillTime)
gen admission= dofc(ICDProcedureDateTime)
drop if admission - dof < 8
by scrssn admission, sort: gen scrssn_n = _n
keep if scrssn_n == 1
duplicates drop scrssn, force
keep scrssn admission 
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\dpp4\diabetes_af_dpp4_abprocafter.dta", replace 
***46 --> 53

**** STEP 5: Cardioversion dpp4
clear all
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\AF SGLT2\diabetes_af_dpp4_cvafter.dta"
gen dof= dofc(DPP4FillTime)
gen admission= dofc(ICDProcedureDateTime)
drop if admission - dof < 8
by scrssn admission, sort: gen scrssn_n = _n
keep if scrssn_n == 1
duplicates drop scrssn, force
keep scrssn admission 
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\dpp4\diabetes_af_dpp4_cvafter.dta", replace 
***93 --> 110

**** STEP 6: Cleaning admission diagnosis with AF hospitalization file for DPP4 patients
clear all
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\AF SGLT2\Diabetes_af_dpp4_afafter.dta", clear
rename  ScrSSN scrssn
gen dof= dofc(DPP4FillTime)
gen admission= dofc(AdmitDateTime)
drop if admission - dof < 8
by scrssn admission, sort: gen scrssn_n = _n
keep if scrssn_n == 1
duplicates drop scrssn, force
keep scrssn admission
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\dpp4\diabetes_af_dpp4_af_admission.dta", replace 
*** 303 hospitalizations for AF --> 328

**** STEP 7 Merge all sglt2 Files
clear all
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\sglt2\diabetes_af_sglt2_af_admission.dta"
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\sglt2\diabetes_af_sglt2_cvafter.dta"
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\sglt2\diabetes_af_sglt2_abprocafter.dta"
drop _merge
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\sglt2\diabetes_af_sglt2_finalAF.dta", replace
*** 430 --> 550

**** STEP 8 Merge all DPP4 Files
clear all
use  "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\dpp4\diabetes_af_dpp4_af_admission.dta"
merge 1:1 scrssn using  "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\dpp4\diabetes_af_dpp4_cvafter.dta"
drop _merge
merge 1:1 scrssn using  "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\dpp4\diabetes_af_dpp4_abprocafter.dta"
drop _merge
save  "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\dpp4\diabetes_af_dpp4_finalAF.dta", replace
*** 328 --> 360



