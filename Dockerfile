FROM continuumio/miniconda3

########### set variables
ENV DEBIAN_FRONTEND noninteractive

########## generate working directories
RUN mkdir /home/tools

######### dependencies
RUN apt-get update -qq \
    && apt-get install -y \
    build-essential \
    wget \
    unzip \
    bzip2 \
    git \
    libidn11* \
    nano \
    curl \
    python3.6 \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

############################################################ install MetaBlast
WORKDIR /home/tools/

RUN git clone https://github.com/MaestSi/MetaBlast.git
WORKDIR /home/tools/MetaBlast
RUN chmod 755 *

RUN conda config --add channels bioconda && \
conda config --add channels conda-forge && \
conda config --add channels r && \
conda config --add channels anaconda

RUN sed -i 's/PIPELINE_DIR=.*/PIPELINE_DIR <- \"\/home\/tools\/MetaBlast\/\"/' config_MetaBlast.sh
RUN sed -i 's/MINICONDA_DIR=.*/MINICONDA_DIR <- \"\/opt\/conda\/\"/' config_MetaBlast.sh

RUN conda create -n MetaBlast_env r-base
RUN conda install -n MetaBlast_env r-taxize r-data.table
RUN conda install -n MetaBlast_env blast krona parallel

RUN MINICONDA_DIR=$(which conda | sed 's/miniconda3.*$/miniconda3/')
RUN /opt/conda/envs/MetaBlast_env/bin/ktUpdateTaxonomy.sh

WORKDIR /home/
