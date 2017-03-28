# begin
#   1/0
# rescue
#   puts 'STD_ERR'
# end
# puts 'ok'

# 1/0
# puts 'ok'

# begin
#   1 / 0
# rescue => e
#   p e.class
#   p e.message
#   p e.backtrace
# end

# begin
#   1 / 0
# rescue ZeroDivisionError
#   puts "対象の例外やー。"
# end

# def full_name(firstname, lastname)
#   puts firstname + lastname
# end
# begin
#   full_name("taro")
# rescue ZeroDivisionError
#   puts "対象の例外やー。"
# rescue ArgumentError => e
#   puts 'ArgErrはこっちやー'
#   puts e
# end

# main.rb
# raise ArgumentError, "ArgumentErrorだよー"

# #=> main.rb:1:in `<main>': ArgumentErrorだよー (ArgumentError)
# こんな感じで指定してあげると例外を自由自在に操れるー。
# ちなみにRunTimeErrorは

# 特定の例外クラスには該当しないエラーが起こったときに発生します。 また Kernel.#raise で例外クラスを指定しなかった場合も RuntimeError が発生します。
# とのこと。ここまできて思い出したけど、raiseはif文とつなげて、

# main.rb
# def kufuku_gauge(energy)
#    true if energy > 100
# end

# def eating_dinner
#   raise "既に満腹！" if kufuku_gauge(120)
#   puts "食事の時間だ！"
# end

# eating_dinner

# #=> main.rb:6:in `eating_dinner': 既に満腹！ (RuntimeError)
# #=> from main.rb:10:in `<main>'
# こんな感じでエラーメッセージを出してた。エラーを特定したい時に便利だ！
# この辺までで元記事の意味は理解できるようになったー

# class ClassTest
#   def test
#     begin
#       1/0
#     rescue StandardError => ex
#       puts "StandardError"
#       # raise
#     rescue ZeroDivisionError => e
#       puts 'ClassTest: ZeroDivisionError'
#       puts e
#     end
#     puts 'ClassTest: next'
#   end
# end

# c = ClassTest.new
# begin
#   c.test
# rescue => e
#   puts 'Main: '
#   p e
# end

# class ExceptionTest
#   def test
#     begin
#       # 0での除算でエラーを発生させる
#       1/0
#     rescue ZeroDivisionError => ex
#       puts "ZeroDivisionError2"
#     rescue StandardError => ex
#       puts "StandardError"
#       raise
#     ensure
#       puts "Ensure"
#     end
#   end
# end

# obj = ExceptionTest.new

# begin
#   obj.test
# rescue => ex
#   puts "Other"
#   puts "class: #{ex.class}"
# end

# class ExceptionTest
#   def test
#     begin
#       1/0
#     rescue => e
#       puts 'ExceptionTest'
#       puts e
#       raise
#     ensure
#       puts 'Ensure'
#     end
#   end
# end

# c = ExceptionTest.new
# begin
#   c.test
# rescue => ex
#   puts 'Main'
#   puts ex
# end

# begin
#   1/0
# rescue => e
  # p 'DEBUG MODE' if $DEBUG
# end
