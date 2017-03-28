q = Queue.new

threads = Array.new
for num in 1..3 do
  threads << Thread.new do
    p 'Thread Start'
    while resource = q.pop
      puts 'pop wait'
      puts resource
    end
  end
end

(1..5).each do |num|
  p "push #{num}"
  q.push("Pop#{num}")
  sleep 2
end

th_timeout = 5
threads.each do |th|
  th.join(th_timeout)
end
