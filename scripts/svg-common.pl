#!/usr/bin/perl
# You may need to change the above path to perl
use strict;
use warnings;

# Common SVG subroutines

sub makeBouncePath( $ $ $ $ $ $ $ $ $ ); # \$ref_to_xml_writer, $total_time, $ground_height, $bounce_height, $number_of_bounces, $radius_of_ball, $x_offset, $delta_for_horizonatal_motion, \$ref_to_path (optional)

sub makeBouncePath( $ $ $ $ $ $ $ $ $ ) {
	# Create bouncing animation path for elliptical shape
	my ($writer, $ttime, $ground, $bounce_height, $bounces, $rx, $sx, $dx, $dref) = @_;
	$ttime = $ttime / 10;
	my $begin = '0s';
	my $from = $rx;
	my $to = $rx;
	my $pi = atan2(1,1) * 4;
	my $x = $sx;
	my $y = int( 1 + $ground - abs($bounce_height * sin( ($x/($ttime*2/$bounces)) * 2 * $pi )) );
	my $points = "M $sx $y";
	my $dur = 0.0005*$ttime / $bounces;
	$dx = $bounces if( $dx > $bounces );
	$$dref = $points;
	
	for( my $n=$ttime; $x<$n; $x+=$bounces, $sx+=$dx ) {
		my $animid = "anim$x";
		 if( $y > $ground*0.98 ) { 
			$to = $rx + ($rx/4)*($y/$ground);
		} else {
			$to = $rx;
		}
		$y = int( ($ground+$x/$n*50) - abs($bounce_height * sin( ($x / (($n*2)/$bounces)) * (2*$pi) )) );
		unless( $points =~ /M\s\d+\s$y/ ) {
			$$writer->emptyTag(
				'animateMotion',
				id => $animid,
				path => $points. " L $sx $y",
				begin => $begin,
				dur => $dur.'s',
				fill => 'freeze',
			);
			$$writer->emptyTag(
				'set',
				attributeName => 'rx',
				from => $from,
				to => $to,
				begin => $begin,
				dur => $dur.'s',
				fill => 'freeze',
			);
			$begin = $animid.'.end';
			my $px = $x * 400/$ttime + $sx;
			$$dref .= " L $px $y";
			$from = $to;
		}
		$points = "M $sx $y";
		$ground -= 40 / ($n/$bounces);
	}
}
1;