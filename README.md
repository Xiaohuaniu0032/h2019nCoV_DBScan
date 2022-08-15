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
hCoV-19_Jiangxi_JXCDC-18_2022   2019-nCoV       241     C       T
hCoV-19_Jiangxi_JXCDC-18_2022   2019-nCoV       670     T       G
hCoV-19_Jiangxi_JXCDC-18_2022   2019-nCoV       2197    C       T
hCoV-19_Jiangxi_JXCDC-18_2022   2019-nCoV       2790    C       T
hCoV-19_Jiangxi_JXCDC-18_2022   2019-nCoV       3037    C       T
hCoV-19_Jiangxi_JXCDC-18_2022   2019-nCoV       4184    G       A
hCoV-19_Jiangxi_JXCDC-18_2022   2019-nCoV       4321    C       T
hCoV-19_Jiangxi_JXCDC-18_2022   2019-nCoV       4893    C       T
hCoV-19_Jiangxi_JXCDC-18_2022   2019-nCoV       7393    G       T
hCoV-19_Jiangxi_JXCDC-18_2022   2019-nCoV       7788    C       T
hCoV-19_Jiangxi_JXCDC-18_2022   2019-nCoV       9344    C       T
hCoV-19_Jiangxi_JXCDC-18_2022   2019-nCoV       9424    A       G
hCoV-19_Jiangxi_JXCDC-18_2022   2019-nCoV       9534    C       T
hCoV-19_Jiangxi_JXCDC-18_2022   2019-nCoV       9866    C       T
hCoV-19_Jiangxi_JXCDC-18_2022   2019-nCoV       10029   C       T
hCoV-19_Jiangxi_JXCDC-18_2022   2019-nCoV       10198   C       T
hCoV-19_Jiangxi_JXCDC-18_2022   2019-nCoV       10447   G       A
hCoV-19_Jiangxi_JXCDC-18_2022   2019-nCoV       10449   C       A
hCoV-19_Jiangxi_JXCDC-18_2022   2019-nCoV       10696   T       C
hCoV-19_Jiangxi_JXCDC-18_2022   2019-nCoV       11288   TCTGGTTTT       -
hCoV-19_Jiangxi_JXCDC-18_2022   2019-nCoV       12525   C       T
hCoV-19_Jiangxi_JXCDC-18_2022   2019-nCoV       12880   C       T
hCoV-19_Jiangxi_JXCDC-18_2022   2019-nCoV       14034   T       C
hCoV-19_Jiangxi_JXCDC-18_2022   2019-nCoV       14408   C       T
hCoV-19_Jiangxi_JXCDC-18_2022   2019-nCoV       15714   C       T
hCoV-19_Jiangxi_JXCDC-18_2022   2019-nCoV       17410   C       T
hCoV-19_Jiangxi_JXCDC-18_2022   2019-nCoV       18163   A       G
hCoV-19_Jiangxi_JXCDC-18_2022   2019-nCoV       19955   C       T
hCoV-19_Jiangxi_JXCDC-18_2022   2019-nCoV       20055   A       G

```

## 2. Top 20 similar sequence from 2019nCoV database

> */outdir/*.similarity.based_on_variant_calling.top10.xls*
```
query_seq_name  db_seq_name     query_seq_var_num       db_seq_var_num  query_seq_uniq_var_num  db_seq_uniq_var_num     both_var_num    total_uniq_var_num      bothVar_to_uniqVar_pct
hCoV-19_Jiangxi_JXCDC-18_2022   hCoV-19_Jiangxi_JXCDC-18_2022   80      80      0       0       80      80
      100.00
hCoV-19_Jiangxi_JXCDC-18_2022   hCoV-19_Jiangxi_IVDC-557_2022   80      78      2       0       78      80
      97.50
hCoV-19_Jiangxi_JXCDC-18_2022   hCoV-19_Xinjiang_IVDC-576_2022  80      79      2       1       78      81
      96.30
hCoV-19_Jiangxi_JXCDC-18_2022   hCoV-19_Jiangxi_JXCDC-17_2022   80      77      3       0       77      80
      96.25
hCoV-19_Jiangxi_JXCDC-18_2022   hCoV-19_Yunnan_IVDC-568_2022    80      77      3       0       77      80
      96.25
hCoV-19_Jiangxi_JXCDC-18_2022   hCoV-19_Jiangsu_IVDC-580_2022   80      77      3       0       77      80
      96.25
hCoV-19_Jiangxi_JXCDC-18_2022   hCoV-19_Jiangxi_JXCDC-16_2022   80      78      3       1       77      81
      95.06
hCoV-19_Jiangxi_JXCDC-18_2022   hCoV-19_Sichuan_IVDC-587_2022   80      78      3       1       77      81
      95.06
hCoV-19_Jiangxi_JXCDC-18_2022   hCoV-19_Jiangxi_IVDC-558_2022   80      78      3       1       77      81
      95.06
hCoV-19_Jiangxi_JXCDC-18_2022   hCoV-19_Fujian_2022XG-2042_2022 80      78      3       1       77      81
      95.06

```
## 3. Query sequence QC info

```
Query_Seq       Consensus_fa_len        Ref_fa_len      N_num   N_pct
hCoV-19_Jiangxi_JXCDC-18_2022   29665   29903   0       0

```
## 4. Variants summary info

```
Query_Seq       Variants_Num    SNP_Num Insertion_Num   Deletion_Num
hCoV-19_Jiangxi_JXCDC-18_2022   80      77      0       3
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

## 6. Merge variants

```
Chr     Pos     Ref     Alt     hCoV-19_Jiangxi_JXCDC-18_2022   hCoV-19_Jiangxi_IVDC-557_2022   hCoV-19_Xinjiang_IVDC-576_2022  hCoV-19_Jiangxi_JXCDC-17_2022   hCoV-19_Yunnan_IVDC-568_2022    hCoV-19_Jiangsu_IVDC-580_2022
   hCoV-19_Jiangxi_JXCDC-16_2022   hCoV-19_Sichuan_IVDC-587_2022   hCoV-19_Jiangxi_IVDC-558_2022   hCoV-19_Fujian_2022XG-2042_2022
2019-nCoV       44      C       T       No      No      Yes     No      No      No      Yes     Yes     Yes
     No
2019-nCoV       241     C       T       Yes     Yes     Yes     Yes     Yes     Yes     Yes     Yes     Yes
     Yes
2019-nCoV       670     T       G       Yes     Yes     Yes     Yes     Yes     Yes     Yes     Yes     Yes
     Yes
2019-nCoV       2197    C       T       Yes     No      No      No      No      No      No      No      No
      No
2019-nCoV       2790    C       T       Yes     Yes     Yes     Yes     Yes     Yes     Yes     Yes     Yes
     Yes
2019-nCoV       3037    C       T       Yes     Yes     Yes     Yes     Yes     Yes     Yes     Yes     Yes
     Yes
2019-nCoV       4184    G       A       Yes     Yes     Yes     Yes     Yes     Yes     Yes     Yes     Yes
     Yes
2019-nCoV       4321    C       T       Yes     Yes     Yes     Yes     Yes     Yes     Yes     Yes     Yes
     Yes
2019-nCoV       4893    C       T       Yes     Yes     Yes     Yes     Yes     Yes     Yes     Yes     Yes
     Yes
2019-nCoV       7393    G       T       Yes     Yes     Yes     Yes     Yes     Yes     Yes     Yes     Yes
     Yes
2019-nCoV       7788    C       T       Yes     No      No      No      No      No      No      No      No
      No
2019-nCoV       9344    C       T       Yes     Yes     Yes     Yes     Yes     Yes     Yes     Yes     Yes
     Yes
2019-nCoV       9424    A       G       Yes     Yes     Yes     Yes     Yes     Yes     Yes     Yes     Yes
     Yes
2019-nCoV       9534    C       T       Yes     Yes     Yes     Yes     Yes     Yes     Yes     Yes     Yes
     Yes
2019-nCoV       9866    C       T       Yes     Yes     Yes     Yes     Yes     Yes     Yes     Yes     Yes
     Yes
2019-nCoV       10029   C       T       Yes     Yes     Yes     Yes     Yes     Yes     Yes     Yes     Yes
     Yes
2019-nCoV       10198   C       T       Yes     Yes     Yes     Yes     Yes     Yes     Yes     Yes     Yes
     Yes
2019-nCoV       10447   G       A       Yes     Yes     Yes     Yes     Yes     Yes     Yes     Yes     Yes
     Yes
2019-nCoV       10449   C       A       Yes     Yes     Yes     Yes     Yes     Yes     Yes     Yes     Yes
     Yes
2019-nCoV       10696   T       C       Yes     Yes     Yes     Yes     Yes     Yes     Yes     Yes     Yes
     Yes
2019-nCoV       11288   TCTGGTTTT       -       Yes     Yes     Yes     Yes     Yes     Yes     Yes     Yes
     Yes     Yes
2019-nCoV       12525   C       T       Yes     Yes     Yes     Yes     Yes     Yes     Yes     Yes     Yes
     Yes
2019-nCoV       12880   C       T       Yes     Yes     Yes     Yes     Yes     Yes     Yes     Yes     Yes
     Yes
2019-nCoV       14034   T       C       Yes     Yes     Yes     No      No      No      No      No      No
      No
2019-nCoV       14408   C       T       Yes     Yes     Yes     Yes     Yes     Yes     Yes     Yes     Yes
     Yes
2019-nCoV       15714   C       T       Yes     Yes     Yes     Yes     Yes     Yes     Yes     Yes     Yes
     Yes
2019-nCoV       17410   C       T       Yes     Yes     Yes     Yes     Yes     Yes     Yes     Yes     Yes
     Yes
2019-nCoV       18163   A       G       Yes     Yes     Yes     Yes     Yes     Yes     Yes     Yes     Yes
     Yes
2019-nCoV       19955   C       T       Yes     Yes     Yes     Yes     Yes     Yes     Yes     Yes     Yes
     Yes
2019-nCoV       20055   A       G       Yes     Yes     Yes     Yes     Yes     Yes     Yes     Yes     Yes
     Yes
2019-nCoV       21618   C       T       Yes     Yes     Yes     Yes     Yes     Yes     Yes     Yes     Yes
     Yes
2019-nCoV       21633   TACCCCCTG       -       Yes     Yes     Yes     Yes     Yes     Yes     Yes     Yes
     Yes     Yes
2019-nCoV       21987   G       A       Yes     Yes     Yes     Yes     Yes     Yes     Yes     Yes     Yes
     Yes
2019-nCoV       22200   T       G       Yes     Yes     Yes     Yes     Yes     Yes     Yes     Yes     Yes
     Yes
2019-nCoV       22578   G       A       Yes     Yes     Yes     Yes     Yes     Yes     Yes     Yes     Yes
     Yes
2019-nCoV       22674   C       T       Yes     Yes     Yes     Yes     Yes     Yes     Yes     Yes     Yes
     Yes
2019-nCoV       22679   T       C       Yes     Yes     Yes     Yes     Yes     Yes     Yes     Yes     Yes
     Yes
2019-nCoV       22686   C       T       Yes     Yes     Yes     Yes     Yes     Yes     Yes     Yes     Yes
     Yes
2019-nCoV       22688   A       G       Yes     Yes     Yes     Yes     Yes     Yes     Yes     Yes     Yes
     Yes
2019-nCoV       22775   G       A       Yes     Yes     Yes     Yes     Yes     Yes     Yes     Yes     Yes
     Yes

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
