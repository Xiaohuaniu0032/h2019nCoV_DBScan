input_fa='/data/fulongfei/git_repo/h2019nCoV_DBScan/test/data/Auto_SARS-CoV-2_Insight_Research_Panel_-_530-2022-7-15_torrent-server_107.consensus.fasta'
dbdir='/data/fulongfei/git_repo/h2019nCoV_DBScan/database'

perl ../2019nCoV_DBScan_pipeline.pl -fa $input_fa -dbdir $dbdir -faname 2022-7-15 -od $PWD
