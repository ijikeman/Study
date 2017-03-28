require "parallel"
require 'openssl'
require "open-uri"

id = 0
count = 0


Parallel.each((1..600), in_threads: 30) {|i|
  body = open("https://zabbton2.sandbox.mngsvr.com/hello/", :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE).read }
