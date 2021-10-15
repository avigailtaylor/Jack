#!/bin/bash

rm -rf job_outputs/tss_extracted/*

for PEAK_TYPE in macs2narrow macs2broad lanceotron
do
  touch job_outputs/tss_extracted/tss.${PEAK_TYPE}.txt

  while read SAMPLE
  do
    tail -n+2 job_outputs/homer_output/${PEAK_TYPE}/annotations/${SAMPLE}* | cut -f10 | \
    awk -v sample=${SAMPLE} -v peaktype=${PEAK_TYPE} '{print sample "\t" peaktype "\t" $1}' >> job_outputs/tss_extracted/tss.${PEAK_TYPE}.txt
  done<meta/samples.txt
done

