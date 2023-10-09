#!/bin/bash 
 
# Below is a script to loop through the files in the /rawdata directory, identify matches,  
# and clean the fastq files, and direct output to /cleandata 
 
cd /data/project_data/RNAseq/rawdata

# Define the sample code to anlayze
# Be sure to replace with your 5-6-digit sample code

MYSAMP="AA_F11"

# for each file that has "MYSAMP" and "1" (read 1) in the name 
# start a loop with this file as the input:

for READ1 in ${MYSAMP}*_1.fq.gz
do

# the partner to this file (read 2) can be found by replacing the _1.fq.gz with _2.fq.gz
# second part of the input for PE reads

READ2=${READ1/_1.fq.gz/_2.fq.gz}

# make the output file names: print the fastq name, replace _# with _#_clean

NAME1=$(echo $READ1 | sed "s/_1/_1_clean/g")
NAME2=$(echo $READ2 | sed "s/_2/_2_clean/g")

# print the input and output to screen 

echo $READ1 $READ2
echo $NAME1 $NAME2

echo "found a match $READ1 and $READ2 ; now cleaning"

# call trimmomatic
    java -classpath /data/popgen/Trimmomatic-0.39/trimmomatic-0.39.jar org.usadellab.trimmomatic.TrimmomaticPE \
            -threads 1 \
            -phred33 \
             "$READ1" \
             "$READ2" \                 
             /data/project_data/RNAseq/cleandata/$NAME1"_paired.fq" \
             /data/project_data/RNAseq/cleandata/unpaired/$NAME1"_unpaired.fq" \
             /data/project_data/RNAseq/cleandata/$NAME2"_paired.fq" \
             /data/project_data/RNAseq/cleandata/unpaired/$NAME2"_unpaired.fq" \
             ILLUMINACLIP:/data/popgen/Trimmomatic-0.39/adapters/TruSeq3-PE.fa:2:30:10 \
             LEADING:20 \
             TRAILING:20 \
             SLIDINGWINDOW:6:20 \
             MINLEN:35
# latest Illumina runs are phred 33 [[http://en.wikipedia.org/wiki/FASTQ_format]] 
# HEADCROP cuts the number of bases chosen from the head 
# SLIDINGWINDOW average the quality score across (6) bases and trims if avg is less than (28) 
# MINLEN excludes reads that are less than 40 bp long 
# 4 output files paired and unpaired for each side 

done