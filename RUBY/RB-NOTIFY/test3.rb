require 'bundler'
Bundler.setup
require 'rb-inotify'
require 'ffi'

notifier = INotify::Notifier.new
notifier.watch("/tmp", :all_events) {|ev|
  # if ev.flags.include?(:open)
  # puts "#{ev.related}"
  # puts "#{ev.absolute_name}"
  puts "#{ev.flags}"
  # puts "#{ev.size}"
  # puts "#{ev.watcher}"
  # puts "#{ev.notifier}"
  # ev.notifier.stop
  # end
}
notifier.run
