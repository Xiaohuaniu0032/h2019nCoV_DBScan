# meta信息
my @col = qw/cons_fa_name virus collect_data seq_data province length host age sex Nextstrain_clade pangolin_lineage submitting_lab submitter/;

my %meta;
open META, "$input_fa_meta_file" or die;
my $meta_header = <META>;
chomp $meta_header;

while (<META>){
	chomp;
	my @arr = split /\t/;
	my $name = $arr[0];

	my $new_name;
	if ($name =~ /\s+/){
		my @name = split /\s+/, $name;
		$new_name = join("_",@name);
	}else{
		$new_name = $name;
	}

	my $final_name;
	if ($new_name =~ /\//){
		my @new_name = split /\//, $new_name;
		$final_name = join("_",@new_name);
	}else{
		$final_name = $new_name;
	}


	$meta{$final_name} = $_;
}
close META;
