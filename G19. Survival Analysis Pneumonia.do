**PNEUMONIA/FALSIFICATION OUTCOME

**STEP 1: merge final survival analysis file with pneumonia file
clear all
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\final_survival_analysis_data.dta"
replace follow_up=mdy(7,31,2021)
drop if dof>=follow_up
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\glp1\diabetes_af_glp1_dpp4_pneumonia_after.dta"
drop if _merge ==2
drop _merge

**STEP 2: setting up variables
gen outcome=min(admission_pneumonia, dod, follow_up)

gen failure=0 if (admission_pneumonia > follow_up) & (dod>follow_up)
replace failure=1 if failure==.

tab pneumonia_after treatment

**STEP 3: survival analysis
stset outcome, id(scrssn) origin(dof) failure(failure==1) exit(failure ==1 time follow_up) scale(365.25)

stcox treatment agegp obesity sex ckd ACE insulin hba1c creatinine weight4

/*
**STEP 4: double-check with competing risk analysis (PNA only)
replace follow_up= mdy(07,31,2021)
replace admission_pneumonia=. if admission_pneumonia>=follow_up
replace dod=. if dod>=follow_up
gen event = 0 if follow_up~=.
replace event = 2 if dod ~=.
replace event = 1 if admission_pneumonia ~=. 
gen outcome = min(admission_pneumonia, dod,follow_up)
gen time = outcome-dof
stset outcome, id(scrssn) origin(dof) failure(event==1) scale(365.25)
stcrreg treatment agegp obesity HF hypertension ckd CAD pad insulin copd sglt2 metformin antiarr LD BB ACE stroke spiro,compete(event==2)
