input_fa='/data/fulongfei/git_repo/h2019nCoV_DBScan/test/data2/1652365368436.sequences.fasta'
meta_f='/data/fulongfei/git_repo/h2019nCoV_DBScan/test/data2/1652365368436.metadata.tsv'
dbfile='/data/fulongfei/git_repo/h2019nCoV_DBScan/database/2019nCoV.DB.CDC.fasta'

perl ../../2019nCoV_DBScan_pipeline.pl -fa $input_fa -n 1652365368436 -meta_f $meta_f -dbfile $dbfile -od $PWD -dk
