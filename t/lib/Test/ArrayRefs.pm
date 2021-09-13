#! /usr/bin/perl

package Test::ArrayRefs;
use v5.30;
use strict;
use warnings;
# use diagnostics;
use Test::Class;
use base qw(Test::Class);
use Test::More;

sub make_fixture : Test(setup) {
    say ['w', 'e', 'l', 'c', 'o', 'm', 'e']->@*;
}

sub test_stuff_with_arrays : Test(8) {
	my @a1 = ('a', 'b', 'c');
	my $a1_r = \@a1; # das ist eine Referenz auf dieses Array
	say $a1_r; # das gibt die Speicheradresse aus
	my $a1_r_addr = scalar $a1_r;
	is(substr($a1_r_addr, 0, 5), 'ARRAY', 'is a reference');

	# Schauen wir uns die Verbindungen an:
	my @a1_copy = $a1_r->@*; # das dereferenziert $ai_r und ich bekomme es hier als Kopie
	push(@a1_copy, 'd');

	say @a1_copy; #abcd
	say $a1_r->@*; # abc ergo, ->@* macht eine Kopie, nein, macht noch keine Kopie, erst, wenn ich es
				   # linkerhand irgendjemand zuspreche, wie wir spáter sehen
	is(scalar $a1_r->@*, 3, 'original has not changed');

	# push($a1_r, 'd'); -> Experimental push on scalar is now forbidden, mit ->@* ginge es!

	$a1_r->[0]='A';
	say $a1_r->@*;
	$a1_r->[4]="XXX"; # index 3 hat ein undef verpasst bekommen

	#map { uc $_ } $a1_r; # map produziert eine neue Liste
	#say $a1_r->@

	change_it($a1_r);
	say "Geändert auf $a1_r->[0]";
	is($a1_r->[0], 'XXX', 'changed array_ref value');

	my @a2 = (1,2,3);
	say_it(@a2);

	my $length1 = @a2;
	my $length2 = scalar @a2; 	# Selbe Sache, also verm. verwende ich das, wenn ich keine
								# Variable erklären möchte. ZB. print scalar @a2
								# Das ist eine Funktion, der ich direkt ein Array übergebe,
								# keine Referenz (die ja schon skalar ist, und darum sinnlos).
	if ($length1 == $length2){
		say "Beide Längen sind gleich: ${length1}";
	} else {
		say "Die Längen sind unterschiedlich: 1:$length1 2:$length2";
	}
	is($length1, $length2, 'turning a list into a scalar gives its length.');

	# Jetzt verändere ich eine Referenz
	say ref_map( \@a2, sub {$_ = shift; $_ * $_ } )->@*; # Ich würde gerne { $_* $_ } sagen, aber andere Baustelle
	is($a2[-1], 9, 'refmap changed values in place');

	ref_push(\@a2, 16);
	say @a2;
	is($a2[-1], 16, 'ref_push worked');

	my @a3 = (0..10);
	my $a3_r = \@a3;
	push($a3_r->@*, 'XXX');
	say @a3; # XXX am Ende. Dh. meine ref_push ist unnötig. ->@* gibt mir direkten Zugriff auf die referenzierte
	         # Liste. Ob das mit map auch geht? Erst werfe ich das XXX wieder weg
	is($a3[-1], 'XXX', 'ref_push worked');
	#pop @a3; #geht
	pop $a3_r->@*; # nur kurz gecheckt, pop geht genauso auf referenzen

	say map {$_*$_} $a3_r->@*; # funktioniert, aber

	say @a3; # das verändert die ref nicht, was auch zu erwarten ist
	is($a3[-1], 10, 'das verändert die ref nicht, was auch zu erwarten ist');
}

sub say_it {
	print "Frankie says: ";
	print @_;
	print qq{\n};
}

sub change_it {
	my $ref = shift;
	$ref->[0] = "XXX";
}

sub ref_map {
	my ($arr_ref, $func ) = @_;
	my $length = $arr_ref->@*; #es könnte auch eine billigere Methode geben, zu der length zu kommen.
	for my $i (0..$length-1){
		$arr_ref->[$i] = $func->($arr_ref->[$i]);
	}
	return $arr_ref;
}

sub ref_push { # unnedig
	my ($arr_ref, $val) = @_;
	my $length = $arr_ref->@*;
	$arr_ref->[$length]=$val;
}

1;
