class LineFilter:
    def __init__(self):
        """
        :param target_phrases: 削除対象の文字列（リスト）
        """
        self.target_phrases = []

    def add(self, target_phrase):
        self.target_phrases.extend(target_phrase)

    # 渡されたlinesのうちtarget_phrasesの配列の文字列が含まれている場合は省く。
    # target_phraseは正規表現で記載が可能
    def filter(self, lines):
        filtered_lines = []
        for line in lines:
            # 空行を削除対象にして
            if line == "":
                continue
            # import re
            # for target_phrase in self.target_phrases:
            # # reを使って正規表現でマッチング
                # if re.match(f"^{target_phrase}.*", line):
                    # break
            # filtered_lines.append(line)
            # if not any(target_phrase in line for target_phrase in self.target_phrases):
            #     filtered_lines.append(line)
            # else:
            #     print(line)
        return filtered_lines
