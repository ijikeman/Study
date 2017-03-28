require "faraday"

600.times do |i|
  # 証明書無効化
  client = Faraday.new(:url => "https://zabbton2.sandbox.mngsvr.com")
  client.ssl[:verify] = false
  res = client.get "/hello"
end

