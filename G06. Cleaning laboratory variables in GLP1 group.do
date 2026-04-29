*** cleaning comorbidity files in glp1i

*** STEP 1: Cleaning age and sex files
clear
cd "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\AF GLP1"
use diabetes_af_glp1_age.dta
gen dof= dofc(glp1Filltime)
gen sex = 1 if SEX=="M"
replace sex=2 if SEX=="F"
drop SEX
rename ScrSSN scrssn
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
drop scrssn_n
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\glp1\diabetes_af_glp1_age.dta", replace
** 1505
*****************************************************************************************************************************

*** STEP 2: Cleaning dob and dod files 
clear
use diabetes_af_glp1_dod
rename ScrSSN scrssn
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
rename MPI_DOD dod
drop scrssn_n
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\glp1\diabetes_af_glp1_dod.dta", replace
*** 448 patients who died during follow up --> 636 (as of 9/2025)
*****************************************************************************************************************************

*** STEP 3: Merging age,sex,dob and dod files
clear all
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\glp1\diabetes_af_glp1_age.dta"
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\glp1\diabetes_af_glp1_dod.dta"
gen survival = dod-dof
count if survival <0
drop if survival < 0
gen survival1 = dod -DOB
count if survival1<0
drop _merge survival survival1
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\glp1\diabetes_af_glp1_demograhics.dta", replace
** 1505
*****************************************************************************************************************************

*** STEP 4: Cleaning BMI files (BMI AT BASELINE)
clear all
use diabetes_af_glp1_bmi.dta
rename ScrSSN scrssn
duplicates drop scrssn, force
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\glp1\diabetes_af_glp1_bmi.dta", replace
*** 1484 patients with BMI values 

*****************************************************************************************************************************
*** STEP 5: Cleaning BNP files 
clear all
use diabetes_af_glp1_bnp.dta
drop if LabChemResultNumericValue > 20000
*** bnp > 10000 is likely an error 

gen dof= dofc(GLP1filltime)
gen bnpdate = dofc(LabChemCompleteDateTime)
by scrssn bnpdate, sort: gen scrssn_n = _n
*** droping duplicate values of bnp

keep if scrssn_n==1
drop scrssn_n
by scrssn, sort: gen scrssn_n = _n
bysort scrssn (LabChemResultNumericValue): keep if scrssn_n==_N
*** keeping only bnp value closest to the drug filling date

count if bnpdate > dof
*** doublechecking to make sure all bnp values are before durg initiation

duplicates drop scrssn, force
rename LabChemResultNumericValue bnpvalue
keep scrssn dof bnpdate bnpvalue
*** cleaning variables  

save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\glp1\diabetes_af_glp1_bnp.dta", replace 
*** 391 patients with BNP value


*****************************************************************************************************************************
*** STEP 5: Cleaning proBNP files 
clear all
use diabetes_af_glp1_pbnp.dta

drop if LabChemResultNumericValue > 100000
*** proBNPbnp > 100000 is likely an error 

gen dof= dofc(GLP1filltime)
gen pbnpdate = dofc(LabChemCompleteDateTime)
by scrssn pbnpdate, sort: gen scrssn_n = _n
*** droping duplicate values of proBNP

keep if scrssn_n==1
drop scrssn_n
by scrssn, sort: gen scrssn_n = _n
bysort scrssn (LabChemResultNumericValue): keep if scrssn_n==_N
*** keeping only proBNP value closest to the drug filling date

count if pbnpdate > dof
*** doublechecking to make sure all proBNP values are before durg initiation

duplicates drop scrssn, force
rename LabChemResultNumericValue pbnp
keep scrssn dof pbnpdate pbnp
*** cleaning variables  

save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\glp1\diabetes_af_glp1_pbnp.dta", replace 
*** 604 patients with proBNP value

*****************************************************************************************************************************
*** STEP 6: Cleaning creatinine files 

clear all
use diabetes_af_glp1_creatinine.dta

gen creatdate = dofc(LabChemCompleteDateTime)
gen dof= dofc(GLP1Filltime)
rename ScrSSN scrssn

drop if LabChemResultNumericValue > 10
*** creatinine > 10 is likely an error 

by scrssn creatdate, sort: gen scrssn_n = _n
keep if scrssn_n==1
drop scrssn_n
*** droping duplicate values of creatinine

by scrssn, sort: gen scrssn_n = _n
bysort scrssn (LabChemResultNumericValue): keep if scrssn_n==_N
*** keeping only creatinine value closest to the drug filling date

count if creatdate > dof
*** doublechecking to make sure all creatinine values are before drug initiation

duplicates drop scrssn, force
rename LabChemResultNumericValue creatinine
keep scrssn dof creatdate creatinine
*** cleaning variables  

save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\glp1\diabetes_af_glp1_creatinine.dta", replace 
** 1462 patients with creatinine 

*****************************************************************************************************************************

*** STEP 8: Cleaning hemoglobin files 

clear all
use diabetes_af_glp1_hemoglobin.dta

gen hemoglobindate = dofc(LabChemCompleteDateTime)
gen dof= dofc(GLP1filltime)


drop if LabChemResultNumericValue > 20 
drop if LabChemResultNumericValue < 4
*** cleaning erroinius values

drop if regexm( LabChemTestName, "GLYCATED")==1
**Some glycated HB values

by scrssn hemoglobindate, sort: gen scrssn_n = _n
keep if scrssn_n==1
drop scrssn_n
*** droping duplicate values of Hb

by scrssn, sort: gen scrssn_n = _n
bysort scrssn (LabChemResultNumericValue): keep if scrssn_n==_N
*** keeping only Hb value closest to the drug filling date

count if hemoglobindate > dof
*** doublechecking to make sure all hemoglobin values are before drug initiation

duplicates drop scrssn, force
rename LabChemResultNumericValue hemoglobin
keep scrssn dof hemoglobindate hemoglobin
*** cleaning variables  

save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\glp1\diabetes_af_glp1_hemoglobin.dta", replace
**1385 patients with hemoglobin values 

*****************************************************************************************************************************

*** STEP 13: Cleaning HBA1c files 

clear all
use diabetes_af_glp1_hba1c.dta

gen hba1cdatedate = dofc(LabChemCompleteDateTime)
gen dof= dofc(GLP1filltime)

drop if LabChemResultNumericValue >15
*** cleaning erroneous values

by scrssn hba1cdate, sort: gen scrssn_n = _n
keep if scrssn_n==1
drop scrssn_n
*** droping duplicate values of ast

by scrssn, sort: gen scrssn_n = _n
bysort scrssn (LabChemResultNumericValue): keep if scrssn_n==_N
*** keeping only HBA1c value closest to the drug filling date

count if hba1cdatedate > dof
*** doublechecking to make sure all HBA1c values are before drug initiation

duplicates drop scrssn, force
rename LabChemResultNumericValue hba1c
keep scrssn dof hba1cdate hba1c
*** cleaning variables  

save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\glp1\diabetes_af_glp1_hba1c.dta", replace
****1353 patients with hba1c value

*****************************************************************************************************************************
*** STEP 13: Merging all laboratory files 
clear all
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\glp1\diabetes_af_glp1_demograhics.dta"
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\glp1\diabetes_af_glp1_bmi.dta"
drop glp1Filltime HeightTime WeightTime _merge
rename heightresult height
rename weightresult weight
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\glp1\diabetes_af_glp1_bnp.dta"
rename bnpvalue bnp
drop bnpdate _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\glp1\diabetes_af_glp1_pbnp.dta"
drop pbnpdate _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\glp1\diabetes_af_glp1_creatinine.dta"
drop creatdate _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\glp1\diabetes_af_glp1_hemoglobin.dta"
drop hemoglobindate _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\glp1\diabetes_af_glp1_hba1c.dta"
drop hba1cdatedate _merge
order scrssn age sex DOB dof height weight bmi bnp pbnp creatinine hemoglobin hba1
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\GLP1 new files AF\glp1\diabetes_af_glp1_final_lab_merged.dta", replace
*** 1505 patients with lab values 