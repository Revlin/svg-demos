# This file defines routes for uni-sol (https://github.com/uni-sol/uni-sol)
use Mojo::Log;

sub getSVGReadme {
	my( $self, $readme ) = @_;
	my $log = Mojo::Log->new();
	my $URL = $self->req->url->base;
	my( $fh, $mh, $save_line_sep );
	my $mark2html = '';
	open $mh, '>', \$mark2html;
	my $mark = Markdent::Parser->new(
		dialect => 'GitHub',
		handler => Markdent::Handler::HTMLStream::Fragment->new(
			output => $mh
		)
	);
	
	open $fh, '<'.$readme;
	$save_line_sep = $/; # Save line seperator vaule
    undef $/; # Allows one pass input of entire file
	$mark->parse( markdown => <$fh> );
    $/ = $save_line_sep; # Restore line seprator
	close $fh;
	close $mh;
	
	my( $apppath ) = $readme =~ /([\w\-]+\/)\w+\.md/;
	$apppath = $URL.'/'.$apppath if( $apppath );
	$apppath = $URL unless( defined $apppath );
	$mark2html = rel2AbsURI( 
		$mark2html, 
		$URL.'/',
		$apppath
	);
	
	($readme) = $readme =~ /(\w+)\//;
	#$log->debug( $readme ."\n" );
	$mark2html = "\n<div class=\"$readme\">\n". $mark2html ."\n</div>\n";
	#$log->debug( $mark2html ."\n" );
	
	$self->stash( 
		url => $URL,
		version => $version,
		mark2html => $mark2html,
		svgApp => '/svg-demos/data/bounce.rl.svg'
	);
	$self->render('readme');
};

get '/svg-demos' => sub {
	my $self = shift;
	getSVGReadme($self, 'svg-demos/README.md');
};

get '/svg-edit' => sub {
	my $self = shift;
	my $port  = $self->req->url->port;
	my $base_url = '';
    ( $base_url, $port ) = $self->req->url->base =~ /(.*[\w|\-|\.]+)(\:\d+)?/;
	getFrame($self, 
		$base_url, $port, 
		'/svg-demos/svg-edit/build/release/svg-editor.html', 
		'Uni:Sol :: svg-edit'
	);
};

1;
