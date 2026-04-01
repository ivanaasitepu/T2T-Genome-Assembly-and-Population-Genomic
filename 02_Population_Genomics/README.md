This study employs population genomics to investigate population structure and local adaptation mechanisms in K. obovata.

The stage of mapping and calling variants ensures verified quality by mapping clean reads to the reference genome and detecting genetic variations, particularly single-nucleotide polymorphisms (SNPs) and insertions/deletions (InDels). The mapping is performed using MegaBOLT (https://mgi-tech.eu/bitplatforms-&-analysis/MegaBOLT), which is integrated into the ZBOLT platform. ZBOLT incorporates the MegaBOLT pipeline and is optimized for population-based whole-genome sequencing (WGS) analysis. This includes calling both germline and somatic mutations, whole exome sequencing (WES), and targeted region sequencing.

All GVCF files from each sample are merged using DPGT (v1.4.2) into a multi-sample VCF file. Following this, variants are filtered based on the criteria in line with best practices from the Genome Analysis Toolkit (GATK).
