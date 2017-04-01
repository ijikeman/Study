require "rubygems"
require "amqp"

EventMachine.run do
  connection = AMQP.connect(:host => '127.0.0.1')
  puts "Connected to RabbitMQ. Running #{AMQP::VERSION} version of the gem..."

  channel  = AMQP::Channel.new(connection)
  queue    = channel.queue("examples", :auto_delete => true)
  exchange = channel.direct("")
  exchange.publish "Hello, world!", :routing_key => queue.name
#
#  queue.subscribe do |payload|
#    puts "Received a message: #{payload}. Disconnecting..."
#
#    connection.close {
#      EM.stop { exit }
#    }
#  end

end
