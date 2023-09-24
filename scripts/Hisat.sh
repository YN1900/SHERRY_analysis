#!/bin/bash
#SBATCH -J hisat
#SBATCH -p Acluster
#SBATCH -n 40
#SBATCH --output=%J_hisat.out
#SBATCH --err=%J_hisat.err


samp=(RNA_1ug_1 RNA_1ug_2 RNA_1ug_3 RNA_1ug_4 RNA_100ng_1 RNA_100ng_2 RNA_100ng_3 RNA_100ng_4 RNA_10ng_1 RNA_10ng_2 RNA_10ng_3 RNA_10ng_4 RNA_1ng_1 RNA_1ng_2 RNA_1ng_3 RNA_1ng_4 RNA_100pg_1 RNA_100pg_2 RNA_100pg_3 RNA_100pg_4 RNA_10pg_1 RNA_10pg_2 RNA_10pg_3 RNA_10pg_4 RNA_1pg_1 RNA_1pg_2 RNA_1pg_3 RNA_1pg_4)

file_path=/BioII/wangjb/Backup/SequencingRuns/LLP_DATA/SHERRY/20230810/20230814/trimmed

out_path=/BioII/wangjb/Backup/SequencingRuns/LLP_DATA/SHERRY/20230810/20230814/trimmed/Outputs/Hisat_results


for i in ${samp[@]} 
do
	echo "processing ${file_path}/${i}"
	/Share/home/wangjb/usr/hisat2-2.1.0/hisat2  -x /BioII/wangjb/Backup/SequencingRuns/LLP_DATA/SHERRY/20230810/GenomeData/Human/Hisat_index/grch38/genome \
		-1 ${file_path}/${i}/${i}_1_trimmed.fastq.gz \ 
		-2 ${file_path}/${i}/${i}_2_trimmed.fastq.gz \
		-S ${out_path}/${i}.sam
done
