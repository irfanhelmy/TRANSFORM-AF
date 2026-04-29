*** Cleaning medication files in sglt2 group

*** STEP 1: Identifying patients on ACEI and or ARB
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\AF SGLT2\diabetes_af_sglt2_ace.dta"
rename ScrSSN scrssn
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\sglt2\diabetes_af_sglt2_ace.dta", replace
*** 652 patients on ACEI

*** ARB
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\AF SGLT2\diabetes_af_sglt2_arb.dta"
rename ScrSSN scrssn
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\sglt2\diabetes_af_sglt2_arb.dta", replace
*** 684 patients on ARB

*** Merging ACEI and ARB
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\sglt2\diabetes_af_sglt2_ace.dta",
unique scrssn
drop _merge
duplicates drop scrssn, force
keep scrssn 
gen ACE=1
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\sglt2\diabetes_af_sglt2_ace_arb.dta", replace
*** 1330 patients on ACEI or ARB

*** ARNI
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\AF SGLT2\diabetes_af_sglt2_sacuval.dta"
 rename ScrSSN scrssn
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn
gen ARNI=1
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\sglt2\diabetes_af_sglt2_sacuval.dta", replace
*212 patients on ARNI
***********************************************************************************************************************************

*** STEP 2: Identifying patients on Betablockers
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\AF SGLT2\diabetes_af_sglt2_bb.dta"
rename ScrSSN scrssn
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
drop scrssn_n
keep scrssn
gen BB=1
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\sglt2\diabetes_af_sglt2_bb.dta", replace
*** 1542 patients on BB

***********************************************************************************************************************************

*** STEP 3: Identifying patients on Antiarryhtmics
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\AF SGLT2\diabetes_af_sglt2_antiarr.dta"
rename ScrSSN scrssn
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn
gen antiarr=1
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\sglt2\diabetes_af_sglt2_antiarr.dta", replace
*** 665 patients 


***********************************************************************************************************************************

*** STEP 4: Identifying patients on glp1 analogs
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\AF SGLT2\diabetes_af_sglt2_glp1.dta"
rename ScrSSN scrssn
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn
gen glp1=1
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\sglt2\diabetes_af_sglt2_glp1.dta", replace
*** 261 patients 



***********************************************************************************************************************************

*** STEP 5: Identifying patients on insulin
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\AF SGLT2\diabetes_af_sglt2_insulin.dta"
rename ScrSSN scrssn
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn
gen insulin=1
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\sglt2\diabetes_af_sglt2_insulin.dta", replace
*** 1120 patients 


***********************************************************************************************************************************

*** STEP 6: Identifying patients on loop diuretic
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\AF SGLT2\diabetes_af_sglt2_loopdiuretic.dta"
rename ScrSSN scrssn
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn
gen LD=1
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\sglt2\diabetes_af_sglt2_loopdiuretic.dta", replace
***2196 patients 

***********************************************************************************************************************************

*** STEP 7: Identifying patients on metformin
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\AF SGLT2\diabetes_af_sglt2_metformin.dta"
rename ScrSSN scrssn
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn
gen metformin=1
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\sglt2\diabetes_af_sglt2_metformin.dta", replace
***853 patients 


***********************************************************************************************************************************

*** STEP 8: Identifying patients on MRA
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\AF SGLT2\diabetes_af_sglt2_spiroep.dta"
rename ScrSSN scrssn
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn
gen spiro=1
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\sglt2\diabetes_af_sglt2_spiroep.dta", replace
***456 patients 


***********************************************************************************************************************************

*** STEP 9: Identifying patients on TZD
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\AF SGLT2\diabetes_af_sglt2_thiazol.dta"
rename ScrSSN scrssn
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn
gen TZD=1
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\sglt2\diabetes_af_sglt2_thiazol.dta", replace
***23 patients 



***********************************************************************************************************************************


*** STEP 10: Merging all medications 

clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\sglt2\diabetes_af_sglt2_ace_arb.dta"
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\sglt2\diabetes_af_sglt2_sacuval.dta"
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\sglt2\diabetes_af_sglt2_bb.dta"
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\sglt2\diabetes_af_sglt2_antiarr.dta"
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\sglt2\diabetes_af_sglt2_glp1.dta"
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\sglt2\diabetes_af_sglt2_insulin.dta"
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\sglt2\diabetes_af_sglt2_loopdiuretic.dta"
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\sglt2\diabetes_af_sglt2_metformin.dta"
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\sglt2\diabetes_af_sglt2_spiroep.dta"
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\sglt2\diabetes_af_sglt2_thiazol.dta"
drop _merge

replace ACE =0 if ACE==.
replace ARNI =0 if ARNI==.
replace BB =0 if BB==.
replace antiarr =0 if antiarr==.
replace insulin=0 if insulin==.
replace LD=0 if LD==.
replace metformin=0 if metformin==.
replace spiro=0 if spiro==.
replace TZD=0 if TZD==.
replace glp1=0 if glp1==.

save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\sglt2\diabetes_af_sglt2_final_med_merged.dta", replace
** 3314 patients on sglt2



