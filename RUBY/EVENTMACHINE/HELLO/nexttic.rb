require 'eventmachine'

EM.run do
  EM::PeriodicTimer.new(1) do
    puts 'Hi'
  end

  EM::Timer.new(5) do
    EM.next_tick do
      EM.stop
    end
  end
end
