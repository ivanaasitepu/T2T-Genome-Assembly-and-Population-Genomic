#!/bin/bash

# Configuration
ASSEMBLY="/data/work/GapFilling/reorder/obovata.v4_1.fa"
ONT_READS="/data/work/GapFilling/reorder/ont_raw.fq.gz"
HIFI_READS="/data/work/GapFilling/reorder/hifi_raw.fq.gz"
ONT_PAF="/data/work/GapFilling/reorder/v4_vs_ont.paf"
THREADS=32
RACON="/home/stereonote/racon/build/bin/racon"

echo "=== START POLISHING ==="
echo "Assembly: $ASSEMBLY"
echo "Threads: $THREADS"

# 1. ONT Polishing - Iteration 1
echo "=== 1. ONT Polishing - Iteration 1 ==="
$RACON -t $THREADS $ONT_READS $ONT_PAF $ASSEMBLY > polished_ont1.fasta

# 2. Create a new mapping for ONT iteration 2
echo "=== 2. Create a new mapping for ONT iteration 2 ==="
/share/app/minimap2/2.17/minimap2 -t $THREADS -x map-ont polished_ont1.fasta $ONT_READS > ont_iter2.paf

# 3. ONT Polishing - Iteration 2
echo "=== 3. ONT Polishing - Iteration 2 ==="
$RACON -t $THREADS $ONT_READS ont_iter2.paf polished_ont1.fasta > polished_ont2.fasta

# 4. HiFi Polishing - Iteration 1
echo "=== 4. HiFi Polishing - Iterasi 1 ==="
/share/app/minimap2/2.17/minimap2 -t $THREADS -x map-pb polished_ont2.fasta $HIFI_READS > hifi_iter1.paf
$RACON -t $THREADS $HIFI_READS hifi_iter1.paf polished_ont2.fasta > polished_hifi1.fasta

# 5. HiFi Polishing - Iteration 2
echo "=== 5. HiFi Polishing - Iterasi 2 ==="
/share/app/minimap2/2.17/minimap2 -t $THREADS -x map-pb polished_hifi1.fasta $HIFI_READS > hifi_iter2.paf
$RACON -t $THREADS $HIFI_READS hifi_iter2.paf polished_hifi1.fasta > final_polished.fasta

echo "=== FINISH POLISHING  ==="
echo "Final Result: final_polished.fasta"

# 6. Count statistics
echo ""
echo "=== STATISTIK ASSEMBLY ==="
echo "Original assembly:"
grep -c "^>" $ASSEMBLY
echo "Final polished assembly:"
grep -c "^>" final_polished.fasta

# Count length total
echo ""
echo "Total length original:"
awk '/^>/ {if (seqlen) print seqlen; seqlen=0; next} {seqlen+=length($0)} END {print seqlen}' $ASSEMBLY

echo "Total length polished:"
awk '/^>/ {if (seqlen) print seqlen; seqlen=0; next} {seqlen+=length($0)} END {print seqlen}' final_polished.fasta

