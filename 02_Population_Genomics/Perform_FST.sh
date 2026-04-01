# Buat population files dulu
# Population 1: Quanzhou
echo -e "QZ-1\nQZ-2\nQZ-3\nQZ-4\nQZ-5\nQZ-7\nQZ-9\nQZ-13\nQZ-14\nQZ-21\nQZ-26\nQZ-29\nQZ-32" > quanzhou.txt

# Population 2: Fuding  
echo -e "FD-1\nFD-6\nFD-7\nFD-10\nFD-16\nFD-17\nFD-21\nFD-22\nFD-24" > fuding.txt

# Population 3: Longgang
echo -e "LG-1\nLG-3\nLG-4\nLG-6\nLG-8\nLG-9\nLG-11\nLG-12\nLG-13\nLG-16\nLG-17\nLG-20\nLG-21\nLG-23\nLG-24\nLG-25" > longgang.txt

# Population 4: Yueqing & Yunxiao
echo -e "YQ-2\nYQ-7\nYX-12" > yueqing_yunxiao.txt

# Hitung FST per site dan window-based
vcftools --gzvcf merged.maffiltered.snps.vcf.gz \
         --weir-fst-pop quanzhou.txt \
         --weir-fst-pop fuding.txt \
         --out fst_quanzhou_vs_fuding

vcftools --gzvcf merged.maffiltered.snps.vcf.gz \
         --weir-fst-pop quanzhou.txt \
         --weir-fst-pop longgang.txt \
         --out fst_quanzhou_vs_longgang

# FST genome-wide average
vcftools --gzvcf merged.maffiltered.snps.vcf.gz \
         --weir-fst-pop quanzhou.txt \
         --weir-fst-pop fuding.txt \
         --weir-fst-pop longgang.txt \
         --weir-fst-pop yueqing.txt \
         --weir-fst-pop yunxiao.txt \
         --out fst_all_populations

vcftools --gzvcf merged.renamed.vcf.gz \
         --weir-fst-pop quanzhou.txt \
         --weir-fst-pop fuding.txt \
         --weir-fst-pop longgang.txt \
         --out fst_all_populations


#FST window-based
vcftools --gzvcf input.vcf 
         --weir-fst-pop pop1.txt 
         --weir-fst-pop pop2.txt 
         --fst-window-size 10000 
         --fst-window-step 10000

vcftools --gzvcf input.vcf 
         --weir-fst-pop pop1.txt \
         --weir-fst-pop pop2.txt \
         --fst-window-size 50000 --fst-window-step 10000 \
         --out fst_window


#KALAU PAKE PLINK
# Buat file phenotype dengan population assignment
# samples.txt format: FID IID Phenotype
cat > samples_population.txt << EOF
QZ-1 QZ-1 1
QZ-2 QZ-2 1
FD-1 FD-1 2
FD-6 FD-6 2
LG-1 LG-1 3
YQ-2 YQ-2 4
YX-12 YX-12 4
EOF

# Hitung FST dengan PLINK
plink --vcf merged.maffiltered.snps.vcf.gz \
      --allow-extra-chr \
      --within samples_population.txt \
      --fst \
      --out plink_fst
