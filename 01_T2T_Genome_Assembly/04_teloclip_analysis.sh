# Read alignments from bam file, pipe sam lines to teloclip, sort overhang-read alignments and write to bam file
# My first version of fasta assembly is missing 5 telomeres
# After identify each locations of the exist telomeres, I performed TeloClip v0.3.4

samtools view -h in.bam | teloclip filter --ref-idx extended_genome.fasta.fai | /share/app/samtools/1.11/bin/samtools sort > overhangs.bam
samtools index telomeric_overhangs.bam

# Check the results of overhangs.bam in which scaffold
samtools view overhangs.bam | cut -f3 | sort | uniq -c

teloclip extend overhangs.bam extended_genome.fasta \
  --output-fasta scaffold17_extended.fasta \
  --stats-report scaffold17_report.txt \
  --count-motifs TTTAGGG \
  --min-overhangs 1 \
  --screen-terminal-bases 2000

#If you want to do Dry Run
teloclip extend overhangs.bam extended_genome.fasta \
  --output-fasta scaffold17_extended.fasta \
  --stats-report scaffold17_report.txt \
  --count-motifs TTTAGGG \
  --min-overhangs 1 \
  --screen-terminal-bases 2000
  --dry-run

#Script created by Ivana
#2026/01/10
