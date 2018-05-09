#!/usr/bin/perl
#
# add file in jobs.yaml
#
use utf8;
use YAML qw/Dump DumpFile LoadFile/;
use Digest::SHA;
use LWP::Simple;

my $down="down";
my $jobs= LoadFile("jobs.yaml");

my $ok=0;

if ($#ARGV != 1){
	print "Usage: check_add.pl <filename> <url>\n";
	exit(1);
}

my %new;
$new{file}=$ARGV[0];
$new{url}=$ARGV[1];

my $sha = Digest::SHA->new("SHA256");

my $cont =get($new{url});
utf8::encode($cont);
$sha->add($cont);

my $res= $sha->hexdigest;

$new{size}=length($cont);
$new{sha}=$res;

push @{$jobs},\%new;

#print Dump($jobs);
DumpFile("jobs.yaml",$jobs);
