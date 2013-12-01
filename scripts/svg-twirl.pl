#!/usr/bin/perl
# You may need to change the above path to perl
use utf8;
use warnings;
use strict;

# Twirling squares with JavaScript
use XML::Writer;
use constant CWD => ($0 =~ /(.+)svg-twirl\.pl/ );
use constant DATA => CWD.'../data/';
use constant STYLE => CWD.'../styles/';

my $COMMON = CWD."svg-common.pl";
require $COMMON;

my $svgFile;
my $svgDir = $ARGV[0] || DATA;
open $svgFile, '> '.$svgDir.'svg-twirl.svg';
my $writer = XML::Writer->new( OUTPUT => $svgFile );
$writer->setDataMode(1);	# Auto insert newlines
$writer->setDataIndent(2);	# Auto indent
$writer->xmlDecl("utf-8"); 	# XML declaration: <?xml version="1.0" encoding="utf-8"?>

my ($width, $height) = (640, 360);

$writer->startTag(
	'svg',
	width => $width,
	height => $height,
	'xmlns' => 'http://www.w3.org/2000/svg',
	'xmlns:xlink' => 'http://www.w3.org/1999/xlink'
);

	$writer->startTag(
		'script',
		type => 'text/ecmascript',
	);
	
	print $svgFile <<SCRIPT;
	//<![CDATA[
		function moveCenter(evt) {
			var sprite = evt.target.ownerDocument.getElementById('sprite');
			sprite.setAttribute( 'x', (evt.clientX - sprite.getAttribute('width')/2) );
			sprite.setAttribute( 'y', (evt.clientY - sprite.getAttribute('height')/2) );
		}
	//]]>
SCRIPT
	$writer->endTag('script');
	
	$writer->emptyTag(
		'rect',
		id => 'background',
		onmousedown => 'moveCenter(evt)',
		width => 400,
		height => 400,
		fill => 'pink',
	);

	$writer->startTag(
		'svg',
		id => 'sprite',
		width => 200,
		height => 200,
		'xmlns' => 'http://www.w3.org/2000/svg',
		'xmlns:xlink' => 'http://www.w3.org/1999/xlink',
		onload => 'startAnimation(evt)',
	);

		$writer->startTag(
			'script',
			type => 'text/ecmascript',
		);
	print $svgFile <<SCRIPT;
	//<![CDATA[
		var delay = 1, 
			angle = 0,
			cx = 100,
			cy = 100,
			frames = 30,
			direction = -1,
			count = 0,
			element = new Array(),
			xIncrement = new Array(),
			yIncrement = new Array(),
			parent, i, x, y;
		
		function startAnimation(evt) {
			parent = evt.target.ownerDocument;
			for( i=0; i<25; i++ ) {
				element[i] = parent.getElementById('box'+i);
				x = element[i].getAttribute('x');
				y = element[i].getAttribute('y');
				xIncrement[i] = (cx - element[i].getAttribute('x')) / frames;
				yIncrement[i] = (cy - element[i].getAttribute('y')) / frames;
			}
			moveElements();
		}
		
		function moveElements() {
			angle = angle + 360/frames;
			count = count + 1;
			if( count == frames ) {
				direction = direction + 1;
				count = 0;
			}
			for( i=0; i<25; i++ ) {
				x = element[i].getAttribute('x');
				y = element[i].getAttribute('y');
				element[i].setAttribute( 'transform', 'rotate('+ angle +','+ x +','+ y +')' );
				element[i].setAttribute( 'x', (x - direction*xIncrement[i]) );
				element[i].setAttribute( 'y', (y - direction*yIncrement[i]) );
			}
			setTimeout( moveElements, delay );
		}
		
		function changeColor(evt) {
			evt.target.setAttribute( 'fill', '#00FF33' );
		}
		
		function changeColorBack(evt) {
			evt.target.setAttribute( 'fill', 'none' );
		}
	//]]>
SCRIPT
		$writer->endTag('script');
	
		foreach my $row (1..5) {
			foreach my $col (1..5) {
				$writer->emptyTag(
					'rect',
					id => 'box'.(($row - 1)*5 + $col - 1),
					onmouseover => 'changeColor(evt)',
					onmouseout => 'changeColorBack(evt)',
					width => 20,
					height => 20,
					'stroke-width' => 1,
					stroke => '#000000',
					fill => 'none',
					x => 30*$col,
					y => 30*$row,
				);
			}
		}
	
	$writer->endTag('svg');

$writer->endTag('svg');
