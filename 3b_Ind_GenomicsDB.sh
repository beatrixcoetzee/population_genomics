#!/bin/bash
#PBS -l nodes=1:ppn=2
#PBS -l mem=500Gb
#PBS -l walltime=100:00:00

###Paramerts for Stellenbosch University HCP2#######

cd $PBS_O_WORKDIR

module load app/bwa
module load app/samtools
module load app/vcftools
module load python/2.7.12
module load app/Java/17.0.7.0.7-1

###combine variant calling data for isolates into a database suitalbe for GATK
#change REF to your reference name
#change /path/to/gatk
#make sure sample.map and REFchrom<num>.list is available, see GenomicsDB.sh for details and Examle_data for examples

rm -r Mydatabase%
rm -r tempdir%

mkdir tempdir%

python /path/to/gatk-4.5.0.0/gatk \
--java-options "-Xmx300g" GenomicsDBImport  \
-L REFchrom%.list  \
--sample-name-map sample.map \
--genomicsdb-workspace-path Mydatabase% \
--tmp-dir tempdir% \
--genomicsdb-shared-posixfs-optimizations true \
--batch-size 50


python /path/to/gatk-4.5.0.0/gatk \
--java-options "-Xmx1000g" GenotypeGVCFs \
--sample-ploidy 1 \
--use-new-qual-calculator TRUE \
-R REF.fasta \
-V gendb://Mydatabase%  \
--tmp-dir tempdir% \
-O Output%.vcf.gz\

