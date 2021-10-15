#!/bin/bash

#rm -rf /well/macaulay/users/opl537/Work_for_Others/Jack/test/src/lanceotron/job_outputs/lanceotron_output/*
#rm -rf job_outputs/job_log_files/run_lanceotron.*

while read TEST_CONTROL_PAIR
do

TEST=`echo ${TEST_CONTROL_PAIR} | cut -d' ' -f1`
CONTROL=`echo ${TEST_CONTROL_PAIR} | cut -d' ' -f2`

module use -a /apps/eb/2020b/skylake/modules/all
module load Python/3.8.6-GCCcore-10.2.0 BEDTools/2.30.0-GCC-10.2.0
. /well/macaulay/users/opl537/Applications/lanceotron-venv/bin/activate

python /well/macaulay/users/opl537/Applications/LanceOtron/modules/find_and_score_peaks_with_input.py \
http://pania:dalvanius@macaulay00.bmrc.ox.ac.uk/test_data/lanceotron_input/${TEST}.lanceotron_ready.bw \
-i http://pania:dalvanius@macaulay00.bmrc.ox.ac.uk/test_data/lanceotron_input/${CONTROL}.lanceotron_ready.bw \
-f /well/macaulay/users/opl537/Work_for_Others/Jack/test/src/lanceotron/job_outputs/lanceotron_output/${CONTROL}_ \
> job_outputs/job_log_files/run_lanceotron.${TEST}_${CONTROL}

#http://pania:dalvanius@macaulay00.bmrc.ox.ac.uk/test_data/lanceotron_input/${TEST}.lanceotron_ready.bw \
#-i http://pania:dalvanius@macaulay00.bmrc.ox.ac.uk/test_data/lanceotron_input/${CONTROL}.lanceotron_ready.bw \

deactivate
module purge

done<meta/test_control_pairs_2.txt
