require 'chef/handler'
require 'chef/client'

class MyClass < Chef::Client
end

my = MyClass.new
p my.ohai
p my.events
my.run_started
