#!/bin/bash
#PBS -l nodes=1:ppn=1
#PBS -l mem=1Gb
#PBS -l walltime=100:00:00

###Paramerts for Stellenbosch University HCP2#######
# Dependancies: TrimGalore
# Dependancies: SRA-toolkit


cd $PBS_O_WORKDIR
module load app/TrimGalore!


cd /Folder/with/data

# change path/to to you SraRunTable.txt

cut -f1 path/to/SraRunTable.txt | while read SRAnum
do

### Extract SRA to fasta, change name to isolate name

path/to/sratoolkit/sratoolkit-version/bin/fasterq-dump $SRAnum

	grep $SRAnum ../SraRunTable.txt | cut -f2 | while read $i
	do

	mv $SRAnum\_1.fastq  > $i\_1.fastq
	mv $SRAnum\_2.fastq  > $i\_2.fastq

	# Trim and filter data; change parameters as needed

	trim_galore \
	-a AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGTAGATCTCGGTGGTCGCCGTATCATT \
	-a2 GATCGGAAGAGCACACGTCTGAACTCCAGTCACGGATGACTATCTCGTATGCCGTCTTCTGCTTG \
	--length 100 \
	--clip_R1 5 \
	--clip_R2 5 \
	--q 20 \
	--paired $i\_1.fastq $i\_2.fastq


	#Get sequencing stats before trimming and filtering
	awk 'NR%4==2' $i\_1.fastq > fread_file1
	wc -l fread_file1 > fread_file2
	wc -m fread_file1 > fread_file3
	printf $i > fread_fileA
	paste fread_file2 fread_file3 > fread_fileB
	paste fread_fileA fread_fileB > fread_fileC

	rm fread_file1
	rm fread_file2
	rm fread_file3
	rm fread_fileA
	rm fread_fileB

	awk 'NR%4==2' $i\_2.fastq > rread_file1
	wc -l rread_file1 > rread_file2
	wc -m rread_file1 > rread_file3
	printf $i > rread_fileA
	paste rread_file2 rread_file3 > rread_fileB
	paste rread_fileA rread_fileB > rread_fileC

	rm rread_file1
	rm rread_file2
	rm rread_file3
	rm rread_fileA
	rm rread_fileB

	paste fread_fileC rread_fileC | cat >> Sequence_stats_before_filtering

	rm fread_fileC 
	rm rread_fileC 
	
	
	#Get sequencing after trimming and  filtering 
	awk 'NR%4==2' $i\_1_val_2.fastq > fread_file1
	wc -l fread_file1 > fread_file2
	wc -m fread_file1 > fread_file3
	printf $i > fread_fileA
	paste fread_file2 fread_file3 > fread_fileB
	paste fread_fileA fread_fileB > fread_fileC

	rm fread_file1
	rm fread_file2
	rm fread_file3
	rm fread_fileA
	rm fread_fileB

	awk 'NR%4==2' $i\_2_val_2.fastq > rread_file1
	wc -l rread_file1 > rread_file2
	wc -m rread_file1 > rread_file3
	printf $i > rread_fileA
	paste rread_file2 rread_file3 > rread_fileB
	paste rread_fileA rread_fileB > rread_fileC

	rm rread_file1
	rm rread_file2
	rm rread_file3
	rm rread_fileA
	rm rread_fileB

	paste fread_fileC rread_fileC | cat >> Sequence_stats_before_filtering

	rm fread_fileC 
	rm rread_fileC 


	done
done



