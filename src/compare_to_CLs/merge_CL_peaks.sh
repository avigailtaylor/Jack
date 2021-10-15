#!/bin/bash

module load BEDTools/2.30.0-GCC-10.2.0
rm -rf temp/CL_IGF-1R.narrow.peaks.sorted.bed
rm -rf job_outputs/CL_IGF-1R.narrow.peaks.merged.bed

cat data.local/CL-peaks/macs2/230_225_peaks.narrowPeak data.local/CL-peaks/macs2/237_225_peaks.narrowPeak \
data.local/CL-peaks/macs2/230_235_peaks.narrowPeak data.local/CL-peaks/macs2/237_235_peaks.narrowPeak | \
cut -f1-3 | grep -v Un | sort -k1,1 -k2,2n > temp/CL_IGF-1R.narrow.peaks.sorted.bed

wc -l temp/CL_IGF-1R.narrow.peaks.sorted.bed

bedtools merge -i temp/CL_IGF-1R.narrow.peaks.sorted.bed > job_outputs/CL_IGF-1R.narrow.peaks.merged.bed

wc -l job_outputs/CL_IGF-1R.narrow.peaks.merged.bed


#*******************************************************************************8

rm -rf temp/CL_IGF-1R.broad.peaks.sorted.bed
rm -rf job_outputs/CL_IGF-1R.broad.peaks.merged.bed

cat data.local/CL-peaks/macs2broad/230_225_peaks.broadPeak data.local/CL-peaks/macs2broad/237_225_peaks.broadPeak \
data.local/CL-peaks/macs2broad/230_235_peaks.broadPeak data.local/CL-peaks/macs2broad/237_235_peaks.broadPeak | \
cut -f1-3 | grep -v Un | sort -k1,1 -k2,2n > temp/CL_IGF-1R.broad.peaks.sorted.bed

wc -l temp/CL_IGF-1R.broad.peaks.sorted.bed

bedtools merge -i temp/CL_IGF-1R.broad.peaks.sorted.bed > job_outputs/CL_IGF-1R.broad.peaks.merged.bed

wc -l job_outputs/CL_IGF-1R.broad.peaks.merged.bed


#*******************************************************************************8

rm -rf temp/CL_IGF-1R.lanceotron.peaks.sorted.bed
rm -rf job_outputs/CL_IGF-1R.lanceotron.peaks.merged.bed

cat data.local/CL-peaks/lanceotron/225_230_L-tron.bed data.local/CL-peaks/lanceotron/225_237_L-tron.bed \
data.local/CL-peaks/lanceotron/235_230_L-tron.bed data.local/CL-peaks/lanceotron/235_237_L-tron.bed | \
awk '{if($4>0.8) print $0}' | cut -f1-3 | sort -k1,1 -k2,2n > temp/CL_IGF-1R.lanceotron.peaks.sorted.bed

wc -l temp/CL_IGF-1R.lanceotron.peaks.sorted.bed

bedtools merge -i temp/CL_IGF-1R.lanceotron.peaks.sorted.bed > job_outputs/CL_IGF-1R.lanceotron.peaks.merged.bed

wc -l job_outputs/CL_IGF-1R.lanceotron.peaks.merged.bed


#********************************************************************************

rm -rf temp/CL_IGF-1R.all_merged.peaks.sorted.bed
rm -rf temp/CL_IGF-1R.all_merged.peaks.merged.bed
rm -rf temp/CL_IGF-1R.all_merged.peaks.overlaps.bed

cat job_outputs/CL_IGF-1R.narrow.peaks.merged.bed job_outputs/CL_IGF-1R.broad.peaks.merged.bed job_outputs/CL_IGF-1R.lanceotron.peaks.merged.bed | \
sort -k1,1 -k2,2n > temp/CL_IGF-1R.all_merged.peaks.sorted.bed

wc -l temp/CL_IGF-1R.all_merged.peaks.sorted.bed

bedtools merge -i temp/CL_IGF-1R.all_merged.peaks.sorted.bed > temp/CL_IGF-1R.all_merged.peaks.merged.bed

wc -l temp/CL_IGF-1R.all_merged.peaks.merged.bed


bedtools intersect -a temp/CL_IGF-1R.all_merged.peaks.merged.bed \
-b job_outputs/CL_IGF-1R.narrow.peaks.merged.bed job_outputs/CL_IGF-1R.broad.peaks.merged.bed job_outputs/CL_IGF-1R.lanceotron.peaks.merged.bed \
-C -names narrow broad lanceotron | awk 'ORS=NR%3?"\t":"\n"' | cut -f1,2,3,5,10,15 > temp/CL_IGF-1R.all_merged.peaks.overlaps.bed

echo "Number of peak regions contributed by narrow only"
cat temp/CL_IGF-1R.all_merged.peaks.overlaps.bed | awk '{if($4>=1 && $5==0 && $6==0) print $0}' | wc -l
echo "Number of peak regions contributed by broad only"
cat temp/CL_IGF-1R.all_merged.peaks.overlaps.bed | awk '{if($4==0 && $5>=1 && $6==0) print $0}' | wc -l
echo "Number of peak regions contributed by lanceotron only"
cat temp/CL_IGF-1R.all_merged.peaks.overlaps.bed | awk '{if($4==0 && $5==0 && $6>=1) print $0}' | wc -l
echo "Number of peak regions contributed by narrow + broad"
cat temp/CL_IGF-1R.all_merged.peaks.overlaps.bed | awk '{if($4>=1 && $5>=1 && $6==0) print $0}' | wc -l
echo "Number of peak regions contributed by narrow + lanceotron"
cat temp/CL_IGF-1R.all_merged.peaks.overlaps.bed | awk '{if($4>=1 && $5==0 && $6>=1) print $0}' | wc -l
echo "Number of peak regions contributed by broad + lanceotron"
cat temp/CL_IGF-1R.all_merged.peaks.overlaps.bed | awk '{if($4==0 && $5>=1 && $6>=1) print $0}' | wc -l
echo "Number of peak regions contributed by narrow + broad + lanceotron"
cat temp/CL_IGF-1R.all_merged.peaks.overlaps.bed | awk '{if($4>=1 && $5>=1 && $6>=1) print $0}' | wc -l

#rm -rf temp/*
module purge
