require 'eventmachine'

class Connector < EM::Connection
  def point_init
    puts "Getting /"
    send_data "GET / HTTP/1.1\r\nHost: MagicBob\r\n\r\n"
  end

  def receive_data(data)
    puts "Received #{data.length} bytes"
  end
end

EM.run do
  EM.connect("127.0.0.1", 10000, Connector)
end
