#OOPではなく手続き型プログラミングの場合

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

comp_win = 0
you_win = 0

while comp_win < 3 && you_win < 3
  puts('パーは0, チョキは1, グーは2を入力')
  choise = gets()
  player = choise.to_i
  comp = rand(3)
  puts("YOU: #{HANDS[player]}, COMP: #{HANDS[comp]}")
  if WIN[[player, comp]]
    you_win += 1
  elsif WIN[[comp, player]]
    comp_win += 1
  end
  puts ("#{you_win}勝#{comp_win}負")
end

if you_win >= 3
  puts("YOU WIN!!")
else
  puts("YOU LOSE!!")
end
