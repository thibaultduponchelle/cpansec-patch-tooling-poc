use strict;
use warnings;
use Test::More;
use lib "xt/lib";
use CLI;
use Path::Tiny;
use App::cpm::Util 'WIN32';

subtest ng => sub {
    my $cpanfile = Path::Tiny->tempfile;
    $cpanfile->spew(<<___);
requires "perl", "5.99.0";
requires 'Plack';
___
    my $r = cpm_install "--cpanfile", $cpanfile->stringify;
    isnt $r->exit, 0;
    unlike $r->err, qr/Plack/; # do not install Plack
};

subtest ng => sub {
    plan skip_all => 'only for perl 5.18+' if $] < 5.018;
    plan skip_all => 'XXX: failed to install Win32 module' if WIN32;
    my $r = cpm_install "--target-perl", "5.8.0", "HTTP::Tinyish";
    isnt $r->exit, 0;
    unlike $r->err, qr/DONE install HTTP-Tiny-/;
    unlike $r->err, qr/DONE install HTTP-Tinyish-/;
    note $r->err;
};

done_testing;
