class Locktest
  def initialize
  end

  def run
    File.open("/lockfile", "a") {|f|
      puts 'start lock already2'
      f.flock(File::LOCK_EX)
      puts 'get lock already2'
      sleep 5
      puts 'start fputs already2'
      f.puts "already2" 
   }
  end
end

locktest = Locktest.new
locktest.run
