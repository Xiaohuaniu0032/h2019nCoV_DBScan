use strict;
use warnings;

# 处理输入的consensus fasta
# 输入fasta支持多行或一行

# change '>Sample 1277-1__2019-nCoV' into '>Sample_1277-1__2019-nCoV'

my ($input_fa,$out_fa) = @ARGV;

open O, ">$out_fa" or die;

open IN, "$input_fa" or die;
while (<IN>){
	chomp;
	next if /^$/;
	if (/^\>/){
		$seq_header = $_;
		$seq_header =~ s/^\>//;
		
		# >hCoV-19/Jiangxi/JXCDC-18/2022
		# >Sample 1277-1__2019-nCoV
		
		my $new_header; # 空格
		if ($seq_header =~ /\s+/){
			my @seq_header = split /\s+/, $seq_header;
			$new_header = join("_",@seq_header);
		}else{
			$new_header = $seq_header;
		}

		if ($new_header =~ /\//){ # 名称包含'/'
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


open O, ">$out_fa" or die;
for my $name (@samples){
	my @fa = @{$sample_fa{$name}};
	my $sample_fa = join("",@fa);

	
	print O "\>$name\n";
	print O "$sample_fa";
}
close O;