package Net::RabbitMQ::Simple::Role::Publish;

use Moose::Role;

requires 'conn';

has 'body' => (
    is => 'rw', 
    isa => 'Str'
);

has 'mandatory' => (
    is => 'rw', 
    isa => 'Bool', 
    default => 0
);

has 'immediate' => (
    is => 'rw', 
    isa => 'Bool', 
    default => 0
);

sub publish {
    my $self = shift;
    my $body = shift;
    my %props = @_;

    $self->conn->publish($self->channel, $self->routing_key, $body,
        {
            exchange => $self->exchange_name,
            mandatory => $self->mandatory,
            immediate => $self->immediate,
        },
        {
            %props
        }
    );

}

1;

