require 'logging'
require 'subscriber'
require 'publisher'
require 'version'

module Lib
  class Server
    include Logging

    attr_accessor :options, :connection
    @@connection = nil

    def initialize(options)
      @options = options
      @jk_heartbeat = 1
    end

    def run
      require "amqp"
      EM.run do
        @@connection = AMQP.connect(@options)
        @@connection.on_open do
          logger.info "Connected to AMQP broker: #{@@connection.broker_endpoint}"
          logger.info "Jackalope is ready for subscription!"

          # Send the routing-key to Niboshi Pro (subscribers).
          send_routing_key

          # Send a heartbeat once to Niboshi Pro (subscribers)
          # when booting Jackalope.
          send_heartbeat
        end

        print_boot_banner

        # if @jk_heartbeat
        #   EM.add_periodic_timer(@jk_heartbeat) {
        #     puts 'Tick...'
        #     # send_heartbeat
        #   }
        # end

        # AMQP::Channel.new(@@connection, auto_recovery: true) do |channel, _|
        #   channel.on_error do |ch, channel_close|
        #     logger.error "[channel-level exception] server: code=#{channel_close.reply_code}, message=#{channel_close.reply_text}"
        #   end

        #   setup_subscriber(channel)
        # end

        # EM.add_timer(5) do
        #   puts 'DAEMON STOP'
        #   EM.stop
        # end
      end
    end

    class << self
      def connection
        @@connection
      end
    end

    private
    def send_routing_key
      reply(routing_key_message, 'routing_key_confirmation')
    end

    def routing_key_message
      { "body"=>{ "public_key"=>public_key }, "routing_key"=>routing_key }
    end

    def send_heartbeat
      logger.info "Sending a heartbeat..."
      reply(heartbeat_message, 'heartbeat', expiration_period)
    end

    def heartbeat_message
      { "body"=>{ "greeting"=>"yo", "version" => VERSION::VERSION }, "routing_key"=>routing_key }
    end

    def expiration_period
      #@jk_heartbeat ? (@jk_heartbeat * HEARTBEAT_EXPIRATION_BASE).to_i.to_s : nil
      nil
    end

    def reply(payload, routing_key, expireation=nil)
      Publisher.publish(Oj.dump(payload, mode: :compat), routing_key, expireation)
      #Publisher.publish(dump_message(payload), routing_key, expireation)
    end

    def print_boot_banner
      puts 'SERVER START'
    end

    def setup_subscriber(channel)
      subscriber = Subscriber.new(channel)
      subscriber.subscribe
      # @subscribers << subscriber
    end

    def routing_key
      'ROUTING_KEY'
    end

    def public_key
      File.read('/RUBY/PROCESS/etc/public_key.txt')
    end
  end
end
