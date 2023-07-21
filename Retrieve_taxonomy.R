#
# Copyright 2021 Simone Maestri. All rights reserved.
# Simone Maestri <simone.maestri@univr.it>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

args <- commandArgs(trailingOnly = TRUE)

if (length(args) == 2) {
  input_file <- args[1]
  output_file <- args[2]
} else {
  stop("Wrong number of input arguments! Input and output files must be provided")
}

library("taxize")
taxonomy_assignments <- read.table(input_file, stringsAsFactors = FALSE, sep = "\t", quote = "", comment.char = "")
counts <- taxonomy_assignments[, 1]
taxid <- as.numeric(taxonomy_assignments[, 2])
subject_description <- taxonomy_assignments[, 3]
avg_alignment_identity <- taxonomy_assignments[, 4]
avg_query_cov <- taxonomy_assignments[, 5]
full_taxonomy <- c()

max_attempts <- 10
num_taxids_chunk <- 100
if (length(taxid) < num_taxids_chunk) {
  chunks_list <- list(1:length(taxid))
} else {
  chunks_list <- split(1:length(taxid), ceiling(seq(from = 1, to = length(taxid))/num_taxids_chunk))
}

raw_classification <- c()
for (i in 1:length(chunks_list)) {
  raw_classification_curr <- NULL
  attempt <- 1
  while(length(which(!is.na(raw_classification_curr))) != lapply(chunks_list, length)[[i]] && attempt <= max_attempts) {
    raw_classification_curr <- try(suppressMessages(classification(NCBI_taxa_uids[chunks_list[[i]]], db = 'ncbi')))
    if (attempt > 1)  cat(sprintf("Running attempt %d\n", attempt))
    attempt <- attempt + 1
  }
}
raw_classification <- c(raw_classification, raw_classification_curr)

full_taxonomy <- c()
for (i in 1:length(raw_classification)) {
  if (!is.null(ncol(raw_classification[[i]]))) {
    if (nrow(raw_classification[[i]]) > 1) {
      subspecies_name_curr <- raw_classification[[i]][which(raw_classification[[i]][, 2] == "subspecies"), 1]
      species_name_curr <- raw_classification[[i]][which(raw_classification[[i]][, 2] == "species"), 1]
      genus_name_curr <- raw_classification[[i]][which(raw_classification[[i]][, 2] == "genus"), 1]
      family_name_curr <- raw_classification[[i]][which(raw_classification[[i]][, 2] == "family"), 1]
      order_name_curr <- raw_classification[[i]][which(raw_classification[[i]][, 2] == "order"), 1]
      class_name_curr <- raw_classification[[i]][which(raw_classification[[i]][, 2] == "class"), 1]
      phylum_name_curr <- raw_classification[[i]][which(raw_classification[[i]][, 2] == "phylum"), 1]
      kingdom_name_curr <- raw_classification[[i]][which(raw_classification[[i]][, 2] == "superkingdom"), 1]
      full_taxonomy[i] <- paste(kingdom_name_curr, phylum_name_curr, class_name_curr, order_name_curr, family_name_curr, genus_name_curr, species_name_curr, subspecies_name_curr, sep = ";")
    } else {
      full_taxonomy[i] <- "Unclassified;;;;;;;"
    }
  } else {
    full_taxonomy[i] <- "Unclassified;;;;;;;"
  }
}

full_taxonomy_df <- data.frame(counts, subject_description, full_taxonomy, avg_alignment_identity, avg_query_cov)
names(full_taxonomy_df) <- c("Read Counts", "Full description",  "Kingdom\tPhylum\tClass\tOrder\tFamily\tGenus\tSpecies\tSubspecies", "Average alignment identity perc.", "Average query coverage perc.")
write.table(x = full_taxonomy_df, file = output_file, quote = FALSE, sep = "\t", row.names = FALSE, col.names = TRUE)
