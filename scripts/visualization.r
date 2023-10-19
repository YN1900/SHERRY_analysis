library(formattable)
library(dplyr)
library(ggplot2)
library(cowplot)
library(ggbeeswarm)
library(ggsignif)
library(RColorBrewer)

#smart seq2、SHERRY、try SHERRY的mapping rate和exonic_rate的比较
results1 <- results_info[1:20,] %>% group_by(method) %>%
  summarise(mapping_rate=percent(mean(Mapping_Rate)),
            mapping_s.d=percent(sd(Mapping_Rate)),
            exonic_rate=percent(mean(Exonic_Rate)),
            exon_s.d=percent(sd(Exonic_Rate)))

results1$method <- factor(results1$method, ordered=TRUE, levels = c("Smart seq2", "SHERRY", "Try-SHERRY"))

p1 <- ggplot() +
  geom_bar(data=results1,aes(x=method, y=mapping_rate, color=method),stat="identity", position="dodge", width=0.6, fill="white",linewidth=0.8) +
  geom_errorbar(data=results1, aes(x=method, y=mapping_rate, ymin=mapping_rate-exon_s.d, ymax=mapping_rate+exon_s.d, color=method), linewidth=0.75, width=0.08) +
  geom_beeswarm(data=results_info[1:20,], aes(x=method, y=Mapping_Rate, color=method), alpha=0.7, cex=3, size=3)+
  theme_classic()+
  labs(y="Mapping Rate")+
  theme(axis.title.x = element_blank(),
        legend.position = "none")

p2 <- ggplot() +
  geom_bar(data=results1,aes(x=method, y=exonic_rate, color=method),stat="identity", position="dodge", width=0.6, fill="white",linewidth=0.8) +
  geom_errorbar(data=results1, aes(x=method, y=exonic_rate, ymin=exonic_rate-exon_s.d, ymax=exonic_rate+exon_s.d, color=method), linewidth=0.75, width=0.08) +
  geom_beeswarm(data=results_info[1:20,], aes(x=method, y=Exonic_Rate, color=method), alpha=0.7, cex=3, size=3)+
  theme_classic()+
  labs(y="Exonic Rate")+
  theme(axis.title.x = element_blank(),
        legend.title = element_blank())


#-----------------------------------------------------------------------
#LCM和流式样品的mapping rate和exonic_rate
results2 <- results_info[21:52,]
results2$sample_description <- c(rep("sorted",12),rep("LCM",20))

results2_1 <- results2 %>%
  group_by(sample,sample_description) %>%
  summarise(mapping_rate=percent(mean(Mapping_Rate)),
            mapping_s.d=percent(sd(Mapping_Rate)),
            exonic_rate=percent(mean(Exonic_Rate)),
            exon_s.d=percent(sd(Exonic_Rate)))

results2_1$sample <- factor(results2_1$sample, ordered=TRUE, levels = c("1000cells", "100cells", "10cells", "1cell"))

p3 <- ggplot() +
  geom_bar(data=results2_1,aes(x=sample, y=mapping_rate, color=sample_description),stat="identity", position="dodge", fill="white", linewidth=0.8, width=0.6) +
  geom_errorbar(data=results2_1,aes(x=sample, y=mapping_rate, ymin=mapping_rate-exon_s.d, ymax=mapping_rate+exon_s.d, color=sample_description), linewidth=0.75, width=0.08,position=position_dodge(0.6)) +
  geom_beeswarm(data=results2, aes(x=sample, y=Mapping_Rate, color=sample_description), alpha=0.7, cex=3, size=3, dodge.width = 0.6)+
  theme_classic()+
  labs(x="sample type(Try-SHERRY)", y="Mapping Rate")+
  theme(legend.title = element_blank(),
        legend.position = "none",
        axis.title.x = element_blank())


p4 <- ggplot() +
  geom_bar(data=results2_1,aes(x=sample, y=exonic_rate, color=sample_description),stat="identity", position="dodge", fill="white", linewidth=0.8, width=0.6) +
  geom_errorbar(data=results2_1,aes(x=sample, y=exonic_rate, ymin=exonic_rate-exon_s.d, ymax=exonic_rate+exon_s.d, color=sample_description), linewidth=0.75, width=0.08,position=position_dodge(0.6)) +
  geom_beeswarm(data=results2, aes(x=sample, y=Exonic_Rate, color=sample_description), alpha=0.7, cex=3, size=3, dodge.width = 0.6)+
  theme_classic()+
  labs(x="sample type(Try-SHERRY)", y="Exonic Rate")+
  theme(legend.title = element_blank(),
        axis.title.x = element_blank())

plot_grid(p1, p2, p3, p4, labels=c("A", "B", "C", "D"),rel_widths = c(0.75,1), align="hv")

#---------------------------------------------------------------------------
#Purified RNA 样品的各项指标测序质量
results3 <- results_info[97:117,] %>% group_by(sample) %>%
  summarise(mapping_rate=percent(mean(Mapping_Rate)),
            mapping_s.d=percent(sd(Mapping_Rate)),
            exonic_rate=percent(mean(Exonic_Rate)),
            exon_s.d=percent(sd(Exonic_Rate)),
            genes_detected=round(mean(Genes_Detected)),
            genes_s.d=round(sd(Genes_Detected)))
results3 <- mutate(results3,
                   `Mapping Rate`=paste0(sub("([0-9.]*)%", "\\1", mapping_rate),"±",mapping_s.d),
                   `Exonic Rate`=paste0(sub("([0-9.]*)%", "\\1", exonic_rate),"±",exon_s.d),
                   `Genes Detected`=paste0(genes_detected, "±", genes_s.d))
results3$sample <- factor(results3$sample, ordered=TRUE, levels = c("1ug", "100ng", "10ng","1ng","100pg","10pg"))

results3_1 <- results_info[97:117,c(1,3,7,8,9)]
results3_2 <- data.frame("sample"=rep("1ug", times=63), "rate"=rep(percent(0.01), times=63), "type"=rep("unique", times=63), "source"=rep("s", times=63))

for (i in seq(1, length(results3_1$sample)*3, 3)){
  results3_2$sample[c(i, i+1, i+2)] <- results3_1$sample[(i+2)/3]
  results3_2$source[c(i, i+1, i+2)] <- results3_1$sample_number[(i+2)/3]
  
  results3_2$rate[i] <- results3_1$Uniquely_Mapping[(i+2)/3]
  results3_2$type[i] <- "Uniquely mapping"
  
  results3_2$rate[i+1] <- results3_1$Multimapping[(i+2)/3]
  results3_2$type[i+1] <- "Multimapping"
  
  results3_2$rate[i+2] <- results3_1$No_Match[(i+2)/3]
  results3_2$type[i+2] <- "No match"
}
results3_2$sample <- factor(results3_2$sample, ordered=TRUE, levels = c("1ug", "100ng", "10ng","1ng","100pg","10pg"))

p5 <- ggplot() +
  geom_bar(data=results3, aes(x=sample, y=mapping_rate, color=sample), stat="identity", position="dodge", fill="white", width=0.6, linewidth=0.8) +
  geom_errorbar(data=results3, aes(x=sample, y=mapping_rate, ymin=mapping_rate-mapping_s.d, ymax=mapping_rate+mapping_s.d, color=sample), linewidth=0.75, width=0.08) +
  geom_beeswarm(data=results_info[97:117,], aes(x=sample, y=Mapping_Rate, color=sample), alpha=0.7, cex=3, size=3)+
  theme_classic()+
  theme(legend.position = "none",
        axis.title.x = element_blank())+
  labs(y="Mapping Rate")

p6<- ggplot() +
  geom_bar(data=results3,aes(x=sample, y=exonic_rate, color=sample),stat="identity", position="dodge", width=0.6, fill="white",linewidth=0.8) +
  geom_errorbar(data=results3, aes(x=sample, y=exonic_rate, ymin=exonic_rate-exon_s.d, ymax=exonic_rate+exon_s.d, color=sample), linewidth=0.75, width=0.08) +
  geom_beeswarm(data=results_info[97:117,], aes(x=sample, y=Exonic_Rate, color=sample), alpha=0.7, cex=3, size=3)+
  theme_classic()+
  labs(y="Exonic Rate")+
  theme(axis.title.x = element_blank(),
        legend.title = element_blank())

p7 <- ggplot() +
  geom_bar(data=results3,aes(x=sample, y=genes_detected, color=sample),stat="identity", position="dodge", width=0.6, fill="white",linewidth=0.8) +
  geom_errorbar(data=results3, aes(x=sample, y=genes_detected, ymin=genes_detected-genes_s.d, ymax=genes_detected+genes_s.d, color=sample), linewidth=0.75, width=0.08) +
  geom_beeswarm(data=results_info[97:117,], aes(x=sample, y=Genes_Detected, color=sample), alpha=0.7, cex=3, size=3)+
  theme_classic()+
  theme(legend.position = "none",
        axis.title.x = element_blank())+
  labs(y="Genes Detected")

p8 <- ggplot(data=results3_2, aes(x=source, y=rate, fill=type))+
  geom_bar(position="fill", stat = "identity") +
  facet_grid(~sample)+
  theme_classic()+
  scale_fill_manual(values=c("#e20612","#ffd401","#00b0eb"))+
  theme(axis.line.x = element_blank(),
        axis.text.x = element_blank(),
        axis.title.x = element_blank(),
        axis.ticks.x = element_blank(),
        legend.title = element_blank(),
        legend.key.size = unit(10,"pt"),
        legend.text = element_text(size=7)
        ) +
  labs(y="Reads Ratio")

plot_grid(p5, p6, p7, p8, labels=c("A", "B", "C", "D"),rel_widths = c(0.75,1), align="v", axis = "l")

#--------------------------------------------------------------------------------------------------------
#增加DNase量的影响
results4 <- results_info[153:159,c(2,3,5,6)]
results4$sample_description <- c(rep("0.4 μL",4),rep("0.8 μL",3))

results4_1 <- results4 %>%
  group_by(sample_description) %>%
  summarise(mapping_rate=percent(mean(Mapping_Rate)),
            mapping_s.d=percent(sd(Mapping_Rate)),
            exonic_rate=percent(mean(Exonic_Rate)),
            exon_s.d=percent(sd(Exonic_Rate)))

ggplot() +
  geom_bar(data=results4_1,aes(x=sample_description, y=exonic_rate, color=sample_description),stat="identity", position="dodge", width=0.6, fill="white",linewidth=0.8) +
  geom_errorbar(data=results4_1, aes(x=sample_description, y=exonic_rate, ymin=exonic_rate-exon_s.d, ymax=exonic_rate+exon_s.d, color=sample_description), linewidth=0.75, width=0.08) +
  geom_beeswarm(data=results4, aes(x=sample_description, y=Exonic_Rate, color=sample_description), alpha=0.7, cex=3, size=3)+
  theme_classic()+
  labs(y="Exonic Rate")+
  theme(axis.title.x = element_blank(),
        legend.title = element_blank())


#-------------------------------------------------------------------------------------------------------
#比较添加100pg carrier DNA前后的结果
results5 <- results_info[c(65:76,109:117,129:152,160:171),c(1,3,4,5,6)]

#删除疑似污染的数据
results5 <- results5[-c(27,28,38),]

results5$method <- c(rep("no carrier DNA",22),rep("10pg carrier DNA",20), rep("100pg carrier DNA",12))
results5$method <- factor(results5$method, ordered=TRUE, levels = c("no carrier DNA", "10pg carrier DNA", "100pg carrier DNA"))
results5$sample <- factor(results5$sample, ordered=TRUE, levels = c("1ng", "100pg", "10pg"))


results5_1 <- results5 %>%
  group_by(sample,method) %>%
  summarise(mapping_rate=percent(mean(Mapping_Rate)),
            mapping_s.d=percent(sd(Mapping_Rate)),
            exonic_rate=percent(mean(Exonic_Rate)),
            exon_s.d=percent(sd(Exonic_Rate)))

results5_1$sample <- factor(results5_1$sample, ordered=TRUE, levels = c("1ng", "100pg", "10pg"))
results5_1$method <- factor(results5_1$method, ordered=TRUE, levels = c("no carrier DNA", "10pg carrier DNA", "100pg carrier DNA"))

#手动t检验并添加显著性标记
#no与10pg carrier:
t.test(results5$Mapping_Rate[c(1:4,13:15,22)],results5$Mapping_Rate[c(39:42)])
#1ng: p-value = 0.000617
t.test(results5$Mapping_Rate[c(5:8,16:18)],results5$Mapping_Rate[c(23:27,32:35)])
#100pg: p-value = 0.018
t.test(results5$Mapping_Rate[c(9:12,19:21)],results5$Mapping_Rate[c(28:31,36:38)])
#10pg: p-value = 0.09437

#no与100pg carrier:
t.test(results5$Mapping_Rate[c(1:4,13:15,22)],results5$Mapping_Rate[c(51:54)])
#1ng: p-value = 0.0004662
t.test(results5$Mapping_Rate[c(5:8,16:18)],results5$Mapping_Rate[c(43:46)])
#100pg: p-value = 0.000326
t.test(results5$Mapping_Rate[c(9:12,19:21)],results5$Mapping_Rate[c(47:50)])
#10pg: p-value = 0.000236

#10pg与100pg carrier:
t.test(results5$Mapping_Rate[c(39:42)],results5$Mapping_Rate[c(51:54)])
#1ng: p-value = 0.4205
t.test(results5$Mapping_Rate[c(23:27,32:35)],results5$Mapping_Rate[c(43:46)])
#100pg: p-value = 0.00001195
t.test(results5$Mapping_Rate[c(28:31,36:38)],results5$Mapping_Rate[c(47:50)])
#10pg: p-value = 0.000002496


p9 <- ggplot() +
  geom_bar(data=results5_1,aes(x=sample, y=mapping_rate, color=method),stat="identity", position="dodge", width=0.6, fill="white",linewidth=0.8) +
  geom_errorbar(data=results5_1, aes(x=sample, y=mapping_rate, ymin=mapping_rate-exon_s.d, ymax=mapping_rate+exon_s.d, color=method), linewidth=0.75, width=0.08,position=position_dodge(0.6)) +
  geom_beeswarm(data=results5, aes(x=sample, y=Mapping_Rate, color=method), alpha=0.7, cex=2, size=2.5,dodge.width = 0.6)+
  theme_classic()+
  scale_color_manual(values=brewer.pal(3, "Set2"))+
  geom_signif(
    data=results5,aes(x=sample, y=Mapping_Rate),
    xmin = c(0.75, 1.05, 0.75,1.75, 2.05, 1.75, 2.75, 3.05, 2.75),
    xmax = c(0.95, 1.25, 1.25, 1.95, 2.25,2.25,  2.95, 3.25, 3.25),
    annotations = c("***", "NS", "***","**", "***","***" ,"NS","***","***"),
    y_position = c(1,1, 1.08, 0.8,0.95, 1.02, 0.4,0.7,0.77),
    textsize = 4,
  )+
  labs(y="Mapping Rate")+
  theme(axis.title.x = element_blank())

#no与10pg carrier:
t.test(results5$Exonic_Rate[c(1:4,13:15,22)],results5$Exonic_Rate[c(39:42)])
#1ng: p-value = 0.008287
t.test(results5$Exonic_Rate[c(5:8,16:18)],results5$Exonic_Rate[c(23:27,32:35)])
#100pg: p-value = 0.5756
t.test(results5$Exonic_Rate[c(9:12,19:21)],results5$Exonic_Rate[c(28:31,36:38)])
#10pg: p-value = 0.4031

#no与100pg carrier:
t.test(results5$Exonic_Rate[c(1:4,13:15,22)],results5$Exonic_Rate[c(51:54)])
#1ng: p-value = 0.01127
t.test(results5$Exonic_Rate[c(5:8,16:18)],results5$Exonic_Rate[c(43:46)])
#100pg: p-value = 0.003255
t.test(results5$Exonic_Rate[c(9:12,19:21)],results5$Exonic_Rate[c(47:50)])
#10pg: p-value = 9.195e-06

#10pg与100pg carrier:
t.test(results5$Exonic_Rate[c(39:42)],results5$Exonic_Rate[c(51:54)])
#1ng: p-value = 0.2866
t.test(results5$Exonic_Rate[c(23:27,32:35)],results5$Exonic_Rate[c(43:46)])
#100pg: p-value = 0.0001173
t.test(results5$Exonic_Rate[c(28:31,36:38)],results5$Exonic_Rate[c(47:50)])
#10pg: p-value = 3.447e-07

p10 <- ggplot() +
  geom_bar(data=results5_1,aes(x=sample, y=exonic_rate, color=method),stat="identity", position="dodge", width=0.6, fill="white",linewidth=0.8) +
  geom_errorbar(data=results5_1, aes(x=sample, y=exonic_rate, ymin=exonic_rate-exon_s.d, ymax=exonic_rate+exon_s.d, color=method), linewidth=0.75, width=0.08,position=position_dodge(0.6)) +
  geom_beeswarm(data=results5, aes(x=sample, y=Exonic_Rate, color=method), alpha=0.7, cex=2, size=2.5,dodge.width = 0.6)+
  theme_classic()+
  scale_color_manual(values=brewer.pal(3, "Set2"))+
  geom_signif(
    data=results5,aes(x=sample, y=Mapping_Rate),
    xmin = c(0.75, 1.05, 0.75,1.75, 2.05, 1.75, 2.75, 3.05, 2.75),
    xmax = c(0.95, 1.25, 1.25, 1.95, 2.25,2.25,  2.95, 3.25, 3.25),
    annotations = c("***", "NS", "**","NS", "***","***" ,"NS","***","***"),
    y_position = c(0.93,0.93, 1.01, 0.8,0.85, 0.92, 0.35,0.75,0.82),
    textsize = 4)+
  labs(y="Eionic Rate")+
  theme(axis.title.x = element_blank())

plot_grid(p9,p10, labels=c("A", "B"), nrow=2)


#--------------------------------------------------------------------------------------
#gene body coverage 绘制
coverage2$percentile <- factor(coverage2$percentile,ordered=TRUE, levels = c(seq(1:100)))
coverage2$sample <- factor(coverage2$sample,ordered=TRUE, levels = c("1ug","100ng","10ng","1ng","100pg","10pg"))

ggplot(data=coverage2, aes(x=percentile, y=value, group=sample_number, color=sample))+
  geom_line(linewidth=0.75)+
  scale_color_manual(values=c("#4575b4","#67a9cf","#9ecae1","#d1e5f0","#fc8d59","#d73027"))+
  theme_classic()+
  theme(axis.text.x = element_blank(),
        axis.ticks.x = element_blank())+
  labs(x="Transcript position(5'→3')", y="Detection Ratio")


