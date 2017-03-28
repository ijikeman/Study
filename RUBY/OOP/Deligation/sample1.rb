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


class PlusFrenchEcho < Echo
  # 元のクラスに処理を追加
  def french_message
    p "Melce"
  end

  # 元のクラスをオーバーライド
  def japanese_message
    p "今日は"
  end
end

f = PlusFrenchEcho.new
f.english_message
f.japanese_message
f.suwahiri_message # 継承しているので親クラスのメソッドを呼べる
f.french_message
