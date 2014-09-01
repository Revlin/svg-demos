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
		
		my( $swidth, $sheight, $rows ) = ( 200, 200, 10 );
		
		for( my $r=0; $r<$rows; $r++ ) {
			# Create brick pattern with alternating width
			my $h = int( $sheight / $rows );
			my $y = $r * $h;
			my $w = $h * (2 - $r%2);
			my $x = 0;
			my $blocks_per_row = int( $swidth/($h*1.5) );
			$blocks_per_row++ if( ($blocks_per_row*($h*1.5)) < $swidth );
				
			for( my $s=0; $s<$blocks_per_row; $s++ ) {
				my $layerId = $r * $blocks_per_row + $s + 1;
				$layerId = ($layerId < 10)? "000$layerId":
							($layerId < 100)? "00$layerId":
							($layerId < 1000)? "0$layerId":
							"$layerId";
				print "$layerId, $s, $x, $w\n";

				$scene->writer->startTag( 'g',
					class => "shatter-layer$layerId",
					transform => "translate(0,0)"
				);
					$scene->writer->startTag( 'clipPath', 
						id => "char-test-shatter-layer$layerId-clip"
					);
						$scene->writer->emptyTag( 'path', 
							d => "M $x $y L ".($x+$w)." $y L ".($x+$w)." ".($y+$h)." L $x ".($y+$h)." Z",
							transform => "translate(0,0)"
						);
					$scene->writer->endTag();
					
					$scene->writer->emptyTag( 'rect',
						transform => "translate(0,0)",
						style => "fill:#ff0000; stroke:none; clip-path:url(#char-test-shatter-layer$layerId-clip);",
						x => "0", 
						y => "0",
						width => "$swidth",
						height => "$sheight"
					);
					
					$scene->writer->emptyTag( 'use',
						transform => "translate(0,0)",
						'xlink:href' => "#char-test-shatter-img",
						style => "clip-path:url(#char-test-shatter-layer$layerId-clip);",
						x => "0", 
						y => "0",
						width => "$swidth",
						height => "$sheight"
					);
					$scene->writer->emptyTag( 'path',
						#style => "stroke:none;",
						d => "M $x $y L ".($x+$w)." $y L ".($x+$w)." ".($y+$h)." L $x ".($y+$h)." Z" 
					);					
					my $points = "M 0 0";
					my @v = (0.0, 1.0);
					$v[0] = 5 - (10*rand);
						
					for( my $i=0; $i < 3; $i++ ) {
						my $animid = "fall$layerId-$i";
						my $begin = $i*3.33;
						my $dur = 3.33;
						$v[0] += $v[0] * 0.1;
						$v[1] += $v[1] * 9.0;

						$scene->writer->emptyTag(
							'animateMotion',
							id => $animid,
							path => $points. " L ".$v[0]." ".$v[1],
							begin =>  $begin.'s',#($i < 1)? $begin.'s': "fall$layerId-".($i-1).'.end',
							dur => $dur.'s',
							fill => 'freeze',
						);
						$points = "M ".$v[0]." ".$v[1];
					}
				$scene->writer->endTag();
				
				$x = $x + $w;
				$w = (($r%2) < 1)? 
						$h * ($s%2 + 1):
						$h * (2 - $s%2);
				if( ($x + $w) > $swidth ){
					$w = $swidth - $x;
				}
			}
		}

	$scene->writer->endTag();

$scene->end();
print $svgFile "\n";

close $svgFile;
