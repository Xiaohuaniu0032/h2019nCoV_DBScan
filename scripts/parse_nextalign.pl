use strict;
use warnings;
use Data::Dumper;
use FindBin qw/$Bin/;
use File::Basename;



my ($align_file,$cons_fa,$ref_fa_file,$samtools_bin,$ins_file,$outdir) = @ARGV;


my $variants_summary_file = "$outdir/variants.summary.xls";
my $similarity_file       = "$outdir/similarity.xls";
my $qc_file               = "$outdir/fasta.qc.xls";


open SUMMARY, ">$variants_summary_file" or die;
print SUMMARY "Query_Seq\tVariants_Num\tSNP_Num\tInsertion_Num\tDeletion_Num\n";

open SIM, ">$similarity_file" or die;
print SIM "Query_Seq\t2019nCoV_Database_Seq\tSimilarity\tMacth_Num\tEff_length\n";

open QC, ">$qc_file" or die;
print QC "Query_Seq\tConsensus_fa_len\tRef_fa_len\tN_num\tN_pct\n";


########### nextalign info ############
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

########### ref fasta info ############
my $ref_seq_name  = "2019-nCoV";
my $ref_seq_fa    = $seq_info{$ref_seq_name};
my $ref_seq_len   = length($ref_seq_fa);



######################### insertion info ########################
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
	$ins_info =~ s/^\"//;
	$ins_info =~ s/\"$//;
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
			#push @{$ins_variants{$name}}, $var;
			$ins_variants{$pos} = $var;
		}
	}elsif ($ins_info =~ /\:/){
		my @val = split /\:/, $ins_info;
		my $pos = $val[0];
		my $nnn = $val[1];
		my $var = "$ref_seq_name\:$pos\:\-\:$nnn";
		#push @{$ins_variants{$name}}, $var;
		$ins_variants{$pos} = $var;
	}else{
		# no ins
		next;
	}
}
close INS;

#print(Dumper(\%ins_variants));




########## query seq info #############
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



if (!-d "$outdir/variants"){
	`mkdir -p $outdir/variants`;
}


################### variants info ###################
# only cal vars info for query seq
for my $query_name (@cons_name){
	my $query_seq = $seq_info{$query_name};
	#print "query_name\t$query_seq\n";

	my $query_seq_len = length($query_seq);
	print "query_seq_len:$query_seq_len\n";
	print "ref_seq_len:$ref_seq_len\n";

	# 计算有效区间
	my $eff_pos_reg_aref = &get_eff_pos_region($ref_seq_fa,$query_seq);
	my $eff_pos_start = $eff_pos_reg_aref->[0];
	my $eff_pos_end   = $eff_pos_reg_aref->[1];

	print "eff_region:$eff_pos_start\t$eff_pos_end\n";

	my $vars_href = &cmp_two_seq($ref_seq_fa,$query_seq,\%ins_variants,$query_name,$eff_pos_start,$eff_pos_end);
	
	my $variants_file = "$outdir/variants/$query_name\.variants.xls";
	open O, ">$variants_file" or die;
	print O "Sample\tChr\tPos\tRef\tAlt\n";
	
	foreach my $pos (sort {$a <=> $b} keys %{$vars_href}){
		my $var = $vars_href->{$pos};
		my @var = split /\:/, $var;
		my $new_var = join("\t",@var); # use tab sep
		print O "$query_name\t$new_var\n";
	}
	close O;

	# variants summary
	my ($var_num,$snp_num,$ins_num,$del_num) = (0,0,0,0);
	
	for my $pos (keys %{$vars_href}){
		#print "$var\n";
		my $var = $vars_href->{$pos};
		$var_num += 1;
		# chr/pos/ref/alt
		my @val = split /\:/, $var;
		my $ref = $val[2];
		my $alt = $val[3];

		if ($ref =~ /[ATCG]/ and $alt =~ /[ATCG]/){
			# snp
			$snp_num += 1;
		}

		if ($ref eq "-"){
			# ins
			$ins_num += 1;
		}

		if ($alt eq "-"){
			# del
			$del_num += 1;
		}
	}

	print SUMMARY "$query_name\t$var_num\t$snp_num\t$ins_num\t$del_num\n";
}
close SUMMARY;

# wirte database seq's var
if (!-d "$outdir/variants/2019nCoV_DB_variants"){
	`mkdir -p $outdir/variants/2019nCoV_DB_variants`;
}

for my $name (@seq_name){
	next if ($name eq $ref_seq_name); # skip ref
	next if (exists $cons_fa{$name}); # skip query seq

	my $db_seq = $seq_info{$name};
	#print "query_name\t$query_seq\n";

	my $db_seq_len = length($db_seq);
	

	# 计算有效区间
	my $eff_pos_reg_aref = &get_eff_pos_region($ref_seq_fa,$db_seq);
	my $eff_pos_start = $eff_pos_reg_aref->[0];
	my $eff_pos_end   = $eff_pos_reg_aref->[1];

	#print "eff_region:$eff_pos_start\t$eff_pos_end\n";

	my $vars_href = &cmp_two_seq($ref_seq_fa,$db_seq,\%ins_variants,$name,$eff_pos_start,$eff_pos_end);
	
	# hCoV-19/Heilongjiang/IVDC-HH-391/2021
	# 处理名称
	my $new_name;
	if ($name =~ /\//){
		my @val = split /\//, $name;
		$new_name = join("_",@val);
	}else{
		$new_name = $name;
	}

	my $variants_file = "$outdir/variants/2019nCoV_DB_variants/$new_name\.variants.xls";
	open O, ">$variants_file" or die;
	print O "Sample\tChr\tPos\tRef\tAlt\n";
	
	foreach my $pos (sort {$a <=> $b} keys %{$vars_href}){
		my $var = $vars_href->{$pos};
		my @var = split /\:/, $var;
		my $new_var = join("\t",@var); # use tab sep
		print O "$name\t$new_var\n";
	}
	close O;
}


#################### get top 10 most similar database sequences ###################
for my $query_name (@cons_name){
	my %similarity;
	my %similarity_detail;

	my $query_seq = $seq_info{$query_name};
	my $query_seq_len = length($query_seq);

	for my $seq_name (@seq_name){
		next if ($seq_name eq $ref_seq_name);
		next if ($seq_name eq $query_name);

		# 计算有效区间
		my $eff_pos_reg_aref = &get_eff_pos_region($ref_seq_fa,$query_seq);
		my $eff_pos_start = $eff_pos_reg_aref->[0];
		my $eff_pos_end   = $eff_pos_reg_aref->[1];
		
		my $sim_aref = &cal_similarity($ref_seq_fa,$query_seq,$eff_pos_start,$eff_pos_end);
		my @sim_info = @{$sim_aref};
		my $sim_info = join("\t",@sim_info);

		my $sim_val = $sim_info[0];
		my $macth_n = $sim_info[1];
		my $eff_reg_len = $sim_info[2];

		$similarity{$seq_name} = $sim_val;
		$similarity_detail{$seq_name} = $sim_info;
	}

	#my @val; # return value
	#push @val, $similarity;
	#push @val, $match_n;
	#push @val, $eff_region_len;

	my $flag = 0;
	foreach my $seq_name (sort {$similarity{$b} <=> $similarity{$a}} keys %similarity){
		$flag += 1;
		my $sim = $similarity{$seq_name};
		my $sim_detail = $similarity_detail{$seq_name};
		if ($flag <= 10){
			print SIM "$query_name\t$seq_name\t$sim_detail\n";
		}
	}
}
close SIM;



###################### cal QC for query seq ##########################
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

	if ($N_num > 0 and $query_seq_len > 0){
		$N_pct = sprintf "%.2f", $N_num / $query_seq_len * 100;
	}else{
		$N_pct = 0;
	}

	print QC "$query_name\t$query_seq_len\t$ref_seq_len\t$N_num\t$N_pct\n";
}
close QC;



####################### output database basic info #########################







############################################################
#########################Sub Func###########################
############################################################

sub cmp_two_seq{
	my ($ref_seq,$query_seq,$ins_info_href,$query_name,$eff_pos_start,$eff_pos_end) = @_;

	my $ref_len = length($ref_seq);
	my $query_len = length($query_seq);


	my %variants; # return value

	my @ref_seq   = split //, $ref_seq;
	my @query_seq = split //, $query_seq;

	my @del_pos; 
	# [11288,11289,11290,11291,11292,11293,11294,11295,11296,21633,21634,21635,21636,21637,21638,21639,21640,21641]
	# ref/11288/TCTGGTTTT/-
	# ref/21633/TACCCCCTG/-

	my $idx = 0;
	
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
				my $var = "$ref_seq_name\:$idx\:$ref_base\:$query_base"; # chr/pos/ref/alt
				#push @variants, $var;
				$variants{$idx} = $var;

			}
		}elsif ($query_base eq "-"){
			# deletion
			push @del_pos, $idx;
			#my $var = "$ref_seq_name\:$idx\:$ref_base\:\-";
			#push @variants, $var;
		}else{
			next;
		}
	}



	my $del_pos_num = scalar(@del_pos);
	#print "del_pos: @del_pos\n";

	if ($del_pos_num > 0){
		# merge del pos
		my %del_segment;
		my $seg_flag = 1;
		my $seg_str = "seg"."_".$seg_flag; # seg_1

		# 11288_11289_11290_11291_11292_11293_11294_11295_11296
	
		my $former_pos = shift @del_pos;
		push @{$del_segment{$seg_str}}, $former_pos;

		for my $pos (@del_pos){
			if ($pos - $former_pos == 1){			
				push @{$del_segment{$seg_str}},$pos;
				$former_pos = $pos;
			}else{
				# 不连续的位置
				$seg_flag += 1;
				$seg_str = "seg"."_".$seg_flag;
				$former_pos = $pos;
				push @{$del_segment{$seg_str}}, $former_pos;
				next;
			}
		}

		#print "$query_name\n";
		#print(Dumper(\%del_segment));
	
		
		foreach my $seg (keys %del_segment){
			my @pos = @{$del_segment{$seg}};
			my $del_num = scalar(@pos);
		
			my $start_pos;
			my $end_pos;

			if ($del_num == 1){
				$start_pos = $pos[0];
				$end_pos   = $pos[0];
			}else{
				$start_pos = $pos[0];
				$end_pos   = $pos[-1];
			}

			my $target = "$ref_seq_name\:$start_pos\-$end_pos";
			#print "$query_name\tdel_target:$target\n";
			my $ref_base = (split /\n/, `$samtools_bin faidx $ref_fa_file $target`)[1];
			my $var = "$ref_seq_name\:$start_pos\:$ref_base\:\-"; # chr/pos/ref/alt
			#push @variants, $var;
			$variants{$start_pos} = $var;
		}
	}

	
	# add insertion
	my %ins_info = %{$ins_info_href};
	if (exists $ins_info{$query_name}){
		my @ins_info = @{$ins_info{$query_name}};
		for my $var (@ins_info){
			#print "$var\n";
			#push @variants, $var;
			my $pos = (split /\:/, $var)[1];
			$variants{$pos} = $var;
		}
	}

	return(\%variants);
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

	my @val; # return value
	push @val, $similarity;
	push @val, $match_n;
	push @val, $eff_region_len;

	return(\@val);
}


sub get_eff_pos_region{
	my ($ref_seq,$query_seq) = @_;

	my $ref_len = length($ref_seq);
	my $query_len = length($query_seq);

	#确认query序列首尾非N位置
	my @ref_seq   = split //, $ref_seq;
	my @query_seq = split //, $query_seq;

	my @pos;
	my $idx = 0;
	for my $base (@query_seq){
		$idx += 1;
		if ($base ne "-"){
			push @pos, $idx;
		}
	}

	my $pos_start = $pos[0]; # 1-based
	my $pos_end   = $pos[-1];

	my @eff_pos;
	push @eff_pos, $pos_start;
	push @eff_pos, $pos_end;

	return(\@eff_pos);
}
