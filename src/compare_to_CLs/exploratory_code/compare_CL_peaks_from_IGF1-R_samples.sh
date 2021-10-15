#!/bin/bash

module load BEDTools/2.30.0-GCC-10.2.0

"Number of peaks in 230 vs 225: "
wc -l data.local/CL-peaks/macs2/230_225_peaks.narrowPeak
echo ""

"Number of peaks in 237 vs 225 (not including peak mapped to ChrUn): "
cat data.local/CL-peaks/macs2/237_225_peaks.narrowPeak | grep -v Un | wc -l
echo ""

echo "Peaks identified in 230 vs 225 overlapped by peak identified in 237 vs 225:"
bedtools intersect -a data.local/CL-peaks/macs2/230_225_peaks.narrowPeak -b data.local/CL-peaks/macs2/237_225_peaks.narrowPeak
bedtools intersect -a data.local/CL-peaks/macs2/230_225_peaks.narrowPeak -b data.local/CL-peaks/macs2/237_225_peaks.narrowPeak | wc -l

echo ""

echo "Unique peaks identified in 230 vs 225 overlapped by peak identified in 237 vs 225:"
bedtools intersect -a data.local/CL-peaks/macs2/230_225_peaks.narrowPeak -b data.local/CL-peaks/macs2/237_225_peaks.narrowPeak -u
bedtools intersect -a data.local/CL-peaks/macs2/230_225_peaks.narrowPeak -b data.local/CL-peaks/macs2/237_225_peaks.narrowPeak -u | wc -l

echo ""
echo "Peaks identified in 230 vs 225 *not* overlapped by peak identified in 237 vs 225:"
bedtools intersect -a data.local/CL-peaks/macs2/230_225_peaks.narrowPeak -b data.local/CL-peaks/macs2/237_225_peaks.narrowPeak -v
bedtools intersect -a data.local/CL-peaks/macs2/230_225_peaks.narrowPeak -b data.local/CL-peaks/macs2/237_225_peaks.narrowPeak -v | wc -l

echo ""
echo "Peaks identified in 237 vs 225 overlapped by peak identified in 230 vs 225:"
bedtools intersect -a data.local/CL-peaks/macs2/237_225_peaks.narrowPeak -b data.local/CL-peaks/macs2/230_225_peaks.narrowPeak | grep -v Un
bedtools intersect -a data.local/CL-peaks/macs2/237_225_peaks.narrowPeak -b data.local/CL-peaks/macs2/230_225_peaks.narrowPeak | grep -v Un | wc -l


echo ""
echo "Unique peaks identified in 237 vs 225 overlapped by peak identified in 230 vs 225:"
bedtools intersect -a data.local/CL-peaks/macs2/237_225_peaks.narrowPeak -b data.local/CL-peaks/macs2/230_225_peaks.narrowPeak -u | grep -v Un
bedtools intersect -a data.local/CL-peaks/macs2/237_225_peaks.narrowPeak -b data.local/CL-peaks/macs2/230_225_peaks.narrowPeak -u | grep -v Un | wc -l

echo ""
echo "Peaks identified in 237 vs 225 *not* overlapped by peak identified in 230 vs 225:"
bedtools intersect -a data.local/CL-peaks/macs2/237_225_peaks.narrowPeak -b data.local/CL-peaks/macs2/230_225_peaks.narrowPeak -v | grep -v Un
bedtools intersect -a data.local/CL-peaks/macs2/237_225_peaks.narrowPeak -b data.local/CL-peaks/macs2/230_225_peaks.narrowPeak -v | grep -v Un | wc -l

echo ""
echo "Number overlapping peaks with reciprocal overlap > 0.5"
bedtools intersect -a data.local/CL-peaks/macs2/230_225_peaks.narrowPeak -b data.local/CL-peaks/macs2/237_225_peaks.narrowPeak -f 0.5 -r | wc -l

echo ""
echo "Number overlapping peaks with reciprocal overlap > 0.75"
bedtools intersect -a data.local/CL-peaks/macs2/230_225_peaks.narrowPeak -b data.local/CL-peaks/macs2/237_225_peaks.narrowPeak -f 0.75 -r | wc -l

echo ""
echo "Number overlapping peaks with reciprocal overlap > 0.9"
bedtools intersect -a data.local/CL-peaks/macs2/230_225_peaks.narrowPeak -b data.local/CL-peaks/macs2/237_225_peaks.narrowPeak -f 0.9 -r | wc -l

echo ""
echo "Number overlapping peaks with reciprocal overlap > 0.95"
bedtools intersect -a data.local/CL-peaks/macs2/230_225_peaks.narrowPeak -b data.local/CL-peaks/macs2/237_225_peaks.narrowPeak -f 0.95 -r | wc -l


module purge
