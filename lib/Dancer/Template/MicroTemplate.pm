package Dancer::Template::MicroTemplate;

use strict;
use warnings;

use Text::MicroTemplate::File;
use Dancer::ModuleLoader;
use Dancer::FileUtils 'path';

use vars '$VERSION';
use base 'Dancer::Template::Abstract';

$VERSION = '0.01';

my $_engine;

sub init {
    my $self = shift;

    my $mt_cfg = {
        use_cache  => 0,
        line_start => '%',
        tag_start  => $self->config->{start_tag} || '<%',
        tag_end    => $self->config->{stop_tag} || '%>',
    };

    if ($self->{settings} && $self->{settings}{appdir}) {
        my $path = path($self->{settings}{appdir}, 'views');
        $mt_cfg->{include_path} = [$path];
    }

    $_engine = Text::MicroTemplate::File->new(%$mt_cfg);
}

sub render($$$) {
    my ($self, $template, $tokens) = @_;

    die "'$template' is not a regular file"
      if ref($template) || (!-f $template);

    my $content = "";
    $content = $_engine->render_file($template, $tokens)->as_string;
    return $content;
}

1;
__END__

=pod

=head1 NAME

Dancer::Template::MicroTemplate - MicroTemplate wrapper for Dancer

=head1 SYNOPSIS

    use Dancer;
    use Dancer::FileUtils 'path';
    use Dancer::Template::MicroTemplate;

    my $engine = Dancer::Template::MicroTemplate->new;
    my $template = path('foo', 'bar.mt');
    my $rendered = $engine->render($template, {template_var1 => 1, template_var2 => 2});

    get '/' => sub {
        $rendered
    };
    dance;

=head1 DESCRIPTION

This class is an interface between Dancer's template engine abstraction layer
and the L<Text::MicroTemplate> module.

In order to use this engine, set the following setting as the following:

    template: micro_template

This can be done in your config.yml file or directly in your app code with the
B<set> keyword.

=head1 SEE ALSO

L<Dancer>, L<Text::MicroTemplate>

=head1 AUTHOR

This module has been written by Franck Cuny

=head1 LICENSE

This module is free software and is released under the same terms as Perl
itself.

=cut
