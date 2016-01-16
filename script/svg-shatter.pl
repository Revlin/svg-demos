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
		
my( $swidth, $sheight, $rows ) = ( 360, 320, 40 );
	
	$scene->writer->startTag( 'g',
		id => "char-test",
		class => "shatter-layer0",
		transform => "translate(". ($width-$swidth)/2 .",0)"
	);
	
		$scene->writer->startTag( 'defs' ); #<defs>
			$scene->writer->emptyTag( 'image',
				id => "char-test-shatter-img",
				'xlink:href' => "images/char-front.png",
				x => "0",
				y => "0",
				width => "$height", # some wierdness about specifying the image dimensions
				height => "$height"
			);
			$scene->writer->emptyTag( 'image',
				id => "char-test-background-img",
				'xlink:href' => "images/char-back.png",
				x => "0",
				y => "0",
				width => "$height", # some wierdness about specifying the image dimensions
				height => "$height"
			);
		$scene->writer->endTag(); #</defs>
					
		$scene->writer->emptyTag( 'use',
			transform => "translate(0,0)",
			'xlink:href' => "#char-test-background-img",
			x => "0", 
			y => "0"
		);
		
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

				$scene->writer->startTag( 'g', #<g>
					class => "shatter-layer$layerId",
					transform => "translate(0,0)"
				);
					$scene->writer->startTag( 'clipPath', 
						id => "char-test-shatter-layer$layerId-clip"
					);
						$scene->writer->emptyTag( 'path', 
							d => "M $x $y L ".($x+$w)." $y L ".($x+$w)." ".($y+$h)." L $x ".($y+$h)." Z",
							transform => "translate(0,". ($height-$sheight)/2 .")"
						);
					$scene->writer->endTag();
					
					$scene->writer->emptyTag( 'rect',
						transform => "translate(0,0)",
						style => "fill:none; stroke:none; clip-path:url(#char-test-shatter-layer$layerId-clip);",
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
						style => "stroke:none;", # show fragment outline by commenting this line out
						d => "M $x $y L ".($x+$w)." $y L ".($x+$w)." ".($y+$h)." L $x ".($y+$h)." Z",
						transform => "translate(0,". ($height-$sheight)/2 .")"
					);					
					my $points = "M 0 0";
					my @v = (0.0, 1.0);
					$v[0] = 5 - (10*rand);
					$v[1] = 1 + (10*rand);
						
					for( my $i=0; $i < 3; $i++ ) {
						my $animid = "fall$layerId$i";
						my $begin = $s*(0.3 + 0.03*rand);
						my $dur = 0.33;
						$v[0] += $v[0] * 0.1;
						$v[1] += $v[1] * 9.0;

						$scene->writer->emptyTag(
							'animateMotion',
							id => $animid,
							path => $points. " L ".$v[0]." ".$v[1],
							begin =>  ($i < 1)? $begin.'s': "fall$layerId".($i-1).'.end',
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
		
		$scene->writer->emptyTag( 'rect',
			style => "fill:none; stroke:none", #"fill:none; stroke:#0000ff; stroke-width:2px;",
			x => "0", 
			y => "0",
			width => "$swidth",
			height => "$sheight",
			transform => "translate(0,". ($height-$sheight)/2 .")"
		);
	$scene->writer->endTag(); #</g>

$scene->end();
print $svgFile "\n";

close $svgFile;
