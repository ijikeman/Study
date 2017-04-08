require 'eventmachine'

EM.run do
  p = EM::PeriodicTimer.new(1) do
    puts 'Tick...'
  end

  EM::Timer.new(3) do
    puts 'BOOM'
  end

  EM::Timer.new(2) do
    puts 'Tack...'
  end
  EM::Timer.new(5) do
    puts 'BOOM2'
  end
  EM::Timer.new(10) do
    EM.stop
  end
end
