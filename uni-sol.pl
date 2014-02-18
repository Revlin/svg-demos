# This file defines routes for uni-sol (https://github.com/uni-sol/uni-sol)

get '/svg-demos' => sub {
	my $self = shift;
	getReadme($self, 'svg-demos/README.md');
};

1;
