use strict;
use warnings;

# modify seq name
# change '>Sample 1277-1__2019-nCoV' into '>Sample_1277-1__2019-nCoV'

my ($input_fa,$out_fa) = @ARGV;

open O, ">$out_fa" or die;

#open IN, "$input_fa" or die;
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
close O;