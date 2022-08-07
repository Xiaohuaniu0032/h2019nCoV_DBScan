use strict;
use warnings;
use Getopt::Long;
use File::Basename;
use Data::Dumper;
use FindBin qw/$Bin/;

my ($similar_file,$top10_outfile) = @ARGV;


open O, ">$top10_outfile" or die;

my %sim;
my %sim_detail;
open IN, "$similar_file" or die;
my $h = <IN>;
chomp $h;
print O "$h\n";

while (<IN>){
	chomp;
	my @arr = split /\t/, $_;
	my $query_name = $arr[0];
	my $db_name    = $arr[1];
	my $val = "$db_name\t$arr[-1]";
	push @{$sim{$query_name}}, $val;


	my $name_name = "$query_name\t$db_name";
	$sim_detail{$name_name} = $_;
}
close IN;







foreach my $query_name (keys %sim){
	my @info = @{$sim{$query_name}};
	
	my %info;
	for my $info (@info){
		my @val = split /\t/, $info;
		$info{$val[0]} = $val[1];
	}

	my $flag = 0;
	foreach my $key (sort {$info{$b} <=> $info{$a}} keys %info){
		my $name_name = "$query_name\t$key";
		# 按共有百分比由大->小排序
		$flag += 1;
		if ($flag <= 10){
			my $detail = $sim_detail{$name_name};
			print O "$detail\n";
		}
	}
}
close O;

