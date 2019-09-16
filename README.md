# rQTL pipeline

rQTL pipeline was based on R/qtl libaray developed by Borman, and constructed by Jae-Yoon Kim.

This analysis piplinee uses a VCF file as input file and performs a single QTL analysis.


# Flow-chart of rQTL pipe

The flow-chart is as follows:

![RQTL1_new](https://user-images.githubusercontent.com/49300659/64958429-1cd18f80-d8ca-11e9-8543-1d853e79de3b.png)


# Basic Usage

Usage: run_qtl.R -g [VCF] -p [PHENO] -map [GMAP] -maf [MAF] -mms [MMISSING] -ims [IMISSING] -met [METHOD] -out [OUTPUT]

![RQTL2](https://user-images.githubusercontent.com/49300659/64957960-07a83100-d8c9-11e9-9c63-6812cfb4e140.jpg)


    Example: Rscript Intro.py -m Dstat \
    
                         -g ExampleData/Test_sample_429_geno.vcf.gz \   #VCF file
                         
                         -p ExampleData/Test_sample_429_pheno.txt \     #Phenotype file
                         
                         -map ExampleData/Test_Genetic_map.txt \        #Genetic map file
                         
                         -maf 0.05 \                                    #Minor allele frequency cut-off
                         
                         -mms 0.1  \                                    #Variant missing rate cut-off
                         
                         -ims 0.1  \                                    #Sample missing rate cut-off
                         
                         -met hk   \                                    #Calculation method (hk, em, imp)
                         
                         -out QTL_results                               #Output directory


# Requirement

Python program of > 3.0 version and R program of > 3.4.3 version are required.

Qtl and ggplot2 libraris of R are also requiered.


# Contact

jaeyoonkim72@gmail.com


# Reference

Broman, K. W., Wu, H., Sen, Ś., & Churchill, G. A. (2003). R/qtl: QTL mapping in experimental crosses. Bioinformatics, 19(7), 889-890.
