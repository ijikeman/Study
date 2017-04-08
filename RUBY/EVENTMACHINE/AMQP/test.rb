#!/usr/bin/env ruby
# encoding: utf-8

require 'eventmachine'
require 'amqp'

EventMachine.run do
  connection = AMQP.connect(:host => '127.0.0.1')
  connection.disconnect {
    EventMachine.stop
  }
end
