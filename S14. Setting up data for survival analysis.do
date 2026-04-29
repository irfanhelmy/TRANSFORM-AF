**** STEP 1:  Merging final SGLT2 and DPP4 combined files to heart failure hospitalization file 
clear all
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\diabetes_af_final_sglt2_dpp4.dta"
gen year= year(dof)
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\diabetes_af_dpp4_sglt2_finalAF.dta"
drop if _merge==2
drop _merge

*******************************************************************************************************************************************

**** STEP 2
*** Splitting continous variables (age and BMI) into categorical variables for regression 
gen bmi2 = round(bmi,1)
**rounding bmi values to nearest number 
replace bmi2=. if bmi2>60
*** 19 changes made
drop bmi


** Splitting age into clinically relevant groups
gen agegp=age
recode agegp (18/49=1) (50/60=2) (61/70=3) (71/80=4) ( 80/100=5)
tab agegp

** Splitting BMI into clinically relevant groups
gen obesity = bmi2
recode obesity (0/18.4=1) (18.5/24.9=2) (25.0/29.9=3) (30/34.9=4) (35.0/39.9=5) (40/60=6)

*** STEP 3
*** Checking associations of covariates with exposure and outcome
foreach var of varlist agegp obesity sex hypertension ckd esrd stroke MI CAD pad HF copd depression alcohol polyabuse cancer hypothyroidism cld BB ACE spiro antiarr LD insulin metformin TZD glp1 HFH Ablation {
	tab `var' treatment, col chi
}

foreach var of varlist age bmi2 hba1c hemoglobin creatinine bnp pbnp {
	ttest `var', by(treatment)
}



*******************************************************************************************************************************************
**** STEP 4: IPTW

** STEP 4A: Checking standardized difference prior to matching 
*pbalchk treatment age obesity sex HF Ablation copd depression alcohol hypothyroidism hypertension CAD MI ckd cld cancer pad polyabuse stroke THFH ACE ARNI BB antiarr insulin LD metformin spiro year

pbalchk treatment age bmi2 sex HF HFH Ablation copd depression alcohol hypothyroidism hypertension CAD MI ckd cld cancer pad polyabuse stroke ACE ARNI BB antiarr LD spiro glp1 insulin metformin hemoglobin creatinine hba1c year

** STEP 4B: Calculating logistic regression, probability of treatment assignment for each patient (total observations 4,808/5597; some missing values)
logistic treatment age bmi2 sex HF HFH Ablation copd depression alcohol hypothyroidism hypertension CAD MI ckd cld cancer pad polyabuse stroke ACE ARNI BB antiarr LD spiro glp1 insulin metformin hemoglobin creatinine hba1c year


** Calculating p
predict p
gen q=1-p if treatment ==0
drop weight
gen weight=.

** Calculating inverse of probability 
replace weight =1/p if treatment==1
replace weight =1/q if treatment==0

** STEP 4C: Checking balance post matching 
pbalchk treatment age bmi2 sex HF HFH Ablation copd depression alcohol hypothyroidism hypertension CAD MI ckd cld cancer pad polyabuse stroke ACE ARNI BB antiarr LD spiro glp1 insulin metformin hemoglobin creatinine hba1c year, wt(weight)
** < 10% difference for all variables 

graph tw kdensity p if treatment ==0||kdensity p if treatment ==1
graph tw kdensity p if treatment ==0||kdensity p if treatment==1 [w=weight]
sum weight,de
sum p if treatment ==1,de
sum p if treatment ==0, de

** STEP 4D: Residual imbalance post matching; removing extreme weights
gen p2=p if p>0.05 & p<0.95
gen q2=q if q>0.05 & q<0.95

gen weight2=.

replace weight2=1/p2 if treatment ==1
replace weight2=1/q2 if treatment ==0

pbalchk treatment age bmi2 sex HF HFH Ablation copd depression alcohol hypothyroidism hypertension CAD MI ckd cld cancer pad polyabuse stroke ACE ARNI BB antiarr LD spiro glp1 insulin metformin hemoglobin creatinine hba1c year, wt(weight2)
** No residual imbalance after excluding extreme weights 

graph tw kdensity p if treatment ==0||kdensity p if treatment==1 [w=weight2]


*******************************************************************************************************************************************
*** STEP 5: Merging with file with entire age and dof information 
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\final_age_dof.dta"
keep if _merge ==3
drop _merge
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\final_survival_analysis_data.dta", replace

************************************************************************************************************************************************************************************************************************************************************
*** STEP 6: Survival analyses 
clear all
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\final_survival_analysis_data.dta",


*** Baseline characteristics
foreach var of varlist agegp obesity sex hypertension ckd esrd stroke MI CAD pad HF copd depression alcohol polyabuse cancer hypothyroidism cld BB ACE spiro antiarr LD insulin metformin TZD HFH Ablation {
	tab `var' treatment, col
}

foreach var of varlist age bmi2 hba1c hemoglobin creatinine bnp pbnp {
	sum `var', by(treatment)
}

*setting up follow-up time, dropping patients who initiated drug after follow-up time
replace follow_up=mdy(7,31,2021)
drop failure
gen failure=1 if admission < follow_up | dod < follow_up
recode failure .=0
replace outcome=min(admission, dod, follow_up)

drop if dof>=follow_up

*generating outcome frequency data
gen death=0 if dod==.
replace death=1 if dod!=.
replace death=0 if dod>follow_up
tab death treatment, col

gen admission_HF=0 if admission==.
replace admission_HF=1 if admission!=.
replace admission_HF=0 if admission>follow_up 
tab admission_HF treatment, col


***INTERMEDIATE STEP: hierarchical adjustment of covariates
 clear all
 use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\final_survival_analysis_data.dta",
 
 stset outcome, id(scrssn) origin(dof) failure(failure==1) exit(failure==1 time follow_up) scale(365.25)
 
 strate agegp, per(100)
 
 foreach var of varlist agegp obesity sex hypertension ckd esrd stroke MI CAD pad HF copd depression alcohol polyabuse cancer hypothyroidism cld BB ACE spiro antiarr LD insulin metformin glp1 HFH Ablation {
 	strate `var', per(100)
 }
 
  foreach var of varlist agegp obesity sex hypertension ckd esrd stroke MI CAD pad HF copd depression alcohol polyabuse cancer hypothyroidism cld BB ACE spiro antiarr LD insulin metformin glp1 HFH Ablation {
 	stmh `var'
 }
 
***Survival analysis:
 clear all
 use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\final_survival_analysis_data.dta",
stset outcome, id(scrssn) origin(dof) failure(failure==1) exit(failure==1 time follow_up) scale(365.25)

sum _t, detail

stcox treatment obesity HFH THFH Ablation HF copd creatinine hemoglobin antiarr LD agegp sex hypertension ckd stroke MI CAD pad polyabuse cancer hypothyroidism cld ACE ARNI insulin metformin glp1

estat phtest

stcox treatment obesity HFH THFH Ablation HF copd creatinine hemoglobin antiarr LD agegp sex hypertension ckd stroke MI CAD pad polyabuse cancer hypothyroidism cld ACE ARNI insulin metformin glp1
*adding weight or weight2 to the model above did not change HR, and also did not improve the model by LRT

*****for TRANSFORM-AF: after hierarchical model-building
stcox treatment agegp sex obesity CAD LD year HF creatinine weight2

estat phtest
stphplot, by(treatment)

sts graph, adjustfor(agegp obesity HF hypertension ckd CAD pad insulin copd metformin antiarr LD BB ACE stroke spiro weight2) by(treatment)

**** STEP 7: Weibull AFT regression 
clear all
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\final_survival_analysis_data.dta",
stset outcome, id(scrssn) origin(dof) failure(failure==1) exit(failure ==1 time follow_up) scale(365.25)

*** Weibull AFT regression 
streg treatment obesity HFH THFH Ablation HF copd creatinine hemoglobin antiarr LD agegp sex hypertension ckd stroke MI CAD pad polyabuse cancer hypothyroidism cld ACE ARNI insulin metformin glp1 weight2, distribution(weibull) time nolog

*** Weibull AFT regression with new model via hierarchical confounders
streg treatment agegp obesity sex CAD LD year HF creatinine weight2, distribution(weibull) tratio

*** STEP 8: mortality alone
clear all
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\final_survival_analysis_data.dta",
gen death=1 if dod<follow_up
recode death .=0
gen outcome2=min(dod,follow_up)
stset outcome2, id(scrssn) origin(dof) failure(death==1) exit(death==1 time follow_up) scale(365.25)

streg treatment obesity HFH THFH Ablation HF copd creatinine hemoglobin antiarr LD agegp sex hypertension ckd stroke MI CAD pad polyabuse cancer hypothyroidism cld ACE ARNI insulin metformin glp1 weight2, distribution(weibull) time nolog

*** Weibull AFT regression with new model via hierarchical confounders
streg treatment agegp obesity sex CAD LD year HF creatinine weight2, distribution(weibull) tratio


*** STEP 9: Competing risk analyses

clear all
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\final_survival_analysis_data.dta",
replace follow_up= mdy(07,31,2021)
replace admission=. if admission>=follow_up
replace dod=. if dod>=follow_up
gen event = 0 if follow_up~=.
replace event = 2 if dod ~=.
replace event = 1 if admission ~=. 
replace outcome = min(admission, dod,follow_up)
gen time = outcome-dof
stset outcome, id(scrssn) origin(dof) failure(event==1) scale(365.25)
*stcrreg treatment obesity HFH THFH Ablation HF copd creatinine hemoglobin antiarr LD agegp sex hypertension ckd stroke MI CAD pad polyabuse cancer hypothyroidism cld ACE ARNI insulin metformin glp1,compete(event==2)
stcrreg treatment agegp obesity sex CAD LD year HF creatinine weight2, compete(event==2)
*stcurve, cif at(treatment=(0 1) obesity HFH THFH Ablation HF copd creatinine hemoglobin antiarr LD age sex hypertension ckd stroke MI CAD pad polyabuse cancer hypothyroidism cld ACE ARNI insulin metformin glp1) range (0 3)
stcurve, cif at(treatment=(0 1) agegp obesity sex CAD LD year HF creatinine weight2) range (0 3) ylabel(0 "0" .05 "5" .10 "10" .15 "15" .2 "20" .25 "25")