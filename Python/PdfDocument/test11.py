import re

pattern = re.compile(r'日本[\u4E00-\u9FFF]+')  # 「日本」に続く漢字

texts = ["日本語", "日本文化", "日本123", "日本の", "日本庭園", "日本"]

for text in texts:
    if pattern.fullmatch(text):  # 文字列全体がマッチするか確認
        print(f"'{text}' はマッチ")
    else:
        print(f"'{text}' はマッチしない")
