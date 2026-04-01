# I tried three aproaches to do HiFiasm utilizing HiFi reads, ONT reads and also HiC.
# I also tried to performing HiFiasm for each reads separately

#1. Assembling ONT reads
hifiasm -t64 --ont -o ONT.asm ONT.read.fastq.gz

#2. Hi-C integration
hifiasm -o NA12878.asm -t32 --h1 read1.fq.gz --h2 read2.fq.gz HiFi-reads.fq.gz

#3. Trio binning
hifiasm -t 2 -o hifiasm   --h1 hic_R1.fq.gz --h2 hic_R2.fq.gz   --ul ont_ul.fq.gz   hifi.fq.gz
