#! env /usr/bin/perl

use strict;
use warnings;
use v5.34;
package Test::HashRefs;
use Data::Dumper;
use Test::Class;
use base qw(Test::Class);
use Test::More;

# $Data::Dumper::Terse = 1;
# $Data::Dumper::Indent = 0;

sub make_fixture : Test(setup) {
    my %h1 = (a=>1, b=>2, c=>3);
    shift->{h1} = \%h1;
}

sub test_referenzen_machen : Test {
	my $h1_r = shift->{h1};
	is(substr($h1_r,0,4), 'HASH', 'ich bekomme eine Referenz');
}

sub test_mache_ein_array_daraus : Test(3) {
	my %h1 = shift->{h1}->%*;

	#ich mache ein Array daraus
	my @h1_a = %h1;
	say @h1_a; # sieht genauso wie das hash aus

	my $key = $h1_a[0];
	is($h1_a[1], $h1{$key}, 'erstes Element stimmt');

	# vergleichen wir die Längen
	say scalar @h1_a;
	is(scalar %h1, 3, 'das hash hat 3 Elemente');
	is(scalar @h1_a, 6, 'das array hat 6 Elemente');
}

sub test_werte_setzen : Test(2) {
	my %h1 = shift->{h1}->%*;
	$h1{d} = 1;
	is($h1{d}, 1, 'setting on obj');

	my $h1_r = \%h1;
	$h1_r->{e} = 2; # same same
	is($h1{e}, 2, 'setting on ref');
}

sub test_smart_reverse :Test(2) {
	my $h1 = shift->{h1};
	$h1->{f} = 4;
	$h1->{g} = 4;
	my $topsy = smart_reverse($h1);
	say Dumper($topsy->%*);
	is($topsy->{1}->@*, q(a), 'reversed');
	is($topsy->{4}->@*, q(fg), 'reversed');
}

sub smart_reverse {
	my %hash = shift->%*;
	my $result = {};
	while ( my($k, $v) = each (%hash) ) {
		unless (defined $result->{$v}){
			$result->{$v} = [];
		}
		push($result->{$v}->@*, $k); # hier muss ich dereffen sonst pushe ich auf skalar
	}
	return $result;
}

1;
