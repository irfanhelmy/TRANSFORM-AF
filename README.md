# TRANSFORM-AF

## Overview

This repository contains the SQL and STATA code used for cohort identification, data extraction, data preparation, and statistical analysis for **TRANSFORM-AF**, a nationwide study conducted within the U.S. Department of Veterans Affairs (VA) health system.

The SQL scripts were used to identify eligible patients, define medication exposure groups, extract study variables, and create analytic cohorts from VA data sources. The extracted data were then cleaned, merged, and analyzed using STATA.

The project includes two parallel analytic workflows:

1. A GLP-1 receptor agonist workflow
2. An SGLT2 inhibitor workflow

Each workflow includes its own cohort extraction code and a separate sequence of STATA do-files.

## Repository contents

This repository includes:

- SQL code for cohort identification and extraction of study variables from the VA database
- One SQL script for the GLP-1 receptor agonist cohort and its corresponding comparator cohort
- One SQL script for the SGLT2 inhibitor cohort and its corresponding comparator cohort
- STATA do-files for data cleaning, merging, variable construction, cohort assembly, and statistical analysis
- Sequentially numbered STATA do-files to indicate the order of the analytic workflow

## File organization and naming convention

The repository contains two parallel STATA workflows. Files beginning with **G** correspond to the GLP-1 receptor agonist analysis, and files beginning with **S** correspond to the SGLT2 inhibitor analysis. Within each workflow, the numeric ordering of the do-files reflects the intended sequence of data preparation, variable derivation, cohort assembly, and statistical analysis.

Throughout the files, **GLP1** refers to glucagon-like peptide-1 receptor agonists, and **SGLT2** refers to sodium-glucose cotransporter 2 inhibitors. The control group consists of a combination of dipeptidyl peptidase-4 inhibitors and sulfonylureas. In the file names and code, this combined control group is usually referred to as **dpp4**.

## Use and interpretation

These scripts were created within the VA data environment, including the VA Informatics and Computing Infrastructure (VINCI), and are intended to document the analytic methods used in the associated manuscript.

Because the underlying source data are not publicly available, and because some scripts depend on local VA table structures, file paths, and environment-specific settings, direct execution outside the VA environment may require modification.

This repository does **not** contain patient-level data.

## Reproducibility statement

The purpose of this repository is to enhance methodological transparency by providing the code used for data extraction and statistical analysis.

Reproduction of the full workflow requires appropriate authorization and access to VA data sources within the VA VINCI environment. The code is provided to support review of the analytic approach and to clarify how the study cohorts, exposure groups, covariates, outcomes, and statistical analyses were implemented.

## Contact

Please contact the repository owner with any questions regarding the code or workflow:

Irfan Helmy, MD | Varun Sundaram, MD, PhD, MSc

ixh119@case.edu | vxs173@case.edu

Louis Stokes Cleveland Veteran Affairs Medical Center

Case Western Reserve University School of Medicine
