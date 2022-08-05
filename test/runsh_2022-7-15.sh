perl /data/fulongfei/git_repo/2019nCoV_DBScan/scripts/pre_process_input_fa.pl /data/fulongfei/git_repo/2019nCoV_DBScan/test/data/Auto_SARS-CoV-2_Insight_Research_Panel_-_530-2022-7-15_torrent-server_107.consensus.fasta /data/fulongfei/git_repo/2019nCoV_DBScan/test/consensus.fasta

perl /data/fulongfei/git_repo/2019nCoV_DBScan/scripts/prepare_input_fa_to_align.pl /data/fulongfei/git_repo/2019nCoV_DBScan/reference/Ion_AmpliSeq_SARS-CoV-2-Insight.Reference.fa /data/fulongfei/git_repo/2019nCoV_DBScan/test/consensus.fasta /data/fulongfei/git_repo/2019nCoV_DBScan/database/2019nCoV.DB.CDC.fasta /data/fulongfei/git_repo/2019nCoV_DBScan/test/input.aln.fasta

/data/fulongfei/git_repo/2019nCoV_DBScan/bin/nextalign --sequences=/data/fulongfei/git_repo/2019nCoV_DBScan/test/input.aln.fasta --reference=/data/fulongfei/git_repo/2019nCoV_DBScan/reference/Ion_AmpliSeq_SARS-CoV-2-Insight.Reference.fa --output-dir=/data/fulongfei/git_repo/2019nCoV_DBScan/test --output-basename=2022-7-15 --in-order

perl /data/fulongfei/git_repo/2019nCoV_DBScan/scripts/parse_nextalign.pl /data/fulongfei/git_repo/2019nCoV_DBScan/test/2022-7-15.aligned.fasta /data/fulongfei/git_repo/2019nCoV_DBScan/test
