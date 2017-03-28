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

  # 追加処理
  def french_message
    p "Melce"
  end

  # 元のクラスから処理を書き換え
  def japanese_message
    p "今日は"
  end

  # 未定義メソッドをmethod_missingをオーバーライドしsendを使って呼び出す
  # 実行速度が遅くなってしまう & コードがわかりにくくなってしまう
  def method_missing(name, *args)
    @echo.send name, *args if name == :english_message
  end
end

f = PlusFrenchEcho.new(Echo.new)
f.english_message
f.japanese_message
f.suwahiri_message # 委譲なので新しいクラスで委譲していない場合は呼べないがmethod_missingにもならない
f.french_message
