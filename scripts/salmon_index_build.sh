#!/bin/bash

grep "^>" <(gunzip -c /BioII/wangjb/Backup/SequencingRuns/LLP_DATA/SHERRY/20230810/GenomeData/Human/Homo_sapiens.GRCh38.dna.primary_assembly.fa) | cut -d " " -f 1 > decoys.txt
sed -i.bak -e 's/>//g' decoys.txt

cat /BioII/wangjb/Backup/SequencingRuns/LLP_DATA/SHERRY/20230810/GenomeData/Human/Homo_sapiens.GRCh38.cdna.all.fa \
 /BioII/wangjb/Backup/SequencingRuns/LLP_DATA/SHERRY/20230810/GenomeData/Human/Homo_sapiens.GRCh38.dna.primary_assembly.fa > gentrome.fa.gz

/Share/home/wangjb/usr/Salmon-0.8.2_linux_x86_64/bin/salmon index -t gentrome.fa.gz -d decoys.txt -p 12 -i salmon_index
