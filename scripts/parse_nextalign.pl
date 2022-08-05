use strict;
use warnings;
use Data::Dumper;
use FindBin qw/$Bin/;

my ($align_file,$outdir) = @ARGV;

my $align_file_name       = basename($align_file);
my $variants_file         = "$outdir/$align_file_name\.nextalign.variants.xls";
my $variants_summary_file = "$outdir/$align_file_name\.nextalign.variants.summary.xls";
my $similarity_file       = "$outdir/$align_file_name\.similarity.xls";


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
	my $seq_sample = $seq_info{$seq_name};

}


sub cmp_two_seq{
	my ($ref_seq,$query_seq) = @_;

	my $ref_len = length($ref_seq);
	my $query_len = length($query_seq);

	

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
