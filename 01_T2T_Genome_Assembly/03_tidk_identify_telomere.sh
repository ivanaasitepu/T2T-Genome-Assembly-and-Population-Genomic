conda activate /opt/software/tidk_env
tidk explore --length 0 --minimum 4 --maximum 10 obovata.v1.fasta -t 5
tidk search --string "AAACCCT" --output tidk.ov2 --dir obovata.v1.fasta
tidk find -d ./ -f  *.fna   -o 1  --clade Eudicots
tidk plot --tsv tidk.ov2_telomeric_repeat_windows.tsv   --output obovata_telomere_plot   --height 120   --width 800

#Script by Ivana Sitepu
#2025/12/30
