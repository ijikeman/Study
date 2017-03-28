require './xor'

o = Xor.new
o.set_input(0, 0)
o.set_input(1, 0)
puts ("0 or 0 = #{o.get_input}")
o.set_input(0, 0)
o.set_input(1, 1)
puts ("0 or 1 = #{o.get_input}")
o.set_input(0, 1)
o.set_input(1, 0)
puts ("1 or 0 = #{o.get_input}")
o.set_input(0, 1)
o.set_input(1, 1)
puts ("1 or 1 = #{o.get_input}")
