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
-pccardtools
-samttols <br/>
-vcftools <br/>
-GATK <br/>
-Python2 <br/>
-Java <br/>


1. Ouality_control.sh
Script to extract SRA data to fastq with SRA toolkit and trim data according to Novogene's sequencing report recommendations. These parameters can be adjusted on a case by case basis to accommodate different sequencing qualities and barcodes used.
Also report sequencing statistics before and after trimming.

2a. Assembly.sh
Wrapper script to submit Ind_assembly.sh script for each isolate in dataset. To reduce walltime in comparison to doing it in series.

2b. Ind_assembly
Script to assembly Illumina fastq data with Spades.

3. In_silico_PCR_blast
Script to do an in silico PCR do detemine location of region of interest in assebled genomes, extract region of interes from genomes, and perform a local Blast to determine nucleotide identity to a databases of known genes.

Example: extract avirulence genes of L. maculans from assemlbed genomes, and Blast against known Avr alleles to determine allele identity. The extracted genes can then be exported to be futher examined in an alignment program.

4a. Mapping.sh
Wrapper script to create a directory for mapping to be housed, create reference sequence indices and launch read mapping for each isolate.

4b. Ind_mapping.sh
Script to perform read mapping and variant calling on individual isolates (to reduce walltime).

5a. Genomicsdb.sh
Once the mapping and variant calling for individual isolate are done, combine variant calling files, per genomic region (per choromosome in reference file, to reduce walltime).
Wrapper script to launch scripts for each genomic region.

5b. Ind_Genomicsdb.sh
Combine variant calling data for isolates into a database suitalbe for GATK

6. Variant_calling_filter.sh
Recallibrate variant calls and filter

Example data: <br/>
SraRunTable.txt <br/> Tab-delimited file the NBCI's short read archive (SRA) numbers and isolate   names
Avr_primers.txt <br/>
AvrLm_ref_alleles.fa <br/>
REFChrom.list
sample.map

