require "amqp"

EventMachine.run do
  binding_key = 'key1'
  routing_key = 'key1'

  connection = AMQP.connect(:host => '127.0.0.1')
  puts "Connected to RabbitMQ. Running #{AMQP::VERSION} version of the gem..."

  channel  = AMQP::Channel.new(connection)
  queue    = channel.queue('queue_name', :auto_delete => true)
  exchange = channel.direct('exchange_name', :auto_delete => true)
  queue.bind(exchange, :routing_key => binding_key)
  exchange.publish("Hello, world!", :routing_key => routing_key) do
    puts "sent: 'Hello world'"
    connection.close { EM.stop }
  end
end
