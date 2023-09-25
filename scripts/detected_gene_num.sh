#!/bin/bash

dir=(LCM_20230728 LCM_20230803 20230809 20230814 20230816)

for d in ${dir[@]}
do
	path=/BioII/wangjb/Backup/SequencingRuns/LLP_DATA/SHERRY/20230810/${d}/trimmed/Outputs/Quant_results
	for f in `ls ${path}`
	do
		if [ -d ${path}/${f} ] ; then
			echo -e "${f}\t$(cat ${path}/${f}/quant.genes.sf | awk '$4>1' | wc -l)" >> /BioII/wangjb/Backup/SequencingRuns/LLP_DATA/SHERRY/20230810/detected_gene_num.txt;
		fi
	done
done



