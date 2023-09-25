#!/bin/bash
#SBATCH -J area
#SBATCH -p Acluster


samp=(1ug_9 1ug_10 1ug_11 1ug_12 100ng_9 100ng_10 100ng_11 10ng_9 10ng_10 10ng_11 10ng_12 1ng_9 1ng_10 1ng_11 1ng_12 1ng_13 100pg_8 100pg_9 100pg_10 100pg_11 100pg_12 100pg_13 100pg_14 100pg_15 100pg_16 100pg_17 100pg_18 10pg_8 10pg_9 10pg_10 10pg_11 10pg_12 10pg_13 10pg_14 10pg_15)

filepath=/BioII/wangjb/Backup/SequencingRuns/LLP_DATA/SHERRY/20230810/20230910_20230911/trimmed/Outputs/Hisat_results/rseqc_results

for i in ${samp[@]}
do
	chmod 777 ${filepath}/${i}.geneBodyCoverage.txt
	var=`cat ${filepath}/${i}.geneBodyCoverage.txt | awk 'NR==2{print$1}'`
	samp_name=$(echo ${var##V} | sed 's/.sorted//')
	uniformity=`perl ${filepath}/area.pl  ${filepath}/${i}.geneBodyCoverage.txt | tail -1 | awk '{print $NF}'`
	echo -e "${samp_name}\t${uniformity}" >> 20230910_20230911_area.txt
done
