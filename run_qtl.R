#!/usr/bin/Rscript

## GWAS pipeline using GAPIT
## Created by Seongmun Jeong and Jae-Yoon Kim
## Contact : lovemun@kribb.re.kr

suppressPackageStartupMessages(library("argparse"))

parser <- ArgumentParser()
parser$add_argument("-g", "--geno", default = NULL, help = "input genotype vcf file")
parser$add_argument("-p", "--pheno", default = NULL, help = "input phenotype txt file")
parser$add_argument("-map", "--gmap", default = NULL, type="character", help = "input gentic map")
parser$add_argument("-maf", "--maf", default = 0.1, type = "double", help = "Minor allele frequency")
parser$add_argument("-mms", "--mmissing", default = 0.1, type = "double", help = "Variant missing rate cutoff")
parser$add_argument("-ims", "--imissing", default = 0.1, type = "double", help = "Sample missing rate cutoff")
parser$add_argument("-met", "--method", default = "hk", type = "character", help = "hk, em, or imp")
parser$add_argument("-out", "--output", default = "QTL_results", help = "output directory")

# Load input argument
args <- parser$parse_args()

vcffile <- args$geno
phenofile <- args$pheno
gmap <- args$gmap
maf <- args$maf
mmissing <- args$mmissing
imissing <- args$imissing
method <- args$method
prefix <- args$out

if (is.null(gmap)){gmap="NULL"}

if (file.exists(prefix)){
    tt=1
    outpath = prefix
} else {
    outpath = prefix
    dir.create(outpath)
}  


# Varaint MAF and Missing filtering
cat("MAF and Missing filtering", '\n')
cmd <- paste0("python src/MAF_MMiss_IMiss.py ", vcffile, " ", maf, " ", mmissing, " ", imissing, " ", outpath)
system(cmd)
cmd <- paste0("chmod 777 ", prefix, "*")
system(cmd)
cat("Complete",'\n')

# Convert VCF to RQTL input file
cat("Converting VCF file to RQTL input csv file", '\n')
cmd <- paste0("python src/VCFtoQTLinput.py temp2.vcf ", gmap, " ",  phenofile, " ", outpath)
system(cmd)
cmd <- paste0("chmod 777 ", prefix, "*")
system(cmd)
cat("Complete", '\n')

# Calculate QTL for single Phenotype
cat("Calculating QTL for single Phenotpye", '\n')
cmd <- paste0("chmod 777 ", prefix, "/Rqtl_input.csv")
system(cmd)
cmd <- paste0("Rscript src/RQTL.runing.V1.R ", outpath, "/Rqtl_input.csv 2 1 ", method)
system(cmd)
cmd <- paste0("chmod 777 ", prefix, "*")
system(cmd)
cmd <- paste0("mv -f ", prefix, "/Rqtl_input.csv ", prefix, "/temp_input.csv")
system(cmd)

cmd1 = paste0("rm -f ", prefix, "/temp1.vcf")
cmd2 = paste0("rm -f ", prefix, "/temp2.vcf")
cmd3 = paste0("rm -f ", prefix, "/temp_input.csv")
system(cmd1)
system(cmd2)
system(cmd3)

cat("All procedure is done", '\n')
