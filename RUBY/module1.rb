module Module1
  class ModuleClass1
  def self.ClassMethod1
    p 'Class1'
  end

  def InsMethod1
    p 'Ins1'
  end
  end
end

class MyClass < Module1::ModuleClass1
end

my = MyClass.new
my.InsMethod1
MyClass.ClassMethod1
