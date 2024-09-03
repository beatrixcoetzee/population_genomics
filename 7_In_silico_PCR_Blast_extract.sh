#!/bin/bash
#PBS -l nodes=1:ppn=1
#PBS -l mem=1Gb
#PBS -l walltime=1:00:00

###Paramerts for Stellenbosch University HCP2#######
# Dependancies: ipcress
# Dependancies: bedtools
# Dependancies: Blast

cd $PBS_O_WORKDIR

module load app/bedtools
module load app/NCBI

####Run in silico PCR with primers of your choice; example Avirulence genes in Leptosphaeria maculans
# change path/to to you SraRunTable.txt and Avr_primers.txt file paths
# make sure path to assembled genomes (Spades_$i/contigs.\fasta) is available

for primer in AvrLm1 AvrLm2 AvrLm3 AvrLm4 AvrLm5 AvrLm6 AvrLm10A AvrLm10B AvrLm11 AvrLm14 AvrLmS LMSTEE98
do
	rm Results
	rm  Bedfile
	rm *_ipcress
	rm $primer\.bed


	cut -f2 path/to/SraRunTable.txt | while read $i 
	do

		grep -w $primer path/to/Avr_primers.txt > Primer_test.txt

		/path/to/ipcress -i Primer_test.txt -m 5 -s Spades_$i/contigs.\fasta > $i\_ipcress 

		printf "$i \n" >> Results
		cat $i\_ipcress  >> Results

		printf "$i \t" >> Bedfile
		grep -m1 "ipcress:" $i\_ipcress >> Bedfile
		printf "\n" >> Bedfile
	
		rm Primer_test.txt

	done

### Create a bed file with start and stop positions of gene regions, extracted from above PCR results
		 
	sed -i "" '/^$/d' Bedfile
	awk '$2!=""' Bedfile > file1
	cut -f3 -d " " file1 | cut -f1 -d ":" > file2

	cut -f7 -d " " file1 > file3a
	cut -f10 -d " " file1 > file3b

	cut -f1 -d " " file1 > file4a
	cut -f12 -d " " file1 > file4b

	paste file2 file3a file3b file4a file4b > file5 

	cat file5 |  awk '{

	if ($5=="forward")
	  {
	    print $1, $2, $3+23, $4 
	  } 
	else if ($5=="revcomp")
	  {
	    print $1, $2, $3+23, $4
	  } 
	  }' > $primer\.bed

	sed -i "" 's/ /\t/g' $primer\.bed

	rm file1
	rm file2
	rm file3a
	rm file3b
	rm file4a
	rm file4b
	rm file5
	rm Bedfile

done

########################################################################

####### Make database against which to Blast; example known Avirulence alleles 
#change path/to to you AvrLm_ref_alleles.fasta file

/path/to/makeblastdb -in /path/to/AvrLm_ref_alleles.fasta -dbtype nucl -out AvrLm_ref_alleles


######## Concatenate all genome sequences assembled
# change path/to to you SraRunTable.txt

cut -f2 path/to/SraRunTable.txt | while read $i

do

cat Spades_$i/contigs.\fasta >> all.fasta
done

######## Extract gene sequences from assembled genomes and Blast against database of know Avr genes; use primer names previously supplied
# change path/to to you SraRunTable.txt
# make sure path to assembled genomes (Spades_$i/contigs.\fasta) is available

for i in  AvrLm1 AvrLm2  AvrLm3  AvrLm4 AvrLm5 AvrLm6 AvrLm10A AvrLm10B AvrLm11 AvrLm14 AvrLmS LMSTEE98

do

	/path/to/bedtools getfasta -fi all.fasta -bed $i\.bed -fo $i\.fasta -name


	/path/to/NCBI/BLAST/2.15.0+/bin/blastn -db AvrLm_ref_alleles -query $i\.fasta -num_threads 1 -outfmt "6 qseqid pident qcovs stitle" -out $i\_Blast.txt

	cat $i\_Blast.txt | awk '$3=="100" {print $0}' >> filea
	sort -k2,2 -n -r filea > $i\_Blast_sorted.txt
	rm filea

	rm $i\_ResultsRef.txt

	cut -f2 path/to/SraRunTable.txt | while read $iso
	do

		grep -m1 -w $iso $i\Blast_sorted.txt > file1
		printf "$iso" > file2
		paste file2 file1 >> $i\_ResultsRef.txt

		rm file1
		rm file2

	done

done

