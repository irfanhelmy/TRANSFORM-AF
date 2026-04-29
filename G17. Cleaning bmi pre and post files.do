
***DPP4i 

*** STEP 1: Cleaning BMI files at baseline 
clear all
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\AF GLP1\diabetes_af_dpp4glp1_bmi.dta"
rename ScrSSN scrssn
drop patientsid HeightTime heightresult
gen bmipre = round(bmi,1)
gen weightpre = round(weightresult,1)
drop bmi weightresult
format %td WeightTime
rename WeightTime wttimepre
duplicates drop scrssn, force 
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\AF GLP1\diabetes_af_dpp4glp1_bmi_pre.dta", replace

*** STEP 2: Cleaning BMI files post drug initiation 
clear 
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\AF GLP1\diabetes_af_dpp4glp1_bmi_after.dta"
rename ScrSSN scrssn
drop patientsid HeightTime heightresult
gen bmipost = round(bmi,1)
gen weightpost = round(weightresult,1)
drop bmi weightresult
format %td WeightTime
rename WeightTime wttimepost
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\AF GLP1\diabetes_af_dpp4glp1_bmi_post.dta", replace


*** STEP 3: Merging BMI files 
clear all
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\AF GLP1\diabetes_af_dpp4glp1_bmi_pre.dta"
merge 1:m scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\AF GLP1\diabetes_af_dpp4glp1_bmi_post.dta"
drop if _merge==2
drop _merge
drop if weightpost < 50
drop if weightpost < 100
drop if weightpost > 500
bysort scrssn weightpost: keep if _n ==1
duplicates drop scrssn, force
gen wtchange = 100*(weightpre- weightpost)/ weightpost
gen treatment =0
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\AF GLP1\diabetes_af_dpp4glp1_bmi_change.dta", replace 


*** GLPi


*** STEP 4: Cleaning BMI files at baseline 
clear all
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\AF GLP1\diabetes_af_glp1_bmi.dta"
rename ScrSSN scrssn
drop patientsid HeightTime heightresult
gen bmipre = round(bmi,1)
gen weightpre = round(weightresult,1)
drop bmi weightresult
format %td WeightTime
rename WeightTime wttimepre
duplicates drop scrssn, force 
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\AF GLP1\diabetes_af_glp1_bmi_pre.dta", replace

*** STEP 5: Cleaning BMI files post drug initiation 
clear 
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\AF GLP1\diabetes_af_glp1_bmi_after.dta"
rename ScrSSN scrssn
drop patientsid HeightTime heightresult
gen bmipost = round(bmi,1)
gen weightpost = round(weightresult,1)
drop bmi weightresult
format %td WeightTime
rename WeightTime wttimepost
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\AF GLP1\diabetes_af_glp1_bmi_post.dta", replace


*** STEP 6: Merging BMI files 
clear all
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\AF GLP1\diabetes_af_glp1_bmi_pre.dta"
merge 1:m scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\AF GLP1\diabetes_af_glp1_bmi_post.dta"
drop if _merge ==2
drop _merge
drop if weightpost < 50
drop if weightpost < 100
drop if weightpost >500
bysort scrssn weightpost: keep if _n ==1
duplicates drop scrssn, force
gen wtchange = 100*(weightpre- weightpost)/ weightpost
gen treatment = 1
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\AF GLP1\diabetes_af_glp1_bmi_change.dta", replace

*** STEP 7: Merging DPP4i and GLPi files 
clear all 
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\AF GLP1\diabetes_af_dpp4glp1_bmi_change.dta"
merge m:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\AF GLP1\diabetes_af_glp1_bmi_change.dta"
drop if _merge ==3
drop _merge 
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\AF GLP1\diabetes_af_bmi_change.dta", replace 


**** STEP 8: Imputation of missing data
clear all
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\AF GLP1\diabetes_af_bmi_change.dta"
merge m:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\final_survival_analysis_data.dta",
drop if _merge ==1
drop _merge
mi set wide
mi register imputed wtchange
drop if age ==.
mi impute regress wtchange age treatment sex HF Ablation copd depression alcohol hypothyroidism hypertension CAD MI ckd cld cancer pad polyabuse stroke THFH ACE BB antiarr insulin LD metformin spiro year, add(20) rseed(1234) force
replace wtchange = ( _1_wtchange + _2_wtchange + _3_wtchange + _4_wtchange + _5_wtchange + _6_wtchange + _7_wtchange + _8_wtchange + _9_wtchange + _10_wtchange + _11_wtchange + _12_wtchange + _13_wtchange + _14_wtchange + _15_wtchange + _16_wtchange + _17_wtchange + _18_wtchange + _19_wtchange + _20_wtchange)/20 if wtchange ==.
summarize wtchange if treatment ==1
summarize wtchange if treatment ==0
ttest wtchange, by (treatment)


