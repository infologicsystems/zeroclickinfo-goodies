#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'crc';
zci is_cached => 1;

# test results compared with http://zorc.breitbandkatze.de/crc.html

ddg_goodie_test(
        [qw(
                DDG::Goodie::Crc
        )],
        'crc 123456789' => test_zci('CBF43926'),
        'crc-16 123456789' => test_zci('BB3D'),
        'crc-32 123456789' => test_zci('CBF43926'),
        'crc-32 duckduckhack' => test_zci('92565B89'),
);

done_testing;
