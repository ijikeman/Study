class Player
  attr_accessor :point
  def initialize
    @point = 0
  end
end

class Human
  attr_accessor :point, :player
  def initialize(player)
    @player = player
  end

  def player
    @player
  end

  def point
    @player.point
  end

  def point=(value)
    @player.point = value
  end
end

player = Player.new
player.point += 1
p player.point

human = Human.new(Player.new)
p human.point
human.point += 1
p human.point
human.point += 1
p human.point
