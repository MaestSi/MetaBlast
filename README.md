# MetaBlast

**MetaBlast** is a Metagenomic pipeline for parallel Blast analysis and report generation. After splitting the fasta file in chunks, it Blasts each read and then reports up to one top hit for each read. A simple summary file is then generated, reporting the number of reads supporting each top hit. Moreover, the full taxonomy of each top hit is retrieved.

<p align="center">
  <img src="Figures/MetaBlast.png" alt="drawing" width="400" title="MetaBlast_pipeline">
</p>

## Getting started

**Prerequisites**

* Miniconda3.
Tested with conda 4.9.2.
```which conda``` should return the path to the executable.
If you don't have Miniconda3 installed, you could download and install it with:
```
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
chmod 755 Miniconda3-latest-Linux-x86_64.sh
./Miniconda3-latest-Linux-x86_64.sh
```

Then, after completing _MetaBlast_ installation, set the _MINICONDA_DIR_ variable in **config_MetaBlast.sh** to the full path to miniconda3 directory.

* A Blast-indexed database. For example, you may download NCBI nt db with the following instruction:

```
mkdir NCBI_nt_db
cd NCBI_nt_db
echo `date +%Y-%m-%d` > download_date.txt
wget ftp://ftp.ncbi.nlm.nih.gov/blast/db/nt*
targz_files=$(find . | grep \.tar\.gz$ | sed 's/\.\///g')
for f in $targz_files; do tar -xzvf $f; done
rm $targz_files
```

Or, in case you want to use a custom \<fasta file\> downloaded from NCBI, you can create a Blast-indexed database with the following instruction:

```
wget ftp://ftp.ncbi.nlm.nih.gov/pub/taxonomy/accession2taxid/nucl_gb.accession2taxid.gz
gunzip nucl_gb.accession2taxid.gz
tail -n+2 nucl_gb.accession2taxid | cut -f2,3 > Taxid_map.txt
makeblastdb -in <fasta file> -parse_seqids -dbtype nucl -taxid_map Taxid_map.txt
```

* A fasta file containing sequences you want to Blast. Be sure your fasta file has 2 lines for each sequence.
If you need reformatting it do:

```
seqtk seq -A <sample_name_tmp.fasta> > <sample_name.fasta>
```

**Installation**

```
git clone https://github.com/MaestSi/MetaBlast.git
cd MetaBlast
chmod 755 *
./install.sh
```

A conda environment named _MetaBlast_env_ is created, where blast, parallel and R with packages taxize and data.table are installed.
Then, you can open the **config_MetaBlast.sh** file with a text editor and set the variables _PIPELINE_DIR_ and _MINICONDA_DIR_ to the value suggested by the installation step.

## Usage

**MetaBlast.sh**

Usage:
./MetaBlast.sh -f \<sample\_name.fasta\> -db \<blast_db\>

Note: modify **config_MetaBlast.sh** before running; 

Inputs:

* \<sample\_name.fasta\>: fasta file containing reads to be analysed
* \<blast_db\>: Blast-indexed database

Outputs:
* \<sample_name\>\_blast\_hits\_unique\_min\_id\_perc\_$MIN\_ID\_PERC\_min\_query\_cov\_$MIN\_QUERY\_COV.txt: file containing top Blast hit for each read
* \<sample_name\>\_summary\_blast\_hits\_unique\_min\_id\_perc\_$MIN\_ID\_PERC\_min\_query\_cov\_$MIN\_QUERY\_COV.txt: file containing summary of top Blast hits with full taxonomy

**Collapse_taxa.sh**

Usage:
./Collapse_taxa.sh \<sample_name\>\_summary\_blast\_hits.txt \<taxonomic level\>

Inputs:

* \<sample_name\>\_summary\_blast\_hits.txt: file produced by **MetaBlast.sh**
* \<taxonomic level\>: number indicating the column of the input file representing the desired taxonomic level

Output

* \<sample_name\>\_summary\_blast\_hits_collapsed_level\<taxonomic level\>.txt: summary file collapsed at the desired taxonomic level

## Auxiliary scripts

In the following, auxiliary scripts run by **MetaBlast.sh** are listed. These scripts should not be called directly.

**config_MetaBlast.sh**

Note: configuration script, should be edited before running **MetaBlast.sh**.

**Filter_Blast_hits.R**

Note: script run by **MetaBlast.sh** for filtering Blast results, retaining up to 1 top hit for each read.

**Retrieve_taxonomy.R**

Note: script run by **MetaBlast.sh** to retrieve the full taxonomy for each top hit.

## Results visualization

After completing the analysis, you can open \<sample_name\>\_blast\_hits\_unique\_min\_id\_perc\_$MIN\_ID\_PERC\_min\_query\_cov\_$MIN\_QUERY\_COV\_Krona\_report.html with a browser.

<p align="center">
  <img src="Figures/Krona_report_example.png" alt="drawing" width="30000" title="Krona report example">
</p>


## Citations

If this tool is useful for your work, please consider citing our [manu](https://www.mdpi.com/2076-0817/11/2/199)[scripts](https://www.mdpi.com/2223-7747/11/6/779).

Marcolungo L, Passera A, Maestri S, Segala E, Alfano M, Gaffuri F, Marturano G, Casati P, Bianco PA, Delledonne M. Real-Time On-Site Diagnosis of Quarantine Pathogens in Plant Tissues by Nanopore-Based Sequencing. Pathogens. 2022; 11(2):199. https://doi.org/10.3390/pathogens11020199.

Tarquini G, Martini M, Maestri S, Firrao G, Ermacora P. The Virome of ‘Lamon Bean’: Application of MinION Sequencing to Investigate the Virus Population Associated with Symptomatic Beans in the Lamon Area, Italy. Plants. 2022; 11(6):779. https://doi.org/10.3390/plants11060779

Please refer to the following manuscripts for further information.

Tange, O. (2020, September 22). GNU Parallel 20200922 ('Ginsburg'). Zenodo. https://doi.org/10.5281/zenodo.4045386

Altschul, S.F., Gish, W., Miller, W., Myers, E.W. & Lipman, D.J. (1990) "Basic local alignment search tool." J. Mol. Biol. 215:403-410.

Scott Chamberlain, Eduard Szocs (2013). “taxize - taxonomic search and retrieval in R.” F1000Research.
