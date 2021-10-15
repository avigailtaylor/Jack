#!/bin/bash

# Specify a job name
#$ -N bt2

# Project name and target queue
#$ -P macaulay.prjc
#$ -q short.qc

# Array settings
#$ -t 1-16:1
#$ -tc 16

# Log locations which are relative to the current
# working directory of the submission
#$ -o job_outputs/job_log_files
#$ -e job_outputs/job_error_files


# Job can re-run if stops early
#$ -r y

# Run the job in the current working directory
#$ -cwd -j y

# Some useful data about the job
echo "------------------------------------------------"
echo "SGE Job ID: $JOB_ID"
echo "SGE Task ID: $SGE_TASK_ID"
echo SGE_TASK_FIRST=${SGE_TASK_FIRST}
echo SGE_TASK_LAST=${SGE_TASK_LAST}
echo SGE_TASK_STEPSIZE=${SGE_TASK_STEPSIZE}
echo "Run on host: "`hostname`
echo "Operating system: "`uname -s`
echo "Username: "`whoami`
echo "Started at: "`date`
echo "------------------------------------------------"

##########################################################################################
#
# Do any one-off set up here
#
# None to do...
#
##########################################################################################

##########################################################################################
#    
# Do your per-task processing here
#
## For example, run an R script that uses the task id directly:
## Rscript /path/to/my/rscript.R ${SGE_TASK_ID}

module load Bowtie2/2.3.5.1-GCC-8.3.0 
module load SAMtools/1.10-GCC-8.3.0

SAMPLE=`cat meta/samples_filenames.txt | tail -n+${SGE_TASK_ID} | head -1 | cut -f1`
FASTQ_FILES_1=`cat meta/samples_filenames.txt | tail -n+${SGE_TASK_ID} | head -1 | cut -f2`
FASTQ_FILES_2=`cat meta/samples_filenames.txt | tail -n+${SGE_TASK_ID} | head -1 | cut -f3`

bowtie2 -q --phred33 -x ../../data/genomes/hg19/index/hg19.p13.plusMT.no_alt_analysis_set \
-1 ${FASTQ_FILES_1} -2 ${FASTQ_FILES_2} |\
samtools view -b - | samtools sort -o job_outputs/bt2_output/${SAMPLE}.sorted.bam -

#-S job_outputs/bt2_output/${SAMPLE}.sam

module purge

rv=$?
#
##########################################################################################

echo "Finished at: "`date`
exit $rv

