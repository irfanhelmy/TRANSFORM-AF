***Repeating primary analysis
clear all
 use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\final_survival_analysis_data.dta",
stset outcome, id(scrssn) origin(dof) failure(failure==1) exit(failure ==1 time follow_up) scale(365.25)

*streg treatment obesity HFH THFH Ablation HF copd creatinine hemoglobin antiarr LD agegp sex hypertension ckd stroke MI CAD pad polyabuse cancer hypothyroidism cld ACE ARNI insulin metformin glp1, distribution(weibull) time nolog

*streg treatment obesity HFH THFH Ablation HF copd creatinine hemoglobin antiarr LD agegp sex hypertension ckd stroke MI CAD pad polyabuse cancer hypothyroidism cld ACE ARNI insulin metformin glp1 weight2, distribution(weibull) time nolog

stcox treatment agegp sex obesity CAD LD year HF creatinine weight2
estat phtest
*PH assumption violated

streg treatment agegp obesity sex CAD LD year HF creatinine weight2, distribution(weibull) tratio

***Subgroup analysis 

*** Elderly above 75  

preserve
drop if age <75
streg treatment obesity sex CAD LD year HF creatinine weight2, distribution(weibull) tratio
restore

preserve
drop if age >=75
streg treatment obesity sex CAD LD year HF creatinine weight2, distribution(weibull) tratio
restore

gen elderly = 1 if age>=75
replace elderly = 0 if elderly ==.

streg i.treatment##i.elderly obesity sex CAD LD year HF creatinine weight2, distribution(weibull) tratio

***************************************************************************************************************************************************************************************************************************************************

*** HF
preserve
drop if HF ==1 
streg treatment agegp obesity sex CAD LD year creatinine weight2, distribution(weibull) tratio
restore

preserve
drop if HF ==0
streg treatment agegp obesity sex CAD LD year creatinine weight2, distribution(weibull) tratio
restore

streg i.treatment##i.HF agegp obesity sex CAD LD year creatinine weight2, distribution(weibull) tratio

***************************************************************************************************************************************************************************************************************************************************
*** CKD
preserve
drop if ckd ==1 
streg treatment agegp obesity sex CAD LD year HF creatinine weight2, distribution(weibull) tratio
restore

preserve
drop if ckd ==0
streg treatment agegp obesity sex CAD LD year HF creatinine weight2, distribution(weibull) tratio
restore


streg i.treatment##i.ckd agegp obesity sex CAD LD year HF creatinine weight2, distribution(weibull) tratio

***************************************************************************************************************************************************************************************************************************************************
*** BMI
*** BMI < 18.5
preserve
keep if obesity==1
streg treatment agegp obesity sex CAD LD year HF creatinine weight2, distribution(weibull) tratio
restore

*** unable to analyze "convergence not achieved" N = 7

*** BMI 18.5-24.9
preserve
keep if obesity==2
streg treatment HFH THFH Ablation HF copd creatinine hemoglobin antiarr LD agegp sex hypertension ckd stroke MI CAD pad polyabuse cancer hypothyroidism cld ACE ARNI insulin metformin glp1 weight2, distribution(weibull) time nolog
restore

** BMI < 24.9 (i.e. merging first two groups)
preserve
keep if obesity==1 | obesity==2
streg treatment agegp sex CAD LD year HF creatinine weight2, distribution(weibull) tratio
restore

*** BMI 25.0-29.9
preserve
keep if obesity==3
streg treatment agegp sex CAD LD year HF creatinine weight2, distribution(weibull) tratio
restore

*** BMI 30-34.9
preserve
keep if obesity==4
streg treatment agegp sex CAD LD year HF creatinine weight2, distribution(weibull) tratio
restore

*** BMI 35.0-39.9
preserve
keep if obesity==5
streg treatment agegp obesity sex CAD LD year HF creatinine weight2, distribution(weibull) tratio
restore

*** BMI 40-60
preserve
keep if obesity==6
streg treatment agegp obesity sex CAD LD year HF creatinine weight2, distribution(weibull) tratio
restore

quietly streg i.treatment##i.obesity agegp sex CAD LD year HF creatinine weight2, distribution(weibull) tratio
est store A
quietly streg i.treatment i.obesity agegp sex CAD LD year HF creatinine weight2, distribution(weibull) tratio
est store B
lrtest A B

*****to be consistent with AF GLP1 subgroup analysis, will split obesity at BMI=30 and BMI=40
gen obesity2=obesity
recode obesity2 1/3=1 4/5=2 6=3
*** BMI < 30
preserve
keep if obesity2==1
streg treatment agegp sex CAD LD year HF creatinine weight2, distribution(weibull) tratio
restore


*** BMI 30-40
preserve
keep if obesity2==2
streg treatment agegp sex CAD LD year HF creatinine weight2, distribution(weibull) tratio
restore

*** BMI 40-60
preserve
keep if obesity2==3
streg treatment agegp sex CAD LD year HF creatinine weight2, distribution(weibull) tratio
restore


streg i.treatment##i.obesity2 agegp sex CAD LD year HF creatinine weight2, distribution(weibull) tratio
est store A
streg i.treatment i.obesity2 agegp sex CAD LD year HF creatinine weight2, distribution(weibull) tratio
est store B
lrtest A B

***************************************************************************************************************************************************************************************************************************************************
*** Hypertension 

preserve
drop if hypertension==1
streg treatment agegp obesity sex CAD LD year HF creatinine weight2, distribution(weibull) tratio
restore

preserve
drop if hypertension==0
streg treatment agegp obesity sex CAD LD year HF creatinine weight2, distribution(weibull) tratio
restore

streg i.treatment##i.hypertension agegp obesity sex CAD LD year HF creatinine weight2, distribution(weibull) tratio


************************************************************
*** Prior cardioversion/ablation

preserve
drop if Ablation==1
streg treatment agegp obesity sex CAD LD year HF creatinine weight2, distribution(weibull) tratio
restore

preserve
drop if Ablation==0
streg treatment agegp obesity sex CAD LD year HF creatinine weight2, distribution(weibull) tratio
restore

streg i.treatment##i.Ablation agegp obesity sex CAD LD year HF creatinine weight2, distribution(weibull) tratio

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
stset outcome, id(scrssn) origin(dof) failure(failure==1) exit(failure ==1 time td(30April2024)) scale(365.25)

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
stset outcome, id(scrssn) origin(dof) failure(failure==1) exit(failure ==1 time td(30April2024)) scale(365.25)

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
stset outcome, id(scrssn) origin(dof) failure(failure==1) exit(failure ==1 time td(30April2024)) scale(365.25)

**** analysing dulaglutide
replace treatment =2 if GLP ==3
drop if treatment ==1 
stcox treatment agegp obesity ckd sex AF copd depression alcohol hypothyroidism hypertension MI CAD cld cancer pad polyabuse ppm schizo stroke ACE BB HFH THFH antiarr sglt2 insulin LD metformin spiro statin ARNI year weight2


