package DDG::Goodie::Crc;

use DDG::Goodie;
use String::CRC;

zci is_cached => 1;
zci answer_type => "crc";

primary_example_queries 'CRC this';
secondary_example_queries 'CRC-512 that', 'CRC512sum dim-dims';
description 'CRC cryptography';
name 'CRC';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Crc.pm';
category 'calculations';
topics 'math';
attribution web => [ 'https://www.duckduckgo.com', 'DuckDuckGo' ],
            github => [ 'https://github.com/duckduckgo', 'duckduckgo'],
            twitter => ['http://twitter.com/duckduckgo', 'duckduckgo'];


triggers query_lc => qr/^crc\-?(16|32|64|128)\s*(.*)$/i;

handle query => sub {
	my $crclen   = $1 || '';
	my $str      = $2 || '';

	# default crc length is 32
	if ($crclen eq '') {
	    $crclen = 32;
	}
	if($str) {
		if ( $crclen <= 32 ) {
		    ($crc1) = crc($str,$crclen);
		    $str=sprintf("%X",$crc1);
		} elsif ( $crclen > 32 && $crclen <= 64) {
		    ($crc1,$crc2) = crc($str,$crclen);
		    $str=sprintf("%X%X",$crc1,$crc2);
		} else {
		    $str="";
		}

		return $str, heading => "CRC-$crclen";
	}

	return;
};

1;
