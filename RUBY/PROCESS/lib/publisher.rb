require 'logging'
require 'server'

class Publisher
  class << self
    include Logging
    def publish(payload, routing_key, expiration=nil)
      ensure_exchange
      logger.info(payload)
      logger.info(routing_key)
      logger.info(expiration)

      if Lib::Server.connection.tcp_connection_established?
        logger.info('send routing_key')
        @exchange.publish(payload, routing_key: routing_key, expiration: expiration)
      end
    end

    def ensure_exchange
      # Verify whether the exchange already exists
      unless  @channel && [:opened, :opening].include?(@channel.status)
        @channel.close if @channel
        @channel = AMQP::Channel.new(Lib::Server.connection, auto_recovery: true)
        # @exchange = @channel.direct('amq.direct', nowait: false)
        @exchange = @channel.default_exchange
      end
      @exchange
    end
  end
end
