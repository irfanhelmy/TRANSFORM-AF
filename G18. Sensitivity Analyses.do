*SENSITIVITY ANALYSES

*** STEP 1: repeat main analysis
clear all
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\final_survival_analysis_data.dta",

replace follow_up=mdy(7,31,2021)
gen failure=1 if admission < follow_up | dod < follow_up
recode failure .=0
drop if dof>=follow_up
gen outcome = min(admission, dod, follow_up)

stset outcome, id(scrssn) origin(dof) failure(failure==1) exit(failure ==1 time mdy(7,31,2021)) scale(365.25)

stcox treatment agegp obesity sex ckd ACE insulin hba1c creatinine weight4

*** STEP 2: compare GLP-1 to SU
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\dpp4\diabetes_af_dpp4glp1_drugdose.dta"
*_merge==1 --> GLP-1 group; _merge==2 group: not matched, _merge==3 --> matched DPP4i
drop if _merge==2
drop _merge

*clean up names:
replace DrugNameWithoutDose = "SITAGLIPTIN"  if DrugNameWithoutDose=="*Missing*"
gen SU=1 if DrugNameWithoutDose=="GLIMEPIRIDE" | DrugNameWithoutDose=="GLIPIZIDE" | DrugNameWithoutDose=="GLYBURIDE"

*analysis
preserve
keep if SU==1 | glp1==1

stset outcome, id(scrssn) origin(dof) failure(failure==1) exit(failure ==1 time mdy(7,31,2021)) scale(365.25)

stcox treatment agegp obesity sex ckd ACE insulin hba1c creatinine weight4
restore

*** STEP 3: semaglutide vs. non-semaglutide

merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\glp1\diabetes_af_glp1_drugdose.dta"
drop if _merge==2
drop _merge

*clean up names:
replace DrugNameWithoutDose = "EXENATIDE" if LocalDrugNameWithDose== "EXENATIDE 2MG/PEN INJ SA SUSP" | LocalDrugNameWithDose == "INV EXENATIDE 2MG/PLCB INJ (MB001-089)" | LocalDrugNameWithDose== "EXENATIDE 2MG/VIL INJ SA SUSP"
replace DrugNameWithoutDose = "LIRAGLUTIDE" if LocalDrugNameWithDose== "LIRAGLUTIDE (VICTOZA) 6MG/ML INJ PEN 3ML" | LocalDrugNameWithDose == "ZZZLIRAGLUTIDE (VICTOZA) 6MG/ML INJ PEN"
replace DrugNameWithoutDose = "SEMAGLUTIDE"  if DrugNameWithoutDose=="*Missing*"
gen semaglutide=1 if DrugNameWithoutDose=="SEMAGLUTIDE"
replace semaglutide=0 if DrugNameWithoutDose=="DULAGLUTIDE" | DrugNameWithoutDose=="EXENATIDE" | DrugNameWithoutDose=="LIRAGLUTIDE"

*analyses
*1) semaglutide vs. non-semaglutide: change "treatment" to "semaglutide" in Cox regression
stcox semaglutide agegp obesity HF hypertension ckd CAD pad insulin copd sglt2 metformin antiarr LD BB ACE stroke spiro

stcox semaglutide agegp obesity HF hypertension ckd CAD pad insulin copd sglt2 metformin antiarr LD BB ACE stroke spiro weight2

*2) semaglutide vs. DPP4i/SU
preserve
keep if semaglutide==1 | dpp4==1
stset outcome, id(scrssn) origin(dof) failure(failure==1) exit(failure ==1 time mdy(7,31,2021)) scale(365.25)
stcox treatment agegp obesity HF hypertension ckd CAD pad insulin copd sglt2 metformin antiarr LD BB ACE stroke spiro
stcox treatment agegp obesity HF hypertension ckd CAD pad insulin copd sglt2 metformin antiarr LD BB ACE stroke spiro weight2
restore

*3) non-semaglutide vs. DPP4i/SU 
preserve
keep if semaglutide==0 | dpp4==1
stset outcome, id(scrssn) origin(dof) failure(failure==1) exit(failure ==1 time mdy(7,31,2021)) scale(365.25)
stcox treatment agegp obesity HF hypertension ckd CAD pad insulin copd sglt2 metformin antiarr LD BB ACE stroke spiro
stcox treatment agegp obesity HF hypertension ckd CAD pad insulin copd sglt2 metformin antiarr LD BB ACE stroke spiro weight2
restore