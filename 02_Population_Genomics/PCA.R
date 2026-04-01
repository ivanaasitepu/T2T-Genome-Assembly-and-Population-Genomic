library(ggplot2)
library(openxlsx)
library(ggrepel)
library(dplyr)
library(GGally)

#1. Read data from excel
pca_data = read.xlsx("pca_eigenvec.xlsx")

#2. Read eigenval to variance explained
eigenval = read.table("pca_results.eigenval", header = FALSE)
variance_explained = round(eigenval$V1 / sum(eigenval$V1) * 100, 2)

#3. Plot PC
p1 = ggplot(pca_data, aes(x = PC1, y = PC2, color = species)) +
  geom_point(size = 4, alpha = 0.8) +
  geom_text_repel(aes(label = id), size = 3, max.overlaps = 20) +
  labs(x = paste0("PC1 (", variance_explained[1], "%)"),
       y = paste0("PC2 (", variance_explained[2], "%)"),
       title = "PCA Plot",
       color = "species") +
  theme_classic() +
  theme(legend.position = "bottom",
        plot.title = element_text(hjust = 0.5, size = 11, face = "bold"))

p2 = ggplot(pca_data, aes(x = PC1, y = PC3, color = species)) +
  geom_point(size = 4, alpha = 0.8) +
  geom_text_repel(aes(label = id), size = 3, max.overlaps = 20) +
  labs(x = paste0("PC1 (", variance_explained[1], "%)"),
       y = paste0("PC2 (", variance_explained[3], "%)"),
       title = "PCA Plot (by species)",
       color = "species") +
  theme_classic() +
  theme(legend.position = "bottom",
        plot.title = element_text(hjust = 0.5, size = 11, face = "bold"))

# 5. Save plots
ggsave("pca_plot_pc1_pc2.png", p1, width = 8, height = 8, dpi = 300)
ggsave("pca_plot_pc1_pc3.png", p2, width = 8, height = 8, dpi = 300)


#Include other PCs
pca_subset = ggpairs(pca_subset,
                     columns = 2:5, 
                     mapping = aes(color = species),
                     upper = list(continuous = "points"),
                     lower = list(continuous = "points"),
                     diag = list(continuous = "densityDiag")) +
  theme_minimal() + 
  theme(legend.position = "bottom")

library(GGally)

# Select first 4 PCs + species
pca_subset <- pca_data[, c("species", "PC1", "PC2", "PC3", "PC4")]

library(patchwork)
library(tidyr)

# Convert to long format
pca_long <- pca_data %>%
  pivot_longer(cols = c(PC2, PC3, PC4), 
               names_to = "PC_axis", 
               values_to = "PC_value")

#Combine Multiple PCs
#Create faceted plot
p_faceted <- ggplot(pca_long, aes(x = PC1, y = PC_value, color = species)) +
  geom_point(size = 3, alpha = 0.8) +
  geom_text_repel(aes(label = id), size = 2.5, max.overlaps = 15) +
  facet_wrap(~ PC_axis, scales = "free_y", 
             labeller = labeller(PC_axis = c(
               "PC2" = paste0("PC2 (", variance_explained[2], "%)"),
               "PC3" = paste0("PC3 (", variance_explained[3], "%)"), 
               "PC4" = paste0("PC4 (", variance_explained[4], "%)")
             ))) +
  labs(x = paste0("PC1 (", variance_explained[1], "%)"),
       y = "PC Value",
       title = "PCA Analysis - Multiple Components",
       color = "Species") +
  theme_classic() +
  theme(legend.position = "bottom")

ggsave("pca_faceted_plot.png", p_faceted, width = 12, height = 8, dpi = 300)


#IF 3D Plot
library(plotly)

# 3D Plot interactive
p_3d <- plot_ly(pca_data, x = ~PC1, y = ~PC2, z = ~PC3, 
                color = ~species, text = ~id,
                marker = list(size = 5, opacity = 0.8)) %>%
  add_markers() %>%
  layout(scene = list(
    xaxis = list(title = paste0("PC1 (", variance_explained[1], "%)")),
    yaxis = list(title = paste0("PC2 (", variance_explained[2], "%)")),
    zaxis = list(title = paste0("PC3 (", variance_explained[3], "%)"))
  ),
  title = "3D PCA Plot"
  )

# Save as HTML (interactive)
htmlwidgets::saveWidget(p_3d, "pca_3d_interactive.html")

# Atau static 3D plot
library(scatterplot3d)
png("pca_3d_static.png", width = 10, height = 8, units = "in", res = 300)
scatterplot3d(pca_data$PC1, pca_data$PC2, pca_data$PC3,
              color = as.numeric(factor(pca_data$species)),
              pch = 16,
              xlab = paste0("PC1 (", variance_explained[1], "%)"),
              ylab = paste0("PC2 (", variance_explained[2], "%)"), 
              zlab = paste0("PC3 (", variance_explained[3], "%)"))
legend("topright", legend = levels(factor(pca_data$species)),
       col = 1:length(levels(factor(pca_data$species))), pch = 16)
dev.off()




########################
# Color based on species
species_colors <- c(
  "Quanzhou" = "#0000FF",
  "Yueqing"   = "#FF00FF",
  "Yunxiao"   = "#FFA500",
  "Fuding"    = "#00FF00",
  "Longgang"  = "#FF0000"
)

# Plot PC1 vs PC2
p1 <- ggplot(pca_data, aes(x = PC1, y = PC2, color = species)) +
  geom_point(size = 4, alpha = 0.8) +
  geom_text_repel(aes(label = id), size = 3, max.overlaps = 20) +
  labs(x = paste0("PC1 (", variance_explained[1], "%)"),
       y = paste0("PC2 (", variance_explained[2], "%)"),
       title = "PCA Plot",
       color = "species") +
  scale_color_manual(values = species_colors) +
  theme_classic() +
  theme(legend.position = "bottom",
        plot.title = element_text(hjust = 0.5, size = 11, face = "bold"))

# Plot PC1 vs PC3
p2 <- ggplot(pca_data, aes(x = PC1, y = PC3, color = species)) +
  geom_point(size = 4, alpha = 0.8) +
  geom_text_repel(aes(label = id), size = 3, max.overlaps = 20) +
  labs(x = paste0("PC1 (", variance_explained[1], "%)"),
       y = paste0("PC3 (", variance_explained[3], "%)"),
       title = "PCA Plot (by species)",
       color = "species") +
  scale_color_manual(values = species_colors) +
  theme_classic() +
  theme(legend.position = "bottom",
        plot.title = element_text(hjust = 0.5, size = 11, face = "bold"))

ggsave("pca_plot_pc1_pc2_new.png", p1, width = 8, height = 8, dpi = 300)
ggsave("pca_plot_pc1_pc3_new.png", p2, width = 8, height = 8, dpi = 300)
