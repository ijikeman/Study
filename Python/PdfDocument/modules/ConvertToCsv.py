import json
import csv
import sys

class ConvertToCsv:
    def __init__(self, data):
        self.data = data
        print(self.data.keys())
    
    def to_csv(self):
        for key, values in self.data.items():
            rows = [row.split(',') for row in values[1:]]  # ヘッダー以外を分割
            fieldnames = ['項目', '金額1', '金額2']  # カラム名を設定
            writer = csv.writer(sys.stdout)
            writer.writerow([key])  # セクション名を出力
            writer.writerow(fieldnames)  # ヘッダーを出力
            writer.writerows(rows)  # データを出力
            writer.writerow([])  # 空行を追加
