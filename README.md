# h2019nCoV_DBScan
Using your customized 2019nCoV database sequences to do 2019nCoV mutation tracking.

* Variant calling for query consensus fasta

* Variant calling for your 2019nCoV database sequences

* Do QC for query consensus fasta

* Find the most similar sequence(s) from your 2019nCoV database based on the variants called by `nextalign`

* Variants summary info for query consensus fasta


# Usage
`perl 2019nCoV_DBScan_pipeline.pl -fa <input_cons.fasta> -dbdir <2019nCoV_DB_dir> -faname <input_cons_fasta_name> -od <outdir>`


### Args

`fa`      : *input_fa      [Needed]*

`samtools`: *samtools_bin  [Default: /usr/bin/samtools]*

`dbdir`   : *hcov19_db_dir [Needed]*

`faname`  : *fa_name       [Needed]*

`od`      : *outdir        [Needed]*


# Results

## 1. Sample variants

> */outdir/variants/\*.variants.xls*

```
Sample  Chr     Pos     Ref     Alt
Sample_1277-1__2019-nCoV        2019-nCoV       44      C       T
Sample_1277-1__2019-nCoV        2019-nCoV       241     C       T
Sample_1277-1__2019-nCoV        2019-nCoV       670     T       G
Sample_1277-1__2019-nCoV        2019-nCoV       886     T       C
Sample_1277-1__2019-nCoV        2019-nCoV       2790    C       T
Sample_1277-1__2019-nCoV        2019-nCoV       3037    C       T
Sample_1277-1__2019-nCoV        2019-nCoV       3871    G       T
Sample_1277-1__2019-nCoV        2019-nCoV       4184    G       A
Sample_1277-1__2019-nCoV        2019-nCoV       4321    C       T
Sample_1277-1__2019-nCoV        2019-nCoV       7065    G       T
Sample_1277-1__2019-nCoV        2019-nCoV       9344    C       T
Sample_1277-1__2019-nCoV        2019-nCoV       9424    A       G
Sample_1277-1__2019-nCoV        2019-nCoV       9534    C       T
Sample_1277-1__2019-nCoV        2019-nCoV       9866    C       T
Sample_1277-1__2019-nCoV        2019-nCoV       10029   C       T
Sample_1277-1__2019-nCoV        2019-nCoV       10198   C       T
Sample_1277-1__2019-nCoV        2019-nCoV       10447   G       A
Sample_1277-1__2019-nCoV        2019-nCoV       10449   C       A
Sample_1277-1__2019-nCoV        2019-nCoV       11288   TCTGGTTTT       -
Sample_1277-1__2019-nCoV        2019-nCoV       12880   C       T
Sample_1277-1__2019-nCoV        2019-nCoV       14408   C       T
Sample_1277-1__2019-nCoV        2019-nCoV       15714   C       T
Sample_1277-1__2019-nCoV        2019-nCoV       17410   C       T
Sample_1277-1__2019-nCoV        2019-nCoV       18163   A       G
Sample_1277-1__2019-nCoV        2019-nCoV       19955   C       T
Sample_1277-1__2019-nCoV        2019-nCoV       20055   A       G
Sample_1277-1__2019-nCoV        2019-nCoV       21618   C       T
Sample_1277-1__2019-nCoV        2019-nCoV       21633   TACCCCCTG       -
Sample_1277-1__2019-nCoV        2019-nCoV       21987   G       A
```

## 2. Top 20 similar sequence from 2019nCoV database

> */outdir/*.similarity.xls*
```
Query_Seq       2019nCoV_Database_Seq   Similarity      Macth_Num       Eff_length
Sample_1277-1__2019-nCoV        hCoV-19/Gansu/IVDC-577/2022     99.57   29673   29800
Sample_1277-1__2019-nCoV        hCoV-19/Liaoning/IVDC-DL-168/2021       99.57   29673   29800
Sample_1277-1__2019-nCoV        hCoV-19/Liaoning/IVDC-DL-27/2021        99.57   29673   29800
Sample_1277-1__2019-nCoV        hCoV-19/Heilongjiang/IVDC-HH-493/2021   99.57   29673   29800
Sample_1277-1__2019-nCoV        hCoV-19/Liaoning/IVDC-DL-143/2021       99.57   29673   29800
Sample_1277-1__2019-nCoV        hCoV-19/Liaoning/IVDC-DL-73/2021        99.57   29673   29800
Sample_1277-1__2019-nCoV        hCoV-19/Liaoning/IVDC-DL-157/2021       99.57   29673   29800
Sample_1277-1__2019-nCoV        hCoV-19/Liaoning/IVDC-DL-76/2021        99.57   29673   29800
Sample_1277-1__2019-nCoV        hCoV-19/Liaoning/IVDC-DL-58/2021        99.57   29673   29800
Sample_1277-1__2019-nCoV        hCoV-19/Shanghai/IVDC-613/2022  99.57   29673   29800
Sample_1277-2__2019-nCoV        hCoV-19/Heilongjiang/IVDC-HH-415/2021   99.57   29673   29800
Sample_1277-2__2019-nCoV        hCoV-19/Heilongjiang/IVDC-HH-417/2021   99.57   29673   29800
Sample_1277-2__2019-nCoV        hCoV-19/Zhejiang/3853/2021      99.57   29673   29800
Sample_1277-2__2019-nCoV        hCoV-19/Heilongjiang/IVDC-HH-483/2021   99.57   29673   29800
Sample_1277-2__2019-nCoV        hCoV-19/InnerMongolia/IVDC-597/2022     99.57   29673   29800
Sample_1277-2__2019-nCoV        hCoV-19/Zhejiang/3998/2021      99.57   29673   29800
Sample_1277-2__2019-nCoV        hCoV-19/Yunnan/IVDC-567/2022    99.57   29673   29800
Sample_1277-2__2019-nCoV        hCoV-19/Fujian/2022XG-2040/2022 99.57   29673   29800
Sample_1277-2__2019-nCoV        hCoV-19/Beijing/IVDC-543/2022   99.57   29673   29800
Sample_1277-2__2019-nCoV        hCoV-19/Liaoning/IVDC-DL-43/2021        99.57   29673   29800

```
## 3. Query sequence QC info

```
Query_Seq       Consensus_fa_len        Ref_fa_len      N_num   N_pct
Sample_1277-1__2019-nCoV        29747   29903   0       0
Sample_1277-2__2019-nCoV        29747   29903   0       0
```
## 4. Variants summary info

```
Query_Seq       Variants_Num    SNP_Num Insertion_Num   Deletion_Num
Sample_1277-1__2019-nCoV        78      74      0       4
Sample_1277-2__2019-nCoV        78      74      0       4
```

## 5. Database sequences' variants

```
Sample  Chr     Pos     Ref     Alt
hCoV-19/Fujian/2022XG-2042/2022 2019-nCoV       241     C       T
hCoV-19/Fujian/2022XG-2042/2022 2019-nCoV       670     T       G
hCoV-19/Fujian/2022XG-2042/2022 2019-nCoV       2790    C       T
hCoV-19/Fujian/2022XG-2042/2022 2019-nCoV       3037    C       T
hCoV-19/Fujian/2022XG-2042/2022 2019-nCoV       4184    G       A
hCoV-19/Fujian/2022XG-2042/2022 2019-nCoV       4321    C       T
```


# Test

> Assum you are at`/data/fulongfei/git_repo/2019nCoV_DBScan`

`cd test`

`sh cmd` then you will get `runsh_2022-7-15.sh` file

`sh runsh_2022-7-15.sh`


> *`runsh_2022-7-15.sh` file contains all detail steps of this analysis pipeline.*



# Dependency

1. `samtools`
2. `perl`
3. `nextalign`

> *nextalign has included in this git repo and you do not need to install it. You only need to make sure you have samtools in your system*

# Any Question?
