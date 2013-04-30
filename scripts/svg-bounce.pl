#!/usr/local/bin/perl
# You may need to change the above path to perl
use strict;
use warnings;

# The bouncing ball
use XML::Writer;
use constant DATA => '../data/';

sub makeBouncePath( $ $ $ $ );

my $svgFile;
open $svgFile, '> '.DATA.'svg-bounce.svg';
print $svgFile '<?xml version="1.0"?>'."\n\n";
my $writer = XML::Writer->new( OUTPUT => $svgFile );

my ($width, $height) = (640, 360);
my $grad = 'padded';
my $rx = 30;
my $dx = 0;
my $dur = 0.025;
my $bounce_path;

$writer->setDataMode(1);	# Auto insert newlines
$writer->setDataIndent(2);	# Auto indent

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
		rx => $rx,
		ry => $rx,
		fill => 'url(#padded)',
	);
	
		makeBouncePath(300, 200, 4, \$bounce_path);

	$writer->endTag('ellipse');
	
	$writer->emptyTag(
		'path',
		id => 'bounce',
		d => $bounce_path,
		fill => 'none',
		stroke => '#0000FF',
	);

	$writer->startTag(
		'text',
		x => ($width - 100),
		y => ($height - 10),
		fill => '#0000FF',
	);
		print $svgFile "\n\t\tTIME ->\n";
	$writer->endTag('text');
	
$writer->endTag('svg');

close $svgFile;

sub makeBouncePath( $ $ $ $ ) {
	my ($ground, $bounce_height, $bounces, $dref) = @_;
	my $begin = '0s';
	my $from = $rx;
	my $to = $rx;
	my $pi = atan2(1,1) * 4;
	$dx = $bounces if( $dx > $bounces );
	my $sx = ($width*0.1);
	my $x = $sx;
	my $y = int( 1 + $ground - abs($bounce_height * sin( ($x/($width*2/$bounces)) * 2 * $pi )) );
	my $points = "M $sx $y";
	$$dref = $points;
	
	for( my $n=$width; $x<$n; $x+=$bounces, $sx+=$dx ) {
		my $animid = "anim$x";
		 if( $y > 265 ) { 
			$to = $rx+$rx*((($y-10)*($y-10))*0.001/($height));
		} else {
			$to = $rx;
		}
		$y = int( ($ground+$x/$n*50) - abs($bounce_height * sin( ($x/($n*2/$bounces)) * 2 * $pi )) );
		unless( $points =~ /M\s\d+\s$y/ ) {
			$writer->emptyTag(
				'animateMotion',
				id => $animid,
				path => $points. " L $sx $y",
				begin => $begin,
				dur => $dur.'s',
				fill => 'freeze',
			);
			$writer->emptyTag(
				'set',
				attributeName => 'rx',
				from => $from,
				to => $to,
				begin => $begin,
				dur => $dur.'s',
				fill => 'freeze',
			);
			$begin = $animid.'.end';
			$$dref .= " L $x $y";
			$from = $to;
		}
		$points = "M $sx $y";
		$ground -= 40 / ($n/$bounces);
		$height -= 40 / ($n/$bounces);
	}
}
