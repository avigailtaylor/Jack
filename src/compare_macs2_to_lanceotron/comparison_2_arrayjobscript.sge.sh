#!/bin/bash

# Specify a job name
#$ -N comparison_2

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

SAMPLE=`cat meta/samples2.txt | tail -n+${SGE_TASK_ID} | head -1 | cut -f1`

rm -rf job_outputs/comparison_2_output/${SAMPLE}.macs2_vs_lanceotron_peaks.txt
touch job_outputs/comparison_2_output/${SAMPLE}.macs2_vs_lanceotron_peaks.txt
rm -rf temp/${SAMPLE}_2
mkdir temp/${SAMPLE}_2

MACS2_N_FILE_RAW="../macs2/job_outputs/subcp_output/${SAMPLE}.narrowPeak.remaining.filtered.bed"
MACS2_B_FILE_RAW="../macs2broad/job_outputs/subcp_output/${SAMPLE}.broadPeak.remaining.filtered.bed"
LANCE_FILE_RAW="../lanceotron/job_outputs/subcp_output/${SAMPLE}.lanceotron.remaining.filtered_0.8.bed "

MACS2_N_FILE="temp/${SAMPLE}_2/${SAMPLE}.narrowPeak.simple.bed"
MACS2_B_FILE="temp/${SAMPLE}_2/${SAMPLE}.broadPeak.simple.bed"
LANCE_FILE="temp/${SAMPLE}_2/${SAMPLE}.lanceotron.simple.bed"

cut -f1-3 ${MACS2_N_FILE_RAW} > ${MACS2_N_FILE}
cut -f1-3 ${MACS2_B_FILE_RAW} > ${MACS2_B_FILE}
cut -f1-3 ${LANCE_FILE_RAW} > ${LANCE_FILE}

module load BEDTools/2.30.0-GCC-10.2.0

echo "Comparing macs2 and lanceotron peak calls in ${SAMPLE}" > job_outputs/comparison_2_output/${SAMPLE}.macs2_vs_lanceotron_peaks.txt
echo "" >> job_outputs/comparison_2_output/${SAMPLE}.macs2_vs_lanceotron_peaks.txt

MACS2_N_CALLS=`cat ${MACS2_N_FILE} | wc -l`
MACS2_B_CALLS=`cat ${MACS2_B_FILE} | wc -l`
LANCE_CALLS=`cat ${LANCE_FILE} | wc -l`

echo "macs2 narrow calls: ${MACS2_N_CALLS}" >> job_outputs/comparison_2_output/${SAMPLE}.macs2_vs_lanceotron_peaks.txt
echo "macs2 broad calls: ${MACS2_B_CALLS}" >> job_outputs/comparison_2_output/${SAMPLE}.macs2_vs_lanceotron_peaks.txt
echo "lanceotron calls: ${LANCE_CALLS}" >> job_outputs/comparison_2_output/${SAMPLE}.macs2_vs_lanceotron_peaks.txt


# All overlaps are calculated on the basis of 50% overlap of query database intervals
MACS2_N_NONE=`bedtools intersect -a ${MACS2_N_FILE} -b ${MACS2_B_FILE}  ${LANCE_FILE} -C -f 0.5 | awk '{if($5==0) print $0}' | cut -f1-3 | sort | uniq -d | wc -l`
MACS2_N_BOTH=`bedtools intersect -a ${MACS2_N_FILE} -b ${MACS2_B_FILE}  ${LANCE_FILE} -C -f 0.5 | awk '{if($5>0) print $0}' | cut -f1-3 | sort | uniq -d | wc -l`
MACS2_N_BROAD=`bedtools intersect -a ${MACS2_N_FILE} -b ${MACS2_B_FILE}  ${LANCE_FILE} -C -names b l -f 0.5 | awk '{if($5>0) print $0}' | rev | uniq -f2 -u | rev | awk '{if($4=="b") print $0}' | wc -l`
MACS2_N_LANCE=`bedtools intersect -a ${MACS2_N_FILE} -b ${MACS2_B_FILE}  ${LANCE_FILE} -C -names b l -f 0.5 | awk '{if($5>0) print $0}' | rev | uniq -f2 -u | rev | awk '{if($4=="l") print $0}' | wc -l`

MACS2_B_NONE=`bedtools intersect -a ${MACS2_B_FILE} -b ${MACS2_N_FILE}  ${LANCE_FILE} -C -f 0.5 | awk '{if($5==0) print $0}' | cut -f1-3 | sort | uniq -d | wc -l`
MACS2_B_BOTH=`bedtools intersect -a ${MACS2_B_FILE} -b ${MACS2_N_FILE}  ${LANCE_FILE} -C -f 0.5 | awk '{if($5>0) print $0}' | cut -f1-3 | sort | uniq -d | wc -l`
MACS2_B_NARROW=`bedtools intersect -a ${MACS2_B_FILE} -b ${MACS2_N_FILE}  ${LANCE_FILE} -C -names n l -f 0.5 | awk '{if($5>0) print $0}' | rev | uniq -f2 -u | rev | awk '{if($4=="n") print $0}' | wc -l`
MACS2_B_LANCE=`bedtools intersect -a ${MACS2_B_FILE} -b ${MACS2_N_FILE}  ${LANCE_FILE} -C -names n l -f 0.5 | awk '{if($5>0) print $0}' | rev | uniq -f2 -u | rev | awk '{if($4=="l") print $0}' | wc -l`


LANCE_NONE=`bedtools intersect -a ${LANCE_FILE} -b ${MACS2_N_FILE} ${MACS2_B_FILE} -C -f 0.5 | awk '{if($5==0) print $0}' | cut -f1-3 | sort | uniq -d | wc -l`
LANCE_BOTH=`bedtools intersect -a ${LANCE_FILE}	-b ${MACS2_N_FILE} ${MACS2_B_FILE} -C -f 0.5 | awk '{if($5>0) print $0}' | cut -f1-3 | sort | uniq -d | wc -l`
LANCE_NARROW=`bedtools intersect -a ${LANCE_FILE} -b ${MACS2_N_FILE} ${MACS2_B_FILE} -C -names n b -f 0.5 | awk '{if($5>0) print $0}' | rev | uniq -f2 -u | rev | awk '{if($4=="n") print $0}' | wc -l`
LANCE_BROAD=`bedtools intersect -a ${LANCE_FILE} -b ${MACS2_N_FILE} ${MACS2_B_FILE} -C -names n b -f 0.5 | awk '{if($5>0) print $0}' | rev | uniq -f2 -u | rev | awk '{if($4=="b") print $0}' | wc -l`


echo "" >> job_outputs/comparison_2_output/${SAMPLE}.macs2_vs_lanceotron_peaks.txt

echo "macs2_narrow ${MACS2_N_NONE} ${MACS2_N_BOTH} ${MACS2_N_BROAD} ${MACS2_N_LANCE} ${MACS2_N_CALLS}" |\
awk -F' ' '{printf "%s %.2f %.2f %.2f %.2f\n" , $1, 100*($2/$6), 100*($3/$6), 100*($4/$6), 100*($5/$6)}'  >> job_outputs/comparison_2_output/${SAMPLE}.macs2_vs_lanceotron_peaks.txt 

echo "macs2_broad ${MACS2_B_NONE} ${MACS2_B_BOTH} ${MACS2_B_NARROW} ${MACS2_B_LANCE} ${MACS2_B_CALLS}" |\
awk -F' ' '{printf "%s %.2f %.2f %.2f %.2f\n" , $1, 100*($2/$6), 100*($3/$6), 100*($4/$6), 100*($5/$6)}'  >> job_outputs/comparison_2_output/${SAMPLE}.macs2_vs_lanceotron_peaks.txt 

echo "lanceotron ${LANCE_NONE} ${LANCE_BOTH} ${LANCE_NARROW} ${LANCE_BROAD} ${LANCE_CALLS}" |\
awk -F' ' '{printf "%s %.2f %.2f %.2f %.2f\n" , $1, 100*($2/$6), 100*($3/$6), 100*($4/$6), 100*($5/$6)}'  >> job_outputs/comparison_2_output/${SAMPLE}.macs2_vs_lanceotron_peaks.txt 

module purge

rm -rf temp/${SAMPLE}_2

rv=$?
#
##########################################################################################

echo "Finished at: "`date`
exit $rv

