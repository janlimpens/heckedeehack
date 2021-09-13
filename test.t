#!/usr/bin/perl
use v5.34;
use strict;
use warnings;
use Test::Class::Load qw(t/lib);

use Test::Array;

Test::Class->runtests;