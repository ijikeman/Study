require 'thread'

m = Mutex.new

ts = []

3.times {|j|
  ts << Thread.start {
    begin
      m.lock
      5.times {|k|
        p "Thread No.#{j} count=#{k}"
        sleep rand * 0.1
      }
    ensure
      m.unlock
    end
  }
}

ts.each {|t|
  t.join
}
