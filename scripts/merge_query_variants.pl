use strict;
use warnings;
use Getopt::Long;
use File::Basename;
use Data::Dumper;
use FindBin qw/$Bin/;


my ($query_var_dir,$outfile) = @ARGV;



# query sample
my @query_variants_file = glob "$query_var_dir/*.xls";
my @query_samples;
for my $file (@query_variants_file){
	my $name = (split /\./, basename $file)[0];
	push @query_samples, $name;
}


my %variants_per_sample;
my %union_variants;

foreach my $file (@query_variants_file){
	my $name = (split /\./, basename $file)[0];
	# read sample var
	open IN, "$file" or die;
	<IN>;
	while (<IN>){
		chomp;
		my @arr = split /\t/;
		my $chr = $arr[1];
		my $pos = $arr[2];
		my $ref = $arr[3];
		my $alt = $arr[4];

		my $var = "$chr\t$pos\t$ref\t$alt";
		$variants_per_sample{$name}{$var} = 1;
		$union_variants{$pos}{$var} = 1;
	}
	close IN;
}



open O, ">$outfile" or die;
print O "Chr\tPos\tRef\tAlt";
for my $name (@query_samples){
	print O "\t$name";
}
print O "\n";


foreach my $pos (sort {$a <=> $b} keys %union_variants){
	my @vars = keys %{$union_variants{$pos}};
	for my $var (@vars){
		my @if_call;
		for my $sample (@query_samples){
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