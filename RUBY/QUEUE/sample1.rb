q = Queue.new

t0 = Thread.start {
  p 'Thread Start'
  loop do
    if q.empty? == true
      p 'Thread done'
      break
   end
    resource = q.pop
    puts "POP: #{resource}"
  end
}

p 'Sleep Start'
sleep 0.01
p 'Sleep End'
q.push('test1')
q.push('test2')

th_timeout = 5
t0.join(th_timeout)
