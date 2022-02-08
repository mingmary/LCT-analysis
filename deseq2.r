https://www.bioconductor.org/packages/devel/bioc/vignettes/DESeq2/inst/doc/DESeq2.html
#metadata contains data about Sampletype for each sample

library(DESeq2)
library(ggplot2)

dds <- DESeqDataSetFromMatrix(countData=countmatrix, 
                              colData=metadata, 
                              design=~Sampletype)
dds <- DESeq(dds)
res <- results(dds)
summary(res)
res <- res[order(res$pvalue),] 
head(res)


plotCounts(dds, gene=which.min(res$padj), intgroup="Sampletype")

#and graphical variations
d <- plotCounts(dds, gene="genename", intgroup="Sampletype", 
                returnData=TRUE)
ggplot(d, aes(x=Sampletype, y=count)) + 
  geom_point(position=position_jitter(w=0.1,h=0)) + 
  scale_y_log10(breaks=c(25,100,400))

