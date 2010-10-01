#!/usr/bin/perl

use common::sense;
use Net::RabbitMQ::Simple;
use AnyEvent::Worker::Pool;
use Coro::Semaphore;

my $MAX_CONNECTS = 55;    # maximum simult. connects

my $MAX_TASKS = 10000;

my $connections = Coro::Semaphore->new($MAX_CONNECTS);

say "Start...";

my $task = 0;
my $tasks_done = 0;

my $cb = sub {
  my ($task) = @_;

  mqconnect { hostname => $ENV{MQHOST} };    # share
  exchange {
    name        => 'triagem',
    passive     => 0,
    durable     => 1,
    auto_delete => 1,
    exclusive   => 0
  };

  publish {
    exchange => 'triagem',
    queue    => 'triagem',
    route    => 'triagem_rota',
    message  => 'foobar' . $task,
  };

  mqdisconnect;
  return 1;
};

my $pool = AnyEvent::Worker::Pool->new( 50, $cb);

my $worker = sub {
  my $id = shift;
  $pool->do(
    "Test:$id",
    sub {
      return warn "Request died: $@\n" if $@;
      $connections->up;
      $tasks_done++;
      exit(0) if $tasks_done == $MAX_TASKS;
    }
  );
};

while () {
  $connections->down;
  $worker->($task++);
}
