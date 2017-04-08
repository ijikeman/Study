puts "=> Channel#initialize example that uses a block"
puts

require 'amqp'
AMQP.start(:host => 'localhost') do |connection|
  AMQP::Channel.new do |channel|
    puts "Channel ##{channel.id} is now open!"
  end


  show_stopper = Proc.new do
    $stdout.puts "Stopping..."

    connection.close {
      EM.stop { exit }
    }
  end

  Signal.trap "INT", show_stopper
  EM.add_timer(2, show_stopper)
end
