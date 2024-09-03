#!/bin/bash
#PBS -l nodes=1:ppn=1
#PBS -l mem=1000Gb
#PBS -l walltime=100:10:00

###Paramerts for Stellenbosch University HCP2#######
Dependancies: bwa
Dependancies: samtools
Dependancies: vcftools
Dependancies: python2
Dependancies: Java
Dependancies: Plink


cd $PBS_O_WORKDIR

module load app/bwa
module load app/samtools
module load app/vcftools
module load python/2.7.12
module load app/Java/17.0.7.0.7-1

###Combine data for genomic regions into one vcf
###Output<num>.vsf.gz should have been created for each chromosome in you reference sequence
#Change Thirtythreecombined to your desired output name
#Change /path/to to the path of gatk and piccard tools

cd Mapping

java -jar /path/to/apps/picard/2.11.0/picard.jar GatherVcfs \
I=Output1.vcf.gz \
I=Output2.vcf.gz \
I=Output3.vcf.gz \
I=Output4.vcf.gz \
I=Output5.vcf.gz \
I=Output6.vcf.gz \
I=Output7.vcf.gz \
I=Output8.vcf.gz \
I=Output9.vcf.gz \
I=Output10.vcf.gz \
I=Output11.vcf.gz \
I=Output12.vcf.gz \
I=Output13.vcf.gz \
I=Output14.vcf.gz \
I=Output15.vcf.gz \
I=Output16.vcf.gz \
I=Output17.vcf.gz \
I=Output18.vcf.gz \
I=Output19.vcf.gz \
I=Output20.vcf.gz \
I=Output21.vcf.gz \
I=Output22.vcf.gz \
I=Output23.vcf.gz \
I=Output24.vcf.gz \
I=Output25.vcf.gz \
I=Output26.vcf.gz \
I=Output27.vcf.gz \
I=Output28.vcf.gz \
I=Output29.vcf.gz \
I=Output30.vcf.gz \
I=Output31.vcf.gz \
I=Output32.vcf.gz \
I=Output33.vcf.gz \
O=Thirtythreecombined.vcf.gz
   
python /path/to/gatk-4.5.0.0/gatk \
--java-options "-Xmx1000g" IndexFeatureFile \
-I Thirtythreecombined.vcf.gz
     
#### Filter variant 
#Change filter parameters as necessary
#Change REF to your reference sequence name
#Change Thirtythreecombined to your desired output name

python /path/to/gatk-4.5.0.0/gatk \
--java-options "-Xmx500g" VariantFiltration \
-R REF.fasta \
-V Thirtythreecombined.vcf.gz \
-O Filtered.vcf.gz \
--filter-name QD -filter 'QD<20.0' \
--filter-name QUAL -filter 'QUAL<50.0' \
--filter-name SOR -filter 'SOR>3.0' \
--filter-name MQ -filter 'MQ<40.0' \
--filter-name FS -filter 'FS>60.0' \
--genotype-filter-name GQ -genotype-filter-expression 'GQ<20' 

### Select only SNPs and those that passed previous filters

python /path/to/gatk-4.5.0.0/gatk \
--java-options "-Xmx500g" SelectVariants \
-R UNSE01.fasta \
--exclude-filtered TRUE \
--exclude-non-variants TRUE \
--max-nocall-number 0 \
--max-filtered-genotypes 0 \
--select-type-to-include SNP \
-V Filtered.vcf.gz \
-O Selected.vcf.gz 

### Recode vcf in plink format
vcftools --gzvcf Selected.vcf.gz --recode --recode-INFO-all --plink Recoded.vcf

### Remove SNPs in linkage disequilibrium
/home/beatrix/Software/plink2 \
--vcf Selected.vcf.gz \
--rm-dup list \
--set-all-var-ids '@:#' \
--bad-ld \
--allow-extra-chr \
--chr-set -33 \
--indep-pairwise 100 1 0.1 \
-export vcf \
--out  plinkoutput

/home/beatrix/Software/plink2 \
--set-all-var-ids '@:#' \
--allow-extra-chr \
--vcf Selected.vcf.gz \
--extract plinkoutput.prune.in \
--out Plink_final \
--recode vcf


