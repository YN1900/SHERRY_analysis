#!/bin/bash

#进入A集群中下载数据存放的位置
cd /BioII/wangjb/Backup/SequencingRuns/LLP_DATA/SHERRY/20230810/20230910_20230911

for dir in `ls` ; do
	if [ -d $dir ]; then
		cd $dir;
		if [ "$(md5sum $(cat MD5.txt | awk 'NR==1{print $2}'))" = "$(cat MD5.txt | awk 'NR==1')" ]
		then
			echo "${dir}_1.clean.fq.gz: pass" >> /BioII/wangjb/Backup/SequencingRuns/LLP_DATA/SHERRY/20230810/20230910_20230911/md5check_out.txt
		else
			echo "${dir}_1.clean.fq.gz: failure" >> /BioII/wangjb/Backup/SequencingRuns/LLP_DATA/SHERRY/20230810/20230910_20230911/md5check_out.txt
		fi


		if [ "$(md5sum $(cat MD5.txt | awk 'NR==2{print $2}'))" = "$(cat MD5.txt | awk 'NR==2')" ]
                then
                        echo "${dir}_2.clean.fq.gz: pass" >> /BioII/wangjb/Backup/SequencingRuns/LLP_DATA/SHERRY/20230810/20230910_20230911/md5check_out.txt
                else
                        echo "${dir}_2.clean.fq.gz: failure" >> /BioII/wangjb/Backup/SequencingRuns/LLP_DATA/SHERRY/20230810/20230910_20230911/md5check_out.txt
		fi
		cd ..
	fi

done
