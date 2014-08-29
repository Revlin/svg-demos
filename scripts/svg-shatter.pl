#!/usr/bin/perl
use utf8;
use strict;
use warnings;

# Draw the first Uni-Sol scene file
use constant CWD => ($0 =~ /(.+)svg-shatter\.pl/ );
use constant DATA => CWD.'../data/';
use constant STYLE => CWD.'../styles/';

my $COMMON = CWD."common-svg.pl";
require $COMMON;

my $svgFile;
my $svgDir = $ARGV[0] || DATA;
open $svgFile, '>:utf8', $svgDir.'shatter-scene.svg';
#$svgFile = *STDOUT;

my ($width, $height) = (640, 360);

my $scene = scene->new( {
		'svgFile' => $svgFile,
		'stylesheet' => 'styles/shatter.css',
		'width' => $width,
		'height' => $height,
		'title' => "Shatter Test",
		'desc' => "Creating and animating masked fragments\n"
	} );
print $scene->title, "\n"; 	# debug
print $scene->desc, "\n";	# debug
	
	$scene->writer->startTag( 'g',
		id => "char-test",
		class => "shatter-layer0",
		transform => "translate(100,100)"
	);
		$scene->writer->startTag( 'defs' );
			$scene->writer->emptyTag( 'image',
				id => "char-test-shatter-img",
				'xlink:href' => "images/char.png",
				x => "0",
				y => "0",
				width => "200",
				height => "200"
			);
		$scene->writer->endTag();
		
		$scene->writer->emptyTag( 'rect',
			style => "fill:none; stroke:#ff0000; stroke-width:2px;",
			x => "0", 
			y => "0",
			width => "200",
			height => "200"
		);
		
		$scene->writer->startTag( 'g',
			class => "shatter-layer0001",
	   	  	transform => "translate(0,0)"
		);
			$scene->writer->startTag( 'clipPath', 
				id => "char-test-shatter-layer0001-clip"
			);
				$scene->writer->emptyTag( 'path', 
					d => "M 0 0 L 40 0 L 40 40 L 0 40 Z",
					transform => "translate(0,0)"
				);
			$scene->writer->endTag();
			$scene->writer->emptyTag( 'rect',
				transform => "translate(0,0)",
				style => "fill:#ff0000; stroke:none; clip-path:url(#char-test-shatter-layer0001-clip);",
				x => "0", 
				y => "0",
				width => "200",
				height => "200"
			);
			$scene->writer->emptyTag( 'use',
				transform => "translate(0,0)",
				'xlink:href' => "#char-test-shatter-img",
				style => "clip-path:url(#char-test-shatter-layer0001-clip);",
				x => "0", 
				y => "0",
				width => "200",
				height => "200"
			);
			$scene->writer->emptyTag( 'path',
				d => "M 0 0 L 40 0 L 40 40 L 0 40 Z" 
			);
		$scene->writer->endTag();

	$scene->writer->endTag();

$scene->end();
print $svgFile "\n";

close $svgFile;
