puts "=> Channel#prefetch"
puts

require 'amqp'
AMQP.start(:host => 'localhost') do |connection|
  ch = AMQP::Channel.new(connection, AMQP::Channel.next_channel_id, :prefetch => 1)
  ch.on_error do |ex|
    raise "Oops! there has been a channel-level exception"
  end


  show_stopper = Proc.new do
    $stdout.puts "Stopping..."

    connection.close {
      EM.stop { exit }
    }
  end

  Signal.trap "INT", show_stopper
  EM.add_timer(1, show_stopper)
end
