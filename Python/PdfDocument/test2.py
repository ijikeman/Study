import json
import re

class A:
    def __init__(self, json_file, lines):
        # JSON ファイルを読み込む
        with open(json_file, 'r', encoding='utf-8') as f:
            self.mapping = json.load(f)

        self.lines = lines
        self.data = {}

    def process_lines(self):
        key = None
        temp_list = []
        
        for line in self.lines:
            if line in self.mapping:
                if key is not None:
                    self.data[key] = temp_list  # 直前のキーに格納
                key = line
                temp_list = []
            elif key is not None:
                # スペースをカンマに変換
                formatted_line = re.sub(r'\s+', ',', line)
                temp_list.append(formatted_line)
                if line == self.mapping[key]:  # 例えば B の場合 'B' に到達したら終了
                    self.data[key] = temp_list
                    key = None  # 終了
                
        if key is not None and temp_list:
            self.data[key] = temp_list  # 最後の要素を格納

    def get_data(self):
        return self.data


# # 実行例
json_file = "data.json"
lines = [
    "A",
    "hoge 1 -2",
    "moge 1",
    "B",
    "doge 3 -5",
    "C",
    "soge -5 10",
    "doge -10 -90",
    "zoge",
    "D",
    "yoge"
]

# クラスを使用
a_instance = A(json_file, lines)
a_instance.process_lines()
print(a_instance.get_data())
