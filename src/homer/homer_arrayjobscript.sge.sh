#!/bin/bash

# Specify a job name
#$ -N homer

# Project name and target queue
#$ -P macaulay.prjc
#$ -q short.qc

# Array settings
#$ -t 1-27:1
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

#../../../../Applications/
#singularity exec Applications/quay.io-biocontainers-homer-4.11--pl5262h7d875b9_5.img findMotifs.pl

INPUT=`cat meta/io.txt | tail -n+${SGE_TASK_ID} | head -1 | cut -f1`
INPUT_STUB=`echo ${INPUT} | cut -d '/' -f12 | cut -d'.' -f1`
OUTPUT=`cat meta/io.txt | tail -n+${SGE_TASK_ID} | head -1 | cut -f2`
LANCEOTRON_FILTER_FLAG=`cat meta/io.txt | tail -n+${SGE_TASK_ID} | head -1 | cut -f3`

if [ ${LANCEOTRON_FILTER_FLAG} -eq 1 ]
then
 
 rm -rf temp/${INPUT_STUB}.bed 
 cat ${INPUT} | cut -f1-3 | \
 awk -v istub=${INPUT_STUB} 'BEGIN{peaknum=1} {print $0 "\t" istub "_peak" peaknum "\tx\t."; peaknum=peaknum+1 }' > temp/${INPUT_STUB}.bed
 INPUT="/well/macaulay/users/opl537/Work_for_Others/Jack/src/homer/temp/${INPUT_STUB}.bed"
fi

singularity exec -B /well/macaulay/users/opl537/:/well/macaulay/users/opl537/ \
-B /well/macaulay/users/opl537/Work_for_Others/Jack/src:/well/macaulay/users/opl537/Work_for_Others/Jack/src \
-B /well/macaulay/users/opl537/Work_for_Others/Jack/src/macs2/job_outputs/subcp_output:/well/macaulay/users/opl537/Work_for_Others/Jack/src/macs2/job_outputs/subcp_output \
-B /well/macaulay/users/opl537/Work_for_Others/Jack/src/macs2broad/job_outputs/subcp_output:/well/macaulay/users/opl537/Work_for_Others/Jack/src/macs2broad/job_outputs/subcp_output \
-B /well/macaulay/users/opl537/Work_for_Others/Jack/src/lanceotron/job_outputs/subcp_output:/well/macaulay/users/opl537/Work_for_Others/Jack/src/lanceotron/job_outputs/subcp_output \
-B /well/macaulay/users/opl537/Work_for_Others/Jack/src/homer/job_outputs/homer_output/macs2narrow/annotations:/well/macaulay/users/opl537/Work_for_Others/Jack/src/homer/job_outputs/homer_output/macs2narrow/annotations \
-B /well/macaulay/users/opl537/Work_for_Others/Jack/src/homer/job_outputs/homer_output/macs2broad/annotations:/well/macaulay/users/opl537/Work_for_Others/Jack/src/homer/job_outputs/homer_output/macs2broad/annotations \
-B /well/macaulay/users/opl537/Work_for_Others/Jack/src/homer/job_outputs/homer_output/lanceotron/annotations:/well/macaulay/users/opl537/Work_for_Others/Jack/src/homer/job_outputs/homer_output/lanceotron/annotations \
-B /well/macaulay/users/opl537/Work_for_Others/Jack/src/homer/job_outputs/homer_output/macs2narrow/GO:/well/macaulay/users/opl537/Work_for_Others/Jack/src/homer/job_outputs/homer_output/macs2narrow/GO \
-B /well/macaulay/users/opl537/Work_for_Others/Jack/src/homer/job_outputs/homer_output/macs2broad/GO:/well/macaulay/users/opl537/Work_for_Others/Jack/src/homer/job_outputs/homer_output/macs2broad/GO \
-B /well/macaulay/users/opl537/Work_for_Others/Jack/src/homer/job_outputs/homer_output/lanceotron/GO:/well/macaulay/users/opl537/Work_for_Others/Jack/src/homer/job_outputs/homer_output/lanceotron/GO \
-B /well/macaulay/users/opl537/Work_for_Others/Jack/src/homer/job_outputs/homer_output/macs2narrow/genomeOntology:/well/macaulay/users/opl537/Work_for_Others/Jack/src/homer/job_outputs/homer_output/macs2narrow/genomeOntology \
-B /well/macaulay/users/opl537/Work_for_Others/Jack/src/homer/job_outputs/homer_output/macs2broad/genomeOntology:/well/macaulay/users/opl537/Work_for_Others/Jack/src/homer/job_outputs/homer_output/macs2broad/genomeOntology \
-B /well/macaulay/users/opl537/Work_for_Others/Jack/src/homer/job_outputs/homer_output/lanceotron/genomeOntology:/well/macaulay/users/opl537/Work_for_Others/Jack/src/homer/job_outputs/homer_output/lanceotron/genomeOntology \
-B /well/macaulay/users/opl537/Work_for_Others/Jack/src/homer/temp:/well/macaulay/users/opl537/Work_for_Others/Jack/src/homer/temp \
/apps/singularity/homer-4.11.img \
annotatePeaks.pl $INPUT hg19 > $OUTPUT/annotations/${INPUT_STUB}.annotatedPeaks.txt


if [ ${LANCEOTRON_FILTER_FLAG} -eq 1 ]
then
 rm -rf	/well/macaulay/users/opl537/Work_for_Others/Jack/src/homer/temp/${INPUT_STUB}.bed
fi

rv=$?
#
##########################################################################################

echo "Finished at: "`date`
exit $rv

