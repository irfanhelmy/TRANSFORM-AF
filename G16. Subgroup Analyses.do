clear all
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\final_survival_analysis_data.dta",

replace follow_up=mdy(07,31,2021)

gen failure=1 if admission < follow_up | dod < follow_up
recode failure .=0

drop if dof>=follow_up
gen outcome = min(admission, dod, follow_up)

stset outcome, id(scrssn) origin(dof) failure(failure==1) exit(failure ==1 time mdy(07,31,2021)) scale(365.25)

stcox treatment agegp obesity HF hypertension ckd CAD pad insulin copd sglt2 metformin antiarr LD BB ACE stroke spiro weight2

stcox treatment agegp obesity HF hypertension ckd CAD pad insulin copd sglt2 metformin antiarr LD BB ACE stroke spiro

stcox treatment agegp obesity sex ckd ACE insulin creatinine hba1c weight4

sts graph, by(treatment) 


***Subgroup analysis 

*** Elderly 

preserve
drop if age <75
stcox treatment obesity sex ckd ACE insulin creatinine hba1c weight4
restore

preserve
drop if age >=75
stcox treatment obesity sex ckd ACE insulin creatinine hba1c weight4
restore

gen elderly = 1 if age>=75
replace elderly = 0 if elderly ==.

stcox i.treatment##i.elderly obesity sex ckd ACE insulin creatinine hba1c weight4

***************************************************************************************************************************************************************************************************************************************************


*** BMI
*** BMI 30-40
preserve
drop if obesity ==6 
stcox treatment agegp obesity sex ckd ACE insulin creatinine hba1c weight4
restore


*** BMI > 40
preserve
keep if obesity ==6 
stcox treatment agegp obesity sex ckd ACE insulin creatinine hba1c weight4
restore



gen obesity1 = bmi2
recode obesity1  (30/39.9=1) (40/60=2)

stcox i.treatment##i.obesity1 agegp sex ckd ACE insulin creatinine hba1c weight4

***************************************************************************************************************************************************************************************************************************************************


*** Hypertension 

preserve
drop if hypertension==1
stcox treatment agegp obesity sex ckd ACE insulin creatinine hba1c weight4
restore


preserve
drop if hypertension==0
stcox treatment agegp obesity sex ckd ACE insulin creatinine hba1c weight4
restore


stcox i.treatment##i.hypertension agegp obesity sex ckd ACE insulin creatinine hba1c weight4


***************************************************************************************************************************************************************************************************************************************************

*** CKD
preserve
drop if ckd ==1 
stcox treatment agegp obesity sex ckd ACE insulin creatinine hba1c weight4
restore


preserve
drop if ckd ==0
stcox treatment agegp obesity sex ckd ACE insulin creatinine hba1c weight4
restore

stcox i.treatment##i.ckd agegp obesity sex ckd ACE insulin creatinine hba1c weight4


***************************************************************************************************************************************************************************************************************************************************

*** HF
preserve
drop if HF ==1 
stcox treatment agegp obesity sex ckd ACE insulin creatinine hba1c weight4
restore

preserve
drop if HF ==0
stcox treatment agegp obesity sex ckd ACE insulin creatinine hba1c weight4
restore


stcox i.treatment##i.HF agegp obesity sex ckd ACE insulin creatinine hba1c weight4

***************************************************************************************************************************************************************************************************************************************************

*** Prior Ablation/cardioversion
preserve
drop if Ablation==1
stcox treatment agegp obesity sex ckd ACE insulin creatinine hba1c  weight4
restore

preserve
drop if Ablation ==0
stcox treatment agegp obesity sex ckd ACE insulin creatinine hba1c weight4
restore

stcox i.treatment##i.Ablation agegp obesity sex ckd ACE insulin creatinine hba1c weight4


***************************************************************************************************************************************************************************************************************************************************

** Specific GLP1 use 
clear all
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\HFrEF GLP1\diabetes_hfref_glp1_drugdose.dta", clear
gen GLP = 1 if DrugNameWithoutDose =="Missing" | DrugNameWithoutDose =="SEMAGLUTIDE"
replace GLP = 2 if DrugNameWithoutDose =="LIRAGLUTIDE"
replace GLP = 3 if DrugNameWithoutDose =="DULAGLUTIDE"
replace GLP = 4 if DrugNameWithoutDose =="EXENATIDE"
replace GLP = 1 if GLP==.
keep scrssn GLP
merge m:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files hf\final_survival_analysis_data.dta",
drop if _merge ==1
stset outcome, id(scrssn) origin(dof) failure(failure==1) exit(failure ==1 time follow_up) scale(365.25)

**** analysing only semgalutide
replace treatment =2 if GLP ==1
drop if treatment ==1 
stcox treatment agegp obesity ckd sex AF copd depression alcohol hypothyroidism hypertension MI CAD cld cancer pad polyabuse ppm schizo stroke ACE BB HFH THFH antiarr sglt2 insulin LD metformin spiro statin ARNI year weight2




***************************************************************************************************************************************************************************************************************************************************

clear all
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\HFrEF GLP1\diabetes_hfref_glp1_drugdose.dta", clear
gen GLP = 1 if DrugNameWithoutDose =="Missing" | DrugNameWithoutDose =="SEMAGLUTIDE"
replace GLP = 2 if DrugNameWithoutDose =="LIRAGLUTIDE"
replace GLP = 3 if DrugNameWithoutDose =="DULAGLUTIDE"
replace GLP = 4 if DrugNameWithoutDose =="EXENATIDE"
replace GLP = 1 if GLP==.
keep scrssn GLP
merge m:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files hf\final_survival_analysis_data.dta",
drop if _merge ==1
stset outcome, id(scrssn) origin(dof) failure(failure==1) exit(failure ==1 time follow_up) scale(365.25)

**** analysing only liraglutide
replace treatment =2 if GLP ==2
drop if treatment ==1 
stcox treatment agegp obesity ckd sex AF copd depression alcohol hypothyroidism hypertension MI CAD cld cancer pad polyabuse ppm schizo stroke ACE BB HFH THFH antiarr sglt2 insulin LD metformin spiro statin ARNI year weight2



***************************************************************************************************************************************************************************************************************************************************

clear all
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\HFrEF GLP1\diabetes_hfref_glp1_drugdose.dta", clear
gen GLP = 1 if DrugNameWithoutDose =="Missing" | DrugNameWithoutDose =="SEMAGLUTIDE"
replace GLP = 2 if DrugNameWithoutDose =="LIRAGLUTIDE"
replace GLP = 3 if DrugNameWithoutDose =="DULAGLUTIDE"
replace GLP = 4 if DrugNameWithoutDose =="EXENATIDE"
replace GLP = 1 if GLP==.
keep scrssn GLP
merge m:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files hf\final_survival_analysis_data.dta",
drop if _merge ==1
stset outcome, id(scrssn) origin(dof) failure(failure==1) exit(failure ==1 time follow_up) scale(365.25)

**** analysing dulaglutide
replace treatment =2 if GLP ==3
drop if treatment ==1 
stcox treatment agegp obesity ckd sex AF copd depression alcohol hypothyroidism hypertension MI CAD cld cancer pad polyabuse ppm schizo stroke ACE BB HFH THFH antiarr sglt2 insulin LD metformin spiro statin ARNI year weight2

