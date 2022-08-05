use strict;
use warnings;
use Data::Dumper;
use FindBin qw/$Bin/;

my ($align_file,$cons_fa,$ins_file,$outdir) = @ARGV;

my $align_file_name       = basename($align_file);
my $variants_summary_file = "$outdir/$align_file_name\.nextalign.variants.summary.xls";
my $similarity_file       = "$outdir/$align_file_name\.similarity.xls";
my $qc_file               = "$outdir/$align_file_name\.qc.xls";


open SUMMARY, ">$variants_summary_file" or die;
print SUMMARY "Sample\tVariants_Num\tSNP_Num\tInsertion_Num\tDeletion_Num\n";

open SIM, ">$similarity_file" or die;
print SIM "Sample\t2019nCoV_Database_Seq\tSimilarity\n";

open QC, ">$qc_file" or die;
print QC "Sample\tConsensus_fa_len\tRef_fa_len\tN_num\tN_pct";


my @cons_name;
my %cons_fa;
my $name;

open CONS, "$cons_fa" or die;
while (<CONS>){
	chomp;
	if (/^\>/){
		$name = $_;
		$name =~ s/^\>//;
		push @cons_name, $name;
	}else{
		$cons_fa{$name} = $_;
	}
}
close CONS;

# insertion信息
# 2022-7-15.insertions.csv
my %ins_variants;
open INS, "$ins_file" or die;
<INS>; # header
while (<INS>){
	chomp;
	next if /^$/;
	my @arr = split /\,/, $_;
	my $name = $arr[0];
	$name =~ s/^\"//;
	$name =~ s/\"$//;
	
	my $ins_info = $arr[1];
	# "hCoV-19/Henan/IVDC-570/2022","22204:GAGCCAGAA",""
	# "hCoV-19/Zhejiang/IVDC-572/2022","22204:GAGCCAGAA;29793:C",""

	if ($ins_info =~ /\;/){
		# 多个ins
		my @ins = split /\;/, $ins_info;
		for my $ins (@ins){
			my @val = split /\:/, $ins;
			my $pos = $val[0];
			my $nnn = $val[1];
			my $var = "$ref_seq_name\:$pos\:\-\:$nnn";
			push @{$ins_variants{$name}}, $var;
		}
	}elsif ($ins_info =~ /\:/){
		my @val = split /\:/, $ins_info;
		my $pos = $val[0];
		my $nnn = $val[1];
		my $var = "$ref_seq_name\:$pos\:\-\:$nnn";
		push @{$ins_variants{$name}}, $var;
	}else{
		# no ins
		next;
	}
}
close INS;



my @seq_name;
my %seq_info;

open IN, "$align_file" or die;
while (<IN>){
	chomp;
	my $header = $_;
	$header =~ s/^\>//;# header
	my $seq = <IN>;    # seq
	chomp $seq;
	push @seq_name, $header;
	$seq_info{$header} = $seq;
}
close IN;


if (!-d "$outdir/variants"){
	`-d $outdir/variants`;
}

my $ref_seq_name  = "2019-nCoV";
my $ref_seq_fa    = $seq_info{$ref_seq_name};
my $ref_seq_len   = length($ref_seq_fa);

# 1) variants info [only cal vars info for query seq]
for my $query_name (@cons_name){
	my $query_seq = $cons_fa{$query_name};
	my $vars_aref = &cmp_two_seq($ref_seq_fa,$query_seq,\%ins_variants,$query_name);
	
	my $variants_file = "$outdir/variants/$query_name\.variants.xls";
	open O, ">$variants_file" or die;
	
	for my $var (@{$vars_aref}){
		my @var = split /\:/, $var;
		my $new_var = join("\t",@var);
		print O "$seq_name\t$new_var\n";
	}
	close O;
}

# 2) variants summary

# 3) cal QC for query seq
for my $query_name (@cons_name){
	my $query_seq = $cons_fa{$query_name};

	# 计算query seq长度
	my $query_seq_len = length($query_seq);

	# 计算query seq N个数/百分比
	my $N_num = 0;
	my $N_pct;

	my @query_seq = split //, $query_seq;
	for my $base (@query_seq){
		if ($base eq 'N'){
			$N_num += 1;
		}
	}

	if ($N_num > 0 and $q_seq_len > 0){
		$N_pct = sprintf "%.2f", $N_num / $q_seq_len * 100;
	}

	# 计算有效区间
	#my $eff_pos_reg_aref = &get_eff_pos_region($ref_seq_fa,$query_seq);
	#my $eff_pos_start = $eff_pos_reg_aref->[0];
	#my $eff_pos_end   = $eff_pos_reg_aref->[1];

	print QC "$query_name\t$query_seq_len\t$ref_seq_len\t$N_num\t$N_pct\n";
}
close QC;

# 4) get top 10 most similar database sequences
for my $query_name (@cons_name){
	my $query_seq = $cons_fa{$query_name};
my $sim = &cal_similarity($ref_seq_fa,$q_seq,$eff_pos_start,$eff_pos_end);
	$similarity{$seq_name} = $sim;

# 3) cal QC for query seq
for my $query_name (@cons_name){
	my $query_seq = $cons_fa{$query_name};

	# 计算query seq长度
	my $query_seq_len = length($query_seq);

	# 计算query seq N个数/百分比
	my $N_num = 0;
	my $N_pct;

	my @query_seq = split //, $query_seq;
	for my $base (@query_seq){
		if ($base eq 'N'){
			$N_num += 1;
		}
	}

	if ($N_num > 0 and $q_seq_len > 0){
		$N_pct = sprintf "%.2f", $N_num / $q_seq_len * 100;
	}

	# 计算有效区间
	#my $eff_pos_reg_aref = &get_eff_pos_region($ref_seq_fa,$query_seq);
	#my $eff_pos_start = $eff_pos_reg_aref->[0];
	#my $eff_pos_end   = $eff_pos_reg_aref->[1];

	print QC "$query_name\t$query_seq_len\t$ref_seq_len\t$N_num\t$N_pct\n";
}
close QC;




############################################################
#########################Sub Func###########################
############################################################

sub cmp_two_seq{
	my ($ref_seq,$query_seq,$ins_info_href,$query_name) = @_;

	my $ref_len = length($ref_seq);
	my $query_len = length($query_seq);


	my @variants; # return value

	#确认query序列首尾非N位置
	my $eff_pos;

	my @ref_seq   = split //, $ref_seq;
	my @query_seq = split //, $query_seq;

	my $idx = 0;
	for my $base (@query_seq){
		$idx += 1;
		if ($base ne "-"){
			push @eff_pos, $idx;
		}
	}

	my $eff_pos_start = $eff_pos[0]; # 1-based
	my $eff_pos_end   = $eff_pos[1];

	$idx = 0;
	for my $base (@ref_seq){
		$idx += 1;
		if ($idx < $eff_pos_start || $idx > $eff_pos_end){
			next; # 有效区间之外
		}

		my $pos = $idx - 1; # 0-based
		my $ref_base = $ref_seq[$pos];
		my $query_base = $query_seq[$pos];

		
		#my @deletion; # 合并相连的del
		
		# 检查变异位点
		if ($query_base =~ /[ATCG]/){
			if ($query_base ne $ref_base){
				# snp
				my $var = "$ref_seq_name\:$idx\t$ref_base\:$query_base"; # chr/pos/ref/alt
				push @variants, $var;
			}
		}elsif ($query_base eq "-"){
			# deletion
			my $var = "$ref_seq_name\:$idx\t$ref_base\:\-";
			push @variants, $var;
		}else{
			next;
		}
	
		# add insertion
		my %ins_info = %{$ins_info_href};
		if (exists $ins_info{$query_name}){
			my @ins_info = @{$ins_info{$query_name}};
			for my $var (@ins_info){
				push @variants, $var;
			}
		}
	}

	return(\@variants);
}



sub cal_similarity{
	# https://www.ncbi.nlm.nih.gov/books/NBK62051/
	# raw score OR similarity
	my ($ref_seq,$query_seq,$eff_pos_start,$eff_pos_end) = @_;

	my $eff_region_len = $eff_pos_end - $eff_pos_start + 1;
	
	my $start_pos = $eff_pos_start - 1; # 0-based
	my $sub_ref_seq = substr($ref_seq, $start_pos, $eff_region_len);
	my $sub_query_seq = substr($query_seq, $start_pos, $eff_region_len);

	my @sub_ref_seq = split //, $sub_ref_seq;
	my @sub_query_seq = split //, $sub_query_seq;

	# 计算相似性
	my $match_n = 0;

	my $idx = 0;
	for my $base (@sub_ref_seq){
		my $ref_base = $sub_ref_seq[$idx];
		my $query_base = $sub_query_seq[$idx];
		if ($ref_base eq $query_base){
			$match_n += 1;
		}
		$idx += 1;
	}

	my $similarity;
	if ($match_n > 0 and $eff_region_len > 0){
		$similarity = sprintf "%.2f", $match_n / $eff_region_len * 100;
	}else{
		$similarity = 0;
	}

	return($similarity);
}


sub get_eff_pos_region{
	my ($ref_seq,$query_seq) = @_;

	my $ref_len = length($ref_seq);
	my $query_len = length($query_seq);

	#确认query序列首尾非N位置
	my $eff_pos;

	my @ref_seq   = split //, $ref_seq;
	my @query_seq = split //, $query_seq;

	my $idx = 0;
	for my $base (@query_seq){
		$idx += 1;
		if ($base ne "-"){
			push @eff_pos, $idx;
		}
	}

	# my $eff_pos_start = $eff_pos[0]; # 1-based
	# my $eff_pos_end   = $eff_pos[1];

	return(\@eff_pos);
}
