*** cleaning comorbidity files in dpp4i


*** STEP 1: Identifying patients with Ablation

*** Cleaning patients with ablation for AF (CPT Codes)
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\AF GLP1\diabetes_af_dpp4glp1_ablation.dta"
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\dpp4\diabetes_af_dpp4glp1_ablation.dta", replace
*** 26 patients with AF ablation (CPT Codes)

*** Cleaning patients with ablation for AF (Procedure Codes)
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\AF GLP1\diabetes_af_dpp4glp1_abproc.dta"
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\dpp4\diabetes_af_dpp4glp1_abproc.dta", replace
*** 107 patients with AF ablation (Procedure Codes)

*** Combine ablation cpt and proc codes
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\dpp4\diabetes_af_dpp4glp1_ablation.dta"
duplicates drop scrssn, force
keep scrssn
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\dpp4\diabetes_af_dpp4glp1_final_ablation.dta", replace
*** 124 patients with ablation


*** Cleaning patients with cardioversion 
clear 
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\AF GLP1\diabetes_af_dpp4glp1_cv.dta"
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn 
*** 313 patients with cv
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\dpp4\diabetes_af_dpp4glp1_final_ablation.dta"
duplicates drop scrssn, force
keep scrssn
gen Ablation=1
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\dpp4\diabetes_af_dpp4glp1_final_af_1.dta", replace
*** 384 patients with AF including procedure and diagnosis codes 

*************************************************************************************************************************

*** STEP 2: Identifying patients with chronic lung disease
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\AF GLP1\diabetes_af_dpp4glp1_copd.dta"
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn
gen copd=1
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\dpp4\diabetes_af_dpp4glp1_copd.dta", replace
*** 831 patients with COPD

*************************************************************************************************************************

*** STEP 3: Identifying patients with depression 
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\AF GLP1\diabetes_af_dpp4glp1_depression.dta" 
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn
gen depression=1
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\dpp4\diabetes_af_dpp4glp1_dep.dta", replace
*** 652 patients with depression 

*************************************************************************************************************************

*** STEP 4: Identifying patients with ESRD
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\AF GLP1\diabetes_af_dpp4glp1_esrd.dta" 
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn
gen esrd=1
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\dpp4\diabetes_af_dpp4glp1_esrd.dta", replace
*** 12 patients with ESRD  

*************************************************************************************************************************

*** STEP 5: Identifying patients with alcohol abuse
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\AF GLP1\diabetes_af_dpp4glp1_alcohol.dta" 
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn
gen alcohol=1
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\dpp4\diabetes_af_dpp4glp1_alcoholabuse.dta", replace
*** 68 patients with alcohol abuse  

*************************************************************************************************************************

*** STEP 6: Identifying patients with hypothyroidism 
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\AF GLP1\diabetes_af_dpp4glp1_hypo.dta" 
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn
gen hypothyroidism=1
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\dpp4\diabetes_af_dpp4glp1_hypo.dta", replace
*** 271 patients with hypothyroidism

*************************************************************************************************************************

*** STEP 7: Identifying patients with hypertension
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\AF GLP1\diabetes_af_dpp4glp1_hyper.dta" 
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn
gen hypertension=1
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\dpp4\diabetes_af_dpp4glp1_hyper.dta", replace
*** 1402 patients with hypertension

*************************************************************************************************************************

*** STEP 8: Identifying patients with CAD
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\AF GLP1\diabetes_af_dpp4glp1_cad.dta" 
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn
gen CAD= 1
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\dpp4\diabetes_af_dpp4glp1_cad.dta", replace
*** 1179 patients with stable CAD 

*************************************************************************************************************************
*** STEP 9: Identifying patients with prior MI
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\AF GLP1\diabetes_af_dpp4glp1_mi.dta" 
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn
gen MI=1
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\dpp4\diabetes_af_dpp4glp1_mi.dta", replace
*** 324 patients with MI

*************************************************************************************************************************
*** STEP 10: Identifying patients with CKD 
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\AF GLP1\diabetes_af_dpp4glp1_kd.dta" 
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn
gen ckd=1
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\dpp4\diabetes_af_dpp4glp1_kd.dta", replace
*** 655 patients with ckd

*************************************************************************************************************************
*** STEP 11: Identifying patients with liver disease 
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\AF GLP1\diabetes_af_dpp4glp1_ld.dta" 
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn
gen cld=1
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\dpp4\diabetes_af_dpp4glp1_ld.dta", replace
*** 172 patients with cld

*************************************************************************************************************************
*** STEP 12: Identifying patients with malignancy
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\AF GLP1\diabetes_af_dpp4glp1_malignancy.dta" 
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn
gen cancer=1
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\dpp4\diabetes_af_dpp4glp1_malig.dta", replace
*** 17 patients with malignancy


*************************************************************************************************************************
*** STEP 13: Identifying patients with PAD
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\AF GLP1\diabetes_af_dpp4glp1_pad.dta" 
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn
gen pad=1
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\dpp4\diabetes_af_dpp4glp1_pad.dta", replace
*** 331 patients with pad


*************************************************************************************************************************
*** STEP 14: Identifying patients with polysubstance abuse
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\AF GLP1\diabetes_af_dpp4glp1_polyabuse.dta" 
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn
gen polyabuse=1
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\dpp4\diabetes_af_dpp4glp1_polyabuse.dta", replace
*** 137 patients with polysubstance abuse

*************************************************************************************************************************

*** STEP 15: Identifying patients with stroke 
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\AF GLP1\diabetes_af_dpp4glp1_stroke.dta" 
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn
gen stroke=1
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\dpp4\diabetes_af_dpp4glp1_stroke.dta", replace
*** 71 patients with stroke

*************************************************************************************************************************
*** STEP 16: Identifying patients with HF
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\AF GLP1\diabetes_af_dpp4glp1_hf.dta" 
rename ScrSSN scrssn
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn
gen HF=1
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\dpp4\diabetes_af_dpp4glp1_hf.dta", replace
*** 801 patients with HF


*************************************************************************************************************************


*** STEP 17: Merging all comorbidities 

clear 
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\dpp4\diabetes_af_dpp4glp1_final_af_1.dta"
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\dpp4\diabetes_af_dpp4glp1_copd.dta"
drop _merge 
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\dpp4\diabetes_af_dpp4glp1_dep.dta"
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\dpp4\diabetes_af_dpp4glp1_esrd.dta"
drop _merge 
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\dpp4\diabetes_af_dpp4glp1_alcoholabuse.dta"
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\dpp4\diabetes_af_dpp4glp1_hypo.dta"
drop _merge 
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\dpp4\diabetes_af_dpp4glp1_hyper.dta"
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\dpp4\diabetes_af_dpp4glp1_cad.dta"
drop _merge 
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\dpp4\diabetes_af_dpp4glp1_mi.dta"
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\dpp4\diabetes_af_dpp4glp1_kd.dta"
drop _merge 
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\dpp4\diabetes_af_dpp4glp1_ld.dta"
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\dpp4\diabetes_af_dpp4glp1_malig.dta"
drop _merge 
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\dpp4\diabetes_af_dpp4glp1_pad.dta"
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\dpp4\diabetes_af_dpp4glp1_polyabuse.dta"
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\dpp4\diabetes_af_dpp4glp1_stroke.dta"
drop _merge 
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\dpp4\diabetes_af_dpp4glp1_hf.dta"
drop _merge 

replace Ablation=0 if Ablation==.
replace copd = 0 if copd==.
replace depression = 0 if depression==.
replace esrd = 0 if esrd ==.
replace alcohol = 0 if alcohol ==.
replace hypothyroidism = 0 if hypothyroidism ==.
replace hypertension = 0 if hypertension ==.
replace CAD = 0 if CAD ==.
replace MI = 0 if MI ==.
replace ckd = 0 if ckd ==.
replace cld = 0 if cld ==.
replace cancer = 0 if cancer ==.
replace pad = 0 if pad ==.
replace polyabuse = 0 if polyabuse ==.
replace stroke = 0 if stroke ==.
replace HF = 0 if HF==.
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\dpp4\diabetes_af_dpp4glp1_final_comorbidities_merged.dta", replace 
***1912 patients 