#!/usr/bin/perl
use utf8;
use strict;
use warnings;

# Common SVG classes and subroutines
use XML::Writer;

{ package scene;
# Create a filled backdrop and begin the scene

	my( $writer, $svgFile, $width, $height, $title, $desc ); 
	$svgFile = undef;
	($width, $height) = (640, 360);
	$title =  "Default Scene";
	$desc = <<SCENEDESC;

Uni:Sol(http://uni-sol.org) by Revlin John(mailto:revlin\@uni-sol.org) is licensed under the Creative Commons Attribution-ShareAlike 3.0 New Zealand License 2013(http://creativecommons.org/licenses/by-sa/3.0/nz/deed.en_GB) and further licesnsed under the Peer Production License(http://p2pfoundation.net/Peer_Production_License).
SCENEDESC
	
	sub new( $ ) {
		my( $self, $props ) = @_;
		
		my $svgFile = $props->{'svgFile'} if ( $props->{'svgFile'} );
		die "scene->new() requires a filehandle assigned to scene->{svgFile}" if(! $svgFile );
		
		my( $writer, $width, $height, $title, $desc ) = ( $writer, $width, $height, $title, $desc );
		$width = $props->{'width'} if ( $props->{'width'} );
		$height = $props->{'height'} if ( $props->{'height'} );
		$title = $props->{'title'} if ( $props->{'title'} );
		$desc =  $props->{'desc'} . $desc if ( $props->{'desc'} );
		$writer = XML::Writer->new( OUTPUT => $svgFile );
		$props = {
			'class'		=> $self,
			'writer'	=> $writer, 
			'svgFile'	=> $svgFile, 
			'width'		=> $width, 
			'height'	=> $height, 
			'title'		=> $title, 
			'desc'		=> $desc
		};
		$writer->setDataMode(1);	# Auto insert newlines
		$writer->setDataIndent(2);	# Auto indent
		$writer->xmlDecl("utf-8"); 	# XML declaration: <?xml version="1.0" encoding="utf-8"?>
		$writer->startTag(	
			'svg',
			'xmlns' => 'http://www.w3.org/2000/svg',
			'xmlns:xlink' => 'http://www.w3.org/1999/xlink',
			height => $height,
			width => $width,
		);

		$writer->startTag('title');
			print $svgFile $title;
		$writer->endTag('title');
	
		$writer->startTag('desc');
			print $svgFile $desc . "\n";
		$writer->endTag('desc');
		
		$writer->emptyTag(
			'rect',
			'id' => "backdrop",
			'x' => "0",
			'y' => "0",
			'width' => "$width",
			'height' => "$height",
			'style' => "stroke:none;fill:rgb(0, 0, 0)"
		);
		
		bless $props, "scene";
		return $props;
	}
		
	sub end() {
		my $self = shift;
		my $writer = $self->{'writer'};
		$writer->endTag('svg');
	}
	
	sub title() {
		my $self = shift;
		return $self->{'title'};
	}
	sub desc() {
		my $self = shift;
		return $self->{'desc'};
	}

}

{ package waveline;
	@waveline::ISA = qw(scene);
	
	my( $name, $color, $position, $size, $smoothing, $dots, $thick, $mod, $mod_op );
	$name = "a waveline instance";
	$color = [ 1, 1, 1 ];
	
	sub new( $ $ ) {
		my ($self, $scene, $props) = @_;
		my( $name, $color, $position, $size, $smoothing, $dots, $thick, $mod, $mod_op ) = ( $name, $color, $position, $size, $smoothing, $dots, $thick, $mod, $mod_op );
		
		$name = $props->{'name'} if( $props->{'name'} );
		$color = $props->{'color'} if( $props->{'color'} );
		$thick = $props->{'thick'} if( $props->{'thick'} );
		$dots = $props->{'dots'} if( $props->{'dots'} );
		$props = { 
			'class'		=> $self,
			'name' 		=> $name,
			'color' 	=> $color, 
			'position'	=> $position, 
			'size'		=> $size, 
			'smoothing'	=> $smoothing, 
			'dots'		=> $dots, 
			'thick'		=> $thick, 
			'mod'		=> $mod, 
			'mod_op'	=> $mod_op,
			'scene'		=> $scene,
			# props inherited from scene
			'writer'	=> $scene->{'writer'}, 
			'svgFile'	=> $scene->{'svgFile'}, 
			'width'		=> $scene->{'width'}, 
			'height'	=> $scene->{'height'}, 
			'title'		=> $scene->{'title'}, 
			'desc'		=> $scene->{'desc'}
		};
		bless $props, "waveline";
		return $props;
	}
	
	sub draw( $ $ $ ); # args: $width_of_screen, $height_of_screen
	sub draw( $ $ $ ) {
		my( $self, $width, $height, $cycles ) = @_;
		my $class = $self->{'class'}; 
		my $name = $self->{'name'};
		my $writer = $self->{'writer'};
		my $stroke = "rgb(".$self->{color}->[0].",".$self->{color}->[1].",".$self->{color}->[2].")";
		my $thick = "2.0";
		$thick = "4.0" if( $self->{thick} );
		my $dash = "none";
		$dash = "2 2" if( $self->{dots} );
		$dash = "4 4" if( $self->{dots} && $self->{thick} );
		$cycles = 16 if(! $cycles );
		my $path = "M 0 ".($height/2)." ";
		for( my $i=1; $i<$cycles; $i+=2 ) {
			my $a = (($i-1)%4)? $height : 0;
			$path = $path.
				"Q ".($i*$width/$cycles)." ".($a).", ".
				(($i+1)*$width/$cycles)." ".($height/2)." ";
		}
		for( my $i=$cycles; $i>0; $i-=2 ) {
			my $a = ($i%4)? 5*$height/12 : 7*$height/12 ;
			$path = $path.
				"Q ".(($i-1)*$width/$cycles)." ".($a).", ".
				(($i-2)*$width/$cycles)." ".($height/2)." ";
		}
		
		$writer->emptyTag(
			'path',
			'id' => "$name",
			'class' => "$class",
			'style' => 
				"stroke:$stroke;".
				"stroke-width:$thick;".
				"fill:none;".
				"stroke-dasharray:$dash;",
			'd' => "$path"
		);
	}
	
	sub name() {
		my $self = shift;
		return $self->{'name'};
	}
}

{ package shatter;
# Subs to render multi-layered, masked fragments, that can be
# animated to produce various crumble, explosion and shatter fx
	@shatter::ISA = qw(scene);
	
}

{ package bounce;
# Subroutines used to define animations in svg-bounce

	# args: \$ref_to_xml_writer, $total_time, $ground_height, $bounce_height, $number_of_bounces, $radius_of_ball, $x_offset, $delta_for_horizonatal_motion, \$ref_to_path (optional), \$loop (optional)
	sub makeBouncePath( $ $ $ $ $ $ $ $ $ );

	sub makeBouncePath( $ $ $ $ $ $ $ $ $ ) {
		# Create bouncing animation path for elliptical shape
		my ($writer, $ttime, $ground, $bounce_height, $bounces, $rx, $sx, $dx, $dref, $loop) = @_;
		$ttime = $ttime / 10;
		my $begin = "0s";
		my $fx = int( ($ttime - $sx)/$bounces )*$bounces + $sx;
		if( $loop ) {
			print "First x is $fx\n";
		 	print ";bounce$fx.end\n";
		}
		my $from = $rx;
		my $to = $rx;
		my $pi = atan2(1,1) * 4;
		my $x = $sx;
		my $sy = int( 1 + $ground - abs($bounce_height * sin( ($x/($ttime*2/$bounces)) * 2 * $pi )) );
		my $y = $sy;
		my $points = "M $sx $y";
		my $dur = 0.0005*$ttime / $bounces;
		$dx = $bounces if( $dx > $bounces );
		$$dref = $points;
		
		for( my $i=0, my $n=$ttime; $x<$n; $x+=$bounces, $sx+=$dx, $i++ ) {
			my $animid = "bounce$x";
			
			if( $y > $ground*0.98 ) { 
				$to = $rx + ($rx/4)*($y/$ground);
			} else {
				$to = $rx;
			}
			$y = int( ($ground + ($x/$n)*50) - abs($bounce_height * sin( ($x / (($n*2)/$bounces)) * (2*$pi) )) );
			
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
				if( ($y > $ground) && ($loop) ) { 
					$begin = $animid.".end;bounce$fx.end";
					$loop = 0;
				} else {
					$begin = $animid.'.end';
				}
				my $px = $x * 400/$ttime + $sx;
				$$dref .= " L $px $y";
				$from = $to;
			}
			$points = "M $sx $y";
			$ground -= 40 / ($n/$bounces);
		}
	}
	
}

1;
