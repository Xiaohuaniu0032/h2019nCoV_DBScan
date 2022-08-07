perl /data/fulongfei/git_repo/h2019nCoV_DBScan/scripts/pre_process_input_fa.pl /data/fulongfei/git_repo/h2019nCoV_DBScan/test/data/Auto_SARS-CoV-2_Insight_Research_Panel_-_530-2022-7-15_torrent-server_107.consensus.fasta /data/fulongfei/git_repo/h2019nCoV_DBScan/test/consensus.fasta

perl /data/fulongfei/git_repo/h2019nCoV_DBScan/scripts/prepare_input_fa_to_align.pl /data/fulongfei/git_repo/h2019nCoV_DBScan/reference/Ion_AmpliSeq_SARS-CoV-2-Insight.Reference.fa /data/fulongfei/git_repo/h2019nCoV_DBScan/test/consensus.fasta /data/fulongfei/git_repo/h2019nCoV_DBScan/database/2019nCoV.DB.CDC.fasta /data/fulongfei/git_repo/h2019nCoV_DBScan/test/input.aln.fasta

/data/fulongfei/git_repo/h2019nCoV_DBScan/bin/nextalign --sequences=/data/fulongfei/git_repo/h2019nCoV_DBScan/test/input.aln.fasta --reference=/data/fulongfei/git_repo/h2019nCoV_DBScan/reference/Ion_AmpliSeq_SARS-CoV-2-Insight.Reference.fa --output-dir=/data/fulongfei/git_repo/h2019nCoV_DBScan/test --output-basename=2022-7-15 --in-order

perl /data/fulongfei/git_repo/h2019nCoV_DBScan/scripts/parse_nextalign.pl /data/fulongfei/git_repo/h2019nCoV_DBScan/test/2022-7-15.aligned.fasta /data/fulongfei/git_repo/h2019nCoV_DBScan/test/consensus.fasta /data/fulongfei/git_repo/h2019nCoV_DBScan/reference/Ion_AmpliSeq_SARS-CoV-2-Insight.Reference.fa /usr/bin/samtools /data/fulongfei/git_repo/h2019nCoV_DBScan/test/2022-7-15.insertions.csv /data/fulongfei/git_repo/h2019nCoV_DBScan/test

perl /data/fulongfei/git_repo/h2019nCoV_DBScan/scripts/find_similar_db_seq_using_variants.pl /data/fulongfei/git_repo/h2019nCoV_DBScan/test/variants /data/fulongfei/git_repo/h2019nCoV_DBScan/test/variants/2019nCoV_DB_variants /data/fulongfei/git_repo/h2019nCoV_DBScan/test/2022-7-15.similarity.based_on_variant_calling.xls

perl /data/fulongfei/git_repo/h2019nCoV_DBScan/scripts/get_top10_most_similar_db_seq.pl /data/fulongfei/git_repo/h2019nCoV_DBScan/test/2022-7-15.similarity.based_on_variant_calling.xls /data/fulongfei/git_repo/h2019nCoV_DBScan/test/2022-7-15.similarity.based_on_variant_calling.top10.xls
