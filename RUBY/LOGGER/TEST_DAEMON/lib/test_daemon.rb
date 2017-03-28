class TestDaemon
  def initialize
    Logging.logger('DEBUG')
    Logging.logger.debug 'TestDaemon initialize'
  end

  def run
    Logging.logger.debug 'TestDaemon run'
  end
end
