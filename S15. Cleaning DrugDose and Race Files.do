
*** Clean drugdose files
*** DPP4
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\AF SGLT2\diabetes_af_dpp4_drugdose.dta"
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
sort DrugNameWithoutDose
*manually cleaned missing drug names
keep scrssn DrugNameWithoutDose
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\dpp4\diabetes_af_dpp4_drugdose.dta", replace
*** 2079 patients 


*** SGLT2
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\AF SGLT2\diabetes_af_sglt2_drugdose.dta"
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
*manually cleaned missing drug names
keep scrssn DrugNameWithoutDose
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\sglt2\diabetes_af_sglt2_drugdose.dta", replace
*** 3715 patients

*** Merge drugdose files
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\dpp4\diabetes_af_dpp4_drugdose.dta"
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\sglt2\diabetes_af_sglt2_drugdose.dta"
drop if _merge ==3
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\final_survival_analysis_data.dta"
keep if _merge==3
drop _merge

*** Clean race files
*** DPP4
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\AF SGLT2\diabetes_af_dpp4_race.dta"
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn Race 
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\dpp4\diabetes_af_dpp4_race.dta"

*** SGLT2i
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\AF SGLT2\diabetes_af_sglt2_race.dta"
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn Race 
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\sglt2\diabetes_af_sglt2_race.dta"

*** Merge race files
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\dpp4\diabetes_af_dpp4_race.dta"
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\sglt2\diabetes_af_sglt2_race.dta"
drop if _merge ==3
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\final_survival_analysis_data.dta"
drop _merge
 save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\diabetes_af_final_race.dta"