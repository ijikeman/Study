q = Queue.new

threads = Array.new
(1..3).each do |num|
  threads << Thread.start do
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
  sleep 1
end

thread_timeout = 5
threads.each do |th|
  th.join(limit_s)
end
