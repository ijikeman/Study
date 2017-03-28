require './teacher'
require './student'
require './klass'

class Hoikusho
  TEACHERS_BY_STUDENTS = 3
  attr_reader :max_students, :klasses
  attr_accessor :teachers, :students
  def initialize(name, m2)
    @name = name
    @m2 = m2
    @max_students
    @klasses = []
    decide_max_students
    make_klass
    @teachers = []
    @students = []
    @possible_students
  end

  def possible_students
    @possible_students = @teachers.count * TEACHERS_BY_STUDENTS
  end

  private
  def decide_max_students
    @max_students = @m2 / 3
  end

  def make_klass
    if @m2 >= 50
      [0,1,2,3,4,5,6].each do |age|
        @klasses << Klass.new(age)
      end
    else 
      [0,1,2].each do |age|
        @klasses << Klass.new(age)
      end
    end
  end
end
