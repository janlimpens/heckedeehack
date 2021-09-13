#! env /usr/bin/perl

use strict;
use warnings;
use v5.34;
package Test::HashRefs;
use Data::Dumper;
use Test::Class;
use base qw(Test::Class);
use Test::More;

$Data::Dumper::Terse = 1;
$Data::Dumper::Indent = 0;

sub test_los_gehts : Test(4) {
		# ich erkläre ein hash
		my %h1 = (a=>1, b=>2, c=>3); #zufällig geordnet, aber in eta a1b2c3
		say %h1;

		# ich mache eine Referenz darauf
		my $h1_r = \%h1;
		is(substr($h1_r,0,4), 'HASH', 'ich bekomme eine Referenz');

		#ich mache ein Array daraus
		my @h1_a = %h1;
		say @h1_a; # sieht genauso wie das hash aus

		my $key = $h1_a[0];
		is($h1_a[1], $h1{$key}, 'erstes Element stimmt');

		# vergleichen wir die Längen
		say scalar @h1_a;
		is(scalar %h1, 3, 'das hash hat 3 Elemente');
		is(scalar @h1_a, 6, 'das array hat 6 Elemente');

		$h1{d} = 1;
		# is($h1{d}, 1, 'setting on obj');
		$h1_r->{e}=2; # same same
		# is($h1_r->{e}, 2, 'setting on ref');

		$h1{f} = (4..6);
		$h1_r->{g} = (7..8);

		my $topsy = smart_reverse($h1_r);
		# is($topsy->{7}, 'g', 'reversed');

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

1;
