require 'logger'

class Logging
  def self.logger(level=nil, output=nil)
    @logger ||= init(level, output)
  end

  private
  def self.init(level, output)
    level ||='ERROR'
    output ||=STDERR
    logger = Logger.new(output)
    logger.level = set_level(level)
    logger
  end

  def self.set_level(level)
    case level
    when 'FATAL'
      Logger::FATAL
    when 'ERROR'
      Logger::ERROR
    when 'WARN'
      Logger::WARN
    when 'INFO'
      Logger::INFO
    when 'DEBUG'
      Logger::DEBUG
    else
      Logger::ERROR
    end
  end
end
