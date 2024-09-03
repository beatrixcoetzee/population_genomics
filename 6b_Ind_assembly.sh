#!/bin/bash
#PBS -l nodes=1:ppn=8
#PBS -l mem=100Gb
#PBS -l walltime=10:00:00

cd $PBS_O_WORKDIR

###Paramerts for Stellenbosch University HCP2#######
# Dependancies: Spades


# change path/to/data to you trimmed reads directory

for i in %
do 

spades.py -k 21,33,55,77,99,127 -t 8 -m 100  --pe1-1 path/to/data/$i\_1_val_1.fq --pe1-2 path/to/data/$i/$i\_2_val_2.fq --careful -o Spades_$i


done
