require 'test/gem'
Test::Gem.hello
client = Test::Gem::Client.new("01-2345-6789", 'Tokyo')
p client.name
p client.tel
p client.address
