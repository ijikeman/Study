module Daemon
  class << self
    def run
      process_running
      ::Process.daemon(true, true)
      write_pid
    end

    private
    def write_pid
      File.open(@options[:PID_FILE], 'w') { |f| f.puts Process.pid }
    end

    def read_pid
      File.exist?(@options[:PID_FILE]) ? open(@options[:PID_FILE]).read.to_i : nil
    end

    def process_running
      if read_pid.nil? == false && process_running_from_pid(read_pid) == true
        abort "Already running with pid #{read_pid}"
      end
    end

    def process_running_from_pid(pid)
      ::Process.getpgid(pid) != -1
      rescue Errno::EPERM
        true
      rescue Errno::ESRCH
        false
    end
  end
end
