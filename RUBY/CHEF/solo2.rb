require 'chef/application/solo'

class MyClass < Chef::Application::Solo
end

Chef::Config[:solo] = true
Chef::Config[:json_attribs] = './user.json'
my = MyClass.new
my.config[:override_runlist] = ['recipe[httpd]','recipe[httpd::default]']
my.run_chef_client
