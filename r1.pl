#! /usr/bin/perl

package Stuff;
use v5.30;
use strict;
use warnings;
use diagnostics;

sub stuff_with_arrays {
	say ['w', 'e', 'l', 'c', 'o', 'm', 'e']->@*; 

	my @a1 = ('a', 'b', 'c'); 
	my $a1_r = \@a1; # das ist eine Referenz auf dieses Array
	say $a1_r; # das gibt die Speicheradresse aus
	my $a1_r_addr = scalar $a1_r;
	
	# Schauen wir uns die Verbindungen an:
	my @a1_copy = $a1_r->@*; # das dereferenziert $ai_r und ich bekomme es hier als Kopie
	push(@a1_copy, 'd');

	say @a1_copy; #abcd
	say $a1_r->@*; # abc ergo, ->@* macht eine Kopie, nein, macht noch keine Kopie, erst, wenn ich es 
				   # linkerhand irgendjemand zuspreche, wie wir spáter sehen

	# push($a1_r, 'd'); -> Experimental push on scalar is now forbidden, mit ->@* ginge es!
	
	$a1_r->[0]='A';
	say $a1_r->@*;
	$a1_r->[4]="XXX"; # index 3 hat ein undef verpasst bekommen

	#map { uc $_ } $a1_r; # map produziert eine neue Liste
	#say $a1_r->@

	change_it($a1_r);
	say "Geändert auf $a1_r->[0]";

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

	# Jetzt verändere ich eine Referenz
	say ref_map( \@a2, sub {$_ = shift; $_ * $_ } )->@*; # Ich würde gerne { $_* $_ } sagen, aber andere Baustelle

	ref_push(\@a2, 16);	
	say @a2;

	my @a3 = (0..10);
	my $a3_r = \@a3;
	push($a3_r->@*, 'XXX');
	say @a3; # XXX am Ende. Dh. meine ref_push ist unnötig. ->@* gibt mir direkten Zugriff auf die referenzierte
	         # Liste. Ob das mit map auch geht? Erst werfe ich das XXX wieder weg
	#pop @a3;
	pop $a3_r->@*; # nur kurz gecheckt, pop geht genauso
	say map {$_*$_} $a3_r->@*; # funktioniert, aber
	say @a3; # das verändert die ref nicht, was auch zu erwarten ist
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

stuff_with_arrays();

1;
