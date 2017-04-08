require 'eventmachine'
require 'thread'

EM.run do
  EM::PeriodicTimer.new(1) do
    puts "Tick... #{Thread.current}"
  end

  EM.add_timer(10) do
    puts "Main #{Thread.current}"
    EM.stop
  end

  EM.defer do
    num = 0
    while num < 3 do
      puts "Tack... Defer #{Thread.current}"
      sleep 2 
      num = num + 1 
    end 
  end
end
