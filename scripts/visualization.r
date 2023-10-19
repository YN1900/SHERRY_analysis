library(XLConnect)
library(formattable)
library(dplyr)

#读取测序结果统计文件
info_load <- loadWorkbook("SHERRY_results.xlsx",creat=T)
results_info <- readWorksheet(info_load,sheet = 1)
results_info$Number_of_Reads <- as.integer(results_info$Number_of_Reads)

#-------------------------------------------------------------------------------
#读取并处理gene body coverage文件
coverage <- read.table("geneBodyCoverage.txt",header = TRUE)
rename_fun <- function(string){
  return(sub(".sorted","",string))
}
norm_fun <- function(Seq){
  return(Seq/max(Seq))
}

coverage <- coverage %>% 
  mutate(Percentile=lapply(coverage$Percentile,rename_fun))
coverage[,2:101] <- t(apply(coverage[,2:101],1,norm_fun))
coverage[,2:101] <- apply(coverage[,2:101],2,as.numeric)
coverage$Percentile <- as.character(coverage$Percentile)

#向coverage数据框中添加样品信息，然后再重新读取
write.csv(coverage, "data/coverage.csv")

coverage <- read.csv("data/coverage.csv", header = TRUE)
#先创建一个空数据框
coverage2 <- data.frame("sample"=rep("s", times=600), "sample_number"=rep("s", times=600), 
                        "percentile"=rep("s", times=600), "value"=rep("s",times=600))

#将coverage数据变为“长数据”
for (i in seq(1, length(coverage$sample)*100, 100)){
  coverage2$sample[seq(i, i+99)] <- coverage$sample[(i+99)/100]
  coverage2$sample_number[seq(i, i+99)] <- (i+99)/100
  coverage2$percentile[seq(i, i+99)] <- seq(1:100)
  coverage2$value[seq(i, i+99)] <- coverage[(i+99)/100,3:102]

}

coverage2$value <- as.numeric(coverage2$value)
#melt函数也可以实现上面的功能
