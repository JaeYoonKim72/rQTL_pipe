# 1. rQTL pipeline

rQTL pipeline was based on R/qtl libaray developed by Borman, and constructed by Jae-Yoon Kim.

This analysis pipeline uses a VCF file as input file and performs a single QTL analysis through HK, EM, and IMP methods.

Source code was written in Python and R languages and supported on windows and linux platforms.


# 2. Flow-chart of rQTL pipe

The flow-chart is as follows:

![그림2](https://user-images.githubusercontent.com/49300659/81289301-25691700-90a1-11ea-9058-e1d1e9579efd.jpg)


# 3. Usage

Usage: run_qtl.R -g [VCF] -p [PHENO] -map [GMAP] -maf [MAF] -mms [MMISSING] -ims [IMISSING] -met [METHOD] -out [OUTPUT]

![rqtl3](https://user-images.githubusercontent.com/49300659/64959102-6f5f7b80-d8cb-11e9-86ae-8310ebedc4bb.png)


    Example: Rscript run_qtl.R \
    
                         -g ExampleData/Test_sample_429_geno.vcf.gz \   # VCF file
                         
                         -p ExampleData/Test_sample_429_pheno.txt \     # Phenotype file
                         
                         -map ExampleData/Test_Genetic_map.txt \        # Genetic map file
                         
                         -maf 0.05 \                                    # Minor allele frequency cut-off
                         
                         -mms 0.1  \                                    # Variant missing rate cut-off
                         
                         -ims 0.1  \                                    # Sample missing rate cut-off
                         
                         -met hk   \                                    # Calculation method (hk, em, imp)
                         
                         -out QTL_results                               # Output directory


# 4. Results

Result files are provided with a total of 13 files including a result table and the following 3 images.

![qtl_resul4](https://user-images.githubusercontent.com/49300659/64959443-147a5400-d8cc-11e9-9c9b-c4dd3c3fa5e0.png)


# 5. Requirement

Python program of > 3.0 version and R program of > 3.4.3 version are required.

Qtl and ggplot2 libraris of R are also requiered.


# 6. Contact

jaeyoonkim72@gmail.com


# 7. Reference

Broman, K. W., Wu, H., Sen, Ś., & Churchill, G. A. (2003). R/qtl: QTL mapping in experimental crosses. Bioinformatics, 19(7), 889-890.
