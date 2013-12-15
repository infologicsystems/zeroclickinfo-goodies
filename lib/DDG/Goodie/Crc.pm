package DDG::Goodie::Crc;

# last update 2013/12/15
# note: testing has not been completed on this package.

use DDG::Goodie;
#use String::CRC;
use Digest::CRC qw(crc64 crc32 crc16 crcccitt crc crc8 crcopenpgparmor crc64_hex);

zci is_cached => 1;
zci answer_type => "crc";

primary_example_queries 'CRC this';
secondary_example_queries 'CRC-32 that';
description 'CRC cryptography';
name 'CRC';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Crc.pm';
category 'calculations';
topics 'math';
attribution web => [ 'https://www.duckduckgo.com', 'DuckDuckGo' ],
            github => [ 'https://github.com/duckduckgo', 'duckduckgo'],
            twitter => ['http://twitter.com/duckduckgo', 'duckduckgo'];


triggers query_lc => qr/^crc\-?(8|16|32|)\s*(.*)$/i;

handle query => sub {
	my $crclen   = $1 || '';
	my $str      = $2 || '';

	my($crc1,$crc2);

	# default crc length is 32
	if ($crclen eq '') {
	    $crclen = 32;
	}
	if($str) {
		if ( $crclen == 8 ) {
		    $crc1 = crc8($str);
		    $str=sprintf("%X",$crc1);
		} elsif ( $crclen == 16 ) {
		    $crc1 = crc16($str);
		    $str=sprintf("%X",$crc1);
		} elsif ( $crclen == 32 ) {
		    $crc1 = crc32($str);
		    $str=sprintf("%X",$crc1);
		} else {
		    $str="";
		}

		return $str, heading => "CRC-$crclen";
	}

	return;
};

1;
