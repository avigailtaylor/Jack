#!/bin/bash

rm -rf job_outputs/gene_sets_analyses/*

while read SAMPLE
do
  for PEAK_TYPE in macs2narrow macs2broad lanceotron
  do    
    tail -n+2 job_outputs/homer_output/${PEAK_TYPE}/annotations/${SAMPLE}* | cut -f12 | sort | uniq > job_outputs/gene_sets_analyses/${SAMPLE}.${PEAK_TYPE}.genes.txt
    wc -l job_outputs/gene_sets_analyses/${SAMPLE}.${PEAK_TYPE}.genes.txt
  done
  join job_outputs/gene_sets_analyses/${SAMPLE}.macs2narrow.genes.txt job_outputs/gene_sets_analyses/${SAMPLE}.macs2broad.genes.txt > job_outputs/gene_sets_analyses/${SAMPLE}.nb.genes.txt
  wc -l job_outputs/gene_sets_analyses/${SAMPLE}.nb.genes.txt
  join job_outputs/gene_sets_analyses/${SAMPLE}.macs2narrow.genes.txt job_outputs/gene_sets_analyses/${SAMPLE}.lanceotron.genes.txt > job_outputs/gene_sets_analyses/${SAMPLE}.nl.genes.txt
  wc -l job_outputs/gene_sets_analyses/${SAMPLE}.nl.genes.txt
  join job_outputs/gene_sets_analyses/${SAMPLE}.macs2broad.genes.txt job_outputs/gene_sets_analyses/${SAMPLE}.lanceotron.genes.txt > job_outputs/gene_sets_analyses/${SAMPLE}.bl.genes.txt
  wc -l job_outputs/gene_sets_analyses/${SAMPLE}.bl.genes.txt
  join job_outputs/gene_sets_analyses/${SAMPLE}.nb.genes.txt job_outputs/gene_sets_analyses/${SAMPLE}.lanceotron.genes.txt > job_outputs/gene_sets_analyses/${SAMPLE}.nbl.genes.txt
  wc -l job_outputs/gene_sets_analyses/${SAMPLE}.nbl.genes.txt
  
  cat job_outputs/gene_sets_analyses/${SAMPLE}.macs2narrow.genes.txt \
  job_outputs/gene_sets_analyses/${SAMPLE}.macs2broad.genes.txt \
  job_outputs/gene_sets_analyses/${SAMPLE}.lanceotron.genes.txt | sort | uniq > job_outputs/gene_sets_analyses/${SAMPLE}.all.genes.txt
  wc -l job_outputs/gene_sets_analyses/${SAMPLE}.all.genes.txt

  echo "*****************************************************"
  echo "" 
  echo "*****************************************************"

done<meta/IGF-1R.samples.txt

rm -rf temp/*
touch temp/intersect.genes.temp

SAMPLE=`head -n1 meta/IGF-1R.samples.txt`
cp  job_outputs/gene_sets_analyses/${SAMPLE}.all.genes.txt job_outputs/gene_sets_analyses/all.sample.intersect.genes.txt
cp job_outputs/gene_sets_analyses/${SAMPLE}.all.genes.txt temp/all.sample.union.genes.txt

tail -n+2 meta/IGF-1R.samples.txt > temp/remaining.samples.txt
while read SAMPLE
do
  join job_outputs/gene_sets_analyses/all.sample.intersect.genes.txt job_outputs/gene_sets_analyses/${SAMPLE}.all.genes.txt > temp/intersect.genes.temp
  mv temp/intersect.genes.temp job_outputs/gene_sets_analyses/all.sample.intersect.genes.txt

  cat job_outputs/gene_sets_analyses/${SAMPLE}.all.genes.txt >> temp/all.sample.union.genes.txt
done<temp/remaining.samples.txt


cat temp/all.sample.union.genes.txt | sort | uniq > job_outputs/gene_sets_analyses/all.sample.union.genes.txt
rm -rf temp/*
