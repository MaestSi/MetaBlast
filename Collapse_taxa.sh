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

OUTPUT_FILE=$(echo $(basename $INPUT_FILE) | sed 's/\.txt/_collapsed/')"_level_"$TAXA_COL".txt"
OUTPUT_FILE_TMP=$(echo $(basename $INPUT_FILE) | sed 's/\.txt/_collapsed/')"_level_"$TAXA_COL"_tmp.txt"
echo -e "Num. reads\tCollapsed taxa" > $OUTPUT_FILE
taxa_tmp=$(cat $INPUT_FILE | tail -n+2 | cut -f $TAXA_COL | sed 's/ /___/g' | sort | uniq)
for taxa_curr_tmp in $(echo $taxa_tmp | sed 's/ /\n/g'); do
  taxa_curr=$(echo $taxa_curr_tmp | sed 's/___/ /g');
  taxa_curr_mod=$(echo $taxa_curr | sed 's/[][]/\\&/g' | sed 's/[)(]/\\&/g');
  total=$(cat $INPUT_FILE | grep -P "\t$taxa_curr_mod\t" | cut -f1 | paste -sd+ | bc);
  echo -e $total"\t"$taxa_curr"\t" >> $OUTPUT_FILE_TMP
done
cat $OUTPUT_FILE_TMP | sort -nr >> $OUTPUT_FILE
rm $OUTPUT_FILE_TMP
