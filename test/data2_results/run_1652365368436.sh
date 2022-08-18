perl /data/fulongfei/git_repo/h2019nCoV_DBScan/scripts/pre_process_input_fa.pl /data/fulongfei/git_repo/h2019nCoV_DBScan/test/data2/1652365368436.sequences.fasta /data/fulongfei/git_repo/h2019nCoV_DBScan/test/data2_results/input.concensus.fasta

cat /data/fulongfei/git_repo/h2019nCoV_DBScan/reference/Ion_AmpliSeq_SARS-CoV-2-Insight.Reference.fa /data/fulongfei/git_repo/h2019nCoV_DBScan/test/data2_results/input.concensus.fasta /data/fulongfei/git_repo/h2019nCoV_DBScan/database/2019nCoV.DB.CDC.fasta >/data/fulongfei/git_repo/h2019nCoV_DBScan/test/data2_results/input.aln.fasta

/data/fulongfei/git_repo/h2019nCoV_DBScan/bin/nextalign --sequences=/data/fulongfei/git_repo/h2019nCoV_DBScan/test/data2_results/input.aln.fasta --reference=/data/fulongfei/git_repo/h2019nCoV_DBScan/reference/Ion_AmpliSeq_SARS-CoV-2-Insight.Reference.fa --output-dir=/data/fulongfei/git_repo/h2019nCoV_DBScan/test/data2_results --output-basename=nextalign --in-order

perl /data/fulongfei/git_repo/h2019nCoV_DBScan/scripts/parse_nextalign.pl /data/fulongfei/git_repo/h2019nCoV_DBScan/test/data2_results/nextalign.aligned.fasta /data/fulongfei/git_repo/h2019nCoV_DBScan/test/data2_results/input.concensus.fasta /data/fulongfei/git_repo/h2019nCoV_DBScan/reference/Ion_AmpliSeq_SARS-CoV-2-Insight.Reference.fa /root/miniconda3/bin/samtools /data/fulongfei/git_repo/h2019nCoV_DBScan/test/data2_results/nextalign.insertions.csv /data/fulongfei/git_repo/h2019nCoV_DBScan/test/data2_results

perl /data/fulongfei/git_repo/h2019nCoV_DBScan/scripts/merge_query_variants.pl /data/fulongfei/git_repo/h2019nCoV_DBScan/test/data2_results/variants /data/fulongfei/git_repo/h2019nCoV_DBScan/test/data2_results/vcMerged.xls

perl /data/fulongfei/git_repo/h2019nCoV_DBScan/scripts/find_similar_db_seq_using_variants.pl /data/fulongfei/git_repo/h2019nCoV_DBScan/test/data2_results/variants /data/fulongfei/git_repo/h2019nCoV_DBScan/test/data2_results/variants/2019nCoV_DB_variants /data/fulongfei/git_repo/h2019nCoV_DBScan/test/data2_results/similarity.based_on_variant_calling.xls

perl /data/fulongfei/git_repo/h2019nCoV_DBScan/scripts/get_top10_most_similar_db_seq.pl /data/fulongfei/git_repo/h2019nCoV_DBScan/test/data2_results/similarity.based_on_variant_calling.xls /data/fulongfei/git_repo/h2019nCoV_DBScan/test/data2_results/similarity.based_on_variant_calling.top10.xls

