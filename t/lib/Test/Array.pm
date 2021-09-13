package Test::Array;
use strict;
use warnings;
use v5.34;
use Test::Class;
use base qw(Test::Class);
use Test::More;

sub test_push_on_undef : Test {
    my $arr_ref;
    push $arr_ref->@*, "something";
    my $length = scalar $arr_ref->@*;
    is($length, 1, 'Array was created by pushing onto undef');
}

1;