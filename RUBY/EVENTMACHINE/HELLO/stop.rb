require 'eventmachine'

EM.run do
  EM.add_timer(5) do # = EM.Timer.new(5) do
    puts 'BOOM'
    if EM.reactor_running?
      EM.stop_event_loop # or EM.stop
    end
  end

  EM.add_periodic_timer(1) do # = EM::PeriodicTimer.new(1) do
    puts 'Tick...'
  end

  EM.add_periodic_timer(1) do
    puts 'Tack...'
  end
end


