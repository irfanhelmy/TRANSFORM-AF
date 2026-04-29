*SENSITIVITY ANALYSES

*** STEP 1: repeat main analysis
clear all
 use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\final_survival_analysis_data.dta",
stset outcome, id(scrssn) origin(dof) failure(failure==1) exit(failure ==1 time follow_up) scale(365.25)
streg treatment agegp obesity sex CAD LD year HF creatinine weight2, distribution(weibull) tratio

*** STEP 2: merge with drug dose files
*** Merge drugdose files
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\dpp4\diabetes_af_dpp4_drugdose.dta"
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\sglt2\diabetes_af_sglt2_drugdose.dta"
drop if _merge ==3
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\final_survival_analysis_data.dta",
keep if _merge==3
drop _merge

*** STEP 3: compare SGLT2i to SU
preserve
drop if DrugNameWithoutDose=="ALOGLIPTIN" | DrugNameWithoutDose=="LINAGLIPTIN" | DrugNameWithoutDose=="SAXAGLIPTIN" | DrugNameWithoutDose=="SITAGLIPTIN" | DrugNameWithoutDose=="SITAGLILPTIN"
stset outcome, id(scrssn) origin(dof) failure(failure==1) exit(failure ==1 time follow_up) scale(365.25)
streg treatment agegp obesity sex CAD LD year HF creatinine weight2, distribution(weibull) tratio
restore

***compare SGLT2i to DPP4i
preserve
keep if DrugNameWithoutDose=="ALOGLIPTIN" | DrugNameWithoutDose=="LINAGLIPTIN" | DrugNameWithoutDose=="SAXAGLIPTIN" | DrugNameWithoutDose=="SITAGLIPTIN" | DrugNameWithoutDose=="SITAGLILPTIN" | treatment==1
stset outcome, id(scrssn) origin(dof) failure(failure==1) exit(failure ==1 time follow_up) scale(365.25)
streg treatment agegp obesity sex CAD LD year HF creatinine weight2, distribution(weibull) tratio
restore