require './hoikusyo'

minamioka = Hoikusho.new('minamioka', 30)
minamioka.teachers.push(Teacher.new('test1'), Teacher.new('test2'))
p minamioka.possible_students
minamioka.teachers.push(Teacher.new('test3'))
p minamioka.possible_students
