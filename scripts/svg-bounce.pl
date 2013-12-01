#!/usr/bin/perl
# You may need to change the above path to perl
use utf8;
use strict;
use warnings;

# The bouncing ball
use XML::Writer;
use constant CWD => ($0 =~ /(.+)svg-bounce\.pl/ );
use constant DATA => CWD.'../data/';
use constant STYLE => CWD.'../styles/';

my $COMMON = CWD."svg-common.pl";
require $COMMON;

my $svgFile;
my $svgDir = $ARGV[0] || DATA;
open $svgFile, '> '.$svgDir.'svg-bounce.svg';
my $writer = XML::Writer->new( OUTPUT => $svgFile );
$writer->setDataMode(1);	# Auto insert newlines
$writer->setDataIndent(2);	# Auto indent
$writer->xmlDecl("utf-8"); 	# XML declaration: <?xml version="1.0" encoding="utf-8"?>

my ($width, $height) = (640, 360);
my $grad = 'padded';
my $rx = 30;
my $dx = 0;
my $dur = 0.025;
my $bounce_path;


$writer->startTag(	
	'svg',
	'xmlns' => 'http://www.w3.org/2000/svg',
	'xmlns:xlink' => 'http://www.w3.org/1999/xlink',
	height => $height,
	width => $width,
);

	$writer->startTag(
		'radialGradient',
		id => 'padded',
		cx => '0.80',
		cy => '0.30',
		r => '0.75', 
		spreadMethod => 'reflect',
	);
	
		$writer->emptyTag(
			'stop', 
			offset => '0.00',
			'stop-color' => '#FFCCCC',
		);
	
		$writer->emptyTag(
			'stop', 
			offset => '0.23',
			'stop-color' => '#FF0000',
		);
	
		$writer->emptyTag(
			'stop', 
			offset => '0.66',
			'stop-color' => '#AA0000',
		);
	
		$writer->emptyTag(
			'stop', 
			offset => '1.00',
			'stop-color' => '#000000',
		);
	
	$writer->endTag('radialGradient');
	
	$writer->emptyTag(
		'rect',
		x => 0,
		y => 0,
		width => $width,
		height => $height,
		fill => '#000000',
	);

	$writer->startTag(
		'ellipse',
		id => 'ball',
		cx => 0,
		cy => 0,
		rx => $rx,
		ry => $rx,
		fill => 'url(#padded)',
	);
	
		bounce::makeBouncePath(\$writer, 3000, 300, 200, 4, $rx, 50, $dx, \$bounce_path);
		# \$ref_to_xml_writer, $total_time, $ground_height, $bounce_height, $number_of_bounces, $radius_of_ball, $x_offset, $delta_for_horizonatal_motion, \$ref_to_path (optional)

	$writer->endTag('ellipse');
	
	$writer->emptyTag(
		'path',
		id => 'bounce',
		d => $bounce_path,
		fill => 'none',
		stroke => '#0000FF',
	) if( $bounce_path );

	$writer->startTag(
		'text',
		x => ($width - 100),
		y => ($height - 10),
		fill => '#0000FF',
		'font-family' => 'monospace',
		'font-size' => '16pt',
	);
		print $svgFile <<TEXT;
			
		time>>
TEXT
	$writer->endTag('text');
	
$writer->endTag('svg');

close $svgFile;
