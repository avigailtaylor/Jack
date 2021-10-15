#!/bin/bash

ls job_outputs/comparison_output/* | xargs grep macs2_narrow | \
awk -F' ' 'BEGIN{ none=0; both=0; broad=0; lance=0; total=0} \
{ none=none+$2; both=both+$3; broad=broad+$4; lance=lance+$5; total+=1} \
END{ printf "all\tmacs2_narrow\t%.2f\t(none)\t%.2f\t(both)\t%.2f\t(broad)\t%.2f\t(lance)\n" , none/total, both/total, broad/total, lance/total}'

ls job_outputs/comparison_output/* | xargs grep macs2_broad  | \
awk -F' ' 'BEGIN{ none=0; both=0; narrow=0; lance=0; total=0} \
{ none=none+$2; both=both+$3; narrow=narrow+$4; lance=lance+$5; total+=1} \
END{ printf  "all\tmacs2_broad\t%.2f\t(none)\t%.2f\t(both)\t%.2f\t(narrow)\t%.2f\t(lance)\n" , none/total, both/total, narrow/total, lance/total}'

ls job_outputs/comparison_output/* | xargs grep 'lanceotron' | grep -v calls | \
awk -F' ' 'BEGIN{ none=0; both=0; narrow=0; broad=0; total=0} \
{ none=none+$2; both=both+$3; narrow=narrow+$4; broad=broad+$5; total+=1} 
END{ printf "all\tlanceotron\t%.2f\t(none)\t%.2f\t(both)\t%.2f\t(narrow)\t%.2f\t(broad)\n" , none/total, both/total, narrow/total, broad/total}'


ls job_outputs/comparison_output/* | grep IGF | xargs grep macs2_narrow | \
awk -F' ' 'BEGIN{ none=0; both=0; broad=0; lance=0; total=0} \
{ none=none+$2; both=both+$3; broad=broad+$4; lance=lance+$5; total+=1} \
END{ printf "IGF-1R\tmacs2_narrow\t%.2f\t(none)\t%.2f\t(both)\t%.2f\t(broad)\t%.2f\t(lance)\n" , none/total, both/total, broad/total, lance/total}'

ls job_outputs/comparison_output/* | grep IGF | xargs grep macs2_broad  | \
awk -F' ' 'BEGIN{ none=0; both=0; narrow=0; lance=0; total=0} \
{ none=none+$2; both=both+$3; narrow=narrow+$4; lance=lance+$5; total+=1} \
END{ printf  "IGF-1R\tmacs2_broad\t%.2f\t(none)\t%.2f\t(both)\t%.2f\t(narrow)\t%.2f\t(lance)\n" , none/total, both/total, narrow/total, lance/total}'

ls job_outputs/comparison_output/* | grep IGF | xargs grep 'lanceotron' | grep -v calls | \
awk -F' ' 'BEGIN{ none=0; both=0; narrow=0; broad=0; total=0} \
{ none=none+$2; both=both+$3; narrow=narrow+$4; broad=broad+$5; total+=1} 
END{ printf "IGF-1R\tlanceotron\t%.2f\t(none)\t%.2f\t(both)\t%.2f\t(narrow)\t%.2f\t(broad)\n" , none/total, both/total, narrow/total, broad/total}'


ls job_outputs/comparison_output/* | grep Controlbeads | xargs grep macs2_narrow | \
awk -F' ' 'BEGIN{ none=0; both=0; broad=0; lance=0; total=0} \
{ none=none+$2; both=both+$3; broad=broad+$4; lance=lance+$5; total+=1} \
END{ printf "Control\tmacs2_narrow\t%.2f\t(none)\t%.2f\t(both)\t%.2f\t(broad)\t%.2f\t(lance)\n" , none/total, both/total, broad/total, lance/total}'

ls job_outputs/comparison_output/* | grep Controlbeads | xargs grep macs2_broad  | \
awk -F' ' 'BEGIN{ none=0; both=0; narrow=0; lance=0; total=0} \
{ none=none+$2; both=both+$3; narrow=narrow+$4; lance=lance+$5; total+=1} \
END{ printf  "Control\tmacs2_broad\t%.2f\t(none)\t%.2f\t(both)\t%.2f\t(narrow)\t%.2f\t(lance)\n" , none/total, both/total, narrow/total, lance/total}'

ls job_outputs/comparison_output/* | grep Controlbeads | xargs grep 'lanceotron' | grep -v calls | \
awk -F' ' 'BEGIN{ none=0; both=0; narrow=0; broad=0; total=0} \
{ none=none+$2; both=both+$3; narrow=narrow+$4; broad=broad+$5; total+=1} 
END{ printf "Control\tlanceotron\t%.2f\t(none)\t%.2f\t(both)\t%.2f\t(narrow)\t%.2f\t(broad)\n" , none/total, both/total, narrow/total, broad/total}'



ls job_outputs/comparison_output/* | grep H3 | xargs grep macs2_narrow | \
awk -F' ' 'BEGIN{ none=0; both=0; broad=0; lance=0; total=0} \
{ none=none+$2; both=both+$3; broad=broad+$4; lance=lance+$5; total+=1} \
END{ printf "H3-positive_control\tmacs2_narrow\t%.2f\t(none)\t%.2f\t(both)\t%.2f\t(broad)\t%.2f\t(lance)\n" , none/total, both/total, broad/total, lance/total}'

ls job_outputs/comparison_output/* | grep H3 | xargs grep macs2_broad  | \
awk -F' ' 'BEGIN{ none=0; both=0; narrow=0; lance=0; total=0} \
{ none=none+$2; both=both+$3; narrow=narrow+$4; lance=lance+$5; total+=1} \
END{ printf  "H3-positive-control\tmacs2_broad\t%.2f\t(none)\t%.2f\t(both)\t%.2f\t(narrow)\t%.2f\t(lance)\n" , none/total, both/total, narrow/total, lance/total}'

ls job_outputs/comparison_output/* | grep H3 | xargs grep 'lanceotron' | grep -v calls | \
awk -F' ' 'BEGIN{ none=0; both=0; narrow=0; broad=0; total=0} \
{ none=none+$2; both=both+$3; narrow=narrow+$4; broad=broad+$5; total+=1} 
END{ printf "H3-positive-control\tlanceotron\t%.2f\t(none)\t%.2f\t(both)\t%.2f\t(narrow)\t%.2f\t(broad)\n" , none/total, both/total, narrow/total, broad/total}'

