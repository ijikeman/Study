module Cli
  def initialize(logger = nil)
    @options = Option.options.merge(Option.parse)
    Logging.logger(@options[:LOG_LEVEL])
  end

  def run
    Daemon.run
    # execute
  end
end
