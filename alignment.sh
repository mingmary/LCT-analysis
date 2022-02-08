#!/bin/bash
#PBS -l walltime=24:00:00
#PBS -l nodes=1:ppn=1
#PBS -l vmem=24g
#PBS -N sample
#PBS -o output.txt
#PBS -e error.txt
#PBS -t 0-3

filelist[0]=file1
filelist[1]=file2
filelist[2]=file3
filelist[3]=file4

module load bwa
module load samtools

mkdir /workingdir #directory with output files
mkdir /workingdir/bam_files
mkdir /workingdir/reference 

#reference file in fasta format should be put to /workingdir/reference
#fastq processed files should be put to /workingdir:
cp _pathtofastqfiles_/*.truncated /workingdir

bwa index \
/workingdir/reference/reference.fa

bwa mem \
/workingdir/reference/reference.fa \
/workingdir/${dirlist[PBS_ARRAYID]}.pair1.truncated \
/workingdir/${dirlist[PBS_ARRAYID]}.pair2.truncated \
| samtools view -Sb - | samtools sort -o /workingdir/bam_files/${dirlist[PBS_ARRAYID]}.sorted.bam

java -Xms128m -Xmx1024m -Djava.io.tmpdir=$TMPDIR -jar /cm/shared/apps/picard/2.6.0/picard.jar MarkDuplicates \
I=/workingdir/bam_files/${dirlist[PBS_ARRAYID]}.sorted.bam \
O=/workingdir/bam_files/${dirlist[PBS_ARRAYID]}.dedup.bam REMOVE_DUPLICATES=true \
M=/workingdir/bam_files/${dirlist[PBS_ARRAYID]}.dedup.bam.metrics

samtools flagstat /workingdir/bam_files/${dirlist[PBS_ARRAYID]}.dedup.bam > /workingdir/bam_files/${dirlist[PBS_ARRAYID]}.dedup.bam.flagstat




