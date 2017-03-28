class Hello
  def say(to)
    "#{to} Hello"
  end
end

class PoliteHello < Hello
  def say(to)
    "Mr.#{to} Hello"
  end
end

hello = PoliteHello.new
puts hello.say("Tom")
