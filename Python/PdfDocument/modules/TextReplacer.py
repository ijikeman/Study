class TextReplacer:
    def __init__(self):
        pass

    def replace(self, text, old_char, new_char):
        return text.replace(old_char, new_char)

    def replace_all(self, text, old_chars, new_chars):
        for old_char, new_char in zip(old_chars, new_chars):
            text = text.replace(old_char, new_char)
        return text
