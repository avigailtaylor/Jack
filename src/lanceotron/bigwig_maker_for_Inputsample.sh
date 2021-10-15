#!/bin/bash
#$ -P macaulay.prjc
#$ -N bigwig_maker_Inputsample
#$ -q short.qc

# Log locations which are relative to the current
# working directory of the submission
#$ -o job_outputs/job_log_files
#$ -e job_outputs/job_error_files

# Job can re-run if stops early
#$ -r y

# Run the job in the current working directory
#$ -cwd -j y

echo "------------------------------------------------"
echo "Run on host: "`hostname`
echo "Operating system: "`uname -s`
echo "Username: "`whoami`
echo "Started at: "`date`
echo "------------------------------------------------"

rm -f temp/Inputsample.sorted.bam*

module load SAMtools/1.10-GCC-8.3.0
cp ../bt2/job_outputs/bt2_output/Inputsample.sorted.bam temp/
samtools index temp/Inputsample.sorted.bam
module purge

module load deepTools/3.3.1-foss-2018b-Python-3.6.6
bamCoverage --bam temp/Inputsample.sorted.bam -o job_outputs/bigwig_maker_output/Inputsample.lanceotron_ready.bw --extendReads -bs 1 --normalizeUsing RPKM

rm temp/Inputsample.sorted.bam*
