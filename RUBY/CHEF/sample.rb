require 'chef/version'

class MyClass < Chef
  def initialize
    puts
    puts 'Class New'
    p CHEF_ROOT
    p VERSION
  end
end

puts 'Direct Yobidashi'
p Chef::CHEF_ROOT
p Chef::VERSION

MyClass.new
