library(dplyr)
library(ggplot2)
library(scales)

# Read the renamed file
data <- read.table("41samples.merged.maffiltered.snp.100k.windowed.pi.renamed", 
                   header = TRUE, sep = "\t", stringsAsFactors = FALSE)

# Define the correct chromosome order
correct_chr_order <- c("chr1", "chr2", "chr3", "chr4", "chr5", "chr6", "chr7", "chr8", "chr9",
                       "chr10", "chr11", "chr12", "chr13", "chr14", "chr15", "chr16", "chr17", "chr18")

# Convert CHROM to factor with correct order
data$CHROM <- factor(data$CHROM, levels = correct_chr_order)

# Remove any NA values that might result from incorrect chromosome names
data <- data %>% filter(!is.na(CHROM))

# Calculate chromosome sizes and cumulative positions
chrom_sizes <- data %>%
  group_by(CHROM) %>%
  summarise(ChrLength = max(BIN_END)) %>%
  arrange(CHROM)  # Now this will use the factor order

# Create cumulative offsets
chrom_sizes$Offset <- c(0, cumsum(chrom_sizes$ChrLength)[-nrow(chrom_sizes)])

# Merge with original data
data <- data %>%
  left_join(chrom_sizes, by = "CHROM") %>%
  mutate(
    GlobalStart = BIN_START + Offset,
    GlobalEnd = BIN_END + Offset,
    GlobalMid = (GlobalStart + GlobalEnd) / 2
  )

# Calculate chromosome center positions for x-axis labels
chrom_centers <- chrom_sizes %>%
  mutate(Center = (Offset + ChrLength / 2))

# Create x-axis breaks and labels (now in correct order)
x_breaks <- chrom_centers$Center
x_labels <- as.character(chrom_centers$CHROM)

# Create summary statistics
pi_summary <- paste(
  "Genome-wide π: Mean =", round(mean(data$PI, na.rm = TRUE), 6),
  "Min =", round(min(data$PI, na.rm = TRUE), 6),
  "Max =", round(max(data$PI, na.rm = TRUE), 6)
)

# Create the plot
p <- ggplot(data, aes(x = GlobalMid, y = PI)) +
  geom_line(linewidth = 0.6, alpha = 0.8, color = "#2c3e50") +  # pilih warna, misal biru tua
  geom_point(size = 0.8, alpha = 0.6, color = "#2c3e50") + 
  
  # Y-axis settings
  scale_y_continuous(
    name = "Nucleotide Diversity (π)",
    limits = c(0, max(data$PI) * 1.1)
  ) +
  
  # X-axis settings with chromosome labels in correct order
  scale_x_continuous(
    name = "Chromosome",
    breaks = x_breaks,
    labels = x_labels,
    expand = c(0.01, 0.01)
  ) +
  
  # Color settings - use the same factor levels for consistent coloring
  scale_color_discrete(name = "Chromosome") +
  
  # Add chromosome boundaries
  geom_vline(
    xintercept = c(0, chrom_sizes$Offset[-1]),
    color = "gray50", linetype = "dashed", linewidth = 0.3, alpha = 0.7
  ) +
  
  # Labels and theme
  labs(
    title = "Genome-wide Nucleotide Diversity (π)",
    subtitle = "100 kb sliding windows",
    caption = pi_summary
  ) +
  
  theme_bw() +
  theme(
    panel.grid.major.y = element_line(linetype = "dashed", color = "gray80"),
    panel.grid.minor.y = element_blank(),
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank(),
    panel.border = element_blank(),
    axis.line = element_line(linewidth = 0.5),
    axis.text = element_text(size = 10),
    axis.text.x = element_text(angle = 0, hjust = 0.5, vjust = 1),
    axis.title = element_text(size = 12),
    plot.title = element_text(size = 14, hjust = 0.5, face = "bold"),
    plot.subtitle = element_text(size = 11, hjust = 0.5),
    plot.caption = element_text(size = 9, hjust = 1, margin = margin(t = 10)),
    legend.position = "none",
    plot.margin = margin(1, 1, 1, 1, "cm")
  )

# Save the plot
ggsave(
  filename = "genome_wide_pi_simple_chrom_names_ordered.pdf",
  plot = p,
  width = 14,
  height = 6,
  dpi = 300
)

ggsave(
  filename = "genome_wide_pi_simple_chrom_names_ordered.png",
  plot = p,
  width = 14,
  height = 6,
  dpi = 300
)

# Print summary
cat("\n=== Genome-wide π Summary ===\n")
cat("Total windows:", nrow(data), "\n")
cat("Mean π:", round(mean(data$PI, na.rm = TRUE), 6), "\n")
cat("Min π:", round(min(data$PI, na.rm = TRUE), 6), "\n")
cat("Max π:", round(max(data$PI, na.rm = TRUE), 6), "\n")

# Chromosome-specific summary (now in correct order)
cat("\n=== Chromosome-specific π ===\n")
chr_summary <- data %>%
  group_by(CHROM) %>%
  summarise(
    Mean_PI = round(mean(PI, na.rm = TRUE), 6),
    Min_PI = round(min(PI, na.rm = TRUE), 6),
    Max_PI = round(max(PI, na.rm = TRUE), 6),
    Windows = n()
  ) %>%
  arrange(CHROM)  # This will use the factor order

print(chr_summary, n = 18)
