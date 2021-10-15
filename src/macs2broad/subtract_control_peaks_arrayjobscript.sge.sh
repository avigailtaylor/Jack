#!/bin/bash

# Specify a job name
#$ -N subcp

# Project name and target queue
#$ -P macaulay.prjc
#$ -q short.qc

# Array settings
#$ -t 1-9:1
#$ -tc 9

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

module load BEDTools/2.30.0-GCC-10.2.0

TEST_STUB=`cat meta/test_control_pairs.txt | tail -n+${SGE_TASK_ID} | head -1 | cut -f1`
CONTROL_STUB=`cat meta/test_control_pairs.txt | tail -n+${SGE_TASK_ID} | head -1 | cut -f2`

rm -rf job_outputs/subcp_output/${TEST_STUB}.broadPeak.remaining.bed

echo "bedtools intersect -a job_outputs/macs2broad_output/${TEST_STUB}_Inputsample_peaks.broadPeak -b job_outputs/macs2broad_output/${CONTROL_STUB}_Inputsample_peaks.broadPeak -v"

bedtools intersect -a job_outputs/macs2broad_output/${TEST_STUB}_Inputsample_peaks.broadPeak -b job_outputs/macs2broad_output/${CONTROL_STUB}_Inputsample_peaks.broadPeak -v > \
job_outputs/subcp_output/${TEST_STUB}.broadPeak.remaining.bed


bedtools intersect -a job_outputs/macs2broad_output/${TEST_STUB}_Inputsample_peaks.broadPeak -b job_outputs/macs2broad_output/${CONTROL_STUB}_Inputsample_peaks.broadPeak -v \
| grep -v 'gl' > job_outputs/subcp_output/${TEST_STUB}.broadPeak.remaining.filtered.bed

module purge

rv=$?
#
##########################################################################################

echo "Finished at: "`date`
exit $rv

