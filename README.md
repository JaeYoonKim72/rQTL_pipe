# rQTL pipe

rQTL pipeline was based on R/qtl libaray developed by Borman, and constructed by Jae-Yoon Kim.

This analysis piplinee uses a VCF file as input file and performs a single QTL analysis.


# Flow-chart of rQTL pipe

The flow-chart is as follows:

![RQTL1](https://user-images.githubusercontent.com/49300659/64957921-f3643400-d8c8-11e9-8439-817b6d9f4d22.png)


# Basic Usage

Usage: run_qtl.R -g [VCF] -p [PHENO] -map [GMAP] -maf [MAF] -mms [MMISSING] -ims [IMISSING] -met [METHOD] -out [OUTPUT]

![RQTL2](https://user-images.githubusercontent.com/49300659/64957960-07a83100-d8c9-11e9-9c63-6812cfb4e140.jpg)


    Example: python Intro.py -m Dstat \
    
                         --input ExampleData/TestSet_234.chr10.vcf.gz \
                         
                         --info ExampleData/TestSet_234.sample_group_info.txt \
                         
                         --popO Wild_Mix_GroupA \
                         
                         --popT Cultivar_B \
                         
                         --pop1 Cultivar_A \
                         
                         --pop2 Cultivar_OutGroup \
                         
                         --chr 10 \
                         
                         --window 50000 \
                         
                         --slide 25000


# Requirement

Python program of > 3.0 version and R program of > 3.4.3 version are required.

Qtl and ggplot2 libraris of R are also requiered.


# Contact

jaeyoonkim72@gmail.com


# Reference

Broman, K. W., Wu, H., Sen, Ś., & Churchill, G. A. (2003). R/qtl: QTL mapping in experimental crosses. Bioinformatics, 19(7), 889-890.
