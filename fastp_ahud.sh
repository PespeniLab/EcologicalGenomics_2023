#!/bin/bash   

# This script loops through a set of files defined by MYSAMP, matching left and right reads
# and cleans the raw data using fastp according to parameters set below

# cd to the location (path) to the fastq data:

cd /data/project_data/RNAseq/rawdata

# Define the sample code to anlayze
# Be sure to replace with your 5-6-digit sample code

MYSAMP="AA_F11"

# for each file that has "MYSAMP" and "_1.fq.gz" (read 1) in the name
# the wildcard here * allows for the different reps to be captured in the list
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

# call fastp
/data/popgen/fastp -i ${READ1} -I ${READ2} -o /data/project_data/RNAseq/cleandata/${NAME1} -O /data/project_data/RNAseq/cleandata/${NAME2} \
--detect_adapter_for_pe \
--trim_front1 24 \
--trim_poly_g \
--thread 1 \
--cut_right \
--cut_window_size 6 \
--qualified_quality_phred 20 \
--length_required 35 \
--html ~/myresults/fastp/${NAME1}.html \
--json ~/myresults/fastp/${NAME1}.json

done