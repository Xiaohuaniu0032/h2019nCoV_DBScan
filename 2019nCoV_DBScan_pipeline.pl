use strict;
use warnings;
use Getopt::Long;
use File::Basename;
use Data::Dumper;
use FindBin qw/$Bin/;
use List::Util qw(sum);

my ($input_fa,$hcov19_db_dir,$hcov19_db_name,$fa_name,$outdir);

# longfei.fu
# 2022-8-4 QIXI

GetOptions(
	"fa:s"     => \$input_fa,            # Needed
	"dbdir:s"  => \$hcov19_db_dir,       # Needed
	"dbname:s" => \$hcov19_db_name,      # Needed
	"faname:s"  => \$fa_name,            # Needed
	"od:s"     => \$outdir,              # Needed
	) or die "Please check your args\n";

my $nextalign_bin = "$Bin/bin/nextalign";
my $ref_fasta     = "$Bin/reference/Ion_AmpliSeq_SARS-CoV-2-Insight.Reference.fa";

my $runsh = "$outdir/runsh\_$sample_name\.sh";


my @db = glob "$hcov19_db_dir/*.fasta";
print "hcov19_db_file:\n";
for my $file (@db){
	print "\t$file\n";
}
my $db_file = $db[0];


open O, ">$runsh" or die;
print O "perl "
print O "$nextalign_bin --sequence\=$input_fa --reference\=$ref_fasta --output-dir\=$outdir --output-basename\=$fa_name --in-order\n\n";


close O;