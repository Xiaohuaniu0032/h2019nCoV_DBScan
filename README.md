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

> */outdir/*.similarity.based_on_variant_calling.top10.xls*
```
query_seq_name  db_seq_name     query_seq_var_num       db_seq_var_num  query_seq_uniq_var_num  db_seq_uniq_var_num     both_var_num    total_uniq_var_num      bothVar_to_uniqVar_pct
Sample_1277-1__2019-nCoV        hCoV-19_Guizhou_IVDC-578_2022   78      72      7       1       71      79
      89.87
Sample_1277-1__2019-nCoV        hCoV-19_Guangdong_IVDC-603_2022 78      72      7       1       71      79
      89.87
Sample_1277-1__2019-nCoV        hCoV-19_Jilin_IVDC-556_2022     78      70      8       0       70      78
      89.74
Sample_1277-1__2019-nCoV        hCoV-19_Yunnan_IVDC-565_2022    78      71      8       1       70      79
      88.61
Sample_1277-1__2019-nCoV        hCoV-19_Chongqing_IVDC-610_2022 78      71      8       1       70      79
      88.61
Sample_1277-1__2019-nCoV        hCoV-19_Shanghai_IVDC-615_2022  78      74      7       3       71      81
      87.65
Sample_1277-1__2019-nCoV        hCoV-19_Fujian_2022XG-2039_2022 78      72      8       2       70      80
      87.50
Sample_1277-1__2019-nCoV        hCoV-19_Guangdong_IVDC-12-01_2021       78      70      9       1       69
      79      87.34
Sample_1277-1__2019-nCoV        hCoV-19_Yunnan_IVDC-562_2022    78      70      9       1       69      79
      87.34
Sample_1277-1__2019-nCoV        hCoV-19_Liaoning_IVDC-583_2022  78      70      9       1       69      79
      87.34
Sample_1277-2__2019-nCoV        hCoV-19_Guangdong_IVDC-603_2022 78      72      7       1       71      79
      89.87
Sample_1277-2__2019-nCoV        hCoV-19_Guizhou_IVDC-578_2022   78      72      7       1       71      79
      89.87
Sample_1277-2__2019-nCoV        hCoV-19_Jilin_IVDC-556_2022     78      70      8       0       70      78
      89.74
Sample_1277-2__2019-nCoV        hCoV-19_Chongqing_IVDC-610_2022 78      71      8       1       70      79

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
