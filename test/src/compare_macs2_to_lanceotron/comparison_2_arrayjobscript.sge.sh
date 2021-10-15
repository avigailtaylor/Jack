#!/bin/bash

# Specify a job name
#$ -N comparison_2

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

rm -rf job_outputs/comparison_2_output/${TEST}_${CONTROL}.macs2_vs_lanceotron_peaks.txt
touch job_outputs/comparison_2_output/${TEST}_${CONTROL}.macs2_vs_lanceotron_peaks.txt
rm -rf temp/${TEST}_${CONTROL}
mkdir temp/${TEST}_${CONTROL}

cut -f1,2,3 /well/macaulay/users/opl537/Work_for_Others/Jack/test/src/macs2/job_outputs/macs2_output/${TEST}_${CONTROL}_peaks.narrowPeak > \
temp/${TEST}_${CONTROL}/${TEST}_${CONTROL}_macs2.narrow.simple.bed
cat temp/${TEST}_${CONTROL}/${TEST}_${CONTROL}_macs2.narrow.simple.bed | grep -v gl > temp/${TEST}_${CONTROL}/${TEST}_${CONTROL}_macs2.narrow.filtered.simple.bed 

cut -f1,2,3 /well/macaulay/users/opl537/Work_for_Others/Jack/test/src/macs2_broad/job_outputs/macs2broad_output/${TEST}_${CONTROL}_peaks.broadPeak > \
temp/${TEST}_${CONTROL}/${TEST}_${CONTROL}_macs2.broad.simple.bed
cat temp/${TEST}_${CONTROL}/${TEST}_${CONTROL}_macs2.broad.simple.bed | grep -v gl > temp/${TEST}_${CONTROL}/${TEST}_${CONTROL}_macs2.broad.filtered.simple.bed 


tail -n+2 /well/macaulay/users/opl537/Work_for_Others/Jack/test/src/lanceotron/job_outputs/lanceotron_output/${CONTROL}_${TEST}_L-tron.bed | \
awk '{print $1 "\t" $2 "\t" $3 "\t" $4 "\t" $7}' > temp/${TEST}_${CONTROL}/${TEST}_${CONTROL}_lanceotron.simple.bed

cat temp/${TEST}_${CONTROL}/${TEST}_${CONTROL}_lanceotron.simple.bed | awk '{if($4>0.8) print $0}' | cut -f1-3 > temp/${TEST}_${CONTROL}/${TEST}_${CONTROL}_lanceotron.filtered.simple.bed

module load BEDTools/2.30.0-GCC-10.2.0

echo "Comparing macs2 and lanceotron peak calls in ${TEST} vs ${CONTROL}" > job_outputs/comparison_2_output/${TEST}_${CONTROL}.macs2_vs_lanceotron_peaks.txt
echo "" >> job_outputs/comparison_2_output/${TEST}_${CONTROL}.macs2_vs_lanceotron_peaks.txt

MACS2_N_CALLS=`cat temp/${TEST}_${CONTROL}/${TEST}_${CONTROL}_macs2.narrow.simple.bed | wc -l`
MACS2_N_CALLS_FILTERED=`cat temp/${TEST}_${CONTROL}/${TEST}_${CONTROL}_macs2.narrow.filtered.simple.bed | wc -l`
MACS2_B_CALLS=`cat temp/${TEST}_${CONTROL}/${TEST}_${CONTROL}_macs2.broad.simple.bed | wc -l`
MACS2_B_CALLS_FILTERED=`cat temp/${TEST}_${CONTROL}/${TEST}_${CONTROL}_macs2.broad.filtered.simple.bed | wc -l`
LANCE_CALLS=`cat temp/${TEST}_${CONTROL}/${TEST}_${CONTROL}_lanceotron.simple.bed | wc -l`
LANCE_CALLS_FILTERED_1=`cat temp/${TEST}_${CONTROL}/${TEST}_${CONTROL}_lanceotron.filtered.simple.bed | wc -l`
LANCE_CALLS_FILTERED_2=`cat temp/${TEST}_${CONTROL}/${TEST}_${CONTROL}_lanceotron.simple.bed | awk '{if($4>0.8 && $5>1.3) print $0}' | wc -l`

echo "macs2 narrow calls: ${MACS2_N_CALLS}" >> job_outputs/comparison_2_output/${TEST}_${CONTROL}.macs2_vs_lanceotron_peaks.txt
echo "macs2 narrow calls filtered: ${MACS2_N_CALLS_FILTERED}" >> job_outputs/comparison_2_output/${TEST}_${CONTROL}.macs2_vs_lanceotron_peaks.txt
echo "macs2 broad calls: ${MACS2_B_CALLS}" >> job_outputs/comparison_2_output/${TEST}_${CONTROL}.macs2_vs_lanceotron_peaks.txt
echo "macs2 broad calls filtered: ${MACS2_B_CALLS_FILTERED}" >> job_outputs/comparison_2_output/${TEST}_${CONTROL}.macs2_vs_lanceotron_peaks.txt
echo "lanceotron calls: ${LANCE_CALLS}" >> job_outputs/comparison_2_output/${TEST}_${CONTROL}.macs2_vs_lanceotron_peaks.txt
echo "lanceotron calls filtered 1: ${LANCE_CALLS_FILTERED_1}" >> job_outputs/comparison_2_output/${TEST}_${CONTROL}.macs2_vs_lanceotron_peaks.txt
echo "lanceotron calls filtered 2: ${LANCE_CALLS_FILTERED_2}" >> job_outputs/comparison_2_output/${TEST}_${CONTROL}.macs2_vs_lanceotron_peaks.txt


# All overlaps are calculated on the basis of 50% overlap of query database intervals
MACS2_N_NONE=`bedtools intersect -a temp/${TEST}_${CONTROL}/${TEST}_${CONTROL}_macs2.narrow.filtered.simple.bed -b temp/${TEST}_${CONTROL}/${TEST}_${CONTROL}_macs2.broad.filtered.simple.bed  temp/${TEST}_${CONTROL}/${TEST}_${CONTROL}_lanceotron.filtered.simple.bed -C -f 0.5 | awk '{if($5==0) print $0}' | cut -f1-3 | sort | uniq -d | wc -l`
MACS2_N_BOTH=`bedtools intersect -a temp/${TEST}_${CONTROL}/${TEST}_${CONTROL}_macs2.narrow.filtered.simple.bed -b temp/${TEST}_${CONTROL}/${TEST}_${CONTROL}_macs2.broad.filtered.simple.bed  temp/${TEST}_${CONTROL}/${TEST}_${CONTROL}_lanceotron.filtered.simple.bed -C -f 0.5 | awk '{if($5>0) print $0}' | cut -f1-3 | sort | uniq -d | wc -l`
MACS2_N_BROAD=`bedtools intersect -a temp/${TEST}_${CONTROL}/${TEST}_${CONTROL}_macs2.narrow.filtered.simple.bed -b temp/${TEST}_${CONTROL}/${TEST}_${CONTROL}_macs2.broad.filtered.simple.bed  temp/${TEST}_${CONTROL}/${TEST}_${CONTROL}_lanceotron.filtered.simple.bed -C -names b l -f 0.5 | awk '{if($5>0) print $0}' | rev | uniq -f2 -u | rev | awk '{if($4=="b") print $0}' | wc -l`
MACS2_N_LANCE=`bedtools intersect -a temp/${TEST}_${CONTROL}/${TEST}_${CONTROL}_macs2.narrow.filtered.simple.bed -b temp/${TEST}_${CONTROL}/${TEST}_${CONTROL}_macs2.broad.filtered.simple.bed  temp/${TEST}_${CONTROL}/${TEST}_${CONTROL}_lanceotron.filtered.simple.bed -C -names b l -f 0.5 | awk '{if($5>0) print $0}' | rev | uniq -f2 -u | rev | awk '{if($4=="l") print $0}' | wc -l`

MACS2_B_NONE=`bedtools intersect -a temp/${TEST}_${CONTROL}/${TEST}_${CONTROL}_macs2.broad.filtered.simple.bed -b temp/${TEST}_${CONTROL}/${TEST}_${CONTROL}_macs2.narrow.filtered.simple.bed  temp/${TEST}_${CONTROL}/${TEST}_${CONTROL}_lanceotron.filtered.simple.bed -C -f 0.5 | awk '{if($5==0) print $0}' | cut -f1-3 | sort | uniq -d | wc -l`
MACS2_B_BOTH=`bedtools intersect -a temp/${TEST}_${CONTROL}/${TEST}_${CONTROL}_macs2.broad.filtered.simple.bed -b temp/${TEST}_${CONTROL}/${TEST}_${CONTROL}_macs2.narrow.filtered.simple.bed  temp/${TEST}_${CONTROL}/${TEST}_${CONTROL}_lanceotron.filtered.simple.bed -C -f 0.5 | awk '{if($5>0) print $0}' | cut -f1-3 | sort | uniq -d | wc -l`
MACS2_B_NARROW=`bedtools intersect -a temp/${TEST}_${CONTROL}/${TEST}_${CONTROL}_macs2.broad.filtered.simple.bed -b temp/${TEST}_${CONTROL}/${TEST}_${CONTROL}_macs2.narrow.filtered.simple.bed  temp/${TEST}_${CONTROL}/${TEST}_${CONTROL}_lanceotron.filtered.simple.bed -C -names n l -f 0.5 | awk '{if($5>0) print $0}' | rev | uniq -f2 -u | rev | awk '{if($4=="n") print $0}' | wc -l`
MACS2_B_LANCE=`bedtools intersect -a temp/${TEST}_${CONTROL}/${TEST}_${CONTROL}_macs2.broad.filtered.simple.bed -b temp/${TEST}_${CONTROL}/${TEST}_${CONTROL}_macs2.narrow.filtered.simple.bed  temp/${TEST}_${CONTROL}/${TEST}_${CONTROL}_lanceotron.filtered.simple.bed -C -names n l -f 0.5 | awk '{if($5>0) print $0}' | rev | uniq -f2 -u | rev | awk '{if($4=="l") print $0}' | wc -l`


LANCE_NONE=`bedtools intersect -a temp/${TEST}_${CONTROL}/${TEST}_${CONTROL}_lanceotron.filtered.simple.bed -b temp/${TEST}_${CONTROL}/${TEST}_${CONTROL}_macs2.narrow.filtered.simple.bed temp/${TEST}_${CONTROL}/${TEST}_${CONTROL}_macs2.broad.filtered.simple.bed -C -f 0.5 | awk '{if($5==0) print $0}' | cut -f1-3 | sort | uniq -d | wc -l`
LANCE_BOTH=`bedtools intersect -a temp/${TEST}_${CONTROL}/${TEST}_${CONTROL}_lanceotron.filtered.simple.bed -b temp/${TEST}_${CONTROL}/${TEST}_${CONTROL}_macs2.narrow.filtered.simple.bed temp/${TEST}_${CONTROL}/${TEST}_${CONTROL}_macs2.broad.filtered.simple.bed -C -f 0.5 | awk '{if($5>0) print $0}' | cut -f1-3 | sort | uniq -d | wc -l`
LANCE_NARROW=`bedtools intersect -a temp/${TEST}_${CONTROL}/${TEST}_${CONTROL}_lanceotron.filtered.simple.bed -b temp/${TEST}_${CONTROL}/${TEST}_${CONTROL}_macs2.narrow.filtered.simple.bed temp/${TEST}_${CONTROL}/${TEST}_${CONTROL}_macs2.broad.filtered.simple.bed -C -names n b -f 0.5 | awk '{if($5>0) print $0}' | rev | uniq -f2 -u | rev | awk '{if($4=="n") print $0}' | wc -l`
LANCE_BROAD=`bedtools intersect -a temp/${TEST}_${CONTROL}/${TEST}_${CONTROL}_lanceotron.filtered.simple.bed -b temp/${TEST}_${CONTROL}/${TEST}_${CONTROL}_macs2.narrow.filtered.simple.bed temp/${TEST}_${CONTROL}/${TEST}_${CONTROL}_macs2.broad.filtered.simple.bed -C -names n b -f 0.5 | awk '{if($5>0) print $0}' | rev | uniq -f2 -u | rev | awk '{if($4=="b") print $0}' | wc -l`


echo "" >> job_outputs/comparison_2_output/${TEST}_${CONTROL}.macs2_vs_lanceotron_peaks.txt

echo "macs2_narrow ${MACS2_N_NONE} ${MACS2_N_BOTH} ${MACS2_N_BROAD} ${MACS2_N_LANCE} ${MACS2_N_CALLS_FILTERED}" |\
awk -F' ' '{printf "%s %.2f %.2f %.2f %.2f\n" , $1, 100*($2/$6), 100*($3/$6), 100*($4/$6), 100*($5/$6)}'  >> job_outputs/comparison_2_output/${TEST}_${CONTROL}.macs2_vs_lanceotron_peaks.txt 

echo "macs2_broad ${MACS2_B_NONE} ${MACS2_B_BOTH} ${MACS2_B_NARROW} ${MACS2_B_LANCE} ${MACS2_B_CALLS_FILTERED}" |\
awk -F' ' '{printf "%s %.2f %.2f %.2f %.2f\n" , $1, 100*($2/$6), 100*($3/$6), 100*($4/$6), 100*($5/$6)}'  >> job_outputs/comparison_2_output/${TEST}_${CONTROL}.macs2_vs_lanceotron_peaks.txt 

echo "lanceotron ${LANCE_NONE} ${LANCE_BOTH} ${LANCE_NARROW} ${LANCE_BROAD} ${LANCE_CALLS_FILTERED_1}" |\
awk -F' ' '{printf "%s %.2f %.2f %.2f %.2f\n" , $1, 100*($2/$6), 100*($3/$6), 100*($4/$6), 100*($5/$6)}'  >> job_outputs/comparison_2_output/${TEST}_${CONTROL}.macs2_vs_lanceotron_peaks.txt 


module purge
#rm -rf temp/${TEST}_${CONTROL}


rv=$?
#
##########################################################################################

echo "Finished at: "`date`
exit $rv

