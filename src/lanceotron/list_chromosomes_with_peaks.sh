#!/bin/bash

rm -rf temp/file_list.txt
rm -rf temp/chromosomes_with_peaks.txt

#ls job_outputs/lanceotron_output/* > temp/file_list.txt
ls job_outputs/subcp_output/* > temp/file_list.txt
touch temp/chromosomes_with_peaks.txt

while read FILE
do
  cut -f1 $FILE | tail -n+2 | uniq | sort | uniq >> temp/chromosomes_with_peaks.txt
done<temp/file_list.txt

cat temp/chromosomes_with_peaks.txt

rm -rf temp/file_list.txt
rm -rf temp/chromosomes_with_peaks.txt
