#!/bin/bash

grep ">" Homo_sapiens.GRCh38.cdna.all.fa | sed 's/>//g' > header.txt

str="gene_symbol"

cat header.txt | while read line
do
	if [[ ${line} =~ ${str} ]]
		then
			echo ${line} | sed 's/cdna.*gene_symbol://g' | sed 's/description.*//g' >> human_trans_gene_map.txt

 		else
			
			echo ${line} | sed 's/cdna.*gene://g' | sed 's/gene_biotype.*//g' >> human_trans_gene_map.txt
	fi
done
