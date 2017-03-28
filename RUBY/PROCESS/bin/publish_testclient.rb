require "amqp"

EventMachine.run do
  routing_key = 'test_message'
  connection = AMQP.connect(:host => '127.0.0.1')
  puts "Connected to RabbitMQ. Running #{AMQP::VERSION} version of the gem..."

  channel  = AMQP::Channel.new(connection)
  # queue    = channel.queue(routing_key, :auto_delete => false)
  exchange = channel.direct('remote_settings')
  exchange.publish("Hello, world!", :routing_key => routing_key) do
    puts "sent: 'Hello world'"
    connection.close { EM.stop }
  end
end
