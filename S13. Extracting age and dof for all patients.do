*dof = date of (prescription) fill
clear all
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\AF SGLT2\diabetes_af_dpp4_age.dta", clear
gen dpp4 = cofd(DPP4Filltime)
gen dof= dofc(dpp4)
drop dpp4
drop DPP4Filltime
duplicates drop ScrSSN, force
merge 1:m ScrSSN using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\AF SGLT2\diabetes_af_sglt2_age.dta"
drop if _merge ==3
duplicates drop ScrSSN, force
rename ScrSSN scrssn
gen sglt2= cofd(sglt2Filltime)
gen sglt2new =dofc(sglt2)
replace dof= sglt2new if dof==.
count if dof==.
count if age ==.
keep scrssn age dof
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\final_age_dof.dta", replace
