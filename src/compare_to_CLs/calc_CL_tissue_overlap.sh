#!/bin/bash

module load BEDTools/2.30.0-GCC-10.2.0

rm -rf temp/*
rm -rf job_outputs/*

./merge_CL_peaks.sh > temp/foo
./merge_tissue_peaks.sh > temp/bar

for PEAK_TYPE in narrow broad lanceotron
do
#  cat job_outputs/CL_IGF-1R.${PEAK_TYPE}.peaks.merged.bed  job_outputs/tissue_IGF-1R.${PEAK_TYPE}.peaks.merged.bed | sort -k1,1 -k2,2n > temp/all.${PEAK_TYPE}.peaks.sorted.bed

#  echo ""
#  wc -l temp/all.${PEAK_TYPE}.peaks.sorted.bed
#  bedtools merge -i temp/all.${PEAK_TYPE}.peaks.sorted.bed > temp/all.${PEAK_TYPE}.peaks.merged.bed
#  wc -l temp/all.${PEAK_TYPE}.peaks.merged.bed
#  echo "***********"
#  echo "Number of CL ${PEAK_TYPE} peaks"
#  wc -l job_outputs/CL_IGF-1R.${PEAK_TYPE}.peaks.merged.bed
#  #echo "CL ${PEAK_TYPE} peaks overlapped by tissue peak:"
#  #bedtools intersect -a job_outputs/CL_IGF-1R.${PEAK_TYPE}.peaks.merged.bed -b job_outputs/tissue_IGF-1R.${PEAK_TYPE}.peaks.merged.bed -u 
#  echo "Number of CL ${PEAK_TYPE} peaks overlapped by tissue peak:"
#  bedtools intersect -a job_outputs/CL_IGF-1R.${PEAK_TYPE}.peaks.merged.bed -b job_outputs/tissue_IGF-1R.${PEAK_TYPE}.peaks.merged.bed -u | wc -l
#  echo "Number of CL ${PEAK_TYPE} peaks not overlapped by tissue peak:"
#  bedtools intersect -a job_outputs/CL_IGF-1R.${PEAK_TYPE}.peaks.merged.bed -b job_outputs/tissue_IGF-1R.${PEAK_TYPE}.peaks.merged.bed -v | wc -l
#  echo "***********"
#  echo "Number of tissue ${PEAK_TYPE} peaks"
#  wc -l job_outputs/tissue_IGF-1R.${PEAK_TYPE}.peaks.merged.bed
#  #echo "Tissue ${PEAK_TYPE} peaks overlapped by tissue peak:"
#  #bedtools intersect -a job_outputs/tissue_IGF-1R.${PEAK_TYPE}.peaks.merged.bed -b job_outputs/CL_IGF-1R.${PEAK_TYPE}.peaks.merged.bed -u
#  echo "Number of tissue ${PEAK_TYPE} peaks overlapped by tissue peak:"
#  bedtools intersect -a job_outputs/tissue_IGF-1R.${PEAK_TYPE}.peaks.merged.bed -b job_outputs/CL_IGF-1R.${PEAK_TYPE}.peaks.merged.bed -u | wc -l
#  echo "Number of tissue ${PEAK_TYPE} peaks not overlapped by tissue peak:"
#  bedtools intersect -a job_outputs/tissue_IGF-1R.${PEAK_TYPE}.peaks.merged.bed -b job_outputs/CL_IGF-1R.${PEAK_TYPE}.peaks.merged.bed -v | wc -l

  rm -rf temp/${PEAK_TYPE}.all_merged.peaks.sorted.bed
  rm -rf temp/${PEAK_TYPE}.all_merged.peaks.merged.bed
  rm -rf temp/${PEAK_TYPE}.all_merged.peaks.overlaps.bed

  cat job_outputs/CL_IGF-1R.${PEAK_TYPE}.peaks.merged.bed job_outputs/tissue_IGF-1R.${PEAK_TYPE}.peaks.merged.bed | \
  sort -k1,1 -k2,2n > temp/${PEAK_TYPE}.all_merged.peaks.sorted.bed

  wc -l temp/${PEAK_TYPE}.all_merged.peaks.sorted.bed

  bedtools merge -i temp/${PEAK_TYPE}.all_merged.peaks.sorted.bed > temp/${PEAK_TYPE}.all_merged.peaks.merged.bed

  wc -l temp/${PEAK_TYPE}.all_merged.peaks.merged.bed

  bedtools intersect -a temp/${PEAK_TYPE}.all_merged.peaks.merged.bed \
  -b job_outputs/CL_IGF-1R.${PEAK_TYPE}.peaks.merged.bed job_outputs/tissue_IGF-1R.${PEAK_TYPE}.peaks.merged.bed \
  -C -names cl tissue | awk 'ORS=NR%2?"\t":"\n"' | cut -f1,2,3,5,10 > temp/${PEAK_TYPE}.all_merged.peaks.overlaps.bed

  wc -l temp/${PEAK_TYPE}.all_merged.peaks.overlaps.bed

  echo "Number of peak regions contributed by CL only"
  cat temp/${PEAK_TYPE}.all_merged.peaks.overlaps.bed | awk '{if($4>=1 && $5==0) print $0}' | wc -l
  echo "Number of peak regions contributed by tissue only"
  cat temp/${PEAK_TYPE}.all_merged.peaks.overlaps.bed | awk '{if($4==0 && $5>=1) print $0}' | wc -l
  echo "Number of peak regions contributed by both"
  cat temp/${PEAK_TYPE}.all_merged.peaks.overlaps.bed | awk '{if($4>=1 && $5>=1) print $0}' | wc -l

done

#rm -rf temp/*
