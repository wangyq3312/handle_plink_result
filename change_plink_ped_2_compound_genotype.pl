#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Long;
use Data::Dumper;
use File::Basename qw(dirname basename);
use FindBin qw($Bin $Script);

my $version    =        "1.0";
my $writer     =        "wangyq";
my $date       =        "2017/09/21";
my $Email      =        "956841102\@qq.com";

#——————————————————————————————————————————————————————————————————————————————————————————————————————————#
my ($in,$out_pre,$out_dir);
GetOptions(
                        "h|?"   =>      \&help,
                        "in:s"  =>      \$in,           #fa file
                        "out_pre:s"     =>      \$out_pre,
                        "out_dir:s"     =>      \$out_dir,
                        ) || &help;
&help unless ($in and $out_pre and $out_dir);

#------------------------------------------------------------------------#
sub help
{
        print <<"       Usage End.";
---------------------------------------------------------------------------------------------------
        Version: $version
        Date: $date
        Writer: $writer
        Email: $Email

        function:statistic fasta sequence

        Usage:
                -in             <file>  plink result file .ped , forced
                -out_pre                <file>  compound genotype file prefix, forced
                -out_dir                <dir>   output dir of changed files
                -h              Help document

        Example:
                perl $Script -in chr1_XMT_1000genome.ped -out_pre chr1 -out_dir */chr1/
---------------------------------------------------------------------------------------------------
        Usage End.
        exit;
}

#——————————————————————————————————————————————————————————————————————————————————————————————————————————#
my $BEGIN=time();
my $Time_Start = &format_datetime(localtime(time()));
my $notename=`hostname`;chomp $notename;
my $operator=`whoami`;chomp $operator;

print "\n\[$Time_Start\] \@$notename $Script Start... \($operator is the operator\)\n";

mkdir $out_dir unless (-d $out_dir) ;

open (IN,$in) or die $!;
#my $num=0;
while (<IN>) {
        chomp;
        next if (/^#/ or /^$/) ;
        s/\r*//g;
#       $num++;
#       last if ($num = 20 ) ;
        my ($id,$t1,$t2,$t3,$t4,$t5,@genotype)=split/\s/,$_;

        my $file="$out_pre"."_"."$id".".txt";
        open (OUT,">$out_dir/$file") or die $!;
        for (my $i=0;$i<=$#genotype ; $i=$i+2) {
#               print "$i\n";
                print OUT "$genotype[$i]$genotype[$i+1]\n" ;
        }
        close OUT;
}



close IN;
close OUT;


my $Time_End = &format_datetime(localtime(time()));
my $run=time()-$BEGIN;
my $run2=&trans_time($run);
$run=$run."s";
print "\n$Script runs $run \($run2).\n";
print "\[$Time_End\] \@$notename $Script End.\n\n";


#————————————————————————————————————————————————————————————————————————————————————————————————————————#
sub format_datetime {#Time calculation subroutine
    my($sec, $min, $hour, $day, $mon, $year, $wday, $yday, $isdst) = localtime(time());
    sprintf("%4d-%02d-%02d %02d:%02d:%02d", $year+1900, $mon+1, $day, $hour, $min, $sec);
}

sub trans_time {
        my ($time)=@_;
        my ($return,$hour,$min,$sec,$tmp);

        if ($time < 60 ) {
                $return=$time."s";
        } elsif ($time >= 60 and $time < 3600) {
                $min=int($time/60);
                $sec=$time%60;
                $return=$min."min-".$sec."s";
        }elsif ($time >= 3600) {
                $hour=int($time/3600);
                $tmp=$time%3600;

                if ($tmp >=60 ) {
                        $min=int($tmp/60);
                        $sec=$tmp%60;
                        $return=$hour."h-".$min."min-".$sec."s";
                } else {
                        $sec=$tmp;
                        $return=$hour."h-"."0min-".$sec."s";
                }
        }

}
