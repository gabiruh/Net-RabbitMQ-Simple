#!/usr/bin/env perl

use Test::More tests => 2;
use strict;

use Net::RabbitMQ::Simple;

my $host = $ENV{'MQHOST'};

SKIP: {
  skip 'No $ENV{\'MQHOST\'}\n', 2 unless $host;

  my $mq = mqconnect {
    hostname => $host,
    user     => 'guest',
    password => 'guest',
    vhost    => '/'
  };

  exchange {
    name        => 'mtest_x',
    type        => 'direct',
    passive     => 0,
    durable     => 0,
    auto_delete => 1,
    exclusive   => 0
  };

  publish {
    exchange => 'mtest_x',
    queue    => 'mtest_get',
    route    => 'mtest_get_route',
    message  => 'message get',
    options  => { content_type => 'text/plain' }
  };

  my $getr = get;
  ok($getr);

  $getr = get;
  is( $getr, undef, 'get should return empty' );

  mqdisconnect;
}

1;

