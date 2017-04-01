require "amqp"

EventMachine.run do
  connection = AMQP.connect(:host => '127.0.0.1')
  puts "Connected to RabbitMQ. Running #{AMQP::VERSION} version of the gem..."

  channel  = AMQP::Channel.new(connection)
  queue    = channel.queue("queue_name", :auto_delete => true)

#  biding_key = 'key1'
#  exchange = channel.direct('exchange_name', :auto_delete => true)
#  queue = channel.queue('queue_name').bind(exchange, routing_key: binding_key)

  queue.subscribe do |payload|
    puts "Received a message: #{payload}. Disconnecting..."

    connection.close {
      EM.stop { exit }
    }
  end
end
