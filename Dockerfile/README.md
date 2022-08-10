## Build docker images using Dockerfile

### https://docs.docker.com/develop/develop-images/dockerfile_best-practices/



### Dockerfile
```
FROM fsz_substr_finding_problem:v2
MAINTAINER longfei.fu
RUN apt-get update && apt-get install -y samtools
WORKDIR /tools
ADD h2019nCoV_DBScan /tools
```


### How to build
> Assume you are at: `/data/fulongfei/git_repo/h2019nCoV_DBScan/Dockerfile`

`docker build -t h2019ncov_dbscan:v1 .`


### Note
Before `docker build -t h2019ncov_dbscan:v1 .`, you need to cp `h2019nCoV_DBScan` whole dir on the `/data/fulongfei/git_repo/h2019nCoV_DBScan/Dockerfile` dir, just like below:

```
-rw-r--r--  1 root root  157 Aug 10 18:24 Dockerfile
drwxr-xr-x  9 root root 4096 Aug 10 18:15 h2019nCoV_DBScan/
``` 


> Use your base docker image instead of `fsz_substr_finding_problem:v2`

> In `Dockerfile`, we need to install `samtools` using `apt-get install`, here I assume your base docker image's OS is ubuntu