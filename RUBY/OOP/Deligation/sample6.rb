require 'forwardable'
class Player
  attr_accessor :point
  def initialize
    @point = 0
  end
end

class Human
  extend Forwardable

  def_delegators :player, :point=, :point
  attr_accessor :player
  def initialize(player)
    @player = player
  end
end

player = Player.new
player.point += 1
p player.point

human = Human.new(Player.new)
p human.point
human.point += 1
p human.point
