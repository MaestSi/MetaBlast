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

INPUT_FILE=$1
TAXA_COL=$2

OUTPUT_FILE=$(echo $(basename $INPUT_FILE) | sed 's/\.txt/_merged/')"_level_"$TAXA_COL".txt"
echo -e "Num. reads\tTaxa merged" > $OUTPUT_FILE
taxa_tmp=$(cat $INPUT_FILE | tail -n+2 | cut -f $TAXA_COL | tr ' ' '_' | sort | uniq)
for taxa_curr_tmp in $(echo $taxa_tmp | tr ' ' '\n'); do
  taxa_curr=$(echo $taxa_curr_tmp | tr '_' ' ');
  nr=$(cat $INPUT_FILE | grep "$taxa_curr" | cut -f1 | paste -sd+ | bc);
  echo -e $nr"\t"$taxa_curr"\t" >> $OUTPUT_FILE
done
