# プレイヤー部分のみオブジェクト化
# Playerオブジェクトは自分の手と勝ち数を管理する
# プレイヤーはinputメソッドで自分の手を決める事ができる
# 属性を追加しコンピュータの場合は自分の手を自動で決める
# 委譲を使いPlayerの属性はHumanPlayerとComputerPlayerの別クラスを定義
require "forwardable"

class Player
  DEFAULT_MAX_POINT = 3
  attr_accessor :choise, :name, :point 
  def initialize
    @choise = nil
    @point = 0
    @name = nil
  end

  def input
    puts('パーは0, チョキは1, グーは2を入力')
    @choise = gets().to_i
  end
end

class HumanPlayer
  extend Forwardable
  attr_accessor :choise, :name, :point
  def_delegators :@player, :choise, :point, :name, :input, :name= ,:point= 
  def initialize
    @player = Player.new
  end
end

class ComputerPlayer
  extend Forwardable
  attr_accessor :choise, :point
  attr_reader :name
  def_delegators :@player, :choise, :point, :point= 
  def initialize
    @player = Player.new
  end

  def name
    @player.name = "コンピュータ" # @nameを上書き
    @player.name
  end

  def input
    @player.choise = rand(3).to_i
  end
end

# 新たにじゃんけんクラスを作成
class Janken
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

  def initialize(player1, player2, max_point)
    @player1 = player1
    @player2 = player2
    @max_point = max_point
  end

  # プレイヤー2人のじゃんけんゲームをゲーム数分行う
  def game_start
    while @player1.point < @max_point && @player2.point < @max_point
      puts 'FIGHT!!'
      @player1.input
      @player2.input
      case judge
      when 'WIN'
        @player1.point = point_up(@player1.point)
      when 'LOSE'
        @player2.point = point_up(@player2.point)
      end
      puts "#{@player1.name}[#{HANDS[@player1.choise]}] vs #{@player2.name}[#{HANDS[@player2.choise]}]"
      puts "#{@player1.name}(#{@player1.point}勝) vs #{@player2.name}(#{@player2.point}勝)"
    end
    return victory(@player1.point, @player2.point)
  end

  private
  # 勝敗を行うクラスメソッド(内部呼び出しであるためprivate)
  def judge
    if WIN[[@player1.choise, @player2.choise]]
      'WIN'
    elsif WIN[[@player2.choise, @player1.choise]]
      'LOSE'
    else
      'DROW'
    end
  end

  def point_up(point)
    return point + 1
  end

  def victory(player1, player2)
    if player1 >= @max_point
      return 'WIN'
    elsif player2 >= @max_point
      return 'LOSE'
    else
      return 'DROW'
    end
  end
end

TO_WIN = 3
you = HumanPlayer.new
comp = ComputerPlayer.new
you.name = '花子'
janken = Janken.new(you, comp, TO_WIN)
puts "YOU #{janken.game_start}!!"
