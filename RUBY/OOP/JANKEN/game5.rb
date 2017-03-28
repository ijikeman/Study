# プレイヤー部分のみオブジェクト化
# Playerオブジェクトは自分の手と勝ち数を管理する
# プレイヤーはinputメソッドで自分の手を決める事ができる
# 属性を追加しコンピュータの場合は自分の手を自動で決める
# 委譲を使いPlayerの属性はHumanPlayerとComputerPlayerの別クラスを定義
class Player
  attr_accessor :choise, :win, :name
  def initialize
    @choise = nil
    @win = 0
    @name = nil
  end

  def input
    puts('パーは0, チョキは1, グーは2を入力')
    @choise = gets().to_i
  end
end

class HumanPlayer
  attr_accessor :choise, :win, :name
  def initialize(player)
    @player = player
  end

  def name(name=nil)
    if !name.nil?
      @player.name = name # 親クラスの処理を実行
    end
    @player.name
  end

  def win
    @player.win
  end

  def choise
    @player.choise
  end

  def input
    @player.input
  end
end

class ComputerPlayer
  attr_accessor :choise, :win, :name
  def initialize(player)
    @player = player
  end

  def name
    @player.name = "コンピュータ" # @nameを上書き
    @player.name
  end

  def win
    @player.win
  end

  def choise
    @player.choise
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

  # プレイヤー2人のじゃんけんゲームをゲーム数分行う
  def self.game_start(player1, player2, games=3)
    while player1.win < games && player2.win < games
      puts 'FIGHT!!'
      case judge(player1.input,player2.input)
      when TRUE
        player1.win += 1
      when FALSE
        player2.win += 1
      end  
      puts "#{player1.name}[#{HANDS[player1.choise]}] vs #{player2.name}[#{HANDS[player2.choise]}]"
      puts "#{player1.name}(#{player1.win}勝) vs #{player2.name}(#{player2.win}勝)"
    end
  end

  # 勝敗を行うクラスメソッド(内部呼び出しであるためprivate)
  private
  def self.judge(choise1, choise2)
    if WIN[[choise1, choise2]]
      TRUE
    elsif WIN[[choise2, choise1]]
      FALSE
    end
  end
end

TO_WIN = 3
you = HumanPlayer.new(Player.new)
comp = ComputerPlayer.new(Player.new)
you.name = '花子'

Janken.game_start(you, comp, TO_WIN)
if you.win >= TO_WIN
  puts 'YOU WIN!!'
else
  puts 'YOU LOSE!!'
end
