#!/bin/bash

# Specify a job name
#$ -N filter

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

TEST_STUB=`cat meta/test_samples_only.txt | tail -n+${SGE_TASK_ID} | head -1 | cut -f1`

tail -n+2 job_outputs/lanceotron_output/Inputsample_${TEST_STUB}_L-tron.bed | cut -f1-4 | awk '{if($4>0.8) print $0}' > \
job_outputs/filtered_output/${TEST_STUB}.lanceotron.filtered_0.8.bed

rv=$?
#
##########################################################################################

echo "Finished at: "`date`
exit $rv

