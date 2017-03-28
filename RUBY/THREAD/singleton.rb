require 'singleton'

# queue1 = Queue.new
class TestClass1
	include
  def initialize
    @params = 'abc'
  end

  def test(text)
    @params = text.to_s
  end

  def display
    puts @params
  end
end

t1 = TestClass1.new
t1.test('def')
t1.display

t2 = TestClass1.new
t2.display

p t1
p t2

# TEST Singleton
class TestClass2
  include Singleton
  def initialize
    @params = 'abc'
  end

  def test(text)
    @params = text.to_s
  end

  def display
    puts @params
  end
end

t3 = TestClass2.instance
t3.test('def')
t3.display

t4 = TestClass2.instance
t4.display

p t3
p t4
