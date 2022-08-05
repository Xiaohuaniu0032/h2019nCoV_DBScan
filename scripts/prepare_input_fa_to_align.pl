use strict;
use warnings;
use Data::Dumper;
use FindBin qw/$Bin/;
use File::Basename;



my ($ref_fa,$input_fa,$db_fa,$out_fa) = @ARGV;

open O, ">$out_fa" or die;


# write ref fasta
open REF, "$ref_fa";
while (<REF>){
	chomp;
	next if /^$/;
	print O "$_\n";
}
close REF;

# write input_fa [generateConsensus.fasta]
# generateConsensus.fasta is in one line format

open IN, "$input_fa" or die;
while (<IN>){
	chomp;
	next if (/^$/);
	my $header = $_;
	if ($header =~ /\s+/){
		my @header = split /\s+/, $header;
		my $new_header = join("_",@header);
		print O "$new_header\n";
	}else{
		print O "$header\n";
	}

	my $seq = <IN>;
	chomp $seq;
	print O "$seq\n";
}
close IN;

# write db_fa
my %db_fa;
my $new_seq_name;
my @seq_name;

open DB, "$db_fa" or die;
while (<DB>){
	chomp;
	next if (/^$/);
	if (/\>/){
		my $seq_name = $_;
		if ($seq_name =~ /\s+/){
			my @seq_name = split /\s+/, $seq_name;
			$new_seq_name = join("_",@seq_name);
		}else{
			$new_seq_name = $seq_name;
		}
		push @seq_name, $new_seq_name; # by db seq order
	}else{
		push @{$db_fa{$new_seq_name}}, $_;
	}
}
close DB;

for my $seq (@seq_name){
	my @fa = @{$db_fa{$seq}};
	my $fa = join("",@fa);
	print O "$seq\n$fa\n";
}

close DB;
close O;