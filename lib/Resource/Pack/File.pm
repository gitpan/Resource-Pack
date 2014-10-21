package Resource::Pack::File;
BEGIN {
  $Resource::Pack::File::VERSION = '0.02';
}
use Moose;
use MooseX::Types::Path::Class qw(File Dir);

with 'Resource::Pack::Installable',
     'Bread::Board::Service',
     'Bread::Board::Service::WithDependencies';

=head1 NAME

Resource::Pack::File - a file resource

=head1 VERSION

version 0.02

=head1 SYNOPSIS

    my $file = Resource::Pack::File->new(
        name         => 'test',
        file         => 'test.txt',
        install_from => data_dir,
    );
    $file->install;

=head1 DESCRIPTION

This class represents a file to be installed. It can also be added as a
subresource to a L<Resource::Pack::Resource>. This class consumes the
L<Resource::Pack::Installable>, L<Bread::Board::Service>, and
L<Bread::Board::Service::WithDependencies> roles.

=cut

=head1 ATTRIBUTES

=cut

=head2 file

Read-only attribute for the source file. Defaults to the service name.

=cut

has file => (
    is      => 'ro',
    isa     => File,
    coerce  => 1,
    lazy    => 1,
    default => sub { Path::Class::File->new(shift->name) },
);

=head2 install_from_dir

Base dir, where C<file> is located. Defaults to the C<install_from_dir> of the
parent resource. The associated constructor argument is C<install_from>.

=cut

has install_from_dir => (
    is         => 'rw',
    isa        => Dir,
    coerce     => 1,
    init_arg   => 'install_from',
    predicate  => 'has_install_from_dir',
    default    => sub {
        my $self = shift;
        if ($self->has_parent && $self->parent->has_install_from_dir) {
            return $self->parent->install_from_dir;
        }
        else {
            confess "install_from is required for File resources without a container";
        }
    },
);

=head2 install_as

The name to use for the installed file. Defaults to C<file>.

=cut

has install_as => (
    is      => 'rw',
    isa     => File,
    coerce  => 1,
    lazy    => 1,
    default => sub { shift->file },
);

=head1 METHODS

=cut

=head2 install_from_absolute

Entire path to the source file (concatenation of C<install_from_dir> and
C<file>).

=cut

sub install_from_absolute {
    my $self = shift;
    $self->install_from_dir->file($self->file);
}

__PACKAGE__->meta->make_immutable;
no Moose;

=head1 AUTHORS

  Stevan Little <stevan.little@iinteractive.com>

  Jesse Luehrs <doy at tozt dot net>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 Infinity Interactive, Inc.

This is free software; you can redistribute it and/or modify it under
the same terms as perl itself.

=cut

1;