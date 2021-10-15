#!/bin/bash

# Specify a job name
#$ -N bigwig_maker Â# was incorrectly named bt2for a lot of runs

# Project name and target queue
#$ -P macaulay.prjc
#$ -q short.qc

# Array settings
#$ -t 225-240:1
#$ -tc 16

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

module load SAMtools/1.10-GCC-8.3.0
cp ../bt2/job_outputs/bt2_output/${SGE_TASK_ID}.sorted.bam temp/
samtools index temp/${SGE_TASK_ID}.sorted.bam
module purge

module load deepTools/3.3.1-foss-2018b-Python-3.6.6
#bamCoverage --bam temp/${SGE_TASK_ID}.sorted.bam -o job_outputs/bigwig_maker_output/${SGE_TASK_ID}.test0.bw
#bamCoverage --bam temp/${SGE_TASK_ID}.sorted.bam -o job_outputs/bigwig_maker_output/${SGE_TASK_ID}.test1.bw --binSize 1
#bamCoverage --bam temp/${SGE_TASK_ID}.sorted.bam -o job_outputs/bigwig_maker_output/${SGE_TASK_ID}.test2.bw --samFlagInclude 64
#bamCoverage --bam temp/${SGE_TASK_ID}.sorted.bam -o job_outputs/bigwig_maker_output/${SGE_TASK_ID}.test3.bw --extendReads
#bamCoverage --bam temp/${SGE_TASK_ID}.sorted.bam -o job_outputs/bigwig_maker_output/${SGE_TASK_ID}.test4.bw --binSize 1 --samFlagInclude 64
#bamCoverage --bam temp/${SGE_TASK_ID}.sorted.bam -o job_outputs/bigwig_maker_output/${SGE_TASK_ID}.test5.bw --binSize 1 --extendReads
#bamCoverage --bam temp/${SGE_TASK_ID}.sorted.bam -o job_outputs/bigwig_maker_output/${SGE_TASK_ID}.test6.bw --samFlagInclude 64 --extendReads
#bamCoverage --bam temp/${SGE_TASK_ID}.sorted.bam -o job_outputs/bigwig_maker_output/${SGE_TASK_ID}.test7.bw --binSize 1 --samFlagInclude 64 --extendReads

#bamCoverage --bam temp/${SGE_TASK_ID}.sorted.bam -o job_outputs/bigwig_maker_output/${SGE_TASK_ID}.test8.bw --extendReads -bs 1 --normalizeUsing RPKM

#bamCoverage --bam temp/${SGE_TASK_ID}.sorted.bam -o job_outputs/bigwig_maker_output/${SGE_TASK_ID}.test9.bw --extendReads -bs 30
#bamCoverage --bam temp/${SGE_TASK_ID}.sorted.bam -o job_outputs/bigwig_maker_output/${SGE_TASK_ID}.test10.bw --extendReads -bs 30 --skipNAs
#bamCoverage --bam temp/${SGE_TASK_ID}.sorted.bam -o job_outputs/bigwig_maker_output/${SGE_TASK_ID}.test11.bw --extendReads -bs 30 --exactScaling
#bamCoverage --bam temp/${SGE_TASK_ID}.sorted.bam -o job_outputs/bigwig_maker_output/${SGE_TASK_ID}.test12.bw --extendReads -bs 30 --skipNAs --exactScaling

#bamCoverage --bam temp/${SGE_TASK_ID}.sorted.bam -o job_outputs/bigwig_maker_output/${SGE_TASK_ID}.test13.bw --extendReads --skipNAs -bs 1 --smoothLength 30
#bamCoverage --bam temp/${SGE_TASK_ID}.sorted.bam -o job_outputs/bigwig_maker_output/${SGE_TASK_ID}.test14.bw --extendReads --skipNAs -bs 20 --smoothLength 30


bamCoverage --bam temp/${SGE_TASK_ID}.sorted.bam -o job_outputs/bigwig_maker_output/${SGE_TASK_ID}.test15.bw -p 3 --binSize 1 --extendReads --skipNAs
bamCoverage --bam temp/${SGE_TASK_ID}.sorted.bam -o job_outputs/bigwig_maker_output/${SGE_TASK_ID}.test16.bw -p 3 --binSize 1 --extendReads --skipNAs --exactScaling
bamCoverage --bam temp/${SGE_TASK_ID}.sorted.bam -o job_outputs/bigwig_maker_output/${SGE_TASK_ID}.test17.bw -p 3 --binSize 1 --extendReads --skipNAs --centerReads
bamCoverage --bam temp/${SGE_TASK_ID}.sorted.bam -o job_outputs/bigwig_maker_output/${SGE_TASK_ID}.test18.bw -p 3 --binSize 1 --extendReads --skipNAs --exactScaling --centerReads


rm temp/${SGE_TASK_ID}.sorted.bam*

module purge

rv=$?
#
##########################################################################################

echo "Finished at: "`date`
exit $rv

