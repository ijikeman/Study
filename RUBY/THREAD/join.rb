
class TestClass
  def initialize
    @str = String.new
    @q = Queue.new
  end

  def create_threads
    num = 0
    threads = []
    while 5 > num
      p num
      threads << Thread.new do
        if num % 2 == 0
          sleep 3 + num
        else
          sleep 1 + num
        end
        @q.push(num)
      end
      num = num + 1
    end

    num2 = 0
    threads.each do |th|
      th.join
      p "#{num2} done"
      num2 = num2 + 1
    end
  end
end

t = TestClass.new
t.create_threads
