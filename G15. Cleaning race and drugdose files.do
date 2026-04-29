*** Cleaning Race files
*** DPP4
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\AF GLP1\diabetes_af_dpp4glp1_race.dta"
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn Race 
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\dpp4\diabetes_af_dpp4glp1_race.dta", replace
*** 1983 patients 


*** GLP1
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\AF GLP1\diabetes_af_glp1_race.dta"
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn Race 
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\glp1\diabetes_af_glp1_race.dta", replace
*** 1502 patients

*** Merge race files
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\dpp4\diabetes_af_dpp4glp1_race.dta"
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\glp1\diabetes_af_glp1_race.dta"
drop if _merge ==3
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\diabetes_af_final_glp1_dpp4.dta"
drop _merge
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\diabetes_af_glp1_dpp4_race.dta",replace

*** Merge with main file
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\diabetes_af_final_glp1_dpp4.dta"
gen year= year(dof)
drop if bmi < 30
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\diabetes_af_glp1_dpp4_race.dta"
drop if _merge==2
drop _merge

*** keep if treatment ==1
*** count if Race == "WHITE"
*** count if Race == "BLACK OR AFRICAN AMERICAN"

*** Clean drugdose files
*** DPP4
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\AF GLP1\diabetes_af_dpp4glp1_drugdose.dta"
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn DrugNameWithoutDose 
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\dpp4\diabetes_af_dpp4glp1_drugdose.dta", replace
*** 1991 patients 


*** GLP1
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\AF GLP1\diabetes_af_glp1_drugdose.dta"
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn DrugNameWithoutDose 
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\glp1\diabetes_af_glp1_drugdose.dta", replace
*** 1489 patients

*** Merge drugdose files
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\dpp4\diabetes_af_dpp4glp1_drugdose.dta"
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\glp1\diabetes_af_glp1_drugdose.dta"
drop if _merge ==3
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\diabetes_af_final_glp1_dpp4.dta"
drop _merge
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\diabetes_af_glp1_dpp4_drugdose.dta",replace
drop if bmi < 30 | bmi==. | bmi>60
drop if dof>mdy(7,31,2021)
