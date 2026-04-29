
*** Merging both SGLT2 and DPP4 files
clear all
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\dpp4\diabetes_af_dpp4_final_merged.dta"
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\sglt2\diabetes_af_SGLT2_final_merged.dta"
drop if _merge ==3
order scrssn dpp4 SGLT2
gen treatment =1 if SGLT2==1
replace treatment =0 if dpp4==1
order scrssn dpp4 SGLT2 treatment
drop _merge
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\diabetes_af_final_SGLT2_dpp4.dta", replace
** 5670