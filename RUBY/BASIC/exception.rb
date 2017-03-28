class MyError < StandardError; end
class MyError2 < StandardError; end

begin
  puts "hello"
  raise MyError2
rescue MyError
  puts "exception handled" # 実行される
end
