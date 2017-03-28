q = Queue.new

t1 = Thread.new do
  p 'Thread1 Start'
  while resource = q.pop
    puts 'pop wait'
    puts resource
  end
end

t2 = Thread.new do
  p 'Thread2 Start'
  (1..10).each do |num|
    p "push #{num}"
    q.push("Pop#{num}")
    sleep 2
  end
end

sleep 15
