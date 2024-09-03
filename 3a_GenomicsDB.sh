#!/bin/bash
#PBS -l nodes=1:ppn=1
#PBS -l mem=1000Gb
#PBS -l walltime=100:10:00

###Paramerts for Stellenbosch University HCP2#######

cd $PBS_O_WORKDIR

###launch scripts vor each genomic region (to reduce walltime it takes to combine data)
#Prepare sample.map file, tab-delimited listing sample names and path to find .vcf.gz files (created with Ind_mapping.sh, see example_data)
#Prepare REFChrom<num>.list files for each genomic region/ chromosome, where <num> is the number of the chromosome/genomic region. File should contain name of chromosome/genomic region (see example_data for REFChrom<num>.list files for the 33 chromosomes of L. maculans)

cd Mapping

# change number to your number of chromosomes/genomic regions

for i in {1..33} 

do

cp ../Ind_GenomicsDB.sh GenomicsDB_$i\.sh

sed -i "s/%/$i/g" GenomicsDB_$i\.sh

qsub GenomicsDB_$i\.sh

done


