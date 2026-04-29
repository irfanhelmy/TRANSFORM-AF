*** cleaning comorbidity files in dpp4i


*** STEP 1: Cleaning age and sex files
clear
cd "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\AF SGLT2"
use diabetes_af_dpp4_age
rename ScrSSN scrssn
gen dof= dofc(DPP4Filltime)
gen sex = 1 if SEX=="M"
replace sex=2 if SEX=="F"
drop SEX
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
drop scrssn_n
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\dpp4\diabetes_af_dpp4_age.dta", replace
*****************************************************************************************************************************

*** STEP 2: Cleaning dod files 
clear
use diabetes_af_dpp4_dod
rename ScrSSN scrssn
rename MPI_DOD dod
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
drop scrssn_n
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\dpp4\diabetes_af_dpp4_dod.dta", replace
*** 855 patients who died during follow up
*****************************************************************************************************************************

*** STEP 3: Merging age,sex,dob and dod files
clear 
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\dpp4\diabetes_af_dpp4_age.dta"
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\dpp4\diabetes_af_dpp4_dod.dta"
gen survival = dod-dof
rename DOB dob
count if survival <0
drop if survival < 0
gen survival1 = dod -dob
count if survival1<0
drop _merge survival survival1
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\dpp4\diabetes_af_dpp4_demograhics.dta", replace
*** 2078 patients 
*****************************************************************************************************************************

*** STEP 4: Cleaning BMI files (BMI AT BASELINE)
clear
use diabetes_af_dpp4_bmi
rename ScrSSN scrssn
duplicates drop scrssn, force
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\dpp4\diabetes_af_dpp4_bmi.dta", replace
** 2057 patients

*****************************************************************************************************************************
*** STEP 5: Cleaning BNP files 
clear all
use diabetes_af_dpp4_bnp
drop patientsid
drop if LabChemResultNumericValue > 20000
***312 observations deleted
*** bnp > 10000 is likely an error 
gen dof= dofc(DPP4FillTime)
gen bnpdate = dofc(LabChemCompleteDateTime)
by scrssn bnpdate, sort: gen scrssn_n = _n
*** droping duplicate values of bnp

keep if scrssn_n==1
drop scrssn_n
by scrssn, sort: gen scrssn_n = _n
bysort scrssn : keep if scrssn_n==_N
*** keeping only bnp value closest to the drug filling date

count if bnpdate > dof
*** doublechecking to make sure all bnp values are before durg initiation

duplicates drop scrssn, force
rename LabChemResultNumericValue bnpvalue
keep scrssn dof bnpdate bnpvalue
*** cleaning variables  

save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\dpp4\diabetes_af_dpp4_bnp.dta", replace 
*** 492 patients with BNP value


*****************************************************************************************************************************
*** STEP 5: Cleaning proBNP files 
clear
use diabetes_af_dpp4_pbnp

drop if LabChemResultNumericValue > 100000
***5 observations deleted
*** proBNPbnp > 100000 is likely an error 
gen dof= dofc(DPP4FillTime)
gen pbnpdate = dofc(LabChemCompleteDateTime)
by scrssn pbnpdate, sort: gen scrssn_n = _n
*** droping duplicate values of proBNP

keep if scrssn_n==1
drop scrssn_n
by scrssn, sort: gen scrssn_n = _n
bysort scrssn : keep if scrssn_n==_N
*** keeping only proBNP value closest to the drug filling date

count if pbnpdate > dof
*** doublechecking to make sure all proBNP values are before durg initiation

duplicates drop scrssn, force
rename LabChemResultNumericValue pbnp
keep scrssn dof pbnpdate pbnp
*** cleaning variables  

save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\dpp4\diabetes_af_dpp4_pbnp.dta", replace 
*** 734 patients with proBNP value

*****************************************************************************************************************************
*** STEP 6: Cleaning creatinine files 

clear all
use diabetes_af_dpp4_creatinine

gen creatdate = dofc(LabChemCompleteDateTime)
gen dof= dofc(DPP4Filltime)
rename ScrSSN scrssn

drop if LabChemResultNumericValue > 10
*** creatinine > 10 is likely an error 

by scrssn creatdate, sort: gen scrssn_n = _n
keep if scrssn_n==1
drop scrssn_n
*** droping duplicate values of creatinine

by scrssn, sort: gen scrssn_n = _n
bysort scrssn : keep if scrssn_n==_N
*** keeping only creatinine value closest to the drug filling date

count if creatdate > dof
*** doublechecking to make sure all creatinine values are before drug initiation

duplicates drop scrssn, force
rename LabChemResultNumericValue creatinine
keep scrssn dof creatdate creatinine
*** cleaning variables  

save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\dpp4\diabetes_af_dpp4_creatinine.dta", replace 
***** 2028 patients

*****************************************************************************************************************************

*** STEP 8: Cleaning hemoglobin files 

clear all
use diabetes_af_dpp4_hemoglobin

gen hemoglobindate = dofc(LabChemCompleteDateTime)
gen dof= dofc(DPP4FillTime)

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
bysort scrssn : keep if scrssn_n==_N
*** keeping only Hb value closest to the drug filling date

count if hemoglobindate > dof
*** doublechecking to make sure all hb values are before drug initiation

duplicates drop scrssn, force
rename LabChemResultNumericValue hemoglobin
keep scrssn dof hemoglobindate hemoglobin
*** cleaning variables  

save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\dpp4\diabetes_af_dpp4_hemoglobin.dta", replace
***1960 patients with hemoglobin values 

*****************************************************************************************************************************


*** STEP 13: Cleaning HBA1c files 

clear all
use diabetes_af_dpp4_hba1c.dta

gen hba1cdatedate = dofc(LabChemCompleteDateTime)
gen dof= dofc(DPP4FillTime)

drop if LabChemResultNumericValue >15
*** cleaning erroinius values

by scrssn hba1cdate, sort: gen scrssn_n = _n
keep if scrssn_n==1
drop scrssn_n
*** droping duplicate values of HBA1c

by scrssn, sort: gen scrssn_n = _n
bysort scrssn : keep if scrssn_n==_N
*** keeping only creatinine value closest to the drug filling date

count if hba1cdatedate > dof
*** doublechecking to make sure all HBA1c values are before drug initiation

duplicates drop scrssn, force
rename LabChemResultNumericValue hba1c
keep scrssn dof hba1cdate hba1c
*** cleaning variables  

save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\dpp4\diabetes_af_dpp4_hba1c.dta", replace
*** 1764 patients with HBA1C values 

*****************************************************************************************************************************
*** STEP 13: Merging all laboratory files 
clear all
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\dpp4\diabetes_af_dpp4_demograhics.dta"
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\dpp4\diabetes_af_dpp4_bmi.dta"
drop DPP4Filltime HeightTime WeightTime _merge
rename heightresult height
rename weightresult weight
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\dpp4\diabetes_af_dpp4_bnp.dta"
rename bnpvalue bnp
drop bnpdate _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\dpp4\diabetes_af_dpp4_pbnp.dta"
drop pbnpdate _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\dpp4\diabetes_af_dpp4_creatinine.dta"
drop creatdate _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\dpp4\diabetes_af_dpp4_hemoglobin.dta"
drop hemoglobindate _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\dpp4\diabetes_af_dpp4_hba1c.dta"
drop hba1cdate _merge
order scrssn age sex dob dof height weight bmi bnp pbnp creatinine hemoglobin hba1c 
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\SGLT2 new files AF\dpp4\diabetes_af_dpp4_final_lab_merged.dta", replace
***  patients 