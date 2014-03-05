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
		'width' => $width,
		'height' => $height,
		'title' => "Shatter Test",
		'desc' => "Creating and animating masked fragments"
	} );
print $scene->title, "\n";
print $scene->desc, "\n";
	
#	my $first_wave = waveline->new( $scene, {
#			'name' => "simple wave",
#			'color' => [ 127, 127, 256 ],
#			'dots' => 1
#		} );
#	print $first_wave->name, "\n";
#	$first_wave->draw($width, $height, 24);
	
$scene->end();

close $svgFile;
