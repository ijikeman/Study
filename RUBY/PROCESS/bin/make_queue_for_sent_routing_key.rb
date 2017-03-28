require "amqp"

EventMachine.run do
  connection = AMQP.connect(:host => '127.0.0.1')
  puts "Connected to RabbitMQ. Running #{AMQP::VERSION} version of the gem..."

  queue_name = 'routing_key_confirmation'
  channel  = AMQP::Channel.new(connection)
  queue    = channel.queue(queue_name, :auto_delete => true)
  puts "make QUEUE = '#{queue_name}'"
  queue.subscribe do |payload|
    puts "Recieved a message: #{payload}. Disconnecting..."
    connection.close { EM.stop }
  end
end
