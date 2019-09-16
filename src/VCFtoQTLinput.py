import sys
import numpy as np
infile2 = sys.argv[2] #Genetic pos
infile3 = sys.argv[3] #Pheno
outpre = sys.argv[4]
infile = outpre + '/temp2.vcf'

#print(infile2)
gdic={}
if infile2 != "NULL":
    for line2 in map(lambda x:x.rstrip('\n').rstrip('\r').split('\t'), open(infile2)):
        gkey = (line2[0], line2[1])
        gdat = str(line2[2])
        gdic[gkey] = gdat


def GT_conv(l, REF, ALT):
    new_GT_line = []
    new_GT = ""    
    for gt in l:
        new_GT = ""
        if gt[0] == "0":
            new_GT = new_GT + REF
        elif gt[0] == "1":
            new_GT = new_GT + ALT
        else:
            new_GT = "-"
        if gt[-1] == "0":
            new_GT = new_GT + REF
        elif gt[-1] == "1":
            new_GT = new_GT + ALT
        else:
            new_GT = "-"
        new_GT_line.append(new_GT)
    return(new_GT_line)
     

pdic={}
for line3 in map(lambda x:x.rstrip('\n').rstrip('\r').split('\t'), open(infile3)):
    pdic[line3[0]] = str(line3[1])


tdata = []
for line in map(lambda x:x.rstrip('\n').rstrip('\r').split('\t'), open(infile)):
    if line[0].startswith('##'): continue
    if line[0].startswith('#'):
        sample_names = line[9:]
        pheno_data = []
        for ss in sample_names:
            try:
                pdat = pdic[ss]
            except KeyError:
                print("Wrong Phenotype file")
                sys.exit()
            else:
                pdat = pdic[ss]
            try:
                float(pdat)
            except ValueError:
                pdat = '-'
            else:
                pdat = pdat
            pheno_data.append(pdat)
        new_sample_name = ["Sample_ID", "", ""] + sample_names
        new_pheno_data = ["Phenotype", "", ""] + pheno_data
        tdata.append(new_pheno_data)
        tdata.append(new_sample_name)
#        print('\t'.join(new_sample_name))
#        print('\t'.join(new_pheno_data))
        continue
    Mid = line[0] + '_' + line[1] + '_' + line[2]
    CHR = line[0]
    Ppos = line[1]
    Gpos = str(round(float(Ppos)/1000000, 6))

    tkey = (CHR, Ppos)
    try:
        Gpos = gdic[tkey]
    except KeyError:
        Gpos = Gpos
    else:
        Gpos = gdic[tkey]
    
    REF = line[3]
    ALT = line[4]
    
    GT_line = line[9:]
    GT_coded = GT_conv(GT_line, REF, ALT)

    new_line = [Mid, CHR, Gpos] + GT_coded
    tdata.append(new_line)
#    print('\t'.join(new_line))
else:
    outfile_name = outpre + '/Rqtl_input.csv'
    outfile = open(outfile_name, 'w')
    tdata = np.array(tdata)
    ttdata = np.transpose(tdata)
    for nline in ttdata:
        print(','.join(nline), file=outfile)
    else:
        outfile.close()

