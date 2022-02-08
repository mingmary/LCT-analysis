#PBS -l walltime=240000
#PBS -l nodes=1ppn=1
#PBS -l vmem=24g
#PBS -N sample
#PBS -o output.txt
#PBS -e error.txt
#PBS -t 0-3

filelist[0]=file1
filelist[1]=file2
filelist[2]=file3
filelist[3]=file4

module load fastqc
module load adapterremoval
module load multiqc

fastqc ${dirlist[PBS_ARRAYID]}.pair1.fastq ${dirlist[PBS_ARRAYID]}.pair2.fastq

#optional
AdapterRemoval \
--file1 ${dirlist[PBS_ARRAYID]}.pair1.fastq \
--file2 ${dirlist[PBS_ARRAYID]}.pair2.fastq \
--basename ${dirlist[PBS_ARRAYID]}

# to get the summary qc report: 
# multiqc .