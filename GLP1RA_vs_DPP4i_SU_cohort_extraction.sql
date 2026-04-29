/* Diabetic Afib GLP1 Study */

/* Run the below command to select the required database */
use ORD_Sundaram_202108013D
go

/* Diabetes patient population using ICD9 and ICD 10 diagnosis codes */
/* Making sure the codes are available in the CDWWork Dimension table */
select distinct scrssn from Dflt.Diabetes_final

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('250.00','250.10','250.20','250.30','250.40','250.50','250.60','250.70','250.80','250.90')

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code like 'E11%' 

select distinct a.PatientSID, a.ScrSSN, a.Sta3n, b.DischargeDateTime, c.ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_AFfinal

from Src.CohortCrosswalk as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('250.00','250.10','250.20','250.30','250.40','250.50','250.60','250.70','250.80','250.90')
and b.Dischargedatetime between '2000-01-01 00:00:00' and '2022-12-31 23:59:59' 
union all

select distinct a.PatientSID, a.ScrSSN, a.Sta3n, b.DischargeDateTime, c.ICD9Code

from Src.CohortCrosswalk as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('250.00','250.10','250.20','250.30','250.40','250.50','250.60','250.70','250.80','250.90')	
and b.Dischargedatetime between '2000-01-01 00:00:00' and  '2022-12-31 23:59:59' 
union all

select distinct a.PatientSID, a.ScrSSN, a.Sta3n, b.DischargeDateTime, c.ICD9Code

from Src.CohortCrosswalk as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('250.00','250.10','250.20','250.30','250.40','250.50','250.60','250.70','250.80','250.90')
and b.Dischargedatetime between '2000-01-01 00:00:00' and '2022-12-31 23:59:59' 
union all

select distinct a.PatientSID, a.ScrSSN, a.Sta3n, b.EventDateTime, c.ICD9Code

from Src.CohortCrosswalk as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('250.00','250.10','250.20','250.30','250.40','250.50','250.60','250.70','250.80','250.90')
and b.EventDateTime between '2000-01-01 00:00:00' and '2022-12-31 23:59:59' 
union all

select distinct a.PatientSID, a.ScrSSN, a.Sta3n, b.EventDateTime, c.ICD9Code

from Src.CohortCrosswalk as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('250.00','250.10','250.20','250.30','250.40','250.50','250.60','250.70','250.80','250.90')
and b.EventDateTime between '2000-01-01 00:00:00' and '2022-12-31 23:59:59' 
union all

select distinct a.PatientSID, a.ScrSSN, a.Sta3n, b.EventDateTime, c.ICD9Code

from Src.CohortCrosswalk as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('250.00','250.10','250.20','250.30','250.40','250.50','250.60','250.70','250.80','250.90')
and b.EventDateTime between '2000-01-01 00:00:00' and '2022-12-31 23:59:59'
union all

select distinct a.PatientSID, a.ScrSSN, a.Sta3n, b.PatientTransferDateTime, c.ICD9Code

from Src.CohortCrosswalk as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('250.00','250.10','250.20','250.30','250.40','250.50','250.60','250.70','250.80','250.90')
and b.PatientTransferDateTime between '2000-01-01 00:00:00' and '2022-12-31 23:59:59' 
union all

select distinct a.PatientSID, a.ScrSSN, a.Sta3n, b.SpecialtyTransferDateTime, c.ICD9Code

from Src.CohortCrosswalk as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('250.00','250.10','250.20','250.30','250.40','250.50','250.60','250.70','250.80','250.90')
and b.SpecialtyTransferDateTime between '2000-01-01 00:00:00' and '2022-12-31 23:59:59'
union all

select distinct a.PatientSID, a.ScrSSN, a.Sta3n, b.AdmitDateTime, c.ICD9Code

from Src.CohortCrosswalk as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('250.00','250.10','250.20','250.30','250.40','250.50','250.60','250.70','250.80','250.90')
and b.AdmitDateTime between '2000-01-01 00:00:00' and '2022-12-31 23:59:59' 
union all

/*ICD10 Codes*/
select distinct a.PatientSID, a.ScrSSN, a.Sta3n, b.DischargeDateTime, c.ICD10Code

from Src.CohortCrosswalk as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'E11%' 
and b.Dischargedatetime between '2000-01-01 00:00:00' and '2022-12-31 23:59:59'
union all

select distinct a.PatientSID, a.ScrSSN, a.Sta3n, b.DischargeDateTime, c.ICD10Code

from Src.CohortCrosswalk as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'E11%' 
and b.Dischargedatetime between '2000-01-01 00:00:00' and '2022-12-31 23:59:59'
union all

select distinct a.PatientSID, a.ScrSSN, a.Sta3n, b.DischargeDateTime, c.ICD10Code

from Src.CohortCrosswalk as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'E11%' 
and b.Dischargedatetime between '2000-01-01 00:00:00' and '2022-12-31 23:59:59' 
union all

select distinct a.PatientSID, a.ScrSSN, a.Sta3n, b.EventDateTime, c.ICD10Code

from Src.CohortCrosswalk as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'E11%' 
and b.EventDateTime between '2000-01-01 00:00:00' and '2022-12-31 23:59:59' 
union all

select distinct a.PatientSID, a.ScrSSN, a.Sta3n, b.EventDateTime, c.ICD10Code

from Src.CohortCrosswalk as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'E11%' 
and b.EventDateTime between '2000-01-01 00:00:00' and '2022-12-31 23:59:59'
union all

select distinct a.PatientSID, a.ScrSSN, a.Sta3n, b.EventDateTime, c.ICD10Code

from Src.CohortCrosswalk as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'E11%' 
and b.EventDateTime between '2000-01-01 00:00:00' and '2022-12-31 23:59:59'
union all

select distinct a.PatientSID, a.ScrSSN, a.Sta3n, b.PatientTransferDateTime, c.ICD10Code

from Src.CohortCrosswalk as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'E11%' 
and b.PatientTransferDateTime between '2000-01-01 00:00:00' and '2022-12-31 23:59:59' 
union all

select distinct a.PatientSID, a.ScrSSN, a.Sta3n, b.SpecialtyTransferDateTime, c.ICD10Code

from Src.CohortCrosswalk as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'E11%' 
and b.SpecialtyTransferDateTime between '2000-01-01 00:00:00' and '2022-12-31 23:59:59' 
union all

select distinct a.PatientSID, a.ScrSSN, a.Sta3n, b.AdmitDateTime, c.ICD10Code

from Src.CohortCrosswalk as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'E11%' 
and b.AdmitDateTime between '2000-01-01 00:00:00' and '2022-12-31 23:59:59' 

select distinct scrssn from Dflt.Diabetes_AFfinal --1,435,168
alter table Dflt.Diabetes_AFfinal  rebuild with (data_compression=page)

/* Atrial Fibiillation */
/* Making sure the codes are available in the CDWWork Dimension table */

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('427.31')

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code like 'I48.%'

select distinct a.PatientSID,a.ScrSSN, b.DischargeDateTime as AF_Dischargedatetime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_AF

from Dflt.Diabetes_AFfinal as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')		
union all

select distinct a.PatientSID,a.ScrSSN, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AFfinal as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
union all

select distinct a.PatientSID,a.ScrSSN, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AFfinal as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
union all

select distinct a.PatientSID,a.ScrSSN, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AFfinal as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
union all

select distinct a.PatientSID,a.ScrSSN,  b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AFfinal as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
union all

select distinct a.PatientSID,a.ScrSSN,  b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AFfinal as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
union all

select distinct a.PatientSID,a.ScrSSN, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AFfinal as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
union all

select distinct a.PatientSID,a.ScrSSN,  b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AFfinal as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
union all

select distinct a.PatientSID,a.ScrSSN,  b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_AFfinal as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
union all

/*ICD10 Codes*/
select distinct a.PatientSID,a.ScrSSN, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AFfinal as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
union all

select distinct a.PatientSID,a.ScrSSN,  b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AFfinal as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
union all

select distinct a.PatientSID,a.ScrSSN, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AFfinal as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
union all

select distinct a.PatientSID,a.ScrSSN,  b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AFfinal as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
union all

select distinct a.PatientSID,a.ScrSSN,  b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AFfinal as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
union all

select distinct a.PatientSID,a.ScrSSN, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AFfinal as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'

union all

select distinct a.PatientSID,a.ScrSSN,  b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AFfinal as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'

union all

select distinct a.PatientSID,a.ScrSSN, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AFfinal as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'

union all

select distinct a.PatientSID,a.ScrSSN,   b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_AFfinal as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'

select distinct scrssn from Dflt.Diabetes_AF -- 438,238
alter table Dflt.Diabetes_AF  rebuild with (data_compression=page)

/* Atrial Fibrillation inpatient */

select distinct a.PatientSID,a.ScrSSN, b.DischargeDateTime as AF_Dischargedatetime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_AFInpatient

from Dflt.Diabetes_AFfinal as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')		
union all

select distinct a.PatientSID,a.ScrSSN, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AFfinal as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
union all

select distinct a.PatientSID,a.ScrSSN, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AFfinal as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
union all

select distinct a.PatientSID,a.ScrSSN, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AFfinal as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
union all

select distinct a.PatientSID,a.ScrSSN,  b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AFfinal as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
union all

select distinct a.PatientSID,a.ScrSSN,  b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_AFfinal as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
union all

/*ICD10 Codes*/
select distinct a.PatientSID,a.ScrSSN, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AFfinal as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
union all

select distinct a.PatientSID,a.ScrSSN,  b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AFfinal as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
union all

select distinct a.PatientSID,a.ScrSSN, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AFfinal as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
union all

select distinct a.PatientSID,a.ScrSSN,  b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AFfinal as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'

union all

select distinct a.PatientSID,a.ScrSSN, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AFfinal as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'

union all

select distinct a.PatientSID,a.ScrSSN,   b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_AFfinal as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'

select distinct scrssn from Dflt.Diabetes_AFInpatient --360,355

alter table Dflt.Diabetes_AFInpatient  rebuild with (data_compression=page)

/* Atrial Fibrillation Outpatient */

/*ICD9 Codes*/

select distinct a.PatientSID,a.ScrSSN, b.EventDateTime as AF_Dischargedatetime, c.ICD9Code as comorbidity_ICD9Code

into Dflt.Diabetes_AFOutpatient

from Dflt.Diabetes_AFfinal as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
union all

select distinct a.PatientSID,a.ScrSSN,  b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AFfinal as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
union all

select distinct a.PatientSID,a.ScrSSN,  b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AFfinal as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
union all

/*ICD 10 Codes */

select distinct a.PatientSID,a.ScrSSN,  b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AFfinal as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
union all

select distinct a.PatientSID,a.ScrSSN,  b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AFfinal as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
union all

select distinct a.PatientSID,a.ScrSSN, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AFfinal as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'

select distinct scrssn from Dflt.Diabetes_AFOutpatient --369,967

alter table Dflt.Diabetes_AFoutpatient  rebuild with (data_compression=page)

/* Atrial Fibrillation outpatient and inpatient */

select distinct a.*

into Dflt.Diabetes_AFInpatOutpat

from Dflt.Diabetes_AFInpatient as a with (NOLOCK) inner join
Dflt.Diabetes_AFOutpatient as b with (NOLOCK) on a.ScrSSN = b.ScrSSN 

select distinct scrssn from Dflt.Diabetes_AFInpatOutpat --292,084
alter table Dflt.Diabetes_AFInpatOutpat  rebuild with (data_compression=page)

/* First instance of Afib diagnosis */

select scrssn, min(AF_Dischargedatetime) as AF_Dischargedatetime
into #tempAFtime
from Dflt.Diabetes_AF group by scrssn

select distinct a.scrssn, a.AF_Dischargedatetime, b.patientsid, b.comorbidity_ICD9Code
into Dflt.Diabetes_AFFirst
from #tempAFtime as a with (NOLOCK) left outer join 
Dflt.Diabetes_AF as b with (NOLOCK) on a.scrssn= b.scrssn and b.AF_Dischargedatetime=a.AF_Dischargedatetime

select distinct scrssn from Dflt.Diabetes_AFFirst --438,238
alter table Dflt.Diabetes_AFFirst rebuild with (data_compression=page)
select distinct scrssn from Dflt.Diabetes_AFFirst where AF_Dischargedatetime is NULL --77,941

/* Anti-Coagulation */

select * from CDWWork.Dim.LocalDrug where LocalDrugNameWithDose like '%Warfarin%'
select * from CDWWork.Dim.LocalDrug where LocalDrugNameWithDose like '%Rivaroxaban%'
select * from CDWWork.Dim.LocalDrug where LocalDrugNameWithDose like '%Apixaban%'
select * from CDWWork.Dim.LocalDrug where LocalDrugNameWithDose like '%Dabigatran%'


select distinct a.scrssn, a.patientsid, a.AF_Dischargedatetime, b.Drugnamewithoutdose, b.LocalDrugNameWithDose, b.FillDateTime as AntiCoagFilldateTime, b.FillNumber, b.DaysSupply, b.Qty

into #tempAnticoag

from Dflt.Diabetes_AFFirst as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where LocalDrugNameWithDose like '%Warfarin%' or
LocalDrugNameWithDose like '%Rivaroxaban%' or
			  LocalDrugNameWithDose like '%Apixaban%' or
			  LocalDrugNameWithDose like '%Dabigatran%' 
union all

select distinct a.scrssn, a.patientsid, a.AF_Dischargedatetime, b.Drugnamewithoutdose, b.LocalDrugNameWithDose, b.FillDateTime as AntiCoagFilldateTime, b.FillNumber, b.DaysSupply, b.Qty

from Dflt.Diabetes_AFFirst as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where LocalDrugNameWithDose like '%Warfarin%' or
LocalDrugNameWithDose like '%Rivaroxaban%' or
			  LocalDrugNameWithDose like '%Apixaban%' or
			  LocalDrugNameWithDose like '%Dabigatran%' 

drop table Dflt.Diabetes_AFAnticoag

Select *

into Dflt.Diabetes_AFAnticoag

from #tempanticoag
where FillNumber >3 

select distinct scrssn from Dflt.Diabetes_AFAnticoag --78,719
alter table Dflt.Diabetes_AFAnticoag  rebuild with (data_compression=page)

/* Exclude patients on DVT (Deep vein Thrombosis) and PE (Pulmonary Embolism) */

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('453.40','415.1')
select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('I82.409','I26.9')
select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code like 'I82.40%'

select distinct a.PatientSID,a.ScrSSN, a.AF_Dischargedatetime, a.DrugNameWithoutDose, a.FillNumber, b.DischargeDateTime
/*ICD9 Codes*/

into #tempDVTPE

from Dflt.Diabetes_AFAnticoag as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('453.40','415.1')	
and b.DischargeDateTime between dateadd(month, -12, a.AF_Dischargedatetime) and a.AF_Dischargedatetime
union all

select distinct a.PatientSID,a.ScrSSN, a.AF_Dischargedatetime, a.DrugNameWithoutDose, a.FillNumber, b.DischargeDateTime

from Dflt.Diabetes_AFAnticoag as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('453.40','415.1')
and b.DischargeDateTime between dateadd(month, -12, a.AF_Dischargedatetime) and a.AF_Dischargedatetime
union all

select distinct a.PatientSID,a.ScrSSN, a.AF_Dischargedatetime, a.DrugNameWithoutDose, a.FillNumber, b.DischargeDateTime

from Dflt.Diabetes_AFAnticoag as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('453.40','415.1')
and b.DischargeDateTime between dateadd(month, -12, a.AF_Dischargedatetime) and a.AF_Dischargedatetime
union all

select distinct a.PatientSID,a.ScrSSN, a.AF_Dischargedatetime, a.DrugNameWithoutDose, a.FillNumber, b.PatientTransferDateTime

from Dflt.Diabetes_AFAnticoag as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('453.40','415.1')
and b.PatientTransferDateTime between dateadd(month, -12, a.AF_Dischargedatetime) and a.AF_Dischargedatetime
union all

select distinct a.PatientSID,a.ScrSSN,  a.AF_Dischargedatetime, a.DrugNameWithoutDose, a.FillNumber, b.SpecialtyTransferDateTime

from Dflt.Diabetes_AFAnticoag as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('453.40','415.1')
and b.SpecialtyTransferDateTime  between dateadd(month, -12, a.AF_Dischargedatetime) and a.AF_Dischargedatetime
union all

select distinct a.PatientSID,a.ScrSSN,  a.AF_Dischargedatetime, a.DrugNameWithoutDose, a.FillNumber, b.DischargeDateTime

from Dflt.Diabetes_AFAnticoag as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('453.40','415.1')
and b.DischargeDateTime between dateadd(month, -12, a.AF_Dischargedatetime) and a.AF_Dischargedatetime
union all

select distinct a.PatientSID,a.ScrSSN,  a.AF_Dischargedatetime, a.DrugNameWithoutDose, a.FillNumber, b.EventDateTime

from Dflt.Diabetes_AFAnticoag as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('453.40','415.1')
and b.EventDateTime between dateadd(month, -12, a.AF_Dischargedatetime) and a.AF_Dischargedatetime
union all

select distinct a.PatientSID,a.ScrSSN,  a.AF_Dischargedatetime, a.DrugNameWithoutDose, a.FillNumber, b.EventDateTime

from Dflt.Diabetes_AFAnticoag as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('453.40','415.1')
and b.EventDateTime between dateadd(month, -12, a.AF_Dischargedatetime) and a.AF_Dischargedatetime
union all

select distinct a.PatientSID,a.ScrSSN,  a.AF_Dischargedatetime, a.DrugNameWithoutDose, a.FillNumber, b.EventDateTime

from Dflt.Diabetes_AFAnticoag as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('453.40','415.1')
and b.EventDateTime between dateadd(month, -12, a.AF_Dischargedatetime) and a.AF_Dischargedatetime
union all

/*ICD10 Codes*/
select distinct a.PatientSID,a.ScrSSN, a.AF_Dischargedatetime, a.DrugNameWithoutDose, a.FillNumber, b.DischargeDateTime

from Dflt.Diabetes_AFAnticoag as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.DischargeDateTime between dateadd(month, -12, a.AF_Dischargedatetime) and a.AF_Dischargedatetime
union all

select distinct a.PatientSID,a.ScrSSN,  a.AF_Dischargedatetime, a.DrugNameWithoutDose, a.FillNumber, b.DischargeDateTime

from Dflt.Diabetes_AFAnticoag as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I82.409','I26.9')
and b.DischargeDateTime between dateadd(month, -12, a.AF_Dischargedatetime) and a.AF_Dischargedatetime
union all

select distinct a.PatientSID,a.ScrSSN, a.AF_Dischargedatetime, a.DrugNameWithoutDose, a.FillNumber, b.DischargeDateTime

from Dflt.Diabetes_AFAnticoag as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I82.409','I26.9')
and b.DischargeDateTime between dateadd(month, -12, a.AF_Dischargedatetime) and a.AF_Dischargedatetime
union all

select distinct a.PatientSID,a.ScrSSN,  a.AF_Dischargedatetime, a.DrugNameWithoutDose, a.FillNumber, b.PatientTransferDateTime

from Dflt.Diabetes_AFAnticoag as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I82.409','I26.9')
and b.PatientTransferDateTime between dateadd(month, -12, a.AF_Dischargedatetime) and a.AF_Dischargedatetime
union all

select distinct a.PatientSID,a.ScrSSN, a.AF_Dischargedatetime, a.DrugNameWithoutDose, a.FillNumber, b.SpecialtyTransferDateTime

from Dflt.Diabetes_AFAnticoag as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I82.409','I26.9')
and b.SpecialtyTransferDateTime between dateadd(month, -12, a.AF_Dischargedatetime) and a.AF_Dischargedatetime
union all

select distinct a.PatientSID,a.ScrSSN, a.AF_Dischargedatetime, a.DrugNameWithoutDose, a.FillNumber, b.AdmitDateTime

from Dflt.Diabetes_AFAnticoag as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I82.409','I26.9')
and b.AdmitDateTime between dateadd(month, -12, a.AF_Dischargedatetime) and a.AF_Dischargedatetime
union all

select distinct a.PatientSID,a.ScrSSN, a.AF_Dischargedatetime, a.DrugNameWithoutDose, a.FillNumber, b.EventDateTime

from Dflt.Diabetes_AFAnticoag as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I82.409','I26.9')
and b.EventDateTime between dateadd(month, -12, a.AF_Dischargedatetime) and a.AF_Dischargedatetime
union all

select distinct a.PatientSID,a.ScrSSN, a.AF_Dischargedatetime, a.DrugNameWithoutDose, a.FillNumber, b.EventDateTime

from Dflt.Diabetes_AFAnticoag as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I82.409','I26.9')
and b.EventDateTime between dateadd(month, -12, a.AF_Dischargedatetime) and a.AF_Dischargedatetime
union all

select distinct a.PatientSID,a.ScrSSN, a.AF_Dischargedatetime, a.DrugNameWithoutDose, a.FillNumber, b.EventDateTime

from Dflt.Diabetes_AFAnticoag as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I82.409','I26.9')
and b.EventDateTime between dateadd(month, -12, a.AF_Dischargedatetime) and a.AF_Dischargedatetime

select distinct scrssn from #tempdvtpe --1070

select distinct a.*--, b.DischargeDateTime, c.ICD10ProcedureCode

into Dflt.Diabetes_AfibFinal

from Dflt.Diabetes_AFAnticoag as a where a.fillnumber > 3
AND NOT EXISTS (Select * from #tempdvtpe as b where a.ScrSSN = b.ScrSSN)

select distinct scrssn from Dflt.Diabetes_AfibFinal --77,649
alter table Dflt.Diabetes_AfibFinal rebuild with (data_compression=page)

/* GLP1 */

select distinct LocalDrugNameWithDose from CDWWork.Dim.LocalDrug where LocalDrugNameWithDose like '%semaglutide%' 
or LocalDrugNameWithDose like '%exenatide%' 
or LocalDrugNameWithDose like '%liraglutide%' 
or LocalDrugNameWithDose like '%lixisenatide%' 
or LocalDrugNameWithDose like '%dulaglutide%'

select distinct a.PatientSID, a.ScrSSN, a.AF_Dischargedatetime, b.FillDateTime as GLP1FillTime , b.FillNumber, b.DaysSupply

into Dflt.Glp1AF

from Dflt.Diabetes_AFibFinal as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill as b with (NOLOCK) on a.PatientSID= b.PatientSID
where b.LocalDrugNameWithDose like '%semaglutide%' 
or b.LocalDrugNameWithDose like '%exenatide%' 
or b.LocalDrugNameWithDose like '%liraglutide%' 
or b.LocalDrugNameWithDose like '%lixisenatide%' 
or b.LocalDrugNameWithDose like '%dulaglutide%'
union all

select distinct a.PatientSID, a.ScrSSN, a.AF_Dischargedatetime, b.FillDateTime as GLP1FillTime , b.FillNumber, b.DaysSupply

from Dflt.Diabetes_AFibFinal as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID
where b.LocalDrugNameWithDose like '%semaglutide%' 
or b.LocalDrugNameWithDose like '%exenatide%' 
or b.LocalDrugNameWithDose like '%liraglutide%' 
or b.LocalDrugNameWithDose like '%lixisenatide%' 
or b.LocalDrugNameWithDose like '%dulaglutide%'

Select distinct scrssn from Dflt.Glp1AF -- 8917

select scrssn, min(GLP1FillTime) as GLP1FillTime
into #tempfilltime
from Dflt.Glp1AF group by scrssn

select scrssn, sum(FillNumber) as FillNumber 
into #tempfillnumber
from Dflt.Glp1AF group by scrssn

select distinct b.scrssn, b.GLP1FillTime, a.FillNumber
into #tempfilldate
from #tempfillnumber as a with (NOLOCK) left outer join 
#tempfilltime as b with (NOLOCK) on a.scrssn= b.scrssn

select distinct scrssn from #tempfilldate --8917

select distinct b.scrssn, b.GLP1FillTime, b.FillNumber,a.patientsid, a.AF_Dischargedatetime
into #date
from Dflt.Glp1AF as a with (NOLOCK) left outer join 
#tempfilldate as b with (NOLOCK) on a.scrssn= b.scrssn and b.GLP1FillTime=a.glp1filltime
where b.GLP1FillTime between '2015-01-01 00:00:00' and '2021-07-31 23:59:59'
and b.GLP1FillTime >= dateadd(day, 30, a.AF_Dischargedatetime)

select distinct scrssn from #date --3,553

/* Remove patients that were on DPP4 1 year prior to GLP1 initiation */

select distinct a.scrssn, a.GLP1FillTime, a.PatientSID, b.FillDateTime

into #DPP4

from #date as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where LocalDrugNameWithDose like '%gliptin%' or
      LocalDrugNameWithDose like '%Glipizide%' or
			  LocalDrugNameWithDose like '%Glimepiride%' or
			  LocalDrugNameWithDose like '%Glyburide%' or
			  LocalDrugNameWithDose like '%Tolbutamide%' 
union all

select distinct a.scrssn, a.GLP1FillTime, a.PatientSID, b.FillDateTime
from #date as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where LocalDrugNameWithDose like '%gliptin%' or
      LocalDrugNameWithDose like '%Glipizide%' or
			  LocalDrugNameWithDose like '%Glimepiride%' or
			  LocalDrugNameWithDose like '%Glyburide%' or
			  LocalDrugNameWithDose like '%Tolbutamide%' 

select distinct scrssn from #DPP4 --3030

select distinct *

into #DPP4Date

from #DPP4
where FillDateTime between dateadd(month, -12, GLP1FillTime) and dateadd(day, 1, GLP1FillTime)

select distinct scrssn from #DPP4Date --1584

select distinct a.*

into #GLP1excludeDpp4

from #date as a where a.fillnumber >=2
AND NOT EXISTS (Select * from #dpp4date as b where a.ScrSSN = b.ScrSSN)

select distinct scrssn from #GLP1excludeDpp4 --1887

select * from #GLP1excludeDpp4

/* Final Cohort (AF/ cardioversion/ Ablation/ Anti Arrythmic Drugs) */

/* AF Diagnosis 1 year prior to drug initiation */
select distinct a.PatientSID,a.ScrSSN,   b.DischargeDateTime ,a.GLP1FillTime, a.AF_Dischargedatetime

into #tempAF

from #GLP1excludeDpp4 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')	
and b.DischargeDateTime	between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.PatientSID,a.ScrSSN, b.DischargeDateTime, a.GLP1FillTime, a.AF_Dischargedatetime

from #GLP1excludeDpp4 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
and b.DischargeDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.PatientSID,a.ScrSSN, b.DischargeDateTime, a.GLP1FillTime, a.AF_Dischargedatetime

from #GLP1excludeDpp4 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
and b.DischargeDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.PatientSID,a.ScrSSN, b.EventDateTime, a.GLP1FillTime, a.AF_Dischargedatetime

from #GLP1excludeDpp4 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
and b.EventDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.PatientSID,a.ScrSSN,  b.EventDateTime, a.GLP1FillTime, a.AF_Dischargedatetime

from #GLP1excludeDpp4 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
and b.EventDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.PatientSID,a.ScrSSN,  b.EventDateTime, a.GLP1FillTime, a.AF_Dischargedatetime

from #GLP1excludeDpp4 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
and b.EventDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.PatientSID,a.ScrSSN, b.PatientTransferDateTime, a.GLP1FillTime, a.AF_Dischargedatetime

from #GLP1excludeDpp4 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
and b.PatientTransferDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.PatientSID,a.ScrSSN,  b.SpecialtyTransferDateTime, a.GLP1FillTime, a.AF_Dischargedatetime

from #GLP1excludeDpp4 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
and b.SpecialtyTransferDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.PatientSID,a.ScrSSN,  b.AdmitDateTime, a.GLP1FillTime, a.AF_Dischargedatetime

from #GLP1excludeDpp4 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
and b.AdmitDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

/*ICD10 Codes*/
select distinct a.PatientSID,a.ScrSSN, b.DischargeDateTime, a.GLP1FillTime, a.AF_Dischargedatetime

from #GLP1excludeDpp4 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.DischargeDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.PatientSID,a.ScrSSN,  b.DischargeDateTime, a.GLP1FillTime, a.AF_Dischargedatetime

from #GLP1excludeDpp4 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.DischargeDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.PatientSID,a.ScrSSN, b.DischargeDateTime, a.GLP1FillTime, a.AF_Dischargedatetime

from #GLP1excludeDpp4 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.DischargeDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.PatientSID,a.ScrSSN,  b.EventDateTime, a.GLP1FillTime, a.AF_Dischargedatetime

from #GLP1excludeDpp4 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.EventDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.PatientSID,a.ScrSSN,  b.EventDateTime, a.GLP1FillTime, a.AF_Dischargedatetime

from #GLP1excludeDpp4 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.EventDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.PatientSID,a.ScrSSN, b.EventDateTime, a.GLP1FillTime, a.AF_Dischargedatetime

from #GLP1excludeDpp4 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.EventDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)

union all

select distinct a.PatientSID,a.ScrSSN,  b.PatientTransferDateTime, a.GLP1FillTime, a.AF_Dischargedatetime

from #GLP1excludeDpp4 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.PatientTransferDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)

union all

select distinct a.PatientSID,a.ScrSSN, b.SpecialtyTransferDateTime, a.GLP1FillTime, a.AF_Dischargedatetime

from #GLP1excludeDpp4 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.SpecialtyTransferDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)

union all

select distinct a.PatientSID,a.ScrSSN,   b.AdmitDateTime, a.GLP1FillTime, a.AF_Dischargedatetime

from #GLP1excludeDpp4 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.AdmitDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)

select distinct scrssn from #tempAF --832

/* Cardioversion */
/* Cardioversion Proc codes */

select distinct ICD9ProcedureCode from CDWWork.Dim.ICD9Procedure where ICD9ProcedureCode in ('99.61','99.62') 
select distinct ICD10ProcedureCode from CDWWork.Dim.ICD10Procedure where ICD10ProcedureCode in ('5A2204Z') 

select distinct a.*, b.ICDProcedureDateTime, c.ICD9ProcedureCode
/*ICD9Procedure Codes*/

into #tempAFCardio

from #GLP1excludeDpp4 as a with (NOLOCK) inner join
Src.Inpat_CensusICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('99.61','99.62')
					and b.ICDProcedureDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.*, b.SurgicalProcedureDateTime, c.ICD9ProcedureCode

from #GLP1excludeDpp4 as a with (NOLOCK) inner join
Src.Inpat_CensusSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('99.61','99.62')
					and b.SurgicalProcedureDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD9ProcedureCode

from #GLP1excludeDpp4 as a with (NOLOCK) inner join
Src.Inpat_InpatientICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('99.61','99.62')
					and b.DischargeDateTime  between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD9ProcedureCode

from #GLP1excludeDpp4 as a with (NOLOCK) inner join
Src.Inpat_InpatientSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('99.61','99.62')
					and b.DischargeDateTime  between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

/*ICD10Procedure Codes*/
select distinct a.*, b.ICDProcedureDateTime, c.ICD10ProcedureCode

from #GLP1excludeDpp4 as a with (NOLOCK) inner join
Src.Inpat_CensusICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('5A2204Z')
and b.ICDProcedureDateTime  between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.*, b.SurgicalProcedureDateTime, c.ICD10ProcedureCode

from #GLP1excludeDpp4 as a with (NOLOCK) inner join
Src.Inpat_CensusSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('5A2204Z')
and b.SurgicalProcedureDateTime  between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD10ProcedureCode

from #GLP1excludeDpp4 as a with (NOLOCK) inner join
Src.Inpat_InpatientICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('5A2204Z')
and b.DischargeDateTime  between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD10ProcedureCode

from #GLP1excludeDpp4 as a with (NOLOCK) inner join
Src.Inpat_InpatientSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('5A2204Z')
and b.DischargeDateTime  between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)

select distinct scrssn from #tempAFCardio --36

/*Ablation */
/*Ablation Procedure Codes */

select distinct ICD9ProcedureCode from CDWWork.Dim.ICD9Procedure where ICD9ProcedureCode in ('37.33','37.34','37.37','37.80','38.65') 
select distinct ICD10ProcedureCode from CDWWork.Dim.ICD10Procedure where ICD10ProcedureCode in ('02560ZZ','02563ZZ','02564ZZ',
'02570ZZ','02573ZZ','02574ZZ','02580ZZ','02583ZZ','02584ZZ','025S0ZZ','025S3ZZ','025S4ZZ','025T0ZZ','025T3ZZ','025T4ZZ') 

select distinct a.*, b.ICDProcedureDateTime, c.ICD9ProcedureCode
/*ICD9Procedure Codes*/

into #tempAFAbProc

from #GLP1excludeDpp4 as a with (NOLOCK) inner join
Src.Inpat_CensusICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('37.33','37.34','37.37','37.80','38.65')
					and b.ICDProcedureDateTime  between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.*, b.SurgicalProcedureDateTime, c.ICD9ProcedureCode

from #GLP1excludeDpp4 as a with (NOLOCK) inner join
Src.Inpat_CensusSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('37.33','37.34','37.37','37.80','38.65')
					and b.SurgicalProcedureDateTime  between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD9ProcedureCode

from #GLP1excludeDpp4 as a with (NOLOCK) inner join
Src.Inpat_InpatientICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('37.33','37.34','37.37','37.80','38.65')
					and b.DischargeDateTime  between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD9ProcedureCode

from #GLP1excludeDpp4 as a with (NOLOCK) inner join
Src.Inpat_InpatientSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('37.33','37.34','37.37','37.80','38.65')
					and b.DischargeDateTime  between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

/*ICD10Procedure Codes*/
select distinct a.*, b.ICDProcedureDateTime, c.ICD10ProcedureCode

from #GLP1excludeDpp4 as a with (NOLOCK) inner join
Src.Inpat_CensusICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('02560ZZ','02563ZZ','02564ZZ',
'02570ZZ','02573ZZ','02574ZZ','02580ZZ','02583ZZ','02584ZZ','025S0ZZ','025S3ZZ','025S4ZZ','025T0ZZ','025T3ZZ','025T4ZZ')
and b.ICDProcedureDateTime  between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.*, b.SurgicalProcedureDateTime, c.ICD10ProcedureCode

from #GLP1excludeDpp4 as a with (NOLOCK) inner join
Src.Inpat_CensusSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('02560ZZ','02563ZZ','02564ZZ',
'02570ZZ','02573ZZ','02574ZZ','02580ZZ','02583ZZ','02584ZZ','025S0ZZ','025S3ZZ','025S4ZZ','025T0ZZ','025T3ZZ','025T4ZZ')
and b.SurgicalProcedureDateTime  between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD10ProcedureCode

from #GLP1excludeDpp4 as a with (NOLOCK) inner join
Src.Inpat_InpatientICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('02560ZZ','02563ZZ','02564ZZ',
'02570ZZ','02573ZZ','02574ZZ','02580ZZ','02583ZZ','02584ZZ','025S0ZZ','025S3ZZ','025S4ZZ','025T0ZZ','025T3ZZ','025T4ZZ')
and b.DischargeDateTime  between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD10ProcedureCode

from #GLP1excludeDpp4 as a with (NOLOCK) inner join
Src.Inpat_InpatientSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('02560ZZ','02563ZZ','02564ZZ',
'02570ZZ','02573ZZ','02574ZZ','02580ZZ','02583ZZ','02584ZZ','025S0ZZ','025S3ZZ','025S4ZZ','025T0ZZ','025T3ZZ','025T4ZZ')
and b.DischargeDateTime  between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)

select distinct scrssn from #tempAFAbProc --5

/* Anti Arrythmic Drugs */

select distinct a.*, b.FillDateTime

into #tempAFAntiArr

from #GLP1excludeDpp4 as a with (NOLOCK) inner join
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
from #GLP1excludeDpp4 as a with (NOLOCK) inner join
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
where FillDateTime  between dateadd(month, -12, GLP1FillTime) and dateadd(day, 1, GLP1FillTime)

select distinct scrssn from #tempAFAntiArrdate --456

select distinct scrssn , glp1filltime , patientsid, AF_Dischargedatetime

into #tempFinalGLP1

from #tempAF
union all

select distinct scrssn , glp1filltime , patientsid, AF_Dischargedatetime
from #tempAFCardio
union all

select distinct scrssn , glp1filltime , patientsid, AF_Dischargedatetime
from #tempAFAbProc
union all

select distinct scrssn , glp1filltime , patientsid , AF_Dischargedatetime
from #tempAFAntiArrdate

select distinct scrssn from #tempFinalGLP1 --1064

/* Patients on Anti coagulation drugs 1 year prior to initiation */

select distinct a.scrssn, a.patientsid, a.GLP1filltime, a.AF_Dischargedatetime, b.FillDateTime

into #tempglp1Anticoag

from #tempFinalGLP1 as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where LocalDrugNameWithDose like '%Warfarin%' or
LocalDrugNameWithDose like '%Rivaroxaban%' or
			  LocalDrugNameWithDose like '%Apixaban%' or
			  LocalDrugNameWithDose like '%Dabigatran%' 
union all

select distinct a.scrssn, a.patientsid, a.GLP1filltime, a.AF_Dischargedatetime, b.FillDateTime

from #tempFinalGLP1 as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where LocalDrugNameWithDose like '%Warfarin%' or
LocalDrugNameWithDose like '%Rivaroxaban%' or
			  LocalDrugNameWithDose like '%Apixaban%' or
			  LocalDrugNameWithDose like '%Dabigatran%' 

select distinct *

into Dflt.Diabetes_AF_GLP1exclusions

from #tempglp1Anticoag
where FillDateTime between dateadd(month, -12, GLP1FillTime) and dateadd(day, 30, GLP1FillTime)

select distinct scrssn from Dflt.Diabetes_AF_GLP1exclusions--1009

/* Add patientsid to the final cohort */

select distinct a.scrssn, a.GLP1FillTime, a.af_dischargedatetime, a.filldatetime, b.patientsid
into Dflt.Diabetes_AF_GLP1
from Dflt.Diabetes_AF_GLP1exclusions as a with (NOLOCK) inner join
Src.CohortCrosswalk as b with (NOLOCK) on a.scrssn= b.scrssn 

select distinct scrssn from Dflt.Diabetes_AF_GLP1 --1009

select * from Dflt.Diabetes_AF_GLP1

select distinct patientsid from Dflt.Diabetes_AF_GLP1--3,787

/*BMI*/

/* Select height and weight values from vital signs view to calculate bmi */
drop table #tempDiabetesVitals

select distinct a.PatientSID, a.VitalSignTakenDateTime, a.VitalResult, a.VitalResultNumeric,
 b.GLP1FillTime, b.ScrSSN, 
c.VitalType

into #tempDiabetesVitals

from Src.Vital_VitalSign as a with (NOLOCK) inner join
Dflt.Diabetes_AF_GLP1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.VitalType as c with (NOLOCK) on a.VitalTypeSID=c.VitalTypeSID 
where (a.VitalSignTakenDateTime between dateadd(month, -12, b.GLP1FillTime) and dateadd(DAY, 1, b.GLP1FillTime)) AND
c.VitalType in ( 'WEIGHT')
union all

select distinct a.PatientSID, a.VitalSignTakenDateTime, a.VitalResult, a.VitalResultNumeric,
b.GLP1FillTime,b.ScrSSN, 
c.VitalType

from Src.Vital_VitalSign_Recent as a with (NOLOCK) inner join
Dflt.Diabetes_AF_GLP1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.VitalType as c with (NOLOCK) on a.VitalTypeSID=c.VitalTypeSID 
where (a.VitalSignTakenDateTime between dateadd(month, -12, b.GLP1FillTime) and dateadd(day, 1, b.GLP1FillTime)) AND 
c.VitalType in ( 'WEIGHT')
union all

select distinct a.PatientSID, a.VitalSignTakenDateTime, a.VitalResult, a.VitalResultNumeric,
b.GLP1FillTime, b.ScrSSN, 
c.VitalType

from Src.Vital_VitalSign as a with (NOLOCK) inner join
Dflt.Diabetes_AF_GLP1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.VitalType as c with (NOLOCK) on a.VitalTypeSID=c.VitalTypeSID 
--where (a.VitalSignTakenDateTime between dateadd(month, -12, b.SGLT2FillTime) and dateadd(day, 1, b.SGLT2FillTime))AND
where a.VitalSignTakenDateTime <= b.GLP1FillTime and 
c.VitalType in ( 'HEIGHT')
union all

select distinct a.PatientSID, a.VitalSignTakenDateTime, a.VitalResult, a.VitalResultNumeric,
b.GLP1FillTime,b.ScrSSN, 
c.VitalType

from Src.Vital_VitalSign_Recent as a with (NOLOCK) inner join
Dflt.Diabetes_AF_GLP1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.VitalType as c with (NOLOCK) on a.VitalTypeSID=c.VitalTypeSID 
--where (a.VitalSignTakenDateTime between dateadd(month, -12, b.SGLT2FillTime) and dateadd(day, 1, b.SGLT2FillTime))AND
where a.VitalSignTakenDateTime <= b.GLP1FillTime and 
c.VitalType in ( 'HEIGHT')

select distinct scrssn from #tempDiabetesVitals --1009

/* Seperate weight records into a table */

select * 

into #tempweight

from #tempDiabetesVitals where vitaltype = 'WEIGHT' and VitalResultNumeric != '0'

select distinct scrssn from #tempweight --998

select scrssn, max (VitalSignTakenDateTime) as VitalSignTakenDateTime
into #tempweight1
from #tempweight group by scrssn

select distinct a.patientsid, b.scrssn, b.VitalSignTakenDateTime, a.VitalResult, a.VitalResultNumeric
into #tempweightfinal
from #tempweight as a with (NOLOCK) left outer join 
#tempweight1 as b with (NOLOCK) on a.scrssn= b.scrssn and a.VitalSignTakenDateTime= b.VitalSignTakenDateTime

select distinct scrssn from #tempweightfinal --999

/* Seperate height records into a table */

select *  

into #tempheight

from #tempDiabetesVitals where vitaltype = 'HEIGHT' and VitalResultNumeric != '0'

select distinct scrssn from #tempheight--1008

select scrssn, max (VitalSignTakenDateTime) as VitalSignTakenDateTime
into #tempheight1
from #tempheight group by scrssn

select distinct a.patientsid, b.scrssn, b.VitalSignTakenDateTime, a.VitalResult, a.VitalResultNumeric
into #tempheightfinal
from #tempheight as a with (NOLOCK) left outer join 
#tempheight1 as b with (NOLOCK) on a.scrssn= b.scrssn and a.VitalSignTakenDateTime= b.VitalSignTakenDateTime

select distinct scrssn from #tempheightfinal --1009

/* Combine data from table weight and height to obtain the bmi for individual patient */
drop table  Dflt.Diabetes_AF_GLP1_BMI

select distinct a.patientsid, a.ScrSSN, cast(a.VitalSignTakenDateTime as date) as HeightTime, a.VitalResultNumeric as heightresult, 
cast(b.VitalSignTakenDateTime as date) as WeightTime,b.VitalResultNumeric as weightresult, ((b.VitalResultNumeric*703)/(a.VitalResultNumeric*a.VitalResultNumeric)) as bmi

into Dflt.Diabetes_AF_GLP1_BMI

from #tempheightfinal as a with (NOLOCK) inner join
#tempweightfinal as b with (NOLOCK) on a.ScrSSN = b.ScrSSN
--where a.VitalSignTakenDateTime=b.VitalSignTakenDateTime --a.SGLT2FillTime=b.SGLT2FillTime and

select distinct scrssn from Dflt.Diabetes_AF_GLP1_BMI where bmi >= 30 --841

select distinct scrssn from Dflt.Diabetes_AF_GLP1_BMI where bmi between 30 and 35 --260

select distinct scrssn from Dflt.Diabetes_AF_GLP1_BMI where bmi between 35 and 40 --257

select distinct scrssn from Dflt.Diabetes_AF_GLP1_BMI --997

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
where b.DPP4FillTime between '2015-01-01 00:00:00' and '2021-07-31 23:59:59'
and b.DPP4FillTime >= dateadd(day, 30, a.AF_Dischargedatetime)

select distinct scrssn from #date1--3321

/* Remove GLP1 from DPP4 */

select distinct a.scrssn, a.DPP4FillTime, a.PatientSID, b.FillDateTime

into #GLP1

from #date1 as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where LocalDrugNameWithDose like '%semaglutide%' 
or LocalDrugNameWithDose like '%exenatide%' 
or LocalDrugNameWithDose like '%liraglutide%' 
or LocalDrugNameWithDose like '%lixisenatide%' 
or LocalDrugNameWithDose like '%dulaglutide%'
union all

select distinct a.scrssn, a.DPP4FillTime, a.PatientSID, b.FillDateTime
from #date1 as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where LocalDrugNameWithDose like '%semaglutide%' 
or LocalDrugNameWithDose like '%exenatide%' 
or LocalDrugNameWithDose like '%liraglutide%' 
or LocalDrugNameWithDose like '%lixisenatide%' 
or LocalDrugNameWithDose like '%dulaglutide%'

select distinct scrssn from #GLP1 --819

select * 
into #GLP11
from #GLP1 where FillDateTime between dateadd(month, -12, DPP4FillTime) and dateadd(day, 1, DPP4FillTime) 

select distinct scrssn from #glp11 --43

select distinct a.*--, b.DischargeDateTime, c.ICD10ProcedureCode

into #Dpp4excludeGLP1

from #date1 as a where a.fillnumber >=2
AND NOT EXISTS (Select * from #glp11 as b where a.ScrSSN = b.ScrSSN)

select distinct scrssn from #Dpp4excludeGLP1-- 3039

/* AF Diagnosis 1 year prior to drug initiation */

select distinct a.PatientSID,a.ScrSSN,   b.DischargeDateTime ,a.DPP4FillTime, a.AF_Dischargedatetime

into #tempAFDPP4

from #Dpp4excludeGLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')	
and b.DischargeDateTime	between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.PatientSID,a.ScrSSN, b.DischargeDateTime, a.DPP4FillTime, a.AF_Dischargedatetime

from #Dpp4excludeGLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
and b.DischargeDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.PatientSID,a.ScrSSN, b.DischargeDateTime, a.DPP4FillTime, a.AF_Dischargedatetime

from #Dpp4excludeGLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
and b.DischargeDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.PatientSID,a.ScrSSN, b.EventDateTime, a.DPP4FillTime, a.AF_Dischargedatetime

from #Dpp4excludeGLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.PatientSID,a.ScrSSN,  b.EventDateTime, a.DPP4FillTime, a.AF_Dischargedatetime

from #Dpp4excludeGLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.PatientSID,a.ScrSSN,  b.EventDateTime, a.DPP4FillTime, a.AF_Dischargedatetime

from #Dpp4excludeGLP1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.PatientSID,a.ScrSSN, b.PatientTransferDateTime, a.DPP4FillTime, a.AF_Dischargedatetime

from #Dpp4excludeGLP1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
and b.PatientTransferDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.PatientSID,a.ScrSSN,  b.SpecialtyTransferDateTime, a.DPP4FillTime, a.AF_Dischargedatetime

from #Dpp4excludeGLP1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
and b.SpecialtyTransferDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.PatientSID,a.ScrSSN,  b.AdmitDateTime, a.DPP4FillTime, a.AF_Dischargedatetime

from #Dpp4excludeGLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
and b.AdmitDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

/*ICD10 Codes*/
select distinct a.PatientSID,a.ScrSSN, b.DischargeDateTime, a.DPP4FillTime, a.AF_Dischargedatetime

from #Dpp4excludeGLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.DischargeDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.PatientSID,a.ScrSSN,  b.DischargeDateTime, a.DPP4FillTime, a.AF_Dischargedatetime

from #Dpp4excludeGLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.DischargeDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.PatientSID,a.ScrSSN, b.DischargeDateTime, a.DPP4FillTime, a.AF_Dischargedatetime

from #Dpp4excludeGLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.DischargeDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.PatientSID,a.ScrSSN,  b.EventDateTime, a.DPP4FillTime, a.AF_Dischargedatetime

from #Dpp4excludeGLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.PatientSID,a.ScrSSN,  b.EventDateTime, a.DPP4FillTime, a.AF_Dischargedatetime

from #Dpp4excludeGLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.PatientSID,a.ScrSSN, b.EventDateTime, a.DPP4FillTime, a.AF_Dischargedatetime

from #Dpp4excludeGLP1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)

union all

select distinct a.PatientSID,a.ScrSSN,  b.PatientTransferDateTime, a.DPP4FillTime, a.AF_Dischargedatetime

from #Dpp4excludeGLP1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.PatientTransferDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)

union all

select distinct a.PatientSID,a.ScrSSN, b.SpecialtyTransferDateTime, a.DPP4FillTime, a.AF_Dischargedatetime

from #Dpp4excludeGLP1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.SpecialtyTransferDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)

union all

select distinct a.PatientSID,a.ScrSSN,   b.AdmitDateTime, a.DPP4FillTime, a.AF_Dischargedatetime

from #Dpp4excludeGLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.AdmitDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)

select distinct scrssn from #tempAFDPP4 --1,441

/* Cardioversion */
/* Cardioversion Proc codes */

select distinct ICD9ProcedureCode from CDWWork.Dim.ICD9Procedure where ICD9ProcedureCode in ('99.61','99.62') 
select distinct ICD10ProcedureCode from CDWWork.Dim.ICD10Procedure where ICD10ProcedureCode in ('5A2204Z') 

select distinct a.*, b.ICDProcedureDateTime, c.ICD9ProcedureCode
/*ICD9Procedure Codes*/

into #tempAFCardioDPP4

from #Dpp4excludeGLP1 as a with (NOLOCK) inner join
Src.Inpat_CensusICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('99.61','99.62')
					and b.ICDProcedureDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.*, b.SurgicalProcedureDateTime, c.ICD9ProcedureCode

from #Dpp4excludeGLP1 as a with (NOLOCK) inner join
Src.Inpat_CensusSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('99.61','99.62')
					and b.SurgicalProcedureDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD9ProcedureCode

from #Dpp4excludeGLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('99.61','99.62')
					and b.DischargeDateTime  between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD9ProcedureCode

from #Dpp4excludeGLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('99.61','99.62')
					and b.DischargeDateTime  between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

/*ICD10Procedure Codes*/
select distinct a.*, b.ICDProcedureDateTime, c.ICD10ProcedureCode

from #Dpp4excludeGLP1 as a with (NOLOCK) inner join
Src.Inpat_CensusICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('5A2204Z')
and b.ICDProcedureDateTime  between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.*, b.SurgicalProcedureDateTime, c.ICD10ProcedureCode

from #Dpp4excludeGLP1 as a with (NOLOCK) inner join
Src.Inpat_CensusSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('5A2204Z')
and b.SurgicalProcedureDateTime  between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD10ProcedureCode

from #Dpp4excludeGLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('5A2204Z')
and b.DischargeDateTime  between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD10ProcedureCode

from #Dpp4excludeGLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('5A2204Z')
and b.DischargeDateTime  between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)

select distinct scrssn from #tempAFCardioDPP4 --75

/*Ablation */
/*Ablation Procedure Codes */

select distinct ICD9ProcedureCode from CDWWork.Dim.ICD9Procedure where ICD9ProcedureCode in ('37.33','37.34','37.37','37.80','38.65') 
select distinct ICD10ProcedureCode from CDWWork.Dim.ICD10Procedure where ICD10ProcedureCode in ('02560ZZ','02563ZZ','02564ZZ',
'02570ZZ','02573ZZ','02574ZZ','02580ZZ','02583ZZ','02584ZZ','025S0ZZ','025S3ZZ','025S4ZZ','025T0ZZ','025T3ZZ','025T4ZZ') 

select distinct a.*, b.ICDProcedureDateTime, c.ICD9ProcedureCode
/*ICD9Procedure Codes*/

into #tempAFAbProcDPP4

from #Dpp4excludeGLP1 as a with (NOLOCK) inner join
Src.Inpat_CensusICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('37.33','37.34','37.37','37.80','38.65')
					and b.ICDProcedureDateTime  between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.*, b.SurgicalProcedureDateTime, c.ICD9ProcedureCode

from #Dpp4excludeGLP1 as a with (NOLOCK) inner join
Src.Inpat_CensusSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('37.33','37.34','37.37','37.80','38.65')
					and b.SurgicalProcedureDateTime  between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD9ProcedureCode

from #Dpp4excludeGLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('37.33','37.34','37.37','37.80','38.65')
					and b.DischargeDateTime  between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD9ProcedureCode

from #Dpp4excludeGLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('37.33','37.34','37.37','37.80','38.65')
					and b.DischargeDateTime  between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

/*ICD10Procedure Codes*/
select distinct a.*, b.ICDProcedureDateTime, c.ICD10ProcedureCode

from #Dpp4excludeGLP1 as a with (NOLOCK) inner join
Src.Inpat_CensusICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('02560ZZ','02563ZZ','02564ZZ',
'02570ZZ','02573ZZ','02574ZZ','02580ZZ','02583ZZ','02584ZZ','025S0ZZ','025S3ZZ','025S4ZZ','025T0ZZ','025T3ZZ','025T4ZZ')
and b.ICDProcedureDateTime  between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.*, b.SurgicalProcedureDateTime, c.ICD10ProcedureCode

from #Dpp4excludeGLP1 as a with (NOLOCK) inner join
Src.Inpat_CensusSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('02560ZZ','02563ZZ','02564ZZ',
'02570ZZ','02573ZZ','02574ZZ','02580ZZ','02583ZZ','02584ZZ','025S0ZZ','025S3ZZ','025S4ZZ','025T0ZZ','025T3ZZ','025T4ZZ')
and b.SurgicalProcedureDateTime  between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD10ProcedureCode

from #Dpp4excludeGLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('02560ZZ','02563ZZ','02564ZZ',
'02570ZZ','02573ZZ','02574ZZ','02580ZZ','02583ZZ','02584ZZ','025S0ZZ','025S3ZZ','025S4ZZ','025T0ZZ','025T3ZZ','025T4ZZ')
and b.DischargeDateTime  between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD10ProcedureCode

from #Dpp4excludeGLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('02560ZZ','02563ZZ','02564ZZ',
'02570ZZ','02573ZZ','02574ZZ','02580ZZ','02583ZZ','02584ZZ','025S0ZZ','025S3ZZ','025S4ZZ','025T0ZZ','025T3ZZ','025T4ZZ')
and b.DischargeDateTime  between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)

select distinct scrssn from #tempAFAbProcDPP4--26

/* Anti Arrythmic Drugs */

select distinct a.*, b.FillDateTime

into #tempAFAntiArrDPP4

from #Dpp4excludeGLP1 as a with (NOLOCK) inner join
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
from #Dpp4excludeGLP1 as a with (NOLOCK) inner join
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

select distinct scrssn from #tempAFAntiArrdateDPP4 --917


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

select distinct scrssn from #tempFinalDPP4 --1855

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

select distinct *

into Dflt.Diabetes_AF_DPP4GLP1exclusions

from #tempDPP4Anticoag
where FillDateTime between dateadd(month, -12, DPP4FillTime) and dateadd(day, 30, DPP4FillTime)

select distinct scrssn from Dflt.Diabetes_AF_DPP4GLP1exclusions --1,715

select * from Dflt.Diabetes_AF_DPP4GLP1exclusions

/* Add patientsid to the final cohort */

select distinct a.scrssn, a.DPP4FillTime, a.filldatetime, b.patientsid
into Dflt.Diabetes_AF_DPP4GLP1
from Dflt.Diabetes_AF_DPP4GLP1exclusions as a with (NOLOCK) inner join
Src.CohortCrosswalk as b with (NOLOCK) on a.scrssn= b.scrssn 

select distinct scrssn from Dflt.Diabetes_AF_DPP4GLP1 --1715

select * from Dflt.Diabetes_AF_DPP4GLP1

select distinct patientsid from Dflt.Diabetes_AF_DPP4GLP1--5984


/* BMI */

/* Select height and weight values from vital signs view to calculate bmi */

select distinct a.PatientSID, a.VitalSignTakenDateTime, a.VitalResult, a.VitalResultNumeric,
 b.DPP4FillTime, b.ScrSSN, 
c.VitalType

into #tempDiabetesVitalsDPP4

from Src.Vital_VitalSign as a with (NOLOCK) inner join
Dflt.Diabetes_AF_DPP4GLP1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.VitalType as c with (NOLOCK) on a.VitalTypeSID=c.VitalTypeSID 
where (a.VitalSignTakenDateTime between dateadd(month, -12, b.DPP4FillTime) and dateadd(DAY, 1, b.DPP4FillTime)) AND
c.VitalType in ( 'WEIGHT')
union all

select distinct a.PatientSID, a.VitalSignTakenDateTime, a.VitalResult, a.VitalResultNumeric,
b.DPP4FillTime,b.ScrSSN, 
c.VitalType

from Src.Vital_VitalSign_Recent as a with (NOLOCK) inner join
Dflt.Diabetes_AF_DPP4GLP1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.VitalType as c with (NOLOCK) on a.VitalTypeSID=c.VitalTypeSID 
where (a.VitalSignTakenDateTime between dateadd(month, -12, b.DPP4FillTime) and dateadd(day, 1, b.DPP4FillTime))AND 
c.VitalType in ( 'WEIGHT')
union all

select distinct a.PatientSID, a.VitalSignTakenDateTime, a.VitalResult, a.VitalResultNumeric,
 b.DPP4FillTime, b.ScrSSN, 
c.VitalType

from Src.Vital_VitalSign as a with (NOLOCK) inner join
Dflt.Diabetes_AF_DPP4GLP1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.VitalType as c with (NOLOCK) on a.VitalTypeSID=c.VitalTypeSID 
--where (a.VitalSignTakenDateTime between dateadd(month, -12, b.DPP4FillTime) and dateadd(day, 1, b.DPP4FillTime))AND
where a.VitalSignTakenDateTime <= b.DPP4FillTime and 
c.VitalType in ( 'HEIGHT')
union all

select distinct a.PatientSID, a.VitalSignTakenDateTime, a.VitalResult, a.VitalResultNumeric,
b.DPP4FillTime,b.ScrSSN, 
c.VitalType

from Src.Vital_VitalSign_Recent as a with (NOLOCK) inner join
Dflt.Diabetes_AF_DPP4GLP1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.VitalType as c with (NOLOCK) on a.VitalTypeSID=c.VitalTypeSID 
--where (a.VitalSignTakenDateTime between dateadd(month, -12, b.DPP4FillTime) and dateadd(day, 1, b.DPP4FillTime))AND
where a.VitalSignTakenDateTime <= b.DPP4FillTime and 
c.VitalType in ( 'HEIGHT')

select distinct scrssn from #tempDiabetesVitalsDPP4--1715



/* Seperate weight records into a table */
select * 

into #tempweightDPP4

from #tempDiabetesVitalsDPP4 where vitaltype = 'WEIGHT' and VitalResultNumeric != '0'

select distinct scrssn from #tempweightDPP4 --1702

select scrssn, max (VitalSignTakenDateTime) as VitalSignTakenDateTime
into #tempweight1DPP4
from #tempweightDPP4 group by scrssn

select distinct a.patientsid, b.scrssn, b.VitalSignTakenDateTime, a.VitalResult, a.VitalResultNumeric
into #tempweightfinalDPP4
from #tempweightDPP4 as a with (NOLOCK) left outer join 
#tempweight1DPP4 as b with (NOLOCK) on a.scrssn= b.scrssn and a.VitalSignTakenDateTime= b.VitalSignTakenDateTime

select distinct scrssn from #tempweightfinalDPP4 --1703

/* Seperate height records into a table */
select *  

into #tempheightDPP4

from #tempDiabetesVitalsDPP4 where vitaltype = 'HEIGHT' and VitalResultNumeric != '0'

select distinct scrssn from #tempheightDPP4 --1713

select scrssn, max (VitalSignTakenDateTime) as VitalSignTakenDateTime
into #tempheight1DPP4
from #tempheightDPP4 group by scrssn

select distinct a.patientsid, b.scrssn, b.VitalSignTakenDateTime, a.VitalResult, a.VitalResultNumeric
into #tempheightfinalDPP4
from #tempheightDPP4 as a with (NOLOCK) left outer join 
#tempheight1DPP4 as b with (NOLOCK) on a.scrssn= b.scrssn and a.VitalSignTakenDateTime= b.VitalSignTakenDateTime

select distinct scrssn from #tempheightfinalDPP4 --1714

/* Combine data from table weight and height to obtain the bmi for individual patient */

select distinct a.patientsid, a.ScrSSN, cast(a.VitalSignTakenDateTime as date) as HeightTime, a.VitalResultNumeric as heightresult, 
cast(b.VitalSignTakenDateTime as date) as WeightTime,b.VitalResultNumeric as weightresult, ((b.VitalResultNumeric*703)/(a.VitalResultNumeric*a.VitalResultNumeric)) as bmi

into Dflt.Diabetes_AF_DPP4GLP1_BMI

from #tempheightfinalDPP4 as a with (NOLOCK) inner join
#tempweightfinalDPP4 as b with (NOLOCK) on a.ScrSSN = b.ScrSSN 
--where a.VitalSignTakenDateTime=b.VitalSignTakenDateTime --a.DPP4FillTime=b.DPP4FillTime and


select distinct scrssn from  Dflt.Diabetes_AF_DPP4GLP1_BMI where bmi >= 30 --1126

select distinct scrssn from  Dflt.Diabetes_AF_DPP4GLP1_BMI where bmi between 30 and 35 --558

select distinct scrssn from  Dflt.Diabetes_AF_DPP4GLP1_BMI where bmi between 35 and 40 --389

select distinct scrssn from  Dflt.Diabetes_AF_DPP4GLP1_BMI --1700


/* GLP1 Baseline Characteristics Extrcation */
/*Age */

select a.ScrSSN, a.glp1Filltime, b.DOB,b.SEX
into Dflt.Diabetes_AF_GLP1_DOB
from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.VitalStatus_Mini as b with (NOLOCK) on a.scrssn= b.scrssn

select *, datediff( year, DOB, glp1Filltime) as age
into Dflt.Diabetes_AF_GLP1_Age
from Dflt.Diabetes_AF_GLP1_DOB

select distinct scrssn from Dflt.Diabetes_AF_GLP1_Age --1505
select distinct scrssn from Dflt.Diabetes_AF_GLP1_Age where SEX ='F' --34

/* Date of Death */

select distinct a.ScrSSN,  b.MPI_DOD
into Dflt.Diabetes_AF_GLP1_DOD
from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.SDAF_DAFMaster as b with (NOLOCK) on a.scrssn= b.MPI_scrssn
where b.MPI_DOD is not null

select distinct scrssn from Dflt.Diabetes_AF_GLP1_DOD --636

select max(MPI_DOD) from Dflt.Diabetes_AF_GLP1_DOD

select * from Dflt.Diabetes_AF_GLP1_DOD where MPI_DOD > '2023-12-01'

/* Race */

select a.*,  b.Race
into Dflt.Diabetes_AF_GLP1_Race
from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.PatSub_PatientRace as b with (NOLOCK) on a.patientsid= b.patientsid

select distinct scrssn from Dflt.Diabetes_AF_GLP1_Race --1502

select distinct race from Dflt.Diabetes_AF_GLP1_Race 

select distinct scrssn from Dflt.Diabetes_AF_GLP1_Race where race = 'WHITE' --1233

select distinct scrssn from Dflt.Diabetes_AF_GLP1_Race where race = 'BLACK OR AFRICAN AMERICAN' --184

/* Hypertension */

select distinct a.*, b.DischargeDateTime as comorbidity_Dischargedatetime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_AF_GLP1_Hypertension

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('401.1','401.0','401.9','402.00','402.01','402.90','402.91','403.00','403.01','403.10','403.11','403.90','403.91','404.00','404.01','404.02','404.03','404.10',
					'404.11','404.12','404.13','404.90','404.91','404.92','404.93','405.01','405.09','405.11','405.99','642.00','642.01','642.02','642.03','642.04','642.10','642.11',
					'642.12','642.13','642.14','642.20','642.21','642.22','642.23','642.24','642.70','642.71','642.72','642.73','642.74','642.90','642.91','642.92','642.93','642.94')
					and b.DischargeDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('401.1','401.0','401.9','402.00','402.01','402.90','402.91','403.00','403.01','403.10','403.11','403.90','403.91','404.00','404.01','404.02','404.03','404.10',
					'404.11','404.12','404.13','404.90','404.91','404.92','404.93','405.01','405.09','405.11','405.99','642.00','642.01','642.02','642.03','642.04','642.10','642.11',
					'642.12','642.13','642.14','642.20','642.21','642.22','642.23','642.24','642.70','642.71','642.72','642.73','642.74','642.90','642.91','642.92','642.93','642.94')
					and b.DischargeDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('401.1','401.0','401.9','402.00','402.01','402.90','402.91','403.00','403.01','403.10','403.11','403.90','403.91','404.00','404.01','404.02','404.03','404.10',
					'404.11','404.12','404.13','404.90','404.91','404.92','404.93','405.01','405.09','405.11','405.99','642.00','642.01','642.02','642.03','642.04','642.10','642.11',
					'642.12','642.13','642.14','642.20','642.21','642.22','642.23','642.24','642.70','642.71','642.72','642.73','642.74','642.90','642.91','642.92','642.93','642.94')
					and b.DischargeDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.*, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('401.1','401.0','401.9','402.00','402.01','402.90','402.91','403.00','403.01','403.10','403.11','403.90','403.91','404.00','404.01','404.02','404.03','404.10',
					'404.11','404.12','404.13','404.90','404.91','404.92','404.93','405.01','405.09','405.11','405.99','642.00','642.01','642.02','642.03','642.04','642.10','642.11',
					'642.12','642.13','642.14','642.20','642.21','642.22','642.23','642.24','642.70','642.71','642.72','642.73','642.74','642.90','642.91','642.92','642.93','642.94')
					and b.EventDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.*, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('401.1','401.0','401.9','402.00','402.01','402.90','402.91','403.00','403.01','403.10','403.11','403.90','403.91','404.00','404.01','404.02','404.03','404.10',
					'404.11','404.12','404.13','404.90','404.91','404.92','404.93','405.01','405.09','405.11','405.99','642.00','642.01','642.02','642.03','642.04','642.10','642.11',
					'642.12','642.13','642.14','642.20','642.21','642.22','642.23','642.24','642.70','642.71','642.72','642.73','642.74','642.90','642.91','642.92','642.93','642.94')
					and b.EventDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.*, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('401.1','401.0','401.9','402.00','402.01','402.90','402.91','403.00','403.01','403.10','403.11','403.90','403.91','404.00','404.01','404.02','404.03','404.10',
					'404.11','404.12','404.13','404.90','404.91','404.92','404.93','405.01','405.09','405.11','405.99','642.00','642.01','642.02','642.03','642.04','642.10','642.11',
					'642.12','642.13','642.14','642.20','642.21','642.22','642.23','642.24','642.70','642.71','642.72','642.73','642.74','642.90','642.91','642.92','642.93','642.94')
					and b.EventDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.*, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('401.1','401.0','401.9','402.00','402.01','402.90','402.91','403.00','403.01','403.10','403.11','403.90','403.91','404.00','404.01','404.02','404.03','404.10',
					'404.11','404.12','404.13','404.90','404.91','404.92','404.93','405.01','405.09','405.11','405.99','642.00','642.01','642.02','642.03','642.04','642.10','642.11',
					'642.12','642.13','642.14','642.20','642.21','642.22','642.23','642.24','642.70','642.71','642.72','642.73','642.74','642.90','642.91','642.92','642.93','642.94')
					and b.PatientTransferDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.*, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('401.1','401.0','401.9','402.00','402.01','402.90','402.91','403.00','403.01','403.10','403.11','403.90','403.91','404.00','404.01','404.02','404.03','404.10',
					'404.11','404.12','404.13','404.90','404.91','404.92','404.93','405.01','405.09','405.11','405.99','642.00','642.01','642.02','642.03','642.04','642.10','642.11',
					'642.12','642.13','642.14','642.20','642.21','642.22','642.23','642.24','642.70','642.71','642.72','642.73','642.74','642.90','642.91','642.92','642.93','642.94')
					and b.SpecialtyTransferDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.*, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('401.1','401.0','401.9','402.00','402.01','402.90','402.91','403.00','403.01','403.10','403.11','403.90','403.91','404.00','404.01','404.02','404.03','404.10',
					'404.11','404.12','404.13','404.90','404.91','404.92','404.93','405.01','405.09','405.11','405.99','642.00','642.01','642.02','642.03','642.04','642.10','642.11',
					'642.12','642.13','642.14','642.20','642.21','642.22','642.23','642.24','642.70','642.71','642.72','642.73','642.74','642.90','642.91','642.92','642.93','642.94')
					and b.AdmitDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

/*ICD10 Codes*/
select distinct a.*, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I10.', 'I16.9', 'I11.9','I11.0', 'I12.9', 'I12.0','I13.10', 'I13.0', 'I13.11', 'I13.2', 'I15.0', 'I15.8', 
					'O10.019','O10.919', 'O10.011', 'O10.012', 'O10.013', 'O10.02', 'O10.911', 'O10.912', 'O10.913', 'O10.92', 'O10.03', 'O10.93', 
					'O10.419', 'O10.411', 'O10.412', 'O10.413', 'O10.42', 'O10.43','O10.119', 'O10.219', 'O10.319', 'O10.111', 'O10.112', 'O10.113', 'O10.12', 
					'O10.211', 'O10.212', 'O10.213','O10.22', 'O10.311', 'O10.312', 'O10.313', 'O10.32', 'O10.13', 'O10.23', 'O10.33', 'O11.9', 'O11.1', 'O11.2', 
					'O11.3', 'O11.4','O11.5', 'O16.9', 'O16.1', 'O16.2', 'O16.3', 'O16.4', 'O16.5')
and b.DischargeDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I10.', 'I16.9', 'I11.9','I11.0', 'I12.9', 'I12.0','I13.10', 'I13.0', 'I13.11', 'I13.2', 'I15.0', 'I15.8', 
					'O10.019','O10.919', 'O10.011', 'O10.012', 'O10.013', 'O10.02', 'O10.911', 'O10.912', 'O10.913', 'O10.92', 'O10.03', 'O10.93', 
					'O10.419', 'O10.411', 'O10.412', 'O10.413', 'O10.42', 'O10.43','O10.119', 'O10.219', 'O10.319', 'O10.111', 'O10.112', 'O10.113', 'O10.12', 
					'O10.211', 'O10.212', 'O10.213','O10.22', 'O10.311', 'O10.312', 'O10.313', 'O10.32', 'O10.13', 'O10.23', 'O10.33', 'O11.9', 'O11.1', 'O11.2', 
					'O11.3', 'O11.4','O11.5', 'O16.9', 'O16.1', 'O16.2', 'O16.3', 'O16.4', 'O16.5')
and b.DischargeDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I10.', 'I16.9', 'I11.9','I11.0', 'I12.9', 'I12.0','I13.10', 'I13.0', 'I13.11', 'I13.2', 'I15.0', 'I15.8', 
					'O10.019','O10.919', 'O10.011', 'O10.012', 'O10.013', 'O10.02', 'O10.911', 'O10.912', 'O10.913', 'O10.92', 'O10.03', 'O10.93', 
					'O10.419', 'O10.411', 'O10.412', 'O10.413', 'O10.42', 'O10.43','O10.119', 'O10.219', 'O10.319', 'O10.111', 'O10.112', 'O10.113', 'O10.12', 
					'O10.211', 'O10.212', 'O10.213','O10.22', 'O10.311', 'O10.312', 'O10.313', 'O10.32', 'O10.13', 'O10.23', 'O10.33', 'O11.9', 'O11.1', 'O11.2', 
					'O11.3', 'O11.4','O11.5', 'O16.9', 'O16.1', 'O16.2', 'O16.3', 'O16.4', 'O16.5')
and b.DischargeDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.*, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I10.', 'I16.9', 'I11.9','I11.0', 'I12.9', 'I12.0','I13.10', 'I13.0', 'I13.11', 'I13.2', 'I15.0', 'I15.8', 
					'O10.019','O10.919', 'O10.011', 'O10.012', 'O10.013', 'O10.02', 'O10.911', 'O10.912', 'O10.913', 'O10.92', 'O10.03', 'O10.93', 
					'O10.419', 'O10.411', 'O10.412', 'O10.413', 'O10.42', 'O10.43','O10.119', 'O10.219', 'O10.319', 'O10.111', 'O10.112', 'O10.113', 'O10.12', 
					'O10.211', 'O10.212', 'O10.213','O10.22', 'O10.311', 'O10.312', 'O10.313', 'O10.32', 'O10.13', 'O10.23', 'O10.33', 'O11.9', 'O11.1', 'O11.2', 
					'O11.3', 'O11.4','O11.5', 'O16.9', 'O16.1', 'O16.2', 'O16.3', 'O16.4', 'O16.5')
and b.EventDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.*, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I10.', 'I16.9', 'I11.9','I11.0', 'I12.9', 'I12.0','I13.10', 'I13.0', 'I13.11', 'I13.2', 'I15.0', 'I15.8', 
					'O10.019','O10.919', 'O10.011', 'O10.012', 'O10.013', 'O10.02', 'O10.911', 'O10.912', 'O10.913', 'O10.92', 'O10.03', 'O10.93', 
					'O10.419', 'O10.411', 'O10.412', 'O10.413', 'O10.42', 'O10.43','O10.119', 'O10.219', 'O10.319', 'O10.111', 'O10.112', 'O10.113', 'O10.12', 
					'O10.211', 'O10.212', 'O10.213','O10.22', 'O10.311', 'O10.312', 'O10.313', 'O10.32', 'O10.13', 'O10.23', 'O10.33', 'O11.9', 'O11.1', 'O11.2', 
					'O11.3', 'O11.4','O11.5', 'O16.9', 'O16.1', 'O16.2', 'O16.3', 'O16.4', 'O16.5')
and b.EventDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.*, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I10.', 'I16.9', 'I11.9','I11.0', 'I12.9', 'I12.0','I13.10', 'I13.0', 'I13.11', 'I13.2', 'I15.0', 'I15.8', 
					'O10.019','O10.919', 'O10.011', 'O10.012', 'O10.013', 'O10.02', 'O10.911', 'O10.912', 'O10.913', 'O10.92', 'O10.03', 'O10.93', 
					'O10.419', 'O10.411', 'O10.412', 'O10.413', 'O10.42', 'O10.43','O10.119', 'O10.219', 'O10.319', 'O10.111', 'O10.112', 'O10.113', 'O10.12', 
					'O10.211', 'O10.212', 'O10.213','O10.22', 'O10.311', 'O10.312', 'O10.313', 'O10.32', 'O10.13', 'O10.23', 'O10.33', 'O11.9', 'O11.1', 'O11.2', 
					'O11.3', 'O11.4','O11.5', 'O16.9', 'O16.1', 'O16.2', 'O16.3', 'O16.4', 'O16.5')
and b.EventDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)

union all

select distinct a.*, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I10.', 'I16.9', 'I11.9','I11.0', 'I12.9', 'I12.0','I13.10', 'I13.0', 'I13.11', 'I13.2', 'I15.0', 'I15.8', 
					'O10.019','O10.919', 'O10.011', 'O10.012', 'O10.013', 'O10.02', 'O10.911', 'O10.912', 'O10.913', 'O10.92', 'O10.03', 'O10.93', 
					'O10.419', 'O10.411', 'O10.412', 'O10.413', 'O10.42', 'O10.43','O10.119', 'O10.219', 'O10.319', 'O10.111', 'O10.112', 'O10.113', 'O10.12', 
					'O10.211', 'O10.212', 'O10.213','O10.22', 'O10.311', 'O10.312', 'O10.313', 'O10.32', 'O10.13', 'O10.23', 'O10.33', 'O11.9', 'O11.1', 'O11.2', 
					'O11.3', 'O11.4','O11.5', 'O16.9', 'O16.1', 'O16.2', 'O16.3', 'O16.4', 'O16.5')
and b.PatientTransferDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)

union all

select distinct a.*, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I10.', 'I16.9', 'I11.9','I11.0', 'I12.9', 'I12.0','I13.10', 'I13.0', 'I13.11', 'I13.2', 'I15.0', 'I15.8', 
					'O10.019','O10.919', 'O10.011', 'O10.012', 'O10.013', 'O10.02', 'O10.911', 'O10.912', 'O10.913', 'O10.92', 'O10.03', 'O10.93', 
					'O10.419', 'O10.411', 'O10.412', 'O10.413', 'O10.42', 'O10.43','O10.119', 'O10.219', 'O10.319', 'O10.111', 'O10.112', 'O10.113', 'O10.12', 
					'O10.211', 'O10.212', 'O10.213','O10.22', 'O10.311', 'O10.312', 'O10.313', 'O10.32', 'O10.13', 'O10.23', 'O10.33', 'O11.9', 'O11.1', 'O11.2', 
					'O11.3', 'O11.4','O11.5', 'O16.9', 'O16.1', 'O16.2', 'O16.3', 'O16.4', 'O16.5')
and b.SpecialtyTransferDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)

union all

select distinct a.*, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I10.', 'I16.9', 'I11.9','I11.0', 'I12.9', 'I12.0','I13.10', 'I13.0', 'I13.11', 'I13.2', 'I15.0', 'I15.8', 
					'O10.019','O10.919', 'O10.011', 'O10.012', 'O10.013', 'O10.02', 'O10.911', 'O10.912', 'O10.913', 'O10.92', 'O10.03', 'O10.93', 
					'O10.419', 'O10.411', 'O10.412', 'O10.413', 'O10.42', 'O10.43','O10.119', 'O10.219', 'O10.319', 'O10.111', 'O10.112', 'O10.113', 'O10.12', 
					'O10.211', 'O10.212', 'O10.213','O10.22', 'O10.311', 'O10.312', 'O10.313', 'O10.32', 'O10.13', 'O10.23', 'O10.33', 'O11.9', 'O11.1', 'O11.2', 
					'O11.3', 'O11.4','O11.5', 'O16.9', 'O16.1', 'O16.2', 'O16.3', 'O16.4', 'O16.5')
and b.AdmitDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)

select distinct scrssn from Dflt.Diabetes_AF_GLP1_Hypertension --1096

/* Chronic Kidney Disease */
/*Making sure the ICD9 and ICD10 codes relevant to Kidney Disease are present in the Dimension table under CDWWork*/

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
													'V56.0','V56.1','V56.2','V56.8', '585.3')

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3') or ICD10Code like 'Z49.%'

select distinct a.patientsid, a.scrssn, a.GLP1Filltime ,b.DischargeDateTime as comorbidity_Dischargedatetime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_AF_GLP1_KidneyDisease

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
													'V56.0','V56.1','V56.2','V56.8', '585.3')
					and b.DischargeDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.patientsid, a.scrssn, a.GLP1Filltime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
													'V56.0','V56.1','V56.2','V56.8', '585.3')
					and b.DischargeDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.patientsid, a.scrssn, a.GLP1Filltime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
													'V56.0','V56.1','V56.2','V56.8', '585.3')
					and b.DischargeDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.patientsid, a.scrssn, a.GLP1Filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
													'V56.0','V56.1','V56.2','V56.8', '585.3')
					and b.EventDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.patientsid, a.scrssn, a.GLP1Filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
													'V56.0','V56.1','V56.2','V56.8', '585.3')
					and b.EventDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.patientsid, a.scrssn, a.GLP1Filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
													'V56.0','V56.1','V56.2','V56.8', '585.3')
					and b.EventDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.patientsid, a.scrssn, a.GLP1Filltime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
													'V56.0','V56.1','V56.2','V56.8', '585.3')
					and b.PatientTransferDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.patientsid, a.scrssn, a.GLP1Filltime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
													'V56.0','V56.1','V56.2','V56.8', '585.3')
					and b.SpecialtyTransferDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.patientsid, a.scrssn, a.GLP1Filltime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
													'V56.0','V56.1','V56.2','V56.8', '585.3')
					and b.AdmitDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.GLP1Filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3') or ICD10Code like 'Z49.%'
and b.DischargeDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.patientsid, a.scrssn, a.GLP1Filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3') or ICD10Code like 'Z49.%'
and b.DischargeDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.patientsid, a.scrssn, a.GLP1Filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3') or ICD10Code like 'Z49.%'
and b.DischargeDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.patientsid, a.scrssn, a.GLP1Filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3') or ICD10Code like 'Z49.%'
and b.EventDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.patientsid, a.scrssn, a.GLP1Filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3') or ICD10Code like 'Z49.%'
and b.EventDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.patientsid, a.scrssn, a.GLP1Filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3') or ICD10Code like 'Z49.%'
and b.EventDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)

union all

select distinct a.patientsid, a.scrssn, a.GLP1Filltime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3') or ICD10Code like 'Z49.%'
and b.PatientTransferDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)

union all

select distinct a.patientsid, a.scrssn, a.GLP1Filltime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3') or ICD10Code like 'Z49.%'
and b.SpecialtyTransferDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)

union all

select distinct a.patientsid, a.scrssn, a.GLP1Filltime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3') or ICD10Code like 'Z49.%'
and b.AdmitDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)

select distinct scrssn from Dflt.Diabetes_AF_GLP1_KidneyDisease --702

/* End Stage Renal Disease - ESRD */
/*Making sure the ICD9 and ICD10 codes relevant to ESRD are present in the Dimension table under CDWWork*/

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('585.6')

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('N18.6')

select distinct a.patientsid, a.scrssn, a.GLP1Filltime, b.DischargeDateTime as comorbidity_Dischargedatetime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_AF_GLP1_ESRD

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('585.6')
					and b.DischargeDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.patientsid, a.scrssn, a.GLP1Filltime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('585.6')
					and b.DischargeDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.patientsid, a.scrssn, a.GLP1Filltime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('585.6')
					and b.DischargeDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.patientsid, a.scrssn, a.GLP1Filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('585.6')
					and b.EventDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.patientsid, a.scrssn, a.GLP1Filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('585.6')
					and b.EventDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.patientsid, a.scrssn, a.GLP1Filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('585.6')
					and b.EventDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.patientsid, a.scrssn, a.GLP1Filltime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('585.6')
					and b.PatientTransferDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.patientsid, a.scrssn, a.GLP1Filltime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('585.6')
					and b.SpecialtyTransferDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.patientsid, a.scrssn, a.GLP1Filltime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('585.6')
					and b.AdmitDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.GLP1Filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('N18.6')
and b.DischargeDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.patientsid, a.scrssn, a.GLP1Filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('N18.6')
and b.DischargeDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.patientsid, a.scrssn, a.GLP1Filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('N18.6')
and b.DischargeDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.patientsid, a.scrssn, a.GLP1Filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('N18.6')
and b.EventDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.patientsid, a.scrssn, a.GLP1Filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('N18.6')
and b.EventDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.patientsid, a.scrssn, a.GLP1Filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('N18.6')
and b.EventDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)

union all

select distinct a.patientsid, a.scrssn, a.GLP1Filltime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('N18.6')
and b.PatientTransferDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)

union all

select distinct a.patientsid, a.scrssn, a.GLP1Filltime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('N18.6')
and b.SpecialtyTransferDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)

union all

select distinct a.patientsid, a.scrssn, a.GLP1Filltime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('N18.6')
and b.AdmitDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)

select distinct scrssn from Dflt.Diabetes_AF_GLP1_ESRD--22


/* Alcohol Abuse */

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.DischargeDateTime as comorbidity_Dischargedatettime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_AF_GLP1_AlcoholAbuse

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('290.0','291.1','291.2','291.3','291.5','291.81','291.82','291.89','291.9',
			    '303.00','303.01','303.02','303.03','303.90','303.91','303.92','303.93','305.00','305.01','305.02','305.03','V11.3')
					and b.DischargeDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('290.0','291.1','291.2','291.3','291.5','291.81','291.82','291.89','291.9',
			    '303.00','303.01','303.02','303.03','303.90','303.91','303.92','303.93','305.00','305.01','305.02','305.03','V11.3')
					and b.DischargeDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('290.0','291.1','291.2','291.3','291.5','291.81','291.82','291.89','291.9',
			    '303.00','303.01','303.02','303.03','303.90','303.91','303.92','303.93','305.00','305.01','305.02','305.03','V11.3')
					and b.DischargeDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('290.0','291.1','291.2','291.3','291.5','291.81','291.82','291.89','291.9',
			    '303.00','303.01','303.02','303.03','303.90','303.91','303.92','303.93','305.00','305.01','305.02','305.03','V11.3')
					and b.EventDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('290.0','291.1','291.2','291.3','291.5','291.81','291.82','291.89','291.9',
			    '303.00','303.01','303.02','303.03','303.90','303.91','303.92','303.93','305.00','305.01','305.02','305.03','V11.3')
					and b.EventDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('290.0','291.1','291.2','291.3','291.5','291.81','291.82','291.89','291.9',
			    '303.00','303.01','303.02','303.03','303.90','303.91','303.92','303.93','305.00','305.01','305.02','305.03','V11.3')
					and b.EventDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('290.0','291.1','291.2','291.3','291.5','291.81','291.82','291.89','291.9',
			    '303.00','303.01','303.02','303.03','303.90','303.91','303.92','303.93','305.00','305.01','305.02','305.03','V11.3')
					and b.PatientTransferDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('290.0','291.1','291.2','291.3','291.5','291.81','291.82','291.89','291.9',
			    '303.00','303.01','303.02','303.03','303.90','303.91','303.92','303.93','305.00','305.01','305.02','305.03','V11.3')
					and b.SpecialtyTransferDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('290.0','291.1','291.2','291.3','291.5','291.81','291.82','291.89','291.9',
			    '303.00','303.01','303.02','303.03','303.90','303.91','303.92','303.93','305.00','305.01','305.02','305.03','V11.3')
					and b.AdmitDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.231', 'F10.96', 'F10.27','F10.951','F10.950', 'F10.239', 'F10.182', 'F10.282', 'F10.982', 'F10.159', 'F10.180', 
					'F10.181', 'F10.188','F10.259', 'F10.280', 'F10.281', 'F10.288', 'F10.959', 'F10.980', 'F10.99','F10.229', 'F10.20', 'F10.21','F10.10','F10.11','Z65.8 ')
and b.DischargeDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.231', 'F10.96', 'F10.27','F10.951','F10.950', 'F10.239', 'F10.182', 'F10.282', 'F10.982', 'F10.159', 'F10.180', 
					'F10.181', 'F10.188','F10.259', 'F10.280', 'F10.281', 'F10.288', 'F10.959', 'F10.980', 'F10.99','F10.229', 'F10.20', 'F10.21','F10.10','F10.11','Z65.8 ')
and b.DischargeDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.231', 'F10.96', 'F10.27','F10.951','F10.950', 'F10.239', 'F10.182', 'F10.282', 'F10.982', 'F10.159', 'F10.180', 
					'F10.181', 'F10.188','F10.259', 'F10.280', 'F10.281', 'F10.288', 'F10.959', 'F10.980', 'F10.99','F10.229', 'F10.20', 'F10.21','F10.10','F10.11','Z65.8 ')
and b.DischargeDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.231', 'F10.96', 'F10.27','F10.951','F10.950', 'F10.239', 'F10.182', 'F10.282', 'F10.982', 'F10.159', 'F10.180', 
					'F10.181', 'F10.188','F10.259', 'F10.280', 'F10.281', 'F10.288', 'F10.959', 'F10.980', 'F10.99','F10.229', 'F10.20', 'F10.21','F10.10','F10.11','Z65.8 ')
and b.EventDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.231', 'F10.96', 'F10.27','F10.951','F10.950', 'F10.239', 'F10.182', 'F10.282', 'F10.982', 'F10.159', 'F10.180', 
					'F10.181', 'F10.188','F10.259', 'F10.280', 'F10.281', 'F10.288', 'F10.959', 'F10.980', 'F10.99','F10.229', 'F10.20', 'F10.21','F10.10','F10.11','Z65.8 ')
and b.EventDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.231', 'F10.96', 'F10.27','F10.951','F10.950', 'F10.239', 'F10.182', 'F10.282', 'F10.982', 'F10.159', 'F10.180', 
					'F10.181', 'F10.188','F10.259', 'F10.280', 'F10.281', 'F10.288', 'F10.959', 'F10.980', 'F10.99','F10.229', 'F10.20', 'F10.21','F10.10','F10.11','Z65.8 ')
and b.EventDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)

union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.231', 'F10.96', 'F10.27','F10.951','F10.950', 'F10.239', 'F10.182', 'F10.282', 'F10.982', 'F10.159', 'F10.180', 
					'F10.181', 'F10.188','F10.259', 'F10.280', 'F10.281', 'F10.288', 'F10.959', 'F10.980', 'F10.99','F10.229', 'F10.20', 'F10.21','F10.10','F10.11','Z65.8 ')
and b.PatientTransferDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)

union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.231', 'F10.96', 'F10.27','F10.951','F10.950', 'F10.239', 'F10.182', 'F10.282', 'F10.982', 'F10.159', 'F10.180', 
					'F10.181', 'F10.188','F10.259', 'F10.280', 'F10.281', 'F10.288', 'F10.959', 'F10.980', 'F10.99','F10.229', 'F10.20', 'F10.21','F10.10','F10.11','Z65.8 ')
and b.SpecialtyTransferDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)

union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.231', 'F10.96', 'F10.27','F10.951','F10.950', 'F10.239', 'F10.182', 'F10.282', 'F10.982', 'F10.159', 'F10.180', 
					'F10.181', 'F10.188','F10.259', 'F10.280', 'F10.281', 'F10.288', 'F10.959', 'F10.980', 'F10.99','F10.229', 'F10.20', 'F10.21','F10.10','F10.11','Z65.8 ')
and b.AdmitDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)

select distinct scrssn from Dflt.Diabetes_AF_GLP1_AlcoholAbuse --35

/*Polysubstance Abuse */
/*Making sure the ICD9 and ICD10 codes relevant to Polysubstance Abuse are present in the Dimension table under CDWWork*/

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('F10.129','F10.229','F10.929','F10.10','F10.20','F11.10',
																	'F11.10','F11.20','F11.129','F11.229','F11.929','F11.122','F11.222','F11.922','F11.23','F11.99',
																	'F13.10','F13.20','F14.10','F14.20','F12.10','F12.20','F16.10','F16.20','F18.10','F18.20',
																	'F19.10','F19.20','Z72.0','F17.200','F15.10','F15.20','F15.929')

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('303.00','305.00','303.90','304.00','292.89','292.0','292.9','304.10','305.40','304.20','305.60',
															'304.30','305.20','304.50','305.30','305.90','304.60','304.80','304.90','305.10',
															'305.70','304.40','304.6')

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.DischargeDateTime as comorbidity_Dischargedatettime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_AF_GLP1_PolyAbuse

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('303.00','305.00','303.90','304.00','292.89','292.0','292.9','304.10','305.40','304.20','305.60',
					'304.30','305.20','304.50','305.30','305.90','304.60','304.80','304.90','305.10','305.70','304.40','304.6')
					and b.DischargeDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('303.00','305.00','303.90','304.00','292.89','292.0','292.9','304.10','305.40','304.20','305.60',
					'304.30','305.20','304.50','305.30','305.90','304.60','304.80','304.90','305.10','305.70','304.40','304.6')
					and b.DischargeDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('303.00','305.00','303.90','304.00','292.89','292.0','292.9','304.10','305.40','304.20','305.60',
					'304.30','305.20','304.50','305.30','305.90','304.60','304.80','304.90','305.10','305.70','304.40','304.6')
					and b.DischargeDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('303.00','305.00','303.90','304.00','292.89','292.0','292.9','304.10','305.40','304.20','305.60',
					'304.30','305.20','304.50','305.30','305.90','304.60','304.80','304.90','305.10','305.70','304.40','304.6')
					and b.EventDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('303.00','305.00','303.90','304.00','292.89','292.0','292.9','304.10','305.40','304.20','305.60',
					'304.30','305.20','304.50','305.30','305.90','304.60','304.80','304.90','305.10','305.70','304.40','304.6')
					and b.EventDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('303.00','305.00','303.90','304.00','292.89','292.0','292.9','304.10','305.40','304.20','305.60',
					'304.30','305.20','304.50','305.30','305.90','304.60','304.80','304.90','305.10','305.70','304.40','304.6')
					and b.EventDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('303.00','305.00','303.90','304.00','292.89','292.0','292.9','304.10','305.40','304.20','305.60',
					'304.30','305.20','304.50','305.30','305.90','304.60','304.80','304.90','305.10','305.70','304.40','304.6')
					and b.PatientTransferDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('303.00','305.00','303.90','304.00','292.89','292.0','292.9','304.10','305.40','304.20','305.60',
					'304.30','305.20','304.50','305.30','305.90','304.60','304.80','304.90','305.10','305.70','304.40','304.6')
					and b.SpecialtyTransferDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('303.00','305.00','303.90','304.00','292.89','292.0','292.9','304.10','305.40','304.20','305.60',
					'304.30','305.20','304.50','305.30','305.90','304.60','304.80','304.90','305.10','305.70','304.40','304.6')
					and b.AdmitDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.129','F10.229','F10.929','F10.10','F10.20','F11.10',
					'F11.10','F11.20','F11.129','F11.229','F11.929','F11.122','F11.222','F11.922','F11.23','F11.99',
					'F13.10','F13.20','F14.10','F14.20','F12.10','F12.20','F16.10','F16.20','F18.10','F18.20',
					'F19.10','F19.20','Z72.0','F17.200','F15.10','F15.20','F15.929')
and b.DischargeDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.129','F10.229','F10.929','F10.10','F10.20','F11.10',
					'F11.10','F11.20','F11.129','F11.229','F11.929','F11.122','F11.222','F11.922','F11.23','F11.99',
					'F13.10','F13.20','F14.10','F14.20','F12.10','F12.20','F16.10','F16.20','F18.10','F18.20',
					'F19.10','F19.20','Z72.0','F17.200','F15.10','F15.20','F15.929')
and b.DischargeDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.129','F10.229','F10.929','F10.10','F10.20','F11.10',
					'F11.10','F11.20','F11.129','F11.229','F11.929','F11.122','F11.222','F11.922','F11.23','F11.99',
					'F13.10','F13.20','F14.10','F14.20','F12.10','F12.20','F16.10','F16.20','F18.10','F18.20',
					'F19.10','F19.20','Z72.0','F17.200','F15.10','F15.20','F15.929')
and b.DischargeDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.129','F10.229','F10.929','F10.10','F10.20','F11.10',
					'F11.10','F11.20','F11.129','F11.229','F11.929','F11.122','F11.222','F11.922','F11.23','F11.99',
					'F13.10','F13.20','F14.10','F14.20','F12.10','F12.20','F16.10','F16.20','F18.10','F18.20',
					'F19.10','F19.20','Z72.0','F17.200','F15.10','F15.20','F15.929')
and b.EventDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.129','F10.229','F10.929','F10.10','F10.20','F11.10',
					'F11.10','F11.20','F11.129','F11.229','F11.929','F11.122','F11.222','F11.922','F11.23','F11.99',
					'F13.10','F13.20','F14.10','F14.20','F12.10','F12.20','F16.10','F16.20','F18.10','F18.20',
					'F19.10','F19.20','Z72.0','F17.200','F15.10','F15.20','F15.929')
and b.EventDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.129','F10.229','F10.929','F10.10','F10.20','F11.10',
					'F11.10','F11.20','F11.129','F11.229','F11.929','F11.122','F11.222','F11.922','F11.23','F11.99',
					'F13.10','F13.20','F14.10','F14.20','F12.10','F12.20','F16.10','F16.20','F18.10','F18.20',
					'F19.10','F19.20','Z72.0','F17.200','F15.10','F15.20','F15.929')
and b.EventDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)

union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.129','F10.229','F10.929','F10.10','F10.20','F11.10',
					'F11.10','F11.20','F11.129','F11.229','F11.929','F11.122','F11.222','F11.922','F11.23','F11.99',
					'F13.10','F13.20','F14.10','F14.20','F12.10','F12.20','F16.10','F16.20','F18.10','F18.20',
					'F19.10','F19.20','Z72.0','F17.200','F15.10','F15.20','F15.929')
and b.PatientTransferDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)

union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.129','F10.229','F10.929','F10.10','F10.20','F11.10',
					'F11.10','F11.20','F11.129','F11.229','F11.929','F11.122','F11.222','F11.922','F11.23','F11.99',
					'F13.10','F13.20','F14.10','F14.20','F12.10','F12.20','F16.10','F16.20','F18.10','F18.20',
					'F19.10','F19.20','Z72.0','F17.200','F15.10','F15.20','F15.929')
and b.SpecialtyTransferDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)

union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.129','F10.229','F10.929','F10.10','F10.20','F11.10',
					'F11.10','F11.20','F11.129','F11.229','F11.929','F11.122','F11.222','F11.922','F11.23','F11.99',
					'F13.10','F13.20','F14.10','F14.20','F12.10','F12.20','F16.10','F16.20','F18.10','F18.20',
					'F19.10','F19.20','Z72.0','F17.200','F15.10','F15.20','F15.929')
and b.AdmitDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)

Select distinct scrssn from Dflt.Diabetes_AF_GLP1_PolyAbuse --94 

/*Depression */
/*Making sure the ICD9 and ICD10 codes relevant to depression are present in the Dimension table under CDWWork*/

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('296.20','296.22','296.23','296.30','296.32','296.33','300.00','311.','300.4','301.12','309.0','309.1')

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('F32.9','F32.1','F32.2','F33.1','F33.2','F41.9','F34.1','F43.21')

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.DischargeDateTime as comorbidity_Dischargedatettime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_AF_GLP1_Depression

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('296.20','296.22','296.23','296.30','296.32','296.33','300.00','311.','300.4','301.12','309.0','309.1')
					and b.DischargeDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('296.20','296.22','296.23','296.30','296.32','296.33','300.00','311.','300.4','301.12','309.0','309.1')
					and b.DischargeDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('296.20','296.22','296.23','296.30','296.32','296.33','300.00','311.','300.4','301.12','309.0','309.1')
					and b.DischargeDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('296.20','296.22','296.23','296.30','296.32','296.33','300.00','311.','300.4','301.12','309.0','309.1')
					and b.EventDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('296.20','296.22','296.23','296.30','296.32','296.33','300.00','311.','300.4','301.12','309.0','309.1')
					and b.EventDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('296.20','296.22','296.23','296.30','296.32','296.33','300.00','311.','300.4','301.12','309.0','309.1')
					and b.EventDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('296.20','296.22','296.23','296.30','296.32','296.33','300.00','311.','300.4','301.12','309.0','309.1')
					and b.PatientTransferDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('296.20','296.22','296.23','296.30','296.32','296.33','300.00','311.','300.4','301.12','309.0','309.1')
					and b.SpecialtyTransferDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('296.20','296.22','296.23','296.30','296.32','296.33','300.00','311.','300.4','301.12','309.0','309.1')
					and b.AdmitDateTime <= a.GLP1FillTime
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F32.9','F32.1','F32.2','F33.1','F33.2','F41.9','F34.1','F43.21') 
and b.DischargeDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F32.9','F32.1','F32.2','F33.1','F33.2','F41.9','F34.1','F43.21') 
and b.DischargeDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F32.9','F32.1','F32.2','F33.1','F33.2','F41.9','F34.1','F43.21') 
and b.DischargeDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F32.9','F32.1','F32.2','F33.1','F33.2','F41.9','F34.1','F43.21') 
and b.EventDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F32.9','F32.1','F32.2','F33.1','F33.2','F41.9','F34.1','F43.21') 
and b.EventDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F32.9','F32.1','F32.2','F33.1','F33.2','F41.9','F34.1','F43.21') 
and b.EventDateTime <= a.GLP1FillTime

union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F32.9','F32.1','F32.2','F33.1','F33.2','F41.9','F34.1','F43.21') 
and b.PatientTransferDateTime <= a.GLP1FillTime

union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F32.9','F32.1','F32.2','F33.1','F33.2','F41.9','F34.1','F43.21') 
and b.SpecialtyTransferDateTime <= a.GLP1FillTime

union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F32.9','F32.1','F32.2','F33.1','F33.2','F41.9','F34.1','F43.21') 
and b.AdmitDateTime <= a.GLP1FillTime

select distinct scrssn from Dflt.Diabetes_AF_GLP1_Depression --663

/* COPD Chronic Obstructive Pulmonary Disease*/
/*Making sure the ICD9 and ICD10 codes relevant to COPD are present in the Dimension table under CDWWork*/

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('490.','491.0','491.1','491.2','491.20','491.21','491.22','491.8','491.9','492.0','492.8',
'493.00','493.01','493.02','493.10','493.11','493.12','493.20','493.21','493.22','493.81','493.82','493.90','493.91','493.92',
'494.','494.0','494.1','495.0','495.1','495.2','495.3','495.4','495.5','495.6','495.7','495.8','495.9','496.')

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('J40.','J41.0','J41.1','J41.8','J42.','J43.9','J44.0','J44.1','J44.9',
'J45.20','J45.22','J45.21','J45.990','J45.991','J45.909','J45.998','J45.902','J45.901','J47.9','J47.1',
'J67.0','J67.1','J67.2','J67.3','J67.4','J67.5','J67.6','J67.7','J67.8','J67.9')

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.DischargeDateTime as comorbidity_Dischargedatettime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_AF_GLP1_COPD

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('490.','491.0','491.1','491.2','491.20','491.21','491.22','491.8','491.9','492.0','492.8',
'493.00','493.01','493.02','493.10','493.11','493.12','493.20','493.21','493.22','493.81','493.82','493.90','493.91','493.92',
'494.','494.0','494.1','495.0','495.1','495.2','495.3','495.4','495.5','495.6','495.7','495.8','495.9','496.')
					and b.DischargeDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('490.','491.0','491.1','491.2','491.20','491.21','491.22','491.8','491.9','492.0','492.8',
'493.00','493.01','493.02','493.10','493.11','493.12','493.20','493.21','493.22','493.81','493.82','493.90','493.91','493.92',
'494.','494.0','494.1','495.0','495.1','495.2','495.3','495.4','495.5','495.6','495.7','495.8','495.9','496.')
					and b.DischargeDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('490.','491.0','491.1','491.2','491.20','491.21','491.22','491.8','491.9','492.0','492.8',
'493.00','493.01','493.02','493.10','493.11','493.12','493.20','493.21','493.22','493.81','493.82','493.90','493.91','493.92',
'494.','494.0','494.1','495.0','495.1','495.2','495.3','495.4','495.5','495.6','495.7','495.8','495.9','496.')
					and b.DischargeDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('490.','491.0','491.1','491.2','491.20','491.21','491.22','491.8','491.9','492.0','492.8',
'493.00','493.01','493.02','493.10','493.11','493.12','493.20','493.21','493.22','493.81','493.82','493.90','493.91','493.92',
'494.','494.0','494.1','495.0','495.1','495.2','495.3','495.4','495.5','495.6','495.7','495.8','495.9','496.')
					and b.EventDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('490.','491.0','491.1','491.2','491.20','491.21','491.22','491.8','491.9','492.0','492.8',
'493.00','493.01','493.02','493.10','493.11','493.12','493.20','493.21','493.22','493.81','493.82','493.90','493.91','493.92',
'494.','494.0','494.1','495.0','495.1','495.2','495.3','495.4','495.5','495.6','495.7','495.8','495.9','496.')
					and b.EventDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('490.','491.0','491.1','491.2','491.20','491.21','491.22','491.8','491.9','492.0','492.8',
'493.00','493.01','493.02','493.10','493.11','493.12','493.20','493.21','493.22','493.81','493.82','493.90','493.91','493.92',
'494.','494.0','494.1','495.0','495.1','495.2','495.3','495.4','495.5','495.6','495.7','495.8','495.9','496.')
					and b.EventDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('490.','491.0','491.1','491.2','491.20','491.21','491.22','491.8','491.9','492.0','492.8',
'493.00','493.01','493.02','493.10','493.11','493.12','493.20','493.21','493.22','493.81','493.82','493.90','493.91','493.92',
'494.','494.0','494.1','495.0','495.1','495.2','495.3','495.4','495.5','495.6','495.7','495.8','495.9','496.')
					and b.PatientTransferDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('490.','491.0','491.1','491.2','491.20','491.21','491.22','491.8','491.9','492.0','492.8',
'493.00','493.01','493.02','493.10','493.11','493.12','493.20','493.21','493.22','493.81','493.82','493.90','493.91','493.92',
'494.','494.0','494.1','495.0','495.1','495.2','495.3','495.4','495.5','495.6','495.7','495.8','495.9','496.')
					and b.SpecialtyTransferDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('490.','491.0','491.1','491.2','491.20','491.21','491.22','491.8','491.9','492.0','492.8',
'493.00','493.01','493.02','493.10','493.11','493.12','493.20','493.21','493.22','493.81','493.82','493.90','493.91','493.92',
'494.','494.0','494.1','495.0','495.1','495.2','495.3','495.4','495.5','495.6','495.7','495.8','495.9','496.')
					and b.AdmitDateTime <= a.GLP1FillTime
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F20.0','F20.1','F20.2','F20.3','F20.81','F20.89','F20.9','F25.9')
and b.DischargeDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('J40.','J41.0','J41.1','J41.8','J42.','J43.9','J44.0','J44.1','J44.9',
'J45.20','J45.22','J45.21','J45.990','J45.991','J45.909','J45.998','J45.902','J45.901','J47.9','J47.1',
'J67.0','J67.1','J67.2','J67.3','J67.4','J67.5','J67.6','J67.7','J67.8','J67.9')
and b.DischargeDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('J40.','J41.0','J41.1','J41.8','J42.','J43.9','J44.0','J44.1','J44.9',
'J45.20','J45.22','J45.21','J45.990','J45.991','J45.909','J45.998','J45.902','J45.901','J47.9','J47.1',
'J67.0','J67.1','J67.2','J67.3','J67.4','J67.5','J67.6','J67.7','J67.8','J67.9')
and b.DischargeDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('J40.','J41.0','J41.1','J41.8','J42.','J43.9','J44.0','J44.1','J44.9',
'J45.20','J45.22','J45.21','J45.990','J45.991','J45.909','J45.998','J45.902','J45.901','J47.9','J47.1',
'J67.0','J67.1','J67.2','J67.3','J67.4','J67.5','J67.6','J67.7','J67.8','J67.9')
and b.EventDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('J40.','J41.0','J41.1','J41.8','J42.','J43.9','J44.0','J44.1','J44.9',
'J45.20','J45.22','J45.21','J45.990','J45.991','J45.909','J45.998','J45.902','J45.901','J47.9','J47.1',
'J67.0','J67.1','J67.2','J67.3','J67.4','J67.5','J67.6','J67.7','J67.8','J67.9')
and b.EventDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('J40.','J41.0','J41.1','J41.8','J42.','J43.9','J44.0','J44.1','J44.9',
'J45.20','J45.22','J45.21','J45.990','J45.991','J45.909','J45.998','J45.902','J45.901','J47.9','J47.1',
'J67.0','J67.1','J67.2','J67.3','J67.4','J67.5','J67.6','J67.7','J67.8','J67.9')
and b.EventDateTime <= a.GLP1FillTime

union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('J40.','J41.0','J41.1','J41.8','J42.','J43.9','J44.0','J44.1','J44.9',
'J45.20','J45.22','J45.21','J45.990','J45.991','J45.909','J45.998','J45.902','J45.901','J47.9','J47.1',
'J67.0','J67.1','J67.2','J67.3','J67.4','J67.5','J67.6','J67.7','J67.8','J67.9')
and b.PatientTransferDateTime <= a.GLP1FillTime

union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('J40.','J41.0','J41.1','J41.8','J42.','J43.9','J44.0','J44.1','J44.9',
'J45.20','J45.22','J45.21','J45.990','J45.991','J45.909','J45.998','J45.902','J45.901','J47.9','J47.1',
'J67.0','J67.1','J67.2','J67.3','J67.4','J67.5','J67.6','J67.7','J67.8','J67.9')
and b.SpecialtyTransferDateTime <= a.GLP1FillTime

union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('J40.','J41.0','J41.1','J41.8','J42.','J43.9','J44.0','J44.1','J44.9',
'J45.20','J45.22','J45.21','J45.990','J45.991','J45.909','J45.998','J45.902','J45.901','J47.9','J47.1',
'J67.0','J67.1','J67.2','J67.3','J67.4','J67.5','J67.6','J67.7','J67.8','J67.9')
and b.AdmitDateTime <= a.GLP1FillTime

select distinct scrssn from Dflt.Diabetes_AF_GLP1_COPD --682


/* Chronic Liver Disease */
/*Making sure the ICD9 and ICD10 codes relevant to CLD are present in the Dimension table under CDWWork*/

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('B18.0','B18.1','B18.2','I85.00','I85.01','I85.10','I85.11','K70.0','K70.30','K70.9','K73.0','K73.2','K73.8','K73.9',
													'K75.4','K74.0','K74.60','K74.69','K74.3','K74.4','K74.5','K74.1','K76.0','K76.89','K76.9','K76.6','K72.10','K72.90','Z94.4')

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('070.22','070.32','070.23','070.33','070.44','070.54','456.1','456.0','456.21','456.20','571.0','571.2','571.3',
												'571.41','571.49','571.40','571.42','571.5','571.9','571.6','571.8','572.3','572.8','V42.7')

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.DischargeDateTime as comorbidity_Dischargedatettime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_AF_GLP1_LiverDisease

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('070.22','070.32','070.23','070.33','070.44','070.54','456.1','456.0','456.21','456.20','571.0','571.2','571.3',
					'571.41','571.49','571.40','571.42','571.5','571.9','571.6','571.8','572.3','572.8','V42.7')
					and b.DischargeDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('070.22','070.32','070.23','070.33','070.44','070.54','456.1','456.0','456.21','456.20','571.0','571.2','571.3',
					'571.41','571.49','571.40','571.42','571.5','571.9','571.6','571.8','572.3','572.8','V42.7')
					and b.DischargeDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('070.22','070.32','070.23','070.33','070.44','070.54','456.1','456.0','456.21','456.20','571.0','571.2','571.3',
					'571.41','571.49','571.40','571.42','571.5','571.9','571.6','571.8','572.3','572.8','V42.7')
					and b.DischargeDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('070.22','070.32','070.23','070.33','070.44','070.54','456.1','456.0','456.21','456.20','571.0','571.2','571.3',
					'571.41','571.49','571.40','571.42','571.5','571.9','571.6','571.8','572.3','572.8','V42.7')
					and b.EventDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('070.22','070.32','070.23','070.33','070.44','070.54','456.1','456.0','456.21','456.20','571.0','571.2','571.3',
					'571.41','571.49','571.40','571.42','571.5','571.9','571.6','571.8','572.3','572.8','V42.7')
					and b.EventDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('070.22','070.32','070.23','070.33','070.44','070.54','456.1','456.0','456.21','456.20','571.0','571.2','571.3',
					'571.41','571.49','571.40','571.42','571.5','571.9','571.6','571.8','572.3','572.8','V42.7')
					and b.EventDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('070.22','070.32','070.23','070.33','070.44','070.54','456.1','456.0','456.21','456.20','571.0','571.2','571.3',
					'571.41','571.49','571.40','571.42','571.5','571.9','571.6','571.8','572.3','572.8','V42.7')
					and b.PatientTransferDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('070.22','070.32','070.23','070.33','070.44','070.54','456.1','456.0','456.21','456.20','571.0','571.2','571.3',
					'571.41','571.49','571.40','571.42','571.5','571.9','571.6','571.8','572.3','572.8','V42.7')
					and b.SpecialtyTransferDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('070.22','070.32','070.23','070.33','070.44','070.54','456.1','456.0','456.21','456.20','571.0','571.2','571.3',
					'571.41','571.49','571.40','571.42','571.5','571.9','571.6','571.8','572.3','572.8','V42.7')
					and b.AdmitDateTime <= a.GLP1FillTime
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('B18.0','B18.1','B18.2','I85.00','I85.01','I85.10','I85.11','K70.0','K70.30','K70.9','K73.0','K73.2','K73.8','K73.9',
					'K75.4','K74.0','K74.60','K74.69','K74.3','K74.4','K74.5','K74.1','K76.0','K76.89','K76.9','K76.6','K72.10','K72.90','Z94.4')
and b.DischargeDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('B18.0','B18.1','B18.2','I85.00','I85.01','I85.10','I85.11','K70.0','K70.30','K70.9','K73.0','K73.2','K73.8','K73.9',
					'K75.4','K74.0','K74.60','K74.69','K74.3','K74.4','K74.5','K74.1','K76.0','K76.89','K76.9','K76.6','K72.10','K72.90','Z94.4')
and b.DischargeDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('B18.0','B18.1','B18.2','I85.00','I85.01','I85.10','I85.11','K70.0','K70.30','K70.9','K73.0','K73.2','K73.8','K73.9',
					'K75.4','K74.0','K74.60','K74.69','K74.3','K74.4','K74.5','K74.1','K76.0','K76.89','K76.9','K76.6','K72.10','K72.90','Z94.4') 
and b.DischargeDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('B18.0','B18.1','B18.2','I85.00','I85.01','I85.10','I85.11','K70.0','K70.30','K70.9','K73.0','K73.2','K73.8','K73.9',
					'K75.4','K74.0','K74.60','K74.69','K74.3','K74.4','K74.5','K74.1','K76.0','K76.89','K76.9','K76.6','K72.10','K72.90','Z94.4')
and b.EventDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('B18.0','B18.1','B18.2','I85.00','I85.01','I85.10','I85.11','K70.0','K70.30','K70.9','K73.0','K73.2','K73.8','K73.9',
					'K75.4','K74.0','K74.60','K74.69','K74.3','K74.4','K74.5','K74.1','K76.0','K76.89','K76.9','K76.6','K72.10','K72.90','Z94.4')
and b.EventDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('B18.0','B18.1','B18.2','I85.00','I85.01','I85.10','I85.11','K70.0','K70.30','K70.9','K73.0','K73.2','K73.8','K73.9',
					'K75.4','K74.0','K74.60','K74.69','K74.3','K74.4','K74.5','K74.1','K76.0','K76.89','K76.9','K76.6','K72.10','K72.90','Z94.4')
and b.EventDateTime <= a.GLP1FillTime

union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('B18.0','B18.1','B18.2','I85.00','I85.01','I85.10','I85.11','K70.0','K70.30','K70.9','K73.0','K73.2','K73.8','K73.9',
					'K75.4','K74.0','K74.60','K74.69','K74.3','K74.4','K74.5','K74.1','K76.0','K76.89','K76.9','K76.6','K72.10','K72.90','Z94.4')
and b.PatientTransferDateTime <= a.GLP1FillTime

union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('B18.0','B18.1','B18.2','I85.00','I85.01','I85.10','I85.11','K70.0','K70.30','K70.9','K73.0','K73.2','K73.8','K73.9',
					'K75.4','K74.0','K74.60','K74.69','K74.3','K74.4','K74.5','K74.1','K76.0','K76.89','K76.9','K76.6','K72.10','K72.90','Z94.4')
and b.SpecialtyTransferDateTime <= a.GLP1FillTime

union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('B18.0','B18.1','B18.2','I85.00','I85.01','I85.10','I85.11','K70.0','K70.30','K70.9','K73.0','K73.2','K73.8','K73.9',
					'K75.4','K74.0','K74.60','K74.69','K74.3','K74.4','K74.5','K74.1','K76.0','K76.89','K76.9','K76.6','K72.10','K72.90','Z94.4')
and b.AdmitDateTime <= a.GLP1FillTime

select distinct scrssn from Dflt.Diabetes_AF_GLP1_LiverDisease --168

/* Malignancy */
/*Making sure the ICD9 and ICD10 codes relevant to Malignancy are present in the Dimension table under CDWWork*/

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('196.0','196.1','196.2','196.3','196.5','196.6','196.8','196.9','197.0','197.1','197.2','197.3','197.4','197.5',
					'197.6','197.7','197.8','198.0','198.1','198.2','198.3','198.4','198.5','198.6','198.7','198.81','198.82','198.89','199.0','199.1')

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('C77.0','C77.1','C77.2','C77.3','C77.4','C77.5','C77.8','C77.9','C78.0','C78.1','C78.2','C78.3',
					'C78.4', 'C78.5','C78.6', 'C78.7', 'C78.89','C79.9','C79.11','C79.2','C79.31','C79.32','C79.49',
					'C79.51','C79.52','C79.60','C79.70','C79.81','C79.82','C79.89','C80.0','C80.1')

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.DischargeDateTime as comorbidity_Dischargedatettime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_AF_GLP1_Malignancy

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('196.0','196.1','196.2','196.3','196.5','196.6','196.8','196.9','197.0','197.1','197.2','197.3','197.4','197.5',
					'197.6','197.7','197.8','198.0','198.1','198.2','198.3','198.4','198.5','198.6','198.7','198.81','198.82','198.89','199.0','199.1')
					and b.DischargeDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('196.0','196.1','196.2','196.3','196.5','196.6','196.8','196.9','197.0','197.1','197.2','197.3','197.4','197.5',
					'197.6','197.7','197.8','198.0','198.1','198.2','198.3','198.4','198.5','198.6','198.7','198.81','198.82','198.89','199.0','199.1')
					and b.DischargeDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('196.0','196.1','196.2','196.3','196.5','196.6','196.8','196.9','197.0','197.1','197.2','197.3','197.4','197.5',
					'197.6','197.7','197.8','198.0','198.1','198.2','198.3','198.4','198.5','198.6','198.7','198.81','198.82','198.89','199.0','199.1')
					and b.DischargeDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('196.0','196.1','196.2','196.3','196.5','196.6','196.8','196.9','197.0','197.1','197.2','197.3','197.4','197.5',
					'197.6','197.7','197.8','198.0','198.1','198.2','198.3','198.4','198.5','198.6','198.7','198.81','198.82','198.89','199.0','199.1')
					and b.EventDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('196.0','196.1','196.2','196.3','196.5','196.6','196.8','196.9','197.0','197.1','197.2','197.3','197.4','197.5',
					'197.6','197.7','197.8','198.0','198.1','198.2','198.3','198.4','198.5','198.6','198.7','198.81','198.82','198.89','199.0','199.1')
					and b.EventDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('196.0','196.1','196.2','196.3','196.5','196.6','196.8','196.9','197.0','197.1','197.2','197.3','197.4','197.5',
					'197.6','197.7','197.8','198.0','198.1','198.2','198.3','198.4','198.5','198.6','198.7','198.81','198.82','198.89','199.0','199.1')
					and b.EventDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('196.0','196.1','196.2','196.3','196.5','196.6','196.8','196.9','197.0','197.1','197.2','197.3','197.4','197.5',
					'197.6','197.7','197.8','198.0','198.1','198.2','198.3','198.4','198.5','198.6','198.7','198.81','198.82','198.89','199.0','199.1')
					and b.PatientTransferDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('196.0','196.1','196.2','196.3','196.5','196.6','196.8','196.9','197.0','197.1','197.2','197.3','197.4','197.5',
					'197.6','197.7','197.8','198.0','198.1','198.2','198.3','198.4','198.5','198.6','198.7','198.81','198.82','198.89','199.0','199.1')
					and b.SpecialtyTransferDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('196.0','196.1','196.2','196.3','196.5','196.6','196.8','196.9','197.0','197.1','197.2','197.3','197.4','197.5',
					'197.6','197.7','197.8','198.0','198.1','198.2','198.3','198.4','198.5','198.6','198.7','198.81','198.82','198.89','199.0','199.1')
					and b.AdmitDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('C77.0','C77.1','C77.2','C77.3','C77.4','C77.5','C77.8','C77.9','C78.0','C78.1','C78.2','C78.3',
					'C78.4', 'C78.5','C78.6', 'C78.7', 'C78.89','C79.9','C79.11','C79.2','C79.31','C79.32','C79.49',
					'C79.51','C79.52','C79.60','C79.70','C79.81','C79.82','C79.89','C80.0','C80.1')
and b.DischargeDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('C77.0','C77.1','C77.2','C77.3','C77.4','C77.5','C77.8','C77.9','C78.0','C78.1','C78.2','C78.3',
					'C78.4', 'C78.5','C78.6', 'C78.7', 'C78.89','C79.9','C79.11','C79.2','C79.31','C79.32','C79.49',
					'C79.51','C79.52','C79.60','C79.70','C79.81','C79.82','C79.89','C80.0','C80.1')
and b.DischargeDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('C77.0','C77.1','C77.2','C77.3','C77.4','C77.5','C77.8','C77.9','C78.0','C78.1','C78.2','C78.3',
					'C78.4', 'C78.5','C78.6', 'C78.7', 'C78.89','C79.9','C79.11','C79.2','C79.31','C79.32','C79.49',
					'C79.51','C79.52','C79.60','C79.70','C79.81','C79.82','C79.89','C80.0','C80.1') 
and b.DischargeDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('C77.0','C77.1','C77.2','C77.3','C77.4','C77.5','C77.8','C77.9','C78.0','C78.1','C78.2','C78.3',
					'C78.4', 'C78.5','C78.6', 'C78.7', 'C78.89','C79.9','C79.11','C79.2','C79.31','C79.32','C79.49',
					'C79.51','C79.52','C79.60','C79.70','C79.81','C79.82','C79.89','C80.0','C80.1')
and b.EventDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('C77.0','C77.1','C77.2','C77.3','C77.4','C77.5','C77.8','C77.9','C78.0','C78.1','C78.2','C78.3',
					'C78.4', 'C78.5','C78.6', 'C78.7', 'C78.89','C79.9','C79.11','C79.2','C79.31','C79.32','C79.49',
					'C79.51','C79.52','C79.60','C79.70','C79.81','C79.82','C79.89','C80.0','C80.1')
and b.EventDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('C77.0','C77.1','C77.2','C77.3','C77.4','C77.5','C77.8','C77.9','C78.0','C78.1','C78.2','C78.3',
					'C78.4', 'C78.5','C78.6', 'C78.7', 'C78.89','C79.9','C79.11','C79.2','C79.31','C79.32','C79.49',
					'C79.51','C79.52','C79.60','C79.70','C79.81','C79.82','C79.89','C80.0','C80.1')
and b.EventDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)

union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('C77.0','C77.1','C77.2','C77.3','C77.4','C77.5','C77.8','C77.9','C78.0','C78.1','C78.2','C78.3',
					'C78.4', 'C78.5','C78.6', 'C78.7', 'C78.89','C79.9','C79.11','C79.2','C79.31','C79.32','C79.49',
					'C79.51','C79.52','C79.60','C79.70','C79.81','C79.82','C79.89','C80.0','C80.1')
and b.PatientTransferDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)

union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('C77.0','C77.1','C77.2','C77.3','C77.4','C77.5','C77.8','C77.9','C78.0','C78.1','C78.2','C78.3',
					'C78.4', 'C78.5','C78.6', 'C78.7', 'C78.89','C79.9','C79.11','C79.2','C79.31','C79.32','C79.49',
					'C79.51','C79.52','C79.60','C79.70','C79.81','C79.82','C79.89','C80.0','C80.1')
and b.SpecialtyTransferDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)

union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('C77.0','C77.1','C77.2','C77.3','C77.4','C77.5','C77.8','C77.9','C78.0','C78.1','C78.2','C78.3',
					'C78.4', 'C78.5','C78.6', 'C78.7', 'C78.89','C79.9','C79.11','C79.2','C79.31','C79.32','C79.49',
					'C79.51','C79.52','C79.60','C79.70','C79.81','C79.82','C79.89','C80.0','C80.1')
and b.AdmitDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)

select distinct scrssn from Dflt.Diabetes_AF_GLP1_Malignancy --10

/* Hypothyroidism */

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code like ('244.%')

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code like ('E03.%')

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.DischargeDateTime as comorbidity_Dischargedatettime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_AF_GLP1_Hypothyroidism

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like ('244.%')
					and b.DischargeDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like ('244.%')
					and b.DischargeDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like ('244.%')
					and b.DischargeDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like ('244.%')
					and b.EventDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like ('244.%')
					and b.EventDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like ('244.%')
					and b.EventDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like ('244.%')
					and b.PatientTransferDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like ('244.%')
					and b.SpecialtyTransferDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like ('244.%')
					and b.AdmitDateTime <= a.GLP1FillTime
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like ('E03.%')
and b.DischargeDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like ('E03.%')
and b.DischargeDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like ('E03.%')
and b.DischargeDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like ('E03.%')
and b.EventDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like ('E03.%')
and b.EventDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like ('E03.%')
and b.EventDateTime <= a.GLP1FillTime

union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like ('E03.%')
and b.PatientTransferDateTime <= a.GLP1FillTime

union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like ('E03.%')
and b.SpecialtyTransferDateTime <= a.GLP1FillTime

union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like ('E03.%')
and b.AdmitDateTime <= a.GLP1FillTime

select distinct scrssn from Dflt.Diabetes_AF_GLP1_Hypothyroidism --266

/*Smoking */
select distinct a.*, b.SMOKE

into Dflt.Diabetes_AF_GLP1_Smoke

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.VASQIP_nso_noncardiac as b with (NOLOCK) on a.scrssn= b.scrssn 

select * from Dflt.Diabetes_AF_GLP1_Smoke
select distinct scrssn from Dflt.Diabetes_AF_GLP1_Smoke where smoke = '1' --132

/*Prior Stroke */
/*Making sure the ICD9 and ICD10 codes relevant to Stroke are present in the Dimension table under CDWWork*/

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('I63.019','I63.119','I63.139','I63.20','I63.219','I63.22','I63.239','I63.30','I63.40','I63.50','I63.59')

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('433.21','433.11','433.91','433.01','434.01','434.11','434.91','433.31','433.81')

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.DischargeDateTime as comorbidity_Dischargedatettime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_AF_GLP1_Stroke

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('433.21','433.11','433.91','433.01','434.01','434.11','434.91','433.31','433.81')
					and b.DischargeDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('433.21','433.11','433.91','433.01','434.01','434.11','434.91','433.31','433.81')
					and b.DischargeDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('433.21','433.11','433.91','433.01','434.01','434.11','434.91','433.31','433.81')
					and b.DischargeDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('433.21','433.11','433.91','433.01','434.01','434.11','434.91','433.31','433.81')
					and b.EventDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('433.21','433.11','433.91','433.01','434.01','434.11','434.91','433.31','433.81')
					and b.EventDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('433.21','433.11','433.91','433.01','434.01','434.11','434.91','433.31','433.81')
					and b.EventDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('433.21','433.11','433.91','433.01','434.01','434.11','434.91','433.31','433.81')
					and b.PatientTransferDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('433.21','433.11','433.91','433.01','434.01','434.11','434.91','433.31','433.81')
					and b.SpecialtyTransferDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('433.21','433.11','433.91','433.01','434.01','434.11','434.91','433.31','433.81')
					and b.AdmitDateTime <= a.GLP1FillTime
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I63.019','I63.119','I63.139','I63.20','I63.219','I63.22','I63.239','I63.30','I63.40','I63.50','I63.59')
and b.DischargeDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I63.019','I63.119','I63.139','I63.20','I63.219','I63.22','I63.239','I63.30','I63.40','I63.50','I63.59')
and b.DischargeDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I63.019','I63.119','I63.139','I63.20','I63.219','I63.22','I63.239','I63.30','I63.40','I63.50','I63.59')
and b.DischargeDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I63.019','I63.119','I63.139','I63.20','I63.219','I63.22','I63.239','I63.30','I63.40','I63.50','I63.59')
and b.EventDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I63.019','I63.119','I63.139','I63.20','I63.219','I63.22','I63.239','I63.30','I63.40','I63.50','I63.59')
and b.EventDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I63.019','I63.119','I63.139','I63.20','I63.219','I63.22','I63.239','I63.30','I63.40','I63.50','I63.59')
and b.EventDateTime <= a.GLP1FillTime

union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I63.019','I63.119','I63.139','I63.20','I63.219','I63.22','I63.239','I63.30','I63.40','I63.50','I63.59')
and b.PatientTransferDateTime <= a.GLP1FillTime

union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I63.019','I63.119','I63.139','I63.20','I63.219','I63.22','I63.239','I63.30','I63.40','I63.50','I63.59')
and b.SpecialtyTransferDateTime <= a.GLP1FillTime

union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I63.019','I63.119','I63.139','I63.20','I63.219','I63.22','I63.239','I63.30','I63.40','I63.50','I63.59')
and b.AdmitDateTime <= a.GLP1FillTime

select distinct scrssn from Dflt.Diabetes_AF_GLP1_Stroke--70

/* Prior Myocardial Infarction */
/*Making sure the ICD9 and ICD10 codes relevant to Myocardial Infarction are present in the Dimension table under CDWWork*/

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('I21.01','I21.02','I21.19','I21.29','I21.3','I21.4','I21.9','I22.0','I22.1','I22.8','I22.9',
																	'I23.0','I23.1','I23.2','I23.3','I23.4','I23.5','I23.6','I23.7','I23.8','I24.0','I24.1','I24.8')

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('410.00','410.01','410.02','410.10','410.11','410.12','410.30','410.31','410.32','410.20','410.21','410.22',
														'410.40','410.41','410.42','410.50','410.51','410.52','410.60','410.61','410.62','410.80','410.81','410.82',
														'410.90','410.91','410.92','410.70','410.71','410.72','429.79','411.81','411.0','411.89')

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.DischargeDateTime as comorbidity_Dischargedatetime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_AF_GLP1_MI

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('410.00','410.01','410.02','410.10','410.11','410.12','410.30','410.31','410.32','410.20','410.21','410.22',
														'410.40','410.41','410.42','410.50','410.51','410.52','410.60','410.61','410.62','410.80','410.81','410.82',
														'410.90','410.91','410.92','410.70','410.71','410.72','429.79','411.81','411.0','411.89')
					and b.DischargeDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.DischargeDateTime , c.ICD9Code 

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('410.00','410.01','410.02','410.10','410.11','410.12','410.30','410.31','410.32','410.20','410.21','410.22',
														'410.40','410.41','410.42','410.50','410.51','410.52','410.60','410.61','410.62','410.80','410.81','410.82',
														'410.90','410.91','410.92','410.70','410.71','410.72','429.79','411.81','411.0','411.89')
					and b.DischargeDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('410.00','410.01','410.02','410.10','410.11','410.12','410.30','410.31','410.32','410.20','410.21','410.22',
														'410.40','410.41','410.42','410.50','410.51','410.52','410.60','410.61','410.62','410.80','410.81','410.82',
														'410.90','410.91','410.92','410.70','410.71','410.72','429.79','411.81','411.0','411.89')
					and b.DischargeDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('410.00','410.01','410.02','410.10','410.11','410.12','410.30','410.31','410.32','410.20','410.21','410.22',
														'410.40','410.41','410.42','410.50','410.51','410.52','410.60','410.61','410.62','410.80','410.81','410.82',
														'410.90','410.91','410.92','410.70','410.71','410.72','429.79','411.81','411.0','411.89')
					and b.EventDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('410.00','410.01','410.02','410.10','410.11','410.12','410.30','410.31','410.32','410.20','410.21','410.22',
														'410.40','410.41','410.42','410.50','410.51','410.52','410.60','410.61','410.62','410.80','410.81','410.82',
														'410.90','410.91','410.92','410.70','410.71','410.72','429.79','411.81','411.0','411.89')
					and b.EventDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('410.00','410.01','410.02','410.10','410.11','410.12','410.30','410.31','410.32','410.20','410.21','410.22',
														'410.40','410.41','410.42','410.50','410.51','410.52','410.60','410.61','410.62','410.80','410.81','410.82',
														'410.90','410.91','410.92','410.70','410.71','410.72','429.79','411.81','411.0','411.89')
					and b.EventDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('410.00','410.01','410.02','410.10','410.11','410.12','410.30','410.31','410.32','410.20','410.21','410.22',
														'410.40','410.41','410.42','410.50','410.51','410.52','410.60','410.61','410.62','410.80','410.81','410.82',
														'410.90','410.91','410.92','410.70','410.71','410.72','429.79','411.81','411.0','411.89')
					and b.PatientTransferDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('410.00','410.01','410.02','410.10','410.11','410.12','410.30','410.31','410.32','410.20','410.21','410.22',
														'410.40','410.41','410.42','410.50','410.51','410.52','410.60','410.61','410.62','410.80','410.81','410.82',
														'410.90','410.91','410.92','410.70','410.71','410.72','429.79','411.81','411.0','411.89')
				and b.SpecialtyTransferDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('410.00','410.01','410.02','410.10','410.11','410.12','410.30','410.31','410.32','410.20','410.21','410.22',
					'410.40','410.41','410.42','410.50','410.51','410.52','410.60','410.61','410.62','410.80','410.81','410.82',
					'410.90','410.91','410.92','410.70','410.71','410.72','429.79','411.81','411.0','411.89')
					and b.AdmitDateTime <= a.GLP1FillTime
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I21.01','I21.02','I21.19','I21.29','I21.3','I21.4','I21.9','I22.0','I22.1','I22.8','I22.9',
					'I23.0','I23.1','I23.2','I23.3','I23.4','I23.5','I23.6','I23.7','I23.8','I24.0','I24.1','I24.8')
and b.DischargeDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I21.01','I21.02','I21.19','I21.29','I21.3','I21.4','I21.9','I22.0','I22.1','I22.8','I22.9',
					'I23.0','I23.1','I23.2','I23.3','I23.4','I23.5','I23.6','I23.7','I23.8','I24.0','I24.1','I24.8')
and b.DischargeDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I21.01','I21.02','I21.19','I21.29','I21.3','I21.4','I21.9','I22.0','I22.1','I22.8','I22.9',
					'I23.0','I23.1','I23.2','I23.3','I23.4','I23.5','I23.6','I23.7','I23.8','I24.0','I24.1','I24.8')
and b.DischargeDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I21.01','I21.02','I21.19','I21.29','I21.3','I21.4','I21.9','I22.0','I22.1','I22.8','I22.9',
					'I23.0','I23.1','I23.2','I23.3','I23.4','I23.5','I23.6','I23.7','I23.8','I24.0','I24.1','I24.8')
and b.EventDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I21.01','I21.02','I21.19','I21.29','I21.3','I21.4','I21.9','I22.0','I22.1','I22.8','I22.9',
					'I23.0','I23.1','I23.2','I23.3','I23.4','I23.5','I23.6','I23.7','I23.8','I24.0','I24.1','I24.8')
and b.EventDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I21.01','I21.02','I21.19','I21.29','I21.3','I21.4','I21.9','I22.0','I22.1','I22.8','I22.9',
					'I23.0','I23.1','I23.2','I23.3','I23.4','I23.5','I23.6','I23.7','I23.8','I24.0','I24.1','I24.8')
and b.EventDateTime <= a.GLP1FillTime

union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I21.01','I21.02','I21.19','I21.29','I21.3','I21.4','I21.9','I22.0','I22.1','I22.8','I22.9',
					'I23.0','I23.1','I23.2','I23.3','I23.4','I23.5','I23.6','I23.7','I23.8','I24.0','I24.1','I24.8')
and b.PatientTransferDateTime <= a.GLP1FillTime

union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I21.01','I21.02','I21.19','I21.29','I21.3','I21.4','I21.9','I22.0','I22.1','I22.8','I22.9',
					'I23.0','I23.1','I23.2','I23.3','I23.4','I23.5','I23.6','I23.7','I23.8','I24.0','I24.1','I24.8')
and b.SpecialtyTransferDateTime <= a.GLP1FillTime

union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I21.01','I21.02','I21.19','I21.29','I21.3','I21.4','I21.9','I22.0','I22.1','I22.8','I22.9',
					'I23.0','I23.1','I23.2','I23.3','I23.4','I23.5','I23.6','I23.7','I23.8','I24.0','I24.1','I24.8')
and b.AdmitDateTime <= a.GLP1FillTime

Select distinct scrssn from Dflt.Diabetes_AF_GLP1_MI --375

/*Ablation*/
/*Making sure the CPT codes relevant to Ablation are present in the Dimension table under CDWWork*/

select distinct CPTCode from CDWWork.Dim.CPT where CPTCode in ('93656','93657','93662','33254','33255','33258','33265','33266')

select distinct a.*

into Dflt.Diabetes_AF_GLP1_Ablation

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientCPTProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
Src.Cohort_CPT as c with (NOLOCK) on c.CPTSID=b.cptSID 
where c.cptcode in ('93656','93657','93662','33254','33255','33258','33265','33266')
and b.DischargeDateTime <= a.GLP1Filltime
union all

select distinct a.*
from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_Vprocedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
Src.Cohort_CPT as c with (NOLOCK) on c.CPTSID=b.cptSID 
where c.cptcode in ('93656','93657','93662','33254','33255','33258','33265','33266')
and b.EventDateTime <= a.GLP1Filltime
union all 

select distinct a.*
from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_VProcedure_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
Src.Cohort_CPT as c with (NOLOCK) on c.CPTSID=b.cptSID 
where c.cptcode in ('93656','93657','93662','33254','33255','33258','33265','33266')
and b.EventDateTime <= a.GLP1Filltime
union all

select distinct a.*
from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Surg_SurgeryPrincipalAssociatedProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on b.OtherProcedureCPTSID=c.cptSID 
where c.cptcode in ('93656','93657','93662','33254','33255','33258','33265','33266') 
and b.SurgeryDateTime <= a.GLP1Filltime
union all

select distinct a.*
from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Surg_SurgeryProcedureDiagnosisCode as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on b.PrincipalCPTSID=c.cptSID 
where c.cptcode in ('93656','93657','93662','33254','33255','33258','33265','33266')
and b.SurgeryDateTime <= a.GLP1Filltime
union all

select distinct a.*
from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_VProcedureCPTModifier as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on b.CPTSID=c.cptSID 
where c.cptcode in ('93656','93657','93662','33254','33255','33258','33265','33266')
and b.visitdatetime <= a.GLP1Filltime
union all

select distinct a.*
from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_VProcedureDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on b.CPTSID=c.cptSID 
where c.cptcode in ('93656','93657','93662','33254','33255','33258','33265','33266')
and b.EventDateTime <= a.GLP1Filltime
union all

select distinct a.*
from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on b.CPTSID=c.cptSID 
where c.cptcode in ('93656','93657','93662','33254','33255','33258','33265','33266')
and b.EventDateTime <= a.GLP1Filltime
union all

select distinct a.*
from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVProcedureCPTModifier as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on  b.CPTSID=c.cptSID 
where c.cptcode in ('93656','93657','93662','33254','33255','33258','33265','33266')
and b.VisitDateTime <= a.GLP1Filltime

select distinct scrssn from Dflt.Diabetes_AF_GLP1_Ablation --27

/* Ablation Proc codes */

select distinct ICD9ProcedureCode from CDWWork.Dim.ICD9Procedure where ICD9ProcedureCode in ('37.33','37.34','37.37','37.80','38.65') 
select distinct ICD10ProcedureCode from CDWWork.Dim.ICD10Procedure where ICD10ProcedureCode in ('02560ZZ','02563ZZ','02564ZZ',
'02570ZZ','02573ZZ','02574ZZ','02580ZZ','02583ZZ','02584ZZ','025S0ZZ','025S3ZZ','025S4ZZ','025T0ZZ','025T3ZZ','025T4ZZ') 

select distinct a.*, b.ICDProcedureDateTime, c.ICD9ProcedureCode
/*ICD9Procedure Codes*/

into Dflt.Diabetes_AF_GLP1_AbProc

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_CensusICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('37.33','37.34','37.37','37.80','38.65')
					and b.ICDProcedureDateTime <= a.GLP1Filltime
union all

select distinct a.*, b.SurgicalProcedureDateTime, c.ICD9ProcedureCode

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_CensusSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('37.33','37.34','37.37','37.80','38.65')
					and b.SurgicalProcedureDateTime <= a.GLP1Filltime
union all

select distinct a.*, b.DischargeDateTime, c.ICD9ProcedureCode

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('37.33','37.34','37.37','37.80','38.65')
					and b.DischargeDateTime <= a.GLP1Filltime
union all

select distinct a.*, b.DischargeDateTime, c.ICD9ProcedureCode

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('37.33','37.34','37.37','37.80','38.65')
					and b.DischargeDateTime <= a.GLP1Filltime
union all

/*ICD10Procedure Codes*/
select distinct a.*, b.ICDProcedureDateTime, c.ICD10ProcedureCode

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_CensusICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('02560ZZ','02563ZZ','02564ZZ',
'02570ZZ','02573ZZ','02574ZZ','02580ZZ','02583ZZ','02584ZZ','025S0ZZ','025S3ZZ','025S4ZZ','025T0ZZ','025T3ZZ','025T4ZZ')
and b.ICDProcedureDateTime <= a.GLP1Filltime
union all

select distinct a.*, b.SurgicalProcedureDateTime, c.ICD10ProcedureCode

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_CensusSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('02560ZZ','02563ZZ','02564ZZ',
'02570ZZ','02573ZZ','02574ZZ','02580ZZ','02583ZZ','02584ZZ','025S0ZZ','025S3ZZ','025S4ZZ','025T0ZZ','025T3ZZ','025T4ZZ')
and b.SurgicalProcedureDateTime <= a.GLP1Filltime
union all

select distinct a.*, b.DischargeDateTime, c.ICD10ProcedureCode

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('02560ZZ','02563ZZ','02564ZZ',
'02570ZZ','02573ZZ','02574ZZ','02580ZZ','02583ZZ','02584ZZ','025S0ZZ','025S3ZZ','025S4ZZ','025T0ZZ','025T3ZZ','025T4ZZ')
and b.DischargeDateTime <= a.GLP1Filltime
union all

select distinct a.*, b.DischargeDateTime, c.ICD10ProcedureCode

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('02560ZZ','02563ZZ','02564ZZ',
'02570ZZ','02573ZZ','02574ZZ','02580ZZ','02583ZZ','02584ZZ','025S0ZZ','025S3ZZ','025S4ZZ','025T0ZZ','025T3ZZ','025T4ZZ')
and b.DischargeDateTime <= a.GLP1Filltime

select distinct scrssn from Dflt.Diabetes_AF_GLP1_AbProc --91

/* CAD */

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.DischargeDateTime as comorbidity_Dischargedatettime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_AF_GLP1_CAD

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('411.00''411.10','411.81','411.89','413.00','413.90','414.00','414.01','414.02','414.03','414.04',
'414.05','414.06','414.20','414.30','414.40','414.80','414.90','V45.81','V45.82')
					and b.DischargeDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('411.00''411.10','411.81','411.89','413.00','413.90','414.00','414.01','414.02','414.03','414.04',
'414.05','414.06','414.20','414.30','414.40','414.80','414.90','V45.81','V45.82')
					and b.DischargeDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('411.00''411.10','411.81','411.89','413.00','413.90','414.00','414.01','414.02','414.03','414.04',
'414.05','414.06','414.20','414.30','414.40','414.80','414.90','V45.81','V45.82')
					and b.DischargeDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('411.00''411.10','411.81','411.89','413.00','413.90','414.00','414.01','414.02','414.03','414.04',
'414.05','414.06','414.20','414.30','414.40','414.80','414.90','V45.81','V45.82')
					and b.EventDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('411.00''411.10','411.81','411.89','413.00','413.90','414.00','414.01','414.02','414.03','414.04',
'414.05','414.06','414.20','414.30','414.40','414.80','414.90','V45.81','V45.82')
					and b.EventDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('411.00''411.10','411.81','411.89','413.00','413.90','414.00','414.01','414.02','414.03','414.04',
'414.05','414.06','414.20','414.30','414.40','414.80','414.90','V45.81','V45.82')
					and b.EventDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('411.00''411.10','411.81','411.89','413.00','413.90','414.00','414.01','414.02','414.03','414.04',
'414.05','414.06','414.20','414.30','414.40','414.80','414.90','V45.81','V45.82')
					and b.PatientTransferDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('411.00''411.10','411.81','411.89','413.00','413.90','414.00','414.01','414.02','414.03','414.04',
'414.05','414.06','414.20','414.30','414.40','414.80','414.90','V45.81','V45.82')
					and b.SpecialtyTransferDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('411.00''411.10','411.81','411.89','413.00','413.90','414.00','414.01','414.02','414.03','414.04',
'414.05','414.06','414.20','414.30','414.40','414.80','414.90','V45.81','V45.82')
					and b.AdmitDateTime <= a.GLP1FillTime
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I24.1','I20.0','I24.0','I24.8','I28.0','I20.8','I20.9','I25.0','I25.10','I25.810','I25.811',
'I25.82','I25.83','I25.84','I25.5','I25.9','I25.89','Z95.1','Z98.61')
and b.DischargeDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I24.1','I20.0','I24.0','I24.8','I28.0','I20.8','I20.9','I25.0','I25.10','I25.810','I25.811',
'I25.82','I25.83','I25.84','I25.5','I25.9','I25.89','Z95.1','Z98.61')
and b.DischargeDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I24.1','I20.0','I24.0','I24.8','I28.0','I20.8','I20.9','I25.0','I25.10','I25.810','I25.811',
'I25.82','I25.83','I25.84','I25.5','I25.9','I25.89','Z95.1','Z98.61')
and b.DischargeDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I24.1','I20.0','I24.0','I24.8','I28.0','I20.8','I20.9','I25.0','I25.10','I25.810','I25.811',
'I25.82','I25.83','I25.84','I25.5','I25.9','I25.89','Z95.1','Z98.61')
and b.EventDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I24.1','I20.0','I24.0','I24.8','I28.0','I20.8','I20.9','I25.0','I25.10','I25.810','I25.811',
'I25.82','I25.83','I25.84','I25.5','I25.9','I25.89','Z95.1','Z98.61')
and b.EventDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I24.1','I20.0','I24.0','I24.8','I28.0','I20.8','I20.9','I25.0','I25.10','I25.810','I25.811',
'I25.82','I25.83','I25.84','I25.5','I25.9','I25.89','Z95.1','Z98.61')
and b.EventDateTime <= a.GLP1FillTime

union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I24.1','I20.0','I24.0','I24.8','I28.0','I20.8','I20.9','I25.0','I25.10','I25.810','I25.811',
'I25.82','I25.83','I25.84','I25.5','I25.9','I25.89','Z95.1','Z98.61')
and b.PatientTransferDateTime <= a.GLP1FillTime

union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I24.1','I20.0','I24.0','I24.8','I28.0','I20.8','I20.9','I25.0','I25.10','I25.810','I25.811',
'I25.82','I25.83','I25.84','I25.5','I25.9','I25.89','Z95.1','Z98.61')
and b.SpecialtyTransferDateTime <= a.GLP1FillTime

union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I24.1','I20.0','I24.0','I24.8','I28.0','I20.8','I20.9','I25.0','I25.10','I25.810','I25.811',
'I25.82','I25.83','I25.84','I25.5','I25.9','I25.89','Z95.1','Z98.61')
and b.AdmitDateTime <= a.GLP1FillTime

select distinct scrssn from Dflt.Diabetes_AF_GLP1_CAD --1074

/* PAD */

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.DischargeDateTime as comorbidity_Dischargedatettime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_AF_GLP1_PAD

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('440.0','440.0','440.1','440.2','440.20','440.21','440.22','440.23','440.24','440.29','440.30',
                    '440.31','440.32','440.4','440.8','440.9','441.0','441.00','441.01','441.02','441.03','441.1','441.2',
					'441.3','441.4','441.5','441.6','441.7','441.9','442.0','442.1','442.2','442.3','442.81','442.82',
					'442.83','442.84','442.89','442.9','443.0','443.1','443.21','443.22','443.23','443.24','443.29')
					and b.DischargeDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('440.0','440.0','440.1','440.2','440.20','440.21','440.22','440.23','440.24','440.29','440.30',
                    '440.31','440.32','440.4','440.8','440.9','441.0','441.00','441.01','441.02','441.03','441.1','441.2',
					'441.3','441.4','441.5','441.6','441.7','441.9','442.0','442.1','442.2','442.3','442.81','442.82',
					'442.83','442.84','442.89','442.9','443.0','443.1','443.21','443.22','443.23','443.24','443.29')
					and b.DischargeDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('440.0','440.0','440.1','440.2','440.20','440.21','440.22','440.23','440.24','440.29','440.30',
                    '440.31','440.32','440.4','440.8','440.9','441.0','441.00','441.01','441.02','441.03','441.1','441.2',
					'441.3','441.4','441.5','441.6','441.7','441.9','442.0','442.1','442.2','442.3','442.81','442.82',
					'442.83','442.84','442.89','442.9','443.0','443.1','443.21','443.22','443.23','443.24','443.29')
					and b.DischargeDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('440.0','440.0','440.1','440.2','440.20','440.21','440.22','440.23','440.24','440.29','440.30',
                    '440.31','440.32','440.4','440.8','440.9','441.0','441.00','441.01','441.02','441.03','441.1','441.2',
					'441.3','441.4','441.5','441.6','441.7','441.9','442.0','442.1','442.2','442.3','442.81','442.82',
					'442.83','442.84','442.89','442.9','443.0','443.1','443.21','443.22','443.23','443.24','443.29')
					and b.EventDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('440.0','440.0','440.1','440.2','440.20','440.21','440.22','440.23','440.24','440.29','440.30',
                    '440.31','440.32','440.4','440.8','440.9','441.0','441.00','441.01','441.02','441.03','441.1','441.2',
					'441.3','441.4','441.5','441.6','441.7','441.9','442.0','442.1','442.2','442.3','442.81','442.82',
					'442.83','442.84','442.89','442.9','443.0','443.1','443.21','443.22','443.23','443.24','443.29')
					and b.EventDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('440.0','440.0','440.1','440.2','440.20','440.21','440.22','440.23','440.24','440.29','440.30',
                    '440.31','440.32','440.4','440.8','440.9','441.0','441.00','441.01','441.02','441.03','441.1','441.2',
					'441.3','441.4','441.5','441.6','441.7','441.9','442.0','442.1','442.2','442.3','442.81','442.82',
					'442.83','442.84','442.89','442.9','443.0','443.1','443.21','443.22','443.23','443.24','443.29')
					and b.EventDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('440.0','440.0','440.1','440.2','440.20','440.21','440.22','440.23','440.24','440.29','440.30',
                    '440.31','440.32','440.4','440.8','440.9','441.0','441.00','441.01','441.02','441.03','441.1','441.2',
					'441.3','441.4','441.5','441.6','441.7','441.9','442.0','442.1','442.2','442.3','442.81','442.82',
					'442.83','442.84','442.89','442.9','443.0','443.1','443.21','443.22','443.23','443.24','443.29')
					and b.PatientTransferDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('440.0','440.0','440.1','440.2','440.20','440.21','440.22','440.23','440.24','440.29','440.30',
                    '440.31','440.32','440.4','440.8','440.9','441.0','441.00','441.01','441.02','441.03','441.1','441.2',
					'441.3','441.4','441.5','441.6','441.7','441.9','442.0','442.1','442.2','442.3','442.81','442.82',
					'442.83','442.84','442.89','442.9','443.0','443.1','443.21','443.22','443.23','443.24','443.29')
					and b.SpecialtyTransferDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('440.0','440.0','440.1','440.2','440.20','440.21','440.22','440.23','440.24','440.29','440.30',
                    '440.31','440.32','440.4','440.8','440.9','441.0','441.00','441.01','441.02','441.03','441.1','441.2',
					'441.3','441.4','441.5','441.6','441.7','441.9','442.0','442.1','442.2','442.3','442.81','442.82',
					'442.83','442.84','442.89','442.9','443.0','443.1','443.21','443.22','443.23','443.24','443.29')
					and b.AdmitDateTime <= a.GLP1FillTime
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I70.0','I70.1','I70.209','I70.219','I70.229','I70.25','I70.269','I70.299','I70.399','I70.499','I70.599','I70.92','I70.8','I70.90',
                    'I71.00','I71.01','I71.02','I71.03','I71.1','I71.2','I71.3','I71.4','I71.5','I71.6','I71.8','I71.9','I72.0','I72.1','I72.2','I72.3',
					'I72.4','I72.5','I72.6','I72.8','I72.9','I73.00','I73.01','I73.1','I73.81','I73.89','I73.9','I77.1','I77.71','I77.72','I77.73','I77.74',
					'I77.75','I77.76','I77.77','I77.79','I79.8','K55.1','K55.9','Z95.828')
and b.DischargeDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I70.0','I70.1','I70.209','I70.219','I70.229','I70.25','I70.269','I70.299','I70.399','I70.499','I70.599','I70.92','I70.8','I70.90',
                    'I71.00','I71.01','I71.02','I71.03','I71.1','I71.2','I71.3','I71.4','I71.5','I71.6','I71.8','I71.9','I72.0','I72.1','I72.2','I72.3',
					'I72.4','I72.5','I72.6','I72.8','I72.9','I73.00','I73.01','I73.1','I73.81','I73.89','I73.9','I77.1','I77.71','I77.72','I77.73','I77.74',
					'I77.75','I77.76','I77.77','I77.79','I79.8','K55.1','K55.9','Z95.828')
and b.DischargeDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I70.0','I70.1','I70.209','I70.219','I70.229','I70.25','I70.269','I70.299','I70.399','I70.499','I70.599','I70.92','I70.8','I70.90',
                    'I71.00','I71.01','I71.02','I71.03','I71.1','I71.2','I71.3','I71.4','I71.5','I71.6','I71.8','I71.9','I72.0','I72.1','I72.2','I72.3',
					'I72.4','I72.5','I72.6','I72.8','I72.9','I73.00','I73.01','I73.1','I73.81','I73.89','I73.9','I77.1','I77.71','I77.72','I77.73','I77.74',
					'I77.75','I77.76','I77.77','I77.79','I79.8','K55.1','K55.9','Z95.828')
and b.DischargeDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I70.0','I70.1','I70.209','I70.219','I70.229','I70.25','I70.269','I70.299','I70.399','I70.499','I70.599','I70.92','I70.8','I70.90',
                    'I71.00','I71.01','I71.02','I71.03','I71.1','I71.2','I71.3','I71.4','I71.5','I71.6','I71.8','I71.9','I72.0','I72.1','I72.2','I72.3',
					'I72.4','I72.5','I72.6','I72.8','I72.9','I73.00','I73.01','I73.1','I73.81','I73.89','I73.9','I77.1','I77.71','I77.72','I77.73','I77.74',
					'I77.75','I77.76','I77.77','I77.79','I79.8','K55.1','K55.9','Z95.828')
and b.EventDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I70.0','I70.1','I70.209','I70.219','I70.229','I70.25','I70.269','I70.299','I70.399','I70.499','I70.599','I70.92','I70.8','I70.90',
                    'I71.00','I71.01','I71.02','I71.03','I71.1','I71.2','I71.3','I71.4','I71.5','I71.6','I71.8','I71.9','I72.0','I72.1','I72.2','I72.3',
					'I72.4','I72.5','I72.6','I72.8','I72.9','I73.00','I73.01','I73.1','I73.81','I73.89','I73.9','I77.1','I77.71','I77.72','I77.73','I77.74',
					'I77.75','I77.76','I77.77','I77.79','I79.8','K55.1','K55.9','Z95.828')
and b.EventDateTime <= a.GLP1FillTime
union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I70.0','I70.1','I70.209','I70.219','I70.229','I70.25','I70.269','I70.299','I70.399','I70.499','I70.599','I70.92','I70.8','I70.90',
                    'I71.00','I71.01','I71.02','I71.03','I71.1','I71.2','I71.3','I71.4','I71.5','I71.6','I71.8','I71.9','I72.0','I72.1','I72.2','I72.3',
					'I72.4','I72.5','I72.6','I72.8','I72.9','I73.00','I73.01','I73.1','I73.81','I73.89','I73.9','I77.1','I77.71','I77.72','I77.73','I77.74',
					'I77.75','I77.76','I77.77','I77.79','I79.8','K55.1','K55.9','Z95.828')
and b.EventDateTime <= a.GLP1FillTime

union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I70.0','I70.1','I70.209','I70.219','I70.229','I70.25','I70.269','I70.299','I70.399','I70.499','I70.599','I70.92','I70.8','I70.90',
                    'I71.00','I71.01','I71.02','I71.03','I71.1','I71.2','I71.3','I71.4','I71.5','I71.6','I71.8','I71.9','I72.0','I72.1','I72.2','I72.3',
					'I72.4','I72.5','I72.6','I72.8','I72.9','I73.00','I73.01','I73.1','I73.81','I73.89','I73.9','I77.1','I77.71','I77.72','I77.73','I77.74',
					'I77.75','I77.76','I77.77','I77.79','I79.8','K55.1','K55.9','Z95.828')
and b.PatientTransferDateTime <= a.GLP1FillTime

union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I70.0','I70.1','I70.209','I70.219','I70.229','I70.25','I70.269','I70.299','I70.399','I70.499','I70.599','I70.92','I70.8','I70.90',
                    'I71.00','I71.01','I71.02','I71.03','I71.1','I71.2','I71.3','I71.4','I71.5','I71.6','I71.8','I71.9','I72.0','I72.1','I72.2','I72.3',
					'I72.4','I72.5','I72.6','I72.8','I72.9','I73.00','I73.01','I73.1','I73.81','I73.89','I73.9','I77.1','I77.71','I77.72','I77.73','I77.74',
					'I77.75','I77.76','I77.77','I77.79','I79.8','K55.1','K55.9','Z95.828')
and b.SpecialtyTransferDateTime <= a.GLP1FillTime

union all

select distinct a.patientsid, a.scrssn, a.GLP1FillTime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I70.0','I70.1','I70.209','I70.219','I70.229','I70.25','I70.269','I70.299','I70.399','I70.499','I70.599','I70.92','I70.8','I70.90',
                    'I71.00','I71.01','I71.02','I71.03','I71.1','I71.2','I71.3','I71.4','I71.5','I71.6','I71.8','I71.9','I72.0','I72.1','I72.2','I72.3',
					'I72.4','I72.5','I72.6','I72.8','I72.9','I73.00','I73.01','I73.1','I73.81','I73.89','I73.9','I77.1','I77.71','I77.72','I77.73','I77.74',
					'I77.75','I77.76','I77.77','I77.79','I79.8','K55.1','K55.9','Z95.828')
and b.AdmitDateTime <= a.GLP1FillTime

select distinct scrssn from Dflt.Diabetes_AF_GLP1_PAD --284

/*Cardioversion*/

/*Making sure the CPT codes relevant to Cardioversion are present in the Dimension table under CDWWork*/

select distinct CPTCode from CDWWork.Dim.CPT where CPTCode in ('92960','92961')

select distinct a.*

into Dflt.Diabetes_AF_GLP1_Cardioversion

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientCPTProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
Src.Cohort_CPT as c with (NOLOCK) on c.CPTSID=b.cptSID 
where c.cptcode in ('92960','92961')
union all

select distinct a.*
from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_Vprocedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
Src.Cohort_CPT as c with (NOLOCK) on c.CPTSID=b.cptSID 
where c.cptcode in ('92960','92961')
union all 

select distinct a.*
from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_VProcedure_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
Src.Cohort_CPT as c with (NOLOCK) on c.CPTSID=b.cptSID 
where c.cptcode in ('92960','92961')
union all

select distinct a.*
from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Surg_SurgeryPrincipalAssociatedProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on b.OtherProcedureCPTSID=c.cptSID 
where c.cptcode in ('92960','92961')
union all

select distinct a.*
from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Surg_SurgeryProcedureDiagnosisCode as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on b.PrincipalCPTSID=c.cptSID 
where c.cptcode in ('92960','92961')
union all

select distinct a.*
from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_VProcedureCPTModifier as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on b.CPTSID=c.cptSID 
where c.cptcode in ('92960','92961')
union all

select distinct a.*
from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_VProcedureDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on b.CPTSID=c.cptSID 
where c.cptcode in ('92960','92961')
union all

select distinct a.*
from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on b.CPTSID=c.cptSID 
where c.cptcode in ('92960','92961')
union all

select distinct a.*
from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVProcedureCPTModifier as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on  b.CPTSID=c.cptSID 
where c.cptcode in ('92960','92961')

drop table Dflt.Diabetes_AF_GLP1_Cardioversion

/* Cardioversion Proc codes */

select distinct ICD9ProcedureCode from CDWWork.Dim.ICD9Procedure where ICD9ProcedureCode in ('99.61','99.62') 
select distinct ICD10ProcedureCode from CDWWork.Dim.ICD10Procedure where ICD10ProcedureCode in ('5A2204Z') 

select distinct a.*, b.ICDProcedureDateTime, c.ICD9ProcedureCode
/*ICD9Procedure Codes*/

into Dflt.Diabetes_AF_GLP1_Cardioversion

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_CensusICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('99.61','99.62')
					and b.ICDProcedureDateTime <= a.GLP1Filltime
union all

select distinct a.*, b.SurgicalProcedureDateTime, c.ICD9ProcedureCode

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_CensusSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('99.61','99.62')
					and b.SurgicalProcedureDateTime <= a.GLP1Filltime
union all

select distinct a.*, b.DischargeDateTime, c.ICD9ProcedureCode

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('99.61','99.62')
					and b.DischargeDateTime <= a.GLP1Filltime
union all

select distinct a.*, b.DischargeDateTime, c.ICD9ProcedureCode

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('99.61','99.62')
					and b.DischargeDateTime <= a.GLP1Filltime
union all

/*ICD10Procedure Codes*/
select distinct a.*, b.ICDProcedureDateTime, c.ICD10ProcedureCode

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_CensusICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('5A2204Z')
and b.ICDProcedureDateTime <= a.GLP1Filltime
union all

select distinct a.*, b.SurgicalProcedureDateTime, c.ICD10ProcedureCode

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_CensusSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('5A2204Z')
and b.SurgicalProcedureDateTime <= a.GLP1Filltime
union all

select distinct a.*, b.DischargeDateTime, c.ICD10ProcedureCode

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('5A2204Z')
and b.DischargeDateTime <= a.GLP1Filltime
union all

select distinct a.*, b.DischargeDateTime, c.ICD10ProcedureCode

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('5A2204Z')
and b.DischargeDateTime <= a.GLP1Filltime

select distinct scrssn from Dflt.Diabetes_AF_GLP1_Cardioversion --216

/* Heart Failure */
/* Making sure the codes are available in the CDWWork Dimension table */

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')-- 150.00 is not available

select distinct a.PatientSID,a.ScrSSN, a.AF_Dischargedatetime, b.DischargeDateTime as comorbidity_Dischargedatetime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_AF_GLP1_HF

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')
					and b.DischargeDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.PatientSID,a.ScrSSN, a.AF_Dischargedatetime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')
					and b.DischargeDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.PatientSID,a.ScrSSN, a.AF_Dischargedatetime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')
					and b.DischargeDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.PatientSID,a.ScrSSN, a.AF_Dischargedatetime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')
					and b.EventDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.PatientSID,a.ScrSSN, a.AF_Dischargedatetime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')
					and b.EventDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.PatientSID,a.ScrSSN, a.AF_Dischargedatetime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')
					and b.EventDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.PatientSID,a.ScrSSN, a.AF_Dischargedatetime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')
					and b.PatientTransferDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.PatientSID,a.ScrSSN, a.AF_Dischargedatetime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')
					and b.SpecialtyTransferDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.PatientSID,a.ScrSSN, a.AF_Dischargedatetime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')
					and b.AdmitDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

/*ICD10 Codes*/
select distinct a.PatientSID,a.ScrSSN, a.AF_Dischargedatetime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')
and b.DischargeDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.PatientSID,a.ScrSSN, a.AF_Dischargedatetime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')
and b.DischargeDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.PatientSID,a.ScrSSN, a.AF_Dischargedatetime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')
and b.DischargeDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.PatientSID,a.ScrSSN, a.AF_Dischargedatetime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')
and b.EventDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.PatientSID,a.ScrSSN, a.AF_Dischargedatetime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')
and b.EventDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)
union all

select distinct a.PatientSID,a.ScrSSN, a.AF_Dischargedatetime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')
and b.EventDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)

union all

select distinct a.PatientSID,a.ScrSSN, a.AF_Dischargedatetime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')
and b.PatientTransferDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)

union all

select distinct a.PatientSID,a.ScrSSN, a.AF_Dischargedatetime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')
and b.SpecialtyTransferDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)

union all

select distinct a.PatientSID,a.ScrSSN, a.AF_Dischargedatetime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')
and b.AdmitDateTime between dateadd(month, -12, a.GLP1FillTime) and dateadd(day, 1, a.GLP1FillTime)

select distinct scrssn from Dflt.Diabetes_AF_GLP1_HF --749

/* Laboratory Variables */

/* HBA1C */
/* Check for the labchemtestname in the dimension table */
select distinct labchemtestname from CDWWork.Dim.Labchemtest 
where LabChemTestName like '%A1C%' AND
	LabChemTestName not like '%ZZ%' AND
	LabChemTestName not like '%XX%'

/* Current VA phenomics library is updated and shows only %A1C% */

select b.*, a.LabChemResultValue, a.LabChemResultNumericValue, a.LabChemCompleteDateTime,c.LabChemTestName

into Dflt.Diabetes_AF_GLP1_hba1c

from Src.Chem_LabChem as a with (NOLOCK) inner join
Dflt.Diabetes_AF_GLP1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
where c.LabChemTestName like '%A1C%' AND
	c.LabChemTestName not like '%ZZ%' AND
	c.LabChemTestName not like '%XX%'
and a.LabChemCompleteDateTime between dateadd(month, -6, b.GLP1FillTime) and dateadd(day, 1, b.GLP1FillTime)                                
union all

select b.*, a.LabChemResultValue, a.LabChemResultNumericValue,a.LabChemCompleteDateTime,c.LabChemTestName

from Src.Chem_LabChem_Recent as a with (NOLOCK) inner join
Dflt.Diabetes_AF_GLP1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
where c.LabChemTestName like '%A1C%' AND
	c.LabChemTestName not like '%ZZ%' AND
	c.LabChemTestName not like '%XX%'
and a.LabChemCompleteDateTime between dateadd(month, -6, b.GLP1FillTime) and dateadd(day, 1, b.GLP1FillTime)  
union all

select b.*, a.LabChemResultValue, a.LabChemResultNumericValue, a.LabChemCompleteDateTime, c.LabChemTestName

from Src.Chem_PatientLabChem as a with (NOLOCK) inner join
Dflt.Diabetes_AF_GLP1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
where c.LabChemTestName like '%A1C%' AND
	c.LabChemTestName not like '%ZZ%' AND
	c.LabChemTestName not like '%XX%'
and a.LabChemCompleteDateTime between dateadd(month, -6, GLP1FillTime) and dateadd(day, 1, GLP1FillTime)

select distinct scrssn from Dflt.Diabetes_AF_GLP1_hba1c --1355

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

select distinct b.PatientSID, b.ScrSSN, b.GLP1Filltime, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

into #tempCreatinine

from Src.Chem_LabChem as a with (NOLOCK) inner join
Dflt.Diabetes_AF_GLP1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
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

select distinct b.PatientSID, b.ScrSSN, b.GLP1Filltime, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

from Src.Chem_LabChem_Recent as a with (NOLOCK) inner join
Dflt.Diabetes_AF_GLP1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
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

select distinct b.PatientSID, b.ScrSSN, b.GLP1Filltime, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

from Src.Chem_PatientLabChem as a with (NOLOCK) inner join
Dflt.Diabetes_AF_GLP1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
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
into Dflt.Diabetes_AF_GLP1_Creatinine
from #tempCreatinine
where LabChemCompleteDateTime between dateadd(month, -6, GLP1FillTime) and dateadd(day, 1, GLP1FillTime)

select distinct scrssn from Dflt.Diabetes_AF_GLP1_Creatinine --1468

drop table Dflt.Diabetes_AF_GLP1_Creatinine
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
Dflt.Diabetes_AF_GLP1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
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
Dflt.Diabetes_AF_GLP1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
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
Dflt.Diabetes_AF_GLP1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
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
into Dflt.Diabetes_AF_GLP1_Hemoglobin
from #temphemoglobin
where LabChemCompleteDateTime between dateadd(month, -6, GLP1FillTime) and dateadd(day, 1, GLP1FillTime)

select distinct scrssn from Dflt.Diabetes_AF_GLP1_Hemoglobin --1387

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
Dflt.Diabetes_AF_GLP1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
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
Dflt.Diabetes_AF_GLP1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
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
Dflt.Diabetes_AF_GLP1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE 
   (labchemtestname like '%BNP%' or  
	labchemtestname  like '%brain natriuretic peptide%' or 
	labchemtestname  like '%natriu%pept%') and
	LabChemTestName not like '%ratio%' AND
	LabChemTestName not like '%pro%'
	
select *
into Dflt.Diabetes_AF_GLP1_BNP
from #tempBNP
where LabChemCompleteDateTime between dateadd(month, -6, GLP1FillTime) and dateadd(day, 1, GLP1FillTime)

select distinct scrssn from Dflt.Diabetes_AF_GLP1_BNP--395

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
Dflt.Diabetes_AF_GLP1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
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
Dflt.Diabetes_AF_GLP1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
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
Dflt.Diabetes_AF_GLP1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
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
into Dflt.Diabetes_AF_GLP1_PBNP
from #tempPBNP
where LabChemCompleteDateTime between dateadd(month, -6, GLP1FillTime) and dateadd(day, 1, GLP1FillTime)

select distinct scrssn from Dflt.Diabetes_AF_GLP1_PBNP --608
 
/* prior HF Hospitalization using dishcarge diagnosis table only */

select distinct a.*, b.AdmitDateTime

into Dflt.AF_GLP1_priorHFHospi

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_Inpatient as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.PrincipalDiagnosisICD9SID=c.ICD9SID 
where c.ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')
					and b.AdmitDateTime between dateadd(year, -10, a.GLP1FillTime) and a.GLP1FillTime

union all

select distinct a.*, b.AdmitDateTime

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_Inpatient_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.PrincipalDiagnosisICD10SID=c.ICD10SID 
where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')
and b.AdmitDateTime between dateadd(year, -10, a.GLP1FillTime) and a.GLP1FillTime

select distinct scrssn from Dflt.AF_GLP1_priorHFHospi --262

/* Before EF value */

select distinct a.*, b.Low_Value, b.ValueDateTime

into Dflt.Diabetes_AF_GLP1_EFBefore

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join 
Src.VINCI_TIU_NLP_LVEF as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where b.ValueDateTime <=a.glp1filltime --between dateadd(month, -12, a.GLP1FillTime) and a.glp1filltime

select distinct scrssn from Dflt.Diabetes_AF_GLP1_EFBefore --1482

/* After EF value */

select distinct a.*, b.Low_Value, b.ValueDateTime

into Dflt.Diabetes_AF_GLP1_EFAfter

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join 
Src.VINCI_TIU_NLP_LVEF as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where b.ValueDateTime > a.glp1filltime --between dateadd(month, -12, a.GLP1FillTime) and a.glp1filltime

select distinct scrssn from Dflt.Diabetes_AF_GLP1_EFAfter --1368

/* Medications */
select distinct a.PatientSID, a.ScrSSN, a.GLP1FillTime, b.FillDateTime, b.LocalDrugNameWithDose, b.FillNumber, b.DaysSupply, b.Qty

into #tempMedications

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where b.FillDateTime between dateadd(month, -6, a.GLP1FillTime) and a.GLP1FillTime and 
b.FillNumber > '1'
union all

select distinct a.PatientSID, a.ScrSSN, a.GLP1FillTime, b.FillDateTime, b.LocalDrugNameWithDose, b.FillNumber, b.DaysSupply, b.Qty

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where b.FillDateTime between dateadd(month, -6, a.GLP1FillTime) and a.GLP1FillTime and 
b.FillNumber > '1'

select distinct scrssn from #tempMedications --1476

/* Sacubitril and Valsartan */

select distinct * 

into Dflt.Diabetes_AF_GLP1_SacuVal

from #tempMedications
where LocalDrugNameWithDose like '%sacubitril%' and LocalDrugNameWithDose like '%valsartan%' 
union all

select distinct *
from #tempMedications
where LocalDrugNameWithDose like '%sacubitril%'

select * from Dflt.Diabetes_AF_GLP1_SacuVal

Select distinct scrssn from Dflt.Diabetes_AF_GLP1_SacuVal --19

/* Beta Blockers */
/* Check for the LocalDrugNameWithDose in the dimension table */
select * from CDWWork.Dim.LocalDrug where LocalDrugNameWithDose like '%metoprolol%' or LocalDrugNameWithDose like '%carvedilol%' or LocalDrugNameWithDose like '%bisoprolol%' or
		LocalDrugNameWithDose like '%nebivolol%' or LocalDrugNameWithDose like '%atenolol%'

select distinct *

into Dflt.Diabetes_AF_GLP1_BB

from #tempMedications where LocalDrugNameWithDose like '%metoprolol%' or LocalDrugNameWithDose like '%carvedilol%' or LocalDrugNameWithDose like '%bisoprolol%' or
		LocalDrugNameWithDose like '%nebivolol%' or LocalDrugNameWithDose like '%atenolol%'

select distinct scrssn from Dflt.Diabetes_AF_GLP1_BB--609

/* ACE Inhibitor */
/* Check for the LocalDrugNameWithDose in the dimension table */
select * from CDWWork.Dim.LocalDrug where LocalDrugNameWithDose like '%lisinopril%' or LocalDrugNameWithDose like '%Fosinopril%' or LocalDrugNameWithDose like '%ramipril%' or
		LocalDrugNameWithDose like '%quinapril%' or LocalDrugNameWithDose like '%benazepril%'

select distinct *

into Dflt.Diabetes_AF_GLP1_ACE

from #tempMedications where LocalDrugNameWithDose like '%lisinopril%' or LocalDrugNameWithDose like '%Fosinopril%' or LocalDrugNameWithDose like '%ramipril%' or
		LocalDrugNameWithDose like '%quinapril%' or LocalDrugNameWithDose like '%benazepril%'

select distinct scrssn from Dflt.Diabetes_AF_GLP1_ACE--276

/*ARB Inhibitor */
/* Check for the LocalDrugNameWithDose in the dimension table */
select * from CDWWork.Dim.LocalDrug where LocalDrugNameWithDose like '%valsartan%' or LocalDrugNameWithDose like '%losartan%' or LocalDrugNameWithDose like '%candesartan%' or
		LocalDrugNameWithDose like '%Olmesartan%' or LocalDrugNameWithDose like '%telmisartan%' or LocalDrugNameWithDose like '%irbesartan%' 

select distinct *

into Dflt.Diabetes_AF_GLP1_ARB

from #tempMedications where LocalDrugNameWithDose like '%valsartan%' or LocalDrugNameWithDose like '%losartan%' or LocalDrugNameWithDose like '%candesartan%' or
		LocalDrugNameWithDose like '%Olmesartan%' or LocalDrugNameWithDose like '%telmisartan%' or LocalDrugNameWithDose like '%irbesartan%' 

select distinct scrssn from Dflt.Diabetes_AF_GLP1_ARB --273

/* ACE and ARB */

select distinct * 

into Dflt.Diabetes_AF_GLP1_ACEARB

from Dflt.Diabetes_AF_GLP1_ACE 
union all

select distinct *

from Dflt.Diabetes_AF_GLP1_ARB

select distinct scrssn from Dflt.Diabetes_AF_GLP1_ACEARB --548

/* Spironolactone/Eplerenone */
/* Check for the LocalDrugNameWithDose in the dimension table */
select * from CDWWork.Dim.LocalDrug where LocalDrugNameWithDose like '%spironolactone%' or LocalDrugNameWithDose like '%Eplerenone%'

select distinct *

into Dflt.Diabetes_AF_GLP1_SpiroEp

from #tempMedications where LocalDrugNameWithDose like '%spironolactone%' or LocalDrugNameWithDose like '%Eplerenone%'

select distinct scrssn from Dflt.Diabetes_AF_GLP1_SpiroEp --177

/* Loop Diuretic */
/* Check for the LocalDrugNameWithDose in the dimension table */
select * from CDWWork.Dim.LocalDrug where LocalDrugNameWithDose like '%furosemide%' or LocalDrugNameWithDose like '%torsemide%' or LocalDrugNameWithDose like '%bumetanide%' or
		LocalDrugNameWithDose like '%Ethacrynic acid%' or LocalDrugNameWithDose like '%lasix%' or LocalDrugNameWithDose like '%bumex%'

select distinct a.PatientSID, a.ScrSSN, a.GLP1FillTime, b.FillDateTime, b.LocalDrugNameWithDose, b.FillNumber, b.DaysSupply, b.Qty

into #tempMedicationsLoop

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill as b with (NOLOCK) on a.PatientSID= b.PatientSID
where LocalDrugNameWithDose like '%furosemide%' or LocalDrugNameWithDose like '%torsemide%' or LocalDrugNameWithDose like '%bumetanide%' or
		LocalDrugNameWithDose like '%Ethacrynic acid%' or LocalDrugNameWithDose like '%lasix%' or LocalDrugNameWithDose like '%bumex%'
union all

select distinct a.PatientSID, a.ScrSSN, a.GLP1FillTime, b.FillDateTime, b.LocalDrugNameWithDose, b.FillNumber, b.DaysSupply, b.Qty

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where LocalDrugNameWithDose like '%furosemide%' or LocalDrugNameWithDose like '%torsemide%' or LocalDrugNameWithDose like '%bumetanide%' or
		LocalDrugNameWithDose like '%Ethacrynic acid%' or LocalDrugNameWithDose like '%lasix%' or LocalDrugNameWithDose like '%bumex%'

select distinct *

into Dflt.Diabetes_AF_GLP1_LoopDiuretic

from #tempMedicationsloop 

where FillDateTime between dateadd(month, -12, GLP1FillTime) and dateadd(month, 12, GLP1FillTime) and FillNumber > '1'

select distinct scrssn from Dflt.Diabetes_AF_GLP1_LoopDiuretic--867

drop table Dflt.Diabetes_AF_GLP1_LoopDiuretic
/* Insulin */
/* Check for the LocalDrugNameWithDose in the dimension table */
select * from CDWWork.Dim.LocalDrug where LocalDrugNameWithDose like '%insulin%' 

select distinct *

into Dflt.Diabetes_AF_GLP1_Insulin

from #tempMedications where LocalDrugNameWithDose like '%insulin%' 

select distinct scrssn from Dflt.Diabetes_AF_GLP1_Insulin --769

/* SGLT2 Analogue */
drop table Dflt.Diabetes_AF_GLP1_SGLT2
select distinct LocalDrugNameWithDose from CDWWork.Dim.LocalDrug 
where LocalDrugNameWithDose like '%empagliflozin%' 
or LocalDrugNameWithDose like '%dapagliflozin%' 
or LocalDrugNameWithDose like '%canagliflozin%' 
or LocalDrugNameWithDose like '%ertugliflozin%' 

select distinct *

into Dflt.Diabetes_AF_GLP1_SGLT2

from #tempMedications where LocalDrugNameWithDose like '%empagliflozin%' 
or LocalDrugNameWithDose like '%dapagliflozin%' 
or LocalDrugNameWithDose like '%canagliflozin%' 
or LocalDrugNameWithDose like '%ertugliflozin%' 

select distinct scrssn from Dflt.Diabetes_AF_GLP1_SGLT2 --166

/* DPP4 I */

select distinct LocalDrugNameWithDose from CDWWork.Dim.LocalDrug where LocalDrugNameWithDose like '%gliptin%'

select distinct *

into Dflt.Diabetes_AF_GLP1_DPP4

from #tempMedications where LocalDrugNameWithDose like '%gliptin%'

select distinct scrssn from Dflt.Diabetes_AF_GLP1_DPP4 --0

drop table  Dflt.Diabetes_AF_GLP1_DPP4

/* Metformin */

select * from CDWWork.Dim.LocalDrug where LocalDrugNameWithDose like '%metformin%' 

select distinct *

into Dflt.Diabetes_AF_GLP1_Metformin

from #tempMedications where LocalDrugNameWithDose like '%metformin%' 

select distinct scrssn from Dflt.Diabetes_AF_GLP1_Metformin --324

/* Sulfonylurea */
select distinct LocalDrugNameWithDose from CDWWork.Dim.LocalDrug where LocalDrugNameWithDose like '%Glipizide%' or
			  LocalDrugNameWithDose like '%Glimepiride%' or
			  LocalDrugNameWithDose like '%Glyburide%' or
			  LocalDrugNameWithDose like '%Tolbutamide%' 

select distinct *

into Dflt.Diabetes_AF_GLP1_Sulfonylurea

from #tempMedications where LocalDrugNameWithDose like '%Glipizide%' or
			  LocalDrugNameWithDose like '%Glimepiride%' or
			  LocalDrugNameWithDose like '%Glyburide%' or
			  LocalDrugNameWithDose like '%Tolbutamide%' 

select distinct scrssn from Dflt.Diabetes_AF_GLP1_Sulfonylurea --0

drop table Dflt.Diabetes_AF_GLP1_Sulfonylurea

/* Thiazoldiandione- check */

select distinct LocalDrugNameWithDose from CDWWork.Dim.LocalDrug where LocalDrugNameWithDose like '%pioglitazone%' 
or LocalDrugNameWithDose like '%rosiglitazone%'

select distinct *

into Dflt.Diabetes_AF_GLP1_Thiazol

from #tempMedications where LocalDrugNameWithDose like '%pioglitazone%' 
or LocalDrugNameWithDose like '%rosiglitazone%'

select distinct scrssn from Dflt.Diabetes_AF_GLP1_Thiazol --11

/* Anti-Arrythmia Drugs */

select distinct LocalDrugNameWithDose from CDWWork.Dim.LocalDrug where LocalDrugNameWithDose like '%soltalol%' 
or LocalDrugNameWithDose like '%Dofetilide%' 
or LocalDrugNameWithDose like '%flecainide%' 
or LocalDrugNameWithDose like '%propafenone%' 
or LocalDrugNameWithDose like '%amiodarone%' 
or LocalDrugNameWithDose like '%dronaderone%'
or LocalDrugNameWithDose like '%digoxin%'

select distinct *

into Dflt.Diabetes_AF_GLP1_AntiArr

from #tempMedications where LocalDrugNameWithDose like '%soltalol%' 
or LocalDrugNameWithDose like '%Dofetilide%' 
or LocalDrugNameWithDose like '%flecainide%' 
or LocalDrugNameWithDose like '%propafenone%' 
or LocalDrugNameWithDose like '%amiodarone%' 
or LocalDrugNameWithDose like '%dronaderone%'
or LocalDrugNameWithDose like '%digoxin%'

select distinct scrssn from Dflt.Diabetes_AF_GLP1_AntiArr --282

//** After the drug initiation - Extraction **//

/* All HF hospitalization after GLP1 initiation using only inpatient tables */

select distinct a.PatientSID,a.ScrSSN,  a.GLP1FillTime, b.AdmitDateTime, b.Admitdiagnosis, c.ICD9Code

into Dflt.AF_GLP1_HFHospitalization

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_Inpatient as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.PrincipalDiagnosisICD9SID=c.ICD9SID 
where c.ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')
					and b.DischargeDateTime >= a.GLP1FillTime
union all

/*ICD10 Codes*/

select distinct a.PatientSID,a.ScrSSN,  a.GLP1FillTime, b.AdmitDateTime, b.AdmitDiagnosis, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_Inpatient as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.PrincipalDiagnosisICD10SID=c.ICD10SID 
where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')
and b.DischargeDateTime >= a.GLP1FillTime

select distinct scrssn from Dflt.AF_GLP1_HFHospitalization --354

select * from Dflt.AF_GLP1_HFHospitalization

/* Atrial Fibrillation */

select distinct a.PatientSID,a.ScrSSN,  a.GLP1FillTime, b.AdmitDateTime, b.Admitdiagnosis, c.ICD9Code

into Dflt.Diabetes_AF_GLP1_AFAfter

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_Inpatient as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.PrincipalDiagnosisICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
					and b.DischargeDateTime >= a.GLP1FillTime
union all

/*ICD10 Codes*/

select distinct a.PatientSID,a.ScrSSN,  a.GLP1FillTime, b.AdmitDateTime, b.AdmitDiagnosis, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_Inpatient as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.PrincipalDiagnosisICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.DischargeDateTime >= a.GLP1FillTime

select distinct scrssn from Dflt.Diabetes_AF_GLP1_AFAfter --165


/* All hospitalization after GLP1 initiation using only inpatient tables */

select distinct a.*, b.DischargeDateTime,c.ICD9Code
/*ICD9 Codes*/

into Dflt.AF_GLP1_AllHospitalization

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where b.DischargeDateTime >= a.GLP1FillTime
union all

select distinct a.*, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where b.DischargeDateTime >= a.GLP1FillTime
union all

select distinct a.*, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where b.DischargeDateTime >= a.GLP1FillTime
union all

select distinct a.*, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where b.PatientTransferDateTime >= a.GLP1FillTime
union all

select distinct a.*, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where b.SpecialtyTransferDateTime >= a.GLP1FillTime
union all

select distinct a.*, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where b.AdmitDateTime >= a.GLP1FillTime
union all

/*ICD10 Codes*/
select distinct a.*, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where  b.DischargeDateTime >= a.GLP1FillTime
union all

select distinct a.*, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where b.DischargeDateTime >= a.GLP1FillTime
union all

select distinct a.*, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where b.DischargeDateTime >= a.GLP1FillTime
union all

select distinct a.*, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where b.PatientTransferDateTime >= a.GLP1FillTime

union all

select distinct a.*, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where b.SpecialtyTransferDateTime >= a.GLP1FillTime
union all

select distinct a.*, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where  b.AdmitDateTime >= a.GLP1FillTime

select distinct scrssn from Dflt.AF_GLP1_AllHospitalization--1087

/* Use only Discharge diagnosis table to identify all hospitalization events - GLP1 */

select distinct a.*, b.AdmitDateTime,c.ICD9Code

into Dflt.AF_GLP1_AllDDHospi

/*ICD9 Code */

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where b.AdmitDateTime >= a.GLP1FillTime

union all
/*ICD10 Code */

select distinct a.*, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where b.AdmitDateTime >= a.GLP1FillTime

select distinct scrssn from Dflt.AF_GLP1_AllDDHospi --934


/* Patients that started on DPP4 after GLP1 initiation */

select distinct a.*,  b.FillNumber as DPP4FillNumber

into #tempGLP1DPP4

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where b.LocalDrugNameWithDose like '%gliptin%' 
and b.FillDateTime >= a.GLP1FillTime
union all

select distinct a.*, b.FillNumber as DPP4FillNumber

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where b.LocalDrugNameWithDose like '%gliptin%' 
and b.FillDateTime >= a.GLP1FillTime

select distinct scrssn 

into Dflt.AF_GLP1DPP4 

from #tempGLP1DPP4 where DPP4FillNumber >=3

select distinct scrssn from Dflt.AF_GLP1DPP4 --26

select * from Dflt.AF_GLP1DPP4 

/* Patients that started on GLP1 after DPP4 initiation */

select distinct a.*,  b.FillNumber as GLP1FillNumber

into #DPP4GLP1

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where LocalDrugNameWithDose like '%empagliflozin%' 
or LocalDrugNameWithDose like '%dapagliflozin%' 
or LocalDrugNameWithDose like '%canagliflozin%' 
or LocalDrugNameWithDose like '%ertugliflozin%' 
union all

select distinct a.*, b.FillNumber as GLP1FillNumber

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where LocalDrugNameWithDose like '%empagliflozin%' 
or LocalDrugNameWithDose like '%dapagliflozin%' 
or LocalDrugNameWithDose like '%canagliflozin%' 
or LocalDrugNameWithDose like '%ertugliflozin%'

select distinct *
into Dflt.AF_DPP4_GLP1
from #DPP4GLP1 where 
FillDateTime >= DPP4FillTime
and GLP1FillNumber >=3

select distinct scrssn from Dflt.AF_DPP4_GLP1 --266

/* SGLT2 after initiation of GLP1 - refill at least 3 */

select distinct a.*, b.FillNumber as GLP1FillNumber

into #GLP1SGLT2

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where LocalDrugNameWithDose like '%empagliflozin%' 
or LocalDrugNameWithDose like '%dapagliflozin%' 
or LocalDrugNameWithDose like '%canagliflozin%' 
or LocalDrugNameWithDose like '%ertugliflozin%' 
--and b.FillDateTime >= a.GLP1FillTime
union all

select distinct a.*, b.FillNumber as GLP1FillNumber

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where LocalDrugNameWithDose like '%empagliflozin%' 
or LocalDrugNameWithDose like '%dapagliflozin%' 
or LocalDrugNameWithDose like '%canagliflozin%' 
or LocalDrugNameWithDose like '%ertugliflozin%' 
--and b.FillDateTime >= a.GLP1FillTime

select distinct * 
into Dflt.AF_GLP1SGLT2
from #GLP1SGLT2 where GLP1FillNumber >=3
and FillDateTime >= GLP1FillTime

select distinct scrssn from Dflt.AF_GLP1SGLT2 --281

/* SGLT2 after initiation of DPP4 - refill at least 3 */

select distinct a.*, b.FillNumber as GLP1FillNumber

into #DPP4SGLT2

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where LocalDrugNameWithDose like '%semaglutide%' 
or LocalDrugNameWithDose like '%exenatide%' 
or LocalDrugNameWithDose like '%liraglutide%' 
or LocalDrugNameWithDose like '%lixisenatide%' 
or LocalDrugNameWithDose like '%dulaglutide%'
--and b.FillDateTime >= a.DPP4FillTime
union all

select distinct a.*, b.FillNumber as GLP1FillNumber

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where LocalDrugNameWithDose like '%semaglutide%' 
or LocalDrugNameWithDose like '%exenatide%' 
or LocalDrugNameWithDose like '%liraglutide%' 
or LocalDrugNameWithDose like '%lixisenatide%' 
or LocalDrugNameWithDose like '%dulaglutide%'
--and b.FillDateTime >= a.DPP4FillTime

select distinct *
into Dflt.AF_DPP4SGLT2
from #DPP4SGLT2 where GLP1FillNumber >=3
and FillDateTime >= DPP4FillTime

select distinct scrssn from Dflt.AF_DPP4SGLT2 --147

/*BMI*/
/* Select height and weight values from vital signs view to calculate bmi */


select distinct a.PatientSID, a.VitalSignTakenDateTime, a.VitalResult, a.VitalResultNumeric,
 b.GLP1FillTime, b.ScrSSN, 
c.VitalType

into #tempDiabetesVitalsGLP1

from Src.Vital_VitalSign as a with (NOLOCK) inner join
Dflt.Diabetes_AF_GLP1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.VitalType as c with (NOLOCK) on a.VitalTypeSID=c.VitalTypeSID 
where a.VitalSignTakenDateTime > dateadd(month, 3, b.GLP1FillTime) AND
c.VitalType in ( 'WEIGHT')
union all

select distinct a.PatientSID, a.VitalSignTakenDateTime, a.VitalResult, a.VitalResultNumeric,
b.GLP1FillTime,b.ScrSSN, 
c.VitalType

from Src.Vital_VitalSign_Recent as a with (NOLOCK) inner join
Dflt.Diabetes_AF_GLP1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.VitalType as c with (NOLOCK) on a.VitalTypeSID=c.VitalTypeSID 
where a.VitalSignTakenDateTime > dateadd(month, 3, b.GLP1FillTime) AND 
c.VitalType in ( 'WEIGHT')
union all

select distinct a.PatientSID, a.VitalSignTakenDateTime, a.VitalResult, a.VitalResultNumeric,
 b.GLP1FillTime, b.ScrSSN, 
c.VitalType

from Src.Vital_VitalSign as a with (NOLOCK) inner join
Dflt.Diabetes_AF_GLP1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.VitalType as c with (NOLOCK) on a.VitalTypeSID=c.VitalTypeSID 
--where (a.VitalSignTakenDateTime between dateadd(month, -12, b.GLP1FillTime) and dateadd(day, 1, b.GLP1FillTime))AND
where a.VitalSignTakenDateTime >= b.GLP1FillTime and 
c.VitalType in ( 'HEIGHT')
union all

select distinct a.PatientSID, a.VitalSignTakenDateTime, a.VitalResult, a.VitalResultNumeric,
b.GLP1FillTime,b.ScrSSN, 
c.VitalType

from Src.Vital_VitalSign_Recent as a with (NOLOCK) inner join
Dflt.Diabetes_AF_GLP1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.VitalType as c with (NOLOCK) on a.VitalTypeSID=c.VitalTypeSID 
--where (a.VitalSignTakenDateTime between dateadd(month, -12, b.GLP1FillTime) and dateadd(day, 1, b.GLP1FillTime))AND
where a.VitalSignTakenDateTime >= b.GLP1FillTime and 
c.VitalType in ( 'HEIGHT')

select distinct scrssn from #tempDiabetesVitalsGLP1-- 1467

/* Seperate weight records into a table */
select * 

into #tempweightGLP1After

from #tempDiabetesVitalsGLP1 where vitaltype = 'WEIGHT' and VitalResultNumeric != '0'

select distinct scrssn from #tempweightGLP1After --1452

/* Seperate height records into a table */
select *  

into #tempheightGLP1After

from #tempDiabetesVitalsGLP1 where vitaltype = 'HEIGHT' and VitalResultNumeric != '0'

select distinct scrssn from #tempheightGLP1After --1338

/* Combine data from table weight and height to obtain the bmi for individual patient */

select distinct a.patientsid, a.ScrSSN, cast(a.VitalSignTakenDateTime as date) as HeightTime, a.VitalResultNumeric as heightresult, 
cast(b.VitalSignTakenDateTime as date) as WeightTime,b.VitalResultNumeric as weightresult, ((b.VitalResultNumeric*703)/(a.VitalResultNumeric*a.VitalResultNumeric)) as bmi

into Dflt.Diabetes_AF_GLP1_BMI_After

from #tempheightGLP1After as a with (NOLOCK) inner join
#tempweightGLP1After as b with (NOLOCK) on a.ScrSSN = b.ScrSSN
where a.VitalSignTakenDateTime=b.VitalSignTakenDateTime --a.GLP1FillTime=b.GLP1FillTime and

select distinct scrssn from Dflt.Diabetes_AF_GLP1_BMI_After --1269

select distinct scrssn from Dflt.Diabetes_AF_GLP1_BMI_After where bmi between 30 and 35  --563

select distinct scrssn from Dflt.Diabetes_AF_GLP1_BMI_After where bmi between 35 and 40  --487

select distinct scrssn from Dflt.Diabetes_AF_GLP1_BMI_After where bmi > 40 --390

select distinct scrssn from Dflt.Diabetes_AF_GLP1_BMI_After where bmi < 30 --461

/* GLP1 Cardioversion using procedure codes - 1 week after drug initiation */

select distinct a.*, b.ICDProcedureDateTime, c.ICD9ProcedureCode
/*ICD9Procedure Codes*/

into Dflt.Diabetes_AF_GLP1_CardioAfter

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_CensusICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('99.61','99.62')
					and b.ICDProcedureDateTime  >  dateadd(day, 7, a.GLP1FillTime)
union all

select distinct a.*, b.SurgicalProcedureDateTime, c.ICD9ProcedureCode

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_CensusSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('99.61','99.62')
					and b.SurgicalProcedureDateTime  >  dateadd(day, 7, a.GLP1FillTime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD9ProcedureCode

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('99.61','99.62')
					and b.DischargeDateTime  >  dateadd(day, 7, a.GLP1FillTime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD9ProcedureCode

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('99.61','99.62')
					and b.DischargeDateTime  >  dateadd(day, 7, a.GLP1FillTime)
union all

/*ICD10Procedure Codes*/
select distinct a.*, b.ICDProcedureDateTime, c.ICD10ProcedureCode

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_CensusICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('5A2204Z')
and b.ICDProcedureDateTime  >  dateadd(day, 7, a.GLP1FillTime)
union all

select distinct a.*, b.SurgicalProcedureDateTime, c.ICD10ProcedureCode

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_CensusSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('5A2204Z')
and b.SurgicalProcedureDateTime  >  dateadd(day, 7, a.GLP1FillTime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD10ProcedureCode

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('5A2204Z')
and b.DischargeDateTime  >  dateadd(day, 7, a.GLP1FillTime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD10ProcedureCode

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('5A2204Z')
and b.DischargeDateTime  >  dateadd(day, 7, a.GLP1FillTime)

select distinct scrssn from Dflt.Diabetes_AF_GLP1_CardioAfter --70

/* GLP1 Ablation using CPT codes- 1 week after drug initiation */

select distinct a.*

into Dflt.Diabetes_AF_GLP1_AblationAfter

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientCPTProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
Src.Cohort_CPT as c with (NOLOCK) on c.CPTSID=b.cptSID 
where c.cptcode in ('93656','93657','93662','33254','33255','33258','33265','33266')
and b.DischargeDateTime >  dateadd(day, 7, a.GLP1FillTime)
union all

select distinct a.*
from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Surg_SurgeryPrincipalAssociatedProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on b.OtherProcedureCPTSID=c.cptSID 
where c.cptcode in ('93656','93657','93662','33254','33255','33258','33265','33266') 
and b.SurgeryDateTime >  dateadd(day, 7, a.GLP1FillTime)
union all

select distinct a.*
from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Surg_SurgeryProcedureDiagnosisCode as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on b.PrincipalCPTSID=c.cptSID 
where c.cptcode in ('93656','93657','93662','33254','33255','33258','33265','33266')
and b.SurgeryDateTime >  dateadd(day, 7, a.GLP1FillTime)

select distinct scrssn from Dflt.Diabetes_AF_GLP1_AblationAfter --4

/* GLP1 Ablation using procedure codes- 1 week after initiation */

select distinct a.*, b.ICDProcedureDateTime, c.ICD9ProcedureCode
/*ICD9Procedure Codes*/

into Dflt.Diabetes_AF_GLP1_AbProcAfter

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_CensusICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('37.33','37.34','37.37','37.80','38.65')
					and b.ICDProcedureDateTime >  dateadd(day, 7, a.GLP1FillTime)
union all

select distinct a.*, b.SurgicalProcedureDateTime, c.ICD9ProcedureCode

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_CensusSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('37.33','37.34','37.37','37.80','38.65')
					and b.SurgicalProcedureDateTime >  dateadd(day, 7, a.GLP1FillTime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD9ProcedureCode

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('37.33','37.34','37.37','37.80','38.65')
					and b.DischargeDateTime >  dateadd(day, 7, a.GLP1FillTime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD9ProcedureCode

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('37.33','37.34','37.37','37.80','38.65')
					and b.DischargeDateTime >  dateadd(day, 7, a.GLP1FillTime)
union all

/*ICD10Procedure Codes*/
select distinct a.*, b.ICDProcedureDateTime, c.ICD10ProcedureCode

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_CensusICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('02560ZZ','02563ZZ','02564ZZ',
'02570ZZ','02573ZZ','02574ZZ','02580ZZ','02583ZZ','02584ZZ','025S0ZZ','025S3ZZ','025S4ZZ','025T0ZZ','025T3ZZ','025T4ZZ')
and b.ICDProcedureDateTime >  dateadd(day, 7, a.GLP1FillTime)
union all

select distinct a.*, b.SurgicalProcedureDateTime, c.ICD10ProcedureCode

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_CensusSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('02560ZZ','02563ZZ','02564ZZ',
'02570ZZ','02573ZZ','02574ZZ','02580ZZ','02583ZZ','02584ZZ','025S0ZZ','025S3ZZ','025S4ZZ','025T0ZZ','025T3ZZ','025T4ZZ')
and b.SurgicalProcedureDateTime >  dateadd(day, 7, a.GLP1FillTime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD10ProcedureCode

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('02560ZZ','02563ZZ','02564ZZ',
'02570ZZ','02573ZZ','02574ZZ','02580ZZ','02583ZZ','02584ZZ','025S0ZZ','025S3ZZ','025S4ZZ','025T0ZZ','025T3ZZ','025T4ZZ')
and b.DischargeDateTime >  dateadd(day, 7, a.GLP1FillTime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD10ProcedureCode

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('02560ZZ','02563ZZ','02564ZZ',
'02570ZZ','02573ZZ','02574ZZ','02580ZZ','02583ZZ','02584ZZ','025S0ZZ','025S3ZZ','025S4ZZ','025T0ZZ','025T3ZZ','025T4ZZ')
and b.DischargeDateTime >  dateadd(day, 7, a.GLP1FillTime)

select distinct scrssn from Dflt.Diabetes_AF_GLP1_AbProcAfter --32

/* DPP4 */

/* Baseline Measurements for DPP4GLP1 Cohort */
/* Demographics */
/* Age */

select a.ScrSSN, a.DPP4Filltime, b.DOB,b.SEX
into Dflt.Diabetes_AF_DPP4GLP1_DOB
from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.VitalStatus_Mini as b with (NOLOCK) on a.scrssn= b.scrssn

select *, datediff( year, DOB, DPP4Filltime) as age
into Dflt.Diabetes_AF_DPP4GLP1_Age
from Dflt.Diabetes_AF_DPP4GLP1_DOB

select distinct scrssn from Dflt.Diabetes_AF_DPP4GLP1_Age where SEX ='F'

/* Date of Death */

select a.ScrSSN,  b.MPI_DOD
into Dflt.Diabetes_AF_DPP4GLP1_DOD
from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.SDAF_DAFMaster as b with (NOLOCK) on a.scrssn= b.MPI_scrssn
where b.MPI_DOD is not null

select distinct scrssn from Dflt.Diabetes_AF_DPP4GLP1_DOD --962

select max(MPI_DOD) from Dflt.Diabetes_AF_DPP4GLP1_DOD

select * from Dflt.Diabetes_AF_DPP4GLP1_DOD where MPI_DOD > '2023-12-01'

/* Race */

select a.*,  b.Race
into Dflt.Diabetes_AF_DPP4GLP1_Race
from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.PatSub_PatientRace as b with (NOLOCK) on a.patientsid= b.patientsid

select distinct scrssn from Dflt.Diabetes_AF_DPP4GLP1_Race --1983

select distinct race from Dflt.Diabetes_AF_DPP4GLP1_Race 

select distinct scrssn from Dflt.Diabetes_AF_DPP4GLP1_Race where race = 'WHITE' --1629

select distinct scrssn from Dflt.Diabetes_AF_DPP4GLP1_Race where race = 'BLACK OR AFRICAN AMERICAN' --213

/* Hypertension */

select distinct a.*, b.DischargeDateTime as comorbidity_Dischargedatetime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_AF_DPP4GLP1_Hyper

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('401.1','401.0','401.9','402.00','402.01','402.90','402.91','403.00','403.01','403.10','403.11','403.90','403.91','404.00','404.01','404.02','404.03','404.10',
					'404.11','404.12','404.13','404.90','404.91','404.92','404.93','405.01','405.09','405.11','405.99','642.00','642.01','642.02','642.03','642.04','642.10','642.11',
					'642.12','642.13','642.14','642.20','642.21','642.22','642.23','642.24','642.70','642.71','642.72','642.73','642.74','642.90','642.91','642.92','642.93','642.94')
					and b.DischargeDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('401.1','401.0','401.9','402.00','402.01','402.90','402.91','403.00','403.01','403.10','403.11','403.90','403.91','404.00','404.01','404.02','404.03','404.10',
					'404.11','404.12','404.13','404.90','404.91','404.92','404.93','405.01','405.09','405.11','405.99','642.00','642.01','642.02','642.03','642.04','642.10','642.11',
					'642.12','642.13','642.14','642.20','642.21','642.22','642.23','642.24','642.70','642.71','642.72','642.73','642.74','642.90','642.91','642.92','642.93','642.94')
					and b.DischargeDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('401.1','401.0','401.9','402.00','402.01','402.90','402.91','403.00','403.01','403.10','403.11','403.90','403.91','404.00','404.01','404.02','404.03','404.10',
					'404.11','404.12','404.13','404.90','404.91','404.92','404.93','405.01','405.09','405.11','405.99','642.00','642.01','642.02','642.03','642.04','642.10','642.11',
					'642.12','642.13','642.14','642.20','642.21','642.22','642.23','642.24','642.70','642.71','642.72','642.73','642.74','642.90','642.91','642.92','642.93','642.94')
					and b.DischargeDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.*, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('401.1','401.0','401.9','402.00','402.01','402.90','402.91','403.00','403.01','403.10','403.11','403.90','403.91','404.00','404.01','404.02','404.03','404.10',
					'404.11','404.12','404.13','404.90','404.91','404.92','404.93','405.01','405.09','405.11','405.99','642.00','642.01','642.02','642.03','642.04','642.10','642.11',
					'642.12','642.13','642.14','642.20','642.21','642.22','642.23','642.24','642.70','642.71','642.72','642.73','642.74','642.90','642.91','642.92','642.93','642.94')
					and b.EventDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.*, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('401.1','401.0','401.9','402.00','402.01','402.90','402.91','403.00','403.01','403.10','403.11','403.90','403.91','404.00','404.01','404.02','404.03','404.10',
					'404.11','404.12','404.13','404.90','404.91','404.92','404.93','405.01','405.09','405.11','405.99','642.00','642.01','642.02','642.03','642.04','642.10','642.11',
					'642.12','642.13','642.14','642.20','642.21','642.22','642.23','642.24','642.70','642.71','642.72','642.73','642.74','642.90','642.91','642.92','642.93','642.94')
					and b.EventDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.*, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('401.1','401.0','401.9','402.00','402.01','402.90','402.91','403.00','403.01','403.10','403.11','403.90','403.91','404.00','404.01','404.02','404.03','404.10',
					'404.11','404.12','404.13','404.90','404.91','404.92','404.93','405.01','405.09','405.11','405.99','642.00','642.01','642.02','642.03','642.04','642.10','642.11',
					'642.12','642.13','642.14','642.20','642.21','642.22','642.23','642.24','642.70','642.71','642.72','642.73','642.74','642.90','642.91','642.92','642.93','642.94')
					and b.EventDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.*, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('401.1','401.0','401.9','402.00','402.01','402.90','402.91','403.00','403.01','403.10','403.11','403.90','403.91','404.00','404.01','404.02','404.03','404.10',
					'404.11','404.12','404.13','404.90','404.91','404.92','404.93','405.01','405.09','405.11','405.99','642.00','642.01','642.02','642.03','642.04','642.10','642.11',
					'642.12','642.13','642.14','642.20','642.21','642.22','642.23','642.24','642.70','642.71','642.72','642.73','642.74','642.90','642.91','642.92','642.93','642.94')
					and b.PatientTransferDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.*, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('401.1','401.0','401.9','402.00','402.01','402.90','402.91','403.00','403.01','403.10','403.11','403.90','403.91','404.00','404.01','404.02','404.03','404.10',
					'404.11','404.12','404.13','404.90','404.91','404.92','404.93','405.01','405.09','405.11','405.99','642.00','642.01','642.02','642.03','642.04','642.10','642.11',
					'642.12','642.13','642.14','642.20','642.21','642.22','642.23','642.24','642.70','642.71','642.72','642.73','642.74','642.90','642.91','642.92','642.93','642.94')
					and b.SpecialtyTransferDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.*, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('401.1','401.0','401.9','402.00','402.01','402.90','402.91','403.00','403.01','403.10','403.11','403.90','403.91','404.00','404.01','404.02','404.03','404.10',
					'404.11','404.12','404.13','404.90','404.91','404.92','404.93','405.01','405.09','405.11','405.99','642.00','642.01','642.02','642.03','642.04','642.10','642.11',
					'642.12','642.13','642.14','642.20','642.21','642.22','642.23','642.24','642.70','642.71','642.72','642.73','642.74','642.90','642.91','642.92','642.93','642.94')
					and b.AdmitDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

/*ICD10 Codes*/
select distinct a.*, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I10.', 'I16.9', 'I11.9','I11.0', 'I12.9', 'I12.0','I13.10', 'I13.0', 'I13.11', 'I13.2', 'I15.0', 'I15.8', 
					'O10.019','O10.919', 'O10.011', 'O10.012', 'O10.013', 'O10.02', 'O10.911', 'O10.912', 'O10.913', 'O10.92', 'O10.03', 'O10.93', 
					'O10.419', 'O10.411', 'O10.412', 'O10.413', 'O10.42', 'O10.43','O10.119', 'O10.219', 'O10.319', 'O10.111', 'O10.112', 'O10.113', 'O10.12', 
					'O10.211', 'O10.212', 'O10.213','O10.22', 'O10.311', 'O10.312', 'O10.313', 'O10.32', 'O10.13', 'O10.23', 'O10.33', 'O11.9', 'O11.1', 'O11.2', 
					'O11.3', 'O11.4','O11.5', 'O16.9', 'O16.1', 'O16.2', 'O16.3', 'O16.4', 'O16.5')
and b.DischargeDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I10.', 'I16.9', 'I11.9','I11.0', 'I12.9', 'I12.0','I13.10', 'I13.0', 'I13.11', 'I13.2', 'I15.0', 'I15.8', 
					'O10.019','O10.919', 'O10.011', 'O10.012', 'O10.013', 'O10.02', 'O10.911', 'O10.912', 'O10.913', 'O10.92', 'O10.03', 'O10.93', 
					'O10.419', 'O10.411', 'O10.412', 'O10.413', 'O10.42', 'O10.43','O10.119', 'O10.219', 'O10.319', 'O10.111', 'O10.112', 'O10.113', 'O10.12', 
					'O10.211', 'O10.212', 'O10.213','O10.22', 'O10.311', 'O10.312', 'O10.313', 'O10.32', 'O10.13', 'O10.23', 'O10.33', 'O11.9', 'O11.1', 'O11.2', 
					'O11.3', 'O11.4','O11.5', 'O16.9', 'O16.1', 'O16.2', 'O16.3', 'O16.4', 'O16.5')
and b.DischargeDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I10.', 'I16.9', 'I11.9','I11.0', 'I12.9', 'I12.0','I13.10', 'I13.0', 'I13.11', 'I13.2', 'I15.0', 'I15.8', 
					'O10.019','O10.919', 'O10.011', 'O10.012', 'O10.013', 'O10.02', 'O10.911', 'O10.912', 'O10.913', 'O10.92', 'O10.03', 'O10.93', 
					'O10.419', 'O10.411', 'O10.412', 'O10.413', 'O10.42', 'O10.43','O10.119', 'O10.219', 'O10.319', 'O10.111', 'O10.112', 'O10.113', 'O10.12', 
					'O10.211', 'O10.212', 'O10.213','O10.22', 'O10.311', 'O10.312', 'O10.313', 'O10.32', 'O10.13', 'O10.23', 'O10.33', 'O11.9', 'O11.1', 'O11.2', 
					'O11.3', 'O11.4','O11.5', 'O16.9', 'O16.1', 'O16.2', 'O16.3', 'O16.4', 'O16.5')
and b.DischargeDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.*, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I10.', 'I16.9', 'I11.9','I11.0', 'I12.9', 'I12.0','I13.10', 'I13.0', 'I13.11', 'I13.2', 'I15.0', 'I15.8', 
					'O10.019','O10.919', 'O10.011', 'O10.012', 'O10.013', 'O10.02', 'O10.911', 'O10.912', 'O10.913', 'O10.92', 'O10.03', 'O10.93', 
					'O10.419', 'O10.411', 'O10.412', 'O10.413', 'O10.42', 'O10.43','O10.119', 'O10.219', 'O10.319', 'O10.111', 'O10.112', 'O10.113', 'O10.12', 
					'O10.211', 'O10.212', 'O10.213','O10.22', 'O10.311', 'O10.312', 'O10.313', 'O10.32', 'O10.13', 'O10.23', 'O10.33', 'O11.9', 'O11.1', 'O11.2', 
					'O11.3', 'O11.4','O11.5', 'O16.9', 'O16.1', 'O16.2', 'O16.3', 'O16.4', 'O16.5')
and b.EventDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.*, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I10.', 'I16.9', 'I11.9','I11.0', 'I12.9', 'I12.0','I13.10', 'I13.0', 'I13.11', 'I13.2', 'I15.0', 'I15.8', 
					'O10.019','O10.919', 'O10.011', 'O10.012', 'O10.013', 'O10.02', 'O10.911', 'O10.912', 'O10.913', 'O10.92', 'O10.03', 'O10.93', 
					'O10.419', 'O10.411', 'O10.412', 'O10.413', 'O10.42', 'O10.43','O10.119', 'O10.219', 'O10.319', 'O10.111', 'O10.112', 'O10.113', 'O10.12', 
					'O10.211', 'O10.212', 'O10.213','O10.22', 'O10.311', 'O10.312', 'O10.313', 'O10.32', 'O10.13', 'O10.23', 'O10.33', 'O11.9', 'O11.1', 'O11.2', 
					'O11.3', 'O11.4','O11.5', 'O16.9', 'O16.1', 'O16.2', 'O16.3', 'O16.4', 'O16.5')
and b.EventDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.*, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I10.', 'I16.9', 'I11.9','I11.0', 'I12.9', 'I12.0','I13.10', 'I13.0', 'I13.11', 'I13.2', 'I15.0', 'I15.8', 
					'O10.019','O10.919', 'O10.011', 'O10.012', 'O10.013', 'O10.02', 'O10.911', 'O10.912', 'O10.913', 'O10.92', 'O10.03', 'O10.93', 
					'O10.419', 'O10.411', 'O10.412', 'O10.413', 'O10.42', 'O10.43','O10.119', 'O10.219', 'O10.319', 'O10.111', 'O10.112', 'O10.113', 'O10.12', 
					'O10.211', 'O10.212', 'O10.213','O10.22', 'O10.311', 'O10.312', 'O10.313', 'O10.32', 'O10.13', 'O10.23', 'O10.33', 'O11.9', 'O11.1', 'O11.2', 
					'O11.3', 'O11.4','O11.5', 'O16.9', 'O16.1', 'O16.2', 'O16.3', 'O16.4', 'O16.5')
and b.EventDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)

union all

select distinct a.*, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I10.', 'I16.9', 'I11.9','I11.0', 'I12.9', 'I12.0','I13.10', 'I13.0', 'I13.11', 'I13.2', 'I15.0', 'I15.8', 
					'O10.019','O10.919', 'O10.011', 'O10.012', 'O10.013', 'O10.02', 'O10.911', 'O10.912', 'O10.913', 'O10.92', 'O10.03', 'O10.93', 
					'O10.419', 'O10.411', 'O10.412', 'O10.413', 'O10.42', 'O10.43','O10.119', 'O10.219', 'O10.319', 'O10.111', 'O10.112', 'O10.113', 'O10.12', 
					'O10.211', 'O10.212', 'O10.213','O10.22', 'O10.311', 'O10.312', 'O10.313', 'O10.32', 'O10.13', 'O10.23', 'O10.33', 'O11.9', 'O11.1', 'O11.2', 
					'O11.3', 'O11.4','O11.5', 'O16.9', 'O16.1', 'O16.2', 'O16.3', 'O16.4', 'O16.5')
and b.PatientTransferDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)

union all

select distinct a.*, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I10.', 'I16.9', 'I11.9','I11.0', 'I12.9', 'I12.0','I13.10', 'I13.0', 'I13.11', 'I13.2', 'I15.0', 'I15.8', 
					'O10.019','O10.919', 'O10.011', 'O10.012', 'O10.013', 'O10.02', 'O10.911', 'O10.912', 'O10.913', 'O10.92', 'O10.03', 'O10.93', 
					'O10.419', 'O10.411', 'O10.412', 'O10.413', 'O10.42', 'O10.43','O10.119', 'O10.219', 'O10.319', 'O10.111', 'O10.112', 'O10.113', 'O10.12', 
					'O10.211', 'O10.212', 'O10.213','O10.22', 'O10.311', 'O10.312', 'O10.313', 'O10.32', 'O10.13', 'O10.23', 'O10.33', 'O11.9', 'O11.1', 'O11.2', 
					'O11.3', 'O11.4','O11.5', 'O16.9', 'O16.1', 'O16.2', 'O16.3', 'O16.4', 'O16.5')
and b.SpecialtyTransferDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)

union all

select distinct a.*, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I10.', 'I16.9', 'I11.9','I11.0', 'I12.9', 'I12.0','I13.10', 'I13.0', 'I13.11', 'I13.2', 'I15.0', 'I15.8', 
					'O10.019','O10.919', 'O10.011', 'O10.012', 'O10.013', 'O10.02', 'O10.911', 'O10.912', 'O10.913', 'O10.92', 'O10.03', 'O10.93', 
					'O10.419', 'O10.411', 'O10.412', 'O10.413', 'O10.42', 'O10.43','O10.119', 'O10.219', 'O10.319', 'O10.111', 'O10.112', 'O10.113', 'O10.12', 
					'O10.211', 'O10.212', 'O10.213','O10.22', 'O10.311', 'O10.312', 'O10.313', 'O10.32', 'O10.13', 'O10.23', 'O10.33', 'O11.9', 'O11.1', 'O11.2', 
					'O11.3', 'O11.4','O11.5', 'O16.9', 'O16.1', 'O16.2', 'O16.3', 'O16.4', 'O16.5')
and b.AdmitDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)

select distinct scrssn from Dflt.Diabetes_AF_DPP4GLP1_Hyper --1402

/* Chronic Kidney Disease */
/*Making sure the ICD9 and ICD10 codes relevant to Kidney Disease are present in the Dimension table under CDWWork*/

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
													'V56.0','V56.1','V56.2','V56.8', '585.3')

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3') or ICD10Code like 'Z49.%'

select distinct a.patientsid, a.scrssn, a.DPP4Filltime ,b.DischargeDateTime as comorbidity_Dischargedatetime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_AF_DPP4GLP1_KD

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
													'V56.0','V56.1','V56.2','V56.8', '585.3')
					and b.DischargeDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
													'V56.0','V56.1','V56.2','V56.8', '585.3')
					and b.DischargeDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
													'V56.0','V56.1','V56.2','V56.8', '585.3')
					and b.DischargeDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
													'V56.0','V56.1','V56.2','V56.8', '585.3')
					and b.EventDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
													'V56.0','V56.1','V56.2','V56.8', '585.3')
					and b.EventDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
													'V56.0','V56.1','V56.2','V56.8', '585.3')
					and b.EventDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
													'V56.0','V56.1','V56.2','V56.8', '585.3')
					and b.PatientTransferDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
													'V56.0','V56.1','V56.2','V56.8', '585.3')
					and b.SpecialtyTransferDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
													'V56.0','V56.1','V56.2','V56.8', '585.3')
					and b.AdmitDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3') or ICD10Code like 'Z49.%'
and b.DischargeDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3') or ICD10Code like 'Z49.%'
and b.DischargeDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3') or ICD10Code like 'Z49.%'
and b.DischargeDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3') or ICD10Code like 'Z49.%'
and b.EventDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3') or ICD10Code like 'Z49.%'
and b.EventDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3') or ICD10Code like 'Z49.%'
and b.EventDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)

union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3') or ICD10Code like 'Z49.%'
and b.PatientTransferDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)

union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3') or ICD10Code like 'Z49.%'
and b.SpecialtyTransferDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)

union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3') or ICD10Code like 'Z49.%'
and b.AdmitDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)

select distinct scrssn from Dflt.Diabetes_AF_DPP4GLP1_KD --669

/* End Stage Renal Disease - ESRD */
/*Making sure the ICD9 and ICD10 codes relevant to ESRD are present in the Dimension table under CDWWork*/

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('585.6')

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('N18.6')

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime as comorbidity_Dischargedatetime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_AF_DPP4GLP1_ESRD

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('585.6')
					and b.DischargeDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('585.6')
					and b.DischargeDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('585.6')
					and b.DischargeDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('585.6')
					and b.EventDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('585.6')
					and b.EventDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('585.6')
					and b.EventDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('585.6')
					and b.PatientTransferDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('585.6')
					and b.SpecialtyTransferDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('585.6')
					and b.AdmitDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('N18.6')
and b.DischargeDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('N18.6')
and b.DischargeDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('N18.6')
and b.DischargeDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('N18.6')
and b.EventDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('N18.6')
and b.EventDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('N18.6')
and b.EventDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)

union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('N18.6')
and b.PatientTransferDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)

union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('N18.6')
and b.SpecialtyTransferDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)

union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('N18.6')
and b.AdmitDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)

select distinct scrssn from Dflt.Diabetes_AF_DPP4GLP1_ESRD --12

/* Alcohol Abuse */

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime as comorbidity_Dischargedatettime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_AF_DPP4GLP1_Alcohol

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('290.0','291.1','291.2','291.3','291.5','291.81','291.82','291.89','291.9',
			    '303.00','303.01','303.02','303.03','303.90','303.91','303.92','303.93','305.00','305.01','305.02','305.03','V11.3')
					and b.DischargeDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('290.0','291.1','291.2','291.3','291.5','291.81','291.82','291.89','291.9',
			    '303.00','303.01','303.02','303.03','303.90','303.91','303.92','303.93','305.00','305.01','305.02','305.03','V11.3')
					and b.DischargeDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('290.0','291.1','291.2','291.3','291.5','291.81','291.82','291.89','291.9',
			    '303.00','303.01','303.02','303.03','303.90','303.91','303.92','303.93','305.00','305.01','305.02','305.03','V11.3')
					and b.DischargeDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('290.0','291.1','291.2','291.3','291.5','291.81','291.82','291.89','291.9',
			    '303.00','303.01','303.02','303.03','303.90','303.91','303.92','303.93','305.00','305.01','305.02','305.03','V11.3')
					and b.EventDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('290.0','291.1','291.2','291.3','291.5','291.81','291.82','291.89','291.9',
			    '303.00','303.01','303.02','303.03','303.90','303.91','303.92','303.93','305.00','305.01','305.02','305.03','V11.3')
					and b.EventDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('290.0','291.1','291.2','291.3','291.5','291.81','291.82','291.89','291.9',
			    '303.00','303.01','303.02','303.03','303.90','303.91','303.92','303.93','305.00','305.01','305.02','305.03','V11.3')
					and b.EventDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('290.0','291.1','291.2','291.3','291.5','291.81','291.82','291.89','291.9',
			    '303.00','303.01','303.02','303.03','303.90','303.91','303.92','303.93','305.00','305.01','305.02','305.03','V11.3')
					and b.PatientTransferDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('290.0','291.1','291.2','291.3','291.5','291.81','291.82','291.89','291.9',
			    '303.00','303.01','303.02','303.03','303.90','303.91','303.92','303.93','305.00','305.01','305.02','305.03','V11.3')
					and b.SpecialtyTransferDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('290.0','291.1','291.2','291.3','291.5','291.81','291.82','291.89','291.9',
			    '303.00','303.01','303.02','303.03','303.90','303.91','303.92','303.93','305.00','305.01','305.02','305.03','V11.3')
					and b.AdmitDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.231', 'F10.96', 'F10.27','F10.951','F10.950', 'F10.239', 'F10.182', 'F10.282', 'F10.982', 'F10.159', 'F10.180', 
					'F10.181', 'F10.188','F10.259', 'F10.280', 'F10.281', 'F10.288', 'F10.959', 'F10.980', 'F10.99','F10.229', 'F10.20', 'F10.21','F10.10','F10.11','Z65.8 ')
and b.DischargeDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.231', 'F10.96', 'F10.27','F10.951','F10.950', 'F10.239', 'F10.182', 'F10.282', 'F10.982', 'F10.159', 'F10.180', 
					'F10.181', 'F10.188','F10.259', 'F10.280', 'F10.281', 'F10.288', 'F10.959', 'F10.980', 'F10.99','F10.229', 'F10.20', 'F10.21','F10.10','F10.11','Z65.8 ')
and b.DischargeDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.231', 'F10.96', 'F10.27','F10.951','F10.950', 'F10.239', 'F10.182', 'F10.282', 'F10.982', 'F10.159', 'F10.180', 
					'F10.181', 'F10.188','F10.259', 'F10.280', 'F10.281', 'F10.288', 'F10.959', 'F10.980', 'F10.99','F10.229', 'F10.20', 'F10.21','F10.10','F10.11','Z65.8 ')
and b.DischargeDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.231', 'F10.96', 'F10.27','F10.951','F10.950', 'F10.239', 'F10.182', 'F10.282', 'F10.982', 'F10.159', 'F10.180', 
					'F10.181', 'F10.188','F10.259', 'F10.280', 'F10.281', 'F10.288', 'F10.959', 'F10.980', 'F10.99','F10.229', 'F10.20', 'F10.21','F10.10','F10.11','Z65.8 ')
and b.EventDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.231', 'F10.96', 'F10.27','F10.951','F10.950', 'F10.239', 'F10.182', 'F10.282', 'F10.982', 'F10.159', 'F10.180', 
					'F10.181', 'F10.188','F10.259', 'F10.280', 'F10.281', 'F10.288', 'F10.959', 'F10.980', 'F10.99','F10.229', 'F10.20', 'F10.21','F10.10','F10.11','Z65.8 ')
and b.EventDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.231', 'F10.96', 'F10.27','F10.951','F10.950', 'F10.239', 'F10.182', 'F10.282', 'F10.982', 'F10.159', 'F10.180', 
					'F10.181', 'F10.188','F10.259', 'F10.280', 'F10.281', 'F10.288', 'F10.959', 'F10.980', 'F10.99','F10.229', 'F10.20', 'F10.21','F10.10','F10.11','Z65.8 ')
and b.EventDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)

union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.231', 'F10.96', 'F10.27','F10.951','F10.950', 'F10.239', 'F10.182', 'F10.282', 'F10.982', 'F10.159', 'F10.180', 
					'F10.181', 'F10.188','F10.259', 'F10.280', 'F10.281', 'F10.288', 'F10.959', 'F10.980', 'F10.99','F10.229', 'F10.20', 'F10.21','F10.10','F10.11','Z65.8 ')
and b.PatientTransferDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)

union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.231', 'F10.96', 'F10.27','F10.951','F10.950', 'F10.239', 'F10.182', 'F10.282', 'F10.982', 'F10.159', 'F10.180', 
					'F10.181', 'F10.188','F10.259', 'F10.280', 'F10.281', 'F10.288', 'F10.959', 'F10.980', 'F10.99','F10.229', 'F10.20', 'F10.21','F10.10','F10.11','Z65.8 ')
and b.SpecialtyTransferDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)

union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.231', 'F10.96', 'F10.27','F10.951','F10.950', 'F10.239', 'F10.182', 'F10.282', 'F10.982', 'F10.159', 'F10.180', 
					'F10.181', 'F10.188','F10.259', 'F10.280', 'F10.281', 'F10.288', 'F10.959', 'F10.980', 'F10.99','F10.229', 'F10.20', 'F10.21','F10.10','F10.11','Z65.8 ')
and b.AdmitDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)

select distinct scrssn from Dflt.Diabetes_AF_DPP4GLP1_Alcohol --68

/*Polysubstance Abuse */
/*Making sure the ICD9 and ICD10 codes relevant to Polysubstance Abuse are present in the Dimension table under CDWWork*/

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('F10.129','F10.229','F10.929','F10.10','F10.20','F11.10',
																	'F11.10','F11.20','F11.129','F11.229','F11.929','F11.122','F11.222','F11.922','F11.23','F11.99',
																	'F13.10','F13.20','F14.10','F14.20','F12.10','F12.20','F16.10','F16.20','F18.10','F18.20',
																	'F19.10','F19.20','Z72.0','F17.200','F15.10','F15.20','F15.929')

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('303.00','305.00','303.90','304.00','292.89','292.0','292.9','304.10','305.40','304.20','305.60',
															'304.30','305.20','304.50','305.30','305.90','304.60','304.80','304.90','305.10',
															'305.70','304.40','304.6')

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime as comorbidity_Dischargedatettime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_AF_DPP4GLP1_PolyAbuse

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('303.00','305.00','303.90','304.00','292.89','292.0','292.9','304.10','305.40','304.20','305.60',
					'304.30','305.20','304.50','305.30','305.90','304.60','304.80','304.90','305.10','305.70','304.40','304.6')
					and b.DischargeDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('303.00','305.00','303.90','304.00','292.89','292.0','292.9','304.10','305.40','304.20','305.60',
					'304.30','305.20','304.50','305.30','305.90','304.60','304.80','304.90','305.10','305.70','304.40','304.6')
					and b.DischargeDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('303.00','305.00','303.90','304.00','292.89','292.0','292.9','304.10','305.40','304.20','305.60',
					'304.30','305.20','304.50','305.30','305.90','304.60','304.80','304.90','305.10','305.70','304.40','304.6')
					and b.DischargeDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('303.00','305.00','303.90','304.00','292.89','292.0','292.9','304.10','305.40','304.20','305.60',
					'304.30','305.20','304.50','305.30','305.90','304.60','304.80','304.90','305.10','305.70','304.40','304.6')
					and b.EventDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('303.00','305.00','303.90','304.00','292.89','292.0','292.9','304.10','305.40','304.20','305.60',
					'304.30','305.20','304.50','305.30','305.90','304.60','304.80','304.90','305.10','305.70','304.40','304.6')
					and b.EventDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('303.00','305.00','303.90','304.00','292.89','292.0','292.9','304.10','305.40','304.20','305.60',
					'304.30','305.20','304.50','305.30','305.90','304.60','304.80','304.90','305.10','305.70','304.40','304.6')
					and b.EventDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('303.00','305.00','303.90','304.00','292.89','292.0','292.9','304.10','305.40','304.20','305.60',
					'304.30','305.20','304.50','305.30','305.90','304.60','304.80','304.90','305.10','305.70','304.40','304.6')
					and b.PatientTransferDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('303.00','305.00','303.90','304.00','292.89','292.0','292.9','304.10','305.40','304.20','305.60',
					'304.30','305.20','304.50','305.30','305.90','304.60','304.80','304.90','305.10','305.70','304.40','304.6')
					and b.SpecialtyTransferDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('303.00','305.00','303.90','304.00','292.89','292.0','292.9','304.10','305.40','304.20','305.60',
					'304.30','305.20','304.50','305.30','305.90','304.60','304.80','304.90','305.10','305.70','304.40','304.6')
					and b.AdmitDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.129','F10.229','F10.929','F10.10','F10.20','F11.10',
					'F11.10','F11.20','F11.129','F11.229','F11.929','F11.122','F11.222','F11.922','F11.23','F11.99',
					'F13.10','F13.20','F14.10','F14.20','F12.10','F12.20','F16.10','F16.20','F18.10','F18.20',
					'F19.10','F19.20','Z72.0','F17.200','F15.10','F15.20','F15.929')
and b.DischargeDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.129','F10.229','F10.929','F10.10','F10.20','F11.10',
					'F11.10','F11.20','F11.129','F11.229','F11.929','F11.122','F11.222','F11.922','F11.23','F11.99',
					'F13.10','F13.20','F14.10','F14.20','F12.10','F12.20','F16.10','F16.20','F18.10','F18.20',
					'F19.10','F19.20','Z72.0','F17.200','F15.10','F15.20','F15.929')
and b.DischargeDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.129','F10.229','F10.929','F10.10','F10.20','F11.10',
					'F11.10','F11.20','F11.129','F11.229','F11.929','F11.122','F11.222','F11.922','F11.23','F11.99',
					'F13.10','F13.20','F14.10','F14.20','F12.10','F12.20','F16.10','F16.20','F18.10','F18.20',
					'F19.10','F19.20','Z72.0','F17.200','F15.10','F15.20','F15.929')
and b.DischargeDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.129','F10.229','F10.929','F10.10','F10.20','F11.10',
					'F11.10','F11.20','F11.129','F11.229','F11.929','F11.122','F11.222','F11.922','F11.23','F11.99',
					'F13.10','F13.20','F14.10','F14.20','F12.10','F12.20','F16.10','F16.20','F18.10','F18.20',
					'F19.10','F19.20','Z72.0','F17.200','F15.10','F15.20','F15.929')
and b.EventDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.129','F10.229','F10.929','F10.10','F10.20','F11.10',
					'F11.10','F11.20','F11.129','F11.229','F11.929','F11.122','F11.222','F11.922','F11.23','F11.99',
					'F13.10','F13.20','F14.10','F14.20','F12.10','F12.20','F16.10','F16.20','F18.10','F18.20',
					'F19.10','F19.20','Z72.0','F17.200','F15.10','F15.20','F15.929')
and b.EventDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.129','F10.229','F10.929','F10.10','F10.20','F11.10',
					'F11.10','F11.20','F11.129','F11.229','F11.929','F11.122','F11.222','F11.922','F11.23','F11.99',
					'F13.10','F13.20','F14.10','F14.20','F12.10','F12.20','F16.10','F16.20','F18.10','F18.20',
					'F19.10','F19.20','Z72.0','F17.200','F15.10','F15.20','F15.929')
and b.EventDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)

union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.129','F10.229','F10.929','F10.10','F10.20','F11.10',
					'F11.10','F11.20','F11.129','F11.229','F11.929','F11.122','F11.222','F11.922','F11.23','F11.99',
					'F13.10','F13.20','F14.10','F14.20','F12.10','F12.20','F16.10','F16.20','F18.10','F18.20',
					'F19.10','F19.20','Z72.0','F17.200','F15.10','F15.20','F15.929')
and b.PatientTransferDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)

union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.129','F10.229','F10.929','F10.10','F10.20','F11.10',
					'F11.10','F11.20','F11.129','F11.229','F11.929','F11.122','F11.222','F11.922','F11.23','F11.99',
					'F13.10','F13.20','F14.10','F14.20','F12.10','F12.20','F16.10','F16.20','F18.10','F18.20',
					'F19.10','F19.20','Z72.0','F17.200','F15.10','F15.20','F15.929')
and b.SpecialtyTransferDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)

union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.129','F10.229','F10.929','F10.10','F10.20','F11.10',
					'F11.10','F11.20','F11.129','F11.229','F11.929','F11.122','F11.222','F11.922','F11.23','F11.99',
					'F13.10','F13.20','F14.10','F14.20','F12.10','F12.20','F16.10','F16.20','F18.10','F18.20',
					'F19.10','F19.20','Z72.0','F17.200','F15.10','F15.20','F15.929')
and b.AdmitDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)

Select distinct scrssn from Dflt.Diabetes_AF_DPP4GLP1_PolyAbuse --137

/*Depression */
/*Making sure the ICD9 and ICD10 codes relevant to depression are present in the Dimension table under CDWWork*/

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('296.20','296.22','296.23','296.30','296.32','296.33','300.00','311.','300.4','301.12','309.0','309.1')

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('F32.9','F32.1','F32.2','F33.1','F33.2','F41.9','F34.1','F43.21')

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime as comorbidity_Dischargedatettime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_AF_DPP4GLP1_Depression

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('296.20','296.22','296.23','296.30','296.32','296.33','300.00','311.','300.4','301.12','309.0','309.1')
					and b.DischargeDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('296.20','296.22','296.23','296.30','296.32','296.33','300.00','311.','300.4','301.12','309.0','309.1')
					and b.DischargeDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('296.20','296.22','296.23','296.30','296.32','296.33','300.00','311.','300.4','301.12','309.0','309.1')
					and b.DischargeDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('296.20','296.22','296.23','296.30','296.32','296.33','300.00','311.','300.4','301.12','309.0','309.1')
					and b.EventDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('296.20','296.22','296.23','296.30','296.32','296.33','300.00','311.','300.4','301.12','309.0','309.1')
					and b.EventDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('296.20','296.22','296.23','296.30','296.32','296.33','300.00','311.','300.4','301.12','309.0','309.1')
					and b.EventDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('296.20','296.22','296.23','296.30','296.32','296.33','300.00','311.','300.4','301.12','309.0','309.1')
					and b.PatientTransferDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('296.20','296.22','296.23','296.30','296.32','296.33','300.00','311.','300.4','301.12','309.0','309.1')
					and b.SpecialtyTransferDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('296.20','296.22','296.23','296.30','296.32','296.33','300.00','311.','300.4','301.12','309.0','309.1')
					and b.AdmitDateTime <= a.DPP4Filltime
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F32.9','F32.1','F32.2','F33.1','F33.2','F41.9','F34.1','F43.21') 
and b.DischargeDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F32.9','F32.1','F32.2','F33.1','F33.2','F41.9','F34.1','F43.21') 
and b.DischargeDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F32.9','F32.1','F32.2','F33.1','F33.2','F41.9','F34.1','F43.21') 
and b.DischargeDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F32.9','F32.1','F32.2','F33.1','F33.2','F41.9','F34.1','F43.21') 
and b.EventDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F32.9','F32.1','F32.2','F33.1','F33.2','F41.9','F34.1','F43.21') 
and b.EventDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F32.9','F32.1','F32.2','F33.1','F33.2','F41.9','F34.1','F43.21') 
and b.EventDateTime <= a.DPP4Filltime

union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F32.9','F32.1','F32.2','F33.1','F33.2','F41.9','F34.1','F43.21') 
and b.PatientTransferDateTime <= a.DPP4Filltime

union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F32.9','F32.1','F32.2','F33.1','F33.2','F41.9','F34.1','F43.21') 
and b.SpecialtyTransferDateTime <= a.DPP4Filltime

union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F32.9','F32.1','F32.2','F33.1','F33.2','F41.9','F34.1','F43.21') 
and b.AdmitDateTime <= a.DPP4Filltime

select distinct scrssn from Dflt.Diabetes_AF_DPP4GLP1_Depression --652

/* COPD Chronic Obstructive Pulmonary Disease*/
/*Making sure the ICD9 and ICD10 codes relevant to COPD are present in the Dimension table under CDWWork*/

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('490.','491.0','491.1','491.2','491.20','491.21','491.22','491.8','491.9','492.0','492.8',
'493.00','493.01','493.02','493.10','493.11','493.12','493.20','493.21','493.22','493.81','493.82','493.90','493.91','493.92',
'494.','494.0','494.1','495.0','495.1','495.2','495.3','495.4','495.5','495.6','495.7','495.8','495.9','496.')

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('J40.','J41.0','J41.1','J41.8','J42.','J43.9','J44.0','J44.1','J44.9',
'J45.20','J45.22','J45.21','J45.990','J45.991','J45.909','J45.998','J45.902','J45.901','J47.9','J47.1',
'J67.0','J67.1','J67.2','J67.3','J67.4','J67.5','J67.6','J67.7','J67.8','J67.9')


select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime as comorbidity_Dischargedatettime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_AF_DPP4GLP1_COPD

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('490.','491.0','491.1','491.2','491.20','491.21','491.22','491.8','491.9','492.0','492.8',
'493.00','493.01','493.02','493.10','493.11','493.12','493.20','493.21','493.22','493.81','493.82','493.90','493.91','493.92',
'494.','494.0','494.1','495.0','495.1','495.2','495.3','495.4','495.5','495.6','495.7','495.8','495.9','496.')
					and b.DischargeDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('490.','491.0','491.1','491.2','491.20','491.21','491.22','491.8','491.9','492.0','492.8',
'493.00','493.01','493.02','493.10','493.11','493.12','493.20','493.21','493.22','493.81','493.82','493.90','493.91','493.92',
'494.','494.0','494.1','495.0','495.1','495.2','495.3','495.4','495.5','495.6','495.7','495.8','495.9','496.')
					and b.DischargeDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('490.','491.0','491.1','491.2','491.20','491.21','491.22','491.8','491.9','492.0','492.8',
'493.00','493.01','493.02','493.10','493.11','493.12','493.20','493.21','493.22','493.81','493.82','493.90','493.91','493.92',
'494.','494.0','494.1','495.0','495.1','495.2','495.3','495.4','495.5','495.6','495.7','495.8','495.9','496.')
					and b.DischargeDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('490.','491.0','491.1','491.2','491.20','491.21','491.22','491.8','491.9','492.0','492.8',
'493.00','493.01','493.02','493.10','493.11','493.12','493.20','493.21','493.22','493.81','493.82','493.90','493.91','493.92',
'494.','494.0','494.1','495.0','495.1','495.2','495.3','495.4','495.5','495.6','495.7','495.8','495.9','496.')
					and b.EventDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('490.','491.0','491.1','491.2','491.20','491.21','491.22','491.8','491.9','492.0','492.8',
'493.00','493.01','493.02','493.10','493.11','493.12','493.20','493.21','493.22','493.81','493.82','493.90','493.91','493.92',
'494.','494.0','494.1','495.0','495.1','495.2','495.3','495.4','495.5','495.6','495.7','495.8','495.9','496.')
					and b.EventDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('490.','491.0','491.1','491.2','491.20','491.21','491.22','491.8','491.9','492.0','492.8',
'493.00','493.01','493.02','493.10','493.11','493.12','493.20','493.21','493.22','493.81','493.82','493.90','493.91','493.92',
'494.','494.0','494.1','495.0','495.1','495.2','495.3','495.4','495.5','495.6','495.7','495.8','495.9','496.')
					and b.EventDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('490.','491.0','491.1','491.2','491.20','491.21','491.22','491.8','491.9','492.0','492.8',
'493.00','493.01','493.02','493.10','493.11','493.12','493.20','493.21','493.22','493.81','493.82','493.90','493.91','493.92',
'494.','494.0','494.1','495.0','495.1','495.2','495.3','495.4','495.5','495.6','495.7','495.8','495.9','496.')
					and b.PatientTransferDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('490.','491.0','491.1','491.2','491.20','491.21','491.22','491.8','491.9','492.0','492.8',
'493.00','493.01','493.02','493.10','493.11','493.12','493.20','493.21','493.22','493.81','493.82','493.90','493.91','493.92',
'494.','494.0','494.1','495.0','495.1','495.2','495.3','495.4','495.5','495.6','495.7','495.8','495.9','496.')
					and b.SpecialtyTransferDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('490.','491.0','491.1','491.2','491.20','491.21','491.22','491.8','491.9','492.0','492.8',
'493.00','493.01','493.02','493.10','493.11','493.12','493.20','493.21','493.22','493.81','493.82','493.90','493.91','493.92',
'494.','494.0','494.1','495.0','495.1','495.2','495.3','495.4','495.5','495.6','495.7','495.8','495.9','496.')
					and b.AdmitDateTime <= a.DPP4Filltime
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F20.0','F20.1','F20.2','F20.3','F20.81','F20.89','F20.9','F25.9')
and b.DischargeDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('J40.','J41.0','J41.1','J41.8','J42.','J43.9','J44.0','J44.1','J44.9',
'J45.20','J45.22','J45.21','J45.990','J45.991','J45.909','J45.998','J45.902','J45.901','J47.9','J47.1',
'J67.0','J67.1','J67.2','J67.3','J67.4','J67.5','J67.6','J67.7','J67.8','J67.9')
and b.DischargeDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('J40.','J41.0','J41.1','J41.8','J42.','J43.9','J44.0','J44.1','J44.9',
'J45.20','J45.22','J45.21','J45.990','J45.991','J45.909','J45.998','J45.902','J45.901','J47.9','J47.1',
'J67.0','J67.1','J67.2','J67.3','J67.4','J67.5','J67.6','J67.7','J67.8','J67.9')
and b.DischargeDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('J40.','J41.0','J41.1','J41.8','J42.','J43.9','J44.0','J44.1','J44.9',
'J45.20','J45.22','J45.21','J45.990','J45.991','J45.909','J45.998','J45.902','J45.901','J47.9','J47.1',
'J67.0','J67.1','J67.2','J67.3','J67.4','J67.5','J67.6','J67.7','J67.8','J67.9')
and b.EventDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('J40.','J41.0','J41.1','J41.8','J42.','J43.9','J44.0','J44.1','J44.9',
'J45.20','J45.22','J45.21','J45.990','J45.991','J45.909','J45.998','J45.902','J45.901','J47.9','J47.1',
'J67.0','J67.1','J67.2','J67.3','J67.4','J67.5','J67.6','J67.7','J67.8','J67.9')
and b.EventDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('J40.','J41.0','J41.1','J41.8','J42.','J43.9','J44.0','J44.1','J44.9',
'J45.20','J45.22','J45.21','J45.990','J45.991','J45.909','J45.998','J45.902','J45.901','J47.9','J47.1',
'J67.0','J67.1','J67.2','J67.3','J67.4','J67.5','J67.6','J67.7','J67.8','J67.9')
and b.EventDateTime <= a.DPP4Filltime

union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('J40.','J41.0','J41.1','J41.8','J42.','J43.9','J44.0','J44.1','J44.9',
'J45.20','J45.22','J45.21','J45.990','J45.991','J45.909','J45.998','J45.902','J45.901','J47.9','J47.1',
'J67.0','J67.1','J67.2','J67.3','J67.4','J67.5','J67.6','J67.7','J67.8','J67.9')
and b.PatientTransferDateTime <= a.DPP4Filltime

union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('J40.','J41.0','J41.1','J41.8','J42.','J43.9','J44.0','J44.1','J44.9',
'J45.20','J45.22','J45.21','J45.990','J45.991','J45.909','J45.998','J45.902','J45.901','J47.9','J47.1',
'J67.0','J67.1','J67.2','J67.3','J67.4','J67.5','J67.6','J67.7','J67.8','J67.9')
and b.SpecialtyTransferDateTime <= a.DPP4Filltime

union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('J40.','J41.0','J41.1','J41.8','J42.','J43.9','J44.0','J44.1','J44.9',
'J45.20','J45.22','J45.21','J45.990','J45.991','J45.909','J45.998','J45.902','J45.901','J47.9','J47.1',
'J67.0','J67.1','J67.2','J67.3','J67.4','J67.5','J67.6','J67.7','J67.8','J67.9')
and b.AdmitDateTime <= a.DPP4Filltime

select distinct scrssn from Dflt.Diabetes_AF_DPP4GLP1_COPD --831

/* Chronic Liver Disease */
/*Making sure the ICD9 and ICD10 codes relevant to CLD are present in the Dimension table under CDWWork*/

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('B18.0','B18.1','B18.2','I85.00','I85.01','I85.10','I85.11','K70.0','K70.30','K70.9','K73.0','K73.2','K73.8','K73.9',
													'K75.4','K74.0','K74.60','K74.69','K74.3','K74.4','K74.5','K74.1','K76.0','K76.89','K76.9','K76.6','K72.10','K72.90','Z94.4')

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('070.22','070.32','070.23','070.33','070.44','070.54','456.1','456.0','456.21','456.20','571.0','571.2','571.3',
												'571.41','571.49','571.40','571.42','571.5','571.9','571.6','571.8','572.3','572.8','V42.7')

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime as comorbidity_Dischargedatettime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_AF_DPP4GLP1_LD

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('070.22','070.32','070.23','070.33','070.44','070.54','456.1','456.0','456.21','456.20','571.0','571.2','571.3',
					'571.41','571.49','571.40','571.42','571.5','571.9','571.6','571.8','572.3','572.8','V42.7')
					and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('070.22','070.32','070.23','070.33','070.44','070.54','456.1','456.0','456.21','456.20','571.0','571.2','571.3',
					'571.41','571.49','571.40','571.42','571.5','571.9','571.6','571.8','572.3','572.8','V42.7')
					and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('070.22','070.32','070.23','070.33','070.44','070.54','456.1','456.0','456.21','456.20','571.0','571.2','571.3',
					'571.41','571.49','571.40','571.42','571.5','571.9','571.6','571.8','572.3','572.8','V42.7')
					and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('070.22','070.32','070.23','070.33','070.44','070.54','456.1','456.0','456.21','456.20','571.0','571.2','571.3',
					'571.41','571.49','571.40','571.42','571.5','571.9','571.6','571.8','572.3','572.8','V42.7')
					and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('070.22','070.32','070.23','070.33','070.44','070.54','456.1','456.0','456.21','456.20','571.0','571.2','571.3',
					'571.41','571.49','571.40','571.42','571.5','571.9','571.6','571.8','572.3','572.8','V42.7')
					and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('070.22','070.32','070.23','070.33','070.44','070.54','456.1','456.0','456.21','456.20','571.0','571.2','571.3',
					'571.41','571.49','571.40','571.42','571.5','571.9','571.6','571.8','572.3','572.8','V42.7')
					and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('070.22','070.32','070.23','070.33','070.44','070.54','456.1','456.0','456.21','456.20','571.0','571.2','571.3',
					'571.41','571.49','571.40','571.42','571.5','571.9','571.6','571.8','572.3','572.8','V42.7')
					and b.PatientTransferDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('070.22','070.32','070.23','070.33','070.44','070.54','456.1','456.0','456.21','456.20','571.0','571.2','571.3',
					'571.41','571.49','571.40','571.42','571.5','571.9','571.6','571.8','572.3','572.8','V42.7')
					and b.SpecialtyTransferDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('070.22','070.32','070.23','070.33','070.44','070.54','456.1','456.0','456.21','456.20','571.0','571.2','571.3',
					'571.41','571.49','571.40','571.42','571.5','571.9','571.6','571.8','572.3','572.8','V42.7')
					and b.AdmitDateTime <= a.DPP4FillTime
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('B18.0','B18.1','B18.2','I85.00','I85.01','I85.10','I85.11','K70.0','K70.30','K70.9','K73.0','K73.2','K73.8','K73.9',
					'K75.4','K74.0','K74.60','K74.69','K74.3','K74.4','K74.5','K74.1','K76.0','K76.89','K76.9','K76.6','K72.10','K72.90','Z94.4')
and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('B18.0','B18.1','B18.2','I85.00','I85.01','I85.10','I85.11','K70.0','K70.30','K70.9','K73.0','K73.2','K73.8','K73.9',
					'K75.4','K74.0','K74.60','K74.69','K74.3','K74.4','K74.5','K74.1','K76.0','K76.89','K76.9','K76.6','K72.10','K72.90','Z94.4')
and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('B18.0','B18.1','B18.2','I85.00','I85.01','I85.10','I85.11','K70.0','K70.30','K70.9','K73.0','K73.2','K73.8','K73.9',
					'K75.4','K74.0','K74.60','K74.69','K74.3','K74.4','K74.5','K74.1','K76.0','K76.89','K76.9','K76.6','K72.10','K72.90','Z94.4') 
and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('B18.0','B18.1','B18.2','I85.00','I85.01','I85.10','I85.11','K70.0','K70.30','K70.9','K73.0','K73.2','K73.8','K73.9',
					'K75.4','K74.0','K74.60','K74.69','K74.3','K74.4','K74.5','K74.1','K76.0','K76.89','K76.9','K76.6','K72.10','K72.90','Z94.4')
and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('B18.0','B18.1','B18.2','I85.00','I85.01','I85.10','I85.11','K70.0','K70.30','K70.9','K73.0','K73.2','K73.8','K73.9',
					'K75.4','K74.0','K74.60','K74.69','K74.3','K74.4','K74.5','K74.1','K76.0','K76.89','K76.9','K76.6','K72.10','K72.90','Z94.4')
and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('B18.0','B18.1','B18.2','I85.00','I85.01','I85.10','I85.11','K70.0','K70.30','K70.9','K73.0','K73.2','K73.8','K73.9',
					'K75.4','K74.0','K74.60','K74.69','K74.3','K74.4','K74.5','K74.1','K76.0','K76.89','K76.9','K76.6','K72.10','K72.90','Z94.4')
and b.EventDateTime <= a.DPP4FillTime

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('B18.0','B18.1','B18.2','I85.00','I85.01','I85.10','I85.11','K70.0','K70.30','K70.9','K73.0','K73.2','K73.8','K73.9',
					'K75.4','K74.0','K74.60','K74.69','K74.3','K74.4','K74.5','K74.1','K76.0','K76.89','K76.9','K76.6','K72.10','K72.90','Z94.4')
and b.PatientTransferDateTime <= a.DPP4FillTime

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('B18.0','B18.1','B18.2','I85.00','I85.01','I85.10','I85.11','K70.0','K70.30','K70.9','K73.0','K73.2','K73.8','K73.9',
					'K75.4','K74.0','K74.60','K74.69','K74.3','K74.4','K74.5','K74.1','K76.0','K76.89','K76.9','K76.6','K72.10','K72.90','Z94.4')
and b.SpecialtyTransferDateTime <= a.DPP4FillTime

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('B18.0','B18.1','B18.2','I85.00','I85.01','I85.10','I85.11','K70.0','K70.30','K70.9','K73.0','K73.2','K73.8','K73.9',
					'K75.4','K74.0','K74.60','K74.69','K74.3','K74.4','K74.5','K74.1','K76.0','K76.89','K76.9','K76.6','K72.10','K72.90','Z94.4')
and b.AdmitDateTime <= a.DPP4FillTime

select distinct scrssn from Dflt.Diabetes_AF_DPP4GLP1_LD --172

/* Malignancy */
/*Making sure the ICD9 and ICD10 codes relevant to Malignancy are present in the Dimension table under CDWWork*/

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('196.0','196.1','196.2','196.3','196.5','196.6','196.8','196.9','197.0','197.1','197.2','197.3','197.4','197.5',
					'197.6','197.7','197.8','198.0','198.1','198.2','198.3','198.4','198.5','198.6','198.7','198.81','198.82','198.89','199.0','199.1')

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('C77.0','C77.1','C77.2','C77.3','C77.4','C77.5','C77.8','C77.9','C78.0','C78.1','C78.2','C78.3',
					'C78.4', 'C78.5','C78.6', 'C78.7', 'C78.89','C79.9','C79.11','C79.2','C79.31','C79.32','C79.49',
					'C79.51','C79.52','C79.60','C79.70','C79.81','C79.82','C79.89','C80.0','C80.1')

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime as comorbidity_Dischargedatettime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_AF_DPP4GLP1_Malignancy

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('196.0','196.1','196.2','196.3','196.5','196.6','196.8','196.9','197.0','197.1','197.2','197.3','197.4','197.5',
					'197.6','197.7','197.8','198.0','198.1','198.2','198.3','198.4','198.5','198.6','198.7','198.81','198.82','198.89','199.0','199.1')
					and b.DischargeDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('196.0','196.1','196.2','196.3','196.5','196.6','196.8','196.9','197.0','197.1','197.2','197.3','197.4','197.5',
					'197.6','197.7','197.8','198.0','198.1','198.2','198.3','198.4','198.5','198.6','198.7','198.81','198.82','198.89','199.0','199.1')
					and b.DischargeDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('196.0','196.1','196.2','196.3','196.5','196.6','196.8','196.9','197.0','197.1','197.2','197.3','197.4','197.5',
					'197.6','197.7','197.8','198.0','198.1','198.2','198.3','198.4','198.5','198.6','198.7','198.81','198.82','198.89','199.0','199.1')
					and b.DischargeDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('196.0','196.1','196.2','196.3','196.5','196.6','196.8','196.9','197.0','197.1','197.2','197.3','197.4','197.5',
					'197.6','197.7','197.8','198.0','198.1','198.2','198.3','198.4','198.5','198.6','198.7','198.81','198.82','198.89','199.0','199.1')
					and b.EventDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('196.0','196.1','196.2','196.3','196.5','196.6','196.8','196.9','197.0','197.1','197.2','197.3','197.4','197.5',
					'197.6','197.7','197.8','198.0','198.1','198.2','198.3','198.4','198.5','198.6','198.7','198.81','198.82','198.89','199.0','199.1')
					and b.EventDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('196.0','196.1','196.2','196.3','196.5','196.6','196.8','196.9','197.0','197.1','197.2','197.3','197.4','197.5',
					'197.6','197.7','197.8','198.0','198.1','198.2','198.3','198.4','198.5','198.6','198.7','198.81','198.82','198.89','199.0','199.1')
					and b.EventDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('196.0','196.1','196.2','196.3','196.5','196.6','196.8','196.9','197.0','197.1','197.2','197.3','197.4','197.5',
					'197.6','197.7','197.8','198.0','198.1','198.2','198.3','198.4','198.5','198.6','198.7','198.81','198.82','198.89','199.0','199.1')
					and b.PatientTransferDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('196.0','196.1','196.2','196.3','196.5','196.6','196.8','196.9','197.0','197.1','197.2','197.3','197.4','197.5',
					'197.6','197.7','197.8','198.0','198.1','198.2','198.3','198.4','198.5','198.6','198.7','198.81','198.82','198.89','199.0','199.1')
					and b.SpecialtyTransferDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('196.0','196.1','196.2','196.3','196.5','196.6','196.8','196.9','197.0','197.1','197.2','197.3','197.4','197.5',
					'197.6','197.7','197.8','198.0','198.1','198.2','198.3','198.4','198.5','198.6','198.7','198.81','198.82','198.89','199.0','199.1')
					and b.AdmitDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('C77.0','C77.1','C77.2','C77.3','C77.4','C77.5','C77.8','C77.9','C78.0','C78.1','C78.2','C78.3',
					'C78.4', 'C78.5','C78.6', 'C78.7', 'C78.89','C79.9','C79.11','C79.2','C79.31','C79.32','C79.49',
					'C79.51','C79.52','C79.60','C79.70','C79.81','C79.82','C79.89','C80.0','C80.1')
and b.DischargeDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('C77.0','C77.1','C77.2','C77.3','C77.4','C77.5','C77.8','C77.9','C78.0','C78.1','C78.2','C78.3',
					'C78.4', 'C78.5','C78.6', 'C78.7', 'C78.89','C79.9','C79.11','C79.2','C79.31','C79.32','C79.49',
					'C79.51','C79.52','C79.60','C79.70','C79.81','C79.82','C79.89','C80.0','C80.1')
and b.DischargeDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('C77.0','C77.1','C77.2','C77.3','C77.4','C77.5','C77.8','C77.9','C78.0','C78.1','C78.2','C78.3',
					'C78.4', 'C78.5','C78.6', 'C78.7', 'C78.89','C79.9','C79.11','C79.2','C79.31','C79.32','C79.49',
					'C79.51','C79.52','C79.60','C79.70','C79.81','C79.82','C79.89','C80.0','C80.1') 
and b.DischargeDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('C77.0','C77.1','C77.2','C77.3','C77.4','C77.5','C77.8','C77.9','C78.0','C78.1','C78.2','C78.3',
					'C78.4', 'C78.5','C78.6', 'C78.7', 'C78.89','C79.9','C79.11','C79.2','C79.31','C79.32','C79.49',
					'C79.51','C79.52','C79.60','C79.70','C79.81','C79.82','C79.89','C80.0','C80.1')
and b.EventDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('C77.0','C77.1','C77.2','C77.3','C77.4','C77.5','C77.8','C77.9','C78.0','C78.1','C78.2','C78.3',
					'C78.4', 'C78.5','C78.6', 'C78.7', 'C78.89','C79.9','C79.11','C79.2','C79.31','C79.32','C79.49',
					'C79.51','C79.52','C79.60','C79.70','C79.81','C79.82','C79.89','C80.0','C80.1')
and b.EventDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('C77.0','C77.1','C77.2','C77.3','C77.4','C77.5','C77.8','C77.9','C78.0','C78.1','C78.2','C78.3',
					'C78.4', 'C78.5','C78.6', 'C78.7', 'C78.89','C79.9','C79.11','C79.2','C79.31','C79.32','C79.49',
					'C79.51','C79.52','C79.60','C79.70','C79.81','C79.82','C79.89','C80.0','C80.1')
and b.EventDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)

union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('C77.0','C77.1','C77.2','C77.3','C77.4','C77.5','C77.8','C77.9','C78.0','C78.1','C78.2','C78.3',
					'C78.4', 'C78.5','C78.6', 'C78.7', 'C78.89','C79.9','C79.11','C79.2','C79.31','C79.32','C79.49',
					'C79.51','C79.52','C79.60','C79.70','C79.81','C79.82','C79.89','C80.0','C80.1')
and b.PatientTransferDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)

union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('C77.0','C77.1','C77.2','C77.3','C77.4','C77.5','C77.8','C77.9','C78.0','C78.1','C78.2','C78.3',
					'C78.4', 'C78.5','C78.6', 'C78.7', 'C78.89','C79.9','C79.11','C79.2','C79.31','C79.32','C79.49',
					'C79.51','C79.52','C79.60','C79.70','C79.81','C79.82','C79.89','C80.0','C80.1')
and b.SpecialtyTransferDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)

union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('C77.0','C77.1','C77.2','C77.3','C77.4','C77.5','C77.8','C77.9','C78.0','C78.1','C78.2','C78.3',
					'C78.4', 'C78.5','C78.6', 'C78.7', 'C78.89','C79.9','C79.11','C79.2','C79.31','C79.32','C79.49',
					'C79.51','C79.52','C79.60','C79.70','C79.81','C79.82','C79.89','C80.0','C80.1')
and b.AdmitDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)

select distinct scrssn from Dflt.Diabetes_AF_DPP4GLP1_Malignancy --17

/* Hypothyroidism */

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code like ('244.%')

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code like ('244.%')

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime as comorbidity_Dischargedatettime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_AF_DPP4GLP1_Hypo

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like ('244.%')
					and b.DischargeDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like ('244.%')
					and b.DischargeDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like ('244.%')
					and b.DischargeDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like ('244.%')
					and b.EventDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like ('244.%')
					and b.EventDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like ('244.%')
					and b.EventDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like ('244.%')
					and b.PatientTransferDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like ('244.%')
					and b.SpecialtyTransferDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like ('244.%')
					and b.AdmitDateTime <= a.DPP4Filltime
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like ('E03.%')
and b.DischargeDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like ('E03.%')
and b.DischargeDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like ('E03.%')
and b.DischargeDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like ('E03.%')
and b.EventDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like ('E03.%')
and b.EventDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like ('E03.%')
and b.EventDateTime <= a.DPP4Filltime

union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like ('E03.%')
and b.PatientTransferDateTime <= a.DPP4Filltime

union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like ('E03.%')
and b.SpecialtyTransferDateTime <= a.DPP4Filltime

union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like ('E03.%')
and b.AdmitDateTime <= a.DPP4Filltime

select distinct scrssn from Dflt.Diabetes_AF_DPP4GLP1_Hypo --271

/*Smoking */

select distinct a.*, b.SMOKE

into Dflt.Diabetes_AF_DPP4GLP1_Smoke

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.VASQIP_nso_noncardiac as b with (NOLOCK) on a.scrssn= b.scrssn 

select distinct scrssn from Dflt.Diabetes_AF_DPP4GLP1_Smoke where smoke = '1' --203

/*Prior Stroke */
/*Making sure the ICD9 and ICD10 codes relevant to Stroke are present in the Dimension table under CDWWork*/

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('I63.019','I63.119','I63.139','I63.20','I63.219','I63.22','I63.239','I63.30','I63.40','I63.50','I63.59')

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('433.21','433.11','433.91','433.01','434.01','434.11','434.91','433.31','433.81')

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime as comorbidity_Dischargedatettime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_AF_DPP4GLP1_Stroke

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('433.21','433.11','433.91','433.01','434.01','434.11','434.91','433.31','433.81')
					and b.DischargeDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('433.21','433.11','433.91','433.01','434.01','434.11','434.91','433.31','433.81')
					and b.DischargeDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('433.21','433.11','433.91','433.01','434.01','434.11','434.91','433.31','433.81')
					and b.DischargeDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('433.21','433.11','433.91','433.01','434.01','434.11','434.91','433.31','433.81')
					and b.EventDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('433.21','433.11','433.91','433.01','434.01','434.11','434.91','433.31','433.81')
					and b.EventDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('433.21','433.11','433.91','433.01','434.01','434.11','434.91','433.31','433.81')
					and b.EventDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('433.21','433.11','433.91','433.01','434.01','434.11','434.91','433.31','433.81')
					and b.PatientTransferDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('433.21','433.11','433.91','433.01','434.01','434.11','434.91','433.31','433.81')
					and b.SpecialtyTransferDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('433.21','433.11','433.91','433.01','434.01','434.11','434.91','433.31','433.81')
					and b.AdmitDateTime <= a.DPP4Filltime
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I63.019','I63.119','I63.139','I63.20','I63.219','I63.22','I63.239','I63.30','I63.40','I63.50','I63.59')
and b.DischargeDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I63.019','I63.119','I63.139','I63.20','I63.219','I63.22','I63.239','I63.30','I63.40','I63.50','I63.59')
and b.DischargeDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I63.019','I63.119','I63.139','I63.20','I63.219','I63.22','I63.239','I63.30','I63.40','I63.50','I63.59')
and b.DischargeDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I63.019','I63.119','I63.139','I63.20','I63.219','I63.22','I63.239','I63.30','I63.40','I63.50','I63.59')
and b.EventDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I63.019','I63.119','I63.139','I63.20','I63.219','I63.22','I63.239','I63.30','I63.40','I63.50','I63.59')
and b.EventDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I63.019','I63.119','I63.139','I63.20','I63.219','I63.22','I63.239','I63.30','I63.40','I63.50','I63.59')
and b.EventDateTime <= a.DPP4Filltime

union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I63.019','I63.119','I63.139','I63.20','I63.219','I63.22','I63.239','I63.30','I63.40','I63.50','I63.59')
and b.PatientTransferDateTime <= a.DPP4Filltime

union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I63.019','I63.119','I63.139','I63.20','I63.219','I63.22','I63.239','I63.30','I63.40','I63.50','I63.59')
and b.SpecialtyTransferDateTime <= a.DPP4Filltime

union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I63.019','I63.119','I63.139','I63.20','I63.219','I63.22','I63.239','I63.30','I63.40','I63.50','I63.59')
and b.AdmitDateTime <= a.DPP4Filltime

select distinct scrssn from Dflt.Diabetes_AF_DPP4GLP1_Stroke --71

/* Prior Myocardial Infarction */
/*Making sure the ICD9 and ICD10 codes relevant to Myocardial Infarction are present in the Dimension table under CDWWork*/

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('I21.01','I21.02','I21.19','I21.29','I21.3','I21.4','I21.9','I22.0','I22.1','I22.8','I22.9',
																	'I23.0','I23.1','I23.2','I23.3','I23.4','I23.5','I23.6','I23.7','I23.8','I24.0','I24.1','I24.8')

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('410.00','410.01','410.02','410.10','410.11','410.12','410.30','410.31','410.32','410.20','410.21','410.22',
														'410.40','410.41','410.42','410.50','410.51','410.52','410.60','410.61','410.62','410.80','410.81','410.82',
														'410.90','410.91','410.92','410.70','410.71','410.72','429.79','411.81','411.0','411.89')

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime as comorbidity_Dischargedatetime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_AF_DPP4GLP1_MI

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('410.00','410.01','410.02','410.10','410.11','410.12','410.30','410.31','410.32','410.20','410.21','410.22',
														'410.40','410.41','410.42','410.50','410.51','410.52','410.60','410.61','410.62','410.80','410.81','410.82',
														'410.90','410.91','410.92','410.70','410.71','410.72','429.79','411.81','411.0','411.89')
					and b.DischargeDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime , c.ICD9Code 

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('410.00','410.01','410.02','410.10','410.11','410.12','410.30','410.31','410.32','410.20','410.21','410.22',
														'410.40','410.41','410.42','410.50','410.51','410.52','410.60','410.61','410.62','410.80','410.81','410.82',
														'410.90','410.91','410.92','410.70','410.71','410.72','429.79','411.81','411.0','411.89')
					and b.DischargeDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('410.00','410.01','410.02','410.10','410.11','410.12','410.30','410.31','410.32','410.20','410.21','410.22',
														'410.40','410.41','410.42','410.50','410.51','410.52','410.60','410.61','410.62','410.80','410.81','410.82',
														'410.90','410.91','410.92','410.70','410.71','410.72','429.79','411.81','411.0','411.89')
					and b.DischargeDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('410.00','410.01','410.02','410.10','410.11','410.12','410.30','410.31','410.32','410.20','410.21','410.22',
														'410.40','410.41','410.42','410.50','410.51','410.52','410.60','410.61','410.62','410.80','410.81','410.82',
														'410.90','410.91','410.92','410.70','410.71','410.72','429.79','411.81','411.0','411.89')
					and b.EventDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('410.00','410.01','410.02','410.10','410.11','410.12','410.30','410.31','410.32','410.20','410.21','410.22',
														'410.40','410.41','410.42','410.50','410.51','410.52','410.60','410.61','410.62','410.80','410.81','410.82',
														'410.90','410.91','410.92','410.70','410.71','410.72','429.79','411.81','411.0','411.89')
					and b.EventDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('410.00','410.01','410.02','410.10','410.11','410.12','410.30','410.31','410.32','410.20','410.21','410.22',
														'410.40','410.41','410.42','410.50','410.51','410.52','410.60','410.61','410.62','410.80','410.81','410.82',
														'410.90','410.91','410.92','410.70','410.71','410.72','429.79','411.81','411.0','411.89')
					and b.EventDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('410.00','410.01','410.02','410.10','410.11','410.12','410.30','410.31','410.32','410.20','410.21','410.22',
														'410.40','410.41','410.42','410.50','410.51','410.52','410.60','410.61','410.62','410.80','410.81','410.82',
														'410.90','410.91','410.92','410.70','410.71','410.72','429.79','411.81','411.0','411.89')
					and b.PatientTransferDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('410.00','410.01','410.02','410.10','410.11','410.12','410.30','410.31','410.32','410.20','410.21','410.22',
														'410.40','410.41','410.42','410.50','410.51','410.52','410.60','410.61','410.62','410.80','410.81','410.82',
														'410.90','410.91','410.92','410.70','410.71','410.72','429.79','411.81','411.0','411.89')
				and b.SpecialtyTransferDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('410.00','410.01','410.02','410.10','410.11','410.12','410.30','410.31','410.32','410.20','410.21','410.22',
					'410.40','410.41','410.42','410.50','410.51','410.52','410.60','410.61','410.62','410.80','410.81','410.82',
					'410.90','410.91','410.92','410.70','410.71','410.72','429.79','411.81','411.0','411.89')
					and b.AdmitDateTime <= a.DPP4Filltime
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I21.01','I21.02','I21.19','I21.29','I21.3','I21.4','I21.9','I22.0','I22.1','I22.8','I22.9',
					'I23.0','I23.1','I23.2','I23.3','I23.4','I23.5','I23.6','I23.7','I23.8','I24.0','I24.1','I24.8')
and b.DischargeDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I21.01','I21.02','I21.19','I21.29','I21.3','I21.4','I21.9','I22.0','I22.1','I22.8','I22.9',
					'I23.0','I23.1','I23.2','I23.3','I23.4','I23.5','I23.6','I23.7','I23.8','I24.0','I24.1','I24.8')
and b.DischargeDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I21.01','I21.02','I21.19','I21.29','I21.3','I21.4','I21.9','I22.0','I22.1','I22.8','I22.9',
					'I23.0','I23.1','I23.2','I23.3','I23.4','I23.5','I23.6','I23.7','I23.8','I24.0','I24.1','I24.8')
and b.DischargeDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I21.01','I21.02','I21.19','I21.29','I21.3','I21.4','I21.9','I22.0','I22.1','I22.8','I22.9',
					'I23.0','I23.1','I23.2','I23.3','I23.4','I23.5','I23.6','I23.7','I23.8','I24.0','I24.1','I24.8')
and b.EventDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I21.01','I21.02','I21.19','I21.29','I21.3','I21.4','I21.9','I22.0','I22.1','I22.8','I22.9',
					'I23.0','I23.1','I23.2','I23.3','I23.4','I23.5','I23.6','I23.7','I23.8','I24.0','I24.1','I24.8')
and b.EventDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I21.01','I21.02','I21.19','I21.29','I21.3','I21.4','I21.9','I22.0','I22.1','I22.8','I22.9',
					'I23.0','I23.1','I23.2','I23.3','I23.4','I23.5','I23.6','I23.7','I23.8','I24.0','I24.1','I24.8')
and b.EventDateTime <= a.DPP4Filltime

union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I21.01','I21.02','I21.19','I21.29','I21.3','I21.4','I21.9','I22.0','I22.1','I22.8','I22.9',
					'I23.0','I23.1','I23.2','I23.3','I23.4','I23.5','I23.6','I23.7','I23.8','I24.0','I24.1','I24.8')
and b.PatientTransferDateTime <= a.DPP4Filltime

union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I21.01','I21.02','I21.19','I21.29','I21.3','I21.4','I21.9','I22.0','I22.1','I22.8','I22.9',
					'I23.0','I23.1','I23.2','I23.3','I23.4','I23.5','I23.6','I23.7','I23.8','I24.0','I24.1','I24.8')
and b.SpecialtyTransferDateTime <= a.DPP4Filltime

union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I21.01','I21.02','I21.19','I21.29','I21.3','I21.4','I21.9','I22.0','I22.1','I22.8','I22.9',
					'I23.0','I23.1','I23.2','I23.3','I23.4','I23.5','I23.6','I23.7','I23.8','I24.0','I24.1','I24.8')
and b.AdmitDateTime <= a.DPP4Filltime

Select distinct scrssn from Dflt.Diabetes_AF_DPP4GLP1_MI --324

/*Ablation*/
/*Making sure the CPT codes relevant to Ablation are present in the Dimension table under CDWWork*/

select distinct CPTCode from CDWWork.Dim.CPT where CPTCode in ('93656','93657','93662','33254','33255','33258','33265','33266')

select distinct a.*

into Dflt.Diabetes_AF_DPP4GLP1_Ablation

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientCPTProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
Src.Cohort_CPT as c with (NOLOCK) on c.CPTSID=b.cptSID 
where c.cptcode in ('93656','93657','93662','33254','33255','33258','33265','33266')
and b.DischargeDateTime <= a.DPP4Filltime
union all

select distinct a.*
from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_Vprocedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
Src.Cohort_CPT as c with (NOLOCK) on c.CPTSID=b.cptSID 
where c.cptcode in ('93656','93657','93662','33254','33255','33258','33265','33266')
and b.EventDateTime <= a.DPP4Filltime
union all 

select distinct a.*
from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_VProcedure_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
Src.Cohort_CPT as c with (NOLOCK) on c.CPTSID=b.cptSID 
where c.cptcode in ('93656','93657','93662','33254','33255','33258','33265','33266')
and b.EventDateTime <= a.DPP4Filltime
union all

select distinct a.*
from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Surg_SurgeryPrincipalAssociatedProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on b.OtherProcedureCPTSID=c.cptSID 
where c.cptcode in ('93656','93657','93662','33254','33255','33258','33265','33266') 
and b.SurgeryDateTime <= a.DPP4Filltime
union all

select distinct a.*
from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Surg_SurgeryProcedureDiagnosisCode as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on b.PrincipalCPTSID=c.cptSID 
where c.cptcode in ('93656','93657','93662','33254','33255','33258','33265','33266')
and b.SurgeryDateTime <= a.DPP4Filltime
union all

select distinct a.*
from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_VProcedureCPTModifier as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on b.CPTSID=c.cptSID 
where c.cptcode in ('93656','93657','93662','33254','33255','33258','33265','33266')
and b.visitdatetime <= a.DPP4Filltime
union all

select distinct a.*
from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_VProcedureDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on b.CPTSID=c.cptSID 
where c.cptcode in ('93656','93657','93662','33254','33255','33258','33265','33266')
and b.EventDateTime <= a.DPP4Filltime
union all

select distinct a.*
from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on b.CPTSID=c.cptSID 
where c.cptcode in ('93656','93657','93662','33254','33255','33258','33265','33266')
and b.EventDateTime <= a.DPP4Filltime
union all

select distinct a.*
from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVProcedureCPTModifier as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on  b.CPTSID=c.cptSID 
where c.cptcode in ('93656','93657','93662','33254','33255','33258','33265','33266')
and b.VisitDateTime <= a.DPP4Filltime

select distinct scrssn from Dflt.Diabetes_AF_DPP4GLP1_Ablation --26

/* CAD */

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime as comorbidity_Dischargedatettime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_AF_DPP4GLP1_CAD

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('411.00''411.10','411.81','411.89','413.00','413.90','414.00','414.01','414.02','414.03','414.04',
'414.05','414.06','414.20','414.30','414.40','414.80','414.90','V45.81','V45.82')
					and b.DischargeDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('411.00''411.10','411.81','411.89','413.00','413.90','414.00','414.01','414.02','414.03','414.04',
'414.05','414.06','414.20','414.30','414.40','414.80','414.90','V45.81','V45.82')
					and b.DischargeDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('411.00''411.10','411.81','411.89','413.00','413.90','414.00','414.01','414.02','414.03','414.04',
'414.05','414.06','414.20','414.30','414.40','414.80','414.90','V45.81','V45.82')
					and b.DischargeDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('411.00''411.10','411.81','411.89','413.00','413.90','414.00','414.01','414.02','414.03','414.04',
'414.05','414.06','414.20','414.30','414.40','414.80','414.90','V45.81','V45.82')
					and b.EventDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('411.00''411.10','411.81','411.89','413.00','413.90','414.00','414.01','414.02','414.03','414.04',
'414.05','414.06','414.20','414.30','414.40','414.80','414.90','V45.81','V45.82')
					and b.EventDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('411.00''411.10','411.81','411.89','413.00','413.90','414.00','414.01','414.02','414.03','414.04',
'414.05','414.06','414.20','414.30','414.40','414.80','414.90','V45.81','V45.82')
					and b.EventDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('411.00''411.10','411.81','411.89','413.00','413.90','414.00','414.01','414.02','414.03','414.04',
'414.05','414.06','414.20','414.30','414.40','414.80','414.90','V45.81','V45.82')
					and b.PatientTransferDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('411.00''411.10','411.81','411.89','413.00','413.90','414.00','414.01','414.02','414.03','414.04',
'414.05','414.06','414.20','414.30','414.40','414.80','414.90','V45.81','V45.82')
					and b.SpecialtyTransferDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('411.00''411.10','411.81','411.89','413.00','413.90','414.00','414.01','414.02','414.03','414.04',
'414.05','414.06','414.20','414.30','414.40','414.80','414.90','V45.81','V45.82')
					and b.AdmitDateTime <= a.DPP4Filltime
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I24.1','I20.0','I24.0','I24.8','I28.0','I20.8','I20.9','I25.0','I25.10','I25.810','I25.811',
'I25.82','I25.83','I25.84','I25.5','I25.9','I25.89','Z95.1','Z98.61')
and b.DischargeDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I24.1','I20.0','I24.0','I24.8','I28.0','I20.8','I20.9','I25.0','I25.10','I25.810','I25.811',
'I25.82','I25.83','I25.84','I25.5','I25.9','I25.89','Z95.1','Z98.61')
and b.DischargeDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I24.1','I20.0','I24.0','I24.8','I28.0','I20.8','I20.9','I25.0','I25.10','I25.810','I25.811',
'I25.82','I25.83','I25.84','I25.5','I25.9','I25.89','Z95.1','Z98.61')
and b.DischargeDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I24.1','I20.0','I24.0','I24.8','I28.0','I20.8','I20.9','I25.0','I25.10','I25.810','I25.811',
'I25.82','I25.83','I25.84','I25.5','I25.9','I25.89','Z95.1','Z98.61')
and b.EventDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I24.1','I20.0','I24.0','I24.8','I28.0','I20.8','I20.9','I25.0','I25.10','I25.810','I25.811',
'I25.82','I25.83','I25.84','I25.5','I25.9','I25.89','Z95.1','Z98.61')
and b.EventDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I24.1','I20.0','I24.0','I24.8','I28.0','I20.8','I20.9','I25.0','I25.10','I25.810','I25.811',
'I25.82','I25.83','I25.84','I25.5','I25.9','I25.89','Z95.1','Z98.61')
and b.EventDateTime <= a.DPP4Filltime

union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I24.1','I20.0','I24.0','I24.8','I28.0','I20.8','I20.9','I25.0','I25.10','I25.810','I25.811',
'I25.82','I25.83','I25.84','I25.5','I25.9','I25.89','Z95.1','Z98.61')
and b.PatientTransferDateTime <= a.DPP4Filltime

union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I24.1','I20.0','I24.0','I24.8','I28.0','I20.8','I20.9','I25.0','I25.10','I25.810','I25.811',
'I25.82','I25.83','I25.84','I25.5','I25.9','I25.89','Z95.1','Z98.61')
and b.SpecialtyTransferDateTime <= a.DPP4Filltime

union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I24.1','I20.0','I24.0','I24.8','I28.0','I20.8','I20.9','I25.0','I25.10','I25.810','I25.811',
'I25.82','I25.83','I25.84','I25.5','I25.9','I25.89','Z95.1','Z98.61')
and b.AdmitDateTime <= a.DPP4Filltime

select distinct scrssn from Dflt.Diabetes_AF_DPP4GLP1_CAD --1179

/* PAD */

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime as comorbidity_Dischargedatettime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_AF_DPP4GLP1_PAD

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('440.0','440.0','440.1','440.2','440.20','440.21','440.22','440.23','440.24','440.29','440.30',
                    '440.31','440.32','440.4','440.8','440.9','441.0','441.00','441.01','441.02','441.03','441.1','441.2',
					'441.3','441.4','441.5','441.6','441.7','441.9','442.0','442.1','442.2','442.3','442.81','442.82',
					'442.83','442.84','442.89','442.9','443.0','443.1','443.21','443.22','443.23','443.24','443.29')
					and b.DischargeDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('440.0','440.0','440.1','440.2','440.20','440.21','440.22','440.23','440.24','440.29','440.30',
                    '440.31','440.32','440.4','440.8','440.9','441.0','441.00','441.01','441.02','441.03','441.1','441.2',
					'441.3','441.4','441.5','441.6','441.7','441.9','442.0','442.1','442.2','442.3','442.81','442.82',
					'442.83','442.84','442.89','442.9','443.0','443.1','443.21','443.22','443.23','443.24','443.29')
					and b.DischargeDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('440.0','440.0','440.1','440.2','440.20','440.21','440.22','440.23','440.24','440.29','440.30',
                    '440.31','440.32','440.4','440.8','440.9','441.0','441.00','441.01','441.02','441.03','441.1','441.2',
					'441.3','441.4','441.5','441.6','441.7','441.9','442.0','442.1','442.2','442.3','442.81','442.82',
					'442.83','442.84','442.89','442.9','443.0','443.1','443.21','443.22','443.23','443.24','443.29')
					and b.DischargeDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('440.0','440.0','440.1','440.2','440.20','440.21','440.22','440.23','440.24','440.29','440.30',
                    '440.31','440.32','440.4','440.8','440.9','441.0','441.00','441.01','441.02','441.03','441.1','441.2',
					'441.3','441.4','441.5','441.6','441.7','441.9','442.0','442.1','442.2','442.3','442.81','442.82',
					'442.83','442.84','442.89','442.9','443.0','443.1','443.21','443.22','443.23','443.24','443.29')
					and b.EventDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('440.0','440.0','440.1','440.2','440.20','440.21','440.22','440.23','440.24','440.29','440.30',
                    '440.31','440.32','440.4','440.8','440.9','441.0','441.00','441.01','441.02','441.03','441.1','441.2',
					'441.3','441.4','441.5','441.6','441.7','441.9','442.0','442.1','442.2','442.3','442.81','442.82',
					'442.83','442.84','442.89','442.9','443.0','443.1','443.21','443.22','443.23','443.24','443.29')
					and b.EventDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('440.0','440.0','440.1','440.2','440.20','440.21','440.22','440.23','440.24','440.29','440.30',
                    '440.31','440.32','440.4','440.8','440.9','441.0','441.00','441.01','441.02','441.03','441.1','441.2',
					'441.3','441.4','441.5','441.6','441.7','441.9','442.0','442.1','442.2','442.3','442.81','442.82',
					'442.83','442.84','442.89','442.9','443.0','443.1','443.21','443.22','443.23','443.24','443.29')
					and b.EventDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('440.0','440.0','440.1','440.2','440.20','440.21','440.22','440.23','440.24','440.29','440.30',
                    '440.31','440.32','440.4','440.8','440.9','441.0','441.00','441.01','441.02','441.03','441.1','441.2',
					'441.3','441.4','441.5','441.6','441.7','441.9','442.0','442.1','442.2','442.3','442.81','442.82',
					'442.83','442.84','442.89','442.9','443.0','443.1','443.21','443.22','443.23','443.24','443.29')
					and b.PatientTransferDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('440.0','440.0','440.1','440.2','440.20','440.21','440.22','440.23','440.24','440.29','440.30',
                    '440.31','440.32','440.4','440.8','440.9','441.0','441.00','441.01','441.02','441.03','441.1','441.2',
					'441.3','441.4','441.5','441.6','441.7','441.9','442.0','442.1','442.2','442.3','442.81','442.82',
					'442.83','442.84','442.89','442.9','443.0','443.1','443.21','443.22','443.23','443.24','443.29')
					and b.SpecialtyTransferDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('440.0','440.0','440.1','440.2','440.20','440.21','440.22','440.23','440.24','440.29','440.30',
                    '440.31','440.32','440.4','440.8','440.9','441.0','441.00','441.01','441.02','441.03','441.1','441.2',
					'441.3','441.4','441.5','441.6','441.7','441.9','442.0','442.1','442.2','442.3','442.81','442.82',
					'442.83','442.84','442.89','442.9','443.0','443.1','443.21','443.22','443.23','443.24','443.29')
					and b.AdmitDateTime <= a.DPP4Filltime
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I70.0','I70.1','I70.209','I70.219','I70.229','I70.25','I70.269','I70.299','I70.399','I70.499','I70.599','I70.92','I70.8','I70.90',
                    'I71.00','I71.01','I71.02','I71.03','I71.1','I71.2','I71.3','I71.4','I71.5','I71.6','I71.8','I71.9','I72.0','I72.1','I72.2','I72.3',
					'I72.4','I72.5','I72.6','I72.8','I72.9','I73.00','I73.01','I73.1','I73.81','I73.89','I73.9','I77.1','I77.71','I77.72','I77.73','I77.74',
					'I77.75','I77.76','I77.77','I77.79','I79.8','K55.1','K55.9','Z95.828')
and b.DischargeDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I70.0','I70.1','I70.209','I70.219','I70.229','I70.25','I70.269','I70.299','I70.399','I70.499','I70.599','I70.92','I70.8','I70.90',
                    'I71.00','I71.01','I71.02','I71.03','I71.1','I71.2','I71.3','I71.4','I71.5','I71.6','I71.8','I71.9','I72.0','I72.1','I72.2','I72.3',
					'I72.4','I72.5','I72.6','I72.8','I72.9','I73.00','I73.01','I73.1','I73.81','I73.89','I73.9','I77.1','I77.71','I77.72','I77.73','I77.74',
					'I77.75','I77.76','I77.77','I77.79','I79.8','K55.1','K55.9','Z95.828')
and b.DischargeDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I70.0','I70.1','I70.209','I70.219','I70.229','I70.25','I70.269','I70.299','I70.399','I70.499','I70.599','I70.92','I70.8','I70.90',
                    'I71.00','I71.01','I71.02','I71.03','I71.1','I71.2','I71.3','I71.4','I71.5','I71.6','I71.8','I71.9','I72.0','I72.1','I72.2','I72.3',
					'I72.4','I72.5','I72.6','I72.8','I72.9','I73.00','I73.01','I73.1','I73.81','I73.89','I73.9','I77.1','I77.71','I77.72','I77.73','I77.74',
					'I77.75','I77.76','I77.77','I77.79','I79.8','K55.1','K55.9','Z95.828')
and b.DischargeDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I70.0','I70.1','I70.209','I70.219','I70.229','I70.25','I70.269','I70.299','I70.399','I70.499','I70.599','I70.92','I70.8','I70.90',
                    'I71.00','I71.01','I71.02','I71.03','I71.1','I71.2','I71.3','I71.4','I71.5','I71.6','I71.8','I71.9','I72.0','I72.1','I72.2','I72.3',
					'I72.4','I72.5','I72.6','I72.8','I72.9','I73.00','I73.01','I73.1','I73.81','I73.89','I73.9','I77.1','I77.71','I77.72','I77.73','I77.74',
					'I77.75','I77.76','I77.77','I77.79','I79.8','K55.1','K55.9','Z95.828')
and b.EventDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I70.0','I70.1','I70.209','I70.219','I70.229','I70.25','I70.269','I70.299','I70.399','I70.499','I70.599','I70.92','I70.8','I70.90',
                    'I71.00','I71.01','I71.02','I71.03','I71.1','I71.2','I71.3','I71.4','I71.5','I71.6','I71.8','I71.9','I72.0','I72.1','I72.2','I72.3',
					'I72.4','I72.5','I72.6','I72.8','I72.9','I73.00','I73.01','I73.1','I73.81','I73.89','I73.9','I77.1','I77.71','I77.72','I77.73','I77.74',
					'I77.75','I77.76','I77.77','I77.79','I79.8','K55.1','K55.9','Z95.828')
and b.EventDateTime <= a.DPP4Filltime
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I70.0','I70.1','I70.209','I70.219','I70.229','I70.25','I70.269','I70.299','I70.399','I70.499','I70.599','I70.92','I70.8','I70.90',
                    'I71.00','I71.01','I71.02','I71.03','I71.1','I71.2','I71.3','I71.4','I71.5','I71.6','I71.8','I71.9','I72.0','I72.1','I72.2','I72.3',
					'I72.4','I72.5','I72.6','I72.8','I72.9','I73.00','I73.01','I73.1','I73.81','I73.89','I73.9','I77.1','I77.71','I77.72','I77.73','I77.74',
					'I77.75','I77.76','I77.77','I77.79','I79.8','K55.1','K55.9','Z95.828')
and b.EventDateTime <= a.DPP4Filltime

union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I70.0','I70.1','I70.209','I70.219','I70.229','I70.25','I70.269','I70.299','I70.399','I70.499','I70.599','I70.92','I70.8','I70.90',
                    'I71.00','I71.01','I71.02','I71.03','I71.1','I71.2','I71.3','I71.4','I71.5','I71.6','I71.8','I71.9','I72.0','I72.1','I72.2','I72.3',
					'I72.4','I72.5','I72.6','I72.8','I72.9','I73.00','I73.01','I73.1','I73.81','I73.89','I73.9','I77.1','I77.71','I77.72','I77.73','I77.74',
					'I77.75','I77.76','I77.77','I77.79','I79.8','K55.1','K55.9','Z95.828')
and b.PatientTransferDateTime <= a.DPP4Filltime

union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I70.0','I70.1','I70.209','I70.219','I70.229','I70.25','I70.269','I70.299','I70.399','I70.499','I70.599','I70.92','I70.8','I70.90',
                    'I71.00','I71.01','I71.02','I71.03','I71.1','I71.2','I71.3','I71.4','I71.5','I71.6','I71.8','I71.9','I72.0','I72.1','I72.2','I72.3',
					'I72.4','I72.5','I72.6','I72.8','I72.9','I73.00','I73.01','I73.1','I73.81','I73.89','I73.9','I77.1','I77.71','I77.72','I77.73','I77.74',
					'I77.75','I77.76','I77.77','I77.79','I79.8','K55.1','K55.9','Z95.828')
and b.SpecialtyTransferDateTime <= a.DPP4Filltime

union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I70.0','I70.1','I70.209','I70.219','I70.229','I70.25','I70.269','I70.299','I70.399','I70.499','I70.599','I70.92','I70.8','I70.90',
                    'I71.00','I71.01','I71.02','I71.03','I71.1','I71.2','I71.3','I71.4','I71.5','I71.6','I71.8','I71.9','I72.0','I72.1','I72.2','I72.3',
					'I72.4','I72.5','I72.6','I72.8','I72.9','I73.00','I73.01','I73.1','I73.81','I73.89','I73.9','I77.1','I77.71','I77.72','I77.73','I77.74',
					'I77.75','I77.76','I77.77','I77.79','I79.8','K55.1','K55.9','Z95.828')
and b.AdmitDateTime <= a.DPP4Filltime

select distinct scrssn from Dflt.Diabetes_AF_DPP4GLP1_PAD --331

/*Cardioversion*/

/*Making sure the CPT codes relevant to Cardioversion are present in the Dimension table under CDWWork*/

select distinct CPTCode from CDWWork.Dim.CPT where CPTCode in ('92960','92961')

select distinct a.*

into Dflt.Diabetes_AF_DPP4GLP1_CV

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientCPTProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
Src.Cohort_CPT as c with (NOLOCK) on c.CPTSID=b.cptSID 
where c.cptcode in ('92960','92961')
union all

select distinct a.*
from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_Vprocedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
Src.Cohort_CPT as c with (NOLOCK) on c.CPTSID=b.cptSID 
where c.cptcode in ('92960','92961')
union all 

select distinct a.*
from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_VProcedure_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
Src.Cohort_CPT as c with (NOLOCK) on c.CPTSID=b.cptSID 
where c.cptcode in ('92960','92961')
union all

select distinct a.*
from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Surg_SurgeryPrincipalAssociatedProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on b.OtherProcedureCPTSID=c.cptSID 
where c.cptcode in ('92960','92961')
union all

select distinct a.*
from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Surg_SurgeryProcedureDiagnosisCode as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on b.PrincipalCPTSID=c.cptSID 
where c.cptcode in ('92960','92961')
union all

select distinct a.*
from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_VProcedureCPTModifier as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on b.CPTSID=c.cptSID 
where c.cptcode in ('92960','92961')
union all

select distinct a.*
from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_VProcedureDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on b.CPTSID=c.cptSID 
where c.cptcode in ('92960','92961')
union all

select distinct a.*
from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on b.CPTSID=c.cptSID 
where c.cptcode in ('92960','92961')
union all

select distinct a.*
from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVProcedureCPTModifier as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on  b.CPTSID=c.cptSID 
where c.cptcode in ('92960','92961')

select * from Src.distinct_CPTCodes where ProcCode in ('92960','92961')

drop table Dflt.Diabetes_AF_DPP4GLP1_CV

/* Cardioversion Proc codes */

select distinct ICD9ProcedureCode from CDWWork.Dim.ICD9Procedure where ICD9ProcedureCode in ('99.61','99.62') 
select distinct ICD10ProcedureCode from CDWWork.Dim.ICD10Procedure where ICD10ProcedureCode in ('5A2204Z') 

select distinct a.*, b.ICDProcedureDateTime, c.ICD9ProcedureCode
/*ICD9Procedure Codes*/

into Dflt.Diabetes_AF_DPP4GLP1_CV

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_CensusICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('99.61','99.62')
					and b.ICDProcedureDateTime <= a.DPP4Filltime
union all

select distinct a.*, b.SurgicalProcedureDateTime, c.ICD9ProcedureCode

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_CensusSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('99.61','99.62')
					and b.SurgicalProcedureDateTime <= a.DPP4Filltime
union all

select distinct a.*, b.DischargeDateTime, c.ICD9ProcedureCode

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('99.61','99.62')
					and b.DischargeDateTime <= a.DPP4Filltime
union all

select distinct a.*, b.DischargeDateTime, c.ICD9ProcedureCode

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('99.61','99.62')
					and b.DischargeDateTime <= a.DPP4Filltime
union all

/*ICD10Procedure Codes*/
select distinct a.*, b.ICDProcedureDateTime, c.ICD10ProcedureCode

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_CensusICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('5A2204Z')
and b.ICDProcedureDateTime <= a.DPP4Filltime
union all

select distinct a.*, b.SurgicalProcedureDateTime, c.ICD10ProcedureCode

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_CensusSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('5A2204Z')
and b.SurgicalProcedureDateTime <= a.DPP4Filltime
union all

select distinct a.*, b.DischargeDateTime, c.ICD10ProcedureCode

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('5A2204Z')
and b.DischargeDateTime <= a.DPP4Filltime
union all

select distinct a.*, b.DischargeDateTime, c.ICD10ProcedureCode

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('5A2204Z')
and b.DischargeDateTime <= a.DPP4Filltime

select distinct scrssn from Dflt.Diabetes_AF_DPP4GLP1_CV --313

/* Ablation Proc codes */

select distinct ICD9ProcedureCode from CDWWork.Dim.ICD9Procedure where ICD9ProcedureCode in ('37.33','37.34','37.37','37.80','38.65') 
select distinct ICD10ProcedureCode from CDWWork.Dim.ICD10Procedure where ICD10ProcedureCode in ('02560ZZ','02563ZZ','02564ZZ',
'02570ZZ','02573ZZ','02574ZZ','02580ZZ','02583ZZ','02584ZZ','025S0ZZ','025S3ZZ','025S4ZZ','025T0ZZ','025T3ZZ','025T4ZZ') 

select distinct a.*, b.ICDProcedureDateTime, c.ICD9ProcedureCode
/*ICD9Procedure Codes*/

into Dflt.Diabetes_AF_DPP4GLP1_AbProc

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_CensusICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('37.33','37.34','37.37','37.80','38.65')
					and b.ICDProcedureDateTime <= a.DPP4Filltime
union all

select distinct a.*, b.SurgicalProcedureDateTime, c.ICD9ProcedureCode

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_CensusSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('37.33','37.34','37.37','37.80','38.65')
					and b.SurgicalProcedureDateTime <= a.DPP4Filltime
union all

select distinct a.*, b.DischargeDateTime, c.ICD9ProcedureCode

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('37.33','37.34','37.37','37.80','38.65')
					and b.DischargeDateTime <= a.DPP4Filltime
union all

select distinct a.*, b.DischargeDateTime, c.ICD9ProcedureCode

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('37.33','37.34','37.37','37.80','38.65')
					and b.DischargeDateTime <= a.DPP4Filltime
union all

/*ICD10Procedure Codes*/
select distinct a.*, b.ICDProcedureDateTime, c.ICD10ProcedureCode

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_CensusICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('02560ZZ','02563ZZ','02564ZZ',
'02570ZZ','02573ZZ','02574ZZ','02580ZZ','02583ZZ','02584ZZ','025S0ZZ','025S3ZZ','025S4ZZ','025T0ZZ','025T3ZZ','025T4ZZ')
and b.ICDProcedureDateTime <= a.DPP4Filltime
union all

select distinct a.*, b.SurgicalProcedureDateTime, c.ICD10ProcedureCode

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_CensusSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('02560ZZ','02563ZZ','02564ZZ',
'02570ZZ','02573ZZ','02574ZZ','02580ZZ','02583ZZ','02584ZZ','025S0ZZ','025S3ZZ','025S4ZZ','025T0ZZ','025T3ZZ','025T4ZZ')
and b.SurgicalProcedureDateTime <= a.DPP4Filltime
union all

select distinct a.*, b.DischargeDateTime, c.ICD10ProcedureCode

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('02560ZZ','02563ZZ','02564ZZ',
'02570ZZ','02573ZZ','02574ZZ','02580ZZ','02583ZZ','02584ZZ','025S0ZZ','025S3ZZ','025S4ZZ','025T0ZZ','025T3ZZ','025T4ZZ')
and b.DischargeDateTime <= a.DPP4Filltime
union all

select distinct a.*, b.DischargeDateTime, c.ICD10ProcedureCode

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('02560ZZ','02563ZZ','02564ZZ',
'02570ZZ','02573ZZ','02574ZZ','02580ZZ','02583ZZ','02584ZZ','025S0ZZ','025S3ZZ','025S4ZZ','025T0ZZ','025T3ZZ','025T4ZZ')
and b.DischargeDateTime <= a.DPP4Filltime

select distinct scrssn from Dflt.Diabetes_AF_DPP4GLP1_AbProc --107

/* Heart Failure */
/* Making sure the codes are available in the CDWWork Dimension table */

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')-- 150.00 is not available
drop table Dflt.Diabetes_AF_DPP4GLP1_HF
select distinct a.PatientSID,a.ScrSSN,  b.DischargeDateTime as comorbidity_Dischargedatetime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_AF_DPP4GLP1_HF

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')
					and b.DischargeDateTime  between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime) 
union all

select distinct a.PatientSID,a.ScrSSN, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')
					and b.DischargeDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.PatientSID,a.ScrSSN,  b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')
					and b.DischargeDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.PatientSID,a.ScrSSN, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')
					and b.EventDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.PatientSID,a.ScrSSN, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')
					and b.EventDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.PatientSID,a.ScrSSN,  b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')
					and b.EventDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.PatientSID,a.ScrSSN,  b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')
					and b.PatientTransferDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.PatientSID,a.ScrSSN,  b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')
					and b.SpecialtyTransferDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.PatientSID,a.ScrSSN,  b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')
					and b.AdmitDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

/*ICD10 Codes*/
select distinct a.PatientSID,a.ScrSSN,  b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')
and b.DischargeDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.PatientSID,a.ScrSSN, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')
and b.DischargeDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.PatientSID,a.ScrSSN, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')
and b.DischargeDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.PatientSID,a.ScrSSN, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')
and b.EventDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.PatientSID,a.ScrSSN,  b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')
and b.EventDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)
union all

select distinct a.PatientSID,a.ScrSSN,  b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')
and b.EventDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)

union all

select distinct a.PatientSID,a.ScrSSN,  b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')
and b.PatientTransferDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)

union all

select distinct a.PatientSID,a.ScrSSN,  b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')
and b.SpecialtyTransferDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)

union all

select distinct a.PatientSID,a.ScrSSN, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')
and b.AdmitDateTime between dateadd(month, -12, a.DPP4Filltime) and dateadd(day, 1, a.DPP4Filltime)


select distinct scrssn from Dflt.Diabetes_AF_DPP4GLP1_HF --801

/* Laboratory Variablles */

/* Current VA phenomics library is updated and shows only %A1C% */

select b.*, a.LabChemResultValue, a.LabChemResultNumericValue, a.LabChemCompleteDateTime,c.LabChemTestName

into Dflt.Diabetes_AF_DPP4GLP1_hba1c

from Src.Chem_LabChem as a with (NOLOCK) inner join
Dflt.Diabetes_AF_DPP4GLP1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
where c.LabChemTestName like '%A1C%' AND
	c.LabChemTestName not like '%ZZ%' AND
	c.LabChemTestName not like '%XX%'
and a.LabChemCompleteDateTime between dateadd(month, -6, b.DPP4Filltime) and dateadd(day, 1, b.DPP4Filltime)                                
union all

select b.*, a.LabChemResultValue, a.LabChemResultNumericValue,a.LabChemCompleteDateTime,c.LabChemTestName

from Src.Chem_LabChem_Recent as a with (NOLOCK) inner join
Dflt.Diabetes_AF_DPP4GLP1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
where c.LabChemTestName like '%A1C%' AND
	c.LabChemTestName not like '%ZZ%' AND
	c.LabChemTestName not like '%XX%'
and a.LabChemCompleteDateTime between dateadd(month, -6, b.DPP4Filltime) and dateadd(day, 1, b.DPP4Filltime)  
union all

select b.*, a.LabChemResultValue, a.LabChemResultNumericValue, a.LabChemCompleteDateTime, c.LabChemTestName

from Src.Chem_PatientLabChem as a with (NOLOCK) inner join
Dflt.Diabetes_AF_DPP4GLP1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
where c.LabChemTestName like '%A1C%' AND
	c.LabChemTestName not like '%ZZ%' AND
	c.LabChemTestName not like '%XX%'
and a.LabChemCompleteDateTime between dateadd(month, -6, DPP4Filltime) and dateadd(day, 1, DPP4Filltime)

select distinct scrssn from Dflt.Diabetes_AF_DPP4GLP1_hba1c --1695

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
Dflt.Diabetes_AF_DPP4GLP1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
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
Dflt.Diabetes_AF_DPP4GLP1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
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
Dflt.Diabetes_AF_DPP4GLP1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
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
into Dflt.Diabetes_AF_DPP4GLP1_Creatinine
from #tempCreatinineDPP4
where LabChemCompleteDateTime between dateadd(month, -6, DPP4Filltime) and dateadd(day, 1, DPP4Filltime)

select distinct scrssn from Dflt.Diabetes_AF_DPP4GLP1_Creatinine --1946

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
Dflt.Diabetes_AF_DPP4GLP1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
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
Dflt.Diabetes_AF_DPP4GLP1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
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
Dflt.Diabetes_AF_DPP4GLP1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
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
into Dflt.Diabetes_AF_DPP4GLP1_Hemoglobin
from #temphemoglobinDPP4
where LabChemCompleteDateTime between dateadd(month, -6, DPP4Filltime) and dateadd(day, 1, DPP4Filltime)

select distinct scrssn from Dflt.Diabetes_AF_DPP4GLP1_Hemoglobin --1878

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
Dflt.Diabetes_AF_DPP4GLP1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
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
Dflt.Diabetes_AF_DPP4GLP1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
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
Dflt.Diabetes_AF_DPP4GLP1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE 
   (labchemtestname like '%BNP%' or  
	labchemtestname  like '%brain natriuretic peptide%' or 
	labchemtestname  like '%natriu%pept%') and
	LabChemTestName not like '%ratio%' AND
	LabChemTestName not like '%pro%'

select *
into Dflt.Diabetes_AF_DPP4GLP1_BNP
from #tempBNPDPP4
where LabChemCompleteDateTime between dateadd(month, -6, DPP4Filltime) and dateadd(day, 1, DPP4Filltime)

select distinct scrssn from Dflt.Diabetes_AF_DPP4GLP1_BNP--492

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
Dflt.Diabetes_AF_DPP4GLP1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
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
Dflt.Diabetes_AF_DPP4GLP1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
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
Dflt.Diabetes_AF_DPP4GLP1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
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
into Dflt.Diabetes_AF_DPP4GLP1_PBNP
from #tempPBNPDPP4
where LabChemCompleteDateTime between dateadd(month, -6, DPP4Filltime) and dateadd(day, 1, DPP4Filltime)

select distinct scrssn from Dflt.Diabetes_AF_DPP4GLP1_PBNP --720

/* Prior HF hospitalization */

select distinct a.*, b.AdmitDateTime

into Dflt.AF_DPP4GLP1_priorHFHospi

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_Inpatient as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.PrincipalDiagnosisICD9SID=c.ICD9SID 
where c.ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')
					and b.AdmitDateTime between dateadd(year, -10, a.DPP4Filltime) and a.DPP4Filltime

union all

select distinct a.*, b.AdmitDateTime

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_Inpatient_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.PrincipalDiagnosisICD10SID=c.ICD10SID 
where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')
and b.AdmitDateTime between dateadd(year, -10, a.DPP4Filltime) and a.DPP4Filltime

select distinct scrssn from Dflt.AF_DPP4GLP1_priorHFHospi --232



/* Before EF value */

select distinct a.*, b.low_Value, b.ValueDateTime

into Dflt.Diabetes_AF_DPP4GLP1_EFBefore

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join 
Src.VINCI_TIU_NLP_LVEF as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where b.ValueDateTime <= a.DPP4FillTime

select distinct scrssn from Dflt.Diabetes_AF_DPP4GLP1_EFBefore --1919

/* After EF value */

select distinct a.*, b.low_Value, b.ValueDateTime

into Dflt.Diabetes_AF_DPP4GLP1_EFAfter

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join 
Src.VINCI_TIU_NLP_LVEF as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where b.ValueDateTime > a.DPP4FillTime

select distinct scrssn from Dflt.Diabetes_AF_DPP4GLP1_EFAfter --1800

/* Other Medications */
select distinct a.PatientSID, a.ScrSSN, a.DPP4Filltime, b.FillDateTime, b.LocalDrugNameWithDose, b.FillNumber, b.DaysSupply, b.Qty

into #tempMedicationsDPP4

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where b.FillDateTime between dateadd(month, -6, a.DPP4Filltime) and a.DPP4Filltime and 
b.FillNumber > '1'
union all

select distinct a.PatientSID, a.ScrSSN, a.DPP4Filltime, b.FillDateTime, b.LocalDrugNameWithDose, b.FillNumber, b.DaysSupply, b.Qty

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where b.FillDateTime between dateadd(month, -6, a.DPP4Filltime) and a.DPP4Filltime and 
b.FillNumber > '1'

select distinct scrssn from #tempMedicationsDPP4 --1899

/* Sacubitril and Valsartan */

select distinct * 

into Dflt.Diabetes_AF_DPP4GLP1_SacuVal

from #tempMedicationsDPP4
where LocalDrugNameWithDose like '%sacubitril%' and LocalDrugNameWithDose like '%valsartan%' 
union all

select distinct *
from #tempMedicationsDPP4
where LocalDrugNameWithDose like '%sacubitril%'

select * from Dflt.Diabetes_AF_DPP4GLP1_SacuVal

Select distinct scrssn from Dflt.Diabetes_AF_DPP4GLP1_SacuVal --16

/* Beta Blockers */
/* Check for the LocalDrugNameWithDose in the dimension table */
select * from CDWWork.Dim.LocalDrug where LocalDrugNameWithDose like '%metoprolol%' or LocalDrugNameWithDose like '%carvedilol%' or LocalDrugNameWithDose like '%bisoprolol%' or
		LocalDrugNameWithDose like '%nebivolol%' or LocalDrugNameWithDose like '%atenolol%'

select distinct *

into Dflt.Diabetes_AF_DPP4GLP1_BB

from #tempMedicationsDPP4 where LocalDrugNameWithDose like '%metoprolol%' or LocalDrugNameWithDose like '%carvedilol%' or LocalDrugNameWithDose like '%bisoprolol%' or
		LocalDrugNameWithDose like '%nebivolol%' or LocalDrugNameWithDose like '%atenolol%'

select distinct scrssn from Dflt.Diabetes_AF_DPP4GLP1_BB--782


drop table Dflt.Diabetes_AF_DPP4GLP1_ACE
/* ACE Inhibitor */
/* Check for the LocalDrugNameWithDose in the dimension table */
select * from CDWWork.Dim.LocalDrug where LocalDrugNameWithDose like '%lisinopril%' or LocalDrugNameWithDose like '%Fosinopril%' or LocalDrugNameWithDose like '%ramipril%' or
		LocalDrugNameWithDose like '%quinapril%' or LocalDrugNameWithDose like '%benazepril%'

select distinct *

into Dflt.Diabetes_AF_DPP4GLP1_ACE

from #tempMedicationsDPP4 where LocalDrugNameWithDose like '%lisinopril%' or LocalDrugNameWithDose like '%Fosinopril%' or LocalDrugNameWithDose like '%ramipril%' or
		LocalDrugNameWithDose like '%quinapril%' or LocalDrugNameWithDose like '%benazepril%'

select distinct scrssn from Dflt.Diabetes_AF_DPP4GLP1_ACE--429

/*ARB Inhibitor */
/* Check for the LocalDrugNameWithDose in the dimension table */
select * from CDWWork.Dim.LocalDrug where LocalDrugNameWithDose like '%valsartan%' or LocalDrugNameWithDose like '%losartan%' or LocalDrugNameWithDose like '%candesartan%' or
		LocalDrugNameWithDose like '%Olmesartan%' or LocalDrugNameWithDose like '%telmisartan%' or LocalDrugNameWithDose like '%irbesartan%' 

select distinct *

into Dflt.Diabetes_AF_DPP4GLP1_ARB

from #tempMedicationsDPP4 where LocalDrugNameWithDose like '%valsartan%' or LocalDrugNameWithDose like '%losartan%' or LocalDrugNameWithDose like '%candesartan%' or
		LocalDrugNameWithDose like '%Olmesartan%' or LocalDrugNameWithDose like '%telmisartan%' or LocalDrugNameWithDose like '%irbesartan%' 

select distinct scrssn from Dflt.Diabetes_AF_DPP4GLP1_ARB--213

/* ACE and ARB */

select distinct * 

into Dflt.Diabetes_AF_DPP4GLP1_ACEARB

from Dflt.Diabetes_AF_DPP4GLP1_ACE 
union all

select distinct *

from Dflt.Diabetes_AF_DPP4GLP1_ARB

select distinct scrssn from Dflt.Diabetes_AF_DPP4GLP1_ACEARB --644

/* Spironolactone/Eplerenone */
/* Check for the LocalDrugNameWithDose in the dimension table */
select * from CDWWork.Dim.LocalDrug where LocalDrugNameWithDose like '%spironolactone%' or LocalDrugNameWithDose like '%Eplerenone%'

select distinct *

into Dflt.Diabetes_AF_DPP4GLP1_SpiroEp

from #tempMedicationsDPP4 where LocalDrugNameWithDose like '%spironolactone%' or LocalDrugNameWithDose like '%Eplerenone%'

select distinct scrssn from Dflt.Diabetes_AF_DPP4GLP1_SpiroEp--166

/* Loop Diuretic */
/* Check for the LocalDrugNameWithDose in the dimension table */
select * from CDWWork.Dim.LocalDrug where LocalDrugNameWithDose like '%furosemide%' or LocalDrugNameWithDose like '%torsemide%' or LocalDrugNameWithDose like '%bumetanide%' or
		LocalDrugNameWithDose like '%Ethacrynic acid%' or LocalDrugNameWithDose like '%lasix%' or LocalDrugNameWithDose like '%bumex%'

select distinct a.PatientSID, a.ScrSSN, a.DPP4Filltime, b.FillDateTime, b.LocalDrugNameWithDose, b.FillNumber, b.DaysSupply, b.Qty

into #tempMedicationsLoopDPP4

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill as b with (NOLOCK) on a.PatientSID= b.PatientSID
where LocalDrugNameWithDose like '%furosemide%' or LocalDrugNameWithDose like '%torsemide%' or LocalDrugNameWithDose like '%bumetanide%' or
		LocalDrugNameWithDose like '%Ethacrynic acid%' or LocalDrugNameWithDose like '%lasix%' or LocalDrugNameWithDose like '%bumex%'
union all

select distinct a.PatientSID, a.ScrSSN, a.DPP4Filltime, b.FillDateTime, b.LocalDrugNameWithDose, b.FillNumber, b.DaysSupply, b.Qty

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where LocalDrugNameWithDose like '%furosemide%' or LocalDrugNameWithDose like '%torsemide%' or LocalDrugNameWithDose like '%bumetanide%' or
		LocalDrugNameWithDose like '%Ethacrynic acid%' or LocalDrugNameWithDose like '%lasix%' or LocalDrugNameWithDose like '%bumex%'

select distinct *

into Dflt.Diabetes_AF_DPP4GLP1_Loop

from #tempMedicationsloopDPP4

where FillDateTime between dateadd(month, -12, DPP4Filltime) and dateadd(month, 12, DPP4Filltime) and FillNumber > '1'

select distinct scrssn from Dflt.Diabetes_AF_DPP4GLP1_Loop--903

/* Insulin */
/* Check for the LocalDrugNameWithDose in the dimension table */
select * from CDWWork.Dim.LocalDrug where LocalDrugNameWithDose like '%insulin%' 

select distinct *

into Dflt.Diabetes_AF_DPP4GLP1_Insulin

from #tempMedicationsDPP4 where LocalDrugNameWithDose like '%insulin%' 

select distinct scrssn from Dflt.Diabetes_AF_DPP4GLP1_Insulin--136

/* SGLT2 Analogue */

select distinct LocalDrugNameWithDose from CDWWork.Dim.LocalDrug 
where LocalDrugNameWithDose like '%empagliflozin%' 
or LocalDrugNameWithDose like '%dapagliflozin%' 
or LocalDrugNameWithDose like '%canagliflozin%' 
or LocalDrugNameWithDose like '%ertugliflozin%' 

select distinct *

into Dflt.Diabetes_AF_DPP4GLP1_SGLT2

from #tempMedicationsDPP4 where LocalDrugNameWithDose like '%empagliflozin%' 
or LocalDrugNameWithDose like '%dapagliflozin%' 
or LocalDrugNameWithDose like '%canagliflozin%' 
or LocalDrugNameWithDose like '%ertugliflozin%' 

select distinct scrssn from Dflt.Diabetes_AF_DPP4GLP1_SGLT2--39

/* DPP4 I */

select distinct LocalDrugNameWithDose from CDWWork.Dim.LocalDrug where LocalDrugNameWithDose like '%gliptin%'

select distinct *

into Dflt.Diabetes_AF_DPP4GLP1_DPP4

from #tempMedicationsDPP4 where LocalDrugNameWithDose like '%gliptin%'

select distinct * from Dflt.Diabetes_AF_DPP4GLP1_DPP4 --0


/* Metformin */

select * from CDWWork.Dim.LocalDrug where LocalDrugNameWithDose like '%metformin%' 

select distinct *

into Dflt.Diabetes_AF_DPP4GLP1_Metformin

from #tempMedicationsDPP4 where LocalDrugNameWithDose like '%metformin%' 

select distinct scrssn from Dflt.Diabetes_AF_DPP4GLP1_Metformin--518

/* Sulfonylurea */
select distinct LocalDrugNameWithDose from CDWWork.Dim.LocalDrug where LocalDrugNameWithDose like '%Glipizide%' or
			  LocalDrugNameWithDose like '%Glimepiride%' or
			  LocalDrugNameWithDose like '%Glyburide%' or
			  LocalDrugNameWithDose like '%Tolbutamide%' 

select distinct *

into Dflt.Diabetes_AF_DPP4GLP1_SU

from #tempMedicationsDPP4 where LocalDrugNameWithDose like '%Glipizide%' or
			  LocalDrugNameWithDose like '%Glimepiride%' or
			  LocalDrugNameWithDose like '%Glyburide%' or
			  LocalDrugNameWithDose like '%Tolbutamide%' 

select distinct scrssn from Dflt.Diabetes_AF_DPP4GLP1_SU--0

/* Thiazoldiandione- check */

select distinct LocalDrugNameWithDose from CDWWork.Dim.LocalDrug where LocalDrugNameWithDose like '%pioglitazone%' 
or LocalDrugNameWithDose like '%rosiglitazone%'

select distinct *

into Dflt.Diabetes_AF_DPP4GLP1_Thiazol

from #tempMedicationsDPP4 where LocalDrugNameWithDose like '%pioglitazone%' 
or LocalDrugNameWithDose like '%rosiglitazone%'

select distinct scrssn from Dflt.Diabetes_AF_DPP4GLP1_Thiazol --4

/* Anti-Arrythmia Drugs */

select distinct LocalDrugNameWithDose from CDWWork.Dim.LocalDrug where LocalDrugNameWithDose like '%soltalol%' 
or LocalDrugNameWithDose like '%Dofetilide%' 
or LocalDrugNameWithDose like '%flecainide%' 
or LocalDrugNameWithDose like '%propafenone%' 
or LocalDrugNameWithDose like '%amiodarone%' 
or LocalDrugNameWithDose like '%dronaderone%'
or LocalDrugNameWithDose like '%digoxin%'

select distinct *

into Dflt.Diabetes_AF_DPP4GLP1_AntiArr

from #tempMedicationsDPP4 where LocalDrugNameWithDose like '%soltalol%' 
or LocalDrugNameWithDose like '%Dofetilide%' 
or LocalDrugNameWithDose like '%flecainide%' 
or LocalDrugNameWithDose like '%propafenone%' 
or LocalDrugNameWithDose like '%amiodarone%' 
or LocalDrugNameWithDose like '%dronaderone%'
or LocalDrugNameWithDose like '%digoxin%'

select distinct scrssn from Dflt.Diabetes_AF_DPP4GLP1_AntiArr --411


//** After the drug initiation - Extraction **//

/* All HF hospitalization after DPP4GLP1 initiation */

select distinct a.PatientSID,a.ScrSSN,  a.DPP4FillTime, b.AdmitDateTime, b.Admitdiagnosis, c.ICD9Code

into Dflt.AF_DPP4GLP1_HFHospitalization

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_Inpatient as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.PrincipalDiagnosisICD9SID=c.ICD9SID 
where c.ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')
					and b.DischargeDateTime >= a.DPP4FillTime
union all

/*ICD10 Codes*/

select distinct a.PatientSID,a.ScrSSN,  a.DPP4FillTime, b.AdmitDateTime, b.AdmitDiagnosis, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_Inpatient as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.PrincipalDiagnosisICD10SID=c.ICD10SID 
where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')
and b.DischargeDateTime >= a.DPP4FillTime

select distinct scrssn from Dflt.AF_DPP4GLP1_HFHospitalization --365

select * from Dflt.AF_DPP4GLP1_HFHospitalization

/* Atrial Fibrillation */

select distinct a.PatientSID,a.ScrSSN,  a.DPP4FillTime, b.AdmitDateTime, b.Admitdiagnosis, c.ICD9Code

into Dflt.Diabetes_AF_DPP4GLP1_AFAfter

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_Inpatient as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.PrincipalDiagnosisICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
					and b.DischargeDateTime >= a.DPP4FillTime
union all

/*ICD10 Codes*/

select distinct a.PatientSID,a.ScrSSN,  a.DPP4FillTime, b.AdmitDateTime, b.AdmitDiagnosis, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_Inpatient as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.PrincipalDiagnosisICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.DischargeDateTime >= a.DPP4FillTime

select distinct scrssn from Dflt.Diabetes_AF_DPP4GLP1_AFAfter --308

/* All hospitalization after DPP4GLP1 initiation */

select distinct a.*, b.DischargeDateTime,c.ICD9Code
/*ICD9 Codes*/

into Dflt.AF_DPP4GLP1_AllHospitalization

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where b.DischargeDateTime >= a.DPP4Filltime
union all

select distinct a.*, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where b.DischargeDateTime >= a.DPP4Filltime
union all

select distinct a.*, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where b.DischargeDateTime >= a.DPP4Filltime
union all

select distinct a.*, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where b.PatientTransferDateTime >= a.DPP4Filltime
union all

select distinct a.*, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where b.SpecialtyTransferDateTime >= a.DPP4Filltime
union all

select distinct a.*, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where b.AdmitDateTime >= a.DPP4Filltime
union all

/*ICD10 Codes*/
select distinct a.*, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where  b.DischargeDateTime >= a.DPP4Filltime
union all

select distinct a.*, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where b.DischargeDateTime >= a.DPP4Filltime
union all

select distinct a.*, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where b.DischargeDateTime >= a.DPP4Filltime
union all

select distinct a.*, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where b.PatientTransferDateTime >= a.DPP4Filltime

union all

select distinct a.*, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where b.SpecialtyTransferDateTime >= a.DPP4Filltime
union all

select distinct a.*, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where  b.AdmitDateTime >= a.DPP4Filltime

select distinct scrssn from Dflt.AF_DPP4GLP1_AllHospitalization --1580

/* Use only Discharge diagnosis table to identify all hospitalization events - DPP4GLP1 */

select distinct a.*, b.AdmitDateTime,c.ICD9Code

into Dflt.AF_DPP4GLP1_AllDDHospi

/*ICD9 Code */

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where b.AdmitDateTime >= a.DPP4Filltime

union all
/*ICD10 Code */

select distinct a.*, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where b.AdmitDateTime >= a.DPP4Filltime

select distinct scrssn from Dflt.AF_DPP4GLP1_AllDDHospi --1310

/*BMI After*/
/* Select height and weight values from vital signs view to calculate bmi */
drop table #tempDiabetesVitals

select distinct a.PatientSID, a.VitalSignTakenDateTime, a.VitalResult, a.VitalResultNumeric,
 b.DPP4Filltime, b.ScrSSN, 
c.VitalType

into #tempDiabetesVitalsDPP4GLP1

from Src.Vital_VitalSign as a with (NOLOCK) inner join
Dflt.Diabetes_AF_DPP4GLP1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.VitalType as c with (NOLOCK) on a.VitalTypeSID=c.VitalTypeSID 
where a.VitalSignTakenDateTime > dateadd(month, 3, b.DPP4Filltime) AND
c.VitalType in ( 'WEIGHT')
union all

select distinct a.PatientSID, a.VitalSignTakenDateTime, a.VitalResult, a.VitalResultNumeric,
b.DPP4Filltime,b.ScrSSN, 
c.VitalType

from Src.Vital_VitalSign_Recent as a with (NOLOCK) inner join
Dflt.Diabetes_AF_DPP4GLP1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.VitalType as c with (NOLOCK) on a.VitalTypeSID=c.VitalTypeSID 
where a.VitalSignTakenDateTime > dateadd(month, 3, b.DPP4Filltime) AND 
c.VitalType in ( 'WEIGHT')
union all

select distinct a.PatientSID, a.VitalSignTakenDateTime, a.VitalResult, a.VitalResultNumeric,
 b.DPP4Filltime, b.ScrSSN, 
c.VitalType

from Src.Vital_VitalSign as a with (NOLOCK) inner join
Dflt.Diabetes_AF_DPP4GLP1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.VitalType as c with (NOLOCK) on a.VitalTypeSID=c.VitalTypeSID 
--where (a.VitalSignTakenDateTime between dateadd(month, -12, b.DPP4Filltime) and dateadd(day, 1, b.DPP4Filltime))AND
where a.VitalSignTakenDateTime >= b.DPP4Filltime and 
c.VitalType in ( 'HEIGHT')
union all

select distinct a.PatientSID, a.VitalSignTakenDateTime, a.VitalResult, a.VitalResultNumeric,
b.DPP4Filltime,b.ScrSSN, 
c.VitalType

from Src.Vital_VitalSign_Recent as a with (NOLOCK) inner join
Dflt.Diabetes_AF_DPP4GLP1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.VitalType as c with (NOLOCK) on a.VitalTypeSID=c.VitalTypeSID 
--where (a.VitalSignTakenDateTime between dateadd(month, -12, b.DPP4Filltime) and dateadd(day, 1, b.DPP4Filltime))AND
where a.VitalSignTakenDateTime >= b.DPP4Filltime and 
c.VitalType in ( 'HEIGHT')

select distinct scrssn from #tempDiabetesVitalsDPP4GLP1--1944

/* Seperate weight records into a table */
select * 

into #tempweightDPP4GLP1After

from #tempDiabetesVitalsDPP4GLP1 where vitaltype = 'WEIGHT' and VitalResultNumeric != '0'

select distinct scrssn from #tempweightDPP4GLP1After--1908


/* Seperate height records into a table */
select *  

into #tempheightDPP4GLP1After

from #tempDiabetesVitalsDPP4GLP1 where vitaltype = 'HEIGHT' and VitalResultNumeric != '0'

select distinct scrssn from #tempheightDPP4GLP1After --1783

/* Combine data from table weight and height to obtain the bmi for individual patient */

select distinct a.patientsid, a.ScrSSN, cast(a.VitalSignTakenDateTime as date) as HeightTime, a.VitalResultNumeric as heightresult, 
cast(b.VitalSignTakenDateTime as date) as WeightTime,b.VitalResultNumeric as weightresult, ((b.VitalResultNumeric*703)/(a.VitalResultNumeric*a.VitalResultNumeric)) as bmi

into Dflt.Diabetes_AF_DPP4GLP1_BMI_After

from #tempheightDPP4GLP1After as a with (NOLOCK) inner join
#tempweightDPP4GLP1After as b with (NOLOCK) on a.ScrSSN = b.ScrSSN
where a.VitalSignTakenDateTime=b.VitalSignTakenDateTime --a.DPP4Filltime=b.DPP4Filltime and


select distinct scrssn from Dflt.Diabetes_AF_DPP4GLP1_BMI_After --1674

select distinct scrssn from Dflt.Diabetes_AF_DPP4GLP1_BMI_After where bmi >= 30  --1223

select distinct scrssn from Dflt.Diabetes_AF_DPP4GLP1_BMI_After where bmi between 30 and 35

select distinct scrssn from Dflt.Diabetes_AF_DPP4GLP1_BMI_After where bmi between 35 and 40


/* DPP4 cardioversion using pocedure codes- 1 week after drug initiation */

select distinct a.*, b.ICDProcedureDateTime, c.ICD9ProcedureCode
/*ICD9Procedure Codes*/

into Dflt.Diabetes_AF_DPP4GLP1_CVAfter

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_CensusICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('99.61','99.62')
					and b.ICDProcedureDateTime >  dateadd(day, 7, a.DPP4Filltime)
union all

select distinct a.*, b.SurgicalProcedureDateTime, c.ICD9ProcedureCode

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_CensusSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('99.61','99.62')
					and b.SurgicalProcedureDateTime >  dateadd(day, 7, a.DPP4Filltime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD9ProcedureCode

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('99.61','99.62')
					and b.DischargeDateTime >  dateadd(day, 7, a.DPP4Filltime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD9ProcedureCode

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('99.61','99.62')
					and b.DischargeDateTime >  dateadd(day, 7, a.DPP4Filltime)
union all

/*ICD10Procedure Codes*/
select distinct a.*, b.ICDProcedureDateTime, c.ICD10ProcedureCode

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_CensusICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('5A2204Z')
and b.ICDProcedureDateTime >  dateadd(day, 7, a.DPP4Filltime)
union all

select distinct a.*, b.SurgicalProcedureDateTime, c.ICD10ProcedureCode

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_CensusSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('5A2204Z')
and b.SurgicalProcedureDateTime >  dateadd(day, 7, a.DPP4Filltime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD10ProcedureCode

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('5A2204Z')
and b.DischargeDateTime >  dateadd(day, 7, a.DPP4Filltime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD10ProcedureCode

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('5A2204Z')
and b.DischargeDateTime >  dateadd(day, 7, a.DPP4Filltime)

select distinct scrssn from Dflt.Diabetes_AF_DPP4GLP1_CVAfter --102

/* DPP4 Ablation using CPT codes - 1 week after drug initiation */

select distinct a.*

into Dflt.Diabetes_AF_DPP4GLP1_AbAfter

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientCPTProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
Src.Cohort_CPT as c with (NOLOCK) on c.CPTSID=b.cptSID 
where c.cptcode in ('93656','93657','93662','33254','33255','33258','33265','33266')
and b.DischargeDateTime >  dateadd(day, 7, a.DPP4Filltime)
union all

select distinct a.*
from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Surg_SurgeryPrincipalAssociatedProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on b.OtherProcedureCPTSID=c.cptSID 
where c.cptcode in ('93656','93657','93662','33254','33255','33258','33265','33266') 
and b.SurgeryDateTime >  dateadd(day, 7, a.DPP4Filltime)
union all

select distinct a.*
from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Surg_SurgeryProcedureDiagnosisCode as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on b.PrincipalCPTSID=c.cptSID 
where c.cptcode in ('93656','93657','93662','33254','33255','33258','33265','33266')
and b.SurgeryDateTime >  dateadd(day, 7, a.DPP4Filltime)

select distinct scrssn from Dflt.Diabetes_AF_DPP4GLP1_AbAfter --6

/* Ablation using Procedure codes- 1 week after drug initiation */

select distinct a.*, b.ICDProcedureDateTime, c.ICD9ProcedureCode
/*ICD9Procedure Codes*/

into Dflt.Diabetes_AF_DPP4GLP1_AbProcAfter

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_CensusICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('37.33','37.34','37.37','37.80','38.65')
					and b.ICDProcedureDateTime>  dateadd(day, 7, a.DPP4Filltime)
union all

select distinct a.*, b.SurgicalProcedureDateTime, c.ICD9ProcedureCode

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_CensusSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('37.33','37.34','37.37','37.80','38.65')
					and b.SurgicalProcedureDateTime >  dateadd(day, 7, a.DPP4Filltime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD9ProcedureCode

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('37.33','37.34','37.37','37.80','38.65')
					and b.DischargeDateTime >  dateadd(day, 7, a.DPP4Filltime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD9ProcedureCode

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('37.33','37.34','37.37','37.80','38.65')
					and b.DischargeDateTime >  dateadd(day, 7, a.DPP4Filltime)
union all

/*ICD10Procedure Codes*/
select distinct a.*, b.ICDProcedureDateTime, c.ICD10ProcedureCode

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_CensusICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('02560ZZ','02563ZZ','02564ZZ',
'02570ZZ','02573ZZ','02574ZZ','02580ZZ','02583ZZ','02584ZZ','025S0ZZ','025S3ZZ','025S4ZZ','025T0ZZ','025T3ZZ','025T4ZZ')
and b.ICDProcedureDateTime >  dateadd(day, 7, a.DPP4Filltime)
union all

select distinct a.*, b.SurgicalProcedureDateTime, c.ICD10ProcedureCode

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_CensusSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('02560ZZ','02563ZZ','02564ZZ',
'02570ZZ','02573ZZ','02574ZZ','02580ZZ','02583ZZ','02584ZZ','025S0ZZ','025S3ZZ','025S4ZZ','025T0ZZ','025T3ZZ','025T4ZZ')
and b.SurgicalProcedureDateTime >  dateadd(day, 7, a.DPP4Filltime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD10ProcedureCode

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('02560ZZ','02563ZZ','02564ZZ',
'02570ZZ','02573ZZ','02574ZZ','02580ZZ','02583ZZ','02584ZZ','025S0ZZ','025S3ZZ','025S4ZZ','025T0ZZ','025T3ZZ','025T4ZZ')
and b.DischargeDateTime >  dateadd(day, 7, a.DPP4Filltime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD10ProcedureCode

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.Inpat_InpatientSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('02560ZZ','02563ZZ','02564ZZ',
'02570ZZ','02573ZZ','02574ZZ','02580ZZ','02583ZZ','02584ZZ','025S0ZZ','025S3ZZ','025S4ZZ','025T0ZZ','025T3ZZ','025T4ZZ')
and b.DischargeDateTime >  dateadd(day, 7, a.DPP4Filltime)

select distinct scrssn from Dflt.Diabetes_AF_DPP4GLP1_AbProcAfter --51

/* Drug name for GLP1 */

drop table Dflt.Diabetes_AF_GLP1_Drugdose

select distinct a.scrssn, a.GLP1FillTime,b.filldatetime, b.LocalDrugNameWithDose, b.DrugNameWithoutDose

into #tempglpdose

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where LocalDrugNameWithDose like '%semaglutide%' 
or LocalDrugNameWithDose like '%exenatide%' 
or LocalDrugNameWithDose like '%liraglutide%' 
or LocalDrugNameWithDose like '%lixisenatide%' 
or LocalDrugNameWithDose like '%dulaglutide%' 
union all

select distinct a.scrssn, a.GLP1FillTime,b.filldatetime, b.LocalDrugNameWithDose,  b.DrugNameWithoutDose

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where LocalDrugNameWithDose like '%semaglutide%' 
or LocalDrugNameWithDose like '%exenatide%' 
or LocalDrugNameWithDose like '%liraglutide%' 
or LocalDrugNameWithDose like '%lixisenatide%' 
or LocalDrugNameWithDose like '%dulaglutide%'

select distinct *

into Dflt.Diabetes_AF_GLP1_Drugdose 

from #tempglpdose

where GLP1Filltime = FillDateTime and GLP1Filltime >= '2015-01-01 00:00:00'

select distinct scrssn from Dflt.Diabetes_AF_GLP1_Drugdose--1489

select * from Dflt.Diabetes_AF_GLP1_Drugdose

select distinct scrssn 
from Dflt.Diabetes_AF_GLP1_Drugdose 
where LocalDrugNameWithDose like '%semaglutide%' -- and GLP1Filltime >= '2014-01-01 00:00:00'

select distinct scrssn 
from Dflt.Diabetes_AF_GLP1_Drugdose 
where LocalDrugNameWithDose like '%exenatide%'  --and GLP1Filltime >= '2014-01-01 00:00:00'

select distinct scrssn 
from Dflt.Diabetes_AF_GLP1_Drugdose 
where LocalDrugNameWithDose like '%liraglutide%'  --and GLP1Filltime >= '2014-01-01 00:00:00'

select distinct scrssn 
from Dflt.Diabetes_AF_GLP1_Drugdose 
where LocalDrugNameWithDose like '%lixisenatide%'  --and GLP1Filltime >= '2014-01-01 00:00:00'

select distinct scrssn 
from Dflt.Diabetes_AF_GLP1_Drugdose 
where LocalDrugNameWithDose like '%dulaglutide%' --and GLP1Filltime >= '2014-01-01 00:00:00'

/* Drug name for DPP4 */
select top 10* from Dflt.Diabetes_AF_DPP4GLP1
drop table Dflt.Diabetes_AF_DPP4GLP1_Drugdose

select distinct a.scrssn, a. dpp4filltime, b.LocalDrugNameWithDose, b.FillDateTime, b.DrugNameWithoutDose

into #tempdpp4glpdose

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where LocalDrugNameWithDose like '%gliptin%' or
      LocalDrugNameWithDose like '%Glipizide%' or
			  LocalDrugNameWithDose like '%Glimepiride%' or
			  LocalDrugNameWithDose like '%Glyburide%' or
			  LocalDrugNameWithDose like '%Tolbutamide%'  
union all

select distinct a.scrssn, a. dpp4filltime, b.LocalDrugNameWithDose, b.FillDateTime, b.DrugNameWithoutDose

from Dflt.Diabetes_AF_DPP4GLP1 as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where LocalDrugNameWithDose like '%gliptin%' or
      LocalDrugNameWithDose like '%Glipizide%' or
			  LocalDrugNameWithDose like '%Glimepiride%' or
			  LocalDrugNameWithDose like '%Glyburide%' or
			  LocalDrugNameWithDose like '%Tolbutamide%' 

select distinct *

into Dflt.Diabetes_AF_DPP4GLP1_Drugdose 

from #tempdpp4glpdose

where DPP4Filltime = FillDateTime and DPP4Filltime >= '2015-01-01 00:00:00'

select distinct scrssn from Dflt.Diabetes_AF_DPP4GLP1_Drugdose --1991

select distinct scrssn 
from Dflt.Diabetes_AF_DPP4GLP1_Drugdose 
where LocalDrugNameWithDose like '%gliptin%' -- 523

select distinct scrssn 
from Dflt.Diabetes_AF_DPP4GLP1_Drugdose 
where LocalDrugNameWithDose like '%Glipizide%'  --1721

select distinct scrssn 
from Dflt.Diabetes_AF_DPP4GLP1_Drugdose
where LocalDrugNameWithDose like '%Glimepiride%'  --114

select distinct scrssn 
from Dflt.Diabetes_AF_DPP4GLP1_Drugdose 
where LocalDrugNameWithDose like '%Glyburide%'  --5

select distinct scrssn 
from Dflt.Diabetes_AF_DPP4GLP1_Drugdose 
where LocalDrugNameWithDose like '%Tolbutamide%' --0


/* Additional extraction for analyses */
/* GLP1 Pneumonia */

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in (
            '480.0', '480.1', '480.2', '480.3', '480.8', '480.9',
            '481.',
            '482.0', '482.1', '482.2', '482.3', '482.4', '482.41', '482.42', '482.8', '482.9',
            '483.0', '483.1', '483.8',
            '484.1', '484.3', '484.5', '484.6', '484.7', '484.8',
            '485.', '486.',
            '487.0',
            '488.01', '488.11')
select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code like '481.%'
        

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in (
            'J09.X1', 'J10.00', 'J11.00',
            'J12.0', 'J12.1', 'J12.2', 'J12.3', 'J12.81', 'J12.82','J12.89','J12.9',
            'J13.', 'J14.',
            'J15.0', 'J15.1', 'J15.20', 'J15.211','J15.212','J15.29','J15.3', 'J15.4', 'J15.5', 'J15.6', 'J15.7', 'J15.8', 'J15.9',
            'J16.0', 'J16.8',
            'J17.',
            'J18.0', 'J18.1', 'J18.2', 'J18.8', 'J18.9',
            'J69.0', 'J69.1', 'J69.8')
        
select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code like 'J17.%'


select distinct a.*, b.DischargeDateTime,c.ICD9Code,b.AdmitDiagnosis
/*ICD9 Codes*/

into Dflt.Diabetes_AF_GLP1_Pneumonia

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_Inpatient as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.PrincipalDiagnosisICD9SID=c.ICD9SID 
where c.ICD9Code in ('480.0', '480.1', '480.2', '480.3', '480.8', '480.9',
            '481.',
            '482.0', '482.1', '482.2', '482.3', '482.4', '482.41', '482.42', '482.8', '482.9',
            '483.0', '483.1', '483.8',
            '484.1', '484.3', '484.5', '484.6', '484.7', '484.8',
            '485.', '486.',
            '487.0',
            '488.01', '488.11')
					and b.DischargeDateTime >= a.GLP1FillTime
union all

/*ICD10 Codes*/
select distinct a.*, b.DischargeDateTime, c.ICD10Code, b.AdmitDiagnosis

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_Inpatient as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.PrincipalDiagnosisICD10SID=c.ICD10SID 
where ICD10Code in ('J09.X1', 'J10.00', 'J11.00',
            'J12.0', 'J12.1', 'J12.2', 'J12.3', 'J12.81', 'J12.82','J12.89','J12.9',
            'J13.', 'J14.',
            'J15.0', 'J15.1', 'J15.20', 'J15.211','J15.212','J15.29','J15.3', 'J15.4', 'J15.5', 'J15.6', 'J15.7', 'J15.8', 'J15.9',
            'J16.0', 'J16.8',
            'J17.',
            'J18.0', 'J18.1', 'J18.2', 'J18.8', 'J18.9',
            'J69.0', 'J69.1', 'J69.8')
and b.DischargeDateTime >= a.GLP1FillTime

select distinct scrssn from Dflt.Diabetes_AF_GLP1_Pneumonia --78
drop table Dflt.AF_GLP1_Pneumonia 

/* DPP4/SU Pneumonia */

select distinct a.*, b.DischargeDateTime,c.ICD9Code,b.AdmitDiagnosis
/*ICD9 Codes*/

into Dflt.Diabetes_AF_DPP4GLP1_Pneumonia

from Dflt.Diabetes_HF_DPP4GLP1_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_Inpatient as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.PrincipalDiagnosisICD9SID=c.ICD9SID 
where c.ICD9Code in ('480.0', '480.1', '480.2', '480.3', '480.8', '480.9',
            '481.',
            '482.0', '482.1', '482.2', '482.3', '482.4', '482.41', '482.42', '482.8', '482.9',
            '483.0', '483.1', '483.8',
            '484.1', '484.3', '484.5', '484.6', '484.7', '484.8',
            '485.', '486.',
            '487.0',
            '488.01', '488.11')
					and b.DischargeDateTime >= a.DPP4FillTime
union all

/*ICD10 Codes*/
select distinct a.*, b.DischargeDateTime, c.ICD10Code, b.AdmitDiagnosis

from Dflt.Diabetes_HF_DPP4GLP1_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_Inpatient as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.PrincipalDiagnosisICD10SID=c.ICD10SID 
where ICD10Code in ('J09.X1', 'J10.00', 'J11.00',
            'J12.0', 'J12.1', 'J12.2', 'J12.3', 'J12.81', 'J12.82','J12.89','J12.9',
            'J13.', 'J14.',
            'J15.0', 'J15.1', 'J15.20', 'J15.211','J15.212','J15.29','J15.3', 'J15.4', 'J15.5', 'J15.6', 'J15.7', 'J15.8', 'J15.9',
            'J16.0', 'J16.8',
            'J17.',
            'J18.0', 'J18.1', 'J18.2', 'J18.8', 'J18.9',
            'J69.0', 'J69.1', 'J69.8')
and b.DischargeDateTime >= a.DPP4FillTime

select distinct scrssn from Dflt.Diabetes_AF_DPP4GLP1_Pneumonia --80

/* GLP1 COPD Exacerbation */
select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in (
        '491.21', '491.22', '493.22' )

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in (
        'J44.0', 'J44.1')

select distinct a.*, b.DischargeDateTime,c.ICD9Code,b.AdmitDiagnosis
/*ICD9 Codes*/

into Dflt.Diabetes_AF_GLP1_COPDExa

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_Inpatient as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.PrincipalDiagnosisICD9SID=c.ICD9SID 
where c.ICD9Code in ('491.21', '491.22', '493.22' )
					and b.DischargeDateTime >= a.GLP1FillTime
union all

/*ICD10 Codes*/
select distinct a.*, b.DischargeDateTime, c.ICD10Code, b.AdmitDiagnosis

from Dflt.Diabetes_AF_GLP1 as a with (NOLOCK) inner join
Src.Inpat_Inpatient as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.PrincipalDiagnosisICD10SID=c.ICD10SID 
where ICD10Code in ('J44.0', 'J44.1')
and b.DischargeDateTime >= a.GLP1FillTime

select distinct scrssn from Dflt.Diabetes_AF_GLP1_COPDExa --42

/* DPP4/SU COPD exacerbation */

select distinct a.*, b.DischargeDateTime,c.ICD9Code,b.AdmitDiagnosis
/*ICD9 Codes*/

into Dflt.Diabetes_AF_DPP4GLP1_COPDExa

from Dflt.Diabetes_HF_DPP4GLP1_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_Inpatient as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.PrincipalDiagnosisICD9SID=c.ICD9SID 
where c.ICD9Code in ('491.21', '491.22', '493.22' )
					and b.DischargeDateTime >= a.DPP4FillTime
union all

/*ICD10 Codes*/
select distinct a.*, b.DischargeDateTime, c.ICD10Code, b.AdmitDiagnosis

from Dflt.Diabetes_HF_DPP4GLP1_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_Inpatient as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.PrincipalDiagnosisICD10SID=c.ICD10SID 
where ICD10Code in ( 'J44.0', 'J44.1')
and b.DischargeDateTime >= a.DPP4FillTime

select distinct scrssn from Dflt.Diabetes_AF_DPP4GLP1_COPDExa --71

/* Heart Rate 6 months before drug initiation- GLP1  */

select distinct vitaltype from CDWWork.Dim.VitalType

select distinct a.PatientSID, a.VitalSignTakenDateTime, a.VitalResult, a.VitalResultNumeric, a.systolic, a.diastolic,
 b.GLP1FillTime, b.ScrSSN, 
c.VitalType

into Dflt.Diabetes_AF_GLP1_HR

from Src.Vital_VitalSign as a with (NOLOCK) inner join
Dflt.Diabetes_AF_GLP1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.VitalType as c with (NOLOCK) on a.VitalTypeSID=c.VitalTypeSID 
where (a.VitalSignTakenDateTime between dateadd(month, -6, b.GLP1FillTime) and dateadd(DAY, 1, b.GLP1FillTime)) AND
c.VitalType in ('pulse','zzpulse')
union all

select distinct a.PatientSID, a.VitalSignTakenDateTime, a.VitalResult, a.VitalResultNumeric,a.systolic, a.diastolic,
b.GLP1FillTime,b.ScrSSN, 
c.VitalType

from Src.Vital_VitalSign_Recent as a with (NOLOCK) inner join
Dflt.Diabetes_AF_GLP1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.VitalType as c with (NOLOCK) on a.VitalTypeSID=c.VitalTypeSID 
where (a.VitalSignTakenDateTime between dateadd(month, -6, b.GLP1FillTime) and dateadd(day, 1, b.GLP1FillTime))AND 
c.VitalType in ('pulse','zzpulse')

select distinct scrssn from Dflt.Diabetes_AF_GLP1_HR --1453

/*  Heart Rate 6 months before drug initiation- DPP4 */

select distinct a.PatientSID, a.VitalSignTakenDateTime, a.VitalResult, a.VitalResultNumeric, a.diastolic, a.Systolic,
 b.DPP4Filltime, b.ScrSSN, 
c.VitalType

into Dflt.Diabetes_AF_DPP4GLP1_HR

from Src.Vital_VitalSign as a with (NOLOCK) inner join
Dflt.Diabetes_AF_DPP4GLP1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.VitalType as c with (NOLOCK) on a.VitalTypeSID=c.VitalTypeSID 
where (a.VitalSignTakenDateTime between dateadd(month, -6, b.DPP4Filltime) and dateadd(DAY, 1, b.DPP4Filltime)) AND
c.VitalType in ('pulse','zzpulse')
union all

select distinct a.PatientSID, a.VitalSignTakenDateTime, a.VitalResult, a.VitalResultNumeric,a.diastolic, a.Systolic,
b.DPP4Filltime,b.ScrSSN, 
c.VitalType

from Src.Vital_VitalSign_Recent as a with (NOLOCK) inner join
Dflt.Diabetes_AF_DPP4GLP1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.VitalType as c with (NOLOCK) on a.VitalTypeSID=c.VitalTypeSID 
where (a.VitalSignTakenDateTime between dateadd(month, -6, b.DPP4Filltime) and dateadd(day, 1, b.DPP4Filltime))AND 
c.VitalType in ('pulse','zzpulse')

select distinct scrssn from Dflt.Diabetes_AF_DPP4GLP1_HR --1940

/* Heart Rate 7 days after drug initiation - GLP1 */

select distinct a.PatientSID, a.VitalSignTakenDateTime, a.VitalResult, a.VitalResultNumeric, a.systolic, a.diastolic,
 b.GLP1FillTime, b.ScrSSN, 
c.VitalType

into Dflt.Diabetes_AF_GLP1_HRAfter

from Src.Vital_VitalSign as a with (NOLOCK) inner join
Dflt.Diabetes_AF_GLP1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.VitalType as c with (NOLOCK) on a.VitalTypeSID=c.VitalTypeSID 
where a.VitalSignTakenDateTime > dateadd(DAY, 7, b.GLP1FillTime) and
c.VitalType in ('pulse','zzpulse')
union all

select distinct a.PatientSID, a.VitalSignTakenDateTime, a.VitalResult, a.VitalResultNumeric,a.systolic, a.diastolic,
b.GLP1FillTime,b.ScrSSN, 
c.VitalType

from Src.Vital_VitalSign_Recent as a with (NOLOCK) inner join
Dflt.Diabetes_AF_GLP1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.VitalType as c with (NOLOCK) on a.VitalTypeSID=c.VitalTypeSID 
where a.VitalSignTakenDateTime > dateadd(DAY, 7, b.GLP1FillTime) AND 
c.VitalType in ('pulse','zzpulse')

select distinct scrssn from Dflt.Diabetes_AF_GLP1_HRAfter --1491

/*  Heart Rate 7 days after drug initiation- DPP4 */

select distinct a.PatientSID, a.VitalSignTakenDateTime, a.VitalResult, a.VitalResultNumeric, a.diastolic, a.Systolic,
 b.DPP4Filltime, b.ScrSSN, 
c.VitalType

into Dflt.Diabetes_AF_DPP4GLP1_HRAft

from Src.Vital_VitalSign as a with (NOLOCK) inner join
Dflt.Diabetes_AF_DPP4GLP1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.VitalType as c with (NOLOCK) on a.VitalTypeSID=c.VitalTypeSID 
where a.VitalSignTakenDateTime > dateadd(DAY, 7, b.DPP4FillTime) AND
c.VitalType in ('pulse','zzpulse')
union all

select distinct a.PatientSID, a.VitalSignTakenDateTime, a.VitalResult, a.VitalResultNumeric,a.diastolic, a.Systolic,
b.DPP4Filltime,b.ScrSSN, 
c.VitalType

from Src.Vital_VitalSign_Recent as a with (NOLOCK) inner join
Dflt.Diabetes_AF_DPP4GLP1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.VitalType as c with (NOLOCK) on a.VitalTypeSID=c.VitalTypeSID 
where a.VitalSignTakenDateTime > dateadd(DAY, 7, b.DPP4FillTime) AND
c.VitalType in ('pulse','zzpulse')

select distinct scrssn from Dflt.Diabetes_AF_DPP4GLP1_HRAft --1968