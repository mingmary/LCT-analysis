#!/bin/bash
#PBS -l walltime=24:00:00
#PBS -l nodes=1:ppn=1
#PBS -l vmem=24g
#PBS -N sample
#PBS -o outputreads.txt
#PBS -e errorreads.txt

filelist[0]=file1
filelist[1]=file2
filelist[2]=file3
filelist[3]=file4

for el in "${filelist[@]}"; do
  sed '5!D' /workingdir/bam_files/$el.dedup.bam.flagstat
done

#outputreads.txt contains the amount of reads aligned to the reference sequence (first number in each line) for all the samples in the order from the filelist
#the numbers can be copied to excel to create a count matrix