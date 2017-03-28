require 'logging'
require 'chef/client'
require 'oj'

class Subscriber
  include Logging

  class Handler
    def initialize
    end

    def handle_message(message)
      job_type = message['body']['job_type']
      event_list = fetch_handlers(job_type)
      ::EM::Iterator.new(event_list, event_list.length).each do |entry|
        begin
          entry.__new__(message.merge!('routing_key'=>ROUTING_KEYS[job_type])).perform
        rescue => e
          logger.fatal e
          logger.fatal e.backtrace.join("\n")
        end
      end
    end
  end

  def initialize(channel, exchange_name: "remote_settings")
    @channel = channel
    @exchange_name = exchange_name
    @routing_key = 'test_message'
    @handler = Subscriber::Handler.new
  end

  def subscribe
    @exchange = @channel.direct(@exchange_name)
    @queue = @channel.queue(@routing_key).bind(@exchange, routing_key: @routing_key)
    # subscribeするとqueueを受け取るまで待機する
    @queue.subscribe(ack: false, &method(:handle_message))
    # @queue.subscribe do |payload|
    #   puts "Received a message: #{payload}. Disconnecting..."
    #   EM.stop
    # end
  end

  # subscribeの戻り値としてAMQP connectionとpayloadを受け取る
  def handle_message(metadata, payload)
    logger.info "Start handling metadata: #{metadata}"
    logger.info "Start handling payload: #{payload}"

    setup_default_handlers(@handler)
    load_message(payload)
    @handler.handle_message(@parsed_message)
    EM.stop
  end

  def load_message(payload)
    @parsed_message = Oj.load(payload)
  end

  def setup_default_handlers(handler)
    # handler.store('common',  RubberDuck)
    handler.store('chef',    'ChefClient')
    # handler.store('diag',    ChefClient)
    # handler.store('command', Commander)
  end
end
