class Hello
  def say(count)
    puts(([hello()] * count).join("*"))
  end

  def hello()
    "hello"
  end
end

class OnlyOneHello < Hello
  def say(count)
    super(1)
  end

  def hello()
    "only-once-hello"
  end
end


class DoubleHello < Hello
  def say(count)
    super(2)
  end

  def hello()
    "double-hello"
  end
end


[Hello, OnlyOneHello, DoubleHello].each do |e|
  e.new.say(5)
end
