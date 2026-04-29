*** Cleaning medication files in DPP4 group

*** STEP 1: Identifying patients on ACEI and or ARB
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\AF GLP1\diabetes_af_dpp4glp1_ace.dta"
rename ScrSSN scrssn
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\dpp4\diabetes_af_dpp4glp1_ace.dta", replace
*** 429 patients on ACE

*** ARB
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\AF GLP1\diabetes_af_dpp4glp1_arb.dta"
rename ScrSSN scrssn
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\dpp4\diabetes_af_dpp4glp1_arb.dta", replace
*** 213 patients on ARB

*** Merging ACEI and ARB
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\dpp4\diabetes_af_dpp4glp1_ace.dta",
unique scrssn
drop _merge
duplicates drop scrssn, force
keep scrssn 
gen ACE=1
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\dpp4\diabetes_af_dpp4glp1_ace_arb.dta", replace
*** 640 patients on ACEI or ARB

*** STEP 1B: ARNI
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\AF GLP1\diabetes_af_dpp4glp1_sacuval.dta"
gen ARNI=1
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\dpp4\diabetes_af_dpp4glp1_sacuval.dta"
* 16 patients on ARNI
 
***********************************************************************************************************************************

*** STEP 2: Identifying patients on Betablockers
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\AF GLP1\diabetes_af_dpp4glp1_bb.dta"
rename ScrSSN scrssn
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
drop scrssn_n
keep scrssn
gen BB=1
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\dpp4\diabetes_af_dpp4glp1_bb.dta", replace
*** 782 patients on BB

***********************************************************************************************************************************

*** STEP 3: Identifying patients on Antiarryhtmics
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\AF GLP1\diabetes_af_dpp4glp1_antiarr.dta"
rename ScrSSN scrssn
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn
gen antiarr=1
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\dpp4\diabetes_af_dpp4glp1_antiarr.dta", replace
*** 411 patients 

***********************************************************************************************************************************

*** STEP 4: Identifying patients on SGLT-2 analogs
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\AF GLP1\diabetes_af_dpp4glp1_sglt2.dta"
rename ScrSSN scrssn
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn
gen sglt2=1
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\dpp4\diabetes_af_dpp4glp1_sglt2.dta", replace
***39 patients 



***********************************************************************************************************************************

*** STEP 5: Identifying patients on insulin
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\AF GLP1\diabetes_af_dpp4glp1_insulin.dta"
rename ScrSSN scrssn
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn
gen insulin=1
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\dpp4\diabetes_af_dpp4glp1_insulin.dta", replace
***136 patients 


***********************************************************************************************************************************

*** STEP 6: Identifying patients on loop diuretic
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\AF GLP1\diabetes_af_dpp4glp1_loop.dta"
rename ScrSSN scrssn
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn
gen LD=1
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\dpp4\diabetes_af_dpp4glp1_loop.dta", replace
***903 patients on loop diuretic 

***********************************************************************************************************************************

*** STEP 7: Identifying patients on metformin
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\AF GLP1\diabetes_af_dpp4glp1_metformin.dta"
rename ScrSSN scrssn
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn
gen metformin=1
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\dpp4\diabetes_af_dpp4glp1_metfor.dta", replace
***518 patients 


***********************************************************************************************************************************

*** STEP 8: Identifying patients on MRA
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\AF GLP1\diabetes_af_dpp4glp1_spiroep.dta"
rename ScrSSN scrssn
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn
gen spiro=1
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\dpp4\diabetes_af_dpp4glp1_spiroep.dta", replace
*** 166 patients on mra


***********************************************************************************************************************************

*** STEP 9: Identifying patients on SU
***clear
***use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\AF GLP1\diabetes_af_dpp4glp1_su.dta"
***rename ScrSSN scrssn
***by scrssn, sort: gen scrssn_n = _n
***keep if scrssn_n==1
***keep scrssn
***gen SU=1
***save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\dpp4\diabetes_af_dpp4glp1_su.dta", replace 
***0 patients 


***********************************************************************************************************************************

*** STEP 9: Identifying patients on TZD
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\AF GLP1\diabetes_af_dpp4glp1_thiazol.dta"
rename ScrSSN scrssn
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn
gen TZD=1
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\dpp4\diabetes_af_dpp4glp1_thiazol.dta", replace
***4 patients 



***********************************************************************************************************************************

*** STEP 10: Merging all medications 

clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\dpp4\diabetes_af_dpp4glp1_ace_arb.dta"
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\dpp4\diabetes_af_dpp4glp1_sacuval.dta"
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\dpp4\diabetes_af_dpp4glp1_bb.dta"
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\dpp4\diabetes_af_dpp4glp1_antiarr.dta"
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\dpp4\diabetes_af_dpp4glp1_sglt2.dta"
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\dpp4\diabetes_af_dpp4glp1_insulin.dta"
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\dpp4\diabetes_af_dpp4glp1_loop.dta"
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\dpp4\diabetes_af_dpp4glp1_metfor.dta"
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\dpp4\diabetes_af_dpp4glp1_spiroep.dta"
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\dpp4\diabetes_af_dpp4glp1_thiazol.dta"
drop _merge

replace ACE =0 if ACE==.
replace ARNI=0 if ARNI==.
replace BB =0 if BB==.
replace antiarr =0 if antiarr==.
replace insulin=0 if insulin==.
replace LD=0 if LD==.
replace metformin=0 if metformin==.
replace spiro=0 if spiro==.
replace TZD=0 if TZD==.
replace sglt2=0 if sglt2==.
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\dpp4\diabetes_af_dpp4glp1_final_med_merged.dta", replace
***1649 patients




