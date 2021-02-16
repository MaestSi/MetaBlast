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

if (length(args) == 1) {
  input_file <- args[1]
  min_query_cov <- 90
  min_id_perc <- 0
} else if (length(args) == 2) {
  input_file <- args[1]
  min_query_cov <- as.numeric(args[2])
  min_id_perc <- 0
} else if (length(args == 3)) {
  input_file <- args[1]
  min_query_cov <- as.numeric(args[2])
  min_id_perc <- as.numeric(args[3])
} else {
  stop("Wrong number of input arguments! At least input file must be provided")
}

library("data.table")
output_file <- paste0(dirname(input_file), "/", gsub("\\.txt", "", basename(input_file)), "_unique_min_id_perc_", min_id_perc, "_min_query_cov_", min_query_cov, ".txt")

blast_input <- fread(input_file)
read_names <- blast_input[, 1]
subject_id <- blast_input[, 2]
hit_names <- blast_input[, 3]
alignment_length <- blast_input[, 4]
id_perc <- blast_input[, 5]
qcov <- blast_input[, 6]
e_value <-  blast_input[, 7]
blast_score <- blast_input[, 8]

read_names_unique <- unique(read_names)

ind_out <- c()
for (i in 1:dim(read_names_unique)[1]) {
  ind_curr_read <- which(read_names == read_names_unique[i]$V1)
  ind_pass_curr <- ind_curr_read[intersect(which(qcov[ind_curr_read] > min_query_cov), which(id_perc[ind_curr_read] > min_id_perc))]
  if (length(ind_pass_curr) > 1) {
    ind_out <- c(ind_out, ind_pass_curr[which(blast_score[ind_pass_curr] == max(blast_score[ind_pass_curr]))][1])
    #ind_out <- c(ind_out, ind_pass_curr[which(id_perc[ind_pass_curr] == max(id_perc[ind_pass_curr]))][1])
  }
  if (length(ind_pass_curr) == 1) {
    ind_out <- c(ind_out, ind_pass_curr)
  }
}

blast_output <- blast_input[ind_out, ]

if (length(ind_out) > 0) {
  write.table(x = blast_output, quote = FALSE, row.names = FALSE, col.names = FALSE, file = output_file, sep = "\t")  
}
