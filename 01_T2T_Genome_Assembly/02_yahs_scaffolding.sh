#This script is used under YaHS Image (image creator wanghetong) in DCS Cloud
$ bwa index Kandelia_hifiasm.hic.p_ctg.fasta
$ bwa mem -5SP Kandelia_hifiasm.hic.p_ctg.fasta /data/work/Input/Output/HiC_R1.fq.gz /data/work/Input/Output/HiC_R2.fq.gz \
 | samtools view -bS - \
 | samtools sort -o hic.contigs.bam -

$ samtools faidx Kandelia_hifiasm.hic.p_ctg.fasta

#Running YaHS
$ conda activate yahs
$ yahs Kandelia_hifiasm.hic.p_ctg.fasta Kandeliaobovata.filtered.bam 

#After Doing YaHS you want to generate "out.hic" file and "out_JBAT.hic" file
#(==========CORRECT PART TO GENERATE .hic===========)#
$ export _JAVA_OPTIONS="-Xmx50g"
$ (juicer pre yahs.out.bin yahs.out_scaffolds_final.agp /data/work/Input/pctg/06.haphic/04.build/Kandelia_hifiasm.hic.p_ctg.fasta.fai | sort -k2,2d -k6,6d -T ./ --parallel=8 -S32G | awk 'NF' > alignments_sorted.txt.part) && (mv alignments_sorted.txt.part alignments_sorted.txt)
$ cut -f1,2 yahs.out_scaffolds_final.fa.fai > scaffolds_final.chrom.sizes
$ (juicer_tools pre alignments_sorted.txt out.hic.part scaffolds_final.chrom.sizes) && (mv out.hic.part out.hic)
$ juicer pre -a -o out_JBAT yahs.out.bin yahs.out_scaffolds_final.agp /data/work/Input/pctg/06.haphic/04.build/Kandelia_hifiasm.hic.p_ctg.fasta.fai >out_JBAT.log 2>&1
$ (juicer_tools pre out_JBAT.txt out_JBAT.hic.part <(cat out_JBAT.log  | grep PRE_C_SIZE | awk '{print $2" "$3}')) && (mv out_JBAT.hic.part out_JBAT.hic)

#After you got "out_JBAT.hic", you will do manual curation in Juicebox software
#After finish editing in Juicebox, you save it and got "out_JBAT.review.assembly" file

#Generate fasta after manual curation in Juicebox
#"out_JBAT.liftover.agp" file is generated from YaHS (you use that)
#"contigs.fa" file is your "HiFiasm" fasta file
$ juicer post -o out_JBAT out_JBAT.review.assembly out_JBAT.liftover.agp contigs.fa

# After that perform using HapHiC image to plot visualization
# Change to haphic image (image by WangHetong)
# Generate the final FASTA file for the scaffolds
$ /opt/software/HapHiC/utils/juicer post -o out_JBAT out_JBAT.review.assembly out_JBAT.liftover.agp asm.fa #asm.fa is HiFiasm fasta assembly (It's also the same as contigs.fa, the reason I made a different name is that I'm just following from GitHub)
$ /opt/software/HapHiC/haphic plot out_JBAT.FINAL.agp Kandeliaobovata.filtered.bam

#if you want to specify which scaffold to visualize
#First check, what is your chromosome name in your "out_JBAT_new.FINAl.agp" file
$ /opt/software/HapHiC/haphic plot out_JBAT_new.FINAL.agp kandelia.filtered.bam --specified_scaffolds scaffold_1,scaffold_18 #if only 2 scaffolds
$ /opt/software/HapHiC/haphic plot out_JBAT_new.FINAL.agp kandelia.filtered.bam --specified_scaffolds scaffold_1,scaffold_2,scaffold_3,scaffold_4,scaffold_5,scaffold_6,scaffold_7,scaffold_8,scaffold_9,scaffold_10,scaffold_11,scaffold_12,scaffold_13,scaffold_14,scaffold_15,scaffold_16,scaffold_17,scaffold_18

#script created by Ivana
#2025/12/23
