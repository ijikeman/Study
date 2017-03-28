module Car
  NAME = {
    name: 'my_car',
    color: 'red',
    type: 'Mini'
  }
  def self.test
    name ||= NAME.dup
    p name
  end
end

Car.test
