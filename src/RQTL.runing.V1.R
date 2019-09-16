#J.-Y.K.
#install.packages("qtl",repos='http://cran.us.r-project.org')
library(qtl)
library(ggplot2)

suppressPackageStartupMessages(library("argparse"))

parser = ArgumentParser()
parser$add_argument("file1.csv", nargs=1, help="CSV file")
parser$add_argument("NPheno", nargs=1, help ="The numver of Phenotypes ex(1, 2, ...)")
parser$add_argument("WPheno", nargs=1, help ="The number of the Phenotype you want to calculate ex(1, 2, ...)")
parser$add_argument("Meth", nargs=1, help ="Methods ex(hk, em, imp)")

args = parser$parse_args()
file1 = args$file1.csv
nphe = args$NPheno
wphe = args$WPheno
meth = args$Meth

############################################################
# Data import
############################################################
print("loading file")

GTS = as.integer(nphe)
GTS2 = GTS + 1
data = read.csv(file1)
PT_names = colnames(data)[1:GTS]
GT = data[3:nrow(data),GTS2:ncol(data)]

GT_list = c()
AL_list = c()
for (i in 1:ncol(GT)){
  GT_list = c(GT_list, as.character(unique(GT[,i])))
  GT_list= unique(GT_list)
}
GT_list = setdiff(GT_list, "-")

for (i in GT_list){
  Fir = substr(i, 1, 1)
  Sec = substr(i, 2, 2)
  AL_list = c(AL_list, Fir)
  AL_list = c(AL_list, Sec)
  AL_list = unique(AL_list)
}

#print ("GT_list: ")
#print (GT_list)
#print ("AL_list: ")
#print (AL_list)
#print ("PT_names")
#print (PT_names)

sug = read.cross(format="csv", file=file1, genotypes=GT_list, alleles=AL_list)

############################################################
# Summaries
############################################################
#print ("Data summaries")

summary(sug)

outfile_bk = strsplit(file1, '.csv')[[1]]
outfile_n1 = paste(outfile_bk, ".initial_summary.pdf", sep="")

#pdf(file=outfile_n1)
#print(sug)
#dev.off()

outfile_n111 = paste(outfile_bk, ".initial_summary.Missing_Genotpye.pdf", sep="")
pdf(file=outfile_n111)
plotMissing(sug)
dev.off()

outfile_n112 = paste(outfile_bk, ".initial_summary.Genetic_Map.pdf", sep="")
pdf(file=outfile_n112)
plotMap(sug)
dev.off()

print ("Reading Phenotypes")
for ( i in PT_names){
    outfile_n113 = paste(paste(paste(outfile_bk, ".initial_summary.Phenotype.", sep=""), i, sep=""), ".pdf", sep="")
    pdf(file=outfile_n113)
    plotPheno(sug, pheno.col=i)
    dev.off()
}

#print("Done")
############################################################
# Single-QTL analysis
############################################################
pp=paste0("Single-QTL analysis: ", meth)
print(pp)

WP = as.integer(wphe)
WP_name = PT_names[WP]

#print ("Calculated Phenotype")
#print (WP_name)

if (meth == "em") {
    sug = calc.genoprob(sug, step=1)
    out.em = scanone(sug, pheno.col=1)
    summary(out.em)
    summary(out.em, threshold=3)
    outfile_n2 = paste(paste(outfile_bk, WP_name, sep="."), ".Single_QTL.EM_method.pdf", sep="")
    pdf(outfile_n2)
    plot(out.em)
    dev.off()
}
if (meth == "hk"){
    out.hk = scanone(sug, method="hk")
    outfile_n3 = paste(paste(outfile_bk,  WP_name, sep="."),".Single_QTL.HK_method.pdf", sep="")
    pdf(outfile_n3)
    plot(out.hk, col="red")
    dev.off()
#    outfile_n4 = paste(paste(outfile_bk,  WP_name, sep="."), ".HK-EM.pdf", sep="")
#    pdf(outfile_n4)
#    plot(out.hk - out.em, ylim=c(-0.3, 0.3), ylab="LOD(HK)-LOD(EM)")
#    dev.off()
}
if (meth == "imp"){
    sug = sim.geno(sug, step=1, n.draws=64)
    out.imp = scanone(sug, method="imp")
    outfile_n5 = paste(paste(outfile_bk,  WP_name, sep="."),".Single_QTL.IMP_method.pdf", sep="") 
    pdf(outfile_n5)
    plot(out.imp, col="green")
    dev.off()
}

#outfile_n6 = paste(paste(outfile_bk,  WP_name, sep="."), ".Single_QTL.EM_HK_IMP_merhod.pdf", sep="")
#pdf(outfile_n6)
#plot(out.em, out.hk, out.imp, col=c("blue", "red", "green"))
#dev.off()

#outfile_n7 = paste(paste(outfile_bk, WP_name, sep="."), ".Single_QTL.IMP-EM_HK-EM.pdf", sep="")
#pdf(outfile_n7)
#plot(out.imp - out.em, out.hk - out.em, col=c("green", "red"), ylim=c(-1,1))
#dev.off()

############################################################
# Single-QTL summary
############################################################
print("Single-QTL summary for the phenotype")
#print (meth)

out.all = scanone(sug, pheno.col=1, method=meth)

outfile_n8=paste(paste(outfile_bk, meth, sep="."), ".Single-QTL.summary.for_all_markers.txt", sep='')
a=data.frame(out.all)
aa=data.frame("Marker"=row.names(a), a)
write.table(aa, outfile_n8, quote=F, sep="\t", col.names=T, row.names=F)

outfile_n9=paste(paste(outfile_bk, meth, sep="."), ".Single-QTL.summary.for_all_peaks.txt", sep='')
a = summary(out.all, threshold=3, format="allpeaks")
write.table(a, outfile_n9, quote=F, sep="\t", row.names=F)

outfile_n10=paste(paste(outfile_bk, meth, sep="."), ".Single-QTL.summary.for_all_pheno.txt", sep='')
a = summary(out.all, threshold=3, format="allpheno")
write.table(a, outfile_n10, quote=F, sep="\t", row.names=F)

outfile_n11=paste(paste(outfile_bk, meth, sep="."),".Single-QTL.summary.for_tabByCol.txt", sep='')
sink(outfile_n11)
a = summary(out.all, threshold=3, format="tabByCol")
#print(a)
sink()

outfile_n12=paste(paste(outfile_bk, meth, sep="."),".Single-QTL.summary.for_tabByChr.txt", sep='')
sink(outfile_n12)
a = summary(out.all, threshold=3, format="tabByChr")
#print(a)
sink()

print ("Done")

############################################################
# Single-QTL Permutation tests
############################################################
print ("Single-QTL Permutation tests")
#print (meth)
print ("the number of permutation : 100")

operm = scanone(sug, method=meth, n.perm=100)

outfile_n15 = paste(paste(paste(outfile_bk, WP_name, sep="."), meth, sep="."), ".Single-QTL-Permu.pdf", sep="")
pdf(outfile_n15)
plot(operm)
dev.off()

outfile_n16 = paste(paste(paste(outfile_bk, WP_name, sep="."), meth, sep="."), ".Single-QTL-Permu.txt", sep="")
a = summary(operm, alpha=c(0.01, 0.05, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1))
aa = data.frame("Alpha" = rownames(a), LOD = a[,1])
write.table(aa, outfile_n16, quote=F, sep="\t", row.names=F)

variable1 = paste("out.", meth, sep="")
outfile_n17 = paste(paste(paste(outfile_bk, WP_name, sep="."), meth, sep="."), ".Single-QTL-Permu.Pvalue.txt", sep="")
a = summary(eval(parse(text= variable1)), perms=operm, alpha=0.2, pvalues=TRUE)
if (length(a$pos) == 0){
    write.table("NO LOD PEAKS", outfile_n17, quote=F, sep="\t", row.names=F)
} else {
    aa = data.frame("Marker" = rownames(a), "CHR" = a[,1], "POS" = a[,2], "LOD" = a[,3], "P-val" = a[,4])
    write.table(aa, outfile_n17, quote=F, sep="\t", row.names=F)
}

print ("Done")
#############################################################
