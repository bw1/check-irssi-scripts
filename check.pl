#!/usr/bin/perl
#
# checkt auf neuerungen
#
use YAML qw/Dump DumpFile LoadFile/;
use Digest::SHA;
use LWP::Simple;

my $down="down";
my $jobs= LoadFile("jobs.yaml");

my $ok=0;

foreach my $job (sort @$jobs) {
	printf ("%-30s  ",$job->{file});
	my $sha = Digest::SHA->new("SHA256");

	#$sha->addfile($down."/".$job->{file});
	
	my $cont =get($job->{url});
	$sha->add($cont);

	my $res= $sha->hexdigest;
	print $res,"  ";
	#$job->{sha}=$res;

	if ($job->{sha} ne $res) {
		print "Change!";
		$ok=1;
	} 
	
	print "\n";
}

exit $ok;

#print Dump($jobs);
#DumpFile("jobs.yaml",$jobs);
