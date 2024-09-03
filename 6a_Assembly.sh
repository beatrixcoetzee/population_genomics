#!/bin/bash
#PBS -l nodes=1:ppn=1
#PBS -l mem=1Gb
#PBS -l walltime=1:00:00

###Paramerts for Stellenbosch University HCP2#######
# Dependancies: Spades


cd $PBS_O_WORKDIR

### Make directory for all assemblies to be housed
mkdir Assembly
cd Assembly

### Submit assembly assembly script for each isolate
# change path/to to you SraRunTable.txt
cut -f2 /path/to/SraRunTable.txt | while read $i

do

cp ../Ind_assembly.sh $i\.sh

sed -i "s/%/$i/g" $i\.sh

qsub $i\.sh

done




