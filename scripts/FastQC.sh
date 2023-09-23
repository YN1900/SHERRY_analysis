#!/bin/bash
#SBATCH -J fastqc  
#SBATCH -p Acluster  
#SBATCH -n 40  
#SBATCH --output=%j_fastqc.out  
#SBATCH --error=%j_fastqc.err 

samps=(S5_29 S5_30 S5_31 S5_32)


file_path=/BioII/wangjb/Backup/SequencingRuns/LLP_DATA/SHERRY/20230810/LCM_20230803
outdir=/BioII/wangjb/Backup/SequencingRuns/LLP_DATA/SHERRY/20230810/LCM_20230803/Outputs/FastQC_results


for i in ${samps[@]}
do
	if [ ! -d ${outdir}/${i} ]; then
		mkdir ${outdir}/${i}
	fi

	/BioII/wangjb/Backup/SequencingRuns/LLP_DATA/SHERRY/20230810/software/FastQC/fastqc --extract -o ${outdir}/${i} ${file_path}/${i}/${i}_1.clean.fq.gz  ${file_path}/${i}/${i}_2.clean.fq.gz

done
