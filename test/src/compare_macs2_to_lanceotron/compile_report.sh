#!/bin/bash

ls job_outputs/comparison_2_output/* | xargs grep macs2_narrow | \
awk -F' ' 'BEGIN{ none=0; both=0; broad=0; lance=0; total=0} \
{ none=none+$2; both=both+$3; broad=broad+$4; lance=lance+$5; total+=1} \
END{ printf "all\tmacs2_narrow\t%.2f\t(none)\t%.2f\t(both)\t%.2f\t(broad)\t%.2f\t(lance)\n" , none/total, both/total, broad/total, lance/total}'

ls job_outputs/comparison_2_output/* | xargs grep macs2_broad  | \
awk -F' ' 'BEGIN{ none=0; both=0; narrow=0; lance=0; total=0} \
{ none=none+$2; both=both+$3; narrow=narrow+$4; lance=lance+$5; total+=1} \
END{ printf  "all\tmacs2_broad\t%.2f\t(none)\t%.2f\t(both)\t%.2f\t(narrow)\t%.2f\t(lance)\n" , none/total, both/total, narrow/total, lance/total}'

ls job_outputs/comparison_2_output/* | xargs grep 'lanceotron' | grep -v calls | \
awk -F' ' 'BEGIN{ none=0; both=0; narrow=0; broad=0; total=0} \
{ none=none+$2; both=both+$3; narrow=narrow+$4; broad=broad+$5; total+=1} 
END{ printf "all\tlanceotron\t%.2f\t(none)\t%.2f\t(both)\t%.2f\t(narrow)\t%.2f\t(broad)\n" , none/total, both/total, narrow/total, broad/total}'

#************************************

ls job_outputs/comparison_2_output/* | xargs grep macs2_narrow | cut -d'/' -f3- | sed -e 's/\./_/' | \
awk -F'_' '{if($1==229 || $1==236 || $1==230 || $1==237 || $1==233 || $1==239 || $1==234 || $1==240) print $0}' | \
awk -F' ' 'BEGIN{ none=0; both=0; broad=0; lance=0; total=0} \
{ none=none+$2; both=both+$3; broad=broad+$4; lance=lance+$5; total+=1} \
END{ printf "all_test\tmacs2_narrow\t%.2f\t(none)\t%.2f\t(both)\t%.2f\t(broad)\t%.2f\t(lance)\n" , none/total, both/total, broad/total, lance/total}'

ls job_outputs/comparison_2_output/* | xargs grep macs2_broad  | cut -d'/' -f3- | sed -e 's/\./_/' | \
awk -F'_' '{if($1==229 || $1==236 || $1==230 || $1==237 || $1==233 || $1==239 || $1==234 || $1==240) print $0}' | \
awk -F' ' 'BEGIN{ none=0; both=0; narrow=0; lance=0; total=0} \
{ none=none+$2; both=both+$3; narrow=narrow+$4; lance=lance+$5; total+=1} \
END{ printf  "all_test\tmacs2_broad\t%.2f\t(none)\t%.2f\t(both)\t%.2f\t(narrow)\t%.2f\t(lance)\n" , none/total, both/total, narrow/total, lance/total}'

ls job_outputs/comparison_2_output/* | xargs grep 'lanceotron' | grep -v calls | cut -d'/' -f3- | sed -e 's/\./_/' | \
awk -F'_' '{if($1==229 || $1==236 || $1==230 || $1==237 || $1==233 || $1==239 || $1==234 || $1==240) print $0}' | \
awk -F' ' 'BEGIN{ none=0; both=0; narrow=0; broad=0; total=0} \
{ none=none+$2; both=both+$3; narrow=narrow+$4; broad=broad+$5; total+=1} 
END{ printf "all_test\tlanceotron\t%.2f\t(none)\t%.2f\t(both)\t%.2f\t(narrow)\t%.2f\t(broad)\n" , none/total, both/total, narrow/total, broad/total}'

#************************************

ls job_outputs/comparison_2_output/* | xargs grep macs2_narrow | cut -d'/' -f3- | sed -e 's/\./_/' | \
awk -F'_' '{if($1==226 || $1==227 || $1==228 || $1==232) print $0}' | \
awk -F' ' 'BEGIN{ none=0; both=0; broad=0; lance=0; total=0} \
{ none=none+$2; both=both+$3; broad=broad+$4; lance=lance+$5; total+=1} \
END{ printf "all_pos_control\tmacs2_narrow\t%.2f\t(none)\t%.2f\t(both)\t%.2f\t(broad)\t%.2f\t(lance)\n" , none/total, both/total, broad/total, lance/total}'

ls job_outputs/comparison_2_output/* | xargs grep macs2_broad  | cut -d'/' -f3- | sed -e 's/\./_/' | \
awk -F'_' '{if($1==226 || $1==227 || $1==228 || $1==232) print $0}' | \
awk -F' ' 'BEGIN{ none=0; both=0; narrow=0; lance=0; total=0} \
{ none=none+$2; both=both+$3; narrow=narrow+$4; lance=lance+$5; total+=1} \
END{ printf  "all_pos_control\tmacs2_broad\t%.2f\t(none)\t%.2f\t(both)\t%.2f\t(narrow)\t%.2f\t(lance)\n" , none/total, both/total, narrow/total, lance/total}'

ls job_outputs/comparison_2_output/* | xargs grep 'lanceotron' | grep -v calls | cut -d'/' -f3- | sed -e 's/\./_/' | \
awk -F'_' '{if($1==226 || $1==227 || $1==228 || $1==232) print $0}' | \
awk -F' ' 'BEGIN{ none=0; both=0; narrow=0; broad=0; total=0} \
{ none=none+$2; both=both+$3; narrow=narrow+$4; broad=broad+$5; total+=1} 
END{ printf "all_pos_control\tlanceotron\t%.2f\t(none)\t%.2f\t(both)\t%.2f\t(narrow)\t%.2f\t(broad)\n" , none/total, both/total, narrow/total, broad/total}'



#************************************

ls job_outputs/comparison_2_output/* | xargs grep macs2_narrow | cut -d'/' -f3- | sed -e 's/\./_/' | awk -F'_' '{if($2==225 || $2==235) print $0}' | \
awk -F' ' 'BEGIN{ none=0; both=0; broad=0; lance=0; total=0} \
{ none=none+$2; both=both+$3; broad=broad+$4; lance=lance+$5; total+=1} \
END{ printf "DU145\tmacs2_narrow\t%.2f\t(none)\t%.2f\t(both)\t%.2f\t(broad)\t%.2f\t(lance)\n" , none/total, both/total, broad/total, lance/total}'

ls job_outputs/comparison_2_output/* | xargs grep macs2_broad  | cut -d'/' -f3- | sed -e 's/\./_/' | awk -F'_' '{if($2==225 || $2==235) print $0}' | \
awk -F' ' 'BEGIN{ none=0; both=0; narrow=0; lance=0; total=0} \
{ none=none+$2; both=both+$3; narrow=narrow+$4; lance=lance+$5; total+=1} \
END{ printf  "DU145\tmacs2_broad\t%.2f\t(none)\t%.2f\t(both)\t%.2f\t(narrow)\t%.2f\t(lance)\n" , none/total, both/total, narrow/total, lance/total}'

ls job_outputs/comparison_2_output/* | xargs grep 'lanceotron' | grep -v calls | cut -d'/' -f3- | sed -e 's/\./_/' | awk -F'_' '{if($2==225 || $2==235) print $0}' | \
awk -F' ' 'BEGIN{ none=0; both=0; narrow=0; broad=0; total=0} \
{ none=none+$2; both=both+$3; narrow=narrow+$4; broad=broad+$5; total+=1} 
END{ printf "DU145\tlanceotron\t%.2f\t(none)\t%.2f\t(both)\t%.2f\t(narrow)\t%.2f\t(broad)\n" , none/total, both/total, narrow/total, broad/total}'


#************************************

ls job_outputs/comparison_2_output/* | xargs grep macs2_narrow | cut -d'/' -f3- | sed -e 's/\./_/' | \
awk -F'_' '{if($1==229 || $1==236 || $1==230 || $1==237) print $0}' | \
awk -F' ' 'BEGIN{ none=0; both=0; broad=0; lance=0; total=0} \
{ none=none+$2; both=both+$3; broad=broad+$4; lance=lance+$5; total+=1} \
END{ printf "DU145_test\tmacs2_narrow\t%.2f\t(none)\t%.2f\t(both)\t%.2f\t(broad)\t%.2f\t(lance)\n" , none/total, both/total, broad/total, lance/total}'

ls job_outputs/comparison_2_output/* | xargs grep macs2_broad  | cut -d'/' -f3- | sed -e 's/\./_/' | \
awk -F'_' '{if($1==229 || $1==236 || $1==230 || $1==237) print $0}' | \
awk -F' ' 'BEGIN{ none=0; both=0; narrow=0; lance=0; total=0} \
{ none=none+$2; both=both+$3; narrow=narrow+$4; lance=lance+$5; total+=1} \
END{ printf  "DU145_test\tmacs2_broad\t%.2f\t(none)\t%.2f\t(both)\t%.2f\t(narrow)\t%.2f\t(lance)\n" , none/total, both/total, narrow/total, lance/total}'

ls job_outputs/comparison_2_output/* | xargs grep 'lanceotron' | grep -v calls | cut -d'/' -f3- | sed -e 's/\./_/' | \
awk -F'_' '{if($1==229 || $1==236 || $1==230 || $1==237) print $0}' | \
awk -F' ' 'BEGIN{ none=0; both=0; narrow=0; broad=0; total=0} \
{ none=none+$2; both=both+$3; narrow=narrow+$4; broad=broad+$5; total+=1} 
END{ printf "DU145_test\tlanceotron\t%.2f\t(none)\t%.2f\t(both)\t%.2f\t(narrow)\t%.2f\t(broad)\n" , none/total, both/total, narrow/total, broad/total}'


#************************************

ls job_outputs/comparison_2_output/* | xargs grep macs2_narrow | cut -d'/' -f3- | sed -e 's/\./_/' | \
awk -F'_' '{if($1==226 || $1==227 || $1==228) print $0}' | \
awk -F' ' 'BEGIN{ none=0; both=0; broad=0; lance=0; total=0} \
{ none=none+$2; both=both+$3; broad=broad+$4; lance=lance+$5; total+=1} \
END{ printf "DU145_pos_control\tmacs2_narrow\t%.2f\t(none)\t%.2f\t(both)\t%.2f\t(broad)\t%.2f\t(lance)\n" , none/total, both/total, broad/total, lance/total}'

ls job_outputs/comparison_2_output/* | xargs grep macs2_broad  | cut -d'/' -f3- | sed -e 's/\./_/' | \
awk -F'_' '{if($1==226 || $1==227 || $1==228) print $0}' | \
awk -F' ' 'BEGIN{ none=0; both=0; narrow=0; lance=0; total=0} \
{ none=none+$2; both=both+$3; narrow=narrow+$4; lance=lance+$5; total+=1} \
END{ printf  "DU145_pos_control\tmacs2_broad\t%.2f\t(none)\t%.2f\t(both)\t%.2f\t(narrow)\t%.2f\t(lance)\n" , none/total, both/total, narrow/total, lance/total}'

ls job_outputs/comparison_2_output/* | xargs grep 'lanceotron' | grep -v calls | cut -d'/' -f3- | sed -e 's/\./_/' | \
awk -F'_' '{if($1==226 || $1==227 || $1==228) print $0}' | \
awk -F' ' 'BEGIN{ none=0; both=0; narrow=0; broad=0; total=0} \
{ none=none+$2; both=both+$3; narrow=narrow+$4; broad=broad+$5; total+=1} 
END{ printf "DU145_pos_control\tlanceotron\t%.2f\t(none)\t%.2f\t(both)\t%.2f\t(narrow)\t%.2f\t(broad)\n" , none/total, both/total, narrow/total, broad/total}'


#************************************

ls job_outputs/comparison_2_output/* | xargs grep macs2_narrow | cut -d'/' -f3- | sed -e 's/\./_/' | awk -F'_' '{if($2==231 || $2==238) print $0}' | \
awk -F' ' 'BEGIN{ none=0; both=0; broad=0; lance=0; total=0} \
{ none=none+$2; both=both+$3; broad=broad+$4; lance=lance+$5; total+=1} \
END{ printf "SKMNC\tmacs2_narrow\t%.2f\t(none)\t%.2f\t(both)\t%.2f\t(broad)\t%.2f\t(lance)\n" , none/total, both/total, broad/total, lance/total}'

ls job_outputs/comparison_2_output/* | xargs grep macs2_broad  | cut -d'/' -f3- | sed -e 's/\./_/' | awk -F'_' '{if($2==231 || $2==238) print $0}' | \
awk -F' ' 'BEGIN{ none=0; both=0; narrow=0; lance=0; total=0} \
{ none=none+$2; both=both+$3; narrow=narrow+$4; lance=lance+$5; total+=1} \
END{ printf  "SKMNC\tmacs2_broad\t%.2f\t(none)\t%.2f\t(both)\t%.2f\t(narrow)\t%.2f\t(lance)\n" , none/total, both/total, narrow/total, lance/total}'

ls job_outputs/comparison_2_output/* | xargs grep 'lanceotron' | grep -v calls | cut -d'/' -f3- | sed -e 's/\./_/' | awk -F'_' '{if($2==231 || $2==238) print $0}' | \
awk -F' ' 'BEGIN{ none=0; both=0; narrow=0; broad=0; total=0} \
{ none=none+$2; both=both+$3; narrow=narrow+$4; broad=broad+$5; total+=1} 
END{ printf "SKMNC\tlanceotron\t%.2f\t(none)\t%.2f\t(both)\t%.2f\t(narrow)\t%.2f\t(broad)\n" , none/total, both/total, narrow/total, broad/total}'


#************************************

ls job_outputs/comparison_2_output/* | xargs grep macs2_narrow | cut -d'/' -f3- | sed -e 's/\./_/' | \
awk -F'_' '{if($1==233 || $1==239 || $1==234 || $1==240) print $0}' | \
awk -F' ' 'BEGIN{ none=0; both=0; broad=0; lance=0; total=0} \
{ none=none+$2; both=both+$3; broad=broad+$4; lance=lance+$5; total+=1} \
END{ printf "SKMNC_test\tmacs2_narrow\t%.2f\t(none)\t%.2f\t(both)\t%.2f\t(broad)\t%.2f\t(lance)\n" , none/total, both/total, broad/total, lance/total}'

ls job_outputs/comparison_2_output/* | xargs grep macs2_broad  | cut -d'/' -f3- | sed -e 's/\./_/' | \
awk -F'_' '{if($1==233 || $1==239 || $1==234 || $1==240) print $0}' | \
awk -F' ' 'BEGIN{ none=0; both=0; narrow=0; lance=0; total=0} \
{ none=none+$2; both=both+$3; narrow=narrow+$4; lance=lance+$5; total+=1} \
END{ printf  "SKMNC_test\tmacs2_broad\t%.2f\t(none)\t%.2f\t(both)\t%.2f\t(narrow)\t%.2f\t(lance)\n" , none/total, both/total, narrow/total, lance/total}'

ls job_outputs/comparison_2_output/* | xargs grep 'lanceotron' | grep -v calls | cut -d'/' -f3- | sed -e 's/\./_/' | \
awk -F'_' '{if($1==233 || $1==239 || $1==234 || $1==240) print $0}' | \
awk -F' ' 'BEGIN{ none=0; both=0; narrow=0; broad=0; total=0} \
{ none=none+$2; both=both+$3; narrow=narrow+$4; broad=broad+$5; total+=1} 
END{ printf "SKMNC_test\tlanceotron\t%.2f\t(none)\t%.2f\t(both)\t%.2f\t(narrow)\t%.2f\t(broad)\n" , none/total, both/total, narrow/total, broad/total}'


#************************************

ls job_outputs/comparison_2_output/* | xargs grep macs2_narrow | cut -d'/' -f3- | sed -e 's/\./_/' | \
awk -F'_' '{if($1==232) print $0}' | \
awk -F' ' 'BEGIN{ none=0; both=0; broad=0; lance=0; total=0} \
{ none=none+$2; both=both+$3; broad=broad+$4; lance=lance+$5; total+=1} \
END{ printf "SKMNC_pos_control\tmacs2_narrow\t%.2f\t(none)\t%.2f\t(both)\t%.2f\t(broad)\t%.2f\t(lance)\n" , none/total, both/total, broad/total, lance/total}'

ls job_outputs/comparison_2_output/* | xargs grep macs2_broad  | cut -d'/' -f3- | sed -e 's/\./_/' | \
awk -F'_' '{if($1==232) print $0}' | \
awk -F' ' 'BEGIN{ none=0; both=0; narrow=0; lance=0; total=0} \
{ none=none+$2; both=both+$3; narrow=narrow+$4; lance=lance+$5; total+=1} \
END{ printf  "SKMNC_pos_control\tmacs2_broad\t%.2f\t(none)\t%.2f\t(both)\t%.2f\t(narrow)\t%.2f\t(lance)\n" , none/total, both/total, narrow/total, lance/total}'

ls job_outputs/comparison_2_output/* | xargs grep 'lanceotron' | grep -v calls | cut -d'/' -f3- | sed -e 's/\./_/' | \
awk -F'_' '{if($1==232) print $0}' | \
awk -F' ' 'BEGIN{ none=0; both=0; narrow=0; broad=0; total=0} \
{ none=none+$2; both=both+$3; narrow=narrow+$4; broad=broad+$5; total+=1} 
END{ printf "SKMNC_pos_control\tlanceotron\t%.2f\t(none)\t%.2f\t(both)\t%.2f\t(narrow)\t%.2f\t(broad)\n" , none/total, both/total, narrow/total, broad/total}'
