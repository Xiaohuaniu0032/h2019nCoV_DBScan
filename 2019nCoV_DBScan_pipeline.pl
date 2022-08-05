use strict;
use warnings;
use Getopt::Long;
use File::Basename;
use Data::Dumper;
use FindBin qw/$Bin/;
use List::Util qw(sum);

my ($input_fa,$hcov19_db_dir,$fa_name,$outdir);

# longfei.fu
# 2022-8-4 QIXI

GetOptions(
	"fa:s"     => \$input_fa,            # Needed
	"dbdir:s"  => \$hcov19_db_dir,       # Needed
	"faname:s"  => \$fa_name,            # Needed
	"od:s"     => \$outdir,              # Needed
	) or die "Please check your args\n";

my $nextalign_bin = "$Bin/bin/nextalign";
my $ref_fasta     = "$Bin/reference/Ion_AmpliSeq_SARS-CoV-2-Insight.Reference.fa";

my $runsh = "$outdir/runsh\_$fa_name\.sh";


my @db = glob "$hcov19_db_dir/*.fasta";
print "hcov19_db_file:\n";
for my $file (@db){
	print "\t$file\n";
}
my $db_file = $db[0];


open O, ">$runsh" or die;
# modify seq header
my $new_input_fa = "$outdir/consensus.fasta";
print O "perl $Bin/scripts/pre_process_input_fa.pl $input_fa $new_input_fa\n\n";

# merge fa
my $merge_fa = "$outdir/input.aln.fasta";
print O "perl $Bin/scripts/prepare_input_fa_to_align.pl $ref_fasta $new_input_fa $db_file $merge_fa\n\n";

# do align
print O "$nextalign_bin --sequences\=$merge_fa --reference\=$ref_fasta --output-dir\=$outdir --output-basename\=$fa_name --in-order\n\n";

# parse aln file
my $aln_file = "$outdir/$fa_name\.aligned.fasta";
print O "perl $Bin/scripts/parse_nextalign.pl $aln_file $outdir\n";

`chmod 755 $runsh`;

close O;