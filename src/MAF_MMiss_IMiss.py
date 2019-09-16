import sys, collections

infile = sys.argv[1]
maf = float(sys.argv[2])
miss = float(sys.argv[3])
imiss = float(sys.argv[4])
outpre = sys.argv[5].rstrip('/')
#print(outpre)
outfile_name = outpre+"/temp1.vcf"
#print(outfile_name)
outfile = open(outfile_name, 'w')

def check_phase(s):
    if s[1] == "|":
        return("|")
    else:
        return("/")
       
def calc_maf(l):
    phasing_check = check_phase(l[0])
    Ref_count = 0
    Alt_count = 0
    Mis_count = 0
    Tot_count = len(l)
    for gtf in l:
        gt = gtf.split(':')[0].split(phasing_check)
        for allele in gt:
            if allele == "0":
                Ref_count = Ref_count + 1
            elif allele == "1":
                Alt_count = Alt_count + 1
            else:
                Mis_count = Mis_count + 1
    Ref_freq = float(Ref_count)/Tot_count
    Alt_freq = float(Alt_count)/Tot_count
    Mis_freq = float(Mis_count)/Tot_count
    Min_freq = min([Ref_freq, Alt_freq])
    return(Min_freq, Mis_freq)

out_vari = []
for line in map(lambda x:x.rstrip('\n').rstrip('\r').split('\t'), open(infile)):
    if line[0].startswith('#'):
        print('\t'.join(line), file=outfile)
        continue
    GT_line = line[9:]
    Maf_mis = calc_maf(GT_line)
    line_maf = Maf_mis[0]
    line_mis = Maf_mis[1]
    if float(line_maf) <= float(maf) : 
        out1 = line[:3] + [str(line_maf), str(line_mis)]
        out_vari.append(out1)
        continue
    if float(line_mis) > float(miss) :
        out2 = line[:3] + [str(line_maf), str(line_mis)]
        out_vari.append(out2)
        continue
    print('\t'.join(line), file=outfile)
else:
    outfile.close()

outfile_name4 = outpre + "/Filtered_varinats.txt"
outfile4 = open(outfile_name4, 'w')
header = ["CHR", "POS", "ID", "MAF", "Marker_Missing_Rate"]
print('\t'.join(header), file=outfile4)
for y in out_vari:
    print('\t'.join(y), file=outfile4)
else:
    outfile4.close()

def calc_imiss(l):
    phasing_check = check_phase(l[0])
    Miss_genotype = "." + phasing_check + "."
    tlen = len(l)
    mlen = l.count(Miss_genotype) 
    imisss = float(mlen)/tlen
    return(imisss)

infosamples = []
samples = []
dic = collections.OrderedDict()
for line in map(lambda x:x.rstrip('\n').rstrip('\r').split('\t'), open(outpre + "/temp1.vcf")):
    if line[0].startswith('##'):
        continue
    if line[0].startswith('#'):
        infosamples = line
        samples = line[9:]
        continue
    GT_line = line[9:]
    for s, g in zip(samples, GT_line):
        dic.setdefault(s, []).append(g)

out_sample = []
in_sample = []
for sss in samples:
    sss_imiss = float(calc_imiss(dic[sss]))
    if sss_imiss <= float(imiss):
        in_sample.append(sss)
    else: 
        out_sample.append([sss, str(sss_imiss)])


in_sample_idx = []
for ssx in in_sample:
    ssxidx = infosamples.index(ssx)
    in_sample_idx.append(ssxidx) 

outfile_name2 = outpre + "/temp2.vcf"
outfile2 = open(outfile_name2, 'w')
for line in map(lambda x:x.rstrip('\n').rstrip('\r').split('\t'), open(outpre + "/temp1.vcf")):
    if line[0].startswith('##'):
        print('\t'.join(line), file=outfile2)
        continue
    if line[0].startswith('#'):
        info=line[:9]
        tsample = []
        for idx in in_sample_idx:
            tsam = line[idx]
            tsample.append(tsam)
        new_head = info + tsample
        print('\t'.join(new_head), file=outfile2)
        continue
    info=line[:9]
    tgenotype = []
    for idx in in_sample_idx:
        tgeno = line[idx]
        tgenotype.append(tgeno)
    new_line = info+tgenotype
    print('\t'.join(new_line), file=outfile2)
else:
    outfile2.close()

outfile_name3 = outpre + "/Filtered_samples.txt"
outfile3 = open(outfile_name3, 'w')
header3 = ["Sample", "Call_Rate"]
print('\t'.join(header3), file=outfile3)
for x in out_sample:
    print('\t'.join(x), file=outfile3)
else:
    outfile3.close()








