FROM ubuntu_miniconda_base_r_rmarkdown:v1
MAINTAINER longfei.fu

# install samtools
RUN conda install -c bioconda samtools

# copy app
WORKDIR /tools
ADD h2019nCoV_DBScan /tools

#WORKDIR /bio_soft

