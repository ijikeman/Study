require 'thread'

m = Mutex.new

ts = []
3.times {|j|
  ts << Thread.start {
#    m.synchronize {
      5.times {|k|
        p "Thread No.#{j} count=#{k}"
        sleep rand * 0.1
      }
#    }
  }
}

ts.each {|t|
  t.join
}
