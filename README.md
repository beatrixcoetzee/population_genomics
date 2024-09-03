# crispy-dollop
A collection of bash scripts for HTS data analysis

A set of bash scripts for quality control (1), mapping (2,3) and variant calling (4)  of HTS data and an R script for population genetics (5); and assembly (6) and in silico PCR (7) of HTS data to extract gene regions.

Ensure that all software packages are installed and change the paths in the scripts to be able to find the sofware: <br/>
-SRA-toolkit <br/>
-TrimGalore! <br/>
-Spades <br/>
-iPCRess <br/>
-Blast <br/>
-Bedtools <br/>
-BWA <br/>
-pccardtools
-samttols <br/>
-vcftools <br/>
-GATK <br/>
-Python2 <br/>
-Java <br/>
-Plink <br/>

1.	Ouality_control.sh
Script to extract SRA data to fastq with SRA toolkit and trim data according to Novogene's sequencing report recommendations. These parameters can be adjusted on a case by case basis to accommodate different sequencing qualities and barcodes used. Also report sequencing statistics before and after trimming.

2a. 	Mapping.sh
Wrapper script to create a directory for mapping to be housed, create reference sequence indices and launch read mapping for each isolate.

2b. 	Ind_mapping.sh 
Script to perform read mapping and variant calling on individual isolates (to reduce walltime).

3a. 	Genomicsdb.sh 
Once the mapping and variant calling for individual isolate are done, combine variant calling files, per genomic region (per choromosome in reference file, to reduce walltime). Wrapper script to launch scripts for each genomic region.

3b. 	Ind_Genomicsdb.sh 
Combine variant calling data for isolates into a database suitalbe for GATK.

4.	Variant_calling_filter.sh 
Recallibrate variant calls and filter.

5.

6a. 	Assembly.sh 
Wrapper script to submit Ind_assembly.sh script for each isolate in dataset. To reduce walltime in comparison to doing it in series.

6b. 	Ind_assembly 
Script to assembly Illumina fastq data with Spades.

7.	In_silico_PCR_blast.sh
Script to do an in silico PCR do detemine location of region of interest in assebled genomes, extract region of interes from genomes, and perform a local Blast to determine nucleotide identity to a databases of known genes.
Example: extract avirulence genes of L. maculans from assembled genomes, and Blast against known Avr alleles to determine allele identity. The extracted genes can then be exported to be further examined in an alignment program.

Example data: <br/>
SraRunTable.txt:  Tab-delimited file contianing the NBCI's short read archive (SRA) numbers and isolate names <br/>
Avr_primers.txt: Primers used to extrac L. maculans Avr genes with in silico PCR (it's just the first and last +/- 15 nts of eahc Arv gene) <br/>
AvrLm_ref_alleles.fa: Databasis of current L. maculans Avr alleles <br/>
REFChrom.list: directory of files, for each of the chromosomes in you reference sequence, each file containing the name of the chormosome <br/>
sample.map: list of isolate/sample names and path to their repective vcf files

