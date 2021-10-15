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

rm -rf temp/${TEST_STUB}_${CONTROL_STUB}
mkdir temp/${TEST_STUB}_${CONTROL_STUB}

tail -n+2 job_outputs/lanceotron_output/Inputsample_${TEST_STUB}_L-tron.bed | cut -f1-4 > temp/${TEST_STUB}_${CONTROL_STUB}/${TEST_STUB}.bed
tail -n+2 job_outputs/lanceotron_output/Inputsample_${CONTROL_STUB}_L-tron.bed | cut -f1-4 > temp/${TEST_STUB}_${CONTROL_STUB}/${CONTROL_STUB}.bed

rm -rf job_outputs/subcp_output/${TEST_STUB}.lanceotron.remaining.bed
rm -rf job_outputs/subcp_output/${TEST_STUB}.lanceotron.remaining.filtered.bed

bedtools intersect -a temp/${TEST_STUB}_${CONTROL_STUB}/${TEST_STUB}.bed -b temp/${TEST_STUB}_${CONTROL_STUB}/${CONTROL_STUB}.bed -v > \
job_outputs/subcp_output/${TEST_STUB}.lanceotron.remaining.bed

bedtools intersect -a temp/${TEST_STUB}_${CONTROL_STUB}/${TEST_STUB}.bed -b temp/${TEST_STUB}_${CONTROL_STUB}/${CONTROL_STUB}.bed -v | awk '{if($4>0.8) print $0}' > \
job_outputs/subcp_output/${TEST_STUB}.lanceotron.remaining.filtered_0.8.bed

bedtools intersect -a temp/${TEST_STUB}_${CONTROL_STUB}/${TEST_STUB}.bed -b temp/${TEST_STUB}_${CONTROL_STUB}/${CONTROL_STUB}.bed -v | awk '{if($4>0.5) print $0}' > \
job_outputs/subcp_output/${TEST_STUB}.lanceotron.remaining.filtered_0.5.bed


module purge

rm -rf temp/${TEST_STUB}_${CONTROL_STUB}



rv=$?
#
##########################################################################################

echo "Finished at: "`date`
exit $rv

