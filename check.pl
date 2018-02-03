#!/usr/bin/perl
#
# checkt auf neuerungen
#
use utf8;
use YAML qw/Dump DumpFile LoadFile/;
use Digest::SHA;
use LWP::Simple;

my $down="down";
my $jobs= LoadFile("jobs.yaml");

my $ok=0;


my %fsort;
foreach my $job (@$jobs) {
	$fsort{$job->{file}}=$job;
}

foreach my $fn (sort keys %fsort) {
	my $job =$fsort{$fn};
	printf ("%-30s  ",$job->{file});
	my $sha = Digest::SHA->new("SHA256");

	#$sha->addfile($down."/".$job->{file});
	
	my $cont =get($job->{url});
	utf8::encode($cont);
	$sha->add($cont);

	my $res= $sha->hexdigest;
	printf ("%10s  ",length($cont));
	print $res,"  ";
	#$job->{sha}=$res;

	if ($job->{sha} ne $res 
			|| $job->{size} != length($cont)) {
		print "Change!";
		$ok=1;
	} 
	
	print "\n";
}


#print Dump($jobs);
#DumpFile("jobs.yaml",$jobs);

exit $ok;
