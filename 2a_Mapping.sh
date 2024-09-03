#!/bin/bash
#PBS -l nodes=1:ppn=1
#PBS -l mem=1000Gb
#PBS -l walltime=100:10:00

###Paramerts for Stellenbosch University HCP2#######
Dependancies: bwa
Dependancies: samtools
Dependancies: Java
Dependancies: piccard



cd $PBS_O_WORKDIR

module load app/bwa
module load app/samtools
module load app/vcftools
module load python/2.7.12
module load app/Java/17.0.7.0.7-1

### Make a directory for mapping to be housed, and make reference index files
#change path/to/ref.fasta to the path where your reference sequence is located
# change path to find piccard tools
#change REF to you reference sequence name 

mkdir Mapping
cd Mapping

cp path/to/REF.fasta .
 
bwa index -p REF REF.fasta
 
samtools faidx REF.fasta

java -jar path/to/apps/picard/2.11.0/picard.jar CreateSequenceDictionary R=REF.fasta  O=REF.dict

###luanch individula mapping scripts for all isolates
# change path/to/SraRunTable.txt

cut -f1 path/to/SraRunTable.txt | while read i
do

	cp ../Ind_mapping.sh $i\.sh
	sed I="s/%/$i/g" $i\.sh
	qsub $i\.sh
done
	

