require 'chef/application/solo'

class MyClass < Chef::Application::Solo
end

Chef::Config[:solo] = true
Chef::Config[:color] = true
Chef::Config[:json_attribs] = './user.json'
items = 'recipe[httpd],recipe[httpd::default]'
items = items.split(',')
run_lists = Array.new
items.compact.map{|item|
  run_lists.push(Chef::RunList::RunListItem.new(item))
}
my = MyClass.new
my.config[:override_runlist] =  run_lists
my.reconfigure
my.run_chef_client
