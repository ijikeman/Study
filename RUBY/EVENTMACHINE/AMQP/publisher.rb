require "rubygems"
require "amqp"

EventMachine.run do
  connection = AMQP.connect(:host => '127.0.0.1')
  puts "Connected to RabbitMQ. Running #{AMQP::VERSION} version of the gem..."

  routing_key = 'queue_name'

  channel  = AMQP::Channel.new(connection)
  exchange = channel.direct("")
#  exchange = channel.default_exchange
  queue = channel.queue("queue_name", :auto_delete => false)
  exchange.publish "Hello, world!", :routing_key => routing_key do
    connection.close {
      EM.stop { exit }
    }
  end

end
