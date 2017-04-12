class Locktest
  def initialize
  end

  def run
    ::Process.daemon(true, true)
    File.open("/lockfile", "w") {|f|
      if locked = f.flock(File::LOCK_EX|File::LOCK_NB)
        f.puts ::Process.pid
        puts 'Start Daemon'
        sleep 5
      else
        puts 'Already running'
      end
    }
  end
end

locktest = Locktest.new
locktest.run
