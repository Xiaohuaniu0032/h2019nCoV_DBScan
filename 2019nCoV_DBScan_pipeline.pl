use strict;
use warnings;
use Getopt::Long;
use File::Basename;
use Data::Dumper;
use FindBin qw/$Bin/;
use List::Util qw(sum);

my ($input_fa,$input_fa_name,$input_fa_meta_file,$hcov19_db_file,$samtools_bin,$if_docker_run,$outdir);

# longfei.fu
# 2022-8-4 QIXI

GetOptions(
	"fa:s"        => \$input_fa,            # Needed
	"n:s"         => \$input_fa_name,       # Needed
	"meta_f:s"    => \$input_fa_meta_file,  # Needed 
	"dbfile:s"    => \$hcov19_db_file,      # Needed
	"samtools:s"  => \$samtools_bin,        # Default: /usr/bin/samtools
	"dk!"         => \$if_docker_run,       # Optional
	"od:s"        => \$outdir,              # Needed
	) or die "Please check your args\n";


# default value
if (not defined $samtools_bin){
	$samtools_bin = "/root/miniconda3/bin/samtools"; # docker path
}

my $nextalign_bin = "$Bin/bin/nextalign";
my $ref_fasta     = "$Bin/reference/Ion_AmpliSeq_SARS-CoV-2-Insight.Reference.fa";



my $runsh = "$outdir/run\_$input_fa_name\.sh";
open O, ">$runsh" or die;

# process input fasta
my $processed_input_fa = "$outdir/input.concensus.fasta";
print O "perl $Bin/scripts/pre_process_input_fa.pl $input_fa $processed_input_fa\n\n";

# merge fa
my $merged_fa = "$outdir/input.aln.fasta";
print O "cat $ref_fasta $processed_input_fa $hcov19_db_file \>$merged_fa\n\n";

# do align
#if (!-d "$outdir/nextalign"){
#	`mkdir $outdir/nextalign`;
#}
print O "$nextalign_bin --sequences\=$merged_fa --reference\=$ref_fasta --output-dir\=$outdir --output-basename\=nextalign --in-order\n\n";

# parse aln file
my $aln_file = "$outdir/nextalign.aligned.fasta";
my $ins_file = "$outdir/nextalign.insertions.csv";

print O "perl $Bin/scripts/parse_nextalign.pl $aln_file $processed_input_fa $ref_fasta $samtools_bin $ins_file $outdir\n\n";

# merge query seq's variants
my $vcMerged_file = "$outdir/vcMerged.xls";
print O "perl $Bin/scripts/merge_query_variants.pl $outdir/variants $vcMerged_file\n\n";

# cal similarity based on variants calling
my $similar_file = "$outdir/similarity.based_on_variant_calling.xls";
print O "perl $Bin/scripts/find_similar_db_seq_using_variants.pl $outdir/variants $outdir/variants/2019nCoV_DB_variants $similar_file\n\n";

# output top10 most similar db seq info
my $top_10_file = "$outdir/similarity.based_on_variant_calling.top10.xls";
print O "perl $Bin/scripts/get_top10_most_similar_db_seq.pl $similar_file $top_10_file\n\n";

# vcMerge
my $query_sample_var_file = "$outdir/variants/variants.xls";
my $merged_file = "$outdir/vcMerged.xls";
#print O "perl $Bin/scripts/merge_two_sample_variants.pl $query_sample_var_file $top_10_file $outdir/variants/2019nCoV_DB_variants $merged_file\n";

close O;

`chmod 755 $runsh`;


# run auto if in docker env
if (defined $if_docker_run){
	`$runsh`;
	
	# make Rmd report if runing in docker
	`R -e "rmarkdown::render('/tools/Report_Rmd/h2019nCoV_DBScan.Rmd')"`;
	`mv /tools/Report_Rmd/h2019nCoV_DBScan.html /output/report.html`;
	# `cp /output/Ion-HBV.html /output/reports/Ion-HBV.html`;
	# `zip -r /output/results.zip /output/reports`;
}
