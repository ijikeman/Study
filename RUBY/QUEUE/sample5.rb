locks = Queue.new
2.times { locks.push :lock }

q = Queue.new

Array.new(3) do
  Thread.new do
    lock = locks.pop
    p 'Thread Start'
    while resource = q.pop
      puts 'pop wait'
      puts resource
    end
    locks.push lock
  end
end.each(&:join)

for num in 1..5 do
  p "push #{num}"
  q.push("Pop#{num}")
  sleep 2
end
