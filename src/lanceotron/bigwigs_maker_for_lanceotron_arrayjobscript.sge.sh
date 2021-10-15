#!/bin/bash

# Specify a job name
#$ -N bigwig_maker

# Project name and target queue
#$ -P macaulay.prjc
#$ -q short.qc

# Array settings
#$ -t 1-15:1
#$ -tc 5

# Log locations which are relative to the current
# working directory of the submission
#$ -o job_outputs/job_log_files
#$ -e job_outputs/job_error_files


# Job can re-run if stops early
#$ -r y

# Run the job in the current working directory
#$ -cwd -j y

# Run jobs using three cores
#$ -pe shmem 3

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

TEST=`cat meta/test_input_pairs.txt | tail -n+${SGE_TASK_ID} | head -1 | cut -f1`
rm -f temp/${TEST}.sorted.bam*

module load SAMtools/1.10-GCC-8.3.0
cp ../bt2/job_outputs/bt2_output/${TEST}.sorted.bam temp/
samtools index temp/${TEST}.sorted.bam
module purge

module load deepTools/3.3.1-foss-2018b-Python-3.6.6
bamCoverage --bam temp/${TEST}.sorted.bam -o job_outputs/bigwig_maker_output/${TEST}.lanceotron_ready.bw --extendReads -bs 1 --normalizeUsing RPKM

rm temp/${TEST}.sorted.bam*

module purge

rv=$?
#
##########################################################################################

echo "Finished at: "`date`
exit $rv

