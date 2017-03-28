class Hello
  def say(to)
    "#{to} Hello"
  end
end

class PoliteHello
  def initialize(hello)
    @hello = hello
  end

  def say(to)
    "Mr." + @hello.say(to)
  end
end

hello = PoliteHello.new(Hello.new)
puts hello.say("Tom")
