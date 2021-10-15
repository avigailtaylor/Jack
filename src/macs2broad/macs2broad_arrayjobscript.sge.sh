#!/bin/bash

# Specify a job name
#$ -N macs2broad

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

module load MACS2/2.2.6-foss-2018b-Python-3.6.6

TEST=`cat meta/test_input_pairs.txt | tail -n+${SGE_TASK_ID} | head -1 | cut -f1`
CONTROL=`cat meta/test_input_pairs.txt | tail -n+${SGE_TASK_ID} | head -1 | cut -f2`

macs2 callpeak -t ../bt2/job_outputs/bt2_output/${TEST}.sorted.bam \
--broad \
-c ../bt2/job_outputs/bt2_output/${CONTROL}.sorted.bam \
-f BAM -g hs -n ${TEST}_${CONTROL} -B -q 0.01 \
--outdir job_outputs/macs2broad_output


module purge

rv=$?
#
##########################################################################################

echo "Finished at: "`date`
exit $rv

