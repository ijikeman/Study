require 'Logger'

class Logger
  def self.initialize_logger
    @logger = Logger.new(STDOUT)
    @logger.level = Logger::INFO
    @logger
  end

  def self.logger
    @logger || initialize_logger
  end

  def logger
    Logger.logger
  end
end
