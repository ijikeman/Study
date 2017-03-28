require 'bundler'
Bundler.setup
require 'rb-inotify'
require 'ffi'

notifier = INotify::Notifier.new
notifier.watch("/tmp/foo.txt", :all_events) {|ev|
  puts "foo.txt was #{ev.flags}"
  notifier.stop
}
notifier.run
