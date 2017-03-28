require 'logger'

module Logging
  def logger
    p 'ins method logger'
    Logging.logger
  end

  class << self
    def initialize_logger(logfile = STDOUT)
      p 'init logger'
      @logger = Logger.new(logfile)
      @logger.level = Logger::INFO
      @logger.level = Logger::DEBUG
    end

    def logger
      p 'class method logger'
      @logger || initialize_logger
    end
  end
end
