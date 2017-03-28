require './not'

nt = Not.new
nt.set_input(1)
puts "SET 1 = #{nt.get_input}"
nt.set_input(0)
puts "SET 0 = #{nt.get_input}"
nt = Not.new
puts "NOSET = #{nt.get_input}"

