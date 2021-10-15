#!/bin/bash

module load BEDTools/2.30.0-GCC-10.2.0

rm -rf temp/tissue_IGF-1R.narrow.peaks.sorted.bed
rm -rf job_outputs/tissue_IGF-1R.narrow.peaks.merged.bed

ls /well/macaulay/users/opl537/Work_for_Others/Jack/src/macs2/job_outputs/subcp_output/*remaining.filtered.bed | grep IGF | xargs cat | \
cut -f1-3 | grep -v Un | sort -k1,1 -k2,2n > temp/tissue_IGF-1R.narrow.peaks.sorted.bed

wc -l temp/tissue_IGF-1R.narrow.peaks.sorted.bed

bedtools merge -i temp/tissue_IGF-1R.narrow.peaks.sorted.bed > job_outputs/tissue_IGF-1R.narrow.peaks.merged.bed

wc -l job_outputs/tissue_IGF-1R.narrow.peaks.merged.bed


echo ""

rm -rf temp/tissue_IGF-1R.broad.peaks.sorted.bed
rm -rf job_outputs/tissue_IGF-1R.broad.peaks.merged.bed

ls /well/macaulay/users/opl537/Work_for_Others/Jack/src/macs2broad/job_outputs/subcp_output/*remaining.filtered.bed | grep IGF | xargs cat | \
cut -f1-3 | grep -v Un | sort -k1,1 -k2,2n > temp/tissue_IGF-1R.broad.peaks.sorted.bed

wc -l temp/tissue_IGF-1R.broad.peaks.sorted.bed

bedtools merge -i temp/tissue_IGF-1R.broad.peaks.sorted.bed > job_outputs/tissue_IGF-1R.broad.peaks.merged.bed

wc -l job_outputs/tissue_IGF-1R.broad.peaks.merged.bed


echo ""


rm -rf temp/tissue_IGF-1R.lanceotron.peaks.sorted.bed
rm -rf job_outputs/tissue_IGF-1R.lanceotron.peaks.merged.bed

ls /well/macaulay/users/opl537/Work_for_Others/Jack/src/lanceotron/job_outputs/subcp_output/*remaining.filtered_0.8.bed | grep IGF | xargs cat | \
cut -f1-3 | sort -k1,1 -k2,2n > temp/tissue_IGF-1R.lanceotron.peaks.sorted.bed

wc -l temp/tissue_IGF-1R.lanceotron.peaks.sorted.bed

bedtools merge -i temp/tissue_IGF-1R.lanceotron.peaks.sorted.bed > job_outputs/tissue_IGF-1R.lanceotron.peaks.merged.bed

wc -l job_outputs/tissue_IGF-1R.lanceotron.peaks.merged.bed


#********************************************************************************

rm -rf temp/tissue_IGF-1R.all_merged.peaks.sorted.bed
rm -rf temp/tissue_IGF-1R.all_merged.peaks.merged.bed
rm -rf temp/tissue_IGF-1R.all_merged.peaks.overlaps.bed

cat job_outputs/tissue_IGF-1R.narrow.peaks.merged.bed job_outputs/tissue_IGF-1R.broad.peaks.merged.bed job_outputs/tissue_IGF-1R.lanceotron.peaks.merged.bed | \
sort -k1,1 -k2,2n > temp/tissue_IGF-1R.all_merged.peaks.sorted.bed

wc -l temp/tissue_IGF-1R.all_merged.peaks.sorted.bed

bedtools merge -i temp/tissue_IGF-1R.all_merged.peaks.sorted.bed > temp/tissue_IGF-1R.all_merged.peaks.merged.bed

wc -l temp/tissue_IGF-1R.all_merged.peaks.merged.bed


bedtools intersect -a temp/tissue_IGF-1R.all_merged.peaks.merged.bed \
-b job_outputs/tissue_IGF-1R.narrow.peaks.merged.bed job_outputs/tissue_IGF-1R.broad.peaks.merged.bed job_outputs/tissue_IGF-1R.lanceotron.peaks.merged.bed \
-C -names narrow broad lanceotron | awk 'ORS=NR%3?"\t":"\n"' | cut -f1,2,3,5,10,15 > temp/tissue_IGF-1R.all_merged.peaks.overlaps.bed

wc -l temp/tissue_IGF-1R.all_merged.peaks.overlaps.bed

echo "Number of peak regions contributed by narrow only"
cat temp/tissue_IGF-1R.all_merged.peaks.overlaps.bed | awk '{if($4>=1 && $5==0 && $6==0) print $0}' | wc -l
echo "Number of peak regions contributed by broad only"
cat temp/tissue_IGF-1R.all_merged.peaks.overlaps.bed | awk '{if($4==0 && $5>=1 && $6==0) print $0}' | wc -l
echo "Number of peak regions contributed by lanceotron only"
cat temp/tissue_IGF-1R.all_merged.peaks.overlaps.bed | awk '{if($4==0 && $5==0 && $6>=1) print $0}' | wc -l
echo "Number of peak regions contributed by narrow + broad"
cat temp/tissue_IGF-1R.all_merged.peaks.overlaps.bed | awk '{if($4>=1 && $5>=1 && $6==0) print $0}' | wc -l
echo "Number of peak regions contributed by narrow + lanceotron"
cat temp/tissue_IGF-1R.all_merged.peaks.overlaps.bed | awk '{if($4>=1 && $5==0 && $6>=1) print $0}' | wc -l
echo "Number of peak regions contributed by broad + lanceotron"
cat temp/tissue_IGF-1R.all_merged.peaks.overlaps.bed | awk '{if($4==0 && $5>=1 && $6>=1) print $0}' | wc -l
echo "Number of peak regions contributed by narrow + broad + lanceotron"
cat temp/tissue_IGF-1R.all_merged.peaks.overlaps.bed | awk '{if($4>=1 && $5>=1 && $6>=1) print $0}' | wc -l


#rm -rf temp/*
module purge
