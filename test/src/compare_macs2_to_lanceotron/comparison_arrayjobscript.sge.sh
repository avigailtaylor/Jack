#!/bin/bash

# Specify a job name
#$ -N comparison

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

rm -rf job_outputs/comparison_output/${TEST}_${CONTROL}.macs2_vs_lanceotron_peaks.txt
touch job_outputs/comparison_output/${TEST}_${CONTROL}.macs2_vs_lanceotron_peaks.txt
rm -rf temp/${TEST}_${CONTROL}
mkdir temp/${TEST}_${CONTROL}

cut -f1,2,3,8 /well/macaulay/users/opl537/Work_for_Others/Jack/test/src/macs2/job_outputs/macs2_output/${TEST}_${CONTROL}_peaks.narrowPeak > \
temp/${TEST}_${CONTROL}/${TEST}_${CONTROL}_macs2.simple.bed
cat temp/${TEST}_${CONTROL}/${TEST}_${CONTROL}_macs2.simple.bed | grep -v gl > temp/${TEST}_${CONTROL}/${TEST}_${CONTROL}_macs2.filtered.simple.bed 

tail -n+2 /well/macaulay/users/opl537/Work_for_Others/Jack/test/src/lanceotron/job_outputs/lanceotron_output/${CONTROL}_${TEST}_L-tron.bed | \
awk '{print $1 "\t" $2 "\t" $3 "\t" $4 "\t" $7}' > temp/${TEST}_${CONTROL}/${TEST}_${CONTROL}_lanceotron.simple.bed

module load BEDTools/2.30.0-GCC-10.2.0

echo "Comparing macs2 and lanceotron peak calls in ${TEST} vs ${CONTROL}" > job_outputs/comparison_output/${TEST}_${CONTROL}.macs2_vs_lanceotron_peaks.txt
echo "" >> job_outputs/comparison_output/${TEST}_${CONTROL}.macs2_vs_lanceotron_peaks.txt

MACS2_CALLS=`cat temp/${TEST}_${CONTROL}/${TEST}_${CONTROL}_macs2.simple.bed | wc -l`
MACS2_CALLS_FILTERED=`cat temp/${TEST}_${CONTROL}/${TEST}_${CONTROL}_macs2.filtered.simple.bed | wc -l`
LANCE_CALLS=`cat temp/${TEST}_${CONTROL}/${TEST}_${CONTROL}_lanceotron.simple.bed | wc -l`
LANCE_CALLS_FILTERED_1=`cat temp/${TEST}_${CONTROL}/${TEST}_${CONTROL}_lanceotron.simple.bed | awk '{if($4>0.8) print $0}' | wc -l`
LANCE_CALLS_FILTERED_2=`cat temp/${TEST}_${CONTROL}/${TEST}_${CONTROL}_lanceotron.simple.bed | awk '{if($4>0.8 && $5>1.3) print $0}' | wc -l`

echo "macs2 calls: ${MACS2_CALLS}" >> job_outputs/comparison_output/${TEST}_${CONTROL}.macs2_vs_lanceotron_peaks.txt
echo "macs2 calls filtered: ${MACS2_CALLS_FILTERED}" >> job_outputs/comparison_output/${TEST}_${CONTROL}.macs2_vs_lanceotron_peaks.txt
echo "lanceotron calls: ${LANCE_CALLS}" >> job_outputs/comparison_output/${TEST}_${CONTROL}.macs2_vs_lanceotron_peaks.txt
echo "lanceotron calls filtered 1: ${LANCE_CALLS_FILTERED_1}" >> job_outputs/comparison_output/${TEST}_${CONTROL}.macs2_vs_lanceotron_peaks.txt
echo "lanceotron calls filtered 2: ${LANCE_CALLS_FILTERED_2}" >> job_outputs/comparison_output/${TEST}_${CONTROL}.macs2_vs_lanceotron_peaks.txt

MACS2_ANY_OVERLAP=`bedtools intersect -a temp/${TEST}_${CONTROL}/${TEST}_${CONTROL}_macs2.filtered.simple.bed -b temp/${TEST}_${CONTROL}/${TEST}_${CONTROL}_lanceotron.simple.bed -u | wc -l`
MACS2_50_OVERLAP=`bedtools intersect -a temp/${TEST}_${CONTROL}/${TEST}_${CONTROL}_macs2.filtered.simple.bed -b temp/${TEST}_${CONTROL}/${TEST}_${CONTROL}_lanceotron.simple.bed -f 0.5 -u | wc -l`
MACS2_90_OVERLAP=`bedtools intersect -a temp/${TEST}_${CONTROL}/${TEST}_${CONTROL}_macs2.filtered.simple.bed -b temp/${TEST}_${CONTROL}/${TEST}_${CONTROL}_lanceotron.simple.bed -f 0.9 -u | wc -l`

echo "" >> job_outputs/comparison_output/${TEST}_${CONTROL}.macs2_vs_lanceotron_peaks.txt

echo "macs2 any overlap: ${MACS2_ANY_OVERLAP}" >> job_outputs/comparison_output/${TEST}_${CONTROL}.macs2_vs_lanceotron_peaks.txt
echo "macs2 50% overlap: ${MACS2_50_OVERLAP}" >> job_outputs/comparison_output/${TEST}_${CONTROL}.macs2_vs_lanceotron_peaks.txt
echo "macs2 90% overlap: ${MACS2_90_OVERLAP}" >> job_outputs/comparison_output/${TEST}_${CONTROL}.macs2_vs_lanceotron_peaks.txt

echo "" >> job_outputs/comparison_output/${TEST}_${CONTROL}.macs2_vs_lanceotron_peaks.txt

bedtools intersect -a temp/${TEST}_${CONTROL}/${TEST}_${CONTROL}_macs2.filtered.simple.bed -b temp/${TEST}_${CONTROL}/${TEST}_${CONTROL}_lanceotron.simple.bed -wa -wb >> \
job_outputs/comparison_output/${TEST}_${CONTROL}.macs2_vs_lanceotron_peaks.txt


module purge
rm -rf temp/${TEST}_${CONTROL}


rv=$?
#
##########################################################################################

echo "Finished at: "`date`
exit $rv

