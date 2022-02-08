# Load files:

Normal1 <- read.delim("report1.tsv", header=FALSE)
Normal2 <- read.delim("report2.tsv", header=FALSE)
Normal3 <- read.delim("report3.tsv", header=FALSE)
Normal4 <- read.delim("report4.tsv", header=FALSE)
Normal5 <- read.delim("report5.tsv", header=FALSE)
Normal6 <- read.delim("report6.tsv", header=FALSE)
Tumor1 <- read.delim("report7.tsv", header=FALSE)
Tumor2 <- read.delim("report8.tsv", header=FALSE)
Tumor3 <- read.delim("report9.tsv", header=FALSE)
Tumor4 <- read.delim("report10.tsv", header=FALSE)
Tumor5 <- read.delim("report11.tsv", header=FALSE)
Tumor6 <- read.delim("report12.tsv", header=FALSE)

# V3 = Raw counts. #check actual V№
# V1 = ID.
# Create the table of counts:
join1 <- merge(Normal1[, c("V1","V3")], Normal2[, c("V1","V3")], by.x="V1", by.y="V1", all.x=TRUE,all.y=TRUE)
join1 <- merge(join1, Normal3[, c("V1","V3")], by.x="V1", by.y="V1", all.x=TRUE,all.y=TRUE)
join1 <- merge(join1, Normal4[, c("V1","V3")], by.x="V1", by.y="V1", all.x=TRUE,all.y=TRUE)
join1 <- merge(join1, Normal5[, c("V1","V3")], by.x="V1", by.y="V1", all.x=TRUE,all.y=TRUE)
join1 <- merge(join1, Normal6[, c("V1","V3")], by.x="V1", by.y="V1", all.x=TRUE,all.y=TRUE)
join1 <- merge(join1, Tumor1[, c("V1","V3")], by.x="V1", by.y="V1", all.x=TRUE,all.y=TRUE)
join1 <- merge(join1, Tumor2[, c("V1","V3")], by.x="V1", by.y="V1", all.x=TRUE,all.y=TRUE)
join1 <- merge(join1, Tumor3[, c("V1","V3")], by.x="V1", by.y="V1", all.x=TRUE,all.y=TRUE)
join1 <- merge(join1, Tumor4[, c("V1","V3")], by.x="V1", by.y="V1", all.x=TRUE,all.y=TRUE)
join1 <- merge(join1, Tumor5[, c("V1","V3")], by.x="V1", by.y="V1", all.x=TRUE,all.y=TRUE)
join1 <- merge(join1, Tumor6[, c("V1","V3")], by.x="V1", by.y="V1", all.x=TRUE,all.y=TRUE)
join1[is.na(join1)] <- 0

# Header:
col_headings <- c('ID','N1','N2','N3','N4','N5','N6','T1','T2','T3','T4','T5','T6')
names(join1) <- col_headings

# Create metadata table:
metatable <- matrix(c("N1","Normal","N2","Normal","N3","Normal","N4","Normal","N5","Normal","N6","Normal","T1","Tumour","T2","Tumour","T3","Tumour","T4","Tumour","T5","Tumour","T6","Tumour"),ncol=2,byrow=TRUE)
colnames(metatable) <- c("id","Status")
metatable

# DESeq analysis:
dds <- DESeqDataSetFromMatrix(countData=join1, 
                              colData=metatable, 
                              design=~Status, tidy = TRUE)
dds <- DESeq(dds)
res <- results(dds)
summary(res)
# Order by P-Value (padj is the adjusted value, but doesn't seem to be adjusting)
res <- res[order(res$pvalue),] 
head(res)

# Plots:
plotMA( res, ylim = c(-9, 9) )  # Same information as volcano plot (but I think volcano looks better)
plotDispEsts( dds, ylim = c(1e-6, 1e1) )
hist( res$pvalue, breaks=20, col="grey", main="Histogram of Adjusted P-Values", xlab = "P-Value" ) # P-value distribution

# PCA
vsdata <- vst(dds, blind=FALSE)
plotPCA(vsdata, intgroup="Status")

# Volcano plot
#reset par
par(mfrow=c(1,1))
# Make a basic volcano plot
with(res, plot(log2FoldChange, -log10(pvalue), pch=20, main="Volcano plot", xlim=c(-7,7)))

# Add colored points: blue if padj<0.01, red if log2FC>1 and padj<0.05)
with(subset(res, padj<.01 ), points(log2FoldChange, -log10(pvalue), pch=20, col="blue"))
with(subset(res, padj<.01 & abs(log2FoldChange)>2), points(log2FoldChange, -log10(pvalue), pch=20, col="red"))

# Save the results:
#write.csv( as.data.frame(res), file="FURDBresults.csv" )



