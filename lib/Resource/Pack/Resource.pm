package Resource::Pack::Resource;
BEGIN {
  $Resource::Pack::Resource::VERSION = '0.02';
}
use Moose;
use MooseX::Types::Path::Class qw(Dir);

extends 'Bread::Board::Container';
with 'Resource::Pack::Installable';

=head1 NAME

Resource::Pack::Resource - a collection of resources

=head1 VERSION

version 0.02

=head1 SYNOPSIS

    my $resource = Resource::Pack::Resource->new(
        name         => 'test',
        install_from => data_dir,
    );
    $resource->add_file(
        name => 'test1',
        file => 'test.txt'
    );
    $resource->add_dir(
        name => 'test2',
    );
    $resource->add_url(
        name => 'jquery',
        url  => 'http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js',
    );
    $resource->install;

=head1 DESCRIPTION

This class is a collection of other resources. It can contain
L<Resource::Pack::File>, L<Resource::Pack::Dir>, L<Resource::Pack::URL>, and
other L<Resource::Pack::Resource> objects. It is a subclass of
L<Bread::Board::Container>, and consumes the L<Resource::Pack::Installable>
role.

=cut

=head1 ATTRIBUTES

=cut

=head2 install_from_dir

Base dir, where the contents will be located. Defaults to the
C<install_from_dir> of the parent resource. The associated constructor argument
is C<install_from>.

=cut

has install_from_dir => (
    is         => 'rw',
    isa        => Dir,
    coerce     => 1,
    init_arg   => 'install_from',
    predicate  => 'has_install_from_dir',
    lazy       => 1,
    default    => sub {
        my $self = shift;
        if ($self->has_parent) {
            return $self->parent->install_from_dir;
        }
        else {
            confess "install_from_dir is required for root containers";
        }
    },
);

=head1 METHODS

=cut

=head2 install

The install method for this class installs all of the resources that it
contains, except for other L<Resource::Pack::Resource> resources. To also
install contained Resource::Pack::Resource resources, use the C<install_all>
method.

=cut

sub install {
    my $self = shift;
    for my $service_name ($self->get_service_list) {
        my $service = $self->get_service($service_name);
        $service->install if $service->does('Resource::Pack::Installable');
    }
}

=head2 install_all

This method installs all contained resources, including other
L<Resource::Pack::Resource> resources.

=cut

sub install_all {
    my $self = shift;
    for my $service_name ($self->get_service_list) {
        my $service = $self->get_service($service_name);
        $service->install if $service->does('Resource::Pack::Installable');
    }
    for my $container_name ($self->get_sub_container_list) {
        my $container = $self->get_sub_container($container_name);
        $container->install_all
            if $container->does('Resource::Pack::Installable');
    }
}

=head2 add_file

Creates a L<Resource::Pack::File> resource inside this resource, passing any
arguments along to the constructor.

=cut

sub add_file {
    my $self = shift;
    require Resource::Pack::File;
    $self->add_service(Resource::Pack::File->new(
        @_,
        parent => $self,
    ));
}

=head2 add_dir

Creates a L<Resource::Pack::Dir> resource inside this resource, passing any
arguments along to the constructor.

=cut

sub add_dir {
    my $self = shift;
    require Resource::Pack::Dir;
    $self->add_service(Resource::Pack::Dir->new(
        @_,
        parent => $self,
    ));
}

=head2 add_url

Creates a L<Resource::Pack::URL> resource inside this resource, passing any
arguments along to the constructor.

=cut

sub add_url {
    my $self = shift;
    require Resource::Pack::URL;
    $self->add_service(Resource::Pack::URL->new(
        @_,
        parent => $self,
    ));
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