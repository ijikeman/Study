from pypdf import PdfReader
import os

class PdftoText:
    def __init__(self, path):
        # 配列を用意する
        self.text = []
        self.path = path

    def load_file(self):
        # pathにファイルが存在するか確認
        if not os.path.exists(self.path):
            raise FileNotFoundError(f"File not found: {self.path}")
        # PdfDocumentクラスのオブジェクトを作成し、PDFファイルをロードします
        self.reader = PdfReader(self.path)

        # number_of_pages = len(reader.pages)
    def convert(self):
        # loadメソッドを呼び出す
        self.load_file()
        page = self.reader.pages[15]
        text = page.extract_text()
        print(text)
        # # 0からlen(self.reader.pages）分のデータを読み込む
        # for i in range(len(self.reader.pages)):
        #     page = self.reader.pages[i]
        #     text = page.extract_text()
        #     # textを改行で区切ってtext配列についかしていく
        #     text = text.split('\n')
        #     self.text.extend(text)

            # 読み込んだページのテキストを出力
            # print(self.text)
        return self.text
