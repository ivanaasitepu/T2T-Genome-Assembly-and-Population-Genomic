library(ape)
library(phangorn)

# Read distance matrix and sample IDs
sample_ids <- read.table("merged.maffiltered.snps.ld.chr.dist.mdist.id", header = FALSE)
dist_matrix <- read.table("merged.maffiltered.snps.ld.chr.dist.mdist", header = FALSE)

# Convert to proper matrix
sample_names <- as.character(sample_ids$V2)
dist_matrix <- as.matrix(dist_matrix)
rownames(dist_matrix) <- sample_names
colnames(dist_matrix) <- sample_names

# Create Neighbor-Joining tree
dist_obj <- as.dist(dist_matrix)
nj_tree <- nj(dist_obj)

# Save tree in Newick format for iTOL
write.tree(nj_tree, "tree_itol.nwk")

cat("Tree file for iTOL created: tree_itol.nwk\n")
cat("Upload this file directly to iTOL: https://itol.embl.de\n")
