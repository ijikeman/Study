$:.unshift File.dirname(__FILE__)

# For setup_options
require 'optparse'

# For setup_handler
require 'chef/handler'
require 'chef/handler/json_file'

require 'logging'

# For run
require 'server'

module Lib
  class CLI
    include Singleton
    include Logging
    attr_accessor :environment

    def initialize
      @code = nil
    end

    def parse(args=ARGV)
      @code = nil
      # 引数をparseして@optionsのインスタンス変数に格納
      setup_options(args)

      # Chef::Config[:report_handlers], Chef::Config[:exception_handlers]を設定している
      setup_handlers

      # Logの対象ファイルやLogLevelの設定をしている
      initialize_logger

      # Queue.new
      initialize_reporting_queue

      if !pid.nil? && process_running?(pid)
        abort "Error: already running with $pid #{pid}"
      end

      daemonize
      write_pid_file
    end

    def run
      print_boot_banner
      @server = Lib::Server.new({:host => '127.0.0.1', :port => '5672'})

      begin
        @server.run
      rescue Interrupt
#        remove_pid_file
       @logger.info 'Shutting down'
        die 0
     end
    end

    DEFAULTS = {
      host:        ENV['PHX_AMQP_HOST'] || 'steelapp01.bonnowlabs.com',
      port:       (ENV['PHX_AMQP_PORT'].to_i if ENV['PHX_AMQP_PORT']) || 5672,
      vhost:       ENV['PHX_AMQP_VHOST'] || '/niboshi_pro_sandbox',
      user:        ENV['PHX_AMQP_USER'] || 'jackalope',
      pass:        ENV['PHX_AMQP_PASS'] || 'green_apple',
      ssl:         ({ ssl_version: :TLSv1 } if ENV['PHX_AMQP_SSL'] == 'true'),
      chef_repo:   ENV['PHX_CHEF_REPO'] || '/var/chef',
      routing_key: ENV['PHX_ROUTING_KEY'],
      public_key:  ENV['PUBLIC_KEY_PATH'] || '/RUBY/PROCESS/etc/public_key.txt',
      private_key: ENV['PRIVATE_KEY_PATH'],
      pidfile: '/tmp/daemon.pid',
      logfile: STDOUT
    }

    private
    def print_boot_banner
      msg = options[:daemon] ? "in daemon mode with $pid #{pid}" : "in single mode, hit Ctrl-C to stop"
      logger.info "starting ...#{msg}"
      logger.info "Running in #{RUBY_DESCRIPTION}"
      logger.info "* Environment: #{environment}"
    end

    # Returns +true+ the process identied by +pid+ is running.
    def process_running?(pid)
      ::Process.getpgid(pid) != -1
    rescue Errno::EPERM
      true
    rescue Errno::ESRCH
      false
    end

    def pid
      if path = options[:pidfile]
        File.exist?(path) ? open(path).read.to_i : nil
      end
    end

    def setup_options(args)
      cli = parse_options(args)
      set_environment cli[:environment]
      options.merge!(cli)
    end

    def options
      @options ||= DEFAULTS.dup
    end

    # Jackalope::Handler
    def setup_handlers
      ## Set default handler
      handlers = [Chef::Handler.new]

      ## Add JsonFile report
      if options[:json_report]
        handlers << Chef::Handler::JsonFile.new
      end

      setup_chef_config(handlers)
    end

    def setup_chef_config(handlers)
      [:report_handlers, :exception_handlers].each do |key|
        Chef::Config[key].concat(handlers)
      end
    end
    # END_Jackalope::Handler

    def initialize_logger
      Logging.initialize_logger
      # Logging.initialize_logger(options[:logfile]) if options[:logfile]
    #   logger.level = Logger::DEBUG if options[:verbose]
    end

    # Jackalope::Reporting
    def initialize_reporting_queue
      @queue = Queue.new
    end
    # END_Jackalope::Reporting

    def daemonize
      begin
        Process.daemon(true, true)
      rescue
        STDERR.puts "[ERROR] #{self.class.name}.daemonize #{e}"
        exit 1
      end
    end

    def write_pid_file
      if path = options[:pidfile]
        File.open(path, 'w') { |f| f.puts Process.pid }
      end
    end

    # 引数をparseしてreturn optsしている
    def parse_options(args)
      opts = Hash.new
      @parser = OptionParser.new do |o|
        o.on '-c VALUE', '--retry-count VALUE', 'Retry count num' do |arg|
          opts[:c] = arg
        end
        o.on '-e ENV', '--environment ENV', 'Set application environment to ENV'
      end
      @parser.banner = "jackalope [options]" 
      @parser.parse!(args)
      opts
    end

    # 
    def set_environment(cli_env)
      @environment = cli_env || ENV['JACKALOPE_ENV'] || 'development'
    end
  end
end
