#委譲はスコープを限定できるので親クラスの変更の影響を最小限に留めることができる
class Echo
  def english_message
    p "Hello"
  end

  def japanese_message
    p "こんにちは"
  end

  def suwahiri_message
    p "Jumbo"
  end
end

class PlusFrenchEcho
  def initialize(echo)
    @echo = echo
  end

  # 元のクラスをそのまま委譲するのに再定義
  def english_message
    @echo.english_message
  end

  # 追加処理
  def french_message
    p "Melce"
  end

  # 元のクラスから処理を書き換え
  def japanese_message
    p "今日は"
  end
end

f = PlusFrenchEcho.new(Echo.new)
f.english_message
f.japanese_message
# f.suwahiri_message # 委譲なので新しいクラスで委譲していない場合は呼べない
f.french_message
