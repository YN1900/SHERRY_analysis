#!/bin/bash

#示例脚本
cd /BioII/wangjb/Backup/SequencingRuns/LLP_DATA/SHERRY/20230810/LCM_20230728

for name in `ls` ;do
        if [ -d $name ];then
                cd $name;
                for var in LCM* ; do mv $var ${var#LCM_20230728_} ; done
                cd ..
                mv $name ${name#LCM_20230728_};
        fi
done
