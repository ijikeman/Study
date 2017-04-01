module Notify
  private
  def execute
    run_workers

    notifier = INotify::Notifier.new
    notifier.watch("/tmp", :all_events) {|ev|
      if ev.flags.include?(:close_write)
        Queuing.q.push(ev.absolute_name)
      end
    }
    notifier.run
  end

  def run_workers
    threads = Array.new
    for num in 1..@options[:WORKERS] do
      Logging.logger.debug "Thread start No.#{num}"
      threads << Thread.new do
        while qe = @q.pop
          get_fstat(qe)
          copy_to_tmp(qe)
        end
      end
    end
  end
end
