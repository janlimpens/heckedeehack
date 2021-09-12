#! env /usr/bin/perl

use strict;
use warnings;
use v5.34;
package FunWithHashes;
use Data::Dumper;
$Data::Dumper::Terse = 1;
$Data::Dumper::Indent = 0;

sub los_gehts {
		# ich erkläre ein hash
		my %h1 = (a=>1, b=>2, c=>3); #zufällig geordnet, aber in eta a1b2c3
		say %h1;

		# ich mache eine Referenz darauf
		my $h1_r = \%h1;
		say $h1_r; # HASH(addr)

		#ich mache ein Array daraus
		my @h1_a = %h1;
		say @h1_a; # sieht genauso wie das hash aus

		# vergleichen wir die Längen
		say scalar @h1_a;
		say '%h1 is halb so lang wie @h1_a' 
				if (scalar %h1 == 3 && scalar @h1_a==6);

		$h1{d}=1;
		$h1_r->{e}=2; # same same

		$h1{f}=(4,5,6);
		$h1_r->{g} = (7,8);
		my $topsy = smart_reverse($h1_r);
		say Dumper($topsy);

}


sub smart_reverse {
		my %hash = shift->%*;
		my %result = map {$_=>[]} values %hash; # das sind alles array refs
		while ( my($k, $v) = each (%hash) ) {
				push($result{$v}->@*, $k); # hier muss ich dereffen sonst pushe ich auf skalar
		}
		return \%result;
}

los_gehts;
print "xxxx";
1;
