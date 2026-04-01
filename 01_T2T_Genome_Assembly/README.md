# T2T Genome Assembly – Kandelia obovata

## Overview
Complete telomere-to-telomere (T2T) genome assembly of mangrove species *Kandelia obovata* as part of the **10,000 Genomes Project**. This project demonstrates my expertise in handling large-scale genomic data and implementing complete assembly workflows.

## Pipeline Workflow


## Tools Used

| Step | Tool | Purpose |
|------|------|---------|
| Assembly | HiFiasm | Primary genome assembly from Hifi and ONT reads |
| Scaffolding | YAHS | Chromosome-scale scaffolding |
| Telomere detection | TeloClip | Identify telomeric regions |
| Polishing | Racon | Error correction (3 iterations) |
| Repeat masking | RepeatMasker | Identify and mask repetitive elements |
| Gene prediction | BRAKER3 | Predict gene models with RNA-seq evidence |
| Gene integration | TSEBRA | Combine multiple gene predictions |

## Key Results

| Metric | Value |
|--------|-------|
| Assembly size | 180.6 Mb |
| Number of chromosomes | 18 |
| N50 | 10 Mb |
| QV | 44.7% |
| BUSCO completeness | 99.3% |

## Scripts

All analysis scripts are available in the `scripts/` directory:

| Script | Description |
|--------|-------------|
| `01_hifiasm_assembly.sh` | Primary assembly with Hifiasm |
| `02_yahs_scaffolding.sh` | Scaffolding with YAHS |
| `03_teloclip_analysis.sh` | Telomere detection |
| `04_gap_filling.sh` | Gap closure |
| `05_racon_polishing.sh` | Polishing (3 rounds) |
| `06_repeatmasker_annotation.sh` | Repeat annotation |
| `07_braker3_gene_prediction.sh` | Gene prediction |
| `08_tsebra_integration.sh` | Integration of gene models |

## How to Run

```bash

# Run assembly (adjust paths as needed)
bash scripts/01_hifiasm_assembly.sh -i /path/to/reads.fastq -o results/ -t 32
