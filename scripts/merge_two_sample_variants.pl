use strict;
use warnings;
use Getopt::Long;
use File::Basename;
use Data::Dumper;
use FindBin qw/$Bin/;


my ($sample_variants_file,$sample_name,$top_ten_sim_file,$db_var_dir,$outfile) = @ARGV;

my @most_simimar_samples; # hCoV-19_Jiangxi_IVDC-557_2022
open IN, "$top_ten_sim_file" or die;
<IN>;
while (<IN>){
	chomp;
	my @arr = split /\t/;
	my $query_sample = $arr[0];
	my $db_sample = $arr[1];
	if ($query_sample eq $db_sample){
		next;
	}else{
		push @most_simimar_samples, $db_sample;
		#last;
	}
}
close IN;




my %variants_per_sample;
my %union_variants;

# read sample var
open IN, "$sample_variants_file" or die;
<IN>;
while (<IN>){
	chomp;
	my @arr = split /\t/;
	my $chr = $arr[1];
	my $pos = $arr[2];
	my $ref = $arr[3];
	my $alt = $arr[4];

	my $var = "$chr\t$pos\t$ref\t$alt";
	$variants_per_sample{$sample_name}{$var} = 1;
	$union_variants{$pos}{$var} = 1;
}
close IN;



# read db var
for my $db_sample (@most_simimar_samples){
	my $db_file = "$db_var_dir/$db_sample\.variants.xls";
	open IN, "$db_file" or die;
	<IN>;
	while (<IN>){
		chomp;
		my @arr = split /\t/;
		my $chr = $arr[1];
		my $pos = $arr[2];
		my $ref = $arr[3];
		my $alt = $arr[4];

		my $var = "$chr\t$pos\t$ref\t$alt";
		$variants_per_sample{$db_sample}{$var} = 1;
		$union_variants{$pos}{$var} = 1;
	}
	close IN;
}


open O, ">$outfile" or die;
print O "Chr\tPos\tRef\tAlt";
print O "\t$sample_name";
for my $db_sample (@most_simimar_samples){
	print O "\t$db_sample";
}
print O "\n";

my @all_sample;
push @all_sample, $sample_name;
for my $sample (@most_simimar_samples){
	push @all_sample, $sample;
}

foreach my $pos (sort {$a <=> $b} keys %union_variants){
	my @vars = keys %{$union_variants{$pos}};
	for my $var (@vars){
		my @if_call;
		for my $sample (@all_sample){
			my $flag;
			if (exists $variants_per_sample{$sample}{$var}){
				$flag = "Yes"; 
			}else{
				$flag = "No";
			}
			push @if_call, $flag;
		}
		print O "$var";
		for my $call (@if_call){
			print O "\t$call";
		}
		print O "\n";
	}
}

close O;