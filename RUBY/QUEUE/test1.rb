th = Thread.new do
  loop do
    p 'Hello'
    sleep 1
  end
end

sleep 10
Thread.kill(th)

