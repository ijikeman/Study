require 'amqp'

puts "=> Channel#initialize example that uses a block"
puts

AMQP.start(:host => 'localhost') do |connection|
  AMQP::Channel.new do |channel, open_ok|
    puts "Channel ##{channel.id} is now open!"
  end

  show_stopper = Proc.new do
    $stdout.puts "Stopping..."

    connection.close {
      EM.stop { exit }
    }
  end

#  Signal.trap "INT", show_stopper
  EM.add_timer(10, show_stopper)
end
