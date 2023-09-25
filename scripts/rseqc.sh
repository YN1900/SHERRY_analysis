#!/bin/bash
#SBATCH -J rseqc1
#SBATCH -p Acluster
#SBATCH -n 40
#SBATCH --output=%J_rseqc1.out
#SBATCH --err=%J_rseqc1.err



cat sampath_mouse.txt | while read line
do 
	geneBody_coverage.py -r /BioII/wangjb/Backup/SequencingRuns/LLP_DATA/SHERRY/20230810/GenomeData/M_mu/mm10_RefSeq_nochr.bed -i ${line}  -o ${line}
done

cat sampath_human.txt | while read line
do
        geneBody_coverage.py -r /BioII/wangjb/Backup/SequencingRuns/LLP_DATA/SHERRY/20230810/GenomeData/Human/human_RefSeq_nochr.bed -i ${line}  -o ${line}
done
