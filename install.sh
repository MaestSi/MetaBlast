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

PIPELINE_DIR=$(realpath $( dirname "${BASH_SOURCE[0]}" ))
MINICONDA_DIR=$(which conda | sed 's/miniconda3.*$/miniconda3/')
conda config --add channels bioconda
conda config --add channels conda-forge
conda config --add channels r
conda config --add channels anaconda

conda create -n MetaBlast_env r-base
conda install -n MetaBlast_env r-taxize r-data.table
conda install -n MetaBlast_env blast krona parallel
$MINICONDA_DIR"/envs/MetaBlast_env/bin/ktUpdateTaxonomy.sh"

echo -e "\n"
echo "Modify variables PIPELINE_DIR and MINICONDA_DIR in config_MetaBlast.sh"
echo -e "PIPELINE_DIR=\"$PIPELINE_DIR\""
echo -e "MINICONDA_DIR=\"$MINICONDA_DIR\""
echo -e "\n"
