use strict;
use warnings;
use Getopt::Long;
use File::Basename;
use Data::Dumper;
use FindBin qw/$Bin/;
use List::Util qw(sum);

my ($input_fa,$input_fa_meta_file,$hcov19_db_file,$samtools_bin,$outdir);

# longfei.fu
# 2022-8-4 QIXI

GetOptions(
	"fa:s"        => \$input_fa,            # Needed
	"meta_f:s"    => \$input_fa_meta_file,  # Needed 
	"dbfile:s"    => \$hcov19_db_file,      # Needed
	"samtools:s"  => \$samtools_bin,        # Default: /usr/bin/samtools
	"od:s"        => \$outdir,              # Needed
	) or die "Please check your args\n";


# default value
if (not defined $samtools_bin){
	$samtools_bin = "/usr/bin/samtools";
}

my $nextalign_bin = "$Bin/bin/nextalign";
my $ref_fasta     = "$Bin/reference/Ion_AmpliSeq_SARS-CoV-2-Insight.Reference.fa";


# consensus fa样本信息

my @samples; # 1)remove >; 2) if seq_header has '\s+' or '/'
my %sample_fa;

my $seq_header;
open IN, "$input_fa" or die;
while (<IN>){
	chomp;
	next if /^$/;
	if (/^\>/){
		$seq_header = $_;
		$seq_header =~ s/^\>//;
		
		# >hCoV-19/Jiangxi/JXCDC-18/2022
		# >Sample 1277-1__2019-nCoV
		
		my $new_header;
		if ($seq_header =~ /\s+/){
			my @seq_header = split /\s+/, $seq_header;
			$new_header = join("_",@seq_header);
		}else{
			$new_header = $seq_header;
		}

		if ($new_header =~ /\//){
			my @new_header = split /\//, $new_header;
			$seq_header = join("_",@new_header);
		}else{
			$seq_header = $new_header;
		}

		push @samples, $seq_header;
	}else{
		push @{$sample_fa{$seq_header}}, $_;
	}
}
close IN;


# meta信息
my @col = qw/cons_fa_name virus collect_data seq_data province length host age sex Nextstrain_clade pangolin_lineage submitting_lab submitter/;

my %meta;
open META, "$input_fa_meta_file" or die;
my $meta_header = <META>;
chomp $meta_header;

while (<META>){
	chomp;
	my @arr = split /\t/;
	my $name = $arr[0];

	my $new_name;
	if ($name =~ /\s+/){
		my @name = split /\s+/, $name;
		$new_name = join("_",@name);
	}else{
		$new_name = $name;
	}

	my $final_name;
	if ($new_name =~ /\//){
		my @new_name = split /\//, $new_name;
		$final_name = join("_",@new_name);
	}else{
		$final_name = $new_name;
	}


	$meta{$final_name} = $_;
}
close META;





# 每个样本新建一个目录
for my $name (@samples){
	if (!-d "$outdir/$name"){
		`mkdir -p $outdir/$name`;
	}

	my @fa = @{$sample_fa{$name}};
	my $sample_fa = join("",@fa);

	# write sample fasta
	my $sample_fa_file = "$outdir/$name/$name\.fasta";
	
	open O, ">$sample_fa_file" or die;
	print O "\>$name\n";
	print O "$sample_fa";
	close O;

	# write meta info
	my $sample_meta_file = "$outdir/$name/$name\.metadata.csv";
	open O, ">$sample_meta_file" or die;
	if (exists $meta{$name}){
		my $info = $meta{$name};
		print O "$meta_header\n";
		print O "$info\n";
	}else{
		print O "NA\tNA\tNA\n";
	}
	close O;

	my $runsh = "$outdir/$name/runsh\_$name\.sh";

	open O, ">$runsh" or die;
	# merge fa
	my $merge_fa = "$outdir/$name/input.aln.fasta";
	print O "perl $Bin/scripts/prepare_input_fa_to_align.pl $ref_fasta $sample_fa_file $hcov19_db_file $merge_fa\n\n";

	# do align
	print O "$nextalign_bin --sequences\=$merge_fa --reference\=$ref_fasta --output-dir\=$outdir/$name --output-basename\=nextalign --in-order\n\n";

	# parse aln file
	my $aln_file = "$outdir/$name/nextalign.aligned.fasta";
	my $ins_file = "$outdir/$name/nextalign.insertions.csv";

	print O "perl $Bin/scripts/parse_nextalign.pl $aln_file $sample_fa_file $ref_fasta $samtools_bin $ins_file $outdir/$name\n\n";

	# cal similarity based on variants calling
	my $similar_file = "$outdir/$name/$name\.similarity.based_on_variant_calling.xls";
	print O "perl $Bin/scripts/find_similar_db_seq_using_variants.pl $outdir/$name/variants $outdir/$name/variants/2019nCoV_DB_variants $similar_file\n\n";


	# output top10 most similar db seq info
	my $top_10_file = "$outdir/$name/$name\.similarity.based_on_variant_calling.top10.xls";
	print O "perl $Bin/scripts/get_top10_most_similar_db_seq.pl $similar_file $top_10_file\n";
	close O;

	`chmod 755 $runsh`;
	#`$runsh`;

}