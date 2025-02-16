from .TextReplacer import TextReplacer

class TextReplacers:
    def __init__(self):
        self.text_replacer = TextReplacer()
        self.old_chars = []
        self.new_chars = []

    def add(self, old_char, new_char):
        self.old_chars.append(old_char)
        self.new_chars.append(new_char)
        return self

    def replace(self, text):
        return self.text_replacer.replace_all(text, self.old_chars, self.new_chars)

    def replace_all(self, texts):
        return [self.replace(text) for text in texts]
