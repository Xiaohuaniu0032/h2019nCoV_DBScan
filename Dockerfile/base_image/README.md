## Docker
https://docs.docker.com/engine/reference/commandline/cli/

## Base image

#### base image includes:

1. ubuntu 14.04
2. wget
3. miniconda
4. base r
5. r package "rmarkdown"

## Base image Dockerfile
```
FROM ubuntu:14.04
MAINTAINER longfei.fu

# install wget
RUN apt-get update && apt-get install -y wget
WORKDIR /

# download miniconda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
RUN chmod 755 Miniconda3-latest-Linux-x86_64.sh

# install miniconda silently => /root/miniconda3/bin/conda
RUN /bin/bash Miniconda3-latest-Linux-x86_64.sh -b

# install R => /root/miniconda3/bin/R
# https://conda.io/projects/conda/en/latest/user-guide/install/linux.html
RUN /root/miniconda3/bin/conda install -c r/label/archive r

# install R package "rmarkdown" (this step will use too much time)
ENV PATH "$PATH:/root/miniconda3/bin"
RUN R -e "install.packages('rmarkdown',dependencies=TRUE, repos='http://cran.rstudio.com/')"
```

## Build base docker image
`docker build -t ubuntu_miniconda_base_r_rmarkdown:v1 .`


## Save your base image as tar.gz
https://docs.docker.com/engine/reference/commandline/save/
```
docker save ubuntu_miniconda_base_r_rmarkdown:v1 | gzip >ubuntu_miniconda_base_r_rmarkdown_v1.tar.gz

```

## Load tar.gz file
```
docker load <ubuntu_miniconda_base_r_rmarkdown_v1.tar.gz
```

## Build your app image

Your Dockerfile:
```
From ubuntu_miniconda_base_r_rmarkdown:v1
RUN apt-get update && apt-get install -y samtools
WORKDIR /tools
ADD h2019nCoV_DBScan /tools
WORKDIR /bio_tools
```