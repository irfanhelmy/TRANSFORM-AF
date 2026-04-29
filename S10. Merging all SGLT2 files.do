
*** Merging all sglt2 files

******************************************************************************************************************************************
*** STEP 1: Merging all files 
clear all
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\SGLT2\diabetes_af_SGLT2_final_med_merged.dta"
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\SGLT2\diabetes_af_SGLT2_final_comorbidities_merged.dta"
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\SGLT2\diabetes_af_SGLT2_final_lab_merged.dta"
drop _merge 
gen SGLT2=1
order scrssn SGLT2

******************************************************************************************************************************************
*** STEP 2: Replacing missed values in medications to 0 

replace ACE =0 if ACE==.
replace ARNI =0 if ARNI==.
replace BB =0 if BB==.
replace antiarr =0 if antiarr==.
replace insulin=0 if insulin==.
replace LD=0 if LD==.
replace metformin=0 if metformin==.
replace spiro=0 if spiro==.
replace TZD=0 if TZD==.
replace sglt2=0 if sglt2==.

******************************************************************************************************************************************
*** STEP 3: Replacing missed values in comorbidities to 0

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
replace HF =0 if HF ==.

******************************************************************************************************************************************
*** STEP 4: Merging with prior HFH files

merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\SGLT2\diabetes_af_sglt2_HFH.dta"
drop _merge
replace HFH=0 if HFH==.
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\SGLT2\diabetes_af_sglt2_prior_HFH.dta", 
drop _merge 
replace THFH=0 if THFH==.
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\SGLT2\diabetes_af_SGLT2_final_merged.dta", replace

****3715 patients