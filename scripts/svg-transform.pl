#!/usr/local/bin/perl
# You may need to change the above path to perl
use strict;
use warnings;

# Transform XML data to SVG drawing
use XML::LibXML;
use XML::LibXSLT;
use XML::Writer;
use constant DATA => '../data/';

require "svg-common.pl";

my $svgFile;
my $svgDir = $ARGV[0] || DATA;
open $svgFile, '> '.$svgDir.'svg-transform.svg';

close $svgFile;

