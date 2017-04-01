require 'eventmachine'

EM.run do
  p = EM::PeriodicTimer.new(2) do
    puts 'Tick...'
  end

  EM::Timer.new(5) do
    puts 'BOOM'
    p.cancel # 
  end

  EM::Timer.new(10) do
    puts 'Tack...'
    EM.stop    
  end
end
