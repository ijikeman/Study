$:.unshift(File.dirname(File.expand_path(__FILE__)) + '/../lib/')
require 'utils'

cli = Ruby_Lsync::Cli.new
cli.run
# puts e if $DEBUG
# puts 'BIN'
# exit 1
