class Locktest
  def initialize
  end

  def run
    File.open("/lockfile", "a") {|f|
      puts 'start lock already3'
      f.flock(File::LOCK_EX)
      puts 'get lock already3'
      puts 'start fputs already3'
      f.puts "already3" 
   }
  end
end

locktest = Locktest.new
locktest.run
