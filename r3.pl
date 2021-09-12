#! env /usr/bin/perl

package FunWithReferences;
use strict;
use warnings;
use v5.34;

sub {
	say add_one(10); # 11
	my $number = 10;
	add_one($number);
	say $number; # 10, no $ref change
	add_one_ref($number);
	say $number; # 11
	change_ref($number, 'XXX');
	say $number; # XXX
	change_ref($number,\$number);
	say $number->$*; # selsbt wird  eine referenz auf sich selbst. Ich glaube ich komme 
					 # nie wieder auf den Wert und das könnte ein Speicherloch sein
	change_ref_with_args($number, 'YYY');
	say $number;
}->();

sub add_one {
	my $n = shift; 
	$n++;
	return $n;
}

sub add_one_ref {
	$_[0] ++;
}

sub change_ref {
	# scary monsters! Perl gibt alle parameter als Referenzen weiter!
	$_[0] = $_[1];
	# allerdings werden sie zerstört, wenn man @_ angreift
}

sub change_ref_with_args($$){
	$_[0] = $_[1];
}

1;

