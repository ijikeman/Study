# 渡された配列から決算短信で必要なデータのみ抽出する
import json
import os
import re

class ExtractText:
    def __init__(self, json_file, lines):
        # JSON ファイルを読み込む
        with open(json_file, 'r', encoding='utf-8') as f:
            self.mapping = json.load(f)

        self.lines = lines
        self.data = {}

    def process_lines(self):
        start_key = None
        # データ格納用配列
        temp_list = []

        # linesをiterationする
        for line in self.lines:
            # print(line)
            # line = line.strip()  # 前後の空白を削除

            formatted_line = re.sub(r'\s+', ',', line)  # スペースをカンマに変換

            # lineがkeyにマッチしている場合は`matched_keyに格納、そうでない場合はNoneになる
            # `^key` でマッチするキーを検索
            if start_key is None:
                matched_key = next((k for k in self.mapping if re.match(f"^{k}", line)), None)
                # マッチした場合終了キーを取得する
                if matched_key is not None:
                    # lineをスペースでパースして、最初の部分をstart_keyに格納
                    start_key = line.split()[0]
                    end_key = self.mapping[matched_key]
                    print("start_key=" + str(start_key))
                    print("end_key=" + str(end_key))

                    # もしlineがkeyとデータの正規表現パターンにマッチしていた場合のみデータ部へも格納
                    # if re.match(f"^{matched_key}", line):
                    temp_list.append(formatted_line)
            # start_keyがNoneでない場合はデータを格納
            else:
                temp_list.append(formatted_line)
                # `^end_key` で終了判定
                if re.match(f"^{end_key}.*", line):
                    print("end_match")
                    # 最後の要素を格納
                    self.data[start_key] = temp_list
                    # temp_listをクリアする
                    start_key = None
                    end_key = None
                    temp_list = []

    def get_data(self):
        return self.data
