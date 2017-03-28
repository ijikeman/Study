class MyClass1

  abc = String.new

  def Test1
    abc = '1'
    puts abc
  end

  def Test2
    puts abc
  end
end

my = MyClass1.new
my.Test1
# my.abc
# my.Test2

class MyClass2
  def Test1
    @abc = '1'
    puts @abc
  end

  def Test2
    puts @abc
  end
end

my2 = MyClass2.new
# my2.abc
my2.Test1
my2.Test2

class MyClass3 < MyClass1
  def Test3
    puts abc
  end
end
my3 = MyClass3.new
my3.Test1
#my3.Test3

class MyClass4 < MyClass2
  def Test3
    puts @abc
  end
end
my4 = MyClass4.new
my4.Test1
my4.Test3
