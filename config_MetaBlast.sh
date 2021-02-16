#!/bin/bash

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

#minimum percent alignment identity [0, 100]
min_id_perc=85
#minumum percent query coverage [0, 100]
min_query_cov=90
#maximum e-value
max_evalue=0.00001
#number of threads
threads=24
#chunk_size is the number of reads contained in each file
chunk_size=100
########################################################################################################
PIPELINE_DIR="/path/to/MetaBlast"
MINICONDA_DIR="/path/to/miniconda3"
########### End of user editable region #################################################################
RSCRIPT=$MINICONDA_DIR"/envs/MetaBlast_env/bin/Rscript"
BLAST=$MINICONDA_DIR"/envs/MetaBlast_env/bin/blastn"

