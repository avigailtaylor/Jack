#!/bin/bash

module load BEDTools/2.30.0-GCC-10.2.0

echo "Peaks identified in 230 vs 235 *not* overlapped by peak identified in 230 vs 225:"
bedtools intersect -a data.local/CL-peaks/macs2/230_235_peaks.narrowPeak -b data.local/CL-peaks/macs2/230_225_peaks.narrowPeak -v -f 0.99

echo "Peaks identified in 237 vs 235 *not* overlapped by peak identified in 237 vs 225:"
bedtools intersect -a data.local/CL-peaks/macs2/237_235_peaks.narrowPeak -b data.local/CL-peaks/macs2/237_225_peaks.narrowPeak -v -f 0.99

module purge
