package Net::RabbitMQ::Simple::Role::Tx;

use Moose::Role;

requires 'conn';

sub tx () { 
    my $self = shift;
    $self->conn->tx_select($self->channel); 
}

sub rollback() { 
    my $self = shift;
    $self->conn->tx_rollback($self->channel); 
}

sub commit() { 
    my $self = shift;
    $self->conn->tx_commit($self->channel); 
}

1;

