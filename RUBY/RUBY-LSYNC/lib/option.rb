require 'optparse'

module Option
  DEFAULTS = {
    PID_FILE: '/var/run/sync.pid',
    TMP_PATH: '/data/tmp',
    WORKERS: 3,
    LOG_LEVEL: 'ERROR'
  }

  def self.options
    options ||= DEFAULTS.dup
  end

  def self.parse
    OptionParser.new do |opt|
      opt.on '-p PATH', '--pid PATH', 'Pid File Path' do |arg|
        options[:PID_FILE] = arg
      end
      opt.on '-t PATH', '--tmp PATH', 'Temporary Directory Path' do |arg|
        options[:TMP_PATH] = arg
      end
      opt.on '-n NUM', '--workers NUM', 'Max Worker Num' do |arg|
        options[:WORKERS] = arg
      end
      opt.on '-v', '--verbose', 'Verbose Mode' do |arg|
        options[:LOG_LEVEL] = 'DEBUG' if arg != nil
      end
      opt.parse!(ARGV)
    end
    options
  end
end
