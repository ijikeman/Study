$:.unshift(File.dirname(File.expand_path(__FILE__)) + '/../lib/')
require 'utils'

begin
  test_daemon = TestDaemon.new
  test_daemon.run
rescue => e
  puts e if $DEBUG
  exit 1
end
