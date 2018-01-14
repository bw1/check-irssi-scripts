#!/usr/bin/perl
#
# checkt auf neuerungen
#
use YAML qw/Dump DumpFile LoadFile/;
use Digest::SHA;
use LWP::Simple;

my $down="down";
my $jobs= LoadFile("jobs.yaml");

foreach my $job (@$jobs) {
	print $job->{file},"\t";
	my $sha = Digest::SHA->new("SHA256");

	#$sha->addfile($down."/".$job->{file});
	
	my $cont =get($job->{url});
	$sha->add($cont);

	my $res= $sha->hexdigest,"\n";
	print $res,"\n";
	#$job->{sha}=$res;

	if ($job->{sha} ne $res) {
		print "Error!\n";
	}
}

#print Dump($jobs);
#DumpFile("jobs.yaml",$jobs);
