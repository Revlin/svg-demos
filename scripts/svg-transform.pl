#!/usr/bin/perl
# You may need to change the above path to perl
use utf8;
use strict;
use warnings;

# Transform XML data to SVG drawing
use XML::LibXML;
use XML::LibXSLT;
use XML::Writer;
use constant CWD => ($0 =~ /(.+)svg-transform\.pl/ );
use constant DATA => CWD.'../data/';
use constant STYLE => CWD.'../styles/';

my $COMMON = CWD."common-svg.pl";
require $COMMON;

my $svgFILE;
my ($data_dir)  = ( $ARGV[0] =~ /(.+\/$)/ );
my ($style_dir) = STYLE;
my ($xml, $xsl) = ( (join " ", @ARGV) =~ /([\w|\-]+\.xml)\s+(([\w|\-]+)\.xsl)/ );
my $svg = "xslt-transform.svg";
$data_dir = DATA unless( $data_dir );
unless( ($xml) && ($xsl) ) {
	print 	"Must provide file names (not paths) of xml data and xsl stylesheet!\n",
		"svg-transform.pl </.../DATA_DIR/> <file.xml> <file.xsl>\n";
	exit;
}
print 	"DATA_DIR: $data_dir\n",
		"XML: $xml\n",
		"XSLT: $xsl\n";

my $xslt = XML::LibXSLT->new();
my $source = XML::LibXML->load_xml( location => $data_dir.$xml );
my $stylesheet = XML::LibXML->load_xml( location => $style_dir.$xsl ); #, no_cdata => 1 );

my $style = $xslt->parse_stylesheet($stylesheet);

my $result = $style->transform($source);

open $svgFILE, '> '.$data_dir.$svg;

print $svgFILE $style->output_as_bytes($result);

close $svgFILE;
