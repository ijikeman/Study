require 'eventmachine'
require 'amqp'

class Test
  @options = {
    :host => '127.0.0.1',
    :port => '5672'
  }
  @connection = nil
  attr_reader :connection

  def run
    EM.run do |conn|
      @@connection = AMQP.connect(@options)
      @@connection.on_open do
        test_open()
      end
      @@connection.on_disconnection do
        test_close
        EM.stop
      end
  
      print_boot_banner

      ch = AMQP::Channel.new(@@connection, auto_recovery: true) do |channel, _|
        channel.on_error do |ch, channel_close|
        end
        exchange = channel.direct("remote_settings")
        queue = channel.queue('keyABC').bind(exchange, routing_key: 'keyDEF')
        queue.subscribe(ack: false, &method(:handle_message))
        # @@connection.disconnect
      end
    end
  end
  
  private
  def handle_message
  end

  def print_boot_banner
    p 'booting'
  end

  def test_open
    p 'on_open'
  end
  def test_close
    p 'on_close'
  end
end

t = Test.new
t.run
