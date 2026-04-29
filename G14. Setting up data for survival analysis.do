**** STEP 1:  Merging final GLP1 and DPP4 combined files to heart failure hospitalization file 
clear all
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\diabetes_af_final_glp1_dpp4.dta"
gen year= year(dof)
drop if bmi < 30
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\diabetes_af_dpp4glp1_glp1_finalAF.dta"
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
pbalchk treatment age bmi2 sex HF HFH Ablation copd depression alcohol hypothyroidism hypertension CAD MI ckd cld cancer pad polyabuse stroke ACE ARNI BB antiarr LD spiro sglt2 insulin metformin creatinine hemoglobin hba1c year

** STEP 4B: Calculating logistic regression, probability of treatment assignment for each patient
logistic treatment age bmi2 sex HF HFH Ablation copd depression alcohol hypothyroidism hypertension CAD MI ckd cld cancer pad polyabuse stroke ACE ARNI BB antiarr LD spiro sglt2 insulin metformin creatinine hemoglobin hba1c year

** Calculating p
predict p
gen q=1-p if treatment ==0
gen weight3=.

** Calculating inverse of probability 
replace weight3 =1/p if treatment==1
replace weight3 =1/q if treatment==0

** STEP 4C: Checking balance post matching 
pbalchk treatment age bmi2 sex HF HFH Ablation copd depression alcohol hypothyroidism hypertension CAD MI ckd cld cancer pad polyabuse stroke ACE ARNI BB antiarr LD spiro sglt2 insulin metformin creatinine hemoglobin hba1c year, wt(weight3)

** STEP 4D: trimming extreme weights
gen p2=p if p>0.1 & p<0.9
gen q2=q if q>0.1 & q <0.9

gen weight4=.

replace weight4=1/p2 if treatment ==1
replace weight4=1/q2 if treatment ==0

pbalchk treatment age bmi2 sex HF HFH Ablation copd depression alcohol hypothyroidism hypertension CAD MI ckd cld cancer pad polyabuse stroke ACE ARNI BB antiarr LD spiro sglt2 insulin metformin creatinine hemoglobin hba1c year, wt(weight4)

*kernel density plot pre-match
graph tw kdensity p if treatment ==0||kdensity p if treatment==1

*post-match
graph tw kdensity p if treatment ==0||kdensity p if treatment==1 [w=weight4]

*******************************************************************************************************************************************

*** STEP 5: gen outcome date variable (composite of HFH or mortality; whichever comes first)
gen follow_up =.
replace follow_up=mdy(7,31,2021)
gen failure=1 if admission < follow_up | dod < follow_up
recode failure .=0
drop if dof>=follow_up
drop if bmi==.
gen outcome = min(admission, dod, follow_up)

*******************************************************************************************************************************************
*** STEP 6: Merging with file with entire age and dof information 
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\final_age_dof.dta"
keep if _merge ==3
drop _merge
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\final_survival_analysis_data.dta", replace


***INTERMEDIATE STEP: hierarchical adjustment of covariates
 clear all
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\final_survival_analysis_data.dta",

replace follow_up=mdy(7,31,2021)
gen failure=1 if admission < follow_up | dod < follow_up
recode failure .=0
drop if dof>=follow_up
gen outcome = min(admission, dod, follow_up)

stset outcome, id(scrssn) origin(dof) failure(failure==1) exit(failure ==1 time mdy(7,31,2021)) scale(365.25)

*a priori confounders: age, sex, BMI
stcox treatment agegp2 sex obesity

foreach var in varlist {
	stcox treatment agegp2 sex obesity `var'
}

************************************************************************************************************************************************************************************************************************************************************
*** STEP 7A: Survival analyses - Primary Outcome
clear all
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\final_survival_analysis_data.dta",

stset outcome, id(scrssn) origin(dof) failure(failure==1) exit(failure ==1 time mdy(7,31,2021)) scale(365.25)

***INTERMEDIATE STEP: checking for association of individual covariates with outcome
foreach var of varlist agegp2 obesity sex hypertension ckd esrd stroke MI CAD pad HF copd depression alcohol polyabuse cancer hypothyroidism cld BB ACE spiro antiarr LD insulin metformin TZD sglt2 HFH Ablation {
	strate `var', per(100)
	stmh `var'
}

***INTERMEDIATE STEP 2: missing data analysis
misstable summarize
gen missing=1 if creatinine ==. | hemoglobin==.
recode missing .=0
tab missing
tab missing treatment, col chi



*** SURVIVAL ANALYSIS

stcox treatment agegp obesity HF hypertension ckd CAD pad insulin copd sglt2 metformin antiarr LD BB ACE stroke spiro

stcox treatment agegp2 obesity HF hypertension ckd CAD pad insulin copd sglt2 metformin antiarr LD BB ACE stroke spiro weight2

*included creatinine/hemoglobin in Cox model and in propensity score model (weight4)
stcox treatment agegp obesity HF hypertension ckd CAD pad insulin copd sglt2 metformin antiarr LD BB ACE stroke spiro creatinine hemoglobin weight4

*included variables via hierarchial method
stcox treatment agegp obesity sex ckd ACE insulin hba1c creatinine weight4

estat phtest
 
sts graph, adjustfor(agegp obesity sex ckd ACE insulin creatinine hba1c weight4) by(treatment)

***STEP 7B: Survival Analysis - Mortality alone
clear all
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\final_survival_analysis_data.dta",

replace follow_up=mdy(7,31,2021)
gen death=0
replace death = 1 if dod < follow_up
drop if dof>=follow_up
gen outcome2 = min(dod, follow_up)

stset outcome2, id(scrssn) origin(dof) failure(death==1) exit(death ==1 time mdy(7,31,2021)) scale(365.25)

stcox treatment agegp obesity HF hypertension ckd CAD pad insulin copd sglt2 metformin antiarr LD BB ACE stroke spiro

stcox treatment agegp2 obesity HF hypertension ckd CAD pad insulin copd sglt2 metformin antiarr LD BB ACE stroke spiro weight2

stcox treatment agegp obesity sex ckd ACE insulin creatinine hba1c weight4

estat phtest


*** STEP 8 Competing risk analyses

clear all
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\final_survival_analysis_data.dta",
gen follow_up2 =.
replace follow_up2= mdy(07,31,2021)
replace admission=. if admission>=follow_up2
replace dod=. if dod>=follow_up2
gen event = 0 if follow_up2~=.
replace event = 2 if dod ~=.
replace event = 1 if admission ~=. 
replace outcome = min(admission, dod,follow_up2)
gen time = outcome-dof
stset outcome, id(scrssn) origin(dof) failure(event==1) scale(365.25)

/*stcrreg treatment age obesity sex HF copd depression alcohol hypothyroidism hypertension CAD MI ckd cld cancer pad polyabuse stroke ACE ARNI BB antiarr sglt2 insulin LD metformin spiro creatinine hemoglobin year,compete(event==2)
stcurve, cif at(treatment=(0 1) age obesity sex HF copd depression alcohol hypothyroidism hypertension CAD MI ckd cld cancer pad polyabuse stroke THFH ACE BB antiarr sglt2 insulin LD metformin spiro year) range (0 3.06)*/

*Re-do competing risk analysis with new covariates via hierarchical model-building strategy
stcrreg treatment agegp obesity sex ckd ACE insulin creatinine hba1c weight4, compete(event==2)
stcurve, cif at(treatment=(0 1) agegp obesity sex ckd ACE insulin creatinine weight4) range (0 3) ylabel(0 "0" .05 "5" .10 "10" .15 "15" .2 "20" .25 "25")
