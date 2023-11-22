# HapMLST

HapMLST is a pipeline that processes metagenomic data using EM algorithms and applies the allele sequence variants to quickly and accurately assess the abundance and ST type of bacteria based MLST classification.

## Pipeline
![image](https://github.com/Chen-Lab123/HapMLST/blob/main/pipeline/Figure1-1.png)

## Installation
### 1. install with docker??
- step1: ...
- step2: ...
### 2. install with Source code
- step1: git clone https://github.com/Chen-Lab123/HapMLST.git
- step2: 

## Database Preparation
All MLST classifications are summarized by tseemann basing on PubMLST Database.  You can download from : https://github.com/tseemann/mlst/tree/master/db. 

Normally, the database will be completed during the software installation process, if not, please check, or manually download.

If you want to more updated MLST information, please try to search in PubMLST Database: https://pubmlst.org/.


## Run Analysis
Downlaod the test data into folder (xxx). Test data is in Zenodo (doi:xxx): 

1. The first simulation dataset was a mixture of three ST Escherichia coli genomic reads.

2. The second dataset was an intestinal metagenomic reads from a healthy individual.

Note: the input files could be _1 or _2 with .fq, .fastq or .fq.gz, .fastq.gz. 

## Citation
The mlst software incorporates components of the PubMLST database which must be cited in any publications that use mlst:

"This publication made use of the PubMLST website (https://pubmlst.org/) developed by Keith Jolley (Jolley & Maiden 2010, BMC Bioinformatics, 11:595) and sited at the University of Oxford. The development of that website was funded by the Wellcome Trust".

You should also cite this software (currently unpublished) as:

Seemann T, mlst Github https://github.com/tseemann/mlst

Chen Chen, HapMLST Github https://github.com/Chen-Lab123/HapMLST
## FAQs
