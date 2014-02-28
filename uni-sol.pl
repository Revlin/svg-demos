# This file defines routes for uni-sol (https://github.com/uni-sol/uni-sol)

get '/svg-demos' => sub {
	my $self = shift;
	getReadme($self, 'svg-demos/README.md');
};

get '/svg-edit' => sub {
	my $self = shift;
	my $port  = $self->req->url->port;
	my $base_url = '';
    ( $base_url, $port ) = $self->req->url->base =~ /(.*[\w|\-|\.]+)(\:\d+)?/;
	getFrame($self, 
		$base_url, $port, 
		'/svg-demos/svg-edit/editor/svg-editor.html', 
		'Uni:Sol :: svg-edit'
	);
};

1;
