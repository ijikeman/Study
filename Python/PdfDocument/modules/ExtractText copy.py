# 渡された配列から決算短信で必要なデータのみ抽出する

import json
import os
import re

import json
import re

class ExtractText:
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
            line = line.strip()  # 前後の空白を削除

            # `^key.*` でマッチするキーを検索
            matched_key = next((k for k in self.mapping if re.match(f"^{re.escape(k)}.*", line)), None)

            if matched_key:
                if key is not None:
                    self.data[key] = temp_list  # 直前のキーのデータを保存
                key = matched_key
                temp_list = []
                # キー検知時も、データに格納
                formatted_line = re.sub(r'\s+', ',', line)  # スペースをカンマに変換
                temp_list.append(formatted_line)
            elif key is not None:
                # スペースをカンマに変換
                formatted_line = re.sub(r'\s+', ',', line)
                temp_list.append(formatted_line)

                # `^key.*` で終了判定
                if re.match(f"^{re.escape(self.mapping[key])}.*", line):
                    self.data[key] = temp_list
                    key = None  # 終了
                
        if key is not None and temp_list:
            self.data[key] = temp_list  # 最後の要素を格納

    def get_data(self):
        return self.data
