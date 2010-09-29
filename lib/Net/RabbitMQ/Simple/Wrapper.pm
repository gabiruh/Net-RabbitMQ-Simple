package Net::RabbitMQ::Simple::Wrapper;

use Moose;
use Net::RabbitMQ;
use Net::RabbitFoot;
use Test::Net::RabbitMQ;
use namespace::autoclean;

has conn => (
  is         => 'rw',
  isa        => 'Object',
  lazy_build => 1,
);

with qw/
  Net::RabbitMQ::Simple::Role::Exchange
  Net::RabbitMQ::Simple::Role::Queue
  Net::RabbitMQ::Simple::Role::Publish
  Net::RabbitMQ::Simple::Role::Consume
  Net::RabbitMQ::Simple::Role::Tx
  /;

has hostname => (
  is      => 'rw',
  isa     => 'Str',
  default => 'localhost',
);

has user => (
  is      => 'rw',
  isa     => 'Str',
  default => 'guest'
);

has password => (
  is      => 'rw',
  isa     => 'Str',
  default => 'guest'
);

has vhost => (
  is      => 'rw',
  isa     => 'Str',
  default => '/'
);

has port => (
             is => 'ro',
             isa => 'Int'
);
has channel_max => (
  is      => 'rw',
  isa     => 'Int',
  default => 0
);

has frame_max => (
  is      => 'rw',
  isa     => 'Int',
  default => 131072
);

has heartbeat => (
  is      => 'rw',
  isa     => 'Int',
  default => 0
);

has channel => (
  is      => 'rw',
  isa     => 'Int',
  default => 1,
  trigger => \&_set_channel_open
);

sub _set_channel_open {
  my ( $self, $channel ) = @_;
  $self->conn->channel_open($channel) if $channel;
}

sub _build_conn {
  return Net::RabbitMQ->new;
}

# connect
sub connect {
  my $self = shift;

  $self->conn->connect(
    $self->hostname,
    {
      user        => $self->user,
      password    => $self->password,
      vhost       => $self->vhost,
      channel_max => $self->channel_max,
      frame_max   => $self->frame_max,
      hearbeat    => $self->heartbeat
    }
  );
}

sub disconnect {
  my $self = shift;

  #$self->conn->channel_close($self->channel);
  $self->conn->disconnect();
}

sub purge {
  my $self = shift;
  my $tag  = shift;
  $self->conn->purge( $self->channel, $tag );
}

sub ack {
  my $self = shift;
  my $tag  = shift;
  $self->conn->ack( $self->channel, $tag );
}

1;

