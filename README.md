# crispy-dollop
A collection of bash scripts for HTS data analysis

A set of bash scripts for quality control, assembly, in silico PCR of HTS data to extract gene regions;  
and mapping and variant calling of HTS data for population genetics.

Ensure that all software packages are installed and change the paths in the scripts to be able to find the sofware: <br/>
-SRA-toolkit <br/>
-TrimGalore! <br/>
-Spades <br/>
-iPCRess <br/>
-Blast <br/>
-Bedtools <br/>
-BWA <br/>
-GATK <br/>


1. Ouality_control.sh

Script to extract SRA data to fastq with SRA toolkit and trim data according to Novogene's sequencing report recommendations. These parameters can be adjusted on a case by case basis to accommodate different sequencing qualities and barcodes used.
Also report sequencing statistics before and after trimming.

2a. Assembly.sh
Wrapper script to submit Ind_assembly.sh script for each isolate in dataset.

2b. Ind_assembly
Script to assembly Illumina fastq data with Spades.

3. In_silico_PCR_blast
Script to do an in silico PCR do detemine location of region of interest in assebled genomes, extract region of interes from genomes, and perform a local Blast to determine nucleotide identity to a databases of known genes.
Example: extract avirulence genes of L. maculans from assemlbed genomes, and Blast against known Avr alleles to determine allele identity. The extracted genes can then be exported to be futher examined in an alignment program.

Example data: <br/>
SraRunTable.txt <br/>
Avr_primers.txt <br/>
AvrLm_ref_alleles.fa <br/>

