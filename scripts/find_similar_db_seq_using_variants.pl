use strict;
use warnings;
use Data::Dumper;
use FindBin qw/$Bin/;
use File::Basename;


my ($sample_variants_dir,$db_var_dir,$outfile) = @ARGV;

open O, ">$outfile" or die;
print O "query_seq_name\tdb_seq_name\tquery_seq_var_num\tdb_seq_var_num\tquery_seq_uniq_var_num\tdb_seq_uniq_var_num\tboth_var_num\ttotal_uniq_var_num\tbothVar_to_uniqVar_pct\n";

my @query_var_file = glob "$sample_variants_dir/*.variants.xls";

my %sample_var;
for my $file (@query_var_file){
	my $name = (split /\./, basename($file))[0];
	open IN, "$file" or die;
	<IN>;
	while (<IN>){
		chomp;
		my @arr = split /\t/;
		my $pos = $arr[2];
		my $ref = $arr[3];
		my $alt = $arr[4];
		my $var = "$pos\t$ref\t$alt"; # pos/ref/alt
		$sample_var{$name}{$var} = 1;
	}
	close IN;
}

my %db_vars;
my @db_var_files = glob "$db_var_dir/*.variants.xls";
my @db_sample_name;


for my $file (@db_var_files){
	my $name = (split /\./, basename($file))[0]; # hCoV-19_Fujian_2022XG-2042_2022.variants.xls => hCoV-19_Fujian_2022XG-2042_2022
	push @db_sample_name, $name;
	open IN, "$file" or die;
	<IN>;
	while (<IN>){
		chomp;
		my @arr = split /\t/;
		my $pos = $arr[2];
		my $ref = $arr[3];
		my $alt = $arr[4];
		my $var = "$pos\t$ref\t$alt"; # pos/ref/alt
		$db_vars{$name}{$var} = 1;
	}
	close IN;
}


foreach my $query_name (keys %sample_var){
	my @query_vars = keys %{$sample_var{$query_name}};
	my $query_var_num = scalar(@query_vars);

	for my $db_name (@db_sample_name){
		my @db_vars = keys %{$db_vars{$db_name}};
		my $db_var_num = scalar(@db_vars);

		# 突变的并集
		my %uniq_vars_both;
		for my $var (@query_vars){
			$uniq_vars_both{$var} = 1;
		}

		for my $var (@db_vars){
			$uniq_vars_both{$var} = 1;
		}

		my $query_uniq = 0;
		my $db_uniq    = 0;
		my $both       = 0;

		foreach my $var (keys %uniq_vars_both){
			if (exists $sample_var{$query_name}{$var} and exists $db_vars{$db_name}{$var}){
				$both += 1;
			}
			if (exists $sample_var{$query_name}{$var} and not exists $db_vars{$db_name}{$var}){
				$query_uniq += 1;
			}
			if (not exists $sample_var{$query_name}{$var} and exists $db_vars{$db_name}{$var}){
				$db_uniq += 1;
			}
		}

		my $both_to_all_pct; # 共有突变占并集突变的百分比
		my $uniq_var_num = $query_uniq + $db_uniq + $both;

		if ($both > 0 and $uniq_var_num > 0){
			$both_to_all_pct = sprintf "%.2f", $both / $uniq_var_num * 100;
		}else{
			$both_to_all_pct = 0;
		}

		#print O "query_seq_name\tquery_seq_var_num\tdb_seq_name\tdb_seq_var_num\tquery_seq_uniq_var_num\tdb_seq_uniq_var_num\tboth_var_num\tbothVar_to_uniqVar_pct\n";
		print O "$query_name\t$db_name\t$query_var_num\t$db_var_num\t$query_uniq\t$db_uniq\t$both\t$uniq_var_num\t$both_to_all_pct\n";
	}
}
close O;
