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
