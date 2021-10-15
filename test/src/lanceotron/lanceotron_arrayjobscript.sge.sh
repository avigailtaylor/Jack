#!/bin/bash

# Specify a job name
#$ -N lanceotron

# Project name and target queue
#$ -P macaulay.prjc
#$ -q short.qc

# Array settings
#$ -t 1-24:1
#$ -tc 24

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

TEST=`cat meta/test_control_pairs.txt | tail -n+${SGE_TASK_ID} | head -1 | cut -f1`
CONTROL=`cat meta/test_control_pairs.txt | tail -n+${SGE_TASK_ID} | head -1 | cut -f2`

module use -a /apps/eb/2020b/skylake/modules/all
module load Python/3.8.6-GCCcore-10.2.0 BEDTools/2.30.0-GCC-10.2.0
. /well/macaulay/users/opl537/Applications/lanceotron-venv/bin/activate

python /well/macaulay/users/opl537/Applications/LanceOtron/modules/find_and_score_peaks_with_input.py \
http://macaulay00.bmrc.ox.ac.uk/test_data/lanceotron_input/${TEST}.lanceotron_ready.bw \
-i http://macaulay00.bmrc.ox.ac.uk/test_data/lanceotron_input/${CONTROL}.lanceotron_ready.bw \
-f job_outputs/lanceotron_output/

#http://pania:dalvanius@macaulay00.bmrc.ox.ac.uk/test_data/lanceotron_input/${TEST}.lanceotron_ready.bw \
#-i http://pania:dalvanius@macaulay00.bmrc.ox.ac.uk/test_data/lanceotron_input/${CONTROL}.lanceotron_ready.bw \


deactivate
module purge

rv=$?
#
##########################################################################################

echo "Finished at: "`date`
exit $rv

