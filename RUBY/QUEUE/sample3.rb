class TestClass1
  def initialize(max_threads_num)
    @queue = Queue.new
    @target_file_list = Array.new
    @max_threads_num = max_threads_num
  end

  def run
    threads = Array.new

    for num in 1..@max_threads_num do
      p num
      threads << Thread.new do
        while qe = @queue.pop
          puts "pop: #{qe}"
          copy_file(qe)
        end
        puts 'next pop'
      end
    end


    # threads << Thread.new do
      num = 0
      while num <= 5 do
        @queue.push({"filepath" => "/tmp/#{num}"})
        sleep 1
        num = num + 1
      end
    # end

    # ThreadsWait.all_waits(threads)
    th_num = 0
    threads.each do |th|
      th.join
      p "Join #{th_num}"
      th_num = th_num + 1
    end
  end

  private
  def copy_file(path)
    sleep 5
    puts "copy to #{path}"
  end

end

t1 = TestClass1.new(2)
t1.run
