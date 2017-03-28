class Player
  attr_accessor :choise, :name, :point 
  def initialize(name=nil)
    @choise = nil
    @point = 0
    @name = name
  end

  def input
  end

  def point_up
    @point += 1
  end
end

class HumanPlayer < Player
  def input
    puts('パーは0, チョキは1, グーは2を入力')
    @choise = gets().to_i
  end
end

class Computer < Player
  def initialize
    super
    @name = 'Computer'
  end

  def input
    @choise = rand(3)
  end
end

class Janken
  DEFAULT_MAX_GAMES = 3
  PAPER = 0
  SCISORS = 1
  STONE = 2
  WIN = {
    [SCISORS, PAPER] => true,
    [STONE, SCISORS] => true,
    [PAPER, STONE] => true
  }
  HANDS = [
    "パー",
    "チョキ",
    "グー",
  ]

  def initialize(player, games=DEFAULT_MAX_GAMES)
    @player = player
    @computer = Computer.new
    @games = games
  end

  def start
    while @player.point < @games && @computer.point < @games
      puts 'FIGHT!!'
      @computer.input
      @player.input
      case judge(@player.choise, @computer.choise)
      when 'WIN'
        @player.point_up
      when 'LOSE'
        @computer.point_up
      end
      puts "#{@player.name}[#{HANDS[@player.choise]}] vs #{@computer.name}[#{HANDS[@computer.choise]}]"
      puts "#{@player.name}(#{@player.point}勝) vs #{@computer.name}(#{@computer.point}勝)"
    end
  end

  def victory(point)
    return TRUE if point >= @games
  end

  private
  # 勝敗を行うクラスメソッド(内部呼び出しであるためprivate)
  def judge(choise1, choise2)
    if WIN[[choise1, choise2]]
      'WIN'
    elsif WIN[[choise2, choise1]]
      'LOSE'
    else
      'DROW'
    end
  end
end

player = HumanPlayer.new('hanako')
janken = Janken.new(player)
janken.start
if janken.victory(player.point)
  puts 'YOU WIN'
else
  puts 'YOU LOSE'
end
