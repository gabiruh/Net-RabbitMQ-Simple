package Net::RabbitMQ::Simple::Types;
use warnings;
use strict;

use MooseX::Types::Moose qw(Str Int);
use MooseX::Types -declare => [qw(ShortStr VHostStr RoutingKey Exchange SimpleString)];


subtype SimpleString,
  as Str,
  where { length($_) <= 255 },
  message { 'String has length > 255' };

subtype ShortStr, 
  as SimpleString, 
  where { /^[\w\-_\.:]+$/ };

subtype VHostStr,
  as SimpleString,
  where { m{^[\w\/\-_]+$} },
  message { 'Invalid VHost name' };

subtype RoutingKey, 
  as SimpleString;

enum Exchange, qw/direct topic fanout headers/;

1;
