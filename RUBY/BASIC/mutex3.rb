require 'thread'

m = Mutex.new

ts = []
3.times {|j|
  ts << Thread.start {
    sleep rand * 0.1
    locked = false
    begin
      locked = m.try_lock
      raise "Can't get lock Thread No.#{j}" unless locked
      5.times {|k|
        p "Thread No.#{j} count=#{k}"
        sleep rand * 0.1
      }
    ensure
      m.unlock if locked
    end
  }
}

ts.each {|t|
  begin
    t.join
  rescue
    puts $!
  end
}
