# プレイヤー部分のみオブジェクト化
# Playerオブジェクトは自分の手と勝ち数を管理する
# プレイヤーはinputメソッドで自分の手を決める事ができる
class Player
  # プレイヤーは自分の手と勝数を管理するクラス
  attr_accessor :choise, :win
  def initialize
    @choise = nil
    @win = 0
  end

  def input
    puts('パーは0, チョキは1, グーは2を入力')
    @choise = gets().to_i
  end
end

# 処理部分に関してはまだ手続き型のまま
PAPER = 0
SCISORS = 1
STONE = 2
TO_WIN = 3
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

you = Player.new
comp = Player.new

while you.win < 3 && comp.win < 3
  you.input
  comp.choise = rand(3)
  puts ("YOU vs COMP = #{HANDS[you.choise]} vs #{HANDS[comp.choise]}")
  if WIN[[you.choise, comp.choise]]
    you.win += 1
  elsif WIN[[comp.choise, you.choise]]
    comp.win += 1
  else
  end
  puts "#{you.win}勝#{comp.win}敗"
end

if you.win >= 3
  p "YOU WIN!!"
elsif comp.win >= 3
  p "YOU LOSE!!"
end
