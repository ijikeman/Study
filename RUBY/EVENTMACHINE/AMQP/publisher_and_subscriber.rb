require "amqp"

EventMachine.run do

  routing_key = 'key1'
  binding_key = 'key1'

  connection = AMQP.connect(:host => '127.0.0.1')
  puts "Connected to RabbitMQ. Running #{AMQP::VERSION} version of the gem..."

  channel  = AMQP::Channel.new(connection)
  queue    = channel.queue("queue_name", :auto_delete => true)
  exchange = channel.direct("exchange_name", :auto_delete => true)
  queue.bind(exchange, :routing_key => binding_key)
  exchange.publish "Hello, world!", :routing_key => routing_key

  queue.subscribe do |payload|
    puts "Received a message: #{payload}. Disconnecting..."

    connection.close {
      EM.stop { exit }
    }
  end

end
