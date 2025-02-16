import re

line = "売上高 8288 11219"

# 事前処理
# line = line.replace("\u3000", " ").strip()  # 全角スペースを半角に & trim

# # 正規表現でマッチング
# if re.match(r"売上高.*", line, re.DOTALL):
#     print("✅ マッチしました！")
# else:
#     print("❌ マッチしませんでした")

# if re.match(r"売上高.*", line, re.DOTALL):
# if re.search(r"売上高.*", line):
# pattern = re.escape("売上高") + ".*"
# if re.match(pattern, line):
#     print("✅ マッチしました！")
# else:
#     print("❌ マッチしませんでした")

# pattern = re.escape("売上高") + ".*"
# if re.match(pattern, line):
#     print("✅ マッチしました！")
# else:
#     print("❌ マッチしませんでした")


# 事前処理
line = line.replace("\u3000", " ").strip()  # 全角スペースを半角に & trim

# 正規表現でマッチング
if re.match(r"^売上高.*", line):
    print("✅ マッチしました！")
else:
    print("❌ マッチしませんでした")