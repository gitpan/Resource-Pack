#!/usr/bin/perl

use strict;
use warnings;
use Path::Class;

use lib "t/lib";

use Test::More;
use Test::Exception;
use Test::Moose;

BEGIN {
    use_ok('Test032::Pack');
}

my $pack = Test032::Pack->new;
does_ok($pack, 'Resource::Pack');
does_ok($pack, 'Resource::Pack::Dir');

# copy the file ...

my $dest    = dir('.');
my @targets = (
    $dest->subdir('js')->file( 'Pack.js' ),
    $dest->subdir('js')->file( 'jquery.min.js' )
);

# clear stuff out before we start the test
-e $_ && $_->remove for @targets;
-e $_ && $_->rmtree for $dest->subdir('js');

ok(! -e $_, '... the file (' . $_ . ') does not exist yet') for @targets;

lives_ok {
    $pack->copy( to => $dest, include_deps => 1 );
} '... directory of resources was copied successfully';

ok(-e $_, '... the file (' . $_ . ') does exist now') for @targets;

$_->remove for @targets;
$_->rmtree for $dest->subdir('js');

done_testing;


