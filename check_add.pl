#!/usr/bin/perl
#
# add file in jobs.yaml
#
use YAML qw/Dump DumpFile LoadFile/;
use Digest::SHA;
use LWP::Simple;

my $down="down";
my $jobs= LoadFile("jobs.yaml");

my $ok=0;

if ($#ARGV != 1){
	exit(1);
}

my %new;
$new{file}=$ARGV[0];
$new{url}=$ARGV[1];

my $sha = Digest::SHA->new("SHA256");

my $cont =get($new{url});
$sha->add($cont);

my $res= $sha->hexdigest;

$new{sha}=$res;

push @{$jobs},\%new;

#print Dump($jobs);
DumpFile("jobs.yaml",$jobs);
