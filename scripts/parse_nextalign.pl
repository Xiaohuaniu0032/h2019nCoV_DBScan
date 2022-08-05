use strict;
use warnings;
use Data::Dumper;
use FindBin qw/$Bin/;

my ($align_file,$ins_file,$outdir) = @ARGV;

my $align_file_name       = basename($align_file);
my $variants_file         = "$outdir/$align_file_name\.nextalign.variants.xls";
my $variants_summary_file = "$outdir/$align_file_name\.nextalign.variants.summary.xls";
my $similarity_file       = "$outdir/$align_file_name\.similarity.xls";



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

for my $seq_name (@seq_name){
	next if ($seq_name eq "2019-nCoV");
	my $variants_file = "$outdir/variants/$seq_name\.variants.xls";

	# 变异位点
	open O, ">$variants_file" or die;

	my $q_seq = $seq_info{$seq_name};
	my $vars_aref = &cmp_two_seq($ref_seq_fa,$q_seq,\%ins_variants,$seq_name);
	for my $var (@{$vars_aref}){
		my @var = split /\:/, $var;
		my $new_var = join("\t",@var);
		print O "$seq_name\t$new_var\n"; 
	}
	close O;

	# 计算query seq长度
	my $q_seq_len = length($q_seq);

	# 计算query seq N个数/百分比
	my $N_num = 0;
	my $N_pct;

	my @q_seq = split //, $q_seq;
	for my $base (@q_seq){
		if ($base eq 'N'){
			$N_num += 1;
		}
	}

	if ($N_num > 0 and $q_seq_len > 0){
		$N_pct = sprintf "%.2f", $N_num / $q_seq_len * 100;
	}

	# 计算和ref fa相似度
	# match百分比




}


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

}


sub cal_N_pct{
	my ($query_seq) = @_;
}

sub cal_seq_len{

}





#print "@seq_name\n";

print O "Chr\tPos\t";

for my $seq (@seq_name){
	print O "\t$seq";
}
print O "\n";


my $ref_name = $seq_name[0];
my $ref_fa = $seq_info{$ref_name};

my $first_query_name = $seq_name[1];
my $first_query_seq  = $seq_info{$first_query_name};

my $len_ref = length($ref_fa);
my $len_query = length($first_query_seq);

my @ref_fa = split //, $ref_fa;
my @query_fa = split //, $first_query_seq;

# determine first and last ATCG base in query seq
#my @pos;
#my $pos_idx = 0;
#for my $base (@query_fa){
#	$pos_idx += 1;
#	if ($base =~ /[ATCG]/){
#		push @pos, $pos_idx;
#	}
#}

#print "@pos\n";

#my $start_pos = $pos[0];
#my $end_pos = $pos[-1];

#Protein	AA.Pos	DNA.Pos	DNA	AA	AA.Long
#Protease	1	2253-2255	CCT	P	Proline
#Protease	2	2256-2258	CAG	Q	Glutamine
#Protease	3	2259-2261	GTC	V	Valine
#...
#Integrase	287	5088-5090	GAG	E	Glutamic acid
#Integrase	288	5091-5093	GAT	D	Aspartic acid
#Integrase	289	5094-5096	TAG	Stop	Stop codons

my $start_pos = 2253; # 
my $end_pos   = 5096;

print "$start_pos\t$end_pos\n";

my %seq_NNN;
for my $name (@seq_name){
	my $seq = $seq_info{$name};
	my @seq = split //, $seq;
	$seq_NNN{$name} = \@seq;
}

for (my $i=0;$i<=$len_ref-1;$i++){
	my @nt; # 每个位置上,不同序列的碱基
	for my $name (@seq_name){
		my @base = @{$seq_NNN{$name}};
		my $base = $base[$i];
		push @nt, $base;
	}
	#print "@nt\n";

	my $ref_base = shift @nt;

	my $first_base = $nt[0];
	my $same_flag = 1;
	for my $base (@nt){
		if ($base ne $first_base){
			$same_flag = 0;
		}
	}

	my $if_same;
	if ($same_flag == 1){
		# all same
		$if_same = "Same";
	}else{
		$if_same = "NotSame";
	}

	my $idx = $i + 1;
	next if ($idx < $start_pos || $idx > $end_pos);
	my $base_str = join("\t",@nt);
	print O "K03455.1\t$idx\t$ref_base\t$base_str\t$if_same\n";
	#print "$idx\n";
}
close O;
