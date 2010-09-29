package Net::RabbitMQ::Simple::Role::Exchange;

use Moose::Role;
use Net::RabbitMQ::Simple::Types qw(Exchange ShortStr);
use Data::Dumper;
has exchange_type => (
  is      => 'rw',
  isa     => Exchange,
  default => 'direct'
);

has exchange_name => (
  is  => 'rw',
  isa => ShortStr
);

sub exchange_declare {
  
  my $self          = shift;
  my $exchange_name = shift;
  my %props         = @_;

  $self->exchange_name($exchange_name);

  $props{type} = $self->exchange_type
    if !defined( $props{type} )
      or $self->exchange_type( $props{type} );

  $props{exchange_type} = $props{type};
  delete $props{type};

  $self->conn->exchange_declare( $self->channel, $self->exchange_name,
    {%props} );
}

sub exchange_delete {
  my $self     = shift;
  my $exchange = shift;
  my %props    = @_;

  $self->conn->exchange_delete( $self->channel, $exchange, {%props} );
}

1;

