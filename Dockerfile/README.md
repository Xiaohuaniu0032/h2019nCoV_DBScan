## Build docker images using Dockerfile

### https://docs.docker.com/develop/develop-images/dockerfile_best-practices/



### Dockerfile
```
FROM ubuntu:14.04
MAINTAINER longfei.fu
#RUN apt-get update && apt-get install -y samtools
WORKDIR /tools
ADD h2019nCoV_DBScan /tools
```


### How to build
> Assume you are at: `/data/fulongfei/git_repo/h2019nCoV_DBScan/Dockerfile`

`docker build -t h2019ncov_dbscan:v1 .`


### How to run

```
docker run --rm -v /root/Dockerfile/h2019nCoV_DBScan:/input -v /root/tools/test/h2019nCoV_DBScan:/output h2019ncov_dbscan:v1 perl /tools/2019nCoV_DBScan_pipeline.pl -fa /input/test/data/Auto_SARS-CoV-2_Insight_Research_Panel_-_530-2022-7-15_torrent-server_107.consensus.fasta -dbdir /input/database -faname 2022-7-15 -od /output
```

### Note
Before `docker build -t h2019ncov_dbscan:v1 .`, you need to cp `h2019nCoV_DBScan` whole dir on the `/data/fulongfei/git_repo/h2019nCoV_DBScan/Dockerfile` dir, just like below:

```
-rw-r--r--  1 root root  157 Aug 10 18:24 Dockerfile
drwxr-xr-x  9 root root 4096 Aug 10 18:15 h2019nCoV_DBScan/
``` 


> Use your base docker image instead of `fsz_substr_finding_problem:v2`

> In `Dockerfile`, we need to install `samtools` using `apt-get install`, here I assume your base docker image's OS is ubuntu