/* Diabetic Afib SGLT2 Study */

/* Run the below command to select the required database */
use ORD_Sundaram_202108013D
go

/* SGLT2 */

/* Extract all the patients that are on SGLT2 */

select distinct a.PatientSID, a.ScrSSN, a.AF_Dischargedatetime, b.FillDateTime as SGLT2FillTime , b.FillNumber, b.DaysSupply 

into Dflt.Sglt2AF

from Dflt.Diabetes_AFibFinal as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill as b with (NOLOCK) on a.PatientSID= b.PatientSID
where b.LocalDrugNameWithDose like '%empagliflozin%' 
or b.LocalDrugNameWithDose like '%dapagliflozin%' 
or b.LocalDrugNameWithDose like '%canagliflozin%' 
or b.LocalDrugNameWithDose like '%ertugliflozin%' 
union all

select distinct a.PatientSID, a.ScrSSN, a.AF_Dischargedatetime, b.FillDateTime as SGLT2FillTime , b.FillNumber, b.DaysSupply 

from Dflt.Diabetes_AFibFinal as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID
where b.LocalDrugNameWithDose like '%empagliflozin%' 
or b.LocalDrugNameWithDose like '%dapagliflozin%' 
or b.LocalDrugNameWithDose like '%canagliflozin%' 
or b.LocalDrugNameWithDose like '%ertugliflozin%'

select distinct scrssn from  Dflt.Sglt2AF --16,184
alter table Dflt.Sglt2AF rebuild with (data_compression=page)

/* FInd the total number of refills for each patient */

select scrssn, sum(FillNumber) as FillNumber 
into #tempfillnumber
from Dflt.Sglt2AF group by scrssn 

/* Find the date of medication intiation */

select scrssn, min(SGLT2FillTime) as SGLT2FillTime
into #temp
from Dflt.Sglt2AF group by scrssn

/* Combine the above two tables */

select distinct b.scrssn, b.SGLT2FillTime, a.FillNumber
into #tempfilldate
from #tempfillnumber as a with (NOLOCK) left outer join 
#temp as b with (NOLOCK) on a.scrssn= b.scrssn 


select distinct a.patientsid, b.scrssn, b.SGLT2FillTime, b.FillNumber, a.AF_Dischargedatetime
into #date
from Dflt.Sglt2AF as a with (NOLOCK) left outer join 
#tempfilldate as b with (NOLOCK) on a.scrssn= b.scrssn and a.SGLT2FillTime= b.SGLT2FillTime
where b.SGLT2Filltime between '2014-01-01 00:00:00' and '2021-07-31 23:59:59'
and b.SGLT2Filltime >= dateadd(day, 30, a.AF_Dischargedatetime)

select distinct scrssn from #date --5107

/* Find the patients that were on DPP4/SU 1 year prior to SGLT2 initiation */
select distinct a.scrssn, a.SGLT2FillTime, a.PatientSID, b.FillDateTime

into #DPP4

from #date as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where LocalDrugNameWithDose like '%gliptin%' or 
      LocalDrugNameWithDose like '%Glipizide%' or
			  LocalDrugNameWithDose like '%Glimepiride%' or
			  LocalDrugNameWithDose like '%Glyburide%' or
			  LocalDrugNameWithDose like '%Tolbutamide%' 
--and b.FillDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.scrssn, a.SGLT2FillTime, a.PatientSID, b.FillDateTime
from #date as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where LocalDrugNameWithDose like '%gliptin%' or LocalDrugNameWithDose like '%Glipizide%' or
			  LocalDrugNameWithDose like '%Glimepiride%' or
			  LocalDrugNameWithDose like '%Glyburide%' or
			  LocalDrugNameWithDose like '%Tolbutamide%' 

Select *

into #DPP4Date 

from #DPP4 where FillDateTime between dateadd(month, -12, SGLT2FillTime) and dateadd(day, 1, SGLT2FillTime)

select distinct scrssn from #DPP4Date -- 2,354

/* Exclude the patients that were on DPP4 1 year prior to SGLT2 initiation */

select distinct a.*--, b.DischargeDateTime, c.ICD10ProcedureCode

into #SGLT2excludeDpp4

from #date as a where a.fillnumber >=2
AND NOT EXISTS (Select * from #dpp4Date as b where a.ScrSSN = b.ScrSSN)

select distinct scrssn from #SGLT2excludeDpp4 --2,688

/* Final Cohort (AF/ cardioversion/ Ablation/ Anti Arrythmic Drugs) */

/* AF Diagnosis 1 year prior to drug initiation */
select distinct a.PatientSID,a.ScrSSN,   b.DischargeDateTime ,a.SGLT2FillTime, a.AF_Dischargedatetime

into #tempAF

from #SGLT2excludeDpp4 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')	
and b.DischargeDateTime	between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.PatientSID,a.ScrSSN, b.DischargeDateTime, a.SGLT2FillTime, a.AF_Dischargedatetime

from #SGLT2excludeDpp4 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.PatientSID,a.ScrSSN, b.DischargeDateTime, a.SGLT2FillTime, a.AF_Dischargedatetime

from #SGLT2excludeDpp4 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.PatientSID,a.ScrSSN, b.EventDateTime, a.SGLT2FillTime, a.AF_Dischargedatetime

from #SGLT2excludeDpp4 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.PatientSID,a.ScrSSN,  b.EventDateTime, a.SGLT2FillTime, a.AF_Dischargedatetime

from #SGLT2excludeDpp4 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.PatientSID,a.ScrSSN,  b.EventDateTime, a.SGLT2FillTime, a.AF_Dischargedatetime

from #SGLT2excludeDpp4 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.PatientSID,a.ScrSSN, b.PatientTransferDateTime, a.SGLT2FillTime, a.AF_Dischargedatetime

from #SGLT2excludeDpp4 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
and b.PatientTransferDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.PatientSID,a.ScrSSN,  b.SpecialtyTransferDateTime, a.SGLT2FillTime, a.AF_Dischargedatetime

from #SGLT2excludeDpp4 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
and b.SpecialtyTransferDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.PatientSID,a.ScrSSN,  b.AdmitDateTime, a.SGLT2FillTime, a.AF_Dischargedatetime

from #SGLT2excludeDpp4 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
and b.AdmitDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

/*ICD10 Codes*/
select distinct a.PatientSID,a.ScrSSN, b.DischargeDateTime, a.SGLT2FillTime, a.AF_Dischargedatetime

from #SGLT2excludeDpp4 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.PatientSID,a.ScrSSN,  b.DischargeDateTime, a.SGLT2FillTime, a.AF_Dischargedatetime

from #SGLT2excludeDpp4 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.PatientSID,a.ScrSSN, b.DischargeDateTime, a.SGLT2FillTime, a.AF_Dischargedatetime

from #SGLT2excludeDpp4 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.PatientSID,a.ScrSSN,  b.EventDateTime, a.SGLT2FillTime, a.AF_Dischargedatetime

from #SGLT2excludeDpp4 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.PatientSID,a.ScrSSN,  b.EventDateTime, a.SGLT2FillTime, a.AF_Dischargedatetime

from #SGLT2excludeDpp4 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.PatientSID,a.ScrSSN, b.EventDateTime, a.SGLT2FillTime, a.AF_Dischargedatetime

from #SGLT2excludeDpp4 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)

union all

select distinct a.PatientSID,a.ScrSSN,  b.PatientTransferDateTime, a.SGLT2FillTime, a.AF_Dischargedatetime

from #SGLT2excludeDpp4 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.PatientTransferDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)

union all

select distinct a.PatientSID,a.ScrSSN, b.SpecialtyTransferDateTime, a.SGLT2FillTime, a.AF_Dischargedatetime

from #SGLT2excludeDpp4 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.SpecialtyTransferDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)

union all

select distinct a.PatientSID,a.ScrSSN,   b.AdmitDateTime, a.SGLT2FillTime, a.AF_Dischargedatetime

from #SGLT2excludeDpp4 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.AdmitDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)

select distinct scrssn from #tempAF --1324

/* Cardioversion */
/* Cardioversion Proc codes */

select distinct ICD9ProcedureCode from CDWWork.Dim.ICD9Procedure where ICD9ProcedureCode in ('99.61','99.62') 
select distinct ICD10ProcedureCode from CDWWork.Dim.ICD10Procedure where ICD10ProcedureCode in ('5A2204Z') 

select distinct a.*, b.ICDProcedureDateTime, c.ICD9ProcedureCode
/*ICD9Procedure Codes*/

into #tempAFCardio

from #SGLT2excludeDpp4 as a with (NOLOCK) inner join
Src.Inpat_CensusICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('99.61','99.62')
					and b.ICDProcedureDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.*, b.SurgicalProcedureDateTime, c.ICD9ProcedureCode

from #SGLT2excludeDpp4 as a with (NOLOCK) inner join
Src.Inpat_CensusSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('99.61','99.62')
					and b.SurgicalProcedureDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD9ProcedureCode

from #SGLT2excludeDpp4 as a with (NOLOCK) inner join
Src.Inpat_InpatientICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('99.61','99.62')
					and b.DischargeDateTime  between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD9ProcedureCode

from #SGLT2excludeDpp4 as a with (NOLOCK) inner join
Src.Inpat_InpatientSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('99.61','99.62')
					and b.DischargeDateTime  between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

/*ICD10Procedure Codes*/
select distinct a.*, b.ICDProcedureDateTime, c.ICD10ProcedureCode

from #SGLT2excludeDpp4 as a with (NOLOCK) inner join
Src.Inpat_CensusICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('5A2204Z')
and b.ICDProcedureDateTime  between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.*, b.SurgicalProcedureDateTime, c.ICD10ProcedureCode

from #SGLT2excludeDpp4 as a with (NOLOCK) inner join
Src.Inpat_CensusSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('5A2204Z')
and b.SurgicalProcedureDateTime  between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD10ProcedureCode

from #SGLT2excludeDpp4 as a with (NOLOCK) inner join
Src.Inpat_InpatientICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('5A2204Z')
and b.DischargeDateTime  between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD10ProcedureCode

from #SGLT2excludeDpp4 as a with (NOLOCK) inner join
Src.Inpat_InpatientSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('5A2204Z')
and b.DischargeDateTime  between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)

select distinct scrssn from #tempAFCardio --80

/*Ablation */
/*Ablation Procedure Codes */

select distinct ICD9ProcedureCode from CDWWork.Dim.ICD9Procedure where ICD9ProcedureCode in ('37.33','37.34','37.37','37.80','38.65') 
select distinct ICD10ProcedureCode from CDWWork.Dim.ICD10Procedure where ICD10ProcedureCode in ('02560ZZ','02563ZZ','02564ZZ',
'02570ZZ','02573ZZ','02574ZZ','02580ZZ','02583ZZ','02584ZZ','025S0ZZ','025S3ZZ','025S4ZZ','025T0ZZ','025T3ZZ','025T4ZZ') 

select distinct a.*, b.ICDProcedureDateTime, c.ICD9ProcedureCode
/*ICD9Procedure Codes*/

into #tempAFAbProc

from #SGLT2excludeDpp4 as a with (NOLOCK) inner join
Src.Inpat_CensusICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('37.33','37.34','37.37','37.80','38.65')
					and b.ICDProcedureDateTime  between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.*, b.SurgicalProcedureDateTime, c.ICD9ProcedureCode

from #SGLT2excludeDpp4 as a with (NOLOCK) inner join
Src.Inpat_CensusSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('37.33','37.34','37.37','37.80','38.65')
					and b.SurgicalProcedureDateTime  between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD9ProcedureCode

from #SGLT2excludeDpp4 as a with (NOLOCK) inner join
Src.Inpat_InpatientICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('37.33','37.34','37.37','37.80','38.65')
					and b.DischargeDateTime  between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD9ProcedureCode

from #SGLT2excludeDpp4 as a with (NOLOCK) inner join
Src.Inpat_InpatientSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('37.33','37.34','37.37','37.80','38.65')
					and b.DischargeDateTime  between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

/*ICD10Procedure Codes*/
select distinct a.*, b.ICDProcedureDateTime, c.ICD10ProcedureCode

from #SGLT2excludeDpp4 as a with (NOLOCK) inner join
Src.Inpat_CensusICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('02560ZZ','02563ZZ','02564ZZ',
'02570ZZ','02573ZZ','02574ZZ','02580ZZ','02583ZZ','02584ZZ','025S0ZZ','025S3ZZ','025S4ZZ','025T0ZZ','025T3ZZ','025T4ZZ')
and b.ICDProcedureDateTime  between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.*, b.SurgicalProcedureDateTime, c.ICD10ProcedureCode

from #SGLT2excludeDpp4 as a with (NOLOCK) inner join
Src.Inpat_CensusSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('02560ZZ','02563ZZ','02564ZZ',
'02570ZZ','02573ZZ','02574ZZ','02580ZZ','02583ZZ','02584ZZ','025S0ZZ','025S3ZZ','025S4ZZ','025T0ZZ','025T3ZZ','025T4ZZ')
and b.SurgicalProcedureDateTime  between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD10ProcedureCode

from #SGLT2excludeDpp4 as a with (NOLOCK) inner join
Src.Inpat_InpatientICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('02560ZZ','02563ZZ','02564ZZ',
'02570ZZ','02573ZZ','02574ZZ','02580ZZ','02583ZZ','02584ZZ','025S0ZZ','025S3ZZ','025S4ZZ','025T0ZZ','025T3ZZ','025T4ZZ')
and b.DischargeDateTime  between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD10ProcedureCode

from #SGLT2excludeDpp4 as a with (NOLOCK) inner join
Src.Inpat_InpatientSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('02560ZZ','02563ZZ','02564ZZ',
'02570ZZ','02573ZZ','02574ZZ','02580ZZ','02583ZZ','02584ZZ','025S0ZZ','025S3ZZ','025S4ZZ','025T0ZZ','025T3ZZ','025T4ZZ')
and b.DischargeDateTime  between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)

select distinct scrssn from #tempAFAbProc --34

/* Anti Arrythmic Drugs */

select distinct a.*, b.FillDateTime

into #tempAFAntiArr

from #SGLT2excludeDpp4 as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where LocalDrugNameWithDose like '%soltalol%' 
or LocalDrugNameWithDose like '%Dofetilide%' 
or LocalDrugNameWithDose like '%flecainide%' 
or LocalDrugNameWithDose like '%propafenone%' 
or LocalDrugNameWithDose like '%amiodarone%' 
or LocalDrugNameWithDose like '%dronaderone%'
or LocalDrugNameWithDose like '%digoxin%'

union all

select distinct a.*, b.FillDateTime
from #SGLT2excludeDpp4 as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where LocalDrugNameWithDose like '%soltalol%' 
or LocalDrugNameWithDose like '%Dofetilide%' 
or LocalDrugNameWithDose like '%flecainide%' 
or LocalDrugNameWithDose like '%propafenone%' 
or LocalDrugNameWithDose like '%amiodarone%' 
or LocalDrugNameWithDose like '%dronaderone%'
or LocalDrugNameWithDose like '%digoxin%'


select distinct *

into #tempAFAntiArrdate
from #tempAFAntiArr
where FillDateTime  between dateadd(month, -12, SGLT2FillTime) and dateadd(day, 1, SGLT2FillTime)

select distinct scrssn from #tempAFAntiArrdate --785

select distinct scrssn , SGLT2FillTime , patientsid, AF_Dischargedatetime

into #tempFinalSGLT2

from #tempAF
union all

select distinct scrssn , SGLT2FillTime , patientsid, AF_Dischargedatetime
from #tempAFCardio
union all

select distinct scrssn , SGLT2FillTime , patientsid, AF_Dischargedatetime
from #tempAFAbProc
union all

select distinct scrssn , SGLT2FillTime , patientsid , AF_Dischargedatetime
from #tempAFAntiArrdate

select distinct scrssn from #tempFinalSGLT2 --1645

/* Patients on Anti coagulation drugs 1 year prior to initiation */

select distinct a.scrssn, a.patientsid, a.SGLT2FillTime, a.AF_Dischargedatetime, b.FillDateTime

into #tempsglt2Anticoag

from #tempFinalSGLT2 as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where LocalDrugNameWithDose like '%Warfarin%' or
LocalDrugNameWithDose like '%Rivaroxaban%' or
			  LocalDrugNameWithDose like '%Apixaban%' or
			  LocalDrugNameWithDose like '%Dabigatran%' 
union all

select distinct a.scrssn, a.patientsid, a.SGLT2FillTime, a.AF_Dischargedatetime, b.FillDateTime

from #tempFinalSGLT2 as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where LocalDrugNameWithDose like '%Warfarin%' or
LocalDrugNameWithDose like '%Rivaroxaban%' or
			  LocalDrugNameWithDose like '%Apixaban%' or
			  LocalDrugNameWithDose like '%Dabigatran%' 

select distinct *

into Dflt.Diabetes_AF_SGLT2exclusions

from #tempsglt2Anticoag
where FillDateTime between dateadd(month, -12, SGLT2FillTime) and dateadd(day, 30, SGLT2FillTime)

select distinct scrssn from Dflt.Diabetes_AF_SGLT2exclusions  --1561

/* Important note- Dates have been changed to July 31st 2021 until this point */

select a.scrssn, a.sglt2filltime, a.AF_dischargedatetime, a.filldatetime, b.PatientSID

into Dflt.Diabetes_AF_SGLT2

from Dflt.Diabetes_AF_SGLT2exclusions as a with (NOLOCK) inner join
Src.CohortCrosswalk as b with (NOLOCK) on a.scrssn= b.scrssn 

select distinct scrssn from Dflt.Diabetes_AF_SGLT2 --3715

select distinct patientsid from Dflt.Diabetes_AF_SGLT2 --13,324

select * from Dflt.Diabetes_AF_SGLT2exclusions

/* Add patientsid to the final cohort */

/*BMI*/

/* Select height and weight values from vital signs view to calculate bmi */
drop table #tempDiabetesVitals

select distinct a.PatientSID, a.VitalSignTakenDateTime, a.VitalResult, a.VitalResultNumeric,
 b.SGLT2FillTime, b.ScrSSN, 
c.VitalType

into #tempDiabetesVitals

from Src.Vital_VitalSign as a with (NOLOCK) inner join
Dflt.Diabetes_AF_SGLT2 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.VitalType as c with (NOLOCK) on a.VitalTypeSID=c.VitalTypeSID 
where (a.VitalSignTakenDateTime between dateadd(month, -12, b.SGLT2FillTime) and dateadd(DAY, 1, b.SGLT2FillTime)) AND
c.VitalType in ( 'WEIGHT')
union all

select distinct a.PatientSID, a.VitalSignTakenDateTime, a.VitalResult, a.VitalResultNumeric,
b.SGLT2FillTime,b.ScrSSN, 
c.VitalType

from Src.Vital_VitalSign_Recent as a with (NOLOCK) inner join
Dflt.Diabetes_AF_SGLT2 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.VitalType as c with (NOLOCK) on a.VitalTypeSID=c.VitalTypeSID 
where (a.VitalSignTakenDateTime between dateadd(month, -12, b.SGLT2FillTime) and dateadd(day, 1, b.SGLT2FillTime)) AND 
c.VitalType in ( 'WEIGHT')
union all

select distinct a.PatientSID, a.VitalSignTakenDateTime, a.VitalResult, a.VitalResultNumeric,
b.SGLT2FillTime, b.ScrSSN, 
c.VitalType

from Src.Vital_VitalSign as a with (NOLOCK) inner join
Dflt.Diabetes_AF_SGLT2 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.VitalType as c with (NOLOCK) on a.VitalTypeSID=c.VitalTypeSID 
--where (a.VitalSignTakenDateTime between dateadd(month, -12, b.SGLT2FillTime) and dateadd(day, 1, b.SGLT2FillTime))AND
where a.VitalSignTakenDateTime <= b.SGLT2FillTime and 
c.VitalType in ( 'HEIGHT')
union all

select distinct a.PatientSID, a.VitalSignTakenDateTime, a.VitalResult, a.VitalResultNumeric,
b.SGLT2FillTime,b.ScrSSN, 
c.VitalType

from Src.Vital_VitalSign_Recent as a with (NOLOCK) inner join
Dflt.Diabetes_AF_SGLT2 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.VitalType as c with (NOLOCK) on a.VitalTypeSID=c.VitalTypeSID 
--where (a.VitalSignTakenDateTime between dateadd(month, -12, b.SGLT2FillTime) and dateadd(day, 1, b.SGLT2FillTime))AND
where a.VitalSignTakenDateTime <= b.SGLT2FillTime and 
c.VitalType in ( 'HEIGHT')

select distinct scrssn from #tempDiabetesVitals --3715

/* Seperate weight records into a table */

select * 

into #tempweight

from #tempDiabetesVitals where vitaltype = 'WEIGHT' and VitalResultNumeric != '0'

select distinct scrssn from #tempweight --3669

select scrssn, max (VitalSignTakenDateTime) as VitalSignTakenDateTime
into #tempweight1
from #tempweight group by scrssn

select distinct a.patientsid, b.scrssn, b.VitalSignTakenDateTime, a.VitalResult, a.VitalResultNumeric
into #tempweightfinal
from #tempweight as a with (NOLOCK) left outer join 
#tempweight1 as b with (NOLOCK) on a.scrssn= b.scrssn and a.VitalSignTakenDateTime= b.VitalSignTakenDateTime

select distinct scrssn from #tempweightfinal --3670

/* Seperate height records into a table */

select *  

into #tempheight

from #tempDiabetesVitals where vitaltype = 'HEIGHT' and VitalResultNumeric != '0'

select distinct scrssn from #tempheight--3712

select scrssn, max (VitalSignTakenDateTime) as VitalSignTakenDateTime
into #tempheight1
from #tempheight group by scrssn

select distinct a.patientsid, b.scrssn, b.VitalSignTakenDateTime, a.VitalResult, a.VitalResultNumeric
into #tempheightfinal
from #tempheight as a with (NOLOCK) left outer join 
#tempheight1 as b with (NOLOCK) on a.scrssn= b.scrssn and a.VitalSignTakenDateTime= b.VitalSignTakenDateTime

select distinct scrssn from #tempheightfinal --3713

/* Combine data from table weight and height to obtain the bmi for individual patient */
drop table  Dflt.Diabetes_AF_SGLT2_BMI

select distinct a.patientsid, a.ScrSSN, cast(a.VitalSignTakenDateTime as date) as HeightTime, a.VitalResultNumeric as heightresult, 
cast(b.VitalSignTakenDateTime as date) as WeightTime,b.VitalResultNumeric as weightresult, ((b.VitalResultNumeric*703)/(a.VitalResultNumeric*a.VitalResultNumeric)) as bmi

into Dflt.Diabetes_AF_SGLT2_BMI

from #tempheightfinal as a with (NOLOCK) inner join
#tempweightfinal as b with (NOLOCK) on a.ScrSSN = b.ScrSSN
--where a.VitalSignTakenDateTime=b.VitalSignTakenDateTime --a.SGLT2FillTime=b.SGLT2FillTime and

select distinct scrssn from Dflt.Diabetes_AF_SGLT2_BMI where bmi >= 30 --2448

select distinct scrssn from Dflt.Diabetes_AF_SGLT2_BMI where bmi between 30 and 35 --1018

select distinct scrssn from Dflt.Diabetes_AF_SGLT2_BMI where bmi between 35 and 40 --774

select distinct scrssn from Dflt.Diabetes_AF_SGLT2_BMI --3666

/* DPP4 cohort Extraction */


select distinct a.PatientSID, a.ScrSSN, a.AF_dischargedatetime, b.FillDateTime as DPP4FillTime, b.FillNumber, b.DaysSupply, b.Qty, b.DrugNameWithoutDose

into #tempDPP4

from Dflt.Diabetes_AFibFinal as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where b.LocalDrugNameWithDose like '%gliptin%' or
b.LocalDrugNameWithDose like '%Glipizide%' or
			  b.LocalDrugNameWithDose like '%Glimepiride%' or
			 b. LocalDrugNameWithDose like '%Glyburide%' or
			 b. LocalDrugNameWithDose like '%Tolbutamide%'

union all

select distinct a.PatientSID, a.ScrSSN, a.AF_dischargedatetime, b.FillDateTime as DPP4FillTime, b.FillNumber, b.DaysSupply, b.Qty, b.DrugNameWithoutDose
from Dflt.Diabetes_AFibFinal as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where b.LocalDrugNameWithDose like '%gliptin%' or
 b.LocalDrugNameWithDose like '%Glipizide%' or
			  b.LocalDrugNameWithDose like '%Glimepiride%' or
			 b. LocalDrugNameWithDose like '%Glyburide%' or
			  b.LocalDrugNameWithDose like '%Tolbutamide%'

select distinct scrssn from #tempDPP4 --48,182

/* Find the DPP4 Fill time */

select scrssn, min(DPP4FillTime) as DPP4FillTime
into #temp1
from #tempDpp4 group by scrssn

select distinct scrssn from #temp1 --48,182

/* Add the refills for DPP4 */

select scrssn, sum(FillNumber) as FillNumber 
into #tempfillnumberDPP4
from #tempDPP4 group by scrssn 

select distinct scrssn from #tempfillnumberDPP4 --48,182
 
select distinct  b.scrssn, a.DPP4FillTime, b.FillNumber
into #temp2
from #temp1 as a with (NOLOCK) left outer join 
#tempfillnumberDPP4 as b with (NOLOCK) on a.scrssn= b.scrssn --and a.DPP4FillTime= b.DPP4FillTime

select distinct scrssn from #temp2 --48,182

select distinct b.scrssn, b.DPP4FillTime, b.FillNumber,a.patientsid, a.AF_Dischargedatetime
into #date1
from #tempdpp4 as a with (NOLOCK) left outer join 
#temp2 as b with (NOLOCK) on a.scrssn= b.scrssn and b.DPP4FillTime=a.DPP4FillTime
where b.DPP4FillTime between '2014-01-01 00:00:00' and '2021-07-31 23:59:59'
and b.DPP4FillTime >= dateadd(day, 30, a.AF_Dischargedatetime)

select distinct scrssn from #date1 --3685

/* Remove SGLT2 from DPP4 */

select distinct a.scrssn, a.DPP4FillTime, a.PatientSID, b.FillDateTime

into #SGLT2

from #date1 as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where LocalDrugNameWithDose like '%empagliflozin%' 
or LocalDrugNameWithDose like '%dapagliflozin%' 
or LocalDrugNameWithDose like '%canagliflozin%' 
or LocalDrugNameWithDose like '%ertugliflozin%' 
union all

select distinct a.scrssn, a.DPP4FillTime, a.PatientSID, b.FillDateTime
from #date1 as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where LocalDrugNameWithDose like '%empagliflozin%' 
or LocalDrugNameWithDose like '%dapagliflozin%' 
or LocalDrugNameWithDose like '%canagliflozin%' 
or LocalDrugNameWithDose like '%ertugliflozin%' 

select distinct scrssn from #SGLT2 --1660

select * 
into #SGLT21
from #SGLT2 where FillDateTime between dateadd(month, -12, DPP4FillTime) and dateadd(day, 1, DPP4FillTime) 

select distinct scrssn from #sglt21 --110

select distinct a.*--, b.DischargeDateTime, c.ICD10ProcedureCode

into #Dpp4excludeSGLT2

from #date1 as a where a.fillnumber >=2
AND NOT EXISTS (Select * from #sglt21 as b where a.ScrSSN = b.ScrSSN)

select distinct scrssn from #Dpp4excludeSGLT2 --3331

/* AF Diagnosis 1 year prior to drug initiation */

select distinct a.PatientSID,a.ScrSSN,   b.DischargeDateTime ,a.DPP4FillTime, a.AF_Dischargedatetime

into #tempAFDPP4

from #Dpp4excludeSGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')	
and b.DischargeDateTime	between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.PatientSID,a.ScrSSN, b.DischargeDateTime, a.DPP4FillTime, a.AF_Dischargedatetime

from #Dpp4excludeSGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
and b.DischargeDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.PatientSID,a.ScrSSN, b.DischargeDateTime, a.DPP4FillTime, a.AF_Dischargedatetime

from #Dpp4excludeSGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
and b.DischargeDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.PatientSID,a.ScrSSN, b.EventDateTime, a.DPP4FillTime, a.AF_Dischargedatetime

from #Dpp4excludeSGLT2 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.PatientSID,a.ScrSSN,  b.EventDateTime, a.DPP4FillTime, a.AF_Dischargedatetime

from #Dpp4excludeSGLT2 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.PatientSID,a.ScrSSN,  b.EventDateTime, a.DPP4FillTime, a.AF_Dischargedatetime

from #Dpp4excludeSGLT2 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.PatientSID,a.ScrSSN, b.PatientTransferDateTime, a.DPP4FillTime, a.AF_Dischargedatetime

from #Dpp4excludeSGLT2 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
and b.PatientTransferDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.PatientSID,a.ScrSSN,  b.SpecialtyTransferDateTime, a.DPP4FillTime, a.AF_Dischargedatetime

from #Dpp4excludeSGLT2 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
and b.SpecialtyTransferDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.PatientSID,a.ScrSSN,  b.AdmitDateTime, a.DPP4FillTime, a.AF_Dischargedatetime

from #Dpp4excludeSGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
and b.AdmitDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

/*ICD10 Codes*/
select distinct a.PatientSID,a.ScrSSN, b.DischargeDateTime, a.DPP4FillTime, a.AF_Dischargedatetime

from #Dpp4excludeSGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.DischargeDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.PatientSID,a.ScrSSN,  b.DischargeDateTime, a.DPP4FillTime, a.AF_Dischargedatetime

from #Dpp4excludeSGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.DischargeDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.PatientSID,a.ScrSSN, b.DischargeDateTime, a.DPP4FillTime, a.AF_Dischargedatetime

from #Dpp4excludeSGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.DischargeDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.PatientSID,a.ScrSSN,  b.EventDateTime, a.DPP4FillTime, a.AF_Dischargedatetime

from #Dpp4excludeSGLT2 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.PatientSID,a.ScrSSN,  b.EventDateTime, a.DPP4FillTime, a.AF_Dischargedatetime

from #Dpp4excludeSGLT2 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.PatientSID,a.ScrSSN, b.EventDateTime, a.DPP4FillTime, a.AF_Dischargedatetime

from #Dpp4excludeSGLT2 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)

union all

select distinct a.PatientSID,a.ScrSSN,  b.PatientTransferDateTime, a.DPP4FillTime, a.AF_Dischargedatetime

from #Dpp4excludeSGLT2 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.PatientTransferDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)

union all

select distinct a.PatientSID,a.ScrSSN, b.SpecialtyTransferDateTime, a.DPP4FillTime, a.AF_Dischargedatetime

from #Dpp4excludeSGLT2 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.SpecialtyTransferDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)

union all

select distinct a.PatientSID,a.ScrSSN,   b.AdmitDateTime, a.DPP4FillTime, a.AF_Dischargedatetime

from #Dpp4excludeSGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.AdmitDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)

select distinct scrssn from #tempAFDPP4 --1559

/* Cardioversion */
/* Cardioversion Proc codes */

select distinct ICD9ProcedureCode from CDWWork.Dim.ICD9Procedure where ICD9ProcedureCode in ('99.61','99.62') 
select distinct ICD10ProcedureCode from CDWWork.Dim.ICD10Procedure where ICD10ProcedureCode in ('5A2204Z') 

select distinct a.*, b.ICDProcedureDateTime, c.ICD9ProcedureCode
/*ICD9Procedure Codes*/

into #tempAFCardioDPP4

from #Dpp4excludeSGLT2 as a with (NOLOCK) inner join
Src.Inpat_CensusICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('99.61','99.62')
					and b.ICDProcedureDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.*, b.SurgicalProcedureDateTime, c.ICD9ProcedureCode

from #Dpp4excludeSGLT2 as a with (NOLOCK) inner join
Src.Inpat_CensusSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('99.61','99.62')
					and b.SurgicalProcedureDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD9ProcedureCode

from #Dpp4excludeSGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('99.61','99.62')
					and b.DischargeDateTime  between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD9ProcedureCode

from #Dpp4excludeSGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('99.61','99.62')
					and b.DischargeDateTime  between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

/*ICD10Procedure Codes*/
select distinct a.*, b.ICDProcedureDateTime, c.ICD10ProcedureCode

from #Dpp4excludeSGLT2 as a with (NOLOCK) inner join
Src.Inpat_CensusICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('5A2204Z')
and b.ICDProcedureDateTime  between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.*, b.SurgicalProcedureDateTime, c.ICD10ProcedureCode

from #Dpp4excludeSGLT2 as a with (NOLOCK) inner join
Src.Inpat_CensusSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('5A2204Z')
and b.SurgicalProcedureDateTime  between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD10ProcedureCode

from #Dpp4excludeSGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('5A2204Z')
and b.DischargeDateTime  between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD10ProcedureCode

from #Dpp4excludeSGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('5A2204Z')
and b.DischargeDateTime  between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)

select distinct scrssn from #tempAFCardioDPP4 --82

/*Ablation */
/*Ablation Procedure Codes */

select distinct ICD9ProcedureCode from CDWWork.Dim.ICD9Procedure where ICD9ProcedureCode in ('37.33','37.34','37.37','37.80','38.65') 
select distinct ICD10ProcedureCode from CDWWork.Dim.ICD10Procedure where ICD10ProcedureCode in ('02560ZZ','02563ZZ','02564ZZ',
'02570ZZ','02573ZZ','02574ZZ','02580ZZ','02583ZZ','02584ZZ','025S0ZZ','025S3ZZ','025S4ZZ','025T0ZZ','025T3ZZ','025T4ZZ') 

select distinct a.*, b.ICDProcedureDateTime, c.ICD9ProcedureCode
/*ICD9Procedure Codes*/

into #tempAFAbProcDPP4

from #Dpp4excludeSGLT2 as a with (NOLOCK) inner join
Src.Inpat_CensusICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('37.33','37.34','37.37','37.80','38.65')
					and b.ICDProcedureDateTime  between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.*, b.SurgicalProcedureDateTime, c.ICD9ProcedureCode

from #Dpp4excludeSGLT2 as a with (NOLOCK) inner join
Src.Inpat_CensusSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('37.33','37.34','37.37','37.80','38.65')
					and b.SurgicalProcedureDateTime  between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD9ProcedureCode

from #Dpp4excludeSGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('37.33','37.34','37.37','37.80','38.65')
					and b.DischargeDateTime  between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD9ProcedureCode

from #Dpp4excludeSGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('37.33','37.34','37.37','37.80','38.65')
					and b.DischargeDateTime  between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

/*ICD10Procedure Codes*/
select distinct a.*, b.ICDProcedureDateTime, c.ICD10ProcedureCode

from #Dpp4excludeSGLT2 as a with (NOLOCK) inner join
Src.Inpat_CensusICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('02560ZZ','02563ZZ','02564ZZ',
'02570ZZ','02573ZZ','02574ZZ','02580ZZ','02583ZZ','02584ZZ','025S0ZZ','025S3ZZ','025S4ZZ','025T0ZZ','025T3ZZ','025T4ZZ')
and b.ICDProcedureDateTime  between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.*, b.SurgicalProcedureDateTime, c.ICD10ProcedureCode

from #Dpp4excludeSGLT2 as a with (NOLOCK) inner join
Src.Inpat_CensusSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('02560ZZ','02563ZZ','02564ZZ',
'02570ZZ','02573ZZ','02574ZZ','02580ZZ','02583ZZ','02584ZZ','025S0ZZ','025S3ZZ','025S4ZZ','025T0ZZ','025T3ZZ','025T4ZZ')
and b.SurgicalProcedureDateTime  between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD10ProcedureCode

from #Dpp4excludeSGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('02560ZZ','02563ZZ','02564ZZ',
'02570ZZ','02573ZZ','02574ZZ','02580ZZ','02583ZZ','02584ZZ','025S0ZZ','025S3ZZ','025S4ZZ','025T0ZZ','025T3ZZ','025T4ZZ')
and b.DischargeDateTime  between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD10ProcedureCode

from #Dpp4excludeSGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('02560ZZ','02563ZZ','02564ZZ',
'02570ZZ','02573ZZ','02574ZZ','02580ZZ','02583ZZ','02584ZZ','025S0ZZ','025S3ZZ','025S4ZZ','025T0ZZ','025T3ZZ','025T4ZZ')
and b.DischargeDateTime  between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)

select distinct scrssn from #tempAFAbProcDPP4 --28

/* Anti Arrythmic Drugs */

select distinct a.*, b.FillDateTime

into #tempAFAntiArrDPP4

from #Dpp4excludeSGLT2 as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where LocalDrugNameWithDose like '%soltalol%' 
or LocalDrugNameWithDose like '%Dofetilide%' 
or LocalDrugNameWithDose like '%flecainide%' 
or LocalDrugNameWithDose like '%propafenone%' 
or LocalDrugNameWithDose like '%amiodarone%' 
or LocalDrugNameWithDose like '%dronaderone%'
or LocalDrugNameWithDose like '%digoxin%'

union all

select distinct a.*, b.FillDateTime
from #Dpp4excludeSGLT2 as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where LocalDrugNameWithDose like '%soltalol%' 
or LocalDrugNameWithDose like '%Dofetilide%' 
or LocalDrugNameWithDose like '%flecainide%' 
or LocalDrugNameWithDose like '%propafenone%' 
or LocalDrugNameWithDose like '%amiodarone%' 
or LocalDrugNameWithDose like '%dronaderone%'
or LocalDrugNameWithDose like '%digoxin%'


select distinct *

into #tempAFAntiArrdateDPP4
from #tempAFAntiArrDPP4
where FillDateTime  between dateadd(month, -12, DPP4FillTime) and dateadd(day, 1, DPP4FillTime)

select distinct scrssn from #tempAFAntiArrdateDPP4 --1021


select distinct scrssn , DPP4FillTime , patientsid

into #tempFinalDPP4

from #tempAFDPP4
union all

select distinct scrssn , DPP4FillTime , patientsid
from #tempAFCardioDPP4
union all

select distinct scrssn , DPP4FillTime , patientsid
from #tempAFAbProcDPP4
union all

select distinct scrssn , DPP4FillTime , patientsid 
from #tempAFAntiArrdateDPP4

select distinct scrssn from #tempFinalDPP4 --2033

/* Patients on Anti coagulation drugs 1 year prior to initiation */

select distinct a.scrssn, a.patientsid, a.DPP4FillTime, b.FillDateTime

into #tempdpp4Anticoag

from #tempFinalDPP4 as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where LocalDrugNameWithDose like '%Warfarin%' or
LocalDrugNameWithDose like '%Rivaroxaban%' or
			  LocalDrugNameWithDose like '%Apixaban%' or
			  LocalDrugNameWithDose like '%Dabigatran%' 
union all

select distinct a.scrssn, a.patientsid, a.DPP4FillTime, b.FillDateTime

from #tempFinalDPP4 as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where LocalDrugNameWithDose like '%Warfarin%' or
LocalDrugNameWithDose like '%Rivaroxaban%' or
			  LocalDrugNameWithDose like '%Apixaban%' or
			  LocalDrugNameWithDose like '%Dabigatran%' 

select distinct scrssn from #tempdpp4Anticoag

select distinct *

into Dflt.Diabetes_AF_DPP4exclusions

from #tempDPP4Anticoag
where FillDateTime between dateadd(month, -12, DPP4FillTime) and dateadd(day, 30, DPP4FillTime)

select distinct scrssn from Dflt.Diabetes_AF_DPP4exclusions --1867

select distinct patientsid from Dflt.Diabetes_AF_DPP4exclusions

select * from Dflt.Diabetes_AF_DPP4exclusions

select a.scrssn, a.DPP4FillTime, a.FillDateTime, b.PatientSID

into Dflt.Diabetes_AF_DPP4

from Dflt.Diabetes_AF_DPP4exclusions as a with (NOLOCK) inner join
Src.CohortCrosswalk as b with (NOLOCK) on a.scrssn= b.scrssn

select distinct scrssn from Dflt.Diabetes_AF_DPP4 --2079

select distinct patientsid from Dflt.Diabetes_AF_DPP4 --7248

select distinct a.scrssn 
from Dflt.Diabetes_AF_DPP4exclusions as a with (NOLOCK) inner join
Dflt.Diabetes_AF_SGLT2exclusions as b with (NOLOCK) on a.scrssn= b.scrssn
/* BMI */

/* Select height and weight values from vital signs view to calculate bmi */

select distinct a.PatientSID, a.VitalSignTakenDateTime, a.VitalResult, a.VitalResultNumeric,
 b.DPP4FillTime, b.ScrSSN, 
c.VitalType

into #tempDiabetesVitalsDPP4

from Src.Vital_VitalSign as a with (NOLOCK) inner join
Dflt.Diabetes_AF_DPP4 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.VitalType as c with (NOLOCK) on a.VitalTypeSID=c.VitalTypeSID 
where (a.VitalSignTakenDateTime between dateadd(month, -12, b.DPP4FillTime) and dateadd(DAY, 1, b.DPP4FillTime)) AND
c.VitalType in ( 'WEIGHT')
union all

select distinct a.PatientSID, a.VitalSignTakenDateTime, a.VitalResult, a.VitalResultNumeric,
b.DPP4FillTime,b.ScrSSN, 
c.VitalType

from Src.Vital_VitalSign_Recent as a with (NOLOCK) inner join
Dflt.Diabetes_AF_DPP4 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.VitalType as c with (NOLOCK) on a.VitalTypeSID=c.VitalTypeSID 
where (a.VitalSignTakenDateTime between dateadd(month, -12, b.DPP4FillTime) and dateadd(day, 1, b.DPP4FillTime))AND 
c.VitalType in ( 'WEIGHT')
union all

select distinct a.PatientSID, a.VitalSignTakenDateTime, a.VitalResult, a.VitalResultNumeric,
 b.DPP4FillTime, b.ScrSSN, 
c.VitalType

from Src.Vital_VitalSign as a with (NOLOCK) inner join
Dflt.Diabetes_AF_DPP4 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.VitalType as c with (NOLOCK) on a.VitalTypeSID=c.VitalTypeSID 
--where (a.VitalSignTakenDateTime between dateadd(month, -12, b.DPP4FillTime) and dateadd(day, 1, b.DPP4FillTime))AND
where a.VitalSignTakenDateTime <= b.DPP4FillTime and 
c.VitalType in ( 'HEIGHT')
union all

select distinct a.PatientSID, a.VitalSignTakenDateTime, a.VitalResult, a.VitalResultNumeric,
b.DPP4FillTime,b.ScrSSN, 
c.VitalType

from Src.Vital_VitalSign_Recent as a with (NOLOCK) inner join
Dflt.Diabetes_AF_DPP4 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.VitalType as c with (NOLOCK) on a.VitalTypeSID=c.VitalTypeSID 
--where (a.VitalSignTakenDateTime between dateadd(month, -12, b.DPP4FillTime) and dateadd(day, 1, b.DPP4FillTime))AND
where a.VitalSignTakenDateTime <= b.DPP4FillTime and 
c.VitalType in ( 'HEIGHT')

select distinct scrssn from #tempDiabetesVitalsDPP4--2078

/* Seperate weight records into a table */
select * 

into #tempweightDPP4

from #tempDiabetesVitalsDPP4 where vitaltype = 'WEIGHT' and VitalResultNumeric != '0'

select distinct scrssn from #tempweightDPP4 --2059

select scrssn, max (VitalSignTakenDateTime) as VitalSignTakenDateTime
into #tempweight1DPP4
from #tempweightDPP4 group by scrssn

select distinct a.patientsid, b.scrssn, b.VitalSignTakenDateTime, a.VitalResult, a.VitalResultNumeric
into #tempweightfinalDPP4
from #tempweightDPP4 as a with (NOLOCK) left outer join 
#tempweight1DPP4 as b with (NOLOCK) on a.scrssn= b.scrssn and a.VitalSignTakenDateTime= b.VitalSignTakenDateTime

select distinct scrssn from #tempweightfinalDPP4 --2060

/* Seperate height records into a table */
select *  

into #tempheightDPP4

from #tempDiabetesVitalsDPP4 where vitaltype = 'HEIGHT' and VitalResultNumeric != '0'

select distinct scrssn from #tempheightDPP4 --2076

select scrssn, max (VitalSignTakenDateTime) as VitalSignTakenDateTime
into #tempheight1DPP4
from #tempheightDPP4 group by scrssn

select distinct a.patientsid, b.scrssn, b.VitalSignTakenDateTime, a.VitalResult, a.VitalResultNumeric
into #tempheightfinalDPP4
from #tempheightDPP4 as a with (NOLOCK) left outer join 
#tempheight1DPP4 as b with (NOLOCK) on a.scrssn= b.scrssn and a.VitalSignTakenDateTime= b.VitalSignTakenDateTime

select distinct scrssn from #tempheightfinalDPP4 --2077

/* Combine data from table weight and height to obtain the bmi for individual patient */

select distinct a.patientsid, a.ScrSSN, cast(a.VitalSignTakenDateTime as date) as HeightTime, a.VitalResultNumeric as heightresult, 
cast(b.VitalSignTakenDateTime as date) as WeightTime,b.VitalResultNumeric as weightresult, ((b.VitalResultNumeric*703)/(a.VitalResultNumeric*a.VitalResultNumeric)) as bmi

into Dflt.Diabetes_AF_DPP4_BMI

from #tempheightfinalDPP4 as a with (NOLOCK) inner join
#tempweightfinalDPP4 as b with (NOLOCK) on a.ScrSSN = b.ScrSSN 
--where a.VitalSignTakenDateTime=b.VitalSignTakenDateTime --a.DPP4FillTime=b.DPP4FillTime and


select distinct scrssn from  Dflt.Diabetes_AF_DPP4_BMI where bmi >= 30 --1344

select distinct scrssn from  Dflt.Diabetes_AF_DPP4_BMI where bmi between 30 and 35 --582

select distinct scrssn from  Dflt.Diabetes_AF_DPP4_BMI where bmi between 35 and 40 --399

select distinct scrssn from  Dflt.Diabetes_AF_DPP4_BMI --2057

select distinct scrssn from Dflt.Diabetes_AF_SGLT2 --3715
select distinct scrssn from  Dflt.Diabetes_AF_DPP4 --2057

/* Baseline Measurements for SGLT2 Cohort */
/* Demographics */
/* Age */

select a.ScrSSN, a.sglt2Filltime, b.DOB,b.SEX
into Dflt.Diabetes_AF_SGLT2_DOB
from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.VitalStatus_Mini as b with (NOLOCK) on a.scrssn= b.scrssn

select *, datediff( year, DOB, sglt2Filltime) as age
into Dflt.Diabetes_AF_SGLT2_Age
from Dflt.Diabetes_AF_SGLT2_DOB

select distinct scrssn from Dflt.Diabetes_AF_SGLT2_Age where SEX ='F' --50

/* Date of Death */

select distinct a.scrssn, b.MPI_DOD
into Dflt.Diabetes_AF_SGLT2_DOD
from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.SDAF_DAFMaster as b with (NOLOCK) on a.scrssn= b.MPI_ScrSSN
where b.MPI_DOD is not null

select distinct scrssn from Dflt.Diabetes_AF_SGLT2_DOD --1466

select max(MPI_DOD) from Dflt.Diabetes_AF_SGLT2_DOD 

select * from Dflt.Diabetes_AF_SGLT2_DOD where MPI_DOD > '2023-12-01'

/* Race */

select a.*,  b.Race
into Dflt.Diabetes_AF_SGLT2_Race
from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.PatSub_PatientRace as b with (NOLOCK) on a.patientsid= b.patientsid

select distinct scrssn from Dflt.Diabetes_AF_SGLT2_Race --3709

select distinct race from Dflt.Diabetes_AF_SGLT2_Race 

select distinct scrssn from Dflt.Diabetes_AF_SGLT2_Race where race = 'WHITE' --2869

select distinct scrssn from Dflt.Diabetes_AF_SGLT2_Race where race = 'BLACK OR AFRICAN AMERICAN' --605

/* Hypertension */

select distinct a.*, b.DischargeDateTime as comorbidity_Dischargedatetime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_AF_SGLT2_Hypertension

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('401.1','401.0','401.9','402.00','402.01','402.90','402.91','403.00','403.01','403.10','403.11','403.90','403.91','404.00','404.01','404.02','404.03','404.10',
					'404.11','404.12','404.13','404.90','404.91','404.92','404.93','405.01','405.09','405.11','405.99','642.00','642.01','642.02','642.03','642.04','642.10','642.11',
					'642.12','642.13','642.14','642.20','642.21','642.22','642.23','642.24','642.70','642.71','642.72','642.73','642.74','642.90','642.91','642.92','642.93','642.94')
					and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('401.1','401.0','401.9','402.00','402.01','402.90','402.91','403.00','403.01','403.10','403.11','403.90','403.91','404.00','404.01','404.02','404.03','404.10',
					'404.11','404.12','404.13','404.90','404.91','404.92','404.93','405.01','405.09','405.11','405.99','642.00','642.01','642.02','642.03','642.04','642.10','642.11',
					'642.12','642.13','642.14','642.20','642.21','642.22','642.23','642.24','642.70','642.71','642.72','642.73','642.74','642.90','642.91','642.92','642.93','642.94')
					and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('401.1','401.0','401.9','402.00','402.01','402.90','402.91','403.00','403.01','403.10','403.11','403.90','403.91','404.00','404.01','404.02','404.03','404.10',
					'404.11','404.12','404.13','404.90','404.91','404.92','404.93','405.01','405.09','405.11','405.99','642.00','642.01','642.02','642.03','642.04','642.10','642.11',
					'642.12','642.13','642.14','642.20','642.21','642.22','642.23','642.24','642.70','642.71','642.72','642.73','642.74','642.90','642.91','642.92','642.93','642.94')
					and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.*, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('401.1','401.0','401.9','402.00','402.01','402.90','402.91','403.00','403.01','403.10','403.11','403.90','403.91','404.00','404.01','404.02','404.03','404.10',
					'404.11','404.12','404.13','404.90','404.91','404.92','404.93','405.01','405.09','405.11','405.99','642.00','642.01','642.02','642.03','642.04','642.10','642.11',
					'642.12','642.13','642.14','642.20','642.21','642.22','642.23','642.24','642.70','642.71','642.72','642.73','642.74','642.90','642.91','642.92','642.93','642.94')
					and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.*, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('401.1','401.0','401.9','402.00','402.01','402.90','402.91','403.00','403.01','403.10','403.11','403.90','403.91','404.00','404.01','404.02','404.03','404.10',
					'404.11','404.12','404.13','404.90','404.91','404.92','404.93','405.01','405.09','405.11','405.99','642.00','642.01','642.02','642.03','642.04','642.10','642.11',
					'642.12','642.13','642.14','642.20','642.21','642.22','642.23','642.24','642.70','642.71','642.72','642.73','642.74','642.90','642.91','642.92','642.93','642.94')
					and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.*, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('401.1','401.0','401.9','402.00','402.01','402.90','402.91','403.00','403.01','403.10','403.11','403.90','403.91','404.00','404.01','404.02','404.03','404.10',
					'404.11','404.12','404.13','404.90','404.91','404.92','404.93','405.01','405.09','405.11','405.99','642.00','642.01','642.02','642.03','642.04','642.10','642.11',
					'642.12','642.13','642.14','642.20','642.21','642.22','642.23','642.24','642.70','642.71','642.72','642.73','642.74','642.90','642.91','642.92','642.93','642.94')
					and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.*, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('401.1','401.0','401.9','402.00','402.01','402.90','402.91','403.00','403.01','403.10','403.11','403.90','403.91','404.00','404.01','404.02','404.03','404.10',
					'404.11','404.12','404.13','404.90','404.91','404.92','404.93','405.01','405.09','405.11','405.99','642.00','642.01','642.02','642.03','642.04','642.10','642.11',
					'642.12','642.13','642.14','642.20','642.21','642.22','642.23','642.24','642.70','642.71','642.72','642.73','642.74','642.90','642.91','642.92','642.93','642.94')
					and b.PatientTransferDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.*, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('401.1','401.0','401.9','402.00','402.01','402.90','402.91','403.00','403.01','403.10','403.11','403.90','403.91','404.00','404.01','404.02','404.03','404.10',
					'404.11','404.12','404.13','404.90','404.91','404.92','404.93','405.01','405.09','405.11','405.99','642.00','642.01','642.02','642.03','642.04','642.10','642.11',
					'642.12','642.13','642.14','642.20','642.21','642.22','642.23','642.24','642.70','642.71','642.72','642.73','642.74','642.90','642.91','642.92','642.93','642.94')
					and b.SpecialtyTransferDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.*, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('401.1','401.0','401.9','402.00','402.01','402.90','402.91','403.00','403.01','403.10','403.11','403.90','403.91','404.00','404.01','404.02','404.03','404.10',
					'404.11','404.12','404.13','404.90','404.91','404.92','404.93','405.01','405.09','405.11','405.99','642.00','642.01','642.02','642.03','642.04','642.10','642.11',
					'642.12','642.13','642.14','642.20','642.21','642.22','642.23','642.24','642.70','642.71','642.72','642.73','642.74','642.90','642.91','642.92','642.93','642.94')
					and b.AdmitDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

/*ICD10 Codes*/
select distinct a.*, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I10.', 'I16.9', 'I11.9','I11.0', 'I12.9', 'I12.0','I13.10', 'I13.0', 'I13.11', 'I13.2', 'I15.0', 'I15.8', 
					'O10.019','O10.919', 'O10.011', 'O10.012', 'O10.013', 'O10.02', 'O10.911', 'O10.912', 'O10.913', 'O10.92', 'O10.03', 'O10.93', 
					'O10.419', 'O10.411', 'O10.412', 'O10.413', 'O10.42', 'O10.43','O10.119', 'O10.219', 'O10.319', 'O10.111', 'O10.112', 'O10.113', 'O10.12', 
					'O10.211', 'O10.212', 'O10.213','O10.22', 'O10.311', 'O10.312', 'O10.313', 'O10.32', 'O10.13', 'O10.23', 'O10.33', 'O11.9', 'O11.1', 'O11.2', 
					'O11.3', 'O11.4','O11.5', 'O16.9', 'O16.1', 'O16.2', 'O16.3', 'O16.4', 'O16.5')
and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I10.', 'I16.9', 'I11.9','I11.0', 'I12.9', 'I12.0','I13.10', 'I13.0', 'I13.11', 'I13.2', 'I15.0', 'I15.8', 
					'O10.019','O10.919', 'O10.011', 'O10.012', 'O10.013', 'O10.02', 'O10.911', 'O10.912', 'O10.913', 'O10.92', 'O10.03', 'O10.93', 
					'O10.419', 'O10.411', 'O10.412', 'O10.413', 'O10.42', 'O10.43','O10.119', 'O10.219', 'O10.319', 'O10.111', 'O10.112', 'O10.113', 'O10.12', 
					'O10.211', 'O10.212', 'O10.213','O10.22', 'O10.311', 'O10.312', 'O10.313', 'O10.32', 'O10.13', 'O10.23', 'O10.33', 'O11.9', 'O11.1', 'O11.2', 
					'O11.3', 'O11.4','O11.5', 'O16.9', 'O16.1', 'O16.2', 'O16.3', 'O16.4', 'O16.5')
and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I10.', 'I16.9', 'I11.9','I11.0', 'I12.9', 'I12.0','I13.10', 'I13.0', 'I13.11', 'I13.2', 'I15.0', 'I15.8', 
					'O10.019','O10.919', 'O10.011', 'O10.012', 'O10.013', 'O10.02', 'O10.911', 'O10.912', 'O10.913', 'O10.92', 'O10.03', 'O10.93', 
					'O10.419', 'O10.411', 'O10.412', 'O10.413', 'O10.42', 'O10.43','O10.119', 'O10.219', 'O10.319', 'O10.111', 'O10.112', 'O10.113', 'O10.12', 
					'O10.211', 'O10.212', 'O10.213','O10.22', 'O10.311', 'O10.312', 'O10.313', 'O10.32', 'O10.13', 'O10.23', 'O10.33', 'O11.9', 'O11.1', 'O11.2', 
					'O11.3', 'O11.4','O11.5', 'O16.9', 'O16.1', 'O16.2', 'O16.3', 'O16.4', 'O16.5')
and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.*, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I10.', 'I16.9', 'I11.9','I11.0', 'I12.9', 'I12.0','I13.10', 'I13.0', 'I13.11', 'I13.2', 'I15.0', 'I15.8', 
					'O10.019','O10.919', 'O10.011', 'O10.012', 'O10.013', 'O10.02', 'O10.911', 'O10.912', 'O10.913', 'O10.92', 'O10.03', 'O10.93', 
					'O10.419', 'O10.411', 'O10.412', 'O10.413', 'O10.42', 'O10.43','O10.119', 'O10.219', 'O10.319', 'O10.111', 'O10.112', 'O10.113', 'O10.12', 
					'O10.211', 'O10.212', 'O10.213','O10.22', 'O10.311', 'O10.312', 'O10.313', 'O10.32', 'O10.13', 'O10.23', 'O10.33', 'O11.9', 'O11.1', 'O11.2', 
					'O11.3', 'O11.4','O11.5', 'O16.9', 'O16.1', 'O16.2', 'O16.3', 'O16.4', 'O16.5')
and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.*, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I10.', 'I16.9', 'I11.9','I11.0', 'I12.9', 'I12.0','I13.10', 'I13.0', 'I13.11', 'I13.2', 'I15.0', 'I15.8', 
					'O10.019','O10.919', 'O10.011', 'O10.012', 'O10.013', 'O10.02', 'O10.911', 'O10.912', 'O10.913', 'O10.92', 'O10.03', 'O10.93', 
					'O10.419', 'O10.411', 'O10.412', 'O10.413', 'O10.42', 'O10.43','O10.119', 'O10.219', 'O10.319', 'O10.111', 'O10.112', 'O10.113', 'O10.12', 
					'O10.211', 'O10.212', 'O10.213','O10.22', 'O10.311', 'O10.312', 'O10.313', 'O10.32', 'O10.13', 'O10.23', 'O10.33', 'O11.9', 'O11.1', 'O11.2', 
					'O11.3', 'O11.4','O11.5', 'O16.9', 'O16.1', 'O16.2', 'O16.3', 'O16.4', 'O16.5')
and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.*, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I10.', 'I16.9', 'I11.9','I11.0', 'I12.9', 'I12.0','I13.10', 'I13.0', 'I13.11', 'I13.2', 'I15.0', 'I15.8', 
					'O10.019','O10.919', 'O10.011', 'O10.012', 'O10.013', 'O10.02', 'O10.911', 'O10.912', 'O10.913', 'O10.92', 'O10.03', 'O10.93', 
					'O10.419', 'O10.411', 'O10.412', 'O10.413', 'O10.42', 'O10.43','O10.119', 'O10.219', 'O10.319', 'O10.111', 'O10.112', 'O10.113', 'O10.12', 
					'O10.211', 'O10.212', 'O10.213','O10.22', 'O10.311', 'O10.312', 'O10.313', 'O10.32', 'O10.13', 'O10.23', 'O10.33', 'O11.9', 'O11.1', 'O11.2', 
					'O11.3', 'O11.4','O11.5', 'O16.9', 'O16.1', 'O16.2', 'O16.3', 'O16.4', 'O16.5')
and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)

union all

select distinct a.*, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I10.', 'I16.9', 'I11.9','I11.0', 'I12.9', 'I12.0','I13.10', 'I13.0', 'I13.11', 'I13.2', 'I15.0', 'I15.8', 
					'O10.019','O10.919', 'O10.011', 'O10.012', 'O10.013', 'O10.02', 'O10.911', 'O10.912', 'O10.913', 'O10.92', 'O10.03', 'O10.93', 
					'O10.419', 'O10.411', 'O10.412', 'O10.413', 'O10.42', 'O10.43','O10.119', 'O10.219', 'O10.319', 'O10.111', 'O10.112', 'O10.113', 'O10.12', 
					'O10.211', 'O10.212', 'O10.213','O10.22', 'O10.311', 'O10.312', 'O10.313', 'O10.32', 'O10.13', 'O10.23', 'O10.33', 'O11.9', 'O11.1', 'O11.2', 
					'O11.3', 'O11.4','O11.5', 'O16.9', 'O16.1', 'O16.2', 'O16.3', 'O16.4', 'O16.5')
and b.PatientTransferDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)

union all

select distinct a.*, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I10.', 'I16.9', 'I11.9','I11.0', 'I12.9', 'I12.0','I13.10', 'I13.0', 'I13.11', 'I13.2', 'I15.0', 'I15.8', 
					'O10.019','O10.919', 'O10.011', 'O10.012', 'O10.013', 'O10.02', 'O10.911', 'O10.912', 'O10.913', 'O10.92', 'O10.03', 'O10.93', 
					'O10.419', 'O10.411', 'O10.412', 'O10.413', 'O10.42', 'O10.43','O10.119', 'O10.219', 'O10.319', 'O10.111', 'O10.112', 'O10.113', 'O10.12', 
					'O10.211', 'O10.212', 'O10.213','O10.22', 'O10.311', 'O10.312', 'O10.313', 'O10.32', 'O10.13', 'O10.23', 'O10.33', 'O11.9', 'O11.1', 'O11.2', 
					'O11.3', 'O11.4','O11.5', 'O16.9', 'O16.1', 'O16.2', 'O16.3', 'O16.4', 'O16.5')
and b.SpecialtyTransferDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)

union all

select distinct a.*, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I10.', 'I16.9', 'I11.9','I11.0', 'I12.9', 'I12.0','I13.10', 'I13.0', 'I13.11', 'I13.2', 'I15.0', 'I15.8', 
					'O10.019','O10.919', 'O10.011', 'O10.012', 'O10.013', 'O10.02', 'O10.911', 'O10.912', 'O10.913', 'O10.92', 'O10.03', 'O10.93', 
					'O10.419', 'O10.411', 'O10.412', 'O10.413', 'O10.42', 'O10.43','O10.119', 'O10.219', 'O10.319', 'O10.111', 'O10.112', 'O10.113', 'O10.12', 
					'O10.211', 'O10.212', 'O10.213','O10.22', 'O10.311', 'O10.312', 'O10.313', 'O10.32', 'O10.13', 'O10.23', 'O10.33', 'O11.9', 'O11.1', 'O11.2', 
					'O11.3', 'O11.4','O11.5', 'O16.9', 'O16.1', 'O16.2', 'O16.3', 'O16.4', 'O16.5')
and b.AdmitDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)

select distinct scrssn from Dflt.Diabetes_AF_SGLT2_Hypertension --2863

/* Chronic Kidney Disease */
/*Making sure the ICD9 and ICD10 codes relevant to Kidney Disease are present in the Dimension table under CDWWork*/

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
													'V56.0','V56.1','V56.2','V56.8', '585.3')

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3') or ICD10Code like 'Z49.%'

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime ,b.DischargeDateTime as comorbidity_Dischargedatetime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_AF_SGLT2_KidneyDisease

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
				'V56.0','V56.1','V56.2','V56.8','585.3')
					and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
				'V56.0','V56.1','V56.2','V56.8','585.3')
					and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
				'V56.0','V56.1','V56.2','V56.8','585.3')
					and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
				'V56.0','V56.1','V56.2','V56.8','585.3')
					and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
				'V56.0','V56.1','V56.2','V56.8','585.3')
					and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
				'V56.0','V56.1','V56.2','V56.8','585.3')
					and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
				'V56.0','V56.1','V56.2','V56.8','585.3')
					and b.PatientTransferDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
				'V56.0','V56.1','V56.2','V56.8','585.3')
					and b.SpecialtyTransferDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
				'V56.0','V56.1','V56.2','V56.8','585.3')
					and b.AdmitDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3') or ICD10Code like 'Z49.%'
and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3') or ICD10Code like 'Z49.%'
and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3') or ICD10Code like 'Z49.%'
and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3') or ICD10Code like 'Z49.%'
and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3') or ICD10Code like 'Z49.%'
and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3') or ICD10Code like 'Z49.%'
and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)

union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3') or ICD10Code like 'Z49.%'
and b.PatientTransferDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)

union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3') or ICD10Code like 'Z49.%'
and b.SpecialtyTransferDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)

union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3') or ICD10Code like 'Z49.%'
and b.AdmitDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)

select distinct scrssn from Dflt.Diabetes_AF_SGLT2_KidneyDisease --1351

/* End Stage Renal Disease - ESRD */
/*Making sure the ICD9 and ICD10 codes relevant to ESRD are present in the Dimension table under CDWWork*/

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('585.6')

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('N18.6')

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.DischargeDateTime as comorbidity_Dischargedatetime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_AF_SGLT2_ESRD

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('585.6')
					and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('585.6')
					and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('585.6')
					and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('585.6')
					and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('585.6')
					and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('585.6')
					and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('585.6')
					and b.PatientTransferDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('585.6')
					and b.SpecialtyTransferDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('585.6')
					and b.AdmitDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('N18.6')
and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('N18.6')
and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('N18.6')
and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('N18.6')
and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('N18.6')
and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('N18.6')
and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)

union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('N18.6')
and b.PatientTransferDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)

union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('N18.6')
and b.SpecialtyTransferDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)

union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('N18.6')
and b.AdmitDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)

select distinct scrssn from Dflt.Diabetes_AF_SGLT2_ESRD --11


/* Alcohol Abuse */

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime as comorbidity_Dischargedatettime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_AF_SGLT2_AlcoholAbuse

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('290.0','291.1','291.2','291.3','291.5','291.81','291.82','291.89','291.9',
			    '303.00','303.01','303.02','303.03','303.90','303.91','303.92','303.93','305.00','305.01','305.02','305.03','V11.3')
					and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('290.0','291.1','291.2','291.3','291.5','291.81','291.82','291.89','291.9',
			    '303.00','303.01','303.02','303.03','303.90','303.91','303.92','303.93','305.00','305.01','305.02','305.03','V11.3')
					and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('290.0','291.1','291.2','291.3','291.5','291.81','291.82','291.89','291.9',
			    '303.00','303.01','303.02','303.03','303.90','303.91','303.92','303.93','305.00','305.01','305.02','305.03','V11.3')
					and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('290.0','291.1','291.2','291.3','291.5','291.81','291.82','291.89','291.9',
			    '303.00','303.01','303.02','303.03','303.90','303.91','303.92','303.93','305.00','305.01','305.02','305.03','V11.3')
					and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('290.0','291.1','291.2','291.3','291.5','291.81','291.82','291.89','291.9',
			    '303.00','303.01','303.02','303.03','303.90','303.91','303.92','303.93','305.00','305.01','305.02','305.03','V11.3')
					and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('290.0','291.1','291.2','291.3','291.5','291.81','291.82','291.89','291.9',
			    '303.00','303.01','303.02','303.03','303.90','303.91','303.92','303.93','305.00','305.01','305.02','305.03','V11.3')
					and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('290.0','291.1','291.2','291.3','291.5','291.81','291.82','291.89','291.9',
			    '303.00','303.01','303.02','303.03','303.90','303.91','303.92','303.93','305.00','305.01','305.02','305.03','V11.3')
					and b.PatientTransferDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('290.0','291.1','291.2','291.3','291.5','291.81','291.82','291.89','291.9',
			    '303.00','303.01','303.02','303.03','303.90','303.91','303.92','303.93','305.00','305.01','305.02','305.03','V11.3')
					and b.SpecialtyTransferDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('290.0','291.1','291.2','291.3','291.5','291.81','291.82','291.89','291.9',
			    '303.00','303.01','303.02','303.03','303.90','303.91','303.92','303.93','305.00','305.01','305.02','305.03','V11.3')
					and b.AdmitDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.231', 'F10.96', 'F10.27','F10.951','F10.950', 'F10.239', 'F10.182', 'F10.282', 'F10.982', 'F10.159', 'F10.180', 
					'F10.181', 'F10.188','F10.259', 'F10.280', 'F10.281', 'F10.288', 'F10.959', 'F10.980', 'F10.99','F10.229', 'F10.20', 'F10.21','F10.10','F10.11','Z65.8 ')
and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.231', 'F10.96', 'F10.27','F10.951','F10.950', 'F10.239', 'F10.182', 'F10.282', 'F10.982', 'F10.159', 'F10.180', 
					'F10.181', 'F10.188','F10.259', 'F10.280', 'F10.281', 'F10.288', 'F10.959', 'F10.980', 'F10.99','F10.229', 'F10.20', 'F10.21','F10.10','F10.11','Z65.8 ')
and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.231', 'F10.96', 'F10.27','F10.951','F10.950', 'F10.239', 'F10.182', 'F10.282', 'F10.982', 'F10.159', 'F10.180', 
					'F10.181', 'F10.188','F10.259', 'F10.280', 'F10.281', 'F10.288', 'F10.959', 'F10.980', 'F10.99','F10.229', 'F10.20', 'F10.21','F10.10','F10.11','Z65.8 ')
and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.231', 'F10.96', 'F10.27','F10.951','F10.950', 'F10.239', 'F10.182', 'F10.282', 'F10.982', 'F10.159', 'F10.180', 
					'F10.181', 'F10.188','F10.259', 'F10.280', 'F10.281', 'F10.288', 'F10.959', 'F10.980', 'F10.99','F10.229', 'F10.20', 'F10.21','F10.10','F10.11','Z65.8 ')
and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.231', 'F10.96', 'F10.27','F10.951','F10.950', 'F10.239', 'F10.182', 'F10.282', 'F10.982', 'F10.159', 'F10.180', 
					'F10.181', 'F10.188','F10.259', 'F10.280', 'F10.281', 'F10.288', 'F10.959', 'F10.980', 'F10.99','F10.229', 'F10.20', 'F10.21','F10.10','F10.11','Z65.8 ')
and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.231', 'F10.96', 'F10.27','F10.951','F10.950', 'F10.239', 'F10.182', 'F10.282', 'F10.982', 'F10.159', 'F10.180', 
					'F10.181', 'F10.188','F10.259', 'F10.280', 'F10.281', 'F10.288', 'F10.959', 'F10.980', 'F10.99','F10.229', 'F10.20', 'F10.21','F10.10','F10.11','Z65.8 ')
and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.231', 'F10.96', 'F10.27','F10.951','F10.950', 'F10.239', 'F10.182', 'F10.282', 'F10.982', 'F10.159', 'F10.180', 
					'F10.181', 'F10.188','F10.259', 'F10.280', 'F10.281', 'F10.288', 'F10.959', 'F10.980', 'F10.99','F10.229', 'F10.20', 'F10.21','F10.10','F10.11','Z65.8 ')
and b.PatientTransferDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.231', 'F10.96', 'F10.27','F10.951','F10.950', 'F10.239', 'F10.182', 'F10.282', 'F10.982', 'F10.159', 'F10.180', 
					'F10.181', 'F10.188','F10.259', 'F10.280', 'F10.281', 'F10.288', 'F10.959', 'F10.980', 'F10.99','F10.229', 'F10.20', 'F10.21','F10.10','F10.11','Z65.8 ')
and b.SpecialtyTransferDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.231', 'F10.96', 'F10.27','F10.951','F10.950', 'F10.239', 'F10.182', 'F10.282', 'F10.982', 'F10.159', 'F10.180', 
					'F10.181', 'F10.188','F10.259', 'F10.280', 'F10.281', 'F10.288', 'F10.959', 'F10.980', 'F10.99','F10.229', 'F10.20', 'F10.21','F10.10','F10.11','Z65.8 ')
and b.AdmitDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)

select distinct scrssn from Dflt.Diabetes_AF_SGLT2_AlcoholAbuse --180

/*Polysubstance Abuse */
/*Making sure the ICD9 and ICD10 codes relevant to Polysubstance Abuse are present in the Dimension table under CDWWork*/

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('F10.129','F10.229','F10.929','F10.10','F10.20','F11.10',
																	'F11.10','F11.20','F11.129','F11.229','F11.929','F11.122','F11.222','F11.922','F11.23','F11.99',
																	'F13.10','F13.20','F14.10','F14.20','F12.10','F12.20','F16.10','F16.20','F18.10','F18.20',
																	'F19.10','F19.20','Z72.0','F17.200','F15.10','F15.20','F15.929')

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('303.00','305.00','303.90','304.00','292.89','292.0','292.9','304.10','305.40','304.20','305.60',
															'304.30','305.20','304.50','305.30','305.90','304.60','304.80','304.90','305.10',
															'305.70','304.40','304.6')

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime as comorbidity_Dischargedatettime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_AF_SGLT2_PolyAbuse

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('303.00','305.00','303.90','304.00','292.89','292.0','292.9','304.10','305.40','304.20','305.60',
					'304.30','305.20','304.50','305.30','305.90','304.60','304.80','304.90','305.10','305.70','304.40','304.6')
					and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('303.00','305.00','303.90','304.00','292.89','292.0','292.9','304.10','305.40','304.20','305.60',
					'304.30','305.20','304.50','305.30','305.90','304.60','304.80','304.90','305.10','305.70','304.40','304.6')
					and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('303.00','305.00','303.90','304.00','292.89','292.0','292.9','304.10','305.40','304.20','305.60',
					'304.30','305.20','304.50','305.30','305.90','304.60','304.80','304.90','305.10','305.70','304.40','304.6')
					and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('303.00','305.00','303.90','304.00','292.89','292.0','292.9','304.10','305.40','304.20','305.60',
					'304.30','305.20','304.50','305.30','305.90','304.60','304.80','304.90','305.10','305.70','304.40','304.6')
					and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('303.00','305.00','303.90','304.00','292.89','292.0','292.9','304.10','305.40','304.20','305.60',
					'304.30','305.20','304.50','305.30','305.90','304.60','304.80','304.90','305.10','305.70','304.40','304.6')
					and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('303.00','305.00','303.90','304.00','292.89','292.0','292.9','304.10','305.40','304.20','305.60',
					'304.30','305.20','304.50','305.30','305.90','304.60','304.80','304.90','305.10','305.70','304.40','304.6')
					and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('303.00','305.00','303.90','304.00','292.89','292.0','292.9','304.10','305.40','304.20','305.60',
					'304.30','305.20','304.50','305.30','305.90','304.60','304.80','304.90','305.10','305.70','304.40','304.6')
					and b.PatientTransferDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('303.00','305.00','303.90','304.00','292.89','292.0','292.9','304.10','305.40','304.20','305.60',
					'304.30','305.20','304.50','305.30','305.90','304.60','304.80','304.90','305.10','305.70','304.40','304.6')
					and b.SpecialtyTransferDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('303.00','305.00','303.90','304.00','292.89','292.0','292.9','304.10','305.40','304.20','305.60',
					'304.30','305.20','304.50','305.30','305.90','304.60','304.80','304.90','305.10','305.70','304.40','304.6')
					and b.AdmitDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.129','F10.229','F10.929','F10.10','F10.20','F11.10',
					'F11.10','F11.20','F11.129','F11.229','F11.929','F11.122','F11.222','F11.922','F11.23','F11.99',
					'F13.10','F13.20','F14.10','F14.20','F12.10','F12.20','F16.10','F16.20','F18.10','F18.20',
					'F19.10','F19.20','Z72.0','F17.200','F15.10','F15.20','F15.929')
and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.129','F10.229','F10.929','F10.10','F10.20','F11.10',
					'F11.10','F11.20','F11.129','F11.229','F11.929','F11.122','F11.222','F11.922','F11.23','F11.99',
					'F13.10','F13.20','F14.10','F14.20','F12.10','F12.20','F16.10','F16.20','F18.10','F18.20',
					'F19.10','F19.20','Z72.0','F17.200','F15.10','F15.20','F15.929')
and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.129','F10.229','F10.929','F10.10','F10.20','F11.10',
					'F11.10','F11.20','F11.129','F11.229','F11.929','F11.122','F11.222','F11.922','F11.23','F11.99',
					'F13.10','F13.20','F14.10','F14.20','F12.10','F12.20','F16.10','F16.20','F18.10','F18.20',
					'F19.10','F19.20','Z72.0','F17.200','F15.10','F15.20','F15.929')
and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.129','F10.229','F10.929','F10.10','F10.20','F11.10',
					'F11.10','F11.20','F11.129','F11.229','F11.929','F11.122','F11.222','F11.922','F11.23','F11.99',
					'F13.10','F13.20','F14.10','F14.20','F12.10','F12.20','F16.10','F16.20','F18.10','F18.20',
					'F19.10','F19.20','Z72.0','F17.200','F15.10','F15.20','F15.929')
and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.129','F10.229','F10.929','F10.10','F10.20','F11.10',
					'F11.10','F11.20','F11.129','F11.229','F11.929','F11.122','F11.222','F11.922','F11.23','F11.99',
					'F13.10','F13.20','F14.10','F14.20','F12.10','F12.20','F16.10','F16.20','F18.10','F18.20',
					'F19.10','F19.20','Z72.0','F17.200','F15.10','F15.20','F15.929')
and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.129','F10.229','F10.929','F10.10','F10.20','F11.10',
					'F11.10','F11.20','F11.129','F11.229','F11.929','F11.122','F11.222','F11.922','F11.23','F11.99',
					'F13.10','F13.20','F14.10','F14.20','F12.10','F12.20','F16.10','F16.20','F18.10','F18.20',
					'F19.10','F19.20','Z72.0','F17.200','F15.10','F15.20','F15.929')
and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.129','F10.229','F10.929','F10.10','F10.20','F11.10',
					'F11.10','F11.20','F11.129','F11.229','F11.929','F11.122','F11.222','F11.922','F11.23','F11.99',
					'F13.10','F13.20','F14.10','F14.20','F12.10','F12.20','F16.10','F16.20','F18.10','F18.20',
					'F19.10','F19.20','Z72.0','F17.200','F15.10','F15.20','F15.929')
and b.PatientTransferDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.129','F10.229','F10.929','F10.10','F10.20','F11.10',
					'F11.10','F11.20','F11.129','F11.229','F11.929','F11.122','F11.222','F11.922','F11.23','F11.99',
					'F13.10','F13.20','F14.10','F14.20','F12.10','F12.20','F16.10','F16.20','F18.10','F18.20',
					'F19.10','F19.20','Z72.0','F17.200','F15.10','F15.20','F15.929')
and b.SpecialtyTransferDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.129','F10.229','F10.929','F10.10','F10.20','F11.10',
					'F11.10','F11.20','F11.129','F11.229','F11.929','F11.122','F11.222','F11.922','F11.23','F11.99',
					'F13.10','F13.20','F14.10','F14.20','F12.10','F12.20','F16.10','F16.20','F18.10','F18.20',
					'F19.10','F19.20','Z72.0','F17.200','F15.10','F15.20','F15.929')
and b.AdmitDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)

Select distinct scrssn from Dflt.Diabetes_AF_SGLT2_PolyAbuse --327

/* Malignancy */
/*Making sure the ICD9 and ICD10 codes relevant to Malignancy are present in the Dimension table under CDWWork*/

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('196.0','196.1','196.2','196.3','196.5','196.6','196.8','196.9','197.0','197.1','197.2','197.3','197.4','197.5',
					'197.6','197.7','197.8','198.0','198.1','198.2','198.3','198.4','198.5','198.6','198.7','198.81','198.82','198.89','199.0','199.1')

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('C77.0','C77.1','C77.2','C77.3','C77.4','C77.5','C77.8','C77.9','C78.0','C78.1','C78.2','C78.3',
					'C78.4', 'C78.5','C78.6', 'C78.7', 'C78.89','C79.9','C79.11','C79.2','C79.31','C79.32','C79.49',
					'C79.51','C79.52','C79.60','C79.70','C79.81','C79.82','C79.89','C80.0','C80.1')


select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime as comorbidity_Dischargedatettime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_AF_SGLT2_Malignancy

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('196.0','196.1','196.2','196.3','196.5','196.6','196.8','196.9','197.0','197.1','197.2','197.3','197.4','197.5',
					'197.6','197.7','197.8','198.0','198.1','198.2','198.3','198.4','198.5','198.6','198.7','198.81','198.82','198.89','199.0','199.1')
					and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('196.0','196.1','196.2','196.3','196.5','196.6','196.8','196.9','197.0','197.1','197.2','197.3','197.4','197.5',
					'197.6','197.7','197.8','198.0','198.1','198.2','198.3','198.4','198.5','198.6','198.7','198.81','198.82','198.89','199.0','199.1')
					and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('196.0','196.1','196.2','196.3','196.5','196.6','196.8','196.9','197.0','197.1','197.2','197.3','197.4','197.5',
					'197.6','197.7','197.8','198.0','198.1','198.2','198.3','198.4','198.5','198.6','198.7','198.81','198.82','198.89','199.0','199.1')
					and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('196.0','196.1','196.2','196.3','196.5','196.6','196.8','196.9','197.0','197.1','197.2','197.3','197.4','197.5',
					'197.6','197.7','197.8','198.0','198.1','198.2','198.3','198.4','198.5','198.6','198.7','198.81','198.82','198.89','199.0','199.1')
					and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('196.0','196.1','196.2','196.3','196.5','196.6','196.8','196.9','197.0','197.1','197.2','197.3','197.4','197.5',
					'197.6','197.7','197.8','198.0','198.1','198.2','198.3','198.4','198.5','198.6','198.7','198.81','198.82','198.89','199.0','199.1')
					and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('196.0','196.1','196.2','196.3','196.5','196.6','196.8','196.9','197.0','197.1','197.2','197.3','197.4','197.5',
					'197.6','197.7','197.8','198.0','198.1','198.2','198.3','198.4','198.5','198.6','198.7','198.81','198.82','198.89','199.0','199.1')
					and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('196.0','196.1','196.2','196.3','196.5','196.6','196.8','196.9','197.0','197.1','197.2','197.3','197.4','197.5',
					'197.6','197.7','197.8','198.0','198.1','198.2','198.3','198.4','198.5','198.6','198.7','198.81','198.82','198.89','199.0','199.1')
					and b.PatientTransferDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('196.0','196.1','196.2','196.3','196.5','196.6','196.8','196.9','197.0','197.1','197.2','197.3','197.4','197.5',
					'197.6','197.7','197.8','198.0','198.1','198.2','198.3','198.4','198.5','198.6','198.7','198.81','198.82','198.89','199.0','199.1')
					and b.SpecialtyTransferDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('196.0','196.1','196.2','196.3','196.5','196.6','196.8','196.9','197.0','197.1','197.2','197.3','197.4','197.5',
					'197.6','197.7','197.8','198.0','198.1','198.2','198.3','198.4','198.5','198.6','198.7','198.81','198.82','198.89','199.0','199.1')
					and b.AdmitDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('C77.0','C77.1','C77.2','C77.3','C77.4','C77.5','C77.8','C77.9','C78.0','C78.1','C78.2','C78.3',
					'C78.4', 'C78.5','C78.6', 'C78.7', 'C78.89','C79.9','C79.11','C79.2','C79.31','C79.32','C79.49',
					'C79.51','C79.52','C79.60','C79.70','C79.81','C79.82','C79.89','C80.0','C80.1')
and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('C77.0','C77.1','C77.2','C77.3','C77.4','C77.5','C77.8','C77.9','C78.0','C78.1','C78.2','C78.3',
					'C78.4', 'C78.5','C78.6', 'C78.7', 'C78.89','C79.9','C79.11','C79.2','C79.31','C79.32','C79.49',
					'C79.51','C79.52','C79.60','C79.70','C79.81','C79.82','C79.89','C80.0','C80.1')
and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('C77.0','C77.1','C77.2','C77.3','C77.4','C77.5','C77.8','C77.9','C78.0','C78.1','C78.2','C78.3',
					'C78.4', 'C78.5','C78.6', 'C78.7', 'C78.89','C79.9','C79.11','C79.2','C79.31','C79.32','C79.49',
					'C79.51','C79.52','C79.60','C79.70','C79.81','C79.82','C79.89','C80.0','C80.1') 
and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('C77.0','C77.1','C77.2','C77.3','C77.4','C77.5','C77.8','C77.9','C78.0','C78.1','C78.2','C78.3',
					'C78.4', 'C78.5','C78.6', 'C78.7', 'C78.89','C79.9','C79.11','C79.2','C79.31','C79.32','C79.49',
					'C79.51','C79.52','C79.60','C79.70','C79.81','C79.82','C79.89','C80.0','C80.1')
and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('C77.0','C77.1','C77.2','C77.3','C77.4','C77.5','C77.8','C77.9','C78.0','C78.1','C78.2','C78.3',
					'C78.4', 'C78.5','C78.6', 'C78.7', 'C78.89','C79.9','C79.11','C79.2','C79.31','C79.32','C79.49',
					'C79.51','C79.52','C79.60','C79.70','C79.81','C79.82','C79.89','C80.0','C80.1')
and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('C77.0','C77.1','C77.2','C77.3','C77.4','C77.5','C77.8','C77.9','C78.0','C78.1','C78.2','C78.3',
					'C78.4', 'C78.5','C78.6', 'C78.7', 'C78.89','C79.9','C79.11','C79.2','C79.31','C79.32','C79.49',
					'C79.51','C79.52','C79.60','C79.70','C79.81','C79.82','C79.89','C80.0','C80.1')
and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('C77.0','C77.1','C77.2','C77.3','C77.4','C77.5','C77.8','C77.9','C78.0','C78.1','C78.2','C78.3',
					'C78.4', 'C78.5','C78.6', 'C78.7', 'C78.89','C79.9','C79.11','C79.2','C79.31','C79.32','C79.49',
					'C79.51','C79.52','C79.60','C79.70','C79.81','C79.82','C79.89','C80.0','C80.1')
and b.PatientTransferDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('C77.0','C77.1','C77.2','C77.3','C77.4','C77.5','C77.8','C77.9','C78.0','C78.1','C78.2','C78.3',
					'C78.4', 'C78.5','C78.6', 'C78.7', 'C78.89','C79.9','C79.11','C79.2','C79.31','C79.32','C79.49',
					'C79.51','C79.52','C79.60','C79.70','C79.81','C79.82','C79.89','C80.0','C80.1')
and b.SpecialtyTransferDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('C77.0','C77.1','C77.2','C77.3','C77.4','C77.5','C77.8','C77.9','C78.0','C78.1','C78.2','C78.3',
					'C78.4', 'C78.5','C78.6', 'C78.7', 'C78.89','C79.9','C79.11','C79.2','C79.31','C79.32','C79.49',
					'C79.51','C79.52','C79.60','C79.70','C79.81','C79.82','C79.89','C80.0','C80.1')
and b.AdmitDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)

select distinct scrssn from Dflt.Diabetes_AF_SGLT2_Malignancy --42

/* Hypothyroidism */

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code like ('244.%')

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code like ('E03.%')

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime as comorbidity_Dischargedatettime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_AF_SGLT2_Hypothyroidism

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like ('244.%')
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like ('244.%')
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like ('244.%')
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like ('244.%')
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like ('244.%')
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like ('244.%')
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like ('244.%')
					and b.PatientTransferDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like ('244.%')
					and b.SpecialtyTransferDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like ('244.%')
					and b.AdmitDateTime <= a.SGLT2FillTime
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like ('E03.%')
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like ('E03.%')
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like ('E03.%')
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like ('E03.%')
and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like ('E03.%')
and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like ('E03.%')
and b.EventDateTime <= a.SGLT2FillTime

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like ('E03.%')
and b.PatientTransferDateTime <= a.SGLT2FillTime

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like ('E03.%')
and b.SpecialtyTransferDateTime <= a.SGLT2FillTime

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like ('E03.%')
and b.AdmitDateTime <= a.SGLT2FillTime

select distinct scrssn from Dflt.Diabetes_AF_SGLT2_Hypothyroidism --613


/*Smoking */

select distinct a.*, b.SMOKE

into Dflt.Diabetes_AF_SGLT2_Smoke

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.VASQIP_nso_noncardiac as b with (NOLOCK) on a.scrssn= b.scrssn 

select * from Dflt.Diabetes_AF_SGLT2_Smoke
select distinct scrssn from Dflt.Diabetes_AF_SGLT2_Smoke where smoke = '1' --370

/*Prior Stroke */
/*Making sure the ICD9 and ICD10 codes relevant to Stroke are present in the Dimension table under CDWWork*/

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('I63.019','I63.119','I63.139','I63.20','I63.219','I63.22','I63.239','I63.30','I63.40','I63.50','I63.59')

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('433.21','433.11','433.91','433.01','434.01','434.11','434.91','433.31','433.81')

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime as comorbidity_Dischargedatettime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_AF_SGLT2_Stroke

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('433.21','433.11','433.91','433.01','434.01','434.11','434.91','433.31','433.81')
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('433.21','433.11','433.91','433.01','434.01','434.11','434.91','433.31','433.81')
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('433.21','433.11','433.91','433.01','434.01','434.11','434.91','433.31','433.81')
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('433.21','433.11','433.91','433.01','434.01','434.11','434.91','433.31','433.81')
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('433.21','433.11','433.91','433.01','434.01','434.11','434.91','433.31','433.81')
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('433.21','433.11','433.91','433.01','434.01','434.11','434.91','433.31','433.81')
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('433.21','433.11','433.91','433.01','434.01','434.11','434.91','433.31','433.81')
					and b.PatientTransferDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('433.21','433.11','433.91','433.01','434.01','434.11','434.91','433.31','433.81')
					and b.SpecialtyTransferDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('433.21','433.11','433.91','433.01','434.01','434.11','434.91','433.31','433.81')
					and b.AdmitDateTime <= a.SGLT2FillTime
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I63.019','I63.119','I63.139','I63.20','I63.219','I63.22','I63.239','I63.30','I63.40','I63.50','I63.59')
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I63.019','I63.119','I63.139','I63.20','I63.219','I63.22','I63.239','I63.30','I63.40','I63.50','I63.59')
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I63.019','I63.119','I63.139','I63.20','I63.219','I63.22','I63.239','I63.30','I63.40','I63.50','I63.59')
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I63.019','I63.119','I63.139','I63.20','I63.219','I63.22','I63.239','I63.30','I63.40','I63.50','I63.59')
and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I63.019','I63.119','I63.139','I63.20','I63.219','I63.22','I63.239','I63.30','I63.40','I63.50','I63.59')
and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I63.019','I63.119','I63.139','I63.20','I63.219','I63.22','I63.239','I63.30','I63.40','I63.50','I63.59')
and b.EventDateTime <= a.SGLT2FillTime

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I63.019','I63.119','I63.139','I63.20','I63.219','I63.22','I63.239','I63.30','I63.40','I63.50','I63.59')
and b.PatientTransferDateTime <= a.SGLT2FillTime

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I63.019','I63.119','I63.139','I63.20','I63.219','I63.22','I63.239','I63.30','I63.40','I63.50','I63.59')
and b.SpecialtyTransferDateTime <= a.SGLT2FillTime

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I63.019','I63.119','I63.139','I63.20','I63.219','I63.22','I63.239','I63.30','I63.40','I63.50','I63.59')
and b.AdmitDateTime <= a.SGLT2FillTime

select distinct scrssn from Dflt.Diabetes_AF_SGLT2_Stroke --166

/* Prior Myocardial Infarction */
/*Making sure the ICD9 and ICD10 codes relevant to Myocardial Infarction are present in the Dimension table under CDWWork*/

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('I21.01','I21.02','I21.19','I21.29','I21.3','I21.4','I21.9','I22.0','I22.1','I22.8','I22.9',
																	'I23.0','I23.1','I23.2','I23.3','I23.4','I23.5','I23.6','I23.7','I23.8','I24.0','I24.1','I24.8')

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('410.00','410.01','410.02','410.10','410.11','410.12','410.30','410.31','410.32','410.20','410.21','410.22',
														'410.40','410.41','410.42','410.50','410.51','410.52','410.60','410.61','410.62','410.80','410.81','410.82',
														'410.90','410.91','410.92','410.70','410.71','410.72','429.79','411.81','411.0','411.89')

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime as comorbidity_Dischargedatetime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_AF_SGLT2_MI

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('410.00','410.01','410.02','410.10','410.11','410.12','410.30','410.31','410.32','410.20','410.21','410.22',
														'410.40','410.41','410.42','410.50','410.51','410.52','410.60','410.61','410.62','410.80','410.81','410.82',
														'410.90','410.91','410.92','410.70','410.71','410.72','429.79','411.81','411.0','411.89')
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime , c.ICD9Code 

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('410.00','410.01','410.02','410.10','410.11','410.12','410.30','410.31','410.32','410.20','410.21','410.22',
														'410.40','410.41','410.42','410.50','410.51','410.52','410.60','410.61','410.62','410.80','410.81','410.82',
														'410.90','410.91','410.92','410.70','410.71','410.72','429.79','411.81','411.0','411.89')
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('410.00','410.01','410.02','410.10','410.11','410.12','410.30','410.31','410.32','410.20','410.21','410.22',
														'410.40','410.41','410.42','410.50','410.51','410.52','410.60','410.61','410.62','410.80','410.81','410.82',
														'410.90','410.91','410.92','410.70','410.71','410.72','429.79','411.81','411.0','411.89')
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('410.00','410.01','410.02','410.10','410.11','410.12','410.30','410.31','410.32','410.20','410.21','410.22',
														'410.40','410.41','410.42','410.50','410.51','410.52','410.60','410.61','410.62','410.80','410.81','410.82',
														'410.90','410.91','410.92','410.70','410.71','410.72','429.79','411.81','411.0','411.89')
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('410.00','410.01','410.02','410.10','410.11','410.12','410.30','410.31','410.32','410.20','410.21','410.22',
														'410.40','410.41','410.42','410.50','410.51','410.52','410.60','410.61','410.62','410.80','410.81','410.82',
														'410.90','410.91','410.92','410.70','410.71','410.72','429.79','411.81','411.0','411.89')
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('410.00','410.01','410.02','410.10','410.11','410.12','410.30','410.31','410.32','410.20','410.21','410.22',
														'410.40','410.41','410.42','410.50','410.51','410.52','410.60','410.61','410.62','410.80','410.81','410.82',
														'410.90','410.91','410.92','410.70','410.71','410.72','429.79','411.81','411.0','411.89')
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('410.00','410.01','410.02','410.10','410.11','410.12','410.30','410.31','410.32','410.20','410.21','410.22',
														'410.40','410.41','410.42','410.50','410.51','410.52','410.60','410.61','410.62','410.80','410.81','410.82',
														'410.90','410.91','410.92','410.70','410.71','410.72','429.79','411.81','411.0','411.89')
					and b.PatientTransferDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('410.00','410.01','410.02','410.10','410.11','410.12','410.30','410.31','410.32','410.20','410.21','410.22',
														'410.40','410.41','410.42','410.50','410.51','410.52','410.60','410.61','410.62','410.80','410.81','410.82',
														'410.90','410.91','410.92','410.70','410.71','410.72','429.79','411.81','411.0','411.89')
				and b.SpecialtyTransferDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('410.00','410.01','410.02','410.10','410.11','410.12','410.30','410.31','410.32','410.20','410.21','410.22',
					'410.40','410.41','410.42','410.50','410.51','410.52','410.60','410.61','410.62','410.80','410.81','410.82',
					'410.90','410.91','410.92','410.70','410.71','410.72','429.79','411.81','411.0','411.89')
					and b.AdmitDateTime <= a.SGLT2FillTime
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I21.01','I21.02','I21.19','I21.29','I21.3','I21.4','I21.9','I22.0','I22.1','I22.8','I22.9',
					'I23.0','I23.1','I23.2','I23.3','I23.4','I23.5','I23.6','I23.7','I23.8','I24.0','I24.1','I24.8')
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I21.01','I21.02','I21.19','I21.29','I21.3','I21.4','I21.9','I22.0','I22.1','I22.8','I22.9',
					'I23.0','I23.1','I23.2','I23.3','I23.4','I23.5','I23.6','I23.7','I23.8','I24.0','I24.1','I24.8')
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I21.01','I21.02','I21.19','I21.29','I21.3','I21.4','I21.9','I22.0','I22.1','I22.8','I22.9',
					'I23.0','I23.1','I23.2','I23.3','I23.4','I23.5','I23.6','I23.7','I23.8','I24.0','I24.1','I24.8')
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I21.01','I21.02','I21.19','I21.29','I21.3','I21.4','I21.9','I22.0','I22.1','I22.8','I22.9',
					'I23.0','I23.1','I23.2','I23.3','I23.4','I23.5','I23.6','I23.7','I23.8','I24.0','I24.1','I24.8')
and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I21.01','I21.02','I21.19','I21.29','I21.3','I21.4','I21.9','I22.0','I22.1','I22.8','I22.9',
					'I23.0','I23.1','I23.2','I23.3','I23.4','I23.5','I23.6','I23.7','I23.8','I24.0','I24.1','I24.8')
and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I21.01','I21.02','I21.19','I21.29','I21.3','I21.4','I21.9','I22.0','I22.1','I22.8','I22.9',
					'I23.0','I23.1','I23.2','I23.3','I23.4','I23.5','I23.6','I23.7','I23.8','I24.0','I24.1','I24.8')
and b.EventDateTime <= a.SGLT2FillTime

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I21.01','I21.02','I21.19','I21.29','I21.3','I21.4','I21.9','I22.0','I22.1','I22.8','I22.9',
					'I23.0','I23.1','I23.2','I23.3','I23.4','I23.5','I23.6','I23.7','I23.8','I24.0','I24.1','I24.8')
and b.PatientTransferDateTime <= a.SGLT2FillTime

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I21.01','I21.02','I21.19','I21.29','I21.3','I21.4','I21.9','I22.0','I22.1','I22.8','I22.9',
					'I23.0','I23.1','I23.2','I23.3','I23.4','I23.5','I23.6','I23.7','I23.8','I24.0','I24.1','I24.8')
and b.SpecialtyTransferDateTime <= a.SGLT2FillTime

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I21.01','I21.02','I21.19','I21.29','I21.3','I21.4','I21.9','I22.0','I22.1','I22.8','I22.9',
					'I23.0','I23.1','I23.2','I23.3','I23.4','I23.5','I23.6','I23.7','I23.8','I24.0','I24.1','I24.8')
and b.AdmitDateTime <= a.SGLT2FillTime

Select distinct scrssn from Dflt.Diabetes_AF_SGLT2_MI --991

/*Ablation*/
/*Making sure the CPT codes relevant to Ablation are present in the Dimension table under CDWWork*/

select distinct CPTCode from CDWWork.Dim.CPT where CPTCode in ('93656','93657','93662','33254','33255','33258','33265','33266')

select distinct a.*

into Dflt.Diabetes_AF_SGLT2_Ablation

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientCPTProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
Src.Cohort_CPT as c with (NOLOCK) on c.CPTSID=b.cptSID 
where c.cptcode in ('93656','93657','93662','33254','33255','33258','33265','33266')
and b.DischargeDateTime <= a.SGLT2Filltime
union all

select distinct a.*
from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_Vprocedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
Src.Cohort_CPT as c with (NOLOCK) on c.CPTSID=b.cptSID 
where c.cptcode in ('93656','93657','93662','33254','33255','33258','33265','33266')
and b.EventDateTime <= a.SGLT2Filltime
union all 

select distinct a.*
from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_VProcedure_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
Src.Cohort_CPT as c with (NOLOCK) on c.CPTSID=b.cptSID 
where c.cptcode in ('93656','93657','93662','33254','33255','33258','33265','33266')
and b.EventDateTime <= a.SGLT2Filltime
union all

select distinct a.*
from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Surg_SurgeryPrincipalAssociatedProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on b.OtherProcedureCPTSID=c.cptSID 
where c.cptcode in ('93656','93657','93662','33254','33255','33258','33265','33266') 
and b.SurgeryDateTime <= a.SGLT2Filltime
union all

select distinct a.*
from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Surg_SurgeryProcedureDiagnosisCode as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on b.PrincipalCPTSID=c.cptSID 
where c.cptcode in ('93656','93657','93662','33254','33255','33258','33265','33266')
and b.SurgeryDateTime <= a.SGLT2Filltime
union all

select distinct a.*
from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_VProcedureCPTModifier as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on b.CPTSID=c.cptSID 
where c.cptcode in ('93656','93657','93662','33254','33255','33258','33265','33266')
and b.visitdatetime <= a.SGLT2Filltime
union all

select distinct a.*
from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_VProcedureDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on b.CPTSID=c.cptSID 
where c.cptcode in ('93656','93657','93662','33254','33255','33258','33265','33266')
and b.EventDateTime <= a.SGLT2Filltime
union all

select distinct a.*
from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on b.CPTSID=c.cptSID 
where c.cptcode in ('93656','93657','93662','33254','33255','33258','33265','33266')
and b.EventDateTime <= a.SGLT2Filltime
union all

select distinct a.*
from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVProcedureCPTModifier as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on  b.CPTSID=c.cptSID 
where c.cptcode in ('93656','93657','93662','33254','33255','33258','33265','33266')
and b.VisitDateTime <= a.SGLT2Filltime


select distinct scrssn from Dflt.Diabetes_AF_SGLT2_Ablation --82

/* CAD */

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime as comorbidity_Dischargedatettime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_AF_SGLT2_CAD

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('411.00''411.10','411.81','411.89','413.00','413.90','414.00','414.01','414.02','414.03','414.04',
'414.05','414.06','414.20','414.30','414.40','414.80','414.90','V45.81','V45.82')
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('411.00''411.10','411.81','411.89','413.00','413.90','414.00','414.01','414.02','414.03','414.04',
'414.05','414.06','414.20','414.30','414.40','414.80','414.90','V45.81','V45.82')
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('411.00''411.10','411.81','411.89','413.00','413.90','414.00','414.01','414.02','414.03','414.04',
'414.05','414.06','414.20','414.30','414.40','414.80','414.90','V45.81','V45.82')
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('411.00''411.10','411.81','411.89','413.00','413.90','414.00','414.01','414.02','414.03','414.04',
'414.05','414.06','414.20','414.30','414.40','414.80','414.90','V45.81','V45.82')
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('411.00''411.10','411.81','411.89','413.00','413.90','414.00','414.01','414.02','414.03','414.04',
'414.05','414.06','414.20','414.30','414.40','414.80','414.90','V45.81','V45.82')
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('411.00''411.10','411.81','411.89','413.00','413.90','414.00','414.01','414.02','414.03','414.04',
'414.05','414.06','414.20','414.30','414.40','414.80','414.90','V45.81','V45.82')
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('411.00''411.10','411.81','411.89','413.00','413.90','414.00','414.01','414.02','414.03','414.04',
'414.05','414.06','414.20','414.30','414.40','414.80','414.90','V45.81','V45.82')
					and b.PatientTransferDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('411.00''411.10','411.81','411.89','413.00','413.90','414.00','414.01','414.02','414.03','414.04',
'414.05','414.06','414.20','414.30','414.40','414.80','414.90','V45.81','V45.82')
					and b.SpecialtyTransferDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('411.00''411.10','411.81','411.89','413.00','413.90','414.00','414.01','414.02','414.03','414.04',
'414.05','414.06','414.20','414.30','414.40','414.80','414.90','V45.81','V45.82')
					and b.AdmitDateTime <= a.SGLT2FillTime
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I24.1','I20.0','I24.0','I24.8','I28.0','I20.8','I20.9','I25.0','I25.10','I25.810','I25.811',
'I25.82','I25.83','I25.84','I25.5','I25.9','I25.89','Z95.1','Z98.61')
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I24.1','I20.0','I24.0','I24.8','I28.0','I20.8','I20.9','I25.0','I25.10','I25.810','I25.811',
'I25.82','I25.83','I25.84','I25.5','I25.9','I25.89','Z95.1','Z98.61')
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I24.1','I20.0','I24.0','I24.8','I28.0','I20.8','I20.9','I25.0','I25.10','I25.810','I25.811',
'I25.82','I25.83','I25.84','I25.5','I25.9','I25.89','Z95.1','Z98.61')
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I24.1','I20.0','I24.0','I24.8','I28.0','I20.8','I20.9','I25.0','I25.10','I25.810','I25.811',
'I25.82','I25.83','I25.84','I25.5','I25.9','I25.89','Z95.1','Z98.61')
and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I24.1','I20.0','I24.0','I24.8','I28.0','I20.8','I20.9','I25.0','I25.10','I25.810','I25.811',
'I25.82','I25.83','I25.84','I25.5','I25.9','I25.89','Z95.1','Z98.61')
and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I24.1','I20.0','I24.0','I24.8','I28.0','I20.8','I20.9','I25.0','I25.10','I25.810','I25.811',
'I25.82','I25.83','I25.84','I25.5','I25.9','I25.89','Z95.1','Z98.61')
and b.EventDateTime <= a.SGLT2FillTime

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I24.1','I20.0','I24.0','I24.8','I28.0','I20.8','I20.9','I25.0','I25.10','I25.810','I25.811',
'I25.82','I25.83','I25.84','I25.5','I25.9','I25.89','Z95.1','Z98.61')
and b.PatientTransferDateTime <= a.SGLT2FillTime

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I24.1','I20.0','I24.0','I24.8','I28.0','I20.8','I20.9','I25.0','I25.10','I25.810','I25.811',
'I25.82','I25.83','I25.84','I25.5','I25.9','I25.89','Z95.1','Z98.61')
and b.SpecialtyTransferDateTime <= a.SGLT2FillTime

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I24.1','I20.0','I24.0','I24.8','I28.0','I20.8','I20.9','I25.0','I25.10','I25.810','I25.811',
'I25.82','I25.83','I25.84','I25.5','I25.9','I25.89','Z95.1','Z98.61')
and b.AdmitDateTime <= a.SGLT2FillTime

select distinct scrssn from Dflt.Diabetes_AF_SGLT2_CAD --2761

/* CAD- PCI & CABG */

select a.*, b.SURGDATE

into #tempCABGSGLT2

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
src.VASQIP_nso_cardiac as b with (NOLOCK) on a.scrssn= b.scrssn
where b.cpt01 in ('33533','33534','33535','33536','33542','33545','33548')
and b.SURGDATE <= a.SGLT2filltime /* Check the dates */

select * from #tempCABGSGLT2

select a.*, b.ProcedureDateTime

into #tempPCISGLT2

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.CART_PCI as b with (NOLOCK) on a.PatientSID= b.PatientSID
where b.ProcedureDateTime <= a.SGLT2filltime /* Check the dates */

Select distinct patientsid, scrssn, SGLT2FillTime, surgdate

into Dflt.Diabetes_AF_SGLT2_cadCabgpci

from #tempCABGSGLT2
union all

select distinct patientsid, scrssn, SGLT2FillTime, ProcedureDateTime
from #tempPCISGLT2
union all 

select distinct patientsid, scrssn, SGLT2FillTime, comorbidity_Dischargedatettime
from Dflt.Diabetes_AF_SGLT2_CAD

select distinct scrssn from Dflt.Diabetes_AF_SGLT2_cadCabgpci  --2769

/* PAD */

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime as comorbidity_Dischargedatettime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_AF_SGLT2_PAD

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('440.0','440.0','440.1','440.2','440.20','440.21','440.22','440.23','440.24','440.29','440.30',
                    '440.31','440.32','440.4','440.8','440.9','441.0','441.00','441.01','441.02','441.03','441.1','441.2',
					'441.3','441.4','441.5','441.6','441.7','441.9','442.0','442.1','442.2','442.3','442.81','442.82',
					'442.83','442.84','442.89','442.9','443.0','443.1','443.21','443.22','443.23','443.24','443.29')
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('440.0','440.0','440.1','440.2','440.20','440.21','440.22','440.23','440.24','440.29','440.30',
                    '440.31','440.32','440.4','440.8','440.9','441.0','441.00','441.01','441.02','441.03','441.1','441.2',
					'441.3','441.4','441.5','441.6','441.7','441.9','442.0','442.1','442.2','442.3','442.81','442.82',
					'442.83','442.84','442.89','442.9','443.0','443.1','443.21','443.22','443.23','443.24','443.29')
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('440.0','440.0','440.1','440.2','440.20','440.21','440.22','440.23','440.24','440.29','440.30',
                    '440.31','440.32','440.4','440.8','440.9','441.0','441.00','441.01','441.02','441.03','441.1','441.2',
					'441.3','441.4','441.5','441.6','441.7','441.9','442.0','442.1','442.2','442.3','442.81','442.82',
					'442.83','442.84','442.89','442.9','443.0','443.1','443.21','443.22','443.23','443.24','443.29')
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('440.0','440.0','440.1','440.2','440.20','440.21','440.22','440.23','440.24','440.29','440.30',
                    '440.31','440.32','440.4','440.8','440.9','441.0','441.00','441.01','441.02','441.03','441.1','441.2',
					'441.3','441.4','441.5','441.6','441.7','441.9','442.0','442.1','442.2','442.3','442.81','442.82',
					'442.83','442.84','442.89','442.9','443.0','443.1','443.21','443.22','443.23','443.24','443.29')
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('440.0','440.0','440.1','440.2','440.20','440.21','440.22','440.23','440.24','440.29','440.30',
                    '440.31','440.32','440.4','440.8','440.9','441.0','441.00','441.01','441.02','441.03','441.1','441.2',
					'441.3','441.4','441.5','441.6','441.7','441.9','442.0','442.1','442.2','442.3','442.81','442.82',
					'442.83','442.84','442.89','442.9','443.0','443.1','443.21','443.22','443.23','443.24','443.29')
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('440.0','440.0','440.1','440.2','440.20','440.21','440.22','440.23','440.24','440.29','440.30',
                    '440.31','440.32','440.4','440.8','440.9','441.0','441.00','441.01','441.02','441.03','441.1','441.2',
					'441.3','441.4','441.5','441.6','441.7','441.9','442.0','442.1','442.2','442.3','442.81','442.82',
					'442.83','442.84','442.89','442.9','443.0','443.1','443.21','443.22','443.23','443.24','443.29')
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('440.0','440.0','440.1','440.2','440.20','440.21','440.22','440.23','440.24','440.29','440.30',
                    '440.31','440.32','440.4','440.8','440.9','441.0','441.00','441.01','441.02','441.03','441.1','441.2',
					'441.3','441.4','441.5','441.6','441.7','441.9','442.0','442.1','442.2','442.3','442.81','442.82',
					'442.83','442.84','442.89','442.9','443.0','443.1','443.21','443.22','443.23','443.24','443.29')
					and b.PatientTransferDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('440.0','440.0','440.1','440.2','440.20','440.21','440.22','440.23','440.24','440.29','440.30',
                    '440.31','440.32','440.4','440.8','440.9','441.0','441.00','441.01','441.02','441.03','441.1','441.2',
					'441.3','441.4','441.5','441.6','441.7','441.9','442.0','442.1','442.2','442.3','442.81','442.82',
					'442.83','442.84','442.89','442.9','443.0','443.1','443.21','443.22','443.23','443.24','443.29')
					and b.SpecialtyTransferDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('440.0','440.0','440.1','440.2','440.20','440.21','440.22','440.23','440.24','440.29','440.30',
                    '440.31','440.32','440.4','440.8','440.9','441.0','441.00','441.01','441.02','441.03','441.1','441.2',
					'441.3','441.4','441.5','441.6','441.7','441.9','442.0','442.1','442.2','442.3','442.81','442.82',
					'442.83','442.84','442.89','442.9','443.0','443.1','443.21','443.22','443.23','443.24','443.29')
					and b.AdmitDateTime <= a.SGLT2FillTime
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I70.0','I70.1','I70.209','I70.219','I70.229','I70.25','I70.269','I70.299','I70.399','I70.499','I70.599','I70.92','I70.8','I70.90',
                    'I71.00','I71.01','I71.02','I71.03','I71.1','I71.2','I71.3','I71.4','I71.5','I71.6','I71.8','I71.9','I72.0','I72.1','I72.2','I72.3',
					'I72.4','I72.5','I72.6','I72.8','I72.9','I73.00','I73.01','I73.1','I73.81','I73.89','I73.9','I77.1','I77.71','I77.72','I77.73','I77.74',
					'I77.75','I77.76','I77.77','I77.79','I79.8','K55.1','K55.9','Z95.828')
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I70.0','I70.1','I70.209','I70.219','I70.229','I70.25','I70.269','I70.299','I70.399','I70.499','I70.599','I70.92','I70.8','I70.90',
                    'I71.00','I71.01','I71.02','I71.03','I71.1','I71.2','I71.3','I71.4','I71.5','I71.6','I71.8','I71.9','I72.0','I72.1','I72.2','I72.3',
					'I72.4','I72.5','I72.6','I72.8','I72.9','I73.00','I73.01','I73.1','I73.81','I73.89','I73.9','I77.1','I77.71','I77.72','I77.73','I77.74',
					'I77.75','I77.76','I77.77','I77.79','I79.8','K55.1','K55.9','Z95.828')
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I70.0','I70.1','I70.209','I70.219','I70.229','I70.25','I70.269','I70.299','I70.399','I70.499','I70.599','I70.92','I70.8','I70.90',
                    'I71.00','I71.01','I71.02','I71.03','I71.1','I71.2','I71.3','I71.4','I71.5','I71.6','I71.8','I71.9','I72.0','I72.1','I72.2','I72.3',
					'I72.4','I72.5','I72.6','I72.8','I72.9','I73.00','I73.01','I73.1','I73.81','I73.89','I73.9','I77.1','I77.71','I77.72','I77.73','I77.74',
					'I77.75','I77.76','I77.77','I77.79','I79.8','K55.1','K55.9','Z95.828')
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I70.0','I70.1','I70.209','I70.219','I70.229','I70.25','I70.269','I70.299','I70.399','I70.499','I70.599','I70.92','I70.8','I70.90',
                    'I71.00','I71.01','I71.02','I71.03','I71.1','I71.2','I71.3','I71.4','I71.5','I71.6','I71.8','I71.9','I72.0','I72.1','I72.2','I72.3',
					'I72.4','I72.5','I72.6','I72.8','I72.9','I73.00','I73.01','I73.1','I73.81','I73.89','I73.9','I77.1','I77.71','I77.72','I77.73','I77.74',
					'I77.75','I77.76','I77.77','I77.79','I79.8','K55.1','K55.9','Z95.828')
and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I70.0','I70.1','I70.209','I70.219','I70.229','I70.25','I70.269','I70.299','I70.399','I70.499','I70.599','I70.92','I70.8','I70.90',
                    'I71.00','I71.01','I71.02','I71.03','I71.1','I71.2','I71.3','I71.4','I71.5','I71.6','I71.8','I71.9','I72.0','I72.1','I72.2','I72.3',
					'I72.4','I72.5','I72.6','I72.8','I72.9','I73.00','I73.01','I73.1','I73.81','I73.89','I73.9','I77.1','I77.71','I77.72','I77.73','I77.74',
					'I77.75','I77.76','I77.77','I77.79','I79.8','K55.1','K55.9','Z95.828')
and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I70.0','I70.1','I70.209','I70.219','I70.229','I70.25','I70.269','I70.299','I70.399','I70.499','I70.599','I70.92','I70.8','I70.90',
                    'I71.00','I71.01','I71.02','I71.03','I71.1','I71.2','I71.3','I71.4','I71.5','I71.6','I71.8','I71.9','I72.0','I72.1','I72.2','I72.3',
					'I72.4','I72.5','I72.6','I72.8','I72.9','I73.00','I73.01','I73.1','I73.81','I73.89','I73.9','I77.1','I77.71','I77.72','I77.73','I77.74',
					'I77.75','I77.76','I77.77','I77.79','I79.8','K55.1','K55.9','Z95.828')
and b.EventDateTime <= a.SGLT2FillTime

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I70.0','I70.1','I70.209','I70.219','I70.229','I70.25','I70.269','I70.299','I70.399','I70.499','I70.599','I70.92','I70.8','I70.90',
                    'I71.00','I71.01','I71.02','I71.03','I71.1','I71.2','I71.3','I71.4','I71.5','I71.6','I71.8','I71.9','I72.0','I72.1','I72.2','I72.3',
					'I72.4','I72.5','I72.6','I72.8','I72.9','I73.00','I73.01','I73.1','I73.81','I73.89','I73.9','I77.1','I77.71','I77.72','I77.73','I77.74',
					'I77.75','I77.76','I77.77','I77.79','I79.8','K55.1','K55.9','Z95.828')
and b.PatientTransferDateTime <= a.SGLT2FillTime

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I70.0','I70.1','I70.209','I70.219','I70.229','I70.25','I70.269','I70.299','I70.399','I70.499','I70.599','I70.92','I70.8','I70.90',
                    'I71.00','I71.01','I71.02','I71.03','I71.1','I71.2','I71.3','I71.4','I71.5','I71.6','I71.8','I71.9','I72.0','I72.1','I72.2','I72.3',
					'I72.4','I72.5','I72.6','I72.8','I72.9','I73.00','I73.01','I73.1','I73.81','I73.89','I73.9','I77.1','I77.71','I77.72','I77.73','I77.74',
					'I77.75','I77.76','I77.77','I77.79','I79.8','K55.1','K55.9','Z95.828')
and b.SpecialtyTransferDateTime <= a.SGLT2FillTime

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I70.0','I70.1','I70.209','I70.219','I70.229','I70.25','I70.269','I70.299','I70.399','I70.499','I70.599','I70.92','I70.8','I70.90',
                    'I71.00','I71.01','I71.02','I71.03','I71.1','I71.2','I71.3','I71.4','I71.5','I71.6','I71.8','I71.9','I72.0','I72.1','I72.2','I72.3',
					'I72.4','I72.5','I72.6','I72.8','I72.9','I73.00','I73.01','I73.1','I73.81','I73.89','I73.9','I77.1','I77.71','I77.72','I77.73','I77.74',
					'I77.75','I77.76','I77.77','I77.79','I79.8','K55.1','K55.9','Z95.828')
and b.AdmitDateTime <= a.SGLT2FillTime

select distinct scrssn from Dflt.Diabetes_AF_SGLT2_PAD --798

/*Cardioversion*/

/*Making sure the CPT codes relevant to Cardioversion are present in the Dimension table under CDWWork*/

select distinct CPTCode from CDWWork.Dim.CPT where CPTCode in ('92960','92961')

select distinct a.*

into Dflt.Diabetes_AF_SGLT2_Cardioversion

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientCPTProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
Src.Cohort_CPT as c with (NOLOCK) on c.CPTSID=b.cptSID 
where c.cptcode in ('92960','92961')
union all

select distinct a.*
from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_Vprocedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
Src.Cohort_CPT as c with (NOLOCK) on c.CPTSID=b.cptSID 
where c.cptcode in ('92960','92961')
union all 

select distinct a.*
from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_VProcedure_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
Src.Cohort_CPT as c with (NOLOCK) on c.CPTSID=b.cptSID 
where c.cptcode in ('92960','92961')
union all

select distinct a.*
from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Surg_SurgeryPrincipalAssociatedProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on b.OtherProcedureCPTSID=c.cptSID 
where c.cptcode in ('92960','92961')
union all

select distinct a.*
from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Surg_SurgeryProcedureDiagnosisCode as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on b.PrincipalCPTSID=c.cptSID 
where c.cptcode in ('92960','92961')
union all

select distinct a.*
from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_VProcedureCPTModifier as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on b.CPTSID=c.cptSID 
where c.cptcode in ('92960','92961')
union all

select distinct a.*
from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_VProcedureDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on b.CPTSID=c.cptSID 
where c.cptcode in ('92960','92961')
union all

select distinct a.*
from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on b.CPTSID=c.cptSID 
where c.cptcode in ('92960','92961')
union all

select distinct a.*
from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVProcedureCPTModifier as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on  b.CPTSID=c.cptSID 
where c.cptcode in ('92960','92961')

select distinct scrssn from Dflt.Diabetes_AF_SGLT2_Cardioversion --0
drop table Dflt.Diabetes_AF_SGLT2_Cardioversion

/* Cardioversion Proc codes */

select distinct ICD9ProcedureCode from CDWWork.Dim.ICD9Procedure where ICD9ProcedureCode in ('99.61','99.62') 
select distinct ICD10ProcedureCode from CDWWork.Dim.ICD10Procedure where ICD10ProcedureCode in ('5A2204Z') 

select distinct a.*, b.ICDProcedureDateTime, c.ICD9ProcedureCode
/*ICD9Procedure Codes*/

into Dflt.Diabetes_AF_SGLT2_Cardioversion

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_CensusICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('99.61','99.62')
					and b.ICDProcedureDateTime <= a.SGLT2Filltime
union all

select distinct a.*, b.SurgicalProcedureDateTime, c.ICD9ProcedureCode

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_CensusSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('99.61','99.62')
					and b.SurgicalProcedureDateTime <= a.SGLT2Filltime
union all

select distinct a.*, b.DischargeDateTime, c.ICD9ProcedureCode

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('99.61','99.62')
					and b.DischargeDateTime <= a.SGLT2Filltime
union all

select distinct a.*, b.DischargeDateTime, c.ICD9ProcedureCode

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('99.61','99.62')
					and b.DischargeDateTime <= a.SGLT2Filltime
union all

/*ICD10Procedure Codes*/
select distinct a.*, b.ICDProcedureDateTime, c.ICD10ProcedureCode

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_CensusICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('5A2204Z')
and b.ICDProcedureDateTime <= a.SGLT2Filltime
union all

select distinct a.*, b.SurgicalProcedureDateTime, c.ICD10ProcedureCode

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_CensusSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('5A2204Z')
and b.SurgicalProcedureDateTime <= a.SGLT2Filltime
union all

select distinct a.*, b.DischargeDateTime, c.ICD10ProcedureCode

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('5A2204Z')
and b.DischargeDateTime <= a.SGLT2Filltime
union all

select distinct a.*, b.DischargeDateTime, c.ICD10ProcedureCode

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('5A2204Z')
and b.DischargeDateTime <= a.SGLT2Filltime

select distinct scrssn from Dflt.Diabetes_AF_SGLT2_Cardioversion --644

/*ICD9 and 10 Procedure codes for Ablation */

/* Ablation Proc codes */

select distinct ICD9ProcedureCode from CDWWork.Dim.ICD9Procedure where ICD9ProcedureCode in ('37.33','37.34','37.37','37.80','38.65') 
select distinct ICD10ProcedureCode from CDWWork.Dim.ICD10Procedure where ICD10ProcedureCode in ('02560ZZ','02563ZZ','02564ZZ',
'02570ZZ','02573ZZ','02574ZZ','02580ZZ','02583ZZ','02584ZZ','025S0ZZ','025S3ZZ','025S4ZZ','025T0ZZ','025T3ZZ','025T4ZZ') 

select distinct a.*, b.ICDProcedureDateTime, c.ICD9ProcedureCode
/*ICD9Procedure Codes*/

into Dflt.Diabetes_AF_SGLT2_AbProc

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_CensusICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('37.33','37.34','37.37','37.80','38.65')
					and b.ICDProcedureDateTime <= a.SGLT2Filltime
union all

select distinct a.*, b.SurgicalProcedureDateTime, c.ICD9ProcedureCode

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_CensusSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('37.33','37.34','37.37','37.80','38.65')
					and b.SurgicalProcedureDateTime <= a.SGLT2Filltime
union all

select distinct a.*, b.DischargeDateTime, c.ICD9ProcedureCode

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('37.33','37.34','37.37','37.80','38.65')
					and b.DischargeDateTime <= a.SGLT2Filltime
union all

select distinct a.*, b.DischargeDateTime, c.ICD9ProcedureCode

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('37.33','37.34','37.37','37.80','38.65')
					and b.DischargeDateTime <= a.SGLT2Filltime
union all

/*ICD10Procedure Codes*/
select distinct a.*, b.ICDProcedureDateTime, c.ICD10ProcedureCode

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_CensusICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('02560ZZ','02563ZZ','02564ZZ',
'02570ZZ','02573ZZ','02574ZZ','02580ZZ','02583ZZ','02584ZZ','025S0ZZ','025S3ZZ','025S4ZZ','025T0ZZ','025T3ZZ','025T4ZZ')
and b.ICDProcedureDateTime <= a.SGLT2Filltime
union all

select distinct a.*, b.SurgicalProcedureDateTime, c.ICD10ProcedureCode

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_CensusSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('02560ZZ','02563ZZ','02564ZZ',
'02570ZZ','02573ZZ','02574ZZ','02580ZZ','02583ZZ','02584ZZ','025S0ZZ','025S3ZZ','025S4ZZ','025T0ZZ','025T3ZZ','025T4ZZ')
and b.SurgicalProcedureDateTime <= a.SGLT2Filltime
union all

select distinct a.*, b.DischargeDateTime, c.ICD10ProcedureCode

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('02560ZZ','02563ZZ','02564ZZ',
'02570ZZ','02573ZZ','02574ZZ','02580ZZ','02583ZZ','02584ZZ','025S0ZZ','025S3ZZ','025S4ZZ','025T0ZZ','025T3ZZ','025T4ZZ')
and b.DischargeDateTime <= a.SGLT2Filltime
union all

select distinct a.*, b.DischargeDateTime, c.ICD10ProcedureCode

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('02560ZZ','02563ZZ','02564ZZ',
'02570ZZ','02573ZZ','02574ZZ','02580ZZ','02583ZZ','02584ZZ','025S0ZZ','025S3ZZ','025S4ZZ','025T0ZZ','025T3ZZ','025T4ZZ')
and b.DischargeDateTime <= a.SGLT2Filltime

select distinct scrssn from Dflt.Diabetes_AF_SGLT2_AbProc --259

/*Depression */
/*Making sure the ICD9 and ICD10 codes relevant to depression are present in the Dimension table under CDWWork*/

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('296.20','296.22','296.23','296.30','296.32','296.33','300.00','311.','300.4','301.12','309.0','309.1')

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('F32.9','F32.1','F32.2','F33.1','F33.2','F41.9','F34.1','F43.21')

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime as comorbidity_Dischargedatettime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_AF_SGLT2_Depression

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('296.20','296.22','296.23','296.30','296.32','296.33','300.00','311.','300.4','301.12','309.0','309.1')
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('296.20','296.22','296.23','296.30','296.32','296.33','300.00','311.','300.4','301.12','309.0','309.1')
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('296.20','296.22','296.23','296.30','296.32','296.33','300.00','311.','300.4','301.12','309.0','309.1')
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('296.20','296.22','296.23','296.30','296.32','296.33','300.00','311.','300.4','301.12','309.0','309.1')
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('296.20','296.22','296.23','296.30','296.32','296.33','300.00','311.','300.4','301.12','309.0','309.1')
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('296.20','296.22','296.23','296.30','296.32','296.33','300.00','311.','300.4','301.12','309.0','309.1')
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('296.20','296.22','296.23','296.30','296.32','296.33','300.00','311.','300.4','301.12','309.0','309.1')
					and b.PatientTransferDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('296.20','296.22','296.23','296.30','296.32','296.33','300.00','311.','300.4','301.12','309.0','309.1')
					and b.SpecialtyTransferDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('296.20','296.22','296.23','296.30','296.32','296.33','300.00','311.','300.4','301.12','309.0','309.1')
					and b.AdmitDateTime <= a.SGLT2FillTime
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F32.9','F32.1','F32.2','F33.1','F33.2','F41.9','F34.1','F43.21') 
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F32.9','F32.1','F32.2','F33.1','F33.2','F41.9','F34.1','F43.21') 
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F32.9','F32.1','F32.2','F33.1','F33.2','F41.9','F34.1','F43.21') 
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F32.9','F32.1','F32.2','F33.1','F33.2','F41.9','F34.1','F43.21') 
and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F32.9','F32.1','F32.2','F33.1','F33.2','F41.9','F34.1','F43.21') 
and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F32.9','F32.1','F32.2','F33.1','F33.2','F41.9','F34.1','F43.21') 
and b.EventDateTime <= a.SGLT2FillTime

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F32.9','F32.1','F32.2','F33.1','F33.2','F41.9','F34.1','F43.21') 
and b.PatientTransferDateTime <= a.SGLT2FillTime

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F32.9','F32.1','F32.2','F33.1','F33.2','F41.9','F34.1','F43.21') 
and b.SpecialtyTransferDateTime <= a.SGLT2FillTime

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F32.9','F32.1','F32.2','F33.1','F33.2','F41.9','F34.1','F43.21') 
and b.AdmitDateTime <= a.SGLT2FillTime

select distinct scrssn from Dflt.Diabetes_AF_SGLT2_Depression --1494

/* COPD Chronic Obstructive Pulmonary Disease*/
/*Making sure the ICD9 and ICD10 codes relevant to COPD are present in the Dimension table under CDWWork*/

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('490.','491.0','491.1','491.2','491.20','491.21','491.22','491.8','491.9','492.0','492.8',
'493.00','493.01','493.02','493.10','493.11','493.12','493.20','493.21','493.22','493.81','493.82','493.90','493.91','493.92',
'494.','494.0','494.1','495.0','495.1','495.2','495.3','495.4','495.5','495.6','495.7','495.8','495.9','496.')

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('J40.','J41.0','J41.1','J41.8','J42.','J43.9','J44.0','J44.1','J44.9',
'J45.20','J45.22','J45.21','J45.990','J45.991','J45.909','J45.998','J45.902','J45.901','J47.9','J47.1',
'J67.0','J67.1','J67.2','J67.3','J67.4','J67.5','J67.6','J67.7','J67.8','J67.9')

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime as comorbidity_Dischargedatettime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_AF_SGLT2_COPD

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('490.','491.0','491.1','491.2','491.20','491.21','491.22','491.8','491.9','492.0','492.8',
'493.00','493.01','493.02','493.10','493.11','493.12','493.20','493.21','493.22','493.81','493.82','493.90','493.91','493.92',
'494.','494.0','494.1','495.0','495.1','495.2','495.3','495.4','495.5','495.6','495.7','495.8','495.9','496.')
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('490.','491.0','491.1','491.2','491.20','491.21','491.22','491.8','491.9','492.0','492.8',
'493.00','493.01','493.02','493.10','493.11','493.12','493.20','493.21','493.22','493.81','493.82','493.90','493.91','493.92',
'494.','494.0','494.1','495.0','495.1','495.2','495.3','495.4','495.5','495.6','495.7','495.8','495.9','496.')
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('490.','491.0','491.1','491.2','491.20','491.21','491.22','491.8','491.9','492.0','492.8',
'493.00','493.01','493.02','493.10','493.11','493.12','493.20','493.21','493.22','493.81','493.82','493.90','493.91','493.92',
'494.','494.0','494.1','495.0','495.1','495.2','495.3','495.4','495.5','495.6','495.7','495.8','495.9','496.')
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('490.','491.0','491.1','491.2','491.20','491.21','491.22','491.8','491.9','492.0','492.8',
'493.00','493.01','493.02','493.10','493.11','493.12','493.20','493.21','493.22','493.81','493.82','493.90','493.91','493.92',
'494.','494.0','494.1','495.0','495.1','495.2','495.3','495.4','495.5','495.6','495.7','495.8','495.9','496.')
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('490.','491.0','491.1','491.2','491.20','491.21','491.22','491.8','491.9','492.0','492.8',
'493.00','493.01','493.02','493.10','493.11','493.12','493.20','493.21','493.22','493.81','493.82','493.90','493.91','493.92',
'494.','494.0','494.1','495.0','495.1','495.2','495.3','495.4','495.5','495.6','495.7','495.8','495.9','496.')
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('490.','491.0','491.1','491.2','491.20','491.21','491.22','491.8','491.9','492.0','492.8',
'493.00','493.01','493.02','493.10','493.11','493.12','493.20','493.21','493.22','493.81','493.82','493.90','493.91','493.92',
'494.','494.0','494.1','495.0','495.1','495.2','495.3','495.4','495.5','495.6','495.7','495.8','495.9','496.')
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('490.','491.0','491.1','491.2','491.20','491.21','491.22','491.8','491.9','492.0','492.8',
'493.00','493.01','493.02','493.10','493.11','493.12','493.20','493.21','493.22','493.81','493.82','493.90','493.91','493.92',
'494.','494.0','494.1','495.0','495.1','495.2','495.3','495.4','495.5','495.6','495.7','495.8','495.9','496.')
					and b.PatientTransferDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('490.','491.0','491.1','491.2','491.20','491.21','491.22','491.8','491.9','492.0','492.8',
'493.00','493.01','493.02','493.10','493.11','493.12','493.20','493.21','493.22','493.81','493.82','493.90','493.91','493.92',
'494.','494.0','494.1','495.0','495.1','495.2','495.3','495.4','495.5','495.6','495.7','495.8','495.9','496.')
					and b.SpecialtyTransferDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('490.','491.0','491.1','491.2','491.20','491.21','491.22','491.8','491.9','492.0','492.8',
'493.00','493.01','493.02','493.10','493.11','493.12','493.20','493.21','493.22','493.81','493.82','493.90','493.91','493.92',
'494.','494.0','494.1','495.0','495.1','495.2','495.3','495.4','495.5','495.6','495.7','495.8','495.9','496.')
					and b.AdmitDateTime <= a.SGLT2FillTime
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F20.0','F20.1','F20.2','F20.3','F20.81','F20.89','F20.9','F25.9')
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('J40.','J41.0','J41.1','J41.8','J42.','J43.9','J44.0','J44.1','J44.9',
'J45.20','J45.22','J45.21','J45.990','J45.991','J45.909','J45.998','J45.902','J45.901','J47.9','J47.1',
'J67.0','J67.1','J67.2','J67.3','J67.4','J67.5','J67.6','J67.7','J67.8','J67.9')
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('J40.','J41.0','J41.1','J41.8','J42.','J43.9','J44.0','J44.1','J44.9',
'J45.20','J45.22','J45.21','J45.990','J45.991','J45.909','J45.998','J45.902','J45.901','J47.9','J47.1',
'J67.0','J67.1','J67.2','J67.3','J67.4','J67.5','J67.6','J67.7','J67.8','J67.9')
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('J40.','J41.0','J41.1','J41.8','J42.','J43.9','J44.0','J44.1','J44.9',
'J45.20','J45.22','J45.21','J45.990','J45.991','J45.909','J45.998','J45.902','J45.901','J47.9','J47.1',
'J67.0','J67.1','J67.2','J67.3','J67.4','J67.5','J67.6','J67.7','J67.8','J67.9')
and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('J40.','J41.0','J41.1','J41.8','J42.','J43.9','J44.0','J44.1','J44.9',
'J45.20','J45.22','J45.21','J45.990','J45.991','J45.909','J45.998','J45.902','J45.901','J47.9','J47.1',
'J67.0','J67.1','J67.2','J67.3','J67.4','J67.5','J67.6','J67.7','J67.8','J67.9')
and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('J40.','J41.0','J41.1','J41.8','J42.','J43.9','J44.0','J44.1','J44.9',
'J45.20','J45.22','J45.21','J45.990','J45.991','J45.909','J45.998','J45.902','J45.901','J47.9','J47.1',
'J67.0','J67.1','J67.2','J67.3','J67.4','J67.5','J67.6','J67.7','J67.8','J67.9')
and b.EventDateTime <= a.SGLT2FillTime

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('J40.','J41.0','J41.1','J41.8','J42.','J43.9','J44.0','J44.1','J44.9',
'J45.20','J45.22','J45.21','J45.990','J45.991','J45.909','J45.998','J45.902','J45.901','J47.9','J47.1',
'J67.0','J67.1','J67.2','J67.3','J67.4','J67.5','J67.6','J67.7','J67.8','J67.9')
and b.PatientTransferDateTime <= a.SGLT2FillTime

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('J40.','J41.0','J41.1','J41.8','J42.','J43.9','J44.0','J44.1','J44.9',
'J45.20','J45.22','J45.21','J45.990','J45.991','J45.909','J45.998','J45.902','J45.901','J47.9','J47.1',
'J67.0','J67.1','J67.2','J67.3','J67.4','J67.5','J67.6','J67.7','J67.8','J67.9')
and b.SpecialtyTransferDateTime <= a.SGLT2FillTime

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('J40.','J41.0','J41.1','J41.8','J42.','J43.9','J44.0','J44.1','J44.9',
'J45.20','J45.22','J45.21','J45.990','J45.991','J45.909','J45.998','J45.902','J45.901','J47.9','J47.1',
'J67.0','J67.1','J67.2','J67.3','J67.4','J67.5','J67.6','J67.7','J67.8','J67.9')
and b.AdmitDateTime <= a.SGLT2FillTime

select distinct scrssn from Dflt.Diabetes_AF_SGLT2_COPD --1755

/* Chronic Liver Disease */
/*Making sure the ICD9 and ICD10 codes relevant to CLD are present in the Dimension table under CDWWork*/

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('B18.0','B18.1','B18.2','I85.00','I85.01','I85.10','I85.11','K70.0','K70.30','K70.9','K73.0','K73.2','K73.8','K73.9',
													'K75.4','K74.0','K74.60','K74.69','K74.3','K74.4','K74.5','K74.1','K76.0','K76.89','K76.9','K76.6','K72.10','K72.90','Z94.4')

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('070.22','070.32','070.23','070.33','070.44','070.54','456.1','456.0','456.21','456.20','571.0','571.2','571.3',
												'571.41','571.49','571.40','571.42','571.5','571.9','571.6','571.8','572.3','572.8','V42.7')

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime as comorbidity_Dischargedatettime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_AF_SGLT2_LiverDisease

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('070.22','070.32','070.23','070.33','070.44','070.54','456.1','456.0','456.21','456.20','571.0','571.2','571.3',
					'571.41','571.49','571.40','571.42','571.5','571.9','571.6','571.8','572.3','572.8','V42.7')
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('070.22','070.32','070.23','070.33','070.44','070.54','456.1','456.0','456.21','456.20','571.0','571.2','571.3',
					'571.41','571.49','571.40','571.42','571.5','571.9','571.6','571.8','572.3','572.8','V42.7')
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('070.22','070.32','070.23','070.33','070.44','070.54','456.1','456.0','456.21','456.20','571.0','571.2','571.3',
					'571.41','571.49','571.40','571.42','571.5','571.9','571.6','571.8','572.3','572.8','V42.7')
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('070.22','070.32','070.23','070.33','070.44','070.54','456.1','456.0','456.21','456.20','571.0','571.2','571.3',
					'571.41','571.49','571.40','571.42','571.5','571.9','571.6','571.8','572.3','572.8','V42.7')
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('070.22','070.32','070.23','070.33','070.44','070.54','456.1','456.0','456.21','456.20','571.0','571.2','571.3',
					'571.41','571.49','571.40','571.42','571.5','571.9','571.6','571.8','572.3','572.8','V42.7')
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('070.22','070.32','070.23','070.33','070.44','070.54','456.1','456.0','456.21','456.20','571.0','571.2','571.3',
					'571.41','571.49','571.40','571.42','571.5','571.9','571.6','571.8','572.3','572.8','V42.7')
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('070.22','070.32','070.23','070.33','070.44','070.54','456.1','456.0','456.21','456.20','571.0','571.2','571.3',
					'571.41','571.49','571.40','571.42','571.5','571.9','571.6','571.8','572.3','572.8','V42.7')
					and b.PatientTransferDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('070.22','070.32','070.23','070.33','070.44','070.54','456.1','456.0','456.21','456.20','571.0','571.2','571.3',
					'571.41','571.49','571.40','571.42','571.5','571.9','571.6','571.8','572.3','572.8','V42.7')
					and b.SpecialtyTransferDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('070.22','070.32','070.23','070.33','070.44','070.54','456.1','456.0','456.21','456.20','571.0','571.2','571.3',
					'571.41','571.49','571.40','571.42','571.5','571.9','571.6','571.8','572.3','572.8','V42.7')
					and b.AdmitDateTime <= a.SGLT2FillTime
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('B18.0','B18.1','B18.2','I85.00','I85.01','I85.10','I85.11','K70.0','K70.30','K70.9','K73.0','K73.2','K73.8','K73.9',
					'K75.4','K74.0','K74.60','K74.69','K74.3','K74.4','K74.5','K74.1','K76.0','K76.89','K76.9','K76.6','K72.10','K72.90','Z94.4')
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('B18.0','B18.1','B18.2','I85.00','I85.01','I85.10','I85.11','K70.0','K70.30','K70.9','K73.0','K73.2','K73.8','K73.9',
					'K75.4','K74.0','K74.60','K74.69','K74.3','K74.4','K74.5','K74.1','K76.0','K76.89','K76.9','K76.6','K72.10','K72.90','Z94.4')
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('B18.0','B18.1','B18.2','I85.00','I85.01','I85.10','I85.11','K70.0','K70.30','K70.9','K73.0','K73.2','K73.8','K73.9',
					'K75.4','K74.0','K74.60','K74.69','K74.3','K74.4','K74.5','K74.1','K76.0','K76.89','K76.9','K76.6','K72.10','K72.90','Z94.4') 
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('B18.0','B18.1','B18.2','I85.00','I85.01','I85.10','I85.11','K70.0','K70.30','K70.9','K73.0','K73.2','K73.8','K73.9',
					'K75.4','K74.0','K74.60','K74.69','K74.3','K74.4','K74.5','K74.1','K76.0','K76.89','K76.9','K76.6','K72.10','K72.90','Z94.4')
and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('B18.0','B18.1','B18.2','I85.00','I85.01','I85.10','I85.11','K70.0','K70.30','K70.9','K73.0','K73.2','K73.8','K73.9',
					'K75.4','K74.0','K74.60','K74.69','K74.3','K74.4','K74.5','K74.1','K76.0','K76.89','K76.9','K76.6','K72.10','K72.90','Z94.4')
and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('B18.0','B18.1','B18.2','I85.00','I85.01','I85.10','I85.11','K70.0','K70.30','K70.9','K73.0','K73.2','K73.8','K73.9',
					'K75.4','K74.0','K74.60','K74.69','K74.3','K74.4','K74.5','K74.1','K76.0','K76.89','K76.9','K76.6','K72.10','K72.90','Z94.4')
and b.EventDateTime <= a.SGLT2FillTime

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('B18.0','B18.1','B18.2','I85.00','I85.01','I85.10','I85.11','K70.0','K70.30','K70.9','K73.0','K73.2','K73.8','K73.9',
					'K75.4','K74.0','K74.60','K74.69','K74.3','K74.4','K74.5','K74.1','K76.0','K76.89','K76.9','K76.6','K72.10','K72.90','Z94.4')
and b.PatientTransferDateTime <= a.SGLT2FillTime

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('B18.0','B18.1','B18.2','I85.00','I85.01','I85.10','I85.11','K70.0','K70.30','K70.9','K73.0','K73.2','K73.8','K73.9',
					'K75.4','K74.0','K74.60','K74.69','K74.3','K74.4','K74.5','K74.1','K76.0','K76.89','K76.9','K76.6','K72.10','K72.90','Z94.4')
and b.SpecialtyTransferDateTime <= a.SGLT2FillTime

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('B18.0','B18.1','B18.2','I85.00','I85.01','I85.10','I85.11','K70.0','K70.30','K70.9','K73.0','K73.2','K73.8','K73.9',
					'K75.4','K74.0','K74.60','K74.69','K74.3','K74.4','K74.5','K74.1','K76.0','K76.89','K76.9','K76.6','K72.10','K72.90','Z94.4')
and b.AdmitDateTime <= a.SGLT2FillTime

select distinct scrssn from Dflt.Diabetes_AF_SGLT2_LiverDisease --530

/* Heart Failure */
/* Making sure the codes are available in the CDWWork Dimension table */

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')-- 150.00 is not available

select distinct a.PatientSID,a.ScrSSN, a.AF_Dischargedatetime, b.DischargeDateTime as comorbidity_Dischargedatetime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_AF_SGLT2_HF

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')
					and b.DischargeDateTime <= a.SGLT2filltime
union all

select distinct a.PatientSID,a.ScrSSN, a.AF_Dischargedatetime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')
					and b.DischargeDateTime <= a.SGLT2filltime
union all

select distinct a.PatientSID,a.ScrSSN, a.AF_Dischargedatetime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')
					and b.DischargeDateTime <= a.SGLT2filltime
union all

select distinct a.PatientSID,a.ScrSSN, a.AF_Dischargedatetime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')
					and b.EventDateTime <= a.SGLT2filltime
union all

select distinct a.PatientSID,a.ScrSSN, a.AF_Dischargedatetime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')
					and b.EventDateTime <= a.SGLT2filltime
union all

select distinct a.PatientSID,a.ScrSSN, a.AF_Dischargedatetime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')
					and b.EventDateTime <= a.SGLT2filltime
union all

select distinct a.PatientSID,a.ScrSSN, a.AF_Dischargedatetime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')
					and b.PatientTransferDateTime <= a.SGLT2filltime
union all

select distinct a.PatientSID,a.ScrSSN, a.AF_Dischargedatetime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')
					and b.SpecialtyTransferDateTime <= a.SGLT2filltime
union all

select distinct a.PatientSID,a.ScrSSN, a.AF_Dischargedatetime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')
					and b.AdmitDateTime <= a.SGLT2filltime
union all

/*ICD10 Codes*/
select distinct a.PatientSID,a.ScrSSN, a.AF_Dischargedatetime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')
and b.DischargeDateTime <= a.SGLT2filltime
union all

select distinct a.PatientSID,a.ScrSSN, a.AF_Dischargedatetime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')
and b.DischargeDateTime <= a.SGLT2filltime
union all

select distinct a.PatientSID,a.ScrSSN, a.AF_Dischargedatetime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')
and b.DischargeDateTime <= a.SGLT2filltime
union all

select distinct a.PatientSID,a.ScrSSN, a.AF_Dischargedatetime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')
and b.EventDateTime <= a.SGLT2filltime
union all

select distinct a.PatientSID,a.ScrSSN, a.AF_Dischargedatetime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')
and b.EventDateTime <= a.SGLT2filltime
union all

select distinct a.PatientSID,a.ScrSSN, a.AF_Dischargedatetime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')
and b.EventDateTime <= a.SGLT2filltime

union all

select distinct a.PatientSID,a.ScrSSN, a.AF_Dischargedatetime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')
and b.PatientTransferDateTime <= a.SGLT2filltime

union all

select distinct a.PatientSID,a.ScrSSN, a.AF_Dischargedatetime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')
and b.SpecialtyTransferDateTime <= a.SGLT2filltime

union all

select distinct a.PatientSID,a.ScrSSN, a.AF_Dischargedatetime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')
and b.AdmitDateTime <= a.SGLT2filltime

select distinct scrssn from Dflt.Diabetes_AF_SGLT2_HF --3028

/* HBA1C */
/* Check for the labchemtestname in the dimension table */
select distinct labchemtestname from CDWWork.Dim.Labchemtest 
where LabChemTestName like '%A1C%' AND
	LabChemTestName not like '%ZZ%' AND
	LabChemTestName not like '%XX%'

/* Current VA phenomics library is updated and shows only %A1C% */

select b.*, a.LabChemResultValue, a.LabChemResultNumericValue, a.LabChemCompleteDateTime,c.LabChemTestName

into Dflt.Diabetes_AF_SGLT2_hba1c

from Src.Chem_LabChem as a with (NOLOCK) inner join
Dflt.Diabetes_AF_SGLT2 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
where c.LabChemTestName like '%A1C%' AND
	c.LabChemTestName not like '%ZZ%' AND
	c.LabChemTestName not like '%XX%'
and a.LabChemCompleteDateTime between dateadd(month, -6, b.SGLT2FillTime) and dateadd(day, 1, b.SGLT2FillTime)                                
union all

select b.*, a.LabChemResultValue, a.LabChemResultNumericValue,a.LabChemCompleteDateTime,c.LabChemTestName

from Src.Chem_LabChem_Recent as a with (NOLOCK) inner join
Dflt.Diabetes_AF_SGLT2 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
where c.LabChemTestName like '%A1C%' AND
	c.LabChemTestName not like '%ZZ%' AND
	c.LabChemTestName not like '%XX%'
and a.LabChemCompleteDateTime between dateadd(month, -6, b.SGLT2FillTime) and dateadd(day, 1, b.SGLT2FillTime)  
union all

select b.*, a.LabChemResultValue, a.LabChemResultNumericValue, a.LabChemCompleteDateTime, c.LabChemTestName

from Src.Chem_PatientLabChem as a with (NOLOCK) inner join
Dflt.Diabetes_AF_SGLT2 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
where c.LabChemTestName like '%A1C%' AND
	c.LabChemTestName not like '%ZZ%' AND
	c.LabChemTestName not like '%XX%'
and a.LabChemCompleteDateTime between dateadd(month, -6, SGLT2FillTime) and dateadd(day, 1, SGLT2FillTime)

select distinct scrssn from Dflt.Diabetes_AF_SGLT2_hba1c --3076
select * from Dflt.Diabetes_AF_sglt2_hba1c

/* Creatinine */
/* Check for the labchemtestname in the dimension table */
select distinct labchemtestname from CDWWork.Dim.Labchemtest 
WHERE LabChemTestName like '%Creat%' 
	--and	LabChemTestName not like '%ZZ%'  -- removed in latest update 14 June 2021 
	and LabChemTestName not like '%ratio%'
	and LabChemTestName not like '%DO NOT USE%'
	--and LabChemTestName not like 'XX%' -- removed in latest update 14 June 2021
	and LabChemTestName not in ('Beryllium (Creatinine Corrected)', 'ERROR IN CREATION', 'PANCREATIC AMYLASE(q',
'PANCREATIC ELASTASE 1','PANCREATIC ELASTASE-1 STOOL','PANCREATIC ELASTASE-1(Q)',
'PANCREATIC ELASTASE-1,STOOL (QU)','PANCREATIC ELASTASE1',
'Pancreatic Fraction','PANCREATIC ISOAMYLASE (PRE-',
'PANCREATIC POLYPEPTIDE','PANCREATIC POLYPEPTIDE  (before 9/22/98)',
'PANCREATIC POLYPEPTIDE (QU)','PANCREATIC POLYPEPTIDE(QU)(bef.4/26/04)',
'PANCREATIC POLYPEPTIDE~prior to 4/26/04','PANCREATITIS PANEL NGS(PG)', 'THALLIUM (ug/g Creat)')

select distinct b.PatientSID, b.ScrSSN, b.SGLT2Filltime, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

into #tempCreatinine

from Src.Chem_LabChem as a with (NOLOCK) inner join
Dflt.Diabetes_AF_SGLT2 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE LabChemTestName like '%Creat%' 
	--and	LabChemTestName not like '%ZZ%'  
	and LabChemTestName not like '%ratio%'
	and LabChemTestName not like '%DO NOT USE%'
	--and LabChemTestName not like 'XX%'
	and LabChemTestName not in ('Beryllium (Creatinine Corrected)', 'ERROR IN CREATION', 'PANCREATIC AMYLASE(q',
'PANCREATIC ELASTASE 1','PANCREATIC ELASTASE-1 STOOL','PANCREATIC ELASTASE-1(Q)',
'PANCREATIC ELASTASE-1,STOOL (QU)','PANCREATIC ELASTASE1',
'Pancreatic Fraction','PANCREATIC ISOAMYLASE (PRE-',
'PANCREATIC POLYPEPTIDE','PANCREATIC POLYPEPTIDE  (before 9/22/98)',
'PANCREATIC POLYPEPTIDE (QU)','PANCREATIC POLYPEPTIDE(QU)(bef.4/26/04)',
'PANCREATIC POLYPEPTIDE~prior to 4/26/04','PANCREATITIS PANEL NGS(PG)', 'THALLIUM (ug/g Creat)')

union all

select distinct b.PatientSID, b.ScrSSN, b.SGLT2Filltime, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

from Src.Chem_LabChem_Recent as a with (NOLOCK) inner join
Dflt.Diabetes_AF_SGLT2 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE LabChemTestName like '%Creat%' 
	--and	LabChemTestName not like '%ZZ%'  
	and LabChemTestName not like '%ratio%'
	and LabChemTestName not like '%DO NOT USE%'
	--and LabChemTestName not like 'XX%'
	and LabChemTestName not in ('Beryllium (Creatinine Corrected)', 'ERROR IN CREATION', 'PANCREATIC AMYLASE(q',
'PANCREATIC ELASTASE 1','PANCREATIC ELASTASE-1 STOOL','PANCREATIC ELASTASE-1(Q)',
'PANCREATIC ELASTASE-1,STOOL (QU)','PANCREATIC ELASTASE1',
'Pancreatic Fraction','PANCREATIC ISOAMYLASE (PRE-',
'PANCREATIC POLYPEPTIDE','PANCREATIC POLYPEPTIDE  (before 9/22/98)',
'PANCREATIC POLYPEPTIDE (QU)','PANCREATIC POLYPEPTIDE(QU)(bef.4/26/04)',
'PANCREATIC POLYPEPTIDE~prior to 4/26/04','PANCREATITIS PANEL NGS(PG)', 'THALLIUM (ug/g Creat)')

union all

select distinct b.PatientSID, b.ScrSSN, b.SGLT2Filltime, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

from Src.Chem_PatientLabChem as a with (NOLOCK) inner join
Dflt.Diabetes_AF_SGLT2 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE LabChemTestName like '%Creat%' 
	--and	LabChemTestName not like '%ZZ%'  
	and LabChemTestName not like '%ratio%'
	and LabChemTestName not like '%DO NOT USE%'
	--and LabChemTestName not like 'XX%'
	and LabChemTestName not in ('Beryllium (Creatinine Corrected)', 'ERROR IN CREATION', 'PANCREATIC AMYLASE(q',
'PANCREATIC ELASTASE 1','PANCREATIC ELASTASE-1 STOOL','PANCREATIC ELASTASE-1(Q)',
'PANCREATIC ELASTASE-1,STOOL (QU)','PANCREATIC ELASTASE1',
'Pancreatic Fraction','PANCREATIC ISOAMYLASE (PRE-',
'PANCREATIC POLYPEPTIDE','PANCREATIC POLYPEPTIDE  (before 9/22/98)',
'PANCREATIC POLYPEPTIDE (QU)','PANCREATIC POLYPEPTIDE(QU)(bef.4/26/04)',
'PANCREATIC POLYPEPTIDE~prior to 4/26/04','PANCREATITIS PANEL NGS(PG)', 'THALLIUM (ug/g Creat)')

select *
into Dflt.Diabetes_AF_SGLT2_Creatinine
from #tempCreatinine
where LabChemCompleteDateTime between dateadd(month, -6, SGLT2FillTime) and dateadd(day, 1, SGLT2FillTime)

select distinct scrssn from Dflt.Diabetes_AF_SGLT2_Creatinine --3612
select * from Dflt.Diabetes_AF_SGLT2_Creatinine

/* Hemoglobin */
/* Check for the labchemtestname in the dimension table */
select distinct labchemtestname from CDWWork.Dim.Labchemtest 
WHERE 
   (labchemtestname like '%hemoglob%' or 
    labchemtestname like '%HB%' or 
	LabChemTestName like '%HGB%') and
	labchemtestname not like 'z%' AND
	labchemtestname not like 'x%' AND
	LabChemTestName not like '%ratio%' AND 
	LabChemTestName not like '%HBV%' AND
	LabChemTestName not like '%Anti-HB%' AND 
	LabChemTestName not like '%Hepatitis%' AND
	LabChemTestName not like '%ELECTROPHORESIS%' AND
	LabChemTestName not like '%HBSAG%' AND
	LabChemTestName not like '%HC1 ESTERASE%' AND
	LabChemTestName not like '%Testoster%' AND
	LabChemTestName not like '%SDHB%' AND
	LabChemTestName not like '%HBsAb%' AND
	LabChemTestName not like '%GHB%' AND
	LabChemTestName NOT LIKE '%A1C%'
	AND LabChemTestName NOT LIKE '%CELL%'
	AND LabChemTestName not like '%RATE%'
	AND LabChemTestName not like '%/100wbc%'
	AND LabChemTestName not like '%sperm%'
	AND LabChemTestName not like '%HBV%'
	AND LabChemTestName not like '%hbc%'
	AND LabChemTestName not like '%hiv%'
	AND LabChemTestName not like '%anti%'
	AND LabChemTestName not like '%hep%'
	AND LabChemTestName not like '%butyl%'
	AND LabChemTestName not like '%VITROS%'
	AND LabChemTestName not like '%hormone%'
	AND LabChemTestName not like '%hbs%'

select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

into #tempHemoglobin

from Src.Chem_LabChem as a with (NOLOCK) inner join
Dflt.Diabetes_AF_SGLT2 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE 
   (labchemtestname like '%hemoglob%' or 
    labchemtestname like '%HB%' or 
	LabChemTestName like '%HGB%') and
	labchemtestname not like 'z%' AND
	labchemtestname not like 'x%' AND
	LabChemTestName not like '%ratio%' AND 
	LabChemTestName not like '%HBV%' AND
	LabChemTestName not like '%Anti-HB%' AND 
	LabChemTestName not like '%Hepatitis%' AND
	LabChemTestName not like '%ELECTROPHORESIS%' AND
	LabChemTestName not like '%HBSAG%' AND
	LabChemTestName not like '%HC1 ESTERASE%' AND
	LabChemTestName not like '%Testoster%' AND
	LabChemTestName not like '%SDHB%' AND
	LabChemTestName not like '%HBsAb%' AND
	LabChemTestName not like '%GHB%' AND
	LabChemTestName NOT LIKE '%A1C%'
	AND LabChemTestName NOT LIKE '%CELL%'
	AND LabChemTestName not like '%RATE%'
	AND LabChemTestName not like '%/100wbc%'
	AND LabChemTestName not like '%sperm%'
	AND LabChemTestName not like '%HBV%'
	AND LabChemTestName not like '%hbc%'
	AND LabChemTestName not like '%hiv%'
	AND LabChemTestName not like '%anti%'
	AND LabChemTestName not like '%hep%'
	AND LabChemTestName not like '%butyl%'
	AND LabChemTestName not like '%VITROS%'
	AND LabChemTestName not like '%hormone%'
	AND LabChemTestName not like '%hbs%'

union all

select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

from Src.Chem_LabChem_Recent as a with (NOLOCK) inner join
Dflt.Diabetes_AF_SGLT2 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE 
   (labchemtestname like '%hemoglob%' or 
    labchemtestname like '%HB%' or 
	LabChemTestName like '%HGB%') and
	labchemtestname not like 'z%' AND
	labchemtestname not like 'x%' AND
	LabChemTestName not like '%ratio%' AND 
	LabChemTestName not like '%HBV%' AND
	LabChemTestName not like '%Anti-HB%' AND 
	LabChemTestName not like '%Hepatitis%' AND
	LabChemTestName not like '%ELECTROPHORESIS%' AND
	LabChemTestName not like '%HBSAG%' AND
	LabChemTestName not like '%HC1 ESTERASE%' AND
	LabChemTestName not like '%Testoster%' AND
	LabChemTestName not like '%SDHB%' AND
	LabChemTestName not like '%HBsAb%' AND
	LabChemTestName not like '%GHB%' AND
	LabChemTestName NOT LIKE '%A1C%'
	AND LabChemTestName NOT LIKE '%CELL%'
	AND LabChemTestName not like '%RATE%'
	AND LabChemTestName not like '%/100wbc%'
	AND LabChemTestName not like '%sperm%'
	AND LabChemTestName not like '%HBV%'
	AND LabChemTestName not like '%hbc%'
	AND LabChemTestName not like '%hiv%'
	AND LabChemTestName not like '%anti%'
	AND LabChemTestName not like '%hep%'
	AND LabChemTestName not like '%butyl%'
	AND LabChemTestName not like '%VITROS%'
	AND LabChemTestName not like '%hormone%'
	AND LabChemTestName not like '%hbs%'

union all

select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

from Src.Chem_PatientLabChem as a with (NOLOCK) inner join
Dflt.Diabetes_AF_SGLT2 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE 
   (labchemtestname like '%hemoglob%' or 
    labchemtestname like '%HB%' or 
	LabChemTestName like '%HGB%') and
	labchemtestname not like 'z%' AND
	labchemtestname not like 'x%' AND
	LabChemTestName not like '%ratio%' AND 
	LabChemTestName not like '%HBV%' AND
	LabChemTestName not like '%Anti-HB%' AND 
	LabChemTestName not like '%Hepatitis%' AND
	LabChemTestName not like '%ELECTROPHORESIS%' AND
	LabChemTestName not like '%HBSAG%' AND
	LabChemTestName not like '%HC1 ESTERASE%' AND
	LabChemTestName not like '%Testoster%' AND
	LabChemTestName not like '%SDHB%' AND
	LabChemTestName not like '%HBsAb%' AND
	LabChemTestName not like '%GHB%' AND
	LabChemTestName NOT LIKE '%A1C%'
	AND LabChemTestName NOT LIKE '%CELL%'
	AND LabChemTestName not like '%RATE%'
	AND LabChemTestName not like '%/100wbc%'
	AND LabChemTestName not like '%sperm%'
	AND LabChemTestName not like '%HBV%'
	AND LabChemTestName not like '%hbc%'
	AND LabChemTestName not like '%hiv%'
	AND LabChemTestName not like '%anti%'
	AND LabChemTestName not like '%hep%'
	AND LabChemTestName not like '%butyl%'
	AND LabChemTestName not like '%VITROS%'
	AND LabChemTestName not like '%hormone%'
	AND LabChemTestName not like '%hbs%'

select *
into Dflt.Diabetes_AF_SGLT2_Hemoglobin
from #temphemoglobin
where LabChemCompleteDateTime between dateadd(month, -6, SGLT2FillTime) and dateadd(day, 1, SGLT2FillTime)

select distinct scrssn from Dflt.Diabetes_AF_SGLT2_Hemoglobin --3468
select * from Dflt.Diabetes_AF_SGLT2_Hemoglobin

/* Brain Natriuretic Peptide (BNP)*/
/* Check for the labchemtestname in the dimension table */
select distinct labchemtestname from CDWWork.Dim.Labchemtest 
WHERE 
   (labchemtestname like '%BNP%' or  
	labchemtestname  like '%brain natriuretic peptide%' or 
	labchemtestname  like '%natriu%pept%') and
	LabChemTestName not like '%ratio%' AND
	LabChemTestName not like '%pro%'

select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

into #tempBNP

from Src.Chem_LabChem as a with (NOLOCK) inner join
Dflt.Diabetes_AF_SGLT2 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE 
   (labchemtestname like '%BNP%' or  
	labchemtestname  like '%brain natriuretic peptide%' or 
	labchemtestname  like '%natriu%pept%') and
	LabChemTestName not like '%ratio%' AND
	LabChemTestName not like '%pro%'

union all

select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

from Src.Chem_LabChem_Recent as a with (NOLOCK) inner join
Dflt.Diabetes_AF_SGLT2 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE 
   (labchemtestname like '%BNP%' or  
	labchemtestname  like '%brain natriuretic peptide%' or 
	labchemtestname  like '%natriu%pept%') and
	LabChemTestName not like '%ratio%' AND
	LabChemTestName not like '%pro%'

union all

select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

from Src.Chem_PatientLabChem as a with (NOLOCK) inner join
Dflt.Diabetes_AF_SGLT2 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE 
   (labchemtestname like '%BNP%' or  
	labchemtestname  like '%brain natriuretic peptide%' or 
	labchemtestname  like '%natriu%pept%') and
	LabChemTestName not like '%ratio%' AND
	LabChemTestName not like '%pro%'
	
select *
into Dflt.Diabetes_AF_SGLT2_BNP
from #tempBNP
where LabChemCompleteDateTime between dateadd(month, -6, SGLT2FillTime) and dateadd(day, 1, SGLT2FillTime)

select distinct scrssn from Dflt.Diabetes_AF_SGLT2_BNP --1485
select * from Dflt.Diabetes_AF_SGLT2_BNP

/* Pro Brain Natriuretic Peptide (PBNP)*/
/* Check for the labchemtestname in the dimension table */
select distinct labchemtestname from CDWWork.Dim.Labchemtest 
WHERE 
   (labchemtestname like '%BNP%' or 
    labchemtestname like '%terminal%pep%' or
	labchemtestname  like '%proBNP%' or 
	labchemtestname  like '%pro[- /_]BNP%' or 
	labchemtestname  like '%pro brain natriuretic peptide%' or 
	labchemtestname  like '%natriu%pept%') and
	LabChemTestName not like '%ratio%'

select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

into #tempPBNP

from Src.Chem_LabChem as a with (NOLOCK) inner join
Dflt.Diabetes_AF_SGLT2 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE 
   (labchemtestname like '%BNP%' or 
    labchemtestname like '%terminal%pep%' or
	labchemtestname  like '%proBNP%' or 
	labchemtestname  like '%pro[- /_]BNP%' or 
	labchemtestname  like '%pro brain natriuretic peptide%' or 
	labchemtestname  like '%natriu%pept%') and
	LabChemTestName not like '%ratio%'
union all

select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

from Src.Chem_LabChem_Recent as a with (NOLOCK) inner join
Dflt.Diabetes_AF_SGLT2 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE 
   (labchemtestname like '%BNP%' or 
    labchemtestname like '%terminal%pep%' or
	labchemtestname  like '%proBNP%' or 
	labchemtestname  like '%pro[- /_]BNP%' or 
	labchemtestname  like '%pro brain natriuretic peptide%' or 
	labchemtestname  like '%natriu%pept%') and
	LabChemTestName not like '%ratio%'

union all

select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

from Src.Chem_PatientLabChem as a with (NOLOCK) inner join
Dflt.Diabetes_AF_SGLT2 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE 
   (labchemtestname like '%BNP%' or 
    labchemtestname like '%terminal%pep%' or
	labchemtestname  like '%proBNP%' or 
	labchemtestname  like '%pro[- /_]BNP%' or 
	labchemtestname  like '%pro brain natriuretic peptide%' or 
	labchemtestname  like '%natriu%pept%') and
	LabChemTestName not like '%ratio%'

select *
into Dflt.Diabetes_AF_SGLT2_PBNP
from #tempPBNP
where LabChemCompleteDateTime between dateadd(month, -6, SGLT2FillTime) and dateadd(day, 1, SGLT2FillTime)

select distinct scrssn from Dflt.Diabetes_AF_SGLT2_PBNP --2002
select * from Dflt.Diabetes_AF_SGLT2_PBNP

/* prior HF Hospitalization using dishcarge diagnosis table only */

select distinct a.*, b.AdmitDateTime

into Dflt.AF_SGLT2_priorHFHospi

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_Inpatient as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.PrincipalDiagnosisICD9SID=c.ICD9SID 
where c.ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')
					and b.AdmitDateTime between dateadd(year, -10, a.SGLT2FillTime) and a.SGLT2FillTime

union all

select distinct a.*, b.AdmitDateTime

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_Inpatient_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.PrincipalDiagnosisICD10SID=c.ICD10SID 
where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')
and b.AdmitDateTime between dateadd(year, -10, a.SGLT2FillTime) and a.SGLT2FillTime

select distinct scrssn from Dflt.AF_SGLT2_priorHFHospi --938


/* Before EF value */

select distinct a.*, b.Low_Value, b.ValueDateTime

into Dflt.Diabetes_AF_SGLT2_EFBefore

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join 
Src.VINCI_TIU_NLP_LVEF as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where b.ValueDateTime <=a.SGLT2filltime --between dateadd(month, -12, a.SGLT2FillTime) and a.SGLT2filltime

select distinct scrssn from Dflt.Diabetes_AF_SGLT2_EFBefore --3674

/* After EF value */

select distinct a.*, b.Low_Value, b.ValueDateTime

into Dflt.Diabetes_AF_SGLT2_EFAfter

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join 
Src.VINCI_TIU_NLP_LVEF as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where b.ValueDateTime > a.SGLT2filltime --between dateadd(month, -12, a.SGLT2FillTime) and a.SGLT2filltime

select distinct scrssn from Dflt.Diabetes_AF_SGLT2_EFAfter --3446

/* Other Medications */
select distinct a.PatientSID, a.ScrSSN, a.SGLT2FillTime, b.FillDateTime, b.LocalDrugNameWithDose, b.FillNumber, b.DaysSupply, b.Qty

into #tempMedications

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where b.FillDateTime between dateadd(month, -6, a.SGLT2FillTime) and a.SGLT2FillTime and 
b.FillNumber > '1'
union all

select distinct a.PatientSID, a.ScrSSN, a.SGLT2FillTime, b.FillDateTime, b.LocalDrugNameWithDose, b.FillNumber, b.DaysSupply, b.Qty

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where b.FillDateTime between dateadd(month, -6, a.SGLT2FillTime) and a.SGLT2FillTime and 
b.FillNumber > '1'

/* Beta Blockers */
/* Check for the LocalDrugNameWithDose in the dimension table */
select * from CDWWork.Dim.LocalDrug where LocalDrugNameWithDose like '%metoprolol%' or LocalDrugNameWithDose like '%carvedilol%' or LocalDrugNameWithDose like '%bisoprolol%' or
		LocalDrugNameWithDose like '%nebivolol%' or LocalDrugNameWithDose like '%atenolol%'

select distinct *

into Dflt.Diabetes_AF_SGLT2_BB

from #tempMedications where LocalDrugNameWithDose like '%metoprolol%' or LocalDrugNameWithDose like '%carvedilol%' or LocalDrugNameWithDose like '%bisoprolol%' or
		LocalDrugNameWithDose like '%nebivolol%' or LocalDrugNameWithDose like '%atenolol%'

select distinct scrssn from Dflt.Diabetes_AF_SGLT2_BB --1542

/* ACE Inhibitor */
/* Check for the LocalDrugNameWithDose in the dimension table */
select * from CDWWork.Dim.LocalDrug where LocalDrugNameWithDose like '%lisinopril%' or LocalDrugNameWithDose like '%Fosinopril%' or LocalDrugNameWithDose like '%ramipril%' or
		LocalDrugNameWithDose like '%quinapril%' or LocalDrugNameWithDose like '%benazepril%'

select distinct *

into Dflt.Diabetes_AF_SGLT2_ACE

from #tempMedications where LocalDrugNameWithDose like '%lisinopril%' or LocalDrugNameWithDose like '%Fosinopril%' or LocalDrugNameWithDose like '%ramipril%' or
		LocalDrugNameWithDose like '%quinapril%' or LocalDrugNameWithDose like '%benazepril%'

select distinct scrssn from Dflt.Diabetes_AF_SGLT2_ACE --652

/*ARB Inhibitor */
/* Check for the LocalDrugNameWithDose in the dimension table */
select * from CDWWork.Dim.LocalDrug where LocalDrugNameWithDose like '%valsartan%' or LocalDrugNameWithDose like '%losartan%' or LocalDrugNameWithDose like '%candesartan%' or
		LocalDrugNameWithDose like '%Olmesartan%' or LocalDrugNameWithDose like '%telmisartan%' or LocalDrugNameWithDose like '%irbesartan%' 

select distinct *

into Dflt.Diabetes_AF_SGLT2_ARB

from #tempMedications where LocalDrugNameWithDose like '%valsartan%' or LocalDrugNameWithDose like '%losartan%' or LocalDrugNameWithDose like '%candesartan%' or
		LocalDrugNameWithDose like '%Olmesartan%' or LocalDrugNameWithDose like '%telmisartan%' or LocalDrugNameWithDose like '%irbesartan%' 

select distinct scrssn from Dflt.Diabetes_AF_SGLT2_ARB --684

/* ACE and ARB */

select distinct * 

into Dflt.Diabetes_AF_SGLT2_ACEARB

from Dflt.Diabetes_AF_SGLT2_ACE
union all

select distinct *

from Dflt.Diabetes_AF_SGLT2_ARB

select distinct scrssn from Dflt.Diabetes_AF_SGLT2_ACEARB --1330

/* Spironolactone/Eplerenone */
/* Check for the LocalDrugNameWithDose in the dimension table */
select * from CDWWork.Dim.LocalDrug where LocalDrugNameWithDose like '%spironolactone%' or LocalDrugNameWithDose like '%Eplerenone%'

select distinct *

into Dflt.Diabetes_AF_SGLT2_SpiroEp

from #tempMedications where LocalDrugNameWithDose like '%spironolactone%' or LocalDrugNameWithDose like '%Eplerenone%'

select distinct scrssn from Dflt.Diabetes_AF_SGLT2_SpiroEp --456

/* Loop Diuretic */
/* Check for the LocalDrugNameWithDose in the dimension table */
select * from CDWWork.Dim.LocalDrug where LocalDrugNameWithDose like '%furosemide%' or LocalDrugNameWithDose like '%torsemide%' or LocalDrugNameWithDose like '%bumetanide%' or
		LocalDrugNameWithDose like '%Ethacrynic acid%' or LocalDrugNameWithDose like '%lasix%' or LocalDrugNameWithDose like '%bumex%'

select distinct a.PatientSID, a.ScrSSN, a.SGLT2FillTime, b.FillDateTime, b.LocalDrugNameWithDose, b.FillNumber, b.DaysSupply, b.Qty

into #tempMedicationsLoop

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill as b with (NOLOCK) on a.PatientSID= b.PatientSID
where LocalDrugNameWithDose like '%furosemide%' or LocalDrugNameWithDose like '%torsemide%' or LocalDrugNameWithDose like '%bumetanide%' or
		LocalDrugNameWithDose like '%Ethacrynic acid%' or LocalDrugNameWithDose like '%lasix%' or LocalDrugNameWithDose like '%bumex%'
--where b.FillDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(month, 12, a.SGLT2FillTime) and b.FillNumber > '1'
union all

select distinct a.PatientSID, a.ScrSSN, a.SGLT2FillTime, b.FillDateTime, b.LocalDrugNameWithDose, b.FillNumber, b.DaysSupply, b.Qty

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where LocalDrugNameWithDose like '%furosemide%' or LocalDrugNameWithDose like '%torsemide%' or LocalDrugNameWithDose like '%bumetanide%' or
		LocalDrugNameWithDose like '%Ethacrynic acid%' or LocalDrugNameWithDose like '%lasix%' or LocalDrugNameWithDose like '%bumex%'
--where b.FillDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(month, 12, a.SGLT2FillTime) and b.FillNumber > '1'

select distinct *

into Dflt.Diabetes_AF_SGLT2_LoopDiuretic

from #tempMedicationsloop 

where FillDateTime between dateadd(month, -12, SGLT2FillTime) and dateadd(month, 12, SGLT2FillTime) and FillNumber > '1'

select distinct scrssn from Dflt.Diabetes_AF_SGLT2_LoopDiuretic --2196

/* Insulin */
/* Check for the LocalDrugNameWithDose in the dimension table */
select * from CDWWork.Dim.LocalDrug where LocalDrugNameWithDose like '%insulin%' 

select distinct *

into Dflt.Diabetes_AF_SGLT2_Insulin

from #tempMedications where LocalDrugNameWithDose like '%insulin%' 

select distinct scrssn from Dflt.Diabetes_AF_SGLT2_Insulin --1129

/* Sacubitril and Valsartan */

select distinct * 

into Dflt.Diabetes_AF_SGLT2_SacuVal

from #tempMedications
where LocalDrugNameWithDose like '%sacubitril%' and LocalDrugNameWithDose like '%valsartan%' 

Select distinct scrssn from Dflt.Diabetes_AF_SGLT2_SacuVal --212

/* GLP1 Analogue */

select distinct LocalDrugNameWithDose from CDWWork.Dim.LocalDrug where LocalDrugNameWithDose like '%semaglutide%' 
or LocalDrugNameWithDose like '%exenatide%' 
or LocalDrugNameWithDose like '%liraglutide%' 
or LocalDrugNameWithDose like '%lixisenatide%' 
or LocalDrugNameWithDose like '%dulaglutide%'

select distinct *

into Dflt.Diabetes_AF_SGLT2_GLP1

from #tempMedications where LocalDrugNameWithDose like '%semaglutide%' 
or LocalDrugNameWithDose like '%exenatide%' 
or LocalDrugNameWithDose like '%liraglutide%' 
or LocalDrugNameWithDose like '%lixisenatide%' 
or LocalDrugNameWithDose like '%dulaglutide%'

select distinct scrssn from Dflt.Diabetes_AF_SGLT2_GLP1 --261

/* DPP4 I */

select distinct LocalDrugNameWithDose from CDWWork.Dim.LocalDrug where LocalDrugNameWithDose like '%gliptin%'

select distinct *

into Dflt.Diabetes_AF_SGLT2_DPP4

from #tempMedications where LocalDrugNameWithDose like '%gliptin%'

drop table  Dflt.Diabetes_AF_SGLT2_DPP4 --0

/* Metformin */

select * from CDWWork.Dim.LocalDrug where LocalDrugNameWithDose like '%metformin%' 

select distinct *

into Dflt.Diabetes_AF_SGLT2_Metformin

from #tempMedications where LocalDrugNameWithDose like '%metformin%' 

select distinct scrssn from Dflt.Diabetes_AF_SGLT2_Metformin --853

/* Sulfonylurea */
select distinct LocalDrugNameWithDose from CDWWork.Dim.LocalDrug where LocalDrugNameWithDose like '%Glipizide%' or
			  LocalDrugNameWithDose like '%Glimepiride%' or
			  LocalDrugNameWithDose like '%Glyburide%' or
			  LocalDrugNameWithDose like '%Tolbutamide%' 

select distinct *

into Dflt.Diabetes_AF_SGLT2_Sulfonylurea

from #tempMedications where LocalDrugNameWithDose like '%Glipizide%' or
			  LocalDrugNameWithDose like '%Glimepiride%' or
			  LocalDrugNameWithDose like '%Glyburide%' or
			  LocalDrugNameWithDose like '%Tolbutamide%' 

select distinct scrssn from Dflt.Diabetes_AF_SGLT2_Sulfonylurea --0

/* Thiazoldiandione- check */

select distinct LocalDrugNameWithDose from CDWWork.Dim.LocalDrug where LocalDrugNameWithDose like '%pioglitazone%' 
or LocalDrugNameWithDose like '%rosiglitazone%'

select distinct *

into Dflt.Diabetes_AF_SGLT2_Thiazol

from #tempMedications where LocalDrugNameWithDose like '%pioglitazone%' 
or LocalDrugNameWithDose like '%rosiglitazone%'

select distinct scrssn from Dflt.Diabetes_AF_SGLT2_Thiazol --23

/* Anti-Arrythmia Drugs */

select distinct LocalDrugNameWithDose from CDWWork.Dim.LocalDrug where LocalDrugNameWithDose like '%soltalol%' 
or LocalDrugNameWithDose like '%Dofetilide%' 
or LocalDrugNameWithDose like '%flecainide%' 
or LocalDrugNameWithDose like '%propafenone%' 
or LocalDrugNameWithDose like '%amiodarone%' 
or LocalDrugNameWithDose like '%dronaderone%'
or LocalDrugNameWithDose like '%digoxin%'

select distinct *

into Dflt.Diabetes_AF_SGLT2_AntiArr

from #tempMedications where LocalDrugNameWithDose like '%soltalol%' 
or LocalDrugNameWithDose like '%Dofetilide%' 
or LocalDrugNameWithDose like '%flecainide%' 
or LocalDrugNameWithDose like '%propafenone%' 
or LocalDrugNameWithDose like '%amiodarone%' 
or LocalDrugNameWithDose like '%dronaderone%'
or LocalDrugNameWithDose like '%digoxin%'

select distinct scrssn from Dflt.Diabetes_AF_SGLT2_AntiArr --665

//** After the drug initiation - Extraction **//

/* All HF hospitalization after SGLT2 initiation */

select distinct a.PatientSID,a.ScrSSN,  a.SGLT2FillTime, b.AdmitDateTime, b.Admitdiagnosis, c.ICD9Code

into Dflt.AF_SGLT2_HFHospitalization

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_Inpatient as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.PrincipalDiagnosisICD9SID=c.ICD9SID 
where c.ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')
					and b.DischargeDateTime >= a.SGLT2FillTime
union all

/*ICD10 Codes*/

select distinct a.PatientSID,a.ScrSSN,  a.SGLT2FillTime, b.AdmitDateTime, b.AdmitDiagnosis, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_Inpatient as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.PrincipalDiagnosisICD10SID=c.ICD10SID 
where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')
and b.DischargeDateTime >= a.SGLT2FillTime

select distinct scrssn from Dflt.AF_SGLT2_HFHospitalization --1065

select * from Dflt.AF_SGLT2_HFHospitalization

/* Atrial Fibrillation */

select distinct a.PatientSID,a.ScrSSN,  a.SGLT2FillTime, b.AdmitDateTime, b.DischargeDateTime ,b.Admitdiagnosis, c.ICD9Code

into Dflt.Diabetes_AF_SGLT2_AFAfter

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_Inpatient as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.PrincipalDiagnosisICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
					and b.DischargeDateTime >= a.SGLT2FillTime
union all

/*ICD10 Codes*/

select distinct a.PatientSID,a.ScrSSN,  a.SGLT2FillTime, b.AdmitDateTime, b.DischargeDateTime, b.AdmitDiagnosis, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_Inpatient as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.PrincipalDiagnosisICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.DischargeDateTime >= a.SGLT2FillTime

select distinct scrssn from Dflt.Diabetes_AF_SGLT2_AFAfter --509

/* All hospitalization after SGLT2 initiation */

select distinct a.*, b.DischargeDateTime,c.ICD9Code
/*ICD9 Codes*/

into Dflt.AF_SGLT2_AllHospitalization

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where b.DischargeDateTime >= a.SGLT2FillTime
union all

select distinct a.*, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where b.DischargeDateTime >= a.SGLT2FillTime
union all

select distinct a.*, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where b.DischargeDateTime >= a.SGLT2FillTime
union all

select distinct a.*, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where b.PatientTransferDateTime >= a.SGLT2FillTime
union all

select distinct a.*, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where b.SpecialtyTransferDateTime >= a.SGLT2FillTime
union all

select distinct a.*, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where b.AdmitDateTime >= a.SGLT2FillTime
union all

/*ICD10 Codes*/
select distinct a.*, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where  b.DischargeDateTime >= a.SGLT2FillTime
union all

select distinct a.*, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where b.DischargeDateTime >= a.SGLT2FillTime
union all

select distinct a.*, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where b.DischargeDateTime >= a.SGLT2FillTime
union all

select distinct a.*, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where b.PatientTransferDateTime >= a.SGLT2FillTime

union all

select distinct a.*, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where b.SpecialtyTransferDateTime >= a.SGLT2FillTime
union all

select distinct a.*, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where  b.AdmitDateTime >= a.SGLT2FillTime

select distinct scrssn from Dflt.AF_SGLT2_AllHospitalization --2694

/* Use only Discharge diagnosis table to identify all hospitalization events - SGLT2 */

select distinct a.*, b.AdmitDateTime,c.ICD9Code

into Dflt.AF_SGLT2_AllDDHospi

/*ICD9 Code */

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where b.AdmitDateTime >= a.SGLT2FillTime

union all
/*ICD10 Code */

select distinct a.*, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where b.AdmitDateTime >= a.SGLT2FillTime

select distinct scrssn from Dflt.AF_SGLT2_AllDDHospi --2217

/* Patients that started on DPP4 after SGLT2 initiation */

select distinct a.*, b.FillNumber as DPP4FillNumber

into Dflt.AF_SGLT2DPP4

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where b.LocalDrugNameWithDose like '%gliptin%' 
and b.FillDateTime >= a.SGLT2FillTime and b.FillNumber >=3
union all

select distinct a.*, b.FillNumber as DPP4FillNumber

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where b.LocalDrugNameWithDose like '%gliptin%' 
and b.FillDateTime >= a.SGLT2FillTime and b.FillNumber >=3

select distinct scrssn from Dflt.AF_SGLT2DPP4 --58

/* Patients that started on SGLT2 after DPP4 initiation */

select distinct a.*, b.FillNumber as SGLT2FillNumber

into #DPP4SGLT2

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where LocalDrugNameWithDose like '%empagliflozin%' 
or LocalDrugNameWithDose like '%dapagliflozin%' 
or LocalDrugNameWithDose like '%canagliflozin%' 
or LocalDrugNameWithDose like '%ertugliflozin%' 
--and b.FillDateTime >= a.DPP4FillTime
union all

select distinct a.*, b.FillNumber as SGLT2FillNumber

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where LocalDrugNameWithDose like '%empagliflozin%' 
or LocalDrugNameWithDose like '%dapagliflozin%' 
or LocalDrugNameWithDose like '%canagliflozin%' 
or LocalDrugNameWithDose like '%ertugliflozin%'
--and b.FillDateTime >= a.DPP4FillTime

select distinct *
into Dflt.AF_DPP4_SGLT2
from #DPP4SGLT2 where 
FillDateTime >= DPP4FillTime
and SGLT2FillNumber >=3

select distinct scrssn from Dflt.AF_DPP4_SGLT2 --258

/* GLP1 after initiation of SGLT2 - refill at least 3 */

select distinct a.*, b.FillNumber as GLP1FillNumber

into #SGLT2GLP1

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where LocalDrugNameWithDose like '%semaglutide%' 
or LocalDrugNameWithDose like '%exenatide%' 
or LocalDrugNameWithDose like '%liraglutide%' 
or LocalDrugNameWithDose like '%lixisenatide%' 
or LocalDrugNameWithDose like '%dulaglutide%' 
--and b.FillDateTime >= a.SGLT2FillTime
union all

select distinct a.*, b.FillNumber as GLP1FillNumber

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where LocalDrugNameWithDose like '%semaglutide%' 
or LocalDrugNameWithDose like '%exenatide%' 
or LocalDrugNameWithDose like '%liraglutide%' 
or LocalDrugNameWithDose like '%lixisenatide%' 
or LocalDrugNameWithDose like '%dulaglutide%'
--and b.FillDateTime >= a.SGLT2FillTime

select distinct * 
into Dflt.AF_SGLT2GLP1
from #SGLT2GLP1 where GLP1FillNumber >=3
and FillDateTime >= SGLT2FillTime

select distinct scrssn from Dflt.AF_SGLT2GLP1 --446

/* GLP1 after initiation of DPP4 - refill at least 3 */

select distinct a.*,  b.FillNumber as GLP1FillNumber

into #DPP4GLP1

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where LocalDrugNameWithDose like '%semaglutide%' 
or LocalDrugNameWithDose like '%exenatide%' 
or LocalDrugNameWithDose like '%liraglutide%' 
or LocalDrugNameWithDose like '%lixisenatide%' 
or LocalDrugNameWithDose like '%dulaglutide%'
--and b.FillDateTime >= a.DPP4FillTime
union all

select distinct a.*, b.FillNumber as GLP1FillNumber

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where LocalDrugNameWithDose like '%semaglutide%' 
or LocalDrugNameWithDose like '%exenatide%' 
or LocalDrugNameWithDose like '%liraglutide%' 
or LocalDrugNameWithDose like '%lixisenatide%' 
or LocalDrugNameWithDose like '%dulaglutide%'
--and b.FillDateTime >= a.DPP4FillTime

select distinct *
into Dflt.AF_DPP4GLP1
from #DPP4GLP1 where GLP1FillNumber >=3
and FillDateTime >= DPP4FillTime

select distinct scrssn from Dflt.AF_DPP4GLP1 --154

/* SGLT2 */
/* BMI 3 months after initiation */

select distinct a.PatientSID, a.VitalSignTakenDateTime, a.VitalResult, a.VitalResultNumeric,
 b.SGLT2FillTime, b.ScrSSN, 
c.VitalType

into #tempDiabetesVitalsAfter

from Src.Vital_VitalSign as a with (NOLOCK) inner join
Dflt.Diabetes_AF_SGLT2 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.VitalType as c with (NOLOCK) on a.VitalTypeSID=c.VitalTypeSID 
where a.VitalSignTakenDateTime > b.sglt2filltime AND
c.VitalType in ( 'WEIGHT')
union all

select distinct a.PatientSID, a.VitalSignTakenDateTime, a.VitalResult, a.VitalResultNumeric,
b.SGLT2FillTime,b.ScrSSN, 
c.VitalType

from Src.Vital_VitalSign_Recent as a with (NOLOCK) inner join
Dflt.Diabetes_AF_SGLT2 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.VitalType as c with (NOLOCK) on a.VitalTypeSID=c.VitalTypeSID 
where a.VitalSignTakenDateTime > b.sglt2filltime AND
c.VitalType in ( 'WEIGHT')
union all

select distinct a.PatientSID, a.VitalSignTakenDateTime, a.VitalResult, a.VitalResultNumeric,
 b.SGLT2FillTime, b.ScrSSN, 
c.VitalType

from Src.Vital_VitalSign as a with (NOLOCK) inner join
Dflt.Diabetes_AF_SGLT2 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.VitalType as c with (NOLOCK) on a.VitalTypeSID=c.VitalTypeSID 
--where (a.VitalSignTakenDateTime between dateadd(month, -12, b.SGLT2FillTime) and dateadd(day, 1, b.SGLT2FillTime))AND
where a.VitalSignTakenDateTime > b.sglt2filltime AND 
c.VitalType in ( 'HEIGHT')
union all

select distinct a.PatientSID, a.VitalSignTakenDateTime, a.VitalResult, a.VitalResultNumeric,
b.SGLT2FillTime,b.ScrSSN, 
c.VitalType

from Src.Vital_VitalSign_Recent as a with (NOLOCK) inner join
Dflt.Diabetes_AF_SGLT2 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.VitalType as c with (NOLOCK) on a.VitalTypeSID=c.VitalTypeSID 
--where (a.VitalSignTakenDateTime between dateadd(month, -12, b.SGLT2FillTime) and dateadd(day, 1, b.SGLT2FillTime))AND
where a.VitalSignTakenDateTime > b.sglt2filltime AND
c.VitalType in ( 'HEIGHT')

/* Seperate weight records into a table */
select * 

into #tempweightafter

from #tempDiabetesVitalsAfter where vitaltype = 'WEIGHT' and VitalResultNumeric != '0'

/* Seperate height records into a table */
select *  

into #tempheightafter

from #tempDiabetesVitalsafter where vitaltype = 'HEIGHT' and VitalResultNumeric != '0'

/* Combine data from table weight and height to obtain the bmi for individual patient */

select distinct a.patientsid, a.ScrSSN, cast(a.VitalSignTakenDateTime as date) as HeightTime, a.VitalResultNumeric as heightresult, 
cast(b.VitalSignTakenDateTime as date) as WeightTime,b.VitalResultNumeric as weightresult, ((b.VitalResultNumeric*703)/(a.VitalResultNumeric*a.VitalResultNumeric)) as bmi

into Dflt.Diabetes_AF_SGLT2_BMI_After

from #tempheightafter as a with (NOLOCK) inner join
#tempweightafter as b with (NOLOCK) on a.ScrSSN = b.ScrSSN
where a.VitalSignTakenDateTime=b.VitalSignTakenDateTime --a.SGLT2FillTime=b.SGLT2FillTime and

select distinct scrssn from Dflt.Diabetes_AF_SGLT2_BMI_After where bmi between 30 and 35 --1343

select distinct scrssn from Dflt.Diabetes_AF_SGLT2_BMI_After where bmi between 35 and 40 --981

select distinct scrssn from Dflt.Diabetes_AF_SGLT2_BMI_After where bmi >= 30 --2178

select distinct scrssn from Dflt.Diabetes_AF_SGLT2_BMI_After --3070

/* SGLT2 Cardioversion using procedure codes - 1 week after drug initiation */

select distinct a.*, b.ICDProcedureDateTime, c.ICD9ProcedureCode
/*ICD9Procedure Codes*/

into Dflt.Diabetes_AF_SGLT2_CardioAfter

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_CensusICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('99.61','99.62')
					and b.ICDProcedureDateTime  >  dateadd(day, 7, a.SGLT2FillTime)
union all

select distinct a.*, b.SurgicalProcedureDateTime, c.ICD9ProcedureCode

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_CensusSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('99.61','99.62')
					and b.SurgicalProcedureDateTime  >  dateadd(day, 7, a.SGLT2FillTime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD9ProcedureCode

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('99.61','99.62')
					and b.DischargeDateTime  >  dateadd(day, 7, a.SGLT2FillTime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD9ProcedureCode

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('99.61','99.62')
					and b.DischargeDateTime  >  dateadd(day, 7, a.SGLT2FillTime)
union all

/*ICD10Procedure Codes*/
select distinct a.*, b.ICDProcedureDateTime, c.ICD10ProcedureCode

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_CensusICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('5A2204Z')
and b.ICDProcedureDateTime  >  dateadd(day, 7, a.SGLT2FillTime)
union all

select distinct a.*, b.SurgicalProcedureDateTime, c.ICD10ProcedureCode

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_CensusSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('5A2204Z')
and b.SurgicalProcedureDateTime  >  dateadd(day, 7, a.SGLT2FillTime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD10ProcedureCode

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('5A2204Z')
and b.DischargeDateTime  >  dateadd(day, 7, a.SGLT2FillTime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD10ProcedureCode

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('5A2204Z')
and b.DischargeDateTime  >  dateadd(day, 7, a.SGLT2FillTime)

select distinct scrssn from Dflt.Diabetes_AF_SGLT2_CardioAfter --183

/* SGLT2 Ablation using CPT codes- 1 week after drug initiation */

select distinct a.*

into Dflt.Diabetes_AF_SGLT2_AblationAfter

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientCPTProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
Src.Cohort_CPT as c with (NOLOCK) on c.CPTSID=b.cptSID 
where c.cptcode in ('93656','93657','93662','33254','33255','33258','33265','33266')
and b.DischargeDateTime >  dateadd(day, 7, a.SGLT2FillTime)
union all

select distinct a.*
from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Surg_SurgeryPrincipalAssociatedProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on b.OtherProcedureCPTSID=c.cptSID 
where c.cptcode in ('93656','93657','93662','33254','33255','33258','33265','33266') 
and b.SurgeryDateTime >  dateadd(day, 7, a.SGLT2FillTime)
union all

select distinct a.*
from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Surg_SurgeryProcedureDiagnosisCode as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on b.PrincipalCPTSID=c.cptSID 
where c.cptcode in ('93656','93657','93662','33254','33255','33258','33265','33266')
and b.SurgeryDateTime >  dateadd(day, 7, a.SGLT2FillTime)

select distinct scrssn from Dflt.Diabetes_AF_SGLT2_AblationAfter --7

/* SGLT2 Ablation using procedure codes- 1 week after initiation */

select distinct a.*, b.ICDProcedureDateTime, c.ICD9ProcedureCode
/*ICD9Procedure Codes*/

into Dflt.Diabetes_AF_SGLT2_AbProcAfter

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_CensusICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('37.33','37.34','37.37','37.80','38.65')
					and b.ICDProcedureDateTime >  dateadd(day, 7, a.SGLT2FillTime)
union all

select distinct a.*, b.SurgicalProcedureDateTime, c.ICD9ProcedureCode

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_CensusSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('37.33','37.34','37.37','37.80','38.65')
					and b.SurgicalProcedureDateTime >  dateadd(day, 7, a.SGLT2FillTime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD9ProcedureCode

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('37.33','37.34','37.37','37.80','38.65')
					and b.DischargeDateTime >  dateadd(day, 7, a.SGLT2FillTime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD9ProcedureCode

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('37.33','37.34','37.37','37.80','38.65')
					and b.DischargeDateTime >  dateadd(day, 7, a.SGLT2FillTime)
union all

/*ICD10Procedure Codes*/
select distinct a.*, b.ICDProcedureDateTime, c.ICD10ProcedureCode

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_CensusICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('02560ZZ','02563ZZ','02564ZZ',
'02570ZZ','02573ZZ','02574ZZ','02580ZZ','02583ZZ','02584ZZ','025S0ZZ','025S3ZZ','025S4ZZ','025T0ZZ','025T3ZZ','025T4ZZ')
and b.ICDProcedureDateTime >  dateadd(day, 7, a.SGLT2FillTime)
union all

select distinct a.*, b.SurgicalProcedureDateTime, c.ICD10ProcedureCode

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_CensusSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('02560ZZ','02563ZZ','02564ZZ',
'02570ZZ','02573ZZ','02574ZZ','02580ZZ','02583ZZ','02584ZZ','025S0ZZ','025S3ZZ','025S4ZZ','025T0ZZ','025T3ZZ','025T4ZZ')
and b.SurgicalProcedureDateTime >  dateadd(day, 7, a.SGLT2FillTime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD10ProcedureCode

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('02560ZZ','02563ZZ','02564ZZ',
'02570ZZ','02573ZZ','02574ZZ','02580ZZ','02583ZZ','02584ZZ','025S0ZZ','025S3ZZ','025S4ZZ','025T0ZZ','025T3ZZ','025T4ZZ')
and b.DischargeDateTime >  dateadd(day, 7, a.SGLT2FillTime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD10ProcedureCode

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.Inpat_InpatientSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('02560ZZ','02563ZZ','02564ZZ',
'02570ZZ','02573ZZ','02574ZZ','02580ZZ','02583ZZ','02584ZZ','025S0ZZ','025S3ZZ','025S4ZZ','025T0ZZ','025T3ZZ','025T4ZZ')
and b.DischargeDateTime >  dateadd(day, 7, a.SGLT2FillTime)

select distinct scrssn from Dflt.Diabetes_AF_SGLT2_AbProcAfter --84

/* DPP4 Cohort Comorbidity Extraction */

/* Baseline Measurements for DPP4 Cohort */
/* Demographics */
/* Age */

select a.ScrSSN, a.DPP4Filltime, b.DOB,b.SEX
into Dflt.Diabetes_AF_DPP4_DOB
from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.VitalStatus_Mini as b with (NOLOCK) on a.scrssn= b.scrssn

select *, datediff( year, DOB, DPP4Filltime) as age
into Dflt.Diabetes_AF_DPP4_Age
from Dflt.Diabetes_AF_DPP4_DOB

select distinct scrssn from Dflt.Diabetes_AF_DPP4_Age --2079

select distinct scrssn from Dflt.Diabetes_AF_DPP4_Age where SEX ='F' --40

/* Date of Death */

select distinct a.scrssn, b.MPI_DOD
into Dflt.Diabetes_AF_DPP4_DOD
from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.SDAF_DAFMaster as b with (NOLOCK) on a.scrssn= b.MPI_ScrSSN
where b.MPI_DOD is not null

select distinct scrssn from Dflt.Diabetes_AF_DPP4_DOD --1064

select max(MPI_DOD) from Dflt.Diabetes_AF_DPP4_DOD 

select * from Dflt.Diabetes_AF_DPP4_DOD where MPI_DOD > '2023-12-01'

/* Race */

select a.*,  b.Race
into Dflt.Diabetes_AF_DPP4_Race
from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.PatSub_PatientRace as b with (NOLOCK) on a.patientsid= b.patientsid

select distinct scrssn from Dflt.Diabetes_AF_DPP4_Race --2069

select distinct race from Dflt.Diabetes_AF_DPP4_Race 

select distinct scrssn from Dflt.Diabetes_AF_DPP4_Race where race = 'WHITE' --1714

select distinct scrssn from Dflt.Diabetes_AF_DPP4_Race where race = 'BLACK OR AFRICAN AMERICAN' --216

/* Hypertension */

select distinct a.*, b.DischargeDateTime as comorbidity_Dischargedatetime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_AF_DPP4_Hypertension

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('401.1','401.0','401.9','402.00','402.01','402.90','402.91','403.00','403.01','403.10','403.11','403.90','403.91','404.00','404.01','404.02','404.03','404.10',
					'404.11','404.12','404.13','404.90','404.91','404.92','404.93','405.01','405.09','405.11','405.99','642.00','642.01','642.02','642.03','642.04','642.10','642.11',
					'642.12','642.13','642.14','642.20','642.21','642.22','642.23','642.24','642.70','642.71','642.72','642.73','642.74','642.90','642.91','642.92','642.93','642.94')
					and b.DischargeDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('401.1','401.0','401.9','402.00','402.01','402.90','402.91','403.00','403.01','403.10','403.11','403.90','403.91','404.00','404.01','404.02','404.03','404.10',
					'404.11','404.12','404.13','404.90','404.91','404.92','404.93','405.01','405.09','405.11','405.99','642.00','642.01','642.02','642.03','642.04','642.10','642.11',
					'642.12','642.13','642.14','642.20','642.21','642.22','642.23','642.24','642.70','642.71','642.72','642.73','642.74','642.90','642.91','642.92','642.93','642.94')
					and b.DischargeDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('401.1','401.0','401.9','402.00','402.01','402.90','402.91','403.00','403.01','403.10','403.11','403.90','403.91','404.00','404.01','404.02','404.03','404.10',
					'404.11','404.12','404.13','404.90','404.91','404.92','404.93','405.01','405.09','405.11','405.99','642.00','642.01','642.02','642.03','642.04','642.10','642.11',
					'642.12','642.13','642.14','642.20','642.21','642.22','642.23','642.24','642.70','642.71','642.72','642.73','642.74','642.90','642.91','642.92','642.93','642.94')
					and b.DischargeDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.*, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('401.1','401.0','401.9','402.00','402.01','402.90','402.91','403.00','403.01','403.10','403.11','403.90','403.91','404.00','404.01','404.02','404.03','404.10',
					'404.11','404.12','404.13','404.90','404.91','404.92','404.93','405.01','405.09','405.11','405.99','642.00','642.01','642.02','642.03','642.04','642.10','642.11',
					'642.12','642.13','642.14','642.20','642.21','642.22','642.23','642.24','642.70','642.71','642.72','642.73','642.74','642.90','642.91','642.92','642.93','642.94')
					and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.*, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('401.1','401.0','401.9','402.00','402.01','402.90','402.91','403.00','403.01','403.10','403.11','403.90','403.91','404.00','404.01','404.02','404.03','404.10',
					'404.11','404.12','404.13','404.90','404.91','404.92','404.93','405.01','405.09','405.11','405.99','642.00','642.01','642.02','642.03','642.04','642.10','642.11',
					'642.12','642.13','642.14','642.20','642.21','642.22','642.23','642.24','642.70','642.71','642.72','642.73','642.74','642.90','642.91','642.92','642.93','642.94')
					and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.*, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('401.1','401.0','401.9','402.00','402.01','402.90','402.91','403.00','403.01','403.10','403.11','403.90','403.91','404.00','404.01','404.02','404.03','404.10',
					'404.11','404.12','404.13','404.90','404.91','404.92','404.93','405.01','405.09','405.11','405.99','642.00','642.01','642.02','642.03','642.04','642.10','642.11',
					'642.12','642.13','642.14','642.20','642.21','642.22','642.23','642.24','642.70','642.71','642.72','642.73','642.74','642.90','642.91','642.92','642.93','642.94')
					and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.*, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('401.1','401.0','401.9','402.00','402.01','402.90','402.91','403.00','403.01','403.10','403.11','403.90','403.91','404.00','404.01','404.02','404.03','404.10',
					'404.11','404.12','404.13','404.90','404.91','404.92','404.93','405.01','405.09','405.11','405.99','642.00','642.01','642.02','642.03','642.04','642.10','642.11',
					'642.12','642.13','642.14','642.20','642.21','642.22','642.23','642.24','642.70','642.71','642.72','642.73','642.74','642.90','642.91','642.92','642.93','642.94')
					and b.PatientTransferDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.*, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('401.1','401.0','401.9','402.00','402.01','402.90','402.91','403.00','403.01','403.10','403.11','403.90','403.91','404.00','404.01','404.02','404.03','404.10',
					'404.11','404.12','404.13','404.90','404.91','404.92','404.93','405.01','405.09','405.11','405.99','642.00','642.01','642.02','642.03','642.04','642.10','642.11',
					'642.12','642.13','642.14','642.20','642.21','642.22','642.23','642.24','642.70','642.71','642.72','642.73','642.74','642.90','642.91','642.92','642.93','642.94')
					and b.SpecialtyTransferDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.*, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('401.1','401.0','401.9','402.00','402.01','402.90','402.91','403.00','403.01','403.10','403.11','403.90','403.91','404.00','404.01','404.02','404.03','404.10',
					'404.11','404.12','404.13','404.90','404.91','404.92','404.93','405.01','405.09','405.11','405.99','642.00','642.01','642.02','642.03','642.04','642.10','642.11',
					'642.12','642.13','642.14','642.20','642.21','642.22','642.23','642.24','642.70','642.71','642.72','642.73','642.74','642.90','642.91','642.92','642.93','642.94')
					and b.AdmitDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

/*ICD10 Codes*/
select distinct a.*, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I10.', 'I16.9', 'I11.9','I11.0', 'I12.9', 'I12.0','I13.10', 'I13.0', 'I13.11', 'I13.2', 'I15.0', 'I15.8', 
					'O10.019','O10.919', 'O10.011', 'O10.012', 'O10.013', 'O10.02', 'O10.911', 'O10.912', 'O10.913', 'O10.92', 'O10.03', 'O10.93', 
					'O10.419', 'O10.411', 'O10.412', 'O10.413', 'O10.42', 'O10.43','O10.119', 'O10.219', 'O10.319', 'O10.111', 'O10.112', 'O10.113', 'O10.12', 
					'O10.211', 'O10.212', 'O10.213','O10.22', 'O10.311', 'O10.312', 'O10.313', 'O10.32', 'O10.13', 'O10.23', 'O10.33', 'O11.9', 'O11.1', 'O11.2', 
					'O11.3', 'O11.4','O11.5', 'O16.9', 'O16.1', 'O16.2', 'O16.3', 'O16.4', 'O16.5')
and b.DischargeDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I10.', 'I16.9', 'I11.9','I11.0', 'I12.9', 'I12.0','I13.10', 'I13.0', 'I13.11', 'I13.2', 'I15.0', 'I15.8', 
					'O10.019','O10.919', 'O10.011', 'O10.012', 'O10.013', 'O10.02', 'O10.911', 'O10.912', 'O10.913', 'O10.92', 'O10.03', 'O10.93', 
					'O10.419', 'O10.411', 'O10.412', 'O10.413', 'O10.42', 'O10.43','O10.119', 'O10.219', 'O10.319', 'O10.111', 'O10.112', 'O10.113', 'O10.12', 
					'O10.211', 'O10.212', 'O10.213','O10.22', 'O10.311', 'O10.312', 'O10.313', 'O10.32', 'O10.13', 'O10.23', 'O10.33', 'O11.9', 'O11.1', 'O11.2', 
					'O11.3', 'O11.4','O11.5', 'O16.9', 'O16.1', 'O16.2', 'O16.3', 'O16.4', 'O16.5')
and b.DischargeDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I10.', 'I16.9', 'I11.9','I11.0', 'I12.9', 'I12.0','I13.10', 'I13.0', 'I13.11', 'I13.2', 'I15.0', 'I15.8', 
					'O10.019','O10.919', 'O10.011', 'O10.012', 'O10.013', 'O10.02', 'O10.911', 'O10.912', 'O10.913', 'O10.92', 'O10.03', 'O10.93', 
					'O10.419', 'O10.411', 'O10.412', 'O10.413', 'O10.42', 'O10.43','O10.119', 'O10.219', 'O10.319', 'O10.111', 'O10.112', 'O10.113', 'O10.12', 
					'O10.211', 'O10.212', 'O10.213','O10.22', 'O10.311', 'O10.312', 'O10.313', 'O10.32', 'O10.13', 'O10.23', 'O10.33', 'O11.9', 'O11.1', 'O11.2', 
					'O11.3', 'O11.4','O11.5', 'O16.9', 'O16.1', 'O16.2', 'O16.3', 'O16.4', 'O16.5')
and b.DischargeDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.*, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I10.', 'I16.9', 'I11.9','I11.0', 'I12.9', 'I12.0','I13.10', 'I13.0', 'I13.11', 'I13.2', 'I15.0', 'I15.8', 
					'O10.019','O10.919', 'O10.011', 'O10.012', 'O10.013', 'O10.02', 'O10.911', 'O10.912', 'O10.913', 'O10.92', 'O10.03', 'O10.93', 
					'O10.419', 'O10.411', 'O10.412', 'O10.413', 'O10.42', 'O10.43','O10.119', 'O10.219', 'O10.319', 'O10.111', 'O10.112', 'O10.113', 'O10.12', 
					'O10.211', 'O10.212', 'O10.213','O10.22', 'O10.311', 'O10.312', 'O10.313', 'O10.32', 'O10.13', 'O10.23', 'O10.33', 'O11.9', 'O11.1', 'O11.2', 
					'O11.3', 'O11.4','O11.5', 'O16.9', 'O16.1', 'O16.2', 'O16.3', 'O16.4', 'O16.5')
and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.*, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I10.', 'I16.9', 'I11.9','I11.0', 'I12.9', 'I12.0','I13.10', 'I13.0', 'I13.11', 'I13.2', 'I15.0', 'I15.8', 
					'O10.019','O10.919', 'O10.011', 'O10.012', 'O10.013', 'O10.02', 'O10.911', 'O10.912', 'O10.913', 'O10.92', 'O10.03', 'O10.93', 
					'O10.419', 'O10.411', 'O10.412', 'O10.413', 'O10.42', 'O10.43','O10.119', 'O10.219', 'O10.319', 'O10.111', 'O10.112', 'O10.113', 'O10.12', 
					'O10.211', 'O10.212', 'O10.213','O10.22', 'O10.311', 'O10.312', 'O10.313', 'O10.32', 'O10.13', 'O10.23', 'O10.33', 'O11.9', 'O11.1', 'O11.2', 
					'O11.3', 'O11.4','O11.5', 'O16.9', 'O16.1', 'O16.2', 'O16.3', 'O16.4', 'O16.5')
and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.*, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I10.', 'I16.9', 'I11.9','I11.0', 'I12.9', 'I12.0','I13.10', 'I13.0', 'I13.11', 'I13.2', 'I15.0', 'I15.8', 
					'O10.019','O10.919', 'O10.011', 'O10.012', 'O10.013', 'O10.02', 'O10.911', 'O10.912', 'O10.913', 'O10.92', 'O10.03', 'O10.93', 
					'O10.419', 'O10.411', 'O10.412', 'O10.413', 'O10.42', 'O10.43','O10.119', 'O10.219', 'O10.319', 'O10.111', 'O10.112', 'O10.113', 'O10.12', 
					'O10.211', 'O10.212', 'O10.213','O10.22', 'O10.311', 'O10.312', 'O10.313', 'O10.32', 'O10.13', 'O10.23', 'O10.33', 'O11.9', 'O11.1', 'O11.2', 
					'O11.3', 'O11.4','O11.5', 'O16.9', 'O16.1', 'O16.2', 'O16.3', 'O16.4', 'O16.5')
and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)

union all

select distinct a.*, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I10.', 'I16.9', 'I11.9','I11.0', 'I12.9', 'I12.0','I13.10', 'I13.0', 'I13.11', 'I13.2', 'I15.0', 'I15.8', 
					'O10.019','O10.919', 'O10.011', 'O10.012', 'O10.013', 'O10.02', 'O10.911', 'O10.912', 'O10.913', 'O10.92', 'O10.03', 'O10.93', 
					'O10.419', 'O10.411', 'O10.412', 'O10.413', 'O10.42', 'O10.43','O10.119', 'O10.219', 'O10.319', 'O10.111', 'O10.112', 'O10.113', 'O10.12', 
					'O10.211', 'O10.212', 'O10.213','O10.22', 'O10.311', 'O10.312', 'O10.313', 'O10.32', 'O10.13', 'O10.23', 'O10.33', 'O11.9', 'O11.1', 'O11.2', 
					'O11.3', 'O11.4','O11.5', 'O16.9', 'O16.1', 'O16.2', 'O16.3', 'O16.4', 'O16.5')
and b.PatientTransferDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)

union all

select distinct a.*, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I10.', 'I16.9', 'I11.9','I11.0', 'I12.9', 'I12.0','I13.10', 'I13.0', 'I13.11', 'I13.2', 'I15.0', 'I15.8', 
					'O10.019','O10.919', 'O10.011', 'O10.012', 'O10.013', 'O10.02', 'O10.911', 'O10.912', 'O10.913', 'O10.92', 'O10.03', 'O10.93', 
					'O10.419', 'O10.411', 'O10.412', 'O10.413', 'O10.42', 'O10.43','O10.119', 'O10.219', 'O10.319', 'O10.111', 'O10.112', 'O10.113', 'O10.12', 
					'O10.211', 'O10.212', 'O10.213','O10.22', 'O10.311', 'O10.312', 'O10.313', 'O10.32', 'O10.13', 'O10.23', 'O10.33', 'O11.9', 'O11.1', 'O11.2', 
					'O11.3', 'O11.4','O11.5', 'O16.9', 'O16.1', 'O16.2', 'O16.3', 'O16.4', 'O16.5')
and b.SpecialtyTransferDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)

union all

select distinct a.*, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I10.', 'I16.9', 'I11.9','I11.0', 'I12.9', 'I12.0','I13.10', 'I13.0', 'I13.11', 'I13.2', 'I15.0', 'I15.8', 
					'O10.019','O10.919', 'O10.011', 'O10.012', 'O10.013', 'O10.02', 'O10.911', 'O10.912', 'O10.913', 'O10.92', 'O10.03', 'O10.93', 
					'O10.419', 'O10.411', 'O10.412', 'O10.413', 'O10.42', 'O10.43','O10.119', 'O10.219', 'O10.319', 'O10.111', 'O10.112', 'O10.113', 'O10.12', 
					'O10.211', 'O10.212', 'O10.213','O10.22', 'O10.311', 'O10.312', 'O10.313', 'O10.32', 'O10.13', 'O10.23', 'O10.33', 'O11.9', 'O11.1', 'O11.2', 
					'O11.3', 'O11.4','O11.5', 'O16.9', 'O16.1', 'O16.2', 'O16.3', 'O16.4', 'O16.5')
and b.AdmitDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)

select distinct scrssn from Dflt.Diabetes_AF_DPP4_Hypertension --1441
select * from Dflt.Diabetes_AF_DPP4_Hypertension

/* Chronic Kidney Disease */
/*Making sure the ICD9 and ICD10 codes relevant to Kidney Disease are present in the Dimension table under CDWWork*/

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
													'V56.0','V56.1','V56.2','V56.8','585.3')

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3') or ICD10Code like 'Z49.%'

select distinct a.patientsid, a.scrssn, a.DPP4Filltime ,b.DischargeDateTime as comorbidity_Dischargedatetime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_AF_DPP4_KidneyDisease

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
				'V56.0','V56.1','V56.2','V56.8','585.3')
					and b.DischargeDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
				'V56.0','V56.1','V56.2','V56.8','585.3')
					and b.DischargeDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
				'V56.0','V56.1','V56.2','V56.8','585.3')
					and b.DischargeDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
				'V56.0','V56.1','V56.2','V56.8','585.3')
					and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
				'V56.0','V56.1','V56.2','V56.8','585.3')
					and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
				'V56.0','V56.1','V56.2','V56.8','585.3')
					and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
				'V56.0','V56.1','V56.2','V56.8','585.3')
					and b.PatientTransferDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
				'V56.0','V56.1','V56.2','V56.8','585.3')
					and b.SpecialtyTransferDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
				'V56.0','V56.1','V56.2','V56.8','585.3')
					and b.AdmitDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3') or ICD10Code like 'Z49.%'
and b.DischargeDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3') or ICD10Code like 'Z49.%'
and b.DischargeDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3') or ICD10Code like 'Z49.%'
and b.DischargeDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3') or ICD10Code like 'Z49.%'
and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3') or ICD10Code like 'Z49.%'
and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3') or ICD10Code like 'Z49.%'
and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)

union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3') or ICD10Code like 'Z49.%'
and b.PatientTransferDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)

union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3') or ICD10Code like 'Z49.%'
and b.SpecialtyTransferDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)

union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3') or ICD10Code like 'Z49.%'
and b.AdmitDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)

select distinct scrssn from Dflt.Diabetes_AF_DPP4_KidneyDisease --721
select * from Dflt.Diabetes_AF_DPP4_KidneyDisease

/* End Stage Renal Disease - ESRD */
/*Making sure the ICD9 and ICD10 codes relevant to ESRD are present in the Dimension table under CDWWork*/

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('585.6')

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('N18.6')

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime as comorbidity_Dischargedatetime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_AF_DPP4_ESRD

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('585.6')
					and b.DischargeDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('585.6')
					and b.DischargeDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('585.6')
					and b.DischargeDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('585.6')
					and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('585.6')
					and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('585.6')
					and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('585.6')
					and b.PatientTransferDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('585.6')
					and b.SpecialtyTransferDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('585.6')
					and b.AdmitDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('N18.6')
and b.DischargeDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('N18.6')
and b.DischargeDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('N18.6')
and b.DischargeDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('N18.6')
and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('N18.6')
and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('N18.6')
and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)

union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('N18.6')
and b.PatientTransferDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)

union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('N18.6')
and b.SpecialtyTransferDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)

union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('N18.6')
and b.AdmitDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)

select distinct scrssn from Dflt.Diabetes_AF_DPP4_ESRD --11

/* Alcohol Abuse */

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime as comorbidity_Dischargedatettime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_AF_DPP4_AlcoholAbuse

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('290.0','291.1','291.2','291.3','291.5','291.81','291.82','291.89','291.9',
			    '303.00','303.01','303.02','303.03','303.90','303.91','303.92','303.93','305.00','305.01','305.02','305.03','V11.3')
					and b.DischargeDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('290.0','291.1','291.2','291.3','291.5','291.81','291.82','291.89','291.9',
			    '303.00','303.01','303.02','303.03','303.90','303.91','303.92','303.93','305.00','305.01','305.02','305.03','V11.3')
					and b.DischargeDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('290.0','291.1','291.2','291.3','291.5','291.81','291.82','291.89','291.9',
			    '303.00','303.01','303.02','303.03','303.90','303.91','303.92','303.93','305.00','305.01','305.02','305.03','V11.3')
					and b.DischargeDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('290.0','291.1','291.2','291.3','291.5','291.81','291.82','291.89','291.9',
			    '303.00','303.01','303.02','303.03','303.90','303.91','303.92','303.93','305.00','305.01','305.02','305.03','V11.3')
					and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('290.0','291.1','291.2','291.3','291.5','291.81','291.82','291.89','291.9',
			    '303.00','303.01','303.02','303.03','303.90','303.91','303.92','303.93','305.00','305.01','305.02','305.03','V11.3')
					and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('290.0','291.1','291.2','291.3','291.5','291.81','291.82','291.89','291.9',
			    '303.00','303.01','303.02','303.03','303.90','303.91','303.92','303.93','305.00','305.01','305.02','305.03','V11.3')
					and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('290.0','291.1','291.2','291.3','291.5','291.81','291.82','291.89','291.9',
			    '303.00','303.01','303.02','303.03','303.90','303.91','303.92','303.93','305.00','305.01','305.02','305.03','V11.3')
					and b.PatientTransferDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('290.0','291.1','291.2','291.3','291.5','291.81','291.82','291.89','291.9',
			    '303.00','303.01','303.02','303.03','303.90','303.91','303.92','303.93','305.00','305.01','305.02','305.03','V11.3')
					and b.SpecialtyTransferDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('290.0','291.1','291.2','291.3','291.5','291.81','291.82','291.89','291.9',
			    '303.00','303.01','303.02','303.03','303.90','303.91','303.92','303.93','305.00','305.01','305.02','305.03','V11.3')
					and b.AdmitDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.231', 'F10.96', 'F10.27','F10.951','F10.950', 'F10.239', 'F10.182', 'F10.282', 'F10.982', 'F10.159', 'F10.180', 
					'F10.181', 'F10.188','F10.259', 'F10.280', 'F10.281', 'F10.288', 'F10.959', 'F10.980', 'F10.99','F10.229', 'F10.20', 'F10.21','F10.10','F10.11','Z65.8 ')
and b.DischargeDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.231', 'F10.96', 'F10.27','F10.951','F10.950', 'F10.239', 'F10.182', 'F10.282', 'F10.982', 'F10.159', 'F10.180', 
					'F10.181', 'F10.188','F10.259', 'F10.280', 'F10.281', 'F10.288', 'F10.959', 'F10.980', 'F10.99','F10.229', 'F10.20', 'F10.21','F10.10','F10.11','Z65.8 ')
and b.DischargeDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.231', 'F10.96', 'F10.27','F10.951','F10.950', 'F10.239', 'F10.182', 'F10.282', 'F10.982', 'F10.159', 'F10.180', 
					'F10.181', 'F10.188','F10.259', 'F10.280', 'F10.281', 'F10.288', 'F10.959', 'F10.980', 'F10.99','F10.229', 'F10.20', 'F10.21','F10.10','F10.11','Z65.8 ')
and b.DischargeDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.231', 'F10.96', 'F10.27','F10.951','F10.950', 'F10.239', 'F10.182', 'F10.282', 'F10.982', 'F10.159', 'F10.180', 
					'F10.181', 'F10.188','F10.259', 'F10.280', 'F10.281', 'F10.288', 'F10.959', 'F10.980', 'F10.99','F10.229', 'F10.20', 'F10.21','F10.10','F10.11','Z65.8 ')
and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.231', 'F10.96', 'F10.27','F10.951','F10.950', 'F10.239', 'F10.182', 'F10.282', 'F10.982', 'F10.159', 'F10.180', 
					'F10.181', 'F10.188','F10.259', 'F10.280', 'F10.281', 'F10.288', 'F10.959', 'F10.980', 'F10.99','F10.229', 'F10.20', 'F10.21','F10.10','F10.11','Z65.8 ')
and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.231', 'F10.96', 'F10.27','F10.951','F10.950', 'F10.239', 'F10.182', 'F10.282', 'F10.982', 'F10.159', 'F10.180', 
					'F10.181', 'F10.188','F10.259', 'F10.280', 'F10.281', 'F10.288', 'F10.959', 'F10.980', 'F10.99','F10.229', 'F10.20', 'F10.21','F10.10','F10.11','Z65.8 ')
and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.231', 'F10.96', 'F10.27','F10.951','F10.950', 'F10.239', 'F10.182', 'F10.282', 'F10.982', 'F10.159', 'F10.180', 
					'F10.181', 'F10.188','F10.259', 'F10.280', 'F10.281', 'F10.288', 'F10.959', 'F10.980', 'F10.99','F10.229', 'F10.20', 'F10.21','F10.10','F10.11','Z65.8 ')
and b.PatientTransferDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.231', 'F10.96', 'F10.27','F10.951','F10.950', 'F10.239', 'F10.182', 'F10.282', 'F10.982', 'F10.159', 'F10.180', 
					'F10.181', 'F10.188','F10.259', 'F10.280', 'F10.281', 'F10.288', 'F10.959', 'F10.980', 'F10.99','F10.229', 'F10.20', 'F10.21','F10.10','F10.11','Z65.8 ')
and b.SpecialtyTransferDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.231', 'F10.96', 'F10.27','F10.951','F10.950', 'F10.239', 'F10.182', 'F10.282', 'F10.982', 'F10.159', 'F10.180', 
					'F10.181', 'F10.188','F10.259', 'F10.280', 'F10.281', 'F10.288', 'F10.959', 'F10.980', 'F10.99','F10.229', 'F10.20', 'F10.21','F10.10','F10.11','Z65.8 ')
and b.AdmitDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)

select distinct scrssn from Dflt.Diabetes_AF_DPP4_AlcoholAbuse --69

/*Polysubstance Abuse */
/*Making sure the ICD9 and ICD10 codes relevant to Polysubstance Abuse are present in the Dimension table under CDWWork*/

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('F10.129','F10.229','F10.929','F10.10','F10.20','F11.10',
																	'F11.10','F11.20','F11.129','F11.229','F11.929','F11.122','F11.222','F11.922','F11.23','F11.99',
																	'F13.10','F13.20','F14.10','F14.20','F12.10','F12.20','F16.10','F16.20','F18.10','F18.20',
																	'F19.10','F19.20','Z72.0','F17.200','F15.10','F15.20','F15.929')

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('303.00','305.00','303.90','304.00','292.89','292.0','292.9','304.10','305.40','304.20','305.60',
															'304.30','305.20','304.50','305.30','305.90','304.60','304.80','304.90','305.10',
															'305.70','304.40','304.6')

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime as comorbidity_Dischargedatettime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_AF_DPP4_PolyAbuse

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('303.00','305.00','303.90','304.00','292.89','292.0','292.9','304.10','305.40','304.20','305.60',
					'304.30','305.20','304.50','305.30','305.90','304.60','304.80','304.90','305.10','305.70','304.40','304.6')
					and b.DischargeDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('303.00','305.00','303.90','304.00','292.89','292.0','292.9','304.10','305.40','304.20','305.60',
					'304.30','305.20','304.50','305.30','305.90','304.60','304.80','304.90','305.10','305.70','304.40','304.6')
					and b.DischargeDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('303.00','305.00','303.90','304.00','292.89','292.0','292.9','304.10','305.40','304.20','305.60',
					'304.30','305.20','304.50','305.30','305.90','304.60','304.80','304.90','305.10','305.70','304.40','304.6')
					and b.DischargeDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('303.00','305.00','303.90','304.00','292.89','292.0','292.9','304.10','305.40','304.20','305.60',
					'304.30','305.20','304.50','305.30','305.90','304.60','304.80','304.90','305.10','305.70','304.40','304.6')
					and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('303.00','305.00','303.90','304.00','292.89','292.0','292.9','304.10','305.40','304.20','305.60',
					'304.30','305.20','304.50','305.30','305.90','304.60','304.80','304.90','305.10','305.70','304.40','304.6')
					and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('303.00','305.00','303.90','304.00','292.89','292.0','292.9','304.10','305.40','304.20','305.60',
					'304.30','305.20','304.50','305.30','305.90','304.60','304.80','304.90','305.10','305.70','304.40','304.6')
					and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('303.00','305.00','303.90','304.00','292.89','292.0','292.9','304.10','305.40','304.20','305.60',
					'304.30','305.20','304.50','305.30','305.90','304.60','304.80','304.90','305.10','305.70','304.40','304.6')
					and b.PatientTransferDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('303.00','305.00','303.90','304.00','292.89','292.0','292.9','304.10','305.40','304.20','305.60',
					'304.30','305.20','304.50','305.30','305.90','304.60','304.80','304.90','305.10','305.70','304.40','304.6')
					and b.SpecialtyTransferDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('303.00','305.00','303.90','304.00','292.89','292.0','292.9','304.10','305.40','304.20','305.60',
					'304.30','305.20','304.50','305.30','305.90','304.60','304.80','304.90','305.10','305.70','304.40','304.6')
					and b.AdmitDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.129','F10.229','F10.929','F10.10','F10.20','F11.10',
					'F11.10','F11.20','F11.129','F11.229','F11.929','F11.122','F11.222','F11.922','F11.23','F11.99',
					'F13.10','F13.20','F14.10','F14.20','F12.10','F12.20','F16.10','F16.20','F18.10','F18.20',
					'F19.10','F19.20','Z72.0','F17.200','F15.10','F15.20','F15.929')
and b.DischargeDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.129','F10.229','F10.929','F10.10','F10.20','F11.10',
					'F11.10','F11.20','F11.129','F11.229','F11.929','F11.122','F11.222','F11.922','F11.23','F11.99',
					'F13.10','F13.20','F14.10','F14.20','F12.10','F12.20','F16.10','F16.20','F18.10','F18.20',
					'F19.10','F19.20','Z72.0','F17.200','F15.10','F15.20','F15.929')
and b.DischargeDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.129','F10.229','F10.929','F10.10','F10.20','F11.10',
					'F11.10','F11.20','F11.129','F11.229','F11.929','F11.122','F11.222','F11.922','F11.23','F11.99',
					'F13.10','F13.20','F14.10','F14.20','F12.10','F12.20','F16.10','F16.20','F18.10','F18.20',
					'F19.10','F19.20','Z72.0','F17.200','F15.10','F15.20','F15.929')
and b.DischargeDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.129','F10.229','F10.929','F10.10','F10.20','F11.10',
					'F11.10','F11.20','F11.129','F11.229','F11.929','F11.122','F11.222','F11.922','F11.23','F11.99',
					'F13.10','F13.20','F14.10','F14.20','F12.10','F12.20','F16.10','F16.20','F18.10','F18.20',
					'F19.10','F19.20','Z72.0','F17.200','F15.10','F15.20','F15.929')
and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.129','F10.229','F10.929','F10.10','F10.20','F11.10',
					'F11.10','F11.20','F11.129','F11.229','F11.929','F11.122','F11.222','F11.922','F11.23','F11.99',
					'F13.10','F13.20','F14.10','F14.20','F12.10','F12.20','F16.10','F16.20','F18.10','F18.20',
					'F19.10','F19.20','Z72.0','F17.200','F15.10','F15.20','F15.929')
and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.129','F10.229','F10.929','F10.10','F10.20','F11.10',
					'F11.10','F11.20','F11.129','F11.229','F11.929','F11.122','F11.222','F11.922','F11.23','F11.99',
					'F13.10','F13.20','F14.10','F14.20','F12.10','F12.20','F16.10','F16.20','F18.10','F18.20',
					'F19.10','F19.20','Z72.0','F17.200','F15.10','F15.20','F15.929')
and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.129','F10.229','F10.929','F10.10','F10.20','F11.10',
					'F11.10','F11.20','F11.129','F11.229','F11.929','F11.122','F11.222','F11.922','F11.23','F11.99',
					'F13.10','F13.20','F14.10','F14.20','F12.10','F12.20','F16.10','F16.20','F18.10','F18.20',
					'F19.10','F19.20','Z72.0','F17.200','F15.10','F15.20','F15.929')
and b.PatientTransferDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.129','F10.229','F10.929','F10.10','F10.20','F11.10',
					'F11.10','F11.20','F11.129','F11.229','F11.929','F11.122','F11.222','F11.922','F11.23','F11.99',
					'F13.10','F13.20','F14.10','F14.20','F12.10','F12.20','F16.10','F16.20','F18.10','F18.20',
					'F19.10','F19.20','Z72.0','F17.200','F15.10','F15.20','F15.929')
and b.SpecialtyTransferDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.129','F10.229','F10.929','F10.10','F10.20','F11.10',
					'F11.10','F11.20','F11.129','F11.229','F11.929','F11.122','F11.222','F11.922','F11.23','F11.99',
					'F13.10','F13.20','F14.10','F14.20','F12.10','F12.20','F16.10','F16.20','F18.10','F18.20',
					'F19.10','F19.20','Z72.0','F17.200','F15.10','F15.20','F15.929')
and b.AdmitDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)

Select distinct scrssn from Dflt.Diabetes_AF_DPP4_PolyAbuse --132

/* Malignancy */
/*Making sure the ICD9 and ICD10 codes relevant to Malignancy are present in the Dimension table under CDWWork*/

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('196.0','196.1','196.2','196.3','196.5','196.6','196.8','196.9','197.0','197.1','197.2','197.3','197.4','197.5',
					'197.6','197.7','197.8','198.0','198.1','198.2','198.3','198.4','198.5','198.6','198.7','198.81','198.82','198.89','199.0','199.1')

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('C77.0','C77.1','C77.2','C77.3','C77.4','C77.5','C77.8','C77.9','C78.0','C78.1','C78.2','C78.3',
					'C78.4', 'C78.5','C78.6', 'C78.7', 'C78.89','C79.9','C79.11','C79.2','C79.31','C79.32','C79.49',
					'C79.51','C79.52','C79.60','C79.70','C79.81','C79.82','C79.89','C80.0','C80.1')

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime as comorbidity_Dischargedatettime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_AF_DPP4_Malignancy

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('196.0','196.1','196.2','196.3','196.5','196.6','196.8','196.9','197.0','197.1','197.2','197.3','197.4','197.5',
					'197.6','197.7','197.8','198.0','198.1','198.2','198.3','198.4','198.5','198.6','198.7','198.81','198.82','198.89','199.0','199.1')
					and b.DischargeDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('196.0','196.1','196.2','196.3','196.5','196.6','196.8','196.9','197.0','197.1','197.2','197.3','197.4','197.5',
					'197.6','197.7','197.8','198.0','198.1','198.2','198.3','198.4','198.5','198.6','198.7','198.81','198.82','198.89','199.0','199.1')
					and b.DischargeDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('196.0','196.1','196.2','196.3','196.5','196.6','196.8','196.9','197.0','197.1','197.2','197.3','197.4','197.5',
					'197.6','197.7','197.8','198.0','198.1','198.2','198.3','198.4','198.5','198.6','198.7','198.81','198.82','198.89','199.0','199.1')
					and b.DischargeDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('196.0','196.1','196.2','196.3','196.5','196.6','196.8','196.9','197.0','197.1','197.2','197.3','197.4','197.5',
					'197.6','197.7','197.8','198.0','198.1','198.2','198.3','198.4','198.5','198.6','198.7','198.81','198.82','198.89','199.0','199.1')
					and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('196.0','196.1','196.2','196.3','196.5','196.6','196.8','196.9','197.0','197.1','197.2','197.3','197.4','197.5',
					'197.6','197.7','197.8','198.0','198.1','198.2','198.3','198.4','198.5','198.6','198.7','198.81','198.82','198.89','199.0','199.1')
					and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('196.0','196.1','196.2','196.3','196.5','196.6','196.8','196.9','197.0','197.1','197.2','197.3','197.4','197.5',
					'197.6','197.7','197.8','198.0','198.1','198.2','198.3','198.4','198.5','198.6','198.7','198.81','198.82','198.89','199.0','199.1')
					and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('196.0','196.1','196.2','196.3','196.5','196.6','196.8','196.9','197.0','197.1','197.2','197.3','197.4','197.5',
					'197.6','197.7','197.8','198.0','198.1','198.2','198.3','198.4','198.5','198.6','198.7','198.81','198.82','198.89','199.0','199.1')
					and b.PatientTransferDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('196.0','196.1','196.2','196.3','196.5','196.6','196.8','196.9','197.0','197.1','197.2','197.3','197.4','197.5',
					'197.6','197.7','197.8','198.0','198.1','198.2','198.3','198.4','198.5','198.6','198.7','198.81','198.82','198.89','199.0','199.1')
					and b.SpecialtyTransferDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('196.0','196.1','196.2','196.3','196.5','196.6','196.8','196.9','197.0','197.1','197.2','197.3','197.4','197.5',
					'197.6','197.7','197.8','198.0','198.1','198.2','198.3','198.4','198.5','198.6','198.7','198.81','198.82','198.89','199.0','199.1')
					and b.AdmitDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('C77.0','C77.1','C77.2','C77.3','C77.4','C77.5','C77.8','C77.9','C78.0','C78.1','C78.2','C78.3',
					'C78.4', 'C78.5','C78.6', 'C78.7', 'C78.89','C79.9','C79.11','C79.2','C79.31','C79.32','C79.49',
					'C79.51','C79.52','C79.60','C79.70','C79.81','C79.82','C79.89','C80.0','C80.1')
and b.DischargeDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('C77.0','C77.1','C77.2','C77.3','C77.4','C77.5','C77.8','C77.9','C78.0','C78.1','C78.2','C78.3',
					'C78.4', 'C78.5','C78.6', 'C78.7', 'C78.89','C79.9','C79.11','C79.2','C79.31','C79.32','C79.49',
					'C79.51','C79.52','C79.60','C79.70','C79.81','C79.82','C79.89','C80.0','C80.1')
and b.DischargeDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('C77.0','C77.1','C77.2','C77.3','C77.4','C77.5','C77.8','C77.9','C78.0','C78.1','C78.2','C78.3',
					'C78.4', 'C78.5','C78.6', 'C78.7', 'C78.89','C79.9','C79.11','C79.2','C79.31','C79.32','C79.49',
					'C79.51','C79.52','C79.60','C79.70','C79.81','C79.82','C79.89','C80.0','C80.1') 
and b.DischargeDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('C77.0','C77.1','C77.2','C77.3','C77.4','C77.5','C77.8','C77.9','C78.0','C78.1','C78.2','C78.3',
					'C78.4', 'C78.5','C78.6', 'C78.7', 'C78.89','C79.9','C79.11','C79.2','C79.31','C79.32','C79.49',
					'C79.51','C79.52','C79.60','C79.70','C79.81','C79.82','C79.89','C80.0','C80.1')
and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('C77.0','C77.1','C77.2','C77.3','C77.4','C77.5','C77.8','C77.9','C78.0','C78.1','C78.2','C78.3',
					'C78.4', 'C78.5','C78.6', 'C78.7', 'C78.89','C79.9','C79.11','C79.2','C79.31','C79.32','C79.49',
					'C79.51','C79.52','C79.60','C79.70','C79.81','C79.82','C79.89','C80.0','C80.1')
and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('C77.0','C77.1','C77.2','C77.3','C77.4','C77.5','C77.8','C77.9','C78.0','C78.1','C78.2','C78.3',
					'C78.4', 'C78.5','C78.6', 'C78.7', 'C78.89','C79.9','C79.11','C79.2','C79.31','C79.32','C79.49',
					'C79.51','C79.52','C79.60','C79.70','C79.81','C79.82','C79.89','C80.0','C80.1')
and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('C77.0','C77.1','C77.2','C77.3','C77.4','C77.5','C77.8','C77.9','C78.0','C78.1','C78.2','C78.3',
					'C78.4', 'C78.5','C78.6', 'C78.7', 'C78.89','C79.9','C79.11','C79.2','C79.31','C79.32','C79.49',
					'C79.51','C79.52','C79.60','C79.70','C79.81','C79.82','C79.89','C80.0','C80.1')
and b.PatientTransferDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('C77.0','C77.1','C77.2','C77.3','C77.4','C77.5','C77.8','C77.9','C78.0','C78.1','C78.2','C78.3',
					'C78.4', 'C78.5','C78.6', 'C78.7', 'C78.89','C79.9','C79.11','C79.2','C79.31','C79.32','C79.49',
					'C79.51','C79.52','C79.60','C79.70','C79.81','C79.82','C79.89','C80.0','C80.1')
and b.SpecialtyTransferDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('C77.0','C77.1','C77.2','C77.3','C77.4','C77.5','C77.8','C77.9','C78.0','C78.1','C78.2','C78.3',
					'C78.4', 'C78.5','C78.6', 'C78.7', 'C78.89','C79.9','C79.11','C79.2','C79.31','C79.32','C79.49',
					'C79.51','C79.52','C79.60','C79.70','C79.81','C79.82','C79.89','C80.0','C80.1')
and b.AdmitDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)

select distinct scrssn from Dflt.Diabetes_AF_DPP4_Malignancy --15

/* Hypothyroidism */

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime as comorbidity_Dischargedatettime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_AF_DPP4_Hypothyroidism

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like ('244.%')
					and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like ('244.%')
					and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like ('244.%')
					and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like ('244.%')
					and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like ('244.%')
					and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like ('244.%')
					and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like ('244.%')
					and b.PatientTransferDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like ('244.%')
					and b.SpecialtyTransferDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like ('244.%')
					and b.AdmitDateTime <= a.DPP4FillTime
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like ('E03.%')
and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like ('E03.%')
and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like ('E03.%')
and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like ('E03.%')
and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like ('E03.%')
and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like ('E03.%')
and b.EventDateTime <= a.DPP4FillTime

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like ('E03.%')
and b.PatientTransferDateTime <= a.DPP4FillTime

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like ('E03.%')
and b.SpecialtyTransferDateTime <= a.DPP4FillTime

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like ('E03.%')
and b.AdmitDateTime <= a.DPP4FillTime

select distinct scrssn from Dflt.Diabetes_AF_DPP4_Hypothyroidism --284
select * from Dflt.Diabetes_AF_DPP4_Hypothyroidism --1602

/*Smoking */

select distinct a.*, b.SMOKE

into Dflt.Diabetes_AF_DPP4_Smoke

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.VASQIP_nso_noncardiac as b with (NOLOCK) on a.scrssn= b.scrssn 

select * from Dflt.Diabetes_AF_DPP4_Smoke
select distinct scrssn from Dflt.Diabetes_AF_DPP4_Smoke where smoke = '1' --218

/*Prior Stroke */
/*Making sure the ICD9 and ICD10 codes relevant to Stroke are present in the Dimension table under CDWWork*/

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('I63.019','I63.119','I63.139','I63.20','I63.219','I63.22','I63.239','I63.30','I63.40','I63.50','I63.59')

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('433.21','433.11','433.91','433.01','434.01','434.11','434.91','433.31','433.81')

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime as comorbidity_Dischargedatettime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_AF_DPP4_Stroke

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('433.21','433.11','433.91','433.01','434.01','434.11','434.91','433.31','433.81')
					and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('433.21','433.11','433.91','433.01','434.01','434.11','434.91','433.31','433.81')
					and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('433.21','433.11','433.91','433.01','434.01','434.11','434.91','433.31','433.81')
					and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('433.21','433.11','433.91','433.01','434.01','434.11','434.91','433.31','433.81')
					and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('433.21','433.11','433.91','433.01','434.01','434.11','434.91','433.31','433.81')
					and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('433.21','433.11','433.91','433.01','434.01','434.11','434.91','433.31','433.81')
					and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('433.21','433.11','433.91','433.01','434.01','434.11','434.91','433.31','433.81')
					and b.PatientTransferDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('433.21','433.11','433.91','433.01','434.01','434.11','434.91','433.31','433.81')
					and b.SpecialtyTransferDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('433.21','433.11','433.91','433.01','434.01','434.11','434.91','433.31','433.81')
					and b.AdmitDateTime <= a.DPP4FillTime
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I63.019','I63.119','I63.139','I63.20','I63.219','I63.22','I63.239','I63.30','I63.40','I63.50','I63.59')
and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I63.019','I63.119','I63.139','I63.20','I63.219','I63.22','I63.239','I63.30','I63.40','I63.50','I63.59')
and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I63.019','I63.119','I63.139','I63.20','I63.219','I63.22','I63.239','I63.30','I63.40','I63.50','I63.59')
and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I63.019','I63.119','I63.139','I63.20','I63.219','I63.22','I63.239','I63.30','I63.40','I63.50','I63.59')
and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I63.019','I63.119','I63.139','I63.20','I63.219','I63.22','I63.239','I63.30','I63.40','I63.50','I63.59')
and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I63.019','I63.119','I63.139','I63.20','I63.219','I63.22','I63.239','I63.30','I63.40','I63.50','I63.59')
and b.EventDateTime <= a.DPP4FillTime

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I63.019','I63.119','I63.139','I63.20','I63.219','I63.22','I63.239','I63.30','I63.40','I63.50','I63.59')
and b.PatientTransferDateTime <= a.DPP4FillTime

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I63.019','I63.119','I63.139','I63.20','I63.219','I63.22','I63.239','I63.30','I63.40','I63.50','I63.59')
and b.SpecialtyTransferDateTime <= a.DPP4FillTime

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I63.019','I63.119','I63.139','I63.20','I63.219','I63.22','I63.239','I63.30','I63.40','I63.50','I63.59')
and b.AdmitDateTime <= a.DPP4FillTime

select distinct scrssn from Dflt.Diabetes_AF_DPP4_Stroke  --79
select * from Dflt.Diabetes_AF_DPP4_Stroke
/* Prior Myocardial Infarction */
/*Making sure the ICD9 and ICD10 codes relevant to Myocardial Infarction are present in the Dimension table under CDWWork*/

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('I21.01','I21.02','I21.19','I21.29','I21.3','I21.4','I21.9','I22.0','I22.1','I22.8','I22.9',
																	'I23.0','I23.1','I23.2','I23.3','I23.4','I23.5','I23.6','I23.7','I23.8','I24.0','I24.1','I24.8')

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('410.00','410.01','410.02','410.10','410.11','410.12','410.30','410.31','410.32','410.20','410.21','410.22',
														'410.40','410.41','410.42','410.50','410.51','410.52','410.60','410.61','410.62','410.80','410.81','410.82',
														'410.90','410.91','410.92','410.70','410.71','410.72','429.79','411.81','411.0','411.89')

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime as comorbidity_Dischargedatetime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_AF_DPP4_MI

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('410.00','410.01','410.02','410.10','410.11','410.12','410.30','410.31','410.32','410.20','410.21','410.22',
														'410.40','410.41','410.42','410.50','410.51','410.52','410.60','410.61','410.62','410.80','410.81','410.82',
														'410.90','410.91','410.92','410.70','410.71','410.72','429.79','411.81','411.0','411.89')
					and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime , c.ICD9Code 

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('410.00','410.01','410.02','410.10','410.11','410.12','410.30','410.31','410.32','410.20','410.21','410.22',
														'410.40','410.41','410.42','410.50','410.51','410.52','410.60','410.61','410.62','410.80','410.81','410.82',
														'410.90','410.91','410.92','410.70','410.71','410.72','429.79','411.81','411.0','411.89')
					and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('410.00','410.01','410.02','410.10','410.11','410.12','410.30','410.31','410.32','410.20','410.21','410.22',
														'410.40','410.41','410.42','410.50','410.51','410.52','410.60','410.61','410.62','410.80','410.81','410.82',
														'410.90','410.91','410.92','410.70','410.71','410.72','429.79','411.81','411.0','411.89')
					and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('410.00','410.01','410.02','410.10','410.11','410.12','410.30','410.31','410.32','410.20','410.21','410.22',
														'410.40','410.41','410.42','410.50','410.51','410.52','410.60','410.61','410.62','410.80','410.81','410.82',
														'410.90','410.91','410.92','410.70','410.71','410.72','429.79','411.81','411.0','411.89')
					and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('410.00','410.01','410.02','410.10','410.11','410.12','410.30','410.31','410.32','410.20','410.21','410.22',
														'410.40','410.41','410.42','410.50','410.51','410.52','410.60','410.61','410.62','410.80','410.81','410.82',
														'410.90','410.91','410.92','410.70','410.71','410.72','429.79','411.81','411.0','411.89')
					and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('410.00','410.01','410.02','410.10','410.11','410.12','410.30','410.31','410.32','410.20','410.21','410.22',
														'410.40','410.41','410.42','410.50','410.51','410.52','410.60','410.61','410.62','410.80','410.81','410.82',
														'410.90','410.91','410.92','410.70','410.71','410.72','429.79','411.81','411.0','411.89')
					and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('410.00','410.01','410.02','410.10','410.11','410.12','410.30','410.31','410.32','410.20','410.21','410.22',
														'410.40','410.41','410.42','410.50','410.51','410.52','410.60','410.61','410.62','410.80','410.81','410.82',
														'410.90','410.91','410.92','410.70','410.71','410.72','429.79','411.81','411.0','411.89')
					and b.PatientTransferDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('410.00','410.01','410.02','410.10','410.11','410.12','410.30','410.31','410.32','410.20','410.21','410.22',
														'410.40','410.41','410.42','410.50','410.51','410.52','410.60','410.61','410.62','410.80','410.81','410.82',
														'410.90','410.91','410.92','410.70','410.71','410.72','429.79','411.81','411.0','411.89')
				and b.SpecialtyTransferDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('410.00','410.01','410.02','410.10','410.11','410.12','410.30','410.31','410.32','410.20','410.21','410.22',
					'410.40','410.41','410.42','410.50','410.51','410.52','410.60','410.61','410.62','410.80','410.81','410.82',
					'410.90','410.91','410.92','410.70','410.71','410.72','429.79','411.81','411.0','411.89')
					and b.AdmitDateTime <= a.DPP4FillTime
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I21.01','I21.02','I21.19','I21.29','I21.3','I21.4','I21.9','I22.0','I22.1','I22.8','I22.9',
					'I23.0','I23.1','I23.2','I23.3','I23.4','I23.5','I23.6','I23.7','I23.8','I24.0','I24.1','I24.8')
and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I21.01','I21.02','I21.19','I21.29','I21.3','I21.4','I21.9','I22.0','I22.1','I22.8','I22.9',
					'I23.0','I23.1','I23.2','I23.3','I23.4','I23.5','I23.6','I23.7','I23.8','I24.0','I24.1','I24.8')
and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I21.01','I21.02','I21.19','I21.29','I21.3','I21.4','I21.9','I22.0','I22.1','I22.8','I22.9',
					'I23.0','I23.1','I23.2','I23.3','I23.4','I23.5','I23.6','I23.7','I23.8','I24.0','I24.1','I24.8')
and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I21.01','I21.02','I21.19','I21.29','I21.3','I21.4','I21.9','I22.0','I22.1','I22.8','I22.9',
					'I23.0','I23.1','I23.2','I23.3','I23.4','I23.5','I23.6','I23.7','I23.8','I24.0','I24.1','I24.8')
and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I21.01','I21.02','I21.19','I21.29','I21.3','I21.4','I21.9','I22.0','I22.1','I22.8','I22.9',
					'I23.0','I23.1','I23.2','I23.3','I23.4','I23.5','I23.6','I23.7','I23.8','I24.0','I24.1','I24.8')
and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I21.01','I21.02','I21.19','I21.29','I21.3','I21.4','I21.9','I22.0','I22.1','I22.8','I22.9',
					'I23.0','I23.1','I23.2','I23.3','I23.4','I23.5','I23.6','I23.7','I23.8','I24.0','I24.1','I24.8')
and b.EventDateTime <= a.DPP4FillTime

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I21.01','I21.02','I21.19','I21.29','I21.3','I21.4','I21.9','I22.0','I22.1','I22.8','I22.9',
					'I23.0','I23.1','I23.2','I23.3','I23.4','I23.5','I23.6','I23.7','I23.8','I24.0','I24.1','I24.8')
and b.PatientTransferDateTime <= a.DPP4FillTime

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I21.01','I21.02','I21.19','I21.29','I21.3','I21.4','I21.9','I22.0','I22.1','I22.8','I22.9',
					'I23.0','I23.1','I23.2','I23.3','I23.4','I23.5','I23.6','I23.7','I23.8','I24.0','I24.1','I24.8')
and b.SpecialtyTransferDateTime <= a.DPP4FillTime

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I21.01','I21.02','I21.19','I21.29','I21.3','I21.4','I21.9','I22.0','I22.1','I22.8','I22.9',
					'I23.0','I23.1','I23.2','I23.3','I23.4','I23.5','I23.6','I23.7','I23.8','I24.0','I24.1','I24.8')
and b.AdmitDateTime <= a.DPP4FillTime

Select distinct scrssn from Dflt.Diabetes_AF_DPP4_MI --341
select * from Dflt.Diabetes_AF_DPP4_MI --1201

/*Ablation*/
/*Making sure the CPT codes relevant to Ablation are present in the Dimension table under CDWWork*/

select distinct CPTCode from CDWWork.Dim.CPT where CPTCode in ('93656','93657','93662','33254','33255','33258','33265','33266')

select distinct a.*

into Dflt.Diabetes_AF_DPP4_Ablation

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientCPTProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
Src.Cohort_CPT as c with (NOLOCK) on c.CPTSID=b.cptSID 
where c.cptcode in ('93656','93657','93662','33254','33255','33258','33265','33266')
and b.AdmitDateTime <= a.dpp4filltime
union all

select distinct a.*
from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_Vprocedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
Src.Cohort_CPT as c with (NOLOCK) on c.CPTSID=b.cptSID 
where c.cptcode in ('93656','93657','93662','33254','33255','33258','33265','33266')
and b.EventDateTime <= a.dpp4filltime
union all 

select distinct a.*
from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_VProcedure_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
Src.Cohort_CPT as c with (NOLOCK) on c.CPTSID=b.cptSID 
where c.cptcode in ('93656','93657','93662','33254','33255','33258','33265','33266')
and b.EventDateTime <= a.dpp4filltime
union all

select distinct a.*
from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Surg_SurgeryPrincipalAssociatedProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on b.OtherProcedureCPTSID=c.cptSID 
where c.cptcode in ('93656','93657','93662','33254','33255','33258','33265','33266') 
and b.SurgeryDateTime <= a.dpp4filltime
union all

select distinct a.*
from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Surg_SurgeryProcedureDiagnosisCode as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on b.PrincipalCPTSID=c.cptSID 
where c.cptcode in ('93656','93657','93662','33254','33255','33258','33265','33266')
and b.SurgeryDateTime <= a.dpp4filltime
union all

select distinct a.*
from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_VProcedureCPTModifier as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on b.CPTSID=c.cptSID 
where c.cptcode in ('93656','93657','93662','33254','33255','33258','33265','33266')
and b.VisitDateTime <= a.dpp4filltime
union all

select distinct a.*
from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_VProcedureDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on b.CPTSID=c.cptSID 
where c.cptcode in ('93656','93657','93662','33254','33255','33258','33265','33266')
and b.EventDateTime <= a.dpp4filltime
union all

select distinct a.*
from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on b.CPTSID=c.cptSID 
where c.cptcode in ('93656','93657','93662','33254','33255','33258','33265','33266')
and b.EventDateTime <= a.dpp4filltime
union all

select distinct a.*
from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVProcedureCPTModifier as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on  b.CPTSID=c.cptSID 
where c.cptcode in ('93656','93657','93662','33254','33255','33258','33265','33266')
and b.VisitDateTime <= a.dpp4filltime

select distinct scrssn from Dflt.Diabetes_AF_DPP4_Ablation --25

/* CAD */

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime as comorbidity_Dischargedatettime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_AF_DPP4_CAD

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('411.00''411.10','411.81','411.89','413.00','413.90','414.00','414.01','414.02','414.03','414.04',
'414.05','414.06','414.20','414.30','414.40','414.80','414.90','V45.81','V45.82')
					and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('411.00''411.10','411.81','411.89','413.00','413.90','414.00','414.01','414.02','414.03','414.04',
'414.05','414.06','414.20','414.30','414.40','414.80','414.90','V45.81','V45.82')
					and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('411.00''411.10','411.81','411.89','413.00','413.90','414.00','414.01','414.02','414.03','414.04',
'414.05','414.06','414.20','414.30','414.40','414.80','414.90','V45.81','V45.82')
					and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('411.00''411.10','411.81','411.89','413.00','413.90','414.00','414.01','414.02','414.03','414.04',
'414.05','414.06','414.20','414.30','414.40','414.80','414.90','V45.81','V45.82')
					and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('411.00''411.10','411.81','411.89','413.00','413.90','414.00','414.01','414.02','414.03','414.04',
'414.05','414.06','414.20','414.30','414.40','414.80','414.90','V45.81','V45.82')
					and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('411.00''411.10','411.81','411.89','413.00','413.90','414.00','414.01','414.02','414.03','414.04',
'414.05','414.06','414.20','414.30','414.40','414.80','414.90','V45.81','V45.82')
					and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('411.00''411.10','411.81','411.89','413.00','413.90','414.00','414.01','414.02','414.03','414.04',
'414.05','414.06','414.20','414.30','414.40','414.80','414.90','V45.81','V45.82')
					and b.PatientTransferDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('411.00''411.10','411.81','411.89','413.00','413.90','414.00','414.01','414.02','414.03','414.04',
'414.05','414.06','414.20','414.30','414.40','414.80','414.90','V45.81','V45.82')
					and b.SpecialtyTransferDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('411.00''411.10','411.81','411.89','413.00','413.90','414.00','414.01','414.02','414.03','414.04',
'414.05','414.06','414.20','414.30','414.40','414.80','414.90','V45.81','V45.82')
					and b.AdmitDateTime <= a.DPP4FillTime
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I24.1','I20.0','I24.0','I24.8','I28.0','I20.8','I20.9','I25.0','I25.10','I25.810','I25.811',
'I25.82','I25.83','I25.84','I25.5','I25.9','I25.89','Z95.1','Z98.61')
and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I24.1','I20.0','I24.0','I24.8','I28.0','I20.8','I20.9','I25.0','I25.10','I25.810','I25.811',
'I25.82','I25.83','I25.84','I25.5','I25.9','I25.89','Z95.1','Z98.61')
and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I24.1','I20.0','I24.0','I24.8','I28.0','I20.8','I20.9','I25.0','I25.10','I25.810','I25.811',
'I25.82','I25.83','I25.84','I25.5','I25.9','I25.89','Z95.1','Z98.61')
and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I24.1','I20.0','I24.0','I24.8','I28.0','I20.8','I20.9','I25.0','I25.10','I25.810','I25.811',
'I25.82','I25.83','I25.84','I25.5','I25.9','I25.89','Z95.1','Z98.61')
and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I24.1','I20.0','I24.0','I24.8','I28.0','I20.8','I20.9','I25.0','I25.10','I25.810','I25.811',
'I25.82','I25.83','I25.84','I25.5','I25.9','I25.89','Z95.1','Z98.61')
and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I24.1','I20.0','I24.0','I24.8','I28.0','I20.8','I20.9','I25.0','I25.10','I25.810','I25.811',
'I25.82','I25.83','I25.84','I25.5','I25.9','I25.89','Z95.1','Z98.61')
and b.EventDateTime <= a.DPP4FillTime

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I24.1','I20.0','I24.0','I24.8','I28.0','I20.8','I20.9','I25.0','I25.10','I25.810','I25.811',
'I25.82','I25.83','I25.84','I25.5','I25.9','I25.89','Z95.1','Z98.61')
and b.PatientTransferDateTime <= a.DPP4FillTime

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I24.1','I20.0','I24.0','I24.8','I28.0','I20.8','I20.9','I25.0','I25.10','I25.810','I25.811',
'I25.82','I25.83','I25.84','I25.5','I25.9','I25.89','Z95.1','Z98.61')
and b.SpecialtyTransferDateTime <= a.DPP4FillTime

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I24.1','I20.0','I24.0','I24.8','I28.0','I20.8','I20.9','I25.0','I25.10','I25.810','I25.811',
'I25.82','I25.83','I25.84','I25.5','I25.9','I25.89','Z95.1','Z98.61')
and b.AdmitDateTime <= a.DPP4FillTime

select distinct scrssn from Dflt.Diabetes_AF_DPP4_CAD --1214
select * from Dflt.Diabetes_AF_DPP4_CAD

/* CAD- PCI & CABG */

select a.*, b.SURGDATE

into #tempCABGDPP4

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
src.VASQIP_nso_cardiac as b with (NOLOCK) on a.scrssn= b.scrssn
where b.cpt01 in ('33533','33534','33535','33536','33542','33545','33548')
and b.SURGDATE <= a.dpp4filltime /* Check the dates */

select a.*, b.ProcedureDateTime

into #tempPCIDPP4

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.CART_PCI as b with (NOLOCK) on a.PatientSID= b.PatientSID
where b.ProcedureDateTime <= a.dpp4filltime /* Check the dates */

Select distinct patientsid, scrssn, DPP4FillTime, surgdate

into Dflt.Diabetes_AF_DPP4_cadCabgpci

from #tempCABGDPP4
union all

select distinct patientsid, scrssn, DPP4FillTime, ProcedureDateTime
from #tempPCIDPP4
union all 

select distinct patientsid, scrssn, DPP4FillTime, comorbidity_Dischargedatettime
from Dflt.Diabetes_AF_DPP4_CAD

select distinct scrssn from Dflt.Diabetes_AF_DPP4_cadCabgpci --1218

/*PAD */

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime as comorbidity_Dischargedatettime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_AF_DPP4_PAD

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('440.0','440.0','440.1','440.2','440.20','440.21','440.22','440.23','440.24','440.29','440.30',
                    '440.31','440.32','440.4','440.8','440.9','441.0','441.00','441.01','441.02','441.03','441.1','441.2',
					'441.3','441.4','441.5','441.6','441.7','441.9','442.0','442.1','442.2','442.3','442.81','442.82',
					'442.83','442.84','442.89','442.9','443.0','443.1','443.21','443.22','443.23','443.24','443.29')
					and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('440.0','440.0','440.1','440.2','440.20','440.21','440.22','440.23','440.24','440.29','440.30',
                    '440.31','440.32','440.4','440.8','440.9','441.0','441.00','441.01','441.02','441.03','441.1','441.2',
					'441.3','441.4','441.5','441.6','441.7','441.9','442.0','442.1','442.2','442.3','442.81','442.82',
					'442.83','442.84','442.89','442.9','443.0','443.1','443.21','443.22','443.23','443.24','443.29')
					and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('440.0','440.0','440.1','440.2','440.20','440.21','440.22','440.23','440.24','440.29','440.30',
                    '440.31','440.32','440.4','440.8','440.9','441.0','441.00','441.01','441.02','441.03','441.1','441.2',
					'441.3','441.4','441.5','441.6','441.7','441.9','442.0','442.1','442.2','442.3','442.81','442.82',
					'442.83','442.84','442.89','442.9','443.0','443.1','443.21','443.22','443.23','443.24','443.29')
					and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('440.0','440.0','440.1','440.2','440.20','440.21','440.22','440.23','440.24','440.29','440.30',
                    '440.31','440.32','440.4','440.8','440.9','441.0','441.00','441.01','441.02','441.03','441.1','441.2',
					'441.3','441.4','441.5','441.6','441.7','441.9','442.0','442.1','442.2','442.3','442.81','442.82',
					'442.83','442.84','442.89','442.9','443.0','443.1','443.21','443.22','443.23','443.24','443.29')
					and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('440.0','440.0','440.1','440.2','440.20','440.21','440.22','440.23','440.24','440.29','440.30',
                    '440.31','440.32','440.4','440.8','440.9','441.0','441.00','441.01','441.02','441.03','441.1','441.2',
					'441.3','441.4','441.5','441.6','441.7','441.9','442.0','442.1','442.2','442.3','442.81','442.82',
					'442.83','442.84','442.89','442.9','443.0','443.1','443.21','443.22','443.23','443.24','443.29')
					and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('440.0','440.0','440.1','440.2','440.20','440.21','440.22','440.23','440.24','440.29','440.30',
                    '440.31','440.32','440.4','440.8','440.9','441.0','441.00','441.01','441.02','441.03','441.1','441.2',
					'441.3','441.4','441.5','441.6','441.7','441.9','442.0','442.1','442.2','442.3','442.81','442.82',
					'442.83','442.84','442.89','442.9','443.0','443.1','443.21','443.22','443.23','443.24','443.29')
					and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('440.0','440.0','440.1','440.2','440.20','440.21','440.22','440.23','440.24','440.29','440.30',
                    '440.31','440.32','440.4','440.8','440.9','441.0','441.00','441.01','441.02','441.03','441.1','441.2',
					'441.3','441.4','441.5','441.6','441.7','441.9','442.0','442.1','442.2','442.3','442.81','442.82',
					'442.83','442.84','442.89','442.9','443.0','443.1','443.21','443.22','443.23','443.24','443.29')
					and b.PatientTransferDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('440.0','440.0','440.1','440.2','440.20','440.21','440.22','440.23','440.24','440.29','440.30',
                    '440.31','440.32','440.4','440.8','440.9','441.0','441.00','441.01','441.02','441.03','441.1','441.2',
					'441.3','441.4','441.5','441.6','441.7','441.9','442.0','442.1','442.2','442.3','442.81','442.82',
					'442.83','442.84','442.89','442.9','443.0','443.1','443.21','443.22','443.23','443.24','443.29')
					and b.SpecialtyTransferDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('440.0','440.0','440.1','440.2','440.20','440.21','440.22','440.23','440.24','440.29','440.30',
                    '440.31','440.32','440.4','440.8','440.9','441.0','441.00','441.01','441.02','441.03','441.1','441.2',
					'441.3','441.4','441.5','441.6','441.7','441.9','442.0','442.1','442.2','442.3','442.81','442.82',
					'442.83','442.84','442.89','442.9','443.0','443.1','443.21','443.22','443.23','443.24','443.29')
					and b.AdmitDateTime <= a.DPP4FillTime
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I70.0','I70.1','I70.209','I70.219','I70.229','I70.25','I70.269','I70.299','I70.399','I70.499','I70.599','I70.92','I70.8','I70.90',
                    'I71.00','I71.01','I71.02','I71.03','I71.1','I71.2','I71.3','I71.4','I71.5','I71.6','I71.8','I71.9','I72.0','I72.1','I72.2','I72.3',
					'I72.4','I72.5','I72.6','I72.8','I72.9','I73.00','I73.01','I73.1','I73.81','I73.89','I73.9','I77.1','I77.71','I77.72','I77.73','I77.74',
					'I77.75','I77.76','I77.77','I77.79','I79.8','K55.1','K55.9','Z95.828')
and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I70.0','I70.1','I70.209','I70.219','I70.229','I70.25','I70.269','I70.299','I70.399','I70.499','I70.599','I70.92','I70.8','I70.90',
                    'I71.00','I71.01','I71.02','I71.03','I71.1','I71.2','I71.3','I71.4','I71.5','I71.6','I71.8','I71.9','I72.0','I72.1','I72.2','I72.3',
					'I72.4','I72.5','I72.6','I72.8','I72.9','I73.00','I73.01','I73.1','I73.81','I73.89','I73.9','I77.1','I77.71','I77.72','I77.73','I77.74',
					'I77.75','I77.76','I77.77','I77.79','I79.8','K55.1','K55.9','Z95.828')
and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I70.0','I70.1','I70.209','I70.219','I70.229','I70.25','I70.269','I70.299','I70.399','I70.499','I70.599','I70.92','I70.8','I70.90',
                    'I71.00','I71.01','I71.02','I71.03','I71.1','I71.2','I71.3','I71.4','I71.5','I71.6','I71.8','I71.9','I72.0','I72.1','I72.2','I72.3',
					'I72.4','I72.5','I72.6','I72.8','I72.9','I73.00','I73.01','I73.1','I73.81','I73.89','I73.9','I77.1','I77.71','I77.72','I77.73','I77.74',
					'I77.75','I77.76','I77.77','I77.79','I79.8','K55.1','K55.9','Z95.828')
and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I70.0','I70.1','I70.209','I70.219','I70.229','I70.25','I70.269','I70.299','I70.399','I70.499','I70.599','I70.92','I70.8','I70.90',
                    'I71.00','I71.01','I71.02','I71.03','I71.1','I71.2','I71.3','I71.4','I71.5','I71.6','I71.8','I71.9','I72.0','I72.1','I72.2','I72.3',
					'I72.4','I72.5','I72.6','I72.8','I72.9','I73.00','I73.01','I73.1','I73.81','I73.89','I73.9','I77.1','I77.71','I77.72','I77.73','I77.74',
					'I77.75','I77.76','I77.77','I77.79','I79.8','K55.1','K55.9','Z95.828')
and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I70.0','I70.1','I70.209','I70.219','I70.229','I70.25','I70.269','I70.299','I70.399','I70.499','I70.599','I70.92','I70.8','I70.90',
                    'I71.00','I71.01','I71.02','I71.03','I71.1','I71.2','I71.3','I71.4','I71.5','I71.6','I71.8','I71.9','I72.0','I72.1','I72.2','I72.3',
					'I72.4','I72.5','I72.6','I72.8','I72.9','I73.00','I73.01','I73.1','I73.81','I73.89','I73.9','I77.1','I77.71','I77.72','I77.73','I77.74',
					'I77.75','I77.76','I77.77','I77.79','I79.8','K55.1','K55.9','Z95.828')
and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I70.0','I70.1','I70.209','I70.219','I70.229','I70.25','I70.269','I70.299','I70.399','I70.499','I70.599','I70.92','I70.8','I70.90',
                    'I71.00','I71.01','I71.02','I71.03','I71.1','I71.2','I71.3','I71.4','I71.5','I71.6','I71.8','I71.9','I72.0','I72.1','I72.2','I72.3',
					'I72.4','I72.5','I72.6','I72.8','I72.9','I73.00','I73.01','I73.1','I73.81','I73.89','I73.9','I77.1','I77.71','I77.72','I77.73','I77.74',
					'I77.75','I77.76','I77.77','I77.79','I79.8','K55.1','K55.9','Z95.828')
and b.EventDateTime <= a.DPP4FillTime

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I70.0','I70.1','I70.209','I70.219','I70.229','I70.25','I70.269','I70.299','I70.399','I70.499','I70.599','I70.92','I70.8','I70.90',
                    'I71.00','I71.01','I71.02','I71.03','I71.1','I71.2','I71.3','I71.4','I71.5','I71.6','I71.8','I71.9','I72.0','I72.1','I72.2','I72.3',
					'I72.4','I72.5','I72.6','I72.8','I72.9','I73.00','I73.01','I73.1','I73.81','I73.89','I73.9','I77.1','I77.71','I77.72','I77.73','I77.74',
					'I77.75','I77.76','I77.77','I77.79','I79.8','K55.1','K55.9','Z95.828')
and b.PatientTransferDateTime <= a.DPP4FillTime

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I70.0','I70.1','I70.209','I70.219','I70.229','I70.25','I70.269','I70.299','I70.399','I70.499','I70.599','I70.92','I70.8','I70.90',
                    'I71.00','I71.01','I71.02','I71.03','I71.1','I71.2','I71.3','I71.4','I71.5','I71.6','I71.8','I71.9','I72.0','I72.1','I72.2','I72.3',
					'I72.4','I72.5','I72.6','I72.8','I72.9','I73.00','I73.01','I73.1','I73.81','I73.89','I73.9','I77.1','I77.71','I77.72','I77.73','I77.74',
					'I77.75','I77.76','I77.77','I77.79','I79.8','K55.1','K55.9','Z95.828')
and b.SpecialtyTransferDateTime <= a.DPP4FillTime

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I70.0','I70.1','I70.209','I70.219','I70.229','I70.25','I70.269','I70.299','I70.399','I70.499','I70.599','I70.92','I70.8','I70.90',
                    'I71.00','I71.01','I71.02','I71.03','I71.1','I71.2','I71.3','I71.4','I71.5','I71.6','I71.8','I71.9','I72.0','I72.1','I72.2','I72.3',
					'I72.4','I72.5','I72.6','I72.8','I72.9','I73.00','I73.01','I73.1','I73.81','I73.89','I73.9','I77.1','I77.71','I77.72','I77.73','I77.74',
					'I77.75','I77.76','I77.77','I77.79','I79.8','K55.1','K55.9','Z95.828')
and b.AdmitDateTime <= a.DPP4FillTime

select distinct scrssn from Dflt.Diabetes_AF_DPP4_PAD --329
select * from Dflt.Diabetes_AF_DPP4_PAD

/*Cardioversion*/
/*Making sure the CPT codes relevant to Ablation are present in the Dimension table under CDWWork*/

select distinct CPTCode from CDWWork.Dim.CPT where CPTCode in ('92961','92962')

select distinct a.*

into Dflt.Diabetes_AF_DPP4_Cardioversion

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientCPTProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
Src.Cohort_CPT as c with (NOLOCK) on c.CPTSID=b.cptSID 
where c.cptcode in ('92961','92962')
and b.AdmitDateTime <= a.dpp4filltime
union all

select distinct a.*
from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_Vprocedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
Src.Cohort_CPT as c with (NOLOCK) on c.CPTSID=b.cptSID 
where c.cptcode in ('92961','92962')
and b.EventDateTime <= a.dpp4filltime
union all 

select distinct a.*
from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_VProcedure_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
Src.Cohort_CPT as c with (NOLOCK) on c.CPTSID=b.cptSID 
where c.cptcode in ('92961','92962')
and b.EventDateTime <= a.dpp4filltime
union all

select distinct a.*
from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Surg_SurgeryPrincipalAssociatedProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on b.OtherProcedureCPTSID=c.cptSID 
where c.cptcode in ('92961','92962') 
and b.SurgeryDateTime <= a.dpp4filltime
union all

select distinct a.*
from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Surg_SurgeryProcedureDiagnosisCode as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on b.PrincipalCPTSID=c.cptSID 
where c.cptcode in ('92961','92962')
and b.SurgeryDateTime <= a.dpp4filltime
union all

select distinct a.*
from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_VProcedureCPTModifier as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on b.CPTSID=c.cptSID 
where c.cptcode in ('92961','92962')
and b.VisitDateTime <= a.dpp4filltime
union all

select distinct a.*
from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_VProcedureDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on b.CPTSID=c.cptSID 
where c.cptcode in ('93656','93657','93662','33254','33255','33258','33265','33266')
and b.EventDateTime <= a.dpp4filltime
union all

select distinct a.*
from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on b.CPTSID=c.cptSID 
where c.cptcode in ('92961','92962')
and b.EventDateTime <= a.dpp4filltime
union all

select distinct a.*
from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVProcedureCPTModifier as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on  b.CPTSID=c.cptSID 
where c.cptcode in ('92961','92962')
and b.VisitDateTime <= a.dpp4filltime

select * from Src.distinct_CPTCodes where ProcCode in ('92961','92962')

select distinct scrssn from Dflt.Diabetes_AF_DPP4_Cardioversion--0

/* Cardioversion Proc codes */

select distinct ICD9ProcedureCode from CDWWork.Dim.ICD9Procedure where ICD9ProcedureCode in ('99.61','99.62') 
select distinct ICD10ProcedureCode from CDWWork.Dim.ICD10Procedure where ICD10ProcedureCode in ('5A2204Z') 

select distinct a.*, b.ICDProcedureDateTime, c.ICD9ProcedureCode
/*ICD9Procedure Codes*/

into Dflt.Diabetes_AF_DPP4_Cardioversion

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_CensusICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('99.61','99.62')
					and b.ICDProcedureDateTime <= a.DPP4Filltime
union all

select distinct a.*, b.SurgicalProcedureDateTime, c.ICD9ProcedureCode

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_CensusSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('99.61','99.62')
					and b.SurgicalProcedureDateTime <= a.DPP4Filltime
union all

select distinct a.*, b.DischargeDateTime, c.ICD9ProcedureCode

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('99.61','99.62')
					and b.DischargeDateTime <= a.DPP4Filltime
union all

select distinct a.*, b.DischargeDateTime, c.ICD9ProcedureCode

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('99.61','99.62')
					and b.DischargeDateTime <= a.DPP4Filltime
union all

/*ICD10Procedure Codes*/
select distinct a.*, b.ICDProcedureDateTime, c.ICD10ProcedureCode

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_CensusICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('5A2204Z')
and b.ICDProcedureDateTime <= a.DPP4Filltime
union all

select distinct a.*, b.SurgicalProcedureDateTime, c.ICD10ProcedureCode

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_CensusSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('5A2204Z')
and b.SurgicalProcedureDateTime <= a.DPP4Filltime
union all

select distinct a.*, b.DischargeDateTime, c.ICD10ProcedureCode

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('5A2204Z')
and b.DischargeDateTime <= a.DPP4Filltime
union all

select distinct a.*, b.DischargeDateTime, c.ICD10ProcedureCode

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('5A2204Z')
and b.DischargeDateTime <= a.DPP4Filltime

select distinct scrssn from Dflt.Diabetes_AF_DPP4_Cardioversion --317

/* Ablation Proc codes */

select distinct ICD9ProcedureCode from CDWWork.Dim.ICD9Procedure where ICD9ProcedureCode in ('37.33','37.34','37.37','37.80','38.65') 
select distinct ICD10ProcedureCode from CDWWork.Dim.ICD10Procedure where ICD10ProcedureCode in ('02560ZZ','02563ZZ','02564ZZ',
'02570ZZ','02573ZZ','02574ZZ','02580ZZ','02583ZZ','02584ZZ','025S0ZZ','025S3ZZ','025S4ZZ','025T0ZZ','025T3ZZ','025T4ZZ') 

select distinct a.*, b.ICDProcedureDateTime, c.ICD9ProcedureCode
/*ICD9Procedure Codes*/

into Dflt.Diabetes_AF_DPP4_AbProc

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_CensusICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('37.33','37.34','37.37','37.80','38.65')
					and b.ICDProcedureDateTime <= a.DPP4Filltime
union all

select distinct a.*, b.SurgicalProcedureDateTime, c.ICD9ProcedureCode

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_CensusSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('37.33','37.34','37.37','37.80','38.65')
					and b.SurgicalProcedureDateTime <= a.DPP4Filltime
union all

select distinct a.*, b.DischargeDateTime, c.ICD9ProcedureCode

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('37.33','37.34','37.37','37.80','38.65')
					and b.DischargeDateTime <= a.DPP4Filltime
union all

select distinct a.*, b.DischargeDateTime, c.ICD9ProcedureCode

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('37.33','37.34','37.37','37.80','38.65')
					and b.DischargeDateTime <= a.DPP4Filltime
union all

/*ICD10Procedure Codes*/
select distinct a.*, b.ICDProcedureDateTime, c.ICD10ProcedureCode

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_CensusICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('02560ZZ','02563ZZ','02564ZZ',
'02570ZZ','02573ZZ','02574ZZ','02580ZZ','02583ZZ','02584ZZ','025S0ZZ','025S3ZZ','025S4ZZ','025T0ZZ','025T3ZZ','025T4ZZ')
and b.ICDProcedureDateTime <= a.DPP4Filltime
union all

select distinct a.*, b.SurgicalProcedureDateTime, c.ICD10ProcedureCode

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_CensusSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('02560ZZ','02563ZZ','02564ZZ',
'02570ZZ','02573ZZ','02574ZZ','02580ZZ','02583ZZ','02584ZZ','025S0ZZ','025S3ZZ','025S4ZZ','025T0ZZ','025T3ZZ','025T4ZZ')
and b.SurgicalProcedureDateTime <= a.DPP4Filltime
union all

select distinct a.*, b.DischargeDateTime, c.ICD10ProcedureCode

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('02560ZZ','02563ZZ','02564ZZ',
'02570ZZ','02573ZZ','02574ZZ','02580ZZ','02583ZZ','02584ZZ','025S0ZZ','025S3ZZ','025S4ZZ','025T0ZZ','025T3ZZ','025T4ZZ')
and b.DischargeDateTime <= a.DPP4Filltime
union all

select distinct a.*, b.DischargeDateTime, c.ICD10ProcedureCode

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('02560ZZ','02563ZZ','02564ZZ',
'02570ZZ','02573ZZ','02574ZZ','02580ZZ','02583ZZ','02584ZZ','025S0ZZ','025S3ZZ','025S4ZZ','025T0ZZ','025T3ZZ','025T4ZZ')
and b.DischargeDateTime <= a.DPP4Filltime

select distinct scrssn from Dflt.Diabetes_AF_DPP4_AbProc --104
select * from Dflt.Diabetes_AF_DPP4_AbProc --1017

/*Depression */
/*Making sure the ICD9 and ICD10 codes relevant to depression are present in the Dimension table under CDWWork*/

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('296.20','296.22','296.23','296.30','296.32','296.33','300.00','311.','300.4','301.12','309.0','309.1')

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('F32.9','F32.1','F32.2','F33.1','F33.2','F41.9','F34.1','F43.21')

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime as comorbidity_Dischargedatettime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_AF_DPP4_Depression

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('296.20','296.22','296.23','296.30','296.32','296.33','300.00','311.','300.4','301.12','309.0','309.1')
					and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('296.20','296.22','296.23','296.30','296.32','296.33','300.00','311.','300.4','301.12','309.0','309.1')
					and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('296.20','296.22','296.23','296.30','296.32','296.33','300.00','311.','300.4','301.12','309.0','309.1')
					and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('296.20','296.22','296.23','296.30','296.32','296.33','300.00','311.','300.4','301.12','309.0','309.1')
					and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('296.20','296.22','296.23','296.30','296.32','296.33','300.00','311.','300.4','301.12','309.0','309.1')
					and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('296.20','296.22','296.23','296.30','296.32','296.33','300.00','311.','300.4','301.12','309.0','309.1')
					and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('296.20','296.22','296.23','296.30','296.32','296.33','300.00','311.','300.4','301.12','309.0','309.1')
					and b.PatientTransferDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('296.20','296.22','296.23','296.30','296.32','296.33','300.00','311.','300.4','301.12','309.0','309.1')
					and b.SpecialtyTransferDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('296.20','296.22','296.23','296.30','296.32','296.33','300.00','311.','300.4','301.12','309.0','309.1')
					and b.AdmitDateTime <= a.DPP4FillTime
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F32.9','F32.1','F32.2','F33.1','F33.2','F41.9','F34.1','F43.21') 
and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F32.9','F32.1','F32.2','F33.1','F33.2','F41.9','F34.1','F43.21') 
and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F32.9','F32.1','F32.2','F33.1','F33.2','F41.9','F34.1','F43.21') 
and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F32.9','F32.1','F32.2','F33.1','F33.2','F41.9','F34.1','F43.21') 
and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F32.9','F32.1','F32.2','F33.1','F33.2','F41.9','F34.1','F43.21') 
and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F32.9','F32.1','F32.2','F33.1','F33.2','F41.9','F34.1','F43.21') 
and b.EventDateTime <= a.DPP4FillTime

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F32.9','F32.1','F32.2','F33.1','F33.2','F41.9','F34.1','F43.21') 
and b.PatientTransferDateTime <= a.DPP4FillTime

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F32.9','F32.1','F32.2','F33.1','F33.2','F41.9','F34.1','F43.21') 
and b.SpecialtyTransferDateTime <= a.DPP4FillTime

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F32.9','F32.1','F32.2','F33.1','F33.2','F41.9','F34.1','F43.21') 
and b.AdmitDateTime <= a.DPP4FillTime

select distinct scrssn from Dflt.Diabetes_AF_DPP4_Depression --669
select * from Dflt.Diabetes_AF_DPP4_Depression--3799

/* COPD Chronic Obstructive Pulmonary Disease*/
/*Making sure the ICD9 and ICD10 codes relevant to COPD are present in the Dimension table under CDWWork*/

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('490.','491.0','491.1','491.2','491.20','491.21','491.22','491.8','491.9','492.0','492.8',
'493.00','493.01','493.02','493.10','493.11','493.12','493.20','493.21','493.22','493.81','493.82','493.90','493.91','493.92',
'494.','494.0','494.1','495.0','495.1','495.2','495.3','495.4','495.5','495.6','495.7','495.8','495.9','496.')

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('J40.','J41.0','J41.1','J41.8','J42.','J43.9','J44.0','J44.1','J44.9',
'J45.20','J45.22','J45.21','J45.990','J45.991','J45.909','J45.998','J45.902','J45.901','J47.9','J47.1',
'J67.0','J67.1','J67.2','J67.3','J67.4','J67.5','J67.6','J67.7','J67.8','J67.9')

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime as comorbidity_Dischargedatettime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_AF_DPP4_COPD

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('490.','491.0','491.1','491.2','491.20','491.21','491.22','491.8','491.9','492.0','492.8',
'493.00','493.01','493.02','493.10','493.11','493.12','493.20','493.21','493.22','493.81','493.82','493.90','493.91','493.92',
'494.','494.0','494.1','495.0','495.1','495.2','495.3','495.4','495.5','495.6','495.7','495.8','495.9','496.')
					and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('490.','491.0','491.1','491.2','491.20','491.21','491.22','491.8','491.9','492.0','492.8',
'493.00','493.01','493.02','493.10','493.11','493.12','493.20','493.21','493.22','493.81','493.82','493.90','493.91','493.92',
'494.','494.0','494.1','495.0','495.1','495.2','495.3','495.4','495.5','495.6','495.7','495.8','495.9','496.')
					and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('490.','491.0','491.1','491.2','491.20','491.21','491.22','491.8','491.9','492.0','492.8',
'493.00','493.01','493.02','493.10','493.11','493.12','493.20','493.21','493.22','493.81','493.82','493.90','493.91','493.92',
'494.','494.0','494.1','495.0','495.1','495.2','495.3','495.4','495.5','495.6','495.7','495.8','495.9','496.')
					and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('490.','491.0','491.1','491.2','491.20','491.21','491.22','491.8','491.9','492.0','492.8',
'493.00','493.01','493.02','493.10','493.11','493.12','493.20','493.21','493.22','493.81','493.82','493.90','493.91','493.92',
'494.','494.0','494.1','495.0','495.1','495.2','495.3','495.4','495.5','495.6','495.7','495.8','495.9','496.')
					and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('490.','491.0','491.1','491.2','491.20','491.21','491.22','491.8','491.9','492.0','492.8',
'493.00','493.01','493.02','493.10','493.11','493.12','493.20','493.21','493.22','493.81','493.82','493.90','493.91','493.92',
'494.','494.0','494.1','495.0','495.1','495.2','495.3','495.4','495.5','495.6','495.7','495.8','495.9','496.')
					and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('490.','491.0','491.1','491.2','491.20','491.21','491.22','491.8','491.9','492.0','492.8',
'493.00','493.01','493.02','493.10','493.11','493.12','493.20','493.21','493.22','493.81','493.82','493.90','493.91','493.92',
'494.','494.0','494.1','495.0','495.1','495.2','495.3','495.4','495.5','495.6','495.7','495.8','495.9','496.')
					and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('490.','491.0','491.1','491.2','491.20','491.21','491.22','491.8','491.9','492.0','492.8',
'493.00','493.01','493.02','493.10','493.11','493.12','493.20','493.21','493.22','493.81','493.82','493.90','493.91','493.92',
'494.','494.0','494.1','495.0','495.1','495.2','495.3','495.4','495.5','495.6','495.7','495.8','495.9','496.')
					and b.PatientTransferDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('490.','491.0','491.1','491.2','491.20','491.21','491.22','491.8','491.9','492.0','492.8',
'493.00','493.01','493.02','493.10','493.11','493.12','493.20','493.21','493.22','493.81','493.82','493.90','493.91','493.92',
'494.','494.0','494.1','495.0','495.1','495.2','495.3','495.4','495.5','495.6','495.7','495.8','495.9','496.')
					and b.SpecialtyTransferDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('490.','491.0','491.1','491.2','491.20','491.21','491.22','491.8','491.9','492.0','492.8',
'493.00','493.01','493.02','493.10','493.11','493.12','493.20','493.21','493.22','493.81','493.82','493.90','493.91','493.92',
'494.','494.0','494.1','495.0','495.1','495.2','495.3','495.4','495.5','495.6','495.7','495.8','495.9','496.')
					and b.AdmitDateTime <= a.DPP4FillTime
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F20.0','F20.1','F20.2','F20.3','F20.81','F20.89','F20.9','F25.9')
and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('J40.','J41.0','J41.1','J41.8','J42.','J43.9','J44.0','J44.1','J44.9',
'J45.20','J45.22','J45.21','J45.990','J45.991','J45.909','J45.998','J45.902','J45.901','J47.9','J47.1',
'J67.0','J67.1','J67.2','J67.3','J67.4','J67.5','J67.6','J67.7','J67.8','J67.9')
and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('J40.','J41.0','J41.1','J41.8','J42.','J43.9','J44.0','J44.1','J44.9',
'J45.20','J45.22','J45.21','J45.990','J45.991','J45.909','J45.998','J45.902','J45.901','J47.9','J47.1',
'J67.0','J67.1','J67.2','J67.3','J67.4','J67.5','J67.6','J67.7','J67.8','J67.9')
and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('J40.','J41.0','J41.1','J41.8','J42.','J43.9','J44.0','J44.1','J44.9',
'J45.20','J45.22','J45.21','J45.990','J45.991','J45.909','J45.998','J45.902','J45.901','J47.9','J47.1',
'J67.0','J67.1','J67.2','J67.3','J67.4','J67.5','J67.6','J67.7','J67.8','J67.9')
and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('J40.','J41.0','J41.1','J41.8','J42.','J43.9','J44.0','J44.1','J44.9',
'J45.20','J45.22','J45.21','J45.990','J45.991','J45.909','J45.998','J45.902','J45.901','J47.9','J47.1',
'J67.0','J67.1','J67.2','J67.3','J67.4','J67.5','J67.6','J67.7','J67.8','J67.9')
and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('J40.','J41.0','J41.1','J41.8','J42.','J43.9','J44.0','J44.1','J44.9',
'J45.20','J45.22','J45.21','J45.990','J45.991','J45.909','J45.998','J45.902','J45.901','J47.9','J47.1',
'J67.0','J67.1','J67.2','J67.3','J67.4','J67.5','J67.6','J67.7','J67.8','J67.9')
and b.EventDateTime <= a.DPP4FillTime

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('J40.','J41.0','J41.1','J41.8','J42.','J43.9','J44.0','J44.1','J44.9',
'J45.20','J45.22','J45.21','J45.990','J45.991','J45.909','J45.998','J45.902','J45.901','J47.9','J47.1',
'J67.0','J67.1','J67.2','J67.3','J67.4','J67.5','J67.6','J67.7','J67.8','J67.9')
and b.PatientTransferDateTime <= a.DPP4FillTime

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('J40.','J41.0','J41.1','J41.8','J42.','J43.9','J44.0','J44.1','J44.9',
'J45.20','J45.22','J45.21','J45.990','J45.991','J45.909','J45.998','J45.902','J45.901','J47.9','J47.1',
'J67.0','J67.1','J67.2','J67.3','J67.4','J67.5','J67.6','J67.7','J67.8','J67.9')
and b.SpecialtyTransferDateTime <= a.DPP4FillTime

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('J40.','J41.0','J41.1','J41.8','J42.','J43.9','J44.0','J44.1','J44.9',
'J45.20','J45.22','J45.21','J45.990','J45.991','J45.909','J45.998','J45.902','J45.901','J47.9','J47.1',
'J67.0','J67.1','J67.2','J67.3','J67.4','J67.5','J67.6','J67.7','J67.8','J67.9')
and b.AdmitDateTime <= a.DPP4FillTime

select distinct scrssn from Dflt.Diabetes_AF_DPP4_COPD --861
select * from Dflt.Diabetes_AF_DPP4_COPD --5690

/* Chronic Liver Disease */
/*Making sure the ICD9 and ICD10 codes relevant to CLD are present in the Dimension table under CDWWork*/

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('B18.0','B18.1','B18.2','I85.00','I85.01','I85.10','I85.11','K70.0','K70.30','K70.9','K73.0','K73.2','K73.8','K73.9',
													'K75.4','K74.0','K74.60','K74.69','K74.3','K74.4','K74.5','K74.1','K76.0','K76.89','K76.9','K76.6','K72.10','K72.90','Z94.4')

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('070.22','070.32','070.23','070.33','070.44','070.54','456.1','456.0','456.21','456.20','571.0','571.2','571.3',
												'571.41','571.49','571.40','571.42','571.5','571.9','571.6','571.8','572.3','572.8','V42.7')

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime as comorbidity_Dischargedatettime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_AF_DPP4_LiverDisease

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('070.22','070.32','070.23','070.33','070.44','070.54','456.1','456.0','456.21','456.20','571.0','571.2','571.3',
					'571.41','571.49','571.40','571.42','571.5','571.9','571.6','571.8','572.3','572.8','V42.7')
					and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('070.22','070.32','070.23','070.33','070.44','070.54','456.1','456.0','456.21','456.20','571.0','571.2','571.3',
					'571.41','571.49','571.40','571.42','571.5','571.9','571.6','571.8','572.3','572.8','V42.7')
					and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('070.22','070.32','070.23','070.33','070.44','070.54','456.1','456.0','456.21','456.20','571.0','571.2','571.3',
					'571.41','571.49','571.40','571.42','571.5','571.9','571.6','571.8','572.3','572.8','V42.7')
					and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('070.22','070.32','070.23','070.33','070.44','070.54','456.1','456.0','456.21','456.20','571.0','571.2','571.3',
					'571.41','571.49','571.40','571.42','571.5','571.9','571.6','571.8','572.3','572.8','V42.7')
					and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('070.22','070.32','070.23','070.33','070.44','070.54','456.1','456.0','456.21','456.20','571.0','571.2','571.3',
					'571.41','571.49','571.40','571.42','571.5','571.9','571.6','571.8','572.3','572.8','V42.7')
					and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('070.22','070.32','070.23','070.33','070.44','070.54','456.1','456.0','456.21','456.20','571.0','571.2','571.3',
					'571.41','571.49','571.40','571.42','571.5','571.9','571.6','571.8','572.3','572.8','V42.7')
					and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('070.22','070.32','070.23','070.33','070.44','070.54','456.1','456.0','456.21','456.20','571.0','571.2','571.3',
					'571.41','571.49','571.40','571.42','571.5','571.9','571.6','571.8','572.3','572.8','V42.7')
					and b.PatientTransferDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('070.22','070.32','070.23','070.33','070.44','070.54','456.1','456.0','456.21','456.20','571.0','571.2','571.3',
					'571.41','571.49','571.40','571.42','571.5','571.9','571.6','571.8','572.3','572.8','V42.7')
					and b.SpecialtyTransferDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('070.22','070.32','070.23','070.33','070.44','070.54','456.1','456.0','456.21','456.20','571.0','571.2','571.3',
					'571.41','571.49','571.40','571.42','571.5','571.9','571.6','571.8','572.3','572.8','V42.7')
					and b.AdmitDateTime <= a.DPP4FillTime
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('B18.0','B18.1','B18.2','I85.00','I85.01','I85.10','I85.11','K70.0','K70.30','K70.9','K73.0','K73.2','K73.8','K73.9',
					'K75.4','K74.0','K74.60','K74.69','K74.3','K74.4','K74.5','K74.1','K76.0','K76.89','K76.9','K76.6','K72.10','K72.90','Z94.4')
and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('B18.0','B18.1','B18.2','I85.00','I85.01','I85.10','I85.11','K70.0','K70.30','K70.9','K73.0','K73.2','K73.8','K73.9',
					'K75.4','K74.0','K74.60','K74.69','K74.3','K74.4','K74.5','K74.1','K76.0','K76.89','K76.9','K76.6','K72.10','K72.90','Z94.4')
and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('B18.0','B18.1','B18.2','I85.00','I85.01','I85.10','I85.11','K70.0','K70.30','K70.9','K73.0','K73.2','K73.8','K73.9',
					'K75.4','K74.0','K74.60','K74.69','K74.3','K74.4','K74.5','K74.1','K76.0','K76.89','K76.9','K76.6','K72.10','K72.90','Z94.4') 
and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('B18.0','B18.1','B18.2','I85.00','I85.01','I85.10','I85.11','K70.0','K70.30','K70.9','K73.0','K73.2','K73.8','K73.9',
					'K75.4','K74.0','K74.60','K74.69','K74.3','K74.4','K74.5','K74.1','K76.0','K76.89','K76.9','K76.6','K72.10','K72.90','Z94.4')
and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('B18.0','B18.1','B18.2','I85.00','I85.01','I85.10','I85.11','K70.0','K70.30','K70.9','K73.0','K73.2','K73.8','K73.9',
					'K75.4','K74.0','K74.60','K74.69','K74.3','K74.4','K74.5','K74.1','K76.0','K76.89','K76.9','K76.6','K72.10','K72.90','Z94.4')
and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('B18.0','B18.1','B18.2','I85.00','I85.01','I85.10','I85.11','K70.0','K70.30','K70.9','K73.0','K73.2','K73.8','K73.9',
					'K75.4','K74.0','K74.60','K74.69','K74.3','K74.4','K74.5','K74.1','K76.0','K76.89','K76.9','K76.6','K72.10','K72.90','Z94.4')
and b.EventDateTime <= a.DPP4FillTime

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('B18.0','B18.1','B18.2','I85.00','I85.01','I85.10','I85.11','K70.0','K70.30','K70.9','K73.0','K73.2','K73.8','K73.9',
					'K75.4','K74.0','K74.60','K74.69','K74.3','K74.4','K74.5','K74.1','K76.0','K76.89','K76.9','K76.6','K72.10','K72.90','Z94.4')
and b.PatientTransferDateTime <= a.DPP4FillTime

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('B18.0','B18.1','B18.2','I85.00','I85.01','I85.10','I85.11','K70.0','K70.30','K70.9','K73.0','K73.2','K73.8','K73.9',
					'K75.4','K74.0','K74.60','K74.69','K74.3','K74.4','K74.5','K74.1','K76.0','K76.89','K76.9','K76.6','K72.10','K72.90','Z94.4')
and b.SpecialtyTransferDateTime <= a.DPP4FillTime

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('B18.0','B18.1','B18.2','I85.00','I85.01','I85.10','I85.11','K70.0','K70.30','K70.9','K73.0','K73.2','K73.8','K73.9',
					'K75.4','K74.0','K74.60','K74.69','K74.3','K74.4','K74.5','K74.1','K76.0','K76.89','K76.9','K76.6','K72.10','K72.90','Z94.4')
and b.AdmitDateTime <= a.DPP4FillTime

select distinct scrssn from Dflt.Diabetes_AF_DPP4_LiverDisease --164

/* Heart Failure */
/* Making sure the codes are available in the CDWWork Dimension table */

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')-- 150.00 is not available

select distinct a.PatientSID,a.ScrSSN,  b.DischargeDateTime as comorbidity_Dischargedatetime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_AF_DPP4_HF

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')
					and b.DischargeDateTime <= a.DPP4filltime
union all

select distinct a.PatientSID,a.ScrSSN,  b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')
					and b.DischargeDateTime <= a.DPP4filltime
union all

select distinct a.PatientSID,a.ScrSSN,  b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')
					and b.DischargeDateTime <= a.DPP4filltime
union all

select distinct a.PatientSID,a.ScrSSN,  b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')
					and b.EventDateTime <= a.DPP4filltime
union all

select distinct a.PatientSID,a.ScrSSN,  b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')
					and b.EventDateTime <= a.DPP4filltime
union all

select distinct a.PatientSID,a.ScrSSN,  b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')
					and b.EventDateTime <= a.DPP4filltime
union all

select distinct a.PatientSID,a.ScrSSN,  b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')
					and b.PatientTransferDateTime <= a.DPP4filltime
union all

select distinct a.PatientSID,a.ScrSSN,  b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')
					and b.SpecialtyTransferDateTime <= a.DPP4filltime
union all

select distinct a.PatientSID,a.ScrSSN,  b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')
					and b.AdmitDateTime <= a.DPP4filltime
union all

/*ICD10 Codes*/
select distinct a.PatientSID,a.ScrSSN,  b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')
and b.DischargeDateTime <= a.DPP4filltime
union all

select distinct a.PatientSID,a.ScrSSN,  b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')
and b.DischargeDateTime <= a.DPP4filltime
union all

select distinct a.PatientSID,a.ScrSSN,  b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')
and b.DischargeDateTime <= a.DPP4filltime
union all

select distinct a.PatientSID,a.ScrSSN,  b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')
and b.EventDateTime <= a.DPP4filltime
union all

select distinct a.PatientSID,a.ScrSSN,  b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')
and b.EventDateTime <= a.DPP4filltime
union all

select distinct a.PatientSID,a.ScrSSN,  b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')
and b.EventDateTime <= a.DPP4filltime

union all

select distinct a.PatientSID,a.ScrSSN,  b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')
and b.PatientTransferDateTime <= a.DPP4filltime

union all

select distinct a.PatientSID,a.ScrSSN,  b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')
and b.SpecialtyTransferDateTime <= a.DPP4filltime

union all

select distinct a.PatientSID,a.ScrSSN,  b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')
and b.AdmitDateTime <= a.DPP4filltime

select distinct scrssn from Dflt.Diabetes_AF_DPP4_HF --1169


/* HBA1C */
/* Check for the labchemtestname in the dimension table */
select distinct labchemtestname from CDWWork.Dim.Labchemtest 
where LabChemTestName like '%A1C%' AND
	LabChemTestName not like '%ZZ%' AND
	LabChemTestName not like '%XX%'

/* Current VA phenomics library is updated and shows only %A1C% */

select b.*, a.LabChemResultValue, a.LabChemResultNumericValue, a.LabChemCompleteDateTime,c.LabChemTestName

into Dflt.Diabetes_AF_DPP4_hba1c

from Src.Chem_LabChem as a with (NOLOCK) inner join
Dflt.Diabetes_AF_DPP4 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
where c.LabChemTestName like '%A1C%' AND
	c.LabChemTestName not like '%ZZ%' AND
	c.LabChemTestName not like '%XX%'
and a.LabChemCompleteDateTime between dateadd(month, -6, b.DPP4FillTime) and dateadd(day, 1, b.DPP4FillTime)                                
union all

select b.*, a.LabChemResultValue, a.LabChemResultNumericValue,a.LabChemCompleteDateTime,c.LabChemTestName

from Src.Chem_LabChem_Recent as a with (NOLOCK) inner join
Dflt.Diabetes_AF_DPP4 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
where c.LabChemTestName like '%A1C%' AND
	c.LabChemTestName not like '%ZZ%' AND
	c.LabChemTestName not like '%XX%'
and a.LabChemCompleteDateTime between dateadd(month, -6, b.DPP4FillTime) and dateadd(day, 1, b.DPP4FillTime)  
union all

select b.*, a.LabChemResultValue, a.LabChemResultNumericValue, a.LabChemCompleteDateTime, c.LabChemTestName

from Src.Chem_PatientLabChem as a with (NOLOCK) inner join
Dflt.Diabetes_AF_DPP4 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
where c.LabChemTestName like '%A1C%' AND
	c.LabChemTestName not like '%ZZ%' AND
	c.LabChemTestName not like '%XX%'
and a.LabChemCompleteDateTime between dateadd(month, -6, DPP4FillTime) and dateadd(day, 1, DPP4FillTime)

select distinct scrssn from Dflt.Diabetes_AF_DPP4_hba1c --1771
select * from Dflt.Diabetes_AF_DPP4_hba1c

/* Creatinine */
/* Check for the labchemtestname in the dimension table */
select distinct labchemtestname from CDWWork.Dim.Labchemtest 
WHERE LabChemTestName like '%Creat%' 
	--and	LabChemTestName not like '%ZZ%'  -- removed in latest update 14 June 2021 
	and LabChemTestName not like '%ratio%'
	and LabChemTestName not like '%DO NOT USE%'
	--and LabChemTestName not like 'XX%' -- removed in latest update 14 June 2021
	and LabChemTestName not in ('Beryllium (Creatinine Corrected)', 'ERROR IN CREATION', 'PANCREATIC AMYLASE(q',
'PANCREATIC ELASTASE 1','PANCREATIC ELASTASE-1 STOOL','PANCREATIC ELASTASE-1(Q)',
'PANCREATIC ELASTASE-1,STOOL (QU)','PANCREATIC ELASTASE1',
'Pancreatic Fraction','PANCREATIC ISOAMYLASE (PRE-',
'PANCREATIC POLYPEPTIDE','PANCREATIC POLYPEPTIDE  (before 9/22/98)',
'PANCREATIC POLYPEPTIDE (QU)','PANCREATIC POLYPEPTIDE(QU)(bef.4/26/04)',
'PANCREATIC POLYPEPTIDE~prior to 4/26/04','PANCREATITIS PANEL NGS(PG)', 'THALLIUM (ug/g Creat)')

select distinct b.PatientSID, b.ScrSSN, b.DPP4Filltime, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

into #tempCreatinineDPP4

from Src.Chem_LabChem as a with (NOLOCK) inner join
Dflt.Diabetes_AF_DPP4 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE LabChemTestName like '%Creat%' 
	--and	LabChemTestName not like '%ZZ%'  
	and LabChemTestName not like '%ratio%'
	and LabChemTestName not like '%DO NOT USE%'
	--and LabChemTestName not like 'XX%'
	and LabChemTestName not in ('Beryllium (Creatinine Corrected)', 'ERROR IN CREATION', 'PANCREATIC AMYLASE(q',
'PANCREATIC ELASTASE 1','PANCREATIC ELASTASE-1 STOOL','PANCREATIC ELASTASE-1(Q)',
'PANCREATIC ELASTASE-1,STOOL (QU)','PANCREATIC ELASTASE1',
'Pancreatic Fraction','PANCREATIC ISOAMYLASE (PRE-',
'PANCREATIC POLYPEPTIDE','PANCREATIC POLYPEPTIDE  (before 9/22/98)',
'PANCREATIC POLYPEPTIDE (QU)','PANCREATIC POLYPEPTIDE(QU)(bef.4/26/04)',
'PANCREATIC POLYPEPTIDE~prior to 4/26/04','PANCREATITIS PANEL NGS(PG)', 'THALLIUM (ug/g Creat)')

union all

select distinct b.PatientSID, b.ScrSSN, b.DPP4Filltime, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

from Src.Chem_LabChem_Recent as a with (NOLOCK) inner join
Dflt.Diabetes_AF_DPP4 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE LabChemTestName like '%Creat%' 
	--and	LabChemTestName not like '%ZZ%'  
	and LabChemTestName not like '%ratio%'
	and LabChemTestName not like '%DO NOT USE%'
	--and LabChemTestName not like 'XX%'
	and LabChemTestName not in ('Beryllium (Creatinine Corrected)', 'ERROR IN CREATION', 'PANCREATIC AMYLASE(q',
'PANCREATIC ELASTASE 1','PANCREATIC ELASTASE-1 STOOL','PANCREATIC ELASTASE-1(Q)',
'PANCREATIC ELASTASE-1,STOOL (QU)','PANCREATIC ELASTASE1',
'Pancreatic Fraction','PANCREATIC ISOAMYLASE (PRE-',
'PANCREATIC POLYPEPTIDE','PANCREATIC POLYPEPTIDE  (before 9/22/98)',
'PANCREATIC POLYPEPTIDE (QU)','PANCREATIC POLYPEPTIDE(QU)(bef.4/26/04)',
'PANCREATIC POLYPEPTIDE~prior to 4/26/04','PANCREATITIS PANEL NGS(PG)', 'THALLIUM (ug/g Creat)')

union all

select distinct b.PatientSID, b.ScrSSN, b.DPP4Filltime, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

from Src.Chem_PatientLabChem as a with (NOLOCK) inner join
Dflt.Diabetes_AF_DPP4 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE LabChemTestName like '%Creat%' 
	--and	LabChemTestName not like '%ZZ%'  
	and LabChemTestName not like '%ratio%'
	and LabChemTestName not like '%DO NOT USE%'
	--and LabChemTestName not like 'XX%'
	and LabChemTestName not in ('Beryllium (Creatinine Corrected)', 'ERROR IN CREATION', 'PANCREATIC AMYLASE(q',
'PANCREATIC ELASTASE 1','PANCREATIC ELASTASE-1 STOOL','PANCREATIC ELASTASE-1(Q)',
'PANCREATIC ELASTASE-1,STOOL (QU)','PANCREATIC ELASTASE1',
'Pancreatic Fraction','PANCREATIC ISOAMYLASE (PRE-',
'PANCREATIC POLYPEPTIDE','PANCREATIC POLYPEPTIDE  (before 9/22/98)',
'PANCREATIC POLYPEPTIDE (QU)','PANCREATIC POLYPEPTIDE(QU)(bef.4/26/04)',
'PANCREATIC POLYPEPTIDE~prior to 4/26/04','PANCREATITIS PANEL NGS(PG)', 'THALLIUM (ug/g Creat)')

select *
into Dflt.Diabetes_AF_DPP4_Creatinine
from #tempCreatinineDPP4
where LabChemCompleteDateTime between dateadd(month, -6, DPP4FillTime) and dateadd(day, 1, DPP4FillTime)

select distinct scrssn from Dflt.Diabetes_AF_DPP4_Creatinine --2037

select * from Dflt.Diabetes_AF_DPP4_Creatinine

/* Hemoglobin */
/* Check for the labchemtestname in the dimension table */
select distinct labchemtestname from CDWWork.Dim.Labchemtest 
WHERE 
   (labchemtestname like '%hemoglob%' or 
    labchemtestname like '%HB%' or 
	LabChemTestName like '%HGB%') and
	labchemtestname not like 'z%' AND
	labchemtestname not like 'x%' AND
	LabChemTestName not like '%ratio%' AND 
	LabChemTestName not like '%HBV%' AND
	LabChemTestName not like '%Anti-HB%' AND 
	LabChemTestName not like '%Hepatitis%' AND
	LabChemTestName not like '%ELECTROPHORESIS%' AND
	LabChemTestName not like '%HBSAG%' AND
	LabChemTestName not like '%HC1 ESTERASE%' AND
	LabChemTestName not like '%Testoster%' AND
	LabChemTestName not like '%SDHB%' AND
	LabChemTestName not like '%HBsAb%' AND
	LabChemTestName not like '%GHB%' AND
	LabChemTestName NOT LIKE '%A1C%'
	AND LabChemTestName NOT LIKE '%CELL%'
	AND LabChemTestName not like '%RATE%'
	AND LabChemTestName not like '%/100wbc%'
	AND LabChemTestName not like '%sperm%'
	AND LabChemTestName not like '%HBV%'
	AND LabChemTestName not like '%hbc%'
	AND LabChemTestName not like '%hiv%'
	AND LabChemTestName not like '%anti%'
	AND LabChemTestName not like '%hep%'
	AND LabChemTestName not like '%butyl%'
	AND LabChemTestName not like '%VITROS%'
	AND LabChemTestName not like '%hormone%'
	AND LabChemTestName not like '%hbs%'

select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

into #tempHemoglobinDPP4

from Src.Chem_LabChem as a with (NOLOCK) inner join
Dflt.Diabetes_AF_DPP4 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE 
   (labchemtestname like '%hemoglob%' or 
    labchemtestname like '%HB%' or 
	LabChemTestName like '%HGB%') and
	labchemtestname not like 'z%' AND
	labchemtestname not like 'x%' AND
	LabChemTestName not like '%ratio%' AND 
	LabChemTestName not like '%HBV%' AND
	LabChemTestName not like '%Anti-HB%' AND 
	LabChemTestName not like '%Hepatitis%' AND
	LabChemTestName not like '%ELECTROPHORESIS%' AND
	LabChemTestName not like '%HBSAG%' AND
	LabChemTestName not like '%HC1 ESTERASE%' AND
	LabChemTestName not like '%Testoster%' AND
	LabChemTestName not like '%SDHB%' AND
	LabChemTestName not like '%HBsAb%' AND
	LabChemTestName not like '%GHB%' AND
	LabChemTestName NOT LIKE '%A1C%'
	AND LabChemTestName NOT LIKE '%CELL%'
	AND LabChemTestName not like '%RATE%'
	AND LabChemTestName not like '%/100wbc%'
	AND LabChemTestName not like '%sperm%'
	AND LabChemTestName not like '%HBV%'
	AND LabChemTestName not like '%hbc%'
	AND LabChemTestName not like '%hiv%'
	AND LabChemTestName not like '%anti%'
	AND LabChemTestName not like '%hep%'
	AND LabChemTestName not like '%butyl%'
	AND LabChemTestName not like '%VITROS%'
	AND LabChemTestName not like '%hormone%'
	AND LabChemTestName not like '%hbs%'

union all

select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

from Src.Chem_LabChem_Recent as a with (NOLOCK) inner join
Dflt.Diabetes_AF_DPP4 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE 
   (labchemtestname like '%hemoglob%' or 
    labchemtestname like '%HB%' or 
	LabChemTestName like '%HGB%') and
	labchemtestname not like 'z%' AND
	labchemtestname not like 'x%' AND
	LabChemTestName not like '%ratio%' AND 
	LabChemTestName not like '%HBV%' AND
	LabChemTestName not like '%Anti-HB%' AND 
	LabChemTestName not like '%Hepatitis%' AND
	LabChemTestName not like '%ELECTROPHORESIS%' AND
	LabChemTestName not like '%HBSAG%' AND
	LabChemTestName not like '%HC1 ESTERASE%' AND
	LabChemTestName not like '%Testoster%' AND
	LabChemTestName not like '%SDHB%' AND
	LabChemTestName not like '%HBsAb%' AND
	LabChemTestName not like '%GHB%' AND
	LabChemTestName NOT LIKE '%A1C%'
	AND LabChemTestName NOT LIKE '%CELL%'
	AND LabChemTestName not like '%RATE%'
	AND LabChemTestName not like '%/100wbc%'
	AND LabChemTestName not like '%sperm%'
	AND LabChemTestName not like '%HBV%'
	AND LabChemTestName not like '%hbc%'
	AND LabChemTestName not like '%hiv%'
	AND LabChemTestName not like '%anti%'
	AND LabChemTestName not like '%hep%'
	AND LabChemTestName not like '%butyl%'
	AND LabChemTestName not like '%VITROS%'
	AND LabChemTestName not like '%hormone%'
	AND LabChemTestName not like '%hbs%'

union all

select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

from Src.Chem_PatientLabChem as a with (NOLOCK) inner join
Dflt.Diabetes_AF_DPP4 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE 
   (labchemtestname like '%hemoglob%' or 
    labchemtestname like '%HB%' or 
	LabChemTestName like '%HGB%') and
	labchemtestname not like 'z%' AND
	labchemtestname not like 'x%' AND
	LabChemTestName not like '%ratio%' AND 
	LabChemTestName not like '%HBV%' AND
	LabChemTestName not like '%Anti-HB%' AND 
	LabChemTestName not like '%Hepatitis%' AND
	LabChemTestName not like '%ELECTROPHORESIS%' AND
	LabChemTestName not like '%HBSAG%' AND
	LabChemTestName not like '%HC1 ESTERASE%' AND
	LabChemTestName not like '%Testoster%' AND
	LabChemTestName not like '%SDHB%' AND
	LabChemTestName not like '%HBsAb%' AND
	LabChemTestName not like '%GHB%' AND
	LabChemTestName NOT LIKE '%A1C%'
	AND LabChemTestName NOT LIKE '%CELL%'
	AND LabChemTestName not like '%RATE%'
	AND LabChemTestName not like '%/100wbc%'
	AND LabChemTestName not like '%sperm%'
	AND LabChemTestName not like '%HBV%'
	AND LabChemTestName not like '%hbc%'
	AND LabChemTestName not like '%hiv%'
	AND LabChemTestName not like '%anti%'
	AND LabChemTestName not like '%hep%'
	AND LabChemTestName not like '%butyl%'
	AND LabChemTestName not like '%VITROS%'
	AND LabChemTestName not like '%hormone%'
	AND LabChemTestName not like '%hbs%'

select *
into Dflt.Diabetes_AF_DPP4_Hemoglobin
from #tempHemoglobinDPP4
where LabChemCompleteDateTime between dateadd(month, -6, DPP4FillTime) and dateadd(day, 1, DPP4FillTime)

select distinct scrssn from Dflt.Diabetes_AF_DPP4_Hemoglobin --1963
select * from Dflt.Diabetes_AF_DPP4_Hemoglobin

/* Brain Natriuretic Peptide (BNP)*/
/* Check for the labchemtestname in the dimension table */
select distinct labchemtestname from CDWWork.Dim.Labchemtest 
WHERE 
   (labchemtestname like '%BNP%' or  
	labchemtestname  like '%brain natriuretic peptide%' or 
	labchemtestname  like '%natriu%pept%') and
	LabChemTestName not like '%ratio%' AND
	LabChemTestName not like '%pro%'

select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

into #tempBNPDPP4

from Src.Chem_LabChem as a with (NOLOCK) inner join
Dflt.Diabetes_AF_DPP4 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE 
   (labchemtestname like '%BNP%' or  
	labchemtestname  like '%brain natriuretic peptide%' or 
	labchemtestname  like '%natriu%pept%') and
	LabChemTestName not like '%ratio%' AND
	LabChemTestName not like '%pro%'

union all

select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

from Src.Chem_LabChem_Recent as a with (NOLOCK) inner join
Dflt.Diabetes_AF_DPP4 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE 
   (labchemtestname like '%BNP%' or  
	labchemtestname  like '%brain natriuretic peptide%' or 
	labchemtestname  like '%natriu%pept%') and
	LabChemTestName not like '%ratio%' AND
	LabChemTestName not like '%pro%'

union all

select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

from Src.Chem_PatientLabChem as a with (NOLOCK) inner join
Dflt.Diabetes_AF_DPP4 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE 
   (labchemtestname like '%BNP%' or  
	labchemtestname  like '%brain natriuretic peptide%' or 
	labchemtestname  like '%natriu%pept%') and
	LabChemTestName not like '%ratio%' AND
	LabChemTestName not like '%pro%'

select *
into Dflt.Diabetes_AF_DPP4_BNP
from #tempBNPDPP4
where LabChemCompleteDateTime between dateadd(month, -6, DPP4FillTime) and dateadd(day, 1, DPP4FillTime)

select distinct scrssn from Dflt.Diabetes_AF_DPP4_BNP --498
select * from Dflt.Diabetes_AF_DPP4_BNP

/* Pro Brain Natriuretic Peptide (PBNP)*/
/* Check for the labchemtestname in the dimension table */
select distinct labchemtestname from CDWWork.Dim.Labchemtest 
WHERE 
   (labchemtestname like '%BNP%' or 
    labchemtestname like '%terminal%pep%' or
	labchemtestname  like '%proBNP%' or 
	labchemtestname  like '%pro[- /_]BNP%' or 
	labchemtestname  like '%pro brain natriuretic peptide%' or 
	labchemtestname  like '%natriu%pept%') and
	LabChemTestName not like '%ratio%'

select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

into #tempPBNPDPP4

from Src.Chem_LabChem as a with (NOLOCK) inner join
Dflt.Diabetes_AF_DPP4 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE 
   (labchemtestname like '%BNP%' or 
    labchemtestname like '%terminal%pep%' or
	labchemtestname  like '%proBNP%' or 
	labchemtestname  like '%pro[- /_]BNP%' or 
	labchemtestname  like '%pro brain natriuretic peptide%' or 
	labchemtestname  like '%natriu%pept%') and
	LabChemTestName not like '%ratio%'
union all

select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

from Src.Chem_LabChem_Recent as a with (NOLOCK) inner join
Dflt.Diabetes_AF_DPP4 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE 
   (labchemtestname like '%BNP%' or 
    labchemtestname like '%terminal%pep%' or
	labchemtestname  like '%proBNP%' or 
	labchemtestname  like '%pro[- /_]BNP%' or 
	labchemtestname  like '%pro brain natriuretic peptide%' or 
	labchemtestname  like '%natriu%pept%') and
	LabChemTestName not like '%ratio%'

union all

select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

from Src.Chem_PatientLabChem as a with (NOLOCK) inner join
Dflt.Diabetes_AF_DPP4 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE 
   (labchemtestname like '%BNP%' or 
    labchemtestname like '%terminal%pep%' or
	labchemtestname  like '%proBNP%' or 
	labchemtestname  like '%pro[- /_]BNP%' or 
	labchemtestname  like '%pro brain natriuretic peptide%' or 
	labchemtestname  like '%natriu%pept%') and
	LabChemTestName not like '%ratio%'

select *
into Dflt.Diabetes_AF_DPP4_PBNP
from #tempPBNPDPP4
where LabChemCompleteDateTime between dateadd(month, -6, DPP4FillTime) and dateadd(day, 1, DPP4FillTime)

select distinct scrssn from Dflt.Diabetes_AF_DPP4_PBNP --739
select * from Dflt.Diabetes_AF_DPP4_PBNP

/* Other Medications */
select distinct a.PatientSID, a.ScrSSN, a.DPP4FillTime, b.FillDateTime, b.LocalDrugNameWithDose, b.FillNumber, b.DaysSupply, b.Qty

into #tempMedicationsDPP4

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where b.FillDateTime between dateadd(month, -6, a.DPP4FillTime) and a.DPP4FillTime and 
b.FillNumber > '1'
union all

select distinct a.PatientSID, a.ScrSSN, a.DPP4FillTime, b.FillDateTime, b.LocalDrugNameWithDose, b.FillNumber, b.DaysSupply, b.Qty

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where b.FillDateTime between dateadd(month, -6, a.DPP4FillTime) and a.DPP4FillTime and 
b.FillNumber > '1'

/* Beta Blockers */
/* Check for the LocalDrugNameWithDose in the dimension table */
select * from CDWWork.Dim.LocalDrug where LocalDrugNameWithDose like '%metoprolol%' or LocalDrugNameWithDose like '%carvedilol%' or LocalDrugNameWithDose like '%bisoprolol%' or
		LocalDrugNameWithDose like '%nebivolol%' or LocalDrugNameWithDose like '%atenolol%'

select distinct *

into Dflt.Diabetes_AF_DPP4_BB

from #tempMedicationsDPP4 where LocalDrugNameWithDose like '%metoprolol%' or LocalDrugNameWithDose like '%carvedilol%' or LocalDrugNameWithDose like '%bisoprolol%' or
		LocalDrugNameWithDose like '%nebivolol%' or LocalDrugNameWithDose like '%atenolol%'

select distinct scrssn from Dflt.Diabetes_AF_DPP4_BB --791

/* ACE Inhibitor */
/* Check for the LocalDrugNameWithDose in the dimension table */
select * from CDWWork.Dim.LocalDrug where LocalDrugNameWithDose like '%lisinopril%' or LocalDrugNameWithDose like '%Fosinopril%' or LocalDrugNameWithDose like '%ramipril%' or
		LocalDrugNameWithDose like '%quinapril%' or LocalDrugNameWithDose like '%benazepril%'

select distinct *

into Dflt.Diabetes_AF_DPP4_ACE

from #tempMedicationsDPP4 where LocalDrugNameWithDose like '%lisinopril%' or LocalDrugNameWithDose like '%Fosinopril%' or LocalDrugNameWithDose like '%ramipril%' or
		LocalDrugNameWithDose like '%quinapril%' or LocalDrugNameWithDose like '%benazepril%'

select distinct scrssn from Dflt.Diabetes_AF_DPP4_ACE --448

/*ARB Inhibitor */
/* Check for the LocalDrugNameWithDose in the dimension table */
select * from CDWWork.Dim.LocalDrug where LocalDrugNameWithDose like '%valsartan%' or LocalDrugNameWithDose like '%losartan%' or LocalDrugNameWithDose like '%candesartan%' or
		LocalDrugNameWithDose like '%Olmesartan%' or LocalDrugNameWithDose like '%telmisartan%' or LocalDrugNameWithDose like '%irbesartan%' 

select distinct *

into Dflt.Diabetes_AF_DPP4_ARB

from #tempMedicationsDPP4 where LocalDrugNameWithDose like '%valsartan%' or LocalDrugNameWithDose like '%losartan%' or LocalDrugNameWithDose like '%candesartan%' or
		LocalDrugNameWithDose like '%Olmesartan%' or LocalDrugNameWithDose like '%telmisartan%' or LocalDrugNameWithDose like '%irbesartan%' 

select distinct scrssn from Dflt.Diabetes_AF_DPP4_ARB --221

/* ACE and ARB */

select distinct * 

into Dflt.Diabetes_AF_DPP4_ACEARB

from Dflt.Diabetes_AF_DPP4_ACE 
union all

select distinct *

from Dflt.Diabetes_AF_DPP4_ARB

select distinct scrssn from Dflt.Diabetes_AF_DPP4_ACEARB --667

/* Spironolactone/Eplerenone */
/* Check for the LocalDrugNameWithDose in the dimension table */
select * from CDWWork.Dim.LocalDrug where LocalDrugNameWithDose like '%spironolactone%' or LocalDrugNameWithDose like '%Eplerenone%'

select distinct *

into Dflt.Diabetes_AF_DPP4_SpiroEp

from #tempMedicationsDPP4 where LocalDrugNameWithDose like '%spironolactone%' or LocalDrugNameWithDose like '%Eplerenone%'

select distinct scrssn from Dflt.Diabetes_AF_DPP4_SpiroEp --163

/* Loop Diuretic */
/* Check for the LocalDrugNameWithDose in the dimension table */
select distinct a.PatientSID, a.ScrSSN, a.DPP4FillTime, b.FillDateTime, b.LocalDrugNameWithDose, b.FillNumber, b.DaysSupply, b.Qty

into #tempMedicationsDPP4loop

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where LocalDrugNameWithDose like '%furosemide%' or LocalDrugNameWithDose like '%torsemide%' or LocalDrugNameWithDose like '%bumetanide%' or
LocalDrugNameWithDose like '%Ethacrynic acid%' or LocalDrugNameWithDose like '%lasix%' or LocalDrugNameWithDose like '%bumex%'
--where b.FillDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(month, 12, a.DPP4FillTime) and 
--b.FillNumber > '1'
union all

select distinct a.PatientSID, a.ScrSSN, a.DPP4FillTime, b.FillDateTime, b.LocalDrugNameWithDose, b.FillNumber, b.DaysSupply, b.Qty

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID
where LocalDrugNameWithDose like '%furosemide%' or LocalDrugNameWithDose like '%torsemide%' or LocalDrugNameWithDose like '%bumetanide%' or
LocalDrugNameWithDose like '%Ethacrynic acid%' or LocalDrugNameWithDose like '%lasix%' or LocalDrugNameWithDose like '%bumex%'
--where b.FillDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(month, 12, a.DPP4FillTime) and 
--b.FillNumber > '1'

select distinct *

into Dflt.Diabetes_AF_DPP4_LoopDiuretic

from #tempMedicationsDPP4loop 
where FillDateTime between dateadd(month, -12, DPP4FillTime) and dateadd(month, 12, DPP4FillTime) and 
FillNumber > '1'

select distinct scrssn from Dflt.Diabetes_AF_DPP4_LoopDiuretic --956

/* Insulin */
/* Check for the LocalDrugNameWithDose in the dimension table */
select * from CDWWork.Dim.LocalDrug where LocalDrugNameWithDose like '%insulin%' 

select distinct *

into Dflt.Diabetes_AF_DPP4_Insulin

from #tempMedicationsDPP4 where LocalDrugNameWithDose like '%insulin%' 

select distinct scrssn from Dflt.Diabetes_AF_DPP4_Insulin --142

/* Sacubitril and Valsartan */

select distinct * 

into Dflt.Diabetes_AF_DPP4_SacuVal

from #tempMedicationsDPP4
where LocalDrugNameWithDose like '%sacubitril%' and LocalDrugNameWithDose like '%valsartan%' 

Select distinct scrssn from Dflt.Diabetes_AF_DPP4_SacuVal --18 

/* GLP1 Analogue */

select distinct LocalDrugNameWithDose from CDWWork.Dim.LocalDrug where LocalDrugNameWithDose like '%semaglutide%' 
or LocalDrugNameWithDose like '%exenatide%' 
or LocalDrugNameWithDose like '%liraglutide%' 
or LocalDrugNameWithDose like '%lixisenatide%' 
or LocalDrugNameWithDose like '%dulaglutide%'

select distinct *

into Dflt.Diabetes_AF_DPP4_GLP1

from #tempMedicationsDPP4 where LocalDrugNameWithDose like '%semaglutide%' 
or LocalDrugNameWithDose like '%exenatide%' 
or LocalDrugNameWithDose like '%liraglutide%' 
or LocalDrugNameWithDose like '%lixisenatide%' 
or LocalDrugNameWithDose like '%dulaglutide%'

select distinct scrssn from Dflt.Diabetes_AF_DPP4_GLP1 --9


/* DPP4 I */

select distinct LocalDrugNameWithDose from CDWWork.Dim.LocalDrug where LocalDrugNameWithDose like '%gliptin%'

select distinct *

into Dflt.Diabetes_AF_DPP4_DPP4

from #tempMedicationsDPP4 where LocalDrugNameWithDose like '%gliptin%'

drop table  Dflt.Diabetes_AF_DPP4_DPP4

/* Metformin */

select * from CDWWork.Dim.LocalDrug where LocalDrugNameWithDose like '%metformin%' 

select distinct *

into Dflt.Diabetes_AF_DPP4_Metformin

from #tempMedicationsDPP4 where LocalDrugNameWithDose like '%metformin%' 

select distinct scrssn from Dflt.Diabetes_AF_DPP4_Metformin --535

/* Sulfonylurea */

select distinct LocalDrugNameWithDose from CDWWork.Dim.LocalDrug where LocalDrugNameWithDose like '%Glipizide%' or
			  LocalDrugNameWithDose like '%Glimepiride%' or
			  LocalDrugNameWithDose like '%Glyburide%' or
			  LocalDrugNameWithDose like '%Tolbutamide%' 

select distinct *

into Dflt.Diabetes_AF_DPP4_Sulfonylurea

from #tempMedicationsDPP4 where LocalDrugNameWithDose like '%Glipizide%' or
			  LocalDrugNameWithDose like '%Glimepiride%' or
			  LocalDrugNameWithDose like '%Glyburide%' or
			  LocalDrugNameWithDose like '%Tolbutamide%' 

select distinct scrssn from Dflt.Diabetes_AF_DPP4_Sulfonylurea --0

/* Thiazoldiandione */

select distinct LocalDrugNameWithDose from CDWWork.Dim.LocalDrug where LocalDrugNameWithDose like '%pioglitazone%' 
or LocalDrugNameWithDose like '%rosiglitazone%'

select distinct *

into Dflt.Diabetes_AF_DPP4_Thiazol

from #tempMedicationsDPP4 where LocalDrugNameWithDose like '%pioglitazone%' 
or LocalDrugNameWithDose like '%rosiglitazone%'

select distinct scrssn from Dflt.Diabetes_AF_DPP4_Thiazol --4

* Anti-Arrythmia Drugs */

select distinct LocalDrugNameWithDose from CDWWork.Dim.LocalDrug where LocalDrugNameWithDose like '%soltalol%' 
or LocalDrugNameWithDose like '%Dofetilide%' 
or LocalDrugNameWithDose like '%flecainide%' 
or LocalDrugNameWithDose like '%propafenone%' 
or LocalDrugNameWithDose like '%amiodarone%' 
or LocalDrugNameWithDose like '%dronaderone%'
or LocalDrugNameWithDose like '%digoxin%'

select distinct *

into Dflt.Diabetes_AF_DPP4_AntiArr

from #tempMedicationsDPP4 where LocalDrugNameWithDose like '%soltalol%' 
or LocalDrugNameWithDose like '%Dofetilide%' 
or LocalDrugNameWithDose like '%flecainide%' 
or LocalDrugNameWithDose like '%propafenone%' 
or LocalDrugNameWithDose like '%amiodarone%' 
or LocalDrugNameWithDose like '%dronaderone%'
or LocalDrugNameWithDose like '%digoxin%'

select distinct scrssn from Dflt.Diabetes_AF_DPP4_AntiArr --447

/* Total Number of HF hospitalization prior to DPP4 initiation using only discharge diagnosis table*/


select distinct a.*,b.AdmitDateTime

into Dflt.AF_DPP4_PriorHFHospi

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_Inpatient as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.PrincipalDiagnosisICD9SID=c.ICD9SID 
where c.ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')
					and b.AdmitDateTime between dateadd(year, -10, a.DPP4FillTime) and a.DPP4FillTime
union all

select distinct a.*, b.AdmitDateTime

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_Inpatient_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.PrincipalDiagnosisICD10SID=c.ICD10SID 
where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')
and b.AdmitDateTime between dateadd(year, -10, a.DPP4FillTime) and a.DPP4FillTime

select distinct scrssn from Dflt.AF_DPP4_PriorHFHospi --257

/* Before EF value */

select distinct a.*, b.Low_Value, b.ValueDateTime

into Dflt.Diabetes_AF_DPP4_EFBefore

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join 
Src.VINCI_TIU_NLP_LVEF as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where b.ValueDateTime <= a.DPP4Filltime


select distinct scrssn from Dflt.Diabetes_AF_DPP4_EFBefore--2002

/* After EF value */

select distinct a.*, b.Low_Value, b.ValueDateTime

into Dflt.Diabetes_AF_DPP4_EFAfter

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join 
Src.VINCI_TIU_NLP_LVEF as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where b.ValueDateTime > a.DPP4Filltime


select distinct scrssn from Dflt.Diabetes_AF_DPP4_EFAfter --1893

//** After the drug initiation - Extraction **//

/* All HF hospitalization after DPP4 initiation */

select distinct a.PatientSID,a.ScrSSN,  a.DPP4FillTime, b.AdmitDateTime, b.Admitdiagnosis, c.ICD9Code

into Dflt.AF_DPP4_HFHospitalization

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_Inpatient as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.PrincipalDiagnosisICD9SID=c.ICD9SID 
where c.ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')
					and b.DischargeDateTime >= a.DPP4FillTime
union all

/*ICD10 Codes*/

select distinct a.PatientSID,a.ScrSSN,  a.DPP4FillTime, b.AdmitDateTime, b.AdmitDiagnosis, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_Inpatient as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.PrincipalDiagnosisICD10SID=c.ICD10SID 
where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')
and b.DischargeDateTime >= a.DPP4FillTime

select distinct scrssn from Dflt.AF_DPP4_HFHospitalization --419

select * from Dflt.AF_DPP4_HFHospitalization

/* Atrial Fibrillation */

select distinct a.PatientSID,a.ScrSSN,  a.DPP4FillTime, b.AdmitDateTime, b.Admitdiagnosis, c.ICD9Code

into Dflt.Diabetes_AF_DPP4_AFAfter

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_Inpatient as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.PrincipalDiagnosisICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
					and b.DischargeDateTime >= a.DPP4FillTime
union all

/*ICD10 Codes*/

select distinct a.PatientSID,a.ScrSSN,  a.DPP4FillTime, b.AdmitDateTime, b.AdmitDiagnosis, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_Inpatient as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.PrincipalDiagnosisICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.DischargeDateTime >= a.DPP4FillTime

select distinct scrssn from Dflt.Diabetes_AF_DPP4_AFAfter --341

/* All hospitalization after DPP4 initiation */

select distinct a.*, b.DischargeDateTime, c.ICD9Code
/*ICD9 Codes*/

into Dflt.AF_DPP4_AllHospitalization

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where b.DischargeDateTime >= a.DPP4FillTime
union all

select distinct a.*, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where b.DischargeDateTime >= a.DPP4FillTime
union all

select distinct a.*, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where b.DischargeDateTime >= a.DPP4FillTime
union all

select distinct a.*, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where b.PatientTransferDateTime >= a.DPP4FillTime
union all

select distinct a.*,b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where b.SpecialtyTransferDateTime >= a.DPP4FillTime
union all

select distinct a.*, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where b.AdmitDateTime >= a.DPP4FillTime
union all

/*ICD10 Codes*/
select distinct a.*, b.DischargeDateTime,c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where  b.DischargeDateTime >= a.DPP4FillTime
union all

select distinct a.*, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where b.DischargeDateTime >= a.DPP4FillTime
union all

select distinct a.*, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where b.DischargeDateTime >= a.DPP4FillTime
union all

select distinct a.*, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where b.PatientTransferDateTime >= a.DPP4FillTime

union all

select distinct a.*, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where  b.SpecialtyTransferDateTime >= a.DPP4FillTime
union all

select distinct a.*, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where  b.AdmitDateTime >= a.DPP4FillTime

select distinct scrssn from Dflt.AF_DPP4_AllHospitalization --1694
select * from Dflt.AF_DPP4_AllHospitalization

/* Use only Discharge diagnosis table to identify the All hospitalization events - DPP4*/

select distinct a.*,b.AdmitDateTime, c.ICD9code

into Dflt.AF_DPP4_AllDDHospi

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where b.AdmitDateTime >= a.DPP4FillTime
union all

select distinct a.*, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where b.AdmitDateTime >= a.DPP4FillTime

select distinct scrssn from Dflt.AF_DPP4_AllDDHospi --1417

/*BMI*/
/* Select height and weight values from vital signs view to calculate bmi */
drop table #tempDiabetesVitals

select distinct a.PatientSID, a.VitalSignTakenDateTime, a.VitalResult, a.VitalResultNumeric,
 b.DPP4FillTime, b.ScrSSN, 
c.VitalType

into #tempDiabetesVitalsDPP4

from Src.Vital_VitalSign as a with (NOLOCK) inner join
Dflt.Diabetes_AF_DPP4 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.VitalType as c with (NOLOCK) on a.VitalTypeSID=c.VitalTypeSID 
where a.VitalSignTakenDateTime > dateadd(month, 3, b.DPP4FillTime) AND
c.VitalType in ( 'WEIGHT')
union all

select distinct a.PatientSID, a.VitalSignTakenDateTime, a.VitalResult, a.VitalResultNumeric,
b.DPP4FillTime,b.ScrSSN, 
c.VitalType

from Src.Vital_VitalSign_Recent as a with (NOLOCK) inner join
Dflt.Diabetes_AF_DPP4 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.VitalType as c with (NOLOCK) on a.VitalTypeSID=c.VitalTypeSID 
where a.VitalSignTakenDateTime > dateadd(month, 3, b.DPP4FillTime) AND 
c.VitalType in ( 'WEIGHT')
union all

select distinct a.PatientSID, a.VitalSignTakenDateTime, a.VitalResult, a.VitalResultNumeric,
 b.DPP4FillTime, b.ScrSSN, 
c.VitalType

from Src.Vital_VitalSign as a with (NOLOCK) inner join
Dflt.Diabetes_AF_DPP4 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.VitalType as c with (NOLOCK) on a.VitalTypeSID=c.VitalTypeSID 
--where (a.VitalSignTakenDateTime between dateadd(month, -12, b.DPP4FillTime) and dateadd(day, 1, b.DPP4FillTime))AND
where a.VitalSignTakenDateTime >= b.DPP4FillTime and 
c.VitalType in ( 'HEIGHT')
union all

select distinct a.PatientSID, a.VitalSignTakenDateTime, a.VitalResult, a.VitalResultNumeric,
b.DPP4FillTime,b.ScrSSN, 
c.VitalType

from Src.Vital_VitalSign_Recent as a with (NOLOCK) inner join
Dflt.Diabetes_AF_DPP4 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.VitalType as c with (NOLOCK) on a.VitalTypeSID=c.VitalTypeSID 
--where (a.VitalSignTakenDateTime between dateadd(month, -12, b.DPP4FillTime) and dateadd(day, 1, b.DPP4FillTime))AND
where a.VitalSignTakenDateTime >= b.DPP4FillTime and 
c.VitalType in ( 'HEIGHT')

select distinct scrssn from #tempDiabetesVitalsDPP4

/* Seperate weight records into a table */
select * 

into #tempweightDPP4After

from #tempDiabetesVitalsDPP4 where vitaltype = 'WEIGHT' and VitalResultNumeric != '0'

select distinct scrssn from #tempweightDPP4After

/* Seperate height records into a table */

select *  

into #tempheightDPP4After

from #tempDiabetesVitalsDPP4 where vitaltype = 'HEIGHT' and VitalResultNumeric != '0'

select distinct scrssn from #tempheightDPP4After

/* Combine data from table weight and height to obtain the bmi for individual patient */

select distinct a.patientsid, a.ScrSSN, cast(a.VitalSignTakenDateTime as date) as HeightTime, a.VitalResultNumeric as heightresult, 
cast(b.VitalSignTakenDateTime as date) as WeightTime,b.VitalResultNumeric as weightresult, ((b.VitalResultNumeric*703)/(a.VitalResultNumeric*a.VitalResultNumeric)) as bmi

into Dflt.Diabetes_AF_DPP4_BMI_After

from #tempheightDPP4After as a with (NOLOCK) inner join
#tempweightDPP4After as b with (NOLOCK) on a.ScrSSN = b.ScrSSN
where a.VitalSignTakenDateTime=b.VitalSignTakenDateTime --a.DPP4FillTime=b.DPP4FillTime and

select distinct scrssn from Dflt.Diabetes_AF_DPP4_BMI_After --1820

select distinct scrssn from Dflt.Diabetes_AF_DPP4_BMI_After where bmi between 30 and 35

select distinct scrssn from Dflt.Diabetes_AF_DPP4_BMI_After where bmi between 35 and 40

select distinct scrssn from Dflt.Diabetes_AF_DPP4_BMI_After where bmi > 40

select distinct scrssn from Dflt.Diabetes_AF_DPP4_BMI_After where bmi < 30 


/* DPP4 cardioversion using rpocedure codes- 1 week after drug initiation */

select distinct a.*, b.ICDProcedureDateTime, c.ICD9ProcedureCode
/*ICD9Procedure Codes*/

into Dflt.Diabetes_AF_DPP4_CVAfter

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_CensusICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('99.61','99.62')
					and b.ICDProcedureDateTime >  dateadd(day, 7, a.DPP4Filltime)
union all

select distinct a.*, b.SurgicalProcedureDateTime, c.ICD9ProcedureCode

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_CensusSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('99.61','99.62')
					and b.SurgicalProcedureDateTime >  dateadd(day, 7, a.DPP4Filltime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD9ProcedureCode

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('99.61','99.62')
					and b.DischargeDateTime >  dateadd(day, 7, a.DPP4Filltime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD9ProcedureCode

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('99.61','99.62')
					and b.DischargeDateTime >  dateadd(day, 7, a.DPP4Filltime)
union all

/*ICD10Procedure Codes*/
select distinct a.*, b.ICDProcedureDateTime, c.ICD10ProcedureCode

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_CensusICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('5A2204Z')
and b.ICDProcedureDateTime >  dateadd(day, 7, a.DPP4Filltime)
union all

select distinct a.*, b.SurgicalProcedureDateTime, c.ICD10ProcedureCode

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_CensusSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('5A2204Z')
and b.SurgicalProcedureDateTime >  dateadd(day, 7, a.DPP4Filltime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD10ProcedureCode

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('5A2204Z')
and b.DischargeDateTime >  dateadd(day, 7, a.DPP4Filltime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD10ProcedureCode

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('5A2204Z')
and b.DischargeDateTime >  dateadd(day, 7, a.DPP4Filltime)

select distinct scrssn from Dflt.Diabetes_AF_DPP4_CVAfter --110

/* DPP4 Ablation using CPT codes - 1 week after drug initiation */

select distinct a.*

into Dflt.Diabetes_AF_DPP4_AbAfter

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientCPTProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
Src.Cohort_CPT as c with (NOLOCK) on c.CPTSID=b.cptSID 
where c.cptcode in ('93656','93657','93662','33254','33255','33258','33265','33266')
and b.DischargeDateTime >  dateadd(day, 7, a.DPP4Filltime)
union all

select distinct a.*
from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Surg_SurgeryPrincipalAssociatedProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on b.OtherProcedureCPTSID=c.cptSID 
where c.cptcode in ('93656','93657','93662','33254','33255','33258','33265','33266') 
and b.SurgeryDateTime >  dateadd(day, 7, a.DPP4Filltime)
union all

select distinct a.*
from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Surg_SurgeryProcedureDiagnosisCode as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on b.PrincipalCPTSID=c.cptSID 
where c.cptcode in ('93656','93657','93662','33254','33255','33258','33265','33266')
and b.SurgeryDateTime >  dateadd(day, 7, a.DPP4Filltime)

select distinct scrssn from Dflt.Diabetes_AF_DPP4_AbAfter --7

/* Ablation using Procedure codes- 1 week after drug initiation */

select distinct a.*, b.ICDProcedureDateTime, c.ICD9ProcedureCode
/*ICD9Procedure Codes*/

into Dflt.Diabetes_AF_DPP4_AbProcAfter

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_CensusICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('37.33','37.34','37.37','37.80','38.65')
					and b.ICDProcedureDateTime>  dateadd(day, 7, a.DPP4Filltime)
union all

select distinct a.*, b.SurgicalProcedureDateTime, c.ICD9ProcedureCode

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_CensusSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('37.33','37.34','37.37','37.80','38.65')
					and b.SurgicalProcedureDateTime >  dateadd(day, 7, a.DPP4Filltime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD9ProcedureCode

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('37.33','37.34','37.37','37.80','38.65')
					and b.DischargeDateTime >  dateadd(day, 7, a.DPP4Filltime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD9ProcedureCode

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('37.33','37.34','37.37','37.80','38.65')
					and b.DischargeDateTime >  dateadd(day, 7, a.DPP4Filltime)
union all

/*ICD10Procedure Codes*/
select distinct a.*, b.ICDProcedureDateTime, c.ICD10ProcedureCode

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_CensusICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('02560ZZ','02563ZZ','02564ZZ',
'02570ZZ','02573ZZ','02574ZZ','02580ZZ','02583ZZ','02584ZZ','025S0ZZ','025S3ZZ','025S4ZZ','025T0ZZ','025T3ZZ','025T4ZZ')
and b.ICDProcedureDateTime >  dateadd(day, 7, a.DPP4Filltime)
union all

select distinct a.*, b.SurgicalProcedureDateTime, c.ICD10ProcedureCode

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_CensusSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('02560ZZ','02563ZZ','02564ZZ',
'02570ZZ','02573ZZ','02574ZZ','02580ZZ','02583ZZ','02584ZZ','025S0ZZ','025S3ZZ','025S4ZZ','025T0ZZ','025T3ZZ','025T4ZZ')
and b.SurgicalProcedureDateTime >  dateadd(day, 7, a.DPP4Filltime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD10ProcedureCode

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('02560ZZ','02563ZZ','02564ZZ',
'02570ZZ','02573ZZ','02574ZZ','02580ZZ','02583ZZ','02584ZZ','025S0ZZ','025S3ZZ','025S4ZZ','025T0ZZ','025T3ZZ','025T4ZZ')
and b.DischargeDateTime >  dateadd(day, 7, a.DPP4Filltime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD10ProcedureCode

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.Inpat_InpatientSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('02560ZZ','02563ZZ','02564ZZ',
'02570ZZ','02573ZZ','02574ZZ','02580ZZ','02583ZZ','02584ZZ','025S0ZZ','025S3ZZ','025S4ZZ','025T0ZZ','025T3ZZ','025T4ZZ')
and b.DischargeDateTime >  dateadd(day, 7, a.DPP4Filltime)

select distinct scrssn from Dflt.Diabetes_AF_DPP4_AbProcAfter--53


select distinct scrssn from Dflt.Diabetes_AF_GLP1 --1505

select distinct scrssn from Dflt.Diabetes_AF_DPP4GLP1--1991

select distinct scrssn from Dflt.Diabetes_AF_SGLT2 --3715

select distinct scrssn from Dflt.Diabetes_AF_DPP4 -- 2079

/* Medications with liberal criteria */

select distinct a.PatientSID, a.ScrSSN, a.SGLT2FillTime, b.FillDateTime, b.LocalDrugNameWithDose, b.FillNumber, b.DaysSupply, b.Qty

into #tempMedications1

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where b.FillDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(month, 6, a.SGLT2FillTime) and 
b.FillNumber >= '1'
union all

select distinct a.PatientSID, a.ScrSSN, a.SGLT2FillTime, b.FillDateTime, b.LocalDrugNameWithDose, b.FillNumber, b.DaysSupply, b.Qty

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where b.FillDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(month, 6, a.SGLT2FillTime) and 
b.FillNumber >= '1'

select distinct scrssn from #tempMedications1 --3715

/* Beta Blockers */

select distinct *

into Dflt.Diabetes_AF_SGLT2_BB1

from #tempMedications1 where LocalDrugNameWithDose like '%metoprolol%' or LocalDrugNameWithDose like '%carvedilol%' or LocalDrugNameWithDose like '%bisoprolol%' or
		LocalDrugNameWithDose like '%nebivolol%' or LocalDrugNameWithDose like '%atenolol%'

select distinct scrssn from Dflt.Diabetes_AF_SGLT2_BB1 --3369

/* ACE Inhibitor */

select distinct *

into Dflt.Diabetes_AF_SGLT2_ACE1

from #tempMedications1 where LocalDrugNameWithDose like '%lisinopril%' or LocalDrugNameWithDose like '%Fosinopril%' or LocalDrugNameWithDose like '%ramipril%' or
		LocalDrugNameWithDose like '%quinapril%' or LocalDrugNameWithDose like '%benazepril%'

select distinct scrssn from Dflt.Diabetes_AF_SGLT2_ACE1 --1691

/*ARB Inhibitor */

select distinct *

into Dflt.Diabetes_AF_SGLT2_ARB1

from #tempMedications1 where LocalDrugNameWithDose like '%valsartan%' or LocalDrugNameWithDose like '%losartan%' or LocalDrugNameWithDose like '%candesartan%' or
		LocalDrugNameWithDose like '%Olmesartan%' or LocalDrugNameWithDose like '%telmisartan%' or LocalDrugNameWithDose like '%irbesartan%' 

select distinct scrssn from Dflt.Diabetes_AF_SGLT2_ARB1 --1791

/* ACE and ARB */

select distinct * 

into Dflt.Diabetes_AF_SGLT2_ACEARB1

from Dflt.Diabetes_AF_SGLT2_ACE1
union all

select distinct *

from Dflt.Diabetes_AF_SGLT2_ARB1

select distinct scrssn from Dflt.Diabetes_AF_SGLT2_ACEARB1 --3063

/* Spironolactone/Eplerenone */

select distinct *

into Dflt.Diabetes_AF_SGLT2_SpiroEp1

from #tempMedications1 where LocalDrugNameWithDose like '%spironolactone%' or LocalDrugNameWithDose like '%Eplerenone%'

select distinct scrssn from Dflt.Diabetes_AF_SGLT2_SpiroEp1 --1553

/* Loop Diuretic */
/* Check for the LocalDrugNameWithDose in the dimension table */
select * from CDWWork.Dim.LocalDrug where LocalDrugNameWithDose like '%furosemide%' or LocalDrugNameWithDose like '%torsemide%' or LocalDrugNameWithDose like '%bumetanide%' or
		LocalDrugNameWithDose like '%Ethacrynic acid%' or LocalDrugNameWithDose like '%lasix%' or LocalDrugNameWithDose like '%bumex%'

select distinct *

into Dflt.Diabetes_AF_SGLT2_LoopDiuretic1

from #tempMedications1 where LocalDrugNameWithDose like '%furosemide%' or LocalDrugNameWithDose like '%torsemide%' or LocalDrugNameWithDose like '%bumetanide%' or
		LocalDrugNameWithDose like '%Ethacrynic acid%' or LocalDrugNameWithDose like '%lasix%' or LocalDrugNameWithDose like '%bumex%'

select distinct scrssn from Dflt.Diabetes_AF_SGLT2_LoopDiuretic1 --2976

/* Insulin */
select distinct *

into Dflt.Diabetes_AF_SGLT2_Insulin1

from #tempMedications1 where LocalDrugNameWithDose like '%insulin%' 

select distinct scrssn from Dflt.Diabetes_AF_SGLT2_Insulin1 --2976

/* DPP4 */

select distinct a.PatientSID, a.ScrSSN, a.DPP4FillTime, b.FillDateTime, b.LocalDrugNameWithDose, b.FillNumber, b.DaysSupply, b.Qty

into #tempMedicationsDPP41

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where b.FillDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(month, 6, a.DPP4FillTime) and
b.FillNumber >= '1'
union all

select distinct a.PatientSID, a.ScrSSN, a.DPP4FillTime, b.FillDateTime, b.LocalDrugNameWithDose, b.FillNumber, b.DaysSupply, b.Qty

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where b.FillDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(month, 6, a.DPP4FillTime) and 
b.FillNumber >= '1'

select distinct scrssn from #tempMedicationsDPP41--2079

/* Beta Blockers */

select distinct *

into Dflt.Diabetes_AF_DPP4_BB1

from #tempMedicationsDPP41 where LocalDrugNameWithDose like '%metoprolol%' or LocalDrugNameWithDose like '%carvedilol%' or LocalDrugNameWithDose like '%bisoprolol%' or
		LocalDrugNameWithDose like '%nebivolol%' or LocalDrugNameWithDose like '%atenolol%'

select distinct scrssn from Dflt.Diabetes_AF_DPP4_BB1 --1778

/* ACE Inhibitor */

select distinct *

into Dflt.Diabetes_AF_DPP4_ACE1

from #tempMedicationsDPP41 where LocalDrugNameWithDose like '%lisinopril%' or LocalDrugNameWithDose like '%Fosinopril%' or LocalDrugNameWithDose like '%ramipril%' or
		LocalDrugNameWithDose like '%quinapril%' or LocalDrugNameWithDose like '%benazepril%'

select distinct scrssn from Dflt.Diabetes_AF_DPP4_ACE1 --1150

/*ARB Inhibitor */

select distinct *

into Dflt.Diabetes_AF_DPP4_ARB1

from #tempMedicationsDPP41 where LocalDrugNameWithDose like '%valsartan%' or LocalDrugNameWithDose like '%losartan%' or LocalDrugNameWithDose like '%candesartan%' or
		LocalDrugNameWithDose like '%Olmesartan%' or LocalDrugNameWithDose like '%telmisartan%' or LocalDrugNameWithDose like '%irbesartan%' 

select distinct scrssn from Dflt.Diabetes_AF_DPP4_ARB1 --517

/* ACE and ARB */

select distinct * 

into Dflt.Diabetes_AF_DPP4_ACEARB1

from Dflt.Diabetes_AF_DPP4_ACE1
union all

select distinct *

from Dflt.Diabetes_AF_DPP4_ARB1

select distinct scrssn from Dflt.Diabetes_AF_DPP4_ACEARB1 --1565

/* Spironolactone/Eplerenone */

select distinct *

into Dflt.Diabetes_AF_DPP4_SpiroEp1

from #tempMedicationsDPP41 where LocalDrugNameWithDose like '%spironolactone%' or LocalDrugNameWithDose like '%Eplerenone%'

select distinct scrssn from Dflt.Diabetes_AF_DPP4_SpiroEp1 --441

/* Loop Diuretic */
select distinct *

into Dflt.Diabetes_AF_DPP4_LoopDiuretic1

from #tempMedicationsDPP41

where LocalDrugNameWithDose like '%furosemide%' or LocalDrugNameWithDose like '%torsemide%' or LocalDrugNameWithDose like '%bumetanide%' or
LocalDrugNameWithDose like '%Ethacrynic acid%' or LocalDrugNameWithDose like '%lasix%' or LocalDrugNameWithDose like '%bumex%'

select distinct scrssn from Dflt.Diabetes_AF_DPP4_LoopDiuretic1 --1324

/* Insulin */

select distinct *

into Dflt.Diabetes_AF_DPP4_Insulin1

from #tempMedicationsDPP41 where LocalDrugNameWithDose like '%insulin%' 

select distinct scrssn from Dflt.Diabetes_AF_DPP4_Insulin1 --499

/*Extracting drug names within treatment groups */
/* Drug name for SGLT2 */

drop table Dflt.Diabetes_AF_SGLT2_Drugdose

select distinct a.scrssn, a.SGLT2FillTime,b.filldatetime, b.LocalDrugNameWithDose, b.DrugNameWithoutDose

into #tempsglt2dose

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where LocalDrugNameWithDose like '%empagliflozin%' 
or LocalDrugNameWithDose like '%dapagliflozin%' 
or LocalDrugNameWithDose like '%canagliflozin%' 
or LocalDrugNameWithDose like '%ertugliflozin%'
union all

select distinct a.scrssn, a.SGLT2FillTime,b.filldatetime, b.LocalDrugNameWithDose,  b.DrugNameWithoutDose

from Dflt.Diabetes_AF_SGLT2 as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where LocalDrugNameWithDose like '%empagliflozin%' 
or LocalDrugNameWithDose like '%dapagliflozin%' 
or LocalDrugNameWithDose like '%canagliflozin%' 
or LocalDrugNameWithDose like '%ertugliflozin%'

select distinct *

into Dflt.Diabetes_AF_SGLT2_Drugdose 

from #tempsglt2dose

where SGLT2Filltime = FillDateTime and SGLT2Filltime >= '2014-01-01 00:00:00'

select distinct scrssn from Dflt.Diabetes_AF_SGLT2_Drugdose--3715

select * from Dflt.Diabetes_AF_SGLT2_Drugdose

select distinct scrssn 
from Dflt.Diabetes_AF_SGLT2_Drugdose 
where LocalDrugNameWithDose like '%empagliflozin%'  -- and GLP1Filltime >= '2014-01-01 00:00:00' --3699 (99.6%)

select distinct scrssn 
from Dflt.Diabetes_AF_SGLT2_Drugdose 
where LocalDrugNameWithDose like '%dapagliflozin%'   --and GLP1Filltime >= '2014-01-01 00:00:00' --11

select distinct scrssn 
from Dflt.Diabetes_AF_SGLT2_Drugdose 
where LocalDrugNameWithDose like '%canagliflozin%'   --and GLP1Filltime >= '2014-01-01 00:00:00' --2

select distinct scrssn 
from Dflt.Diabetes_AF_SGLT2_Drugdose 
where LocalDrugNameWithDose like '%ertugliflozin%'   --and GLP1Filltime >= '2014-01-01 00:00:00' --1

/* Drug name for DPP4 */

select distinct a.scrssn, a. dpp4filltime, b.LocalDrugNameWithDose, b.FillDateTime, b.DrugNameWithoutDose

into #tempdpp4glpdose

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where LocalDrugNameWithDose like '%gliptin%' or
      LocalDrugNameWithDose like '%Glipizide%' or
			  LocalDrugNameWithDose like '%Glimepiride%' or
			  LocalDrugNameWithDose like '%Glyburide%' or
			  LocalDrugNameWithDose like '%Tolbutamide%'  
union all

select distinct a.scrssn, a. dpp4filltime, b.LocalDrugNameWithDose, b.FillDateTime, b.DrugNameWithoutDose

from Dflt.Diabetes_AF_DPP4 as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where LocalDrugNameWithDose like '%gliptin%' or
      LocalDrugNameWithDose like '%Glipizide%' or
			  LocalDrugNameWithDose like '%Glimepiride%' or
			  LocalDrugNameWithDose like '%Glyburide%' or
			  LocalDrugNameWithDose like '%Tolbutamide%' 

select distinct *

into Dflt.Diabetes_AF_DPP4_Drugdose 

from #tempdpp4glpdose

where DPP4Filltime = FillDateTime and DPP4Filltime >= '2014-01-01 00:00:00'

select distinct scrssn from Dflt.Diabetes_AF_DPP4_Drugdose --2079

select distinct scrssn 
from Dflt.Diabetes_AF_DPP4_Drugdose 
where LocalDrugNameWithDose like '%gliptin%' -- 510

select distinct scrssn 
from Dflt.Diabetes_AF_DPP4_Drugdose 
where LocalDrugNameWithDose like '%Glipizide%'  --1306

select distinct scrssn 
from Dflt.Diabetes_AF_DPP4_Drugdose
where LocalDrugNameWithDose like '%Glimepiride%'  --85

select distinct scrssn 
from Dflt.Diabetes_AF_DPP4_Drugdose 
where LocalDrugNameWithDose like '%Glyburide%'  --3

select distinct scrssn 
from Dflt.Diabetes_AF_DPP4_Drugdose 
where LocalDrugNameWithDose like '%Tolbutamide%' --0
