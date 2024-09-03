#!/bin/bash
#PBS -l nodes=1:ppn=10
#PBS -l mem=100Gb
#PBS -l walltime=24:00:00

cd $PBS_O_WORKDIR

###Paramerts for Stellenbosch University HCP2#######
Dependancies: bwa
Dependancies: samtools
Dependancies: Java
Dependancies: Pyhton2
Dependancies: GATK


module load app/bwa
module load python/2.7.12
module load app/gatk/4.4.0.0


### Read mapping and initial variant calling for individual isolates/samples
#Change /path/to/data/ to the directory storing you trimmed data
#Change REF to your reference name

for i in %

do

$i\_corrected.bam
$i\_marked_dup_metrics.txt
$i\_marked_duplicates.bai
$i\_marked_duplicates.bam
$i\_sorted.bam
$i\.bam
$i\.sam
$i\.sh.e*
$i\.sh.o*
$i\.vcf.gz
$i\.vcf.gz.tbi

bwa mem -t 10 REF /path/to/data/$i/$i\_1_val_1.fq /path/to//$i/$i\_2_val_2.fq > $i\.sam 

###convert sam to bam
java -jar /apps/picard/2.11.0/picard.jar SamFormatConverter \
          INPUT=$i\.sam \
          OUTPUT=$i\.bam \

#### sort sam file and give correct header           
java -jar /apps/picard/2.11.0/picard.jar SortSam \
      I=$i\.bam \
      O=$i\_sorted.bam \
      SORT_ORDER=coordinate
      CREATE_INDEX=TRUE
         
java -jar /apps/picard/2.11.0/picard.jar AddOrReplaceReadGroups \
			I=$i\_sorted.bam \
			O=$i\_corrected.bam \
			RGID=$i \
			RGLB=lib1 \
			RGPL=IonTorrent \
			RGPU=unit1 \
			RGSM=$i

###Mark duplicates
java -jar /apps/picard/2.11.0/picard.jar MarkDuplicates \
          I=$i\_corrected.bam \
          O=$i\_marked_duplicates.bam \
          M=$i\_marked_dup_metrics.txt \
          CREATE_INDEX=TRUE \
          VALIDATION_STRINGENCY=SILENT

###Variant calling
gatk --java-options "-Xmx100g" HaplotypeCaller \
	--emit-ref-confidence BP_RESOLUTION \
	--output-mode EMIT_ALL_CONFIDENT_SITES \
    --assembly-region-padding 100 \
	-ploidy 1 \
	-R UNSE01.fasta \
	-I $i\_marked_duplicates.bam \
	-O $i\.vcf.gz


done

