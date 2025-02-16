# from spire.pdf import pdfdocument
from spire.pdf import PdfDocument
from spire.pdf import PdfTextExtractOptions
from spire.pdf import PdfTextExtractor

import os
import re

class ConvertPdftoText:
    def __init__(self, path):
        self.path = path
        self.pdf = PdfDocument()
        # 配列を用意する
        self.text = []

        # PdfExtractorのオブジェクトを作成します
        self.extract_options = PdfTextExtractOptions()
        # ページ番号を追加しない
        # self.extract_options.AddPageNumber = False
        # シンプルな抽出方法を使用するように設定します
        self.extract_options.IsSimpleExtraction = True

    def load_file(self):
        # pathにファイルが存在するか確認
        if not os.path.exists(self.path):
            raise FileNotFoundError(f"File not found: {self.path}")
        # PdfDocumentクラスのオブジェクトを作成し、PDFファイルをロードします
        self.pdf.LoadFromFile(self.path)

    def convert(self):
        # loadメソッドを呼び出す
        self.load_file()
        # テキストを保存するための文字列オブジェクトを作成します
        extracted_text = ""

        # ドキュメント内のページをループします
        for i in range(self.pdf.Pages.Count):
            # print(self.pdf.Pages.Count)
            # ページを取得します
            page = self.pdf.Pages.get_Item(i)

            # ページをパラメータとして渡してPdfTextExtractorのオブジェクトを作成します
            text_extractor = PdfTextExtractor(page)

            # ページからテキストを抽出します
            text = text_extractor.ExtractText(self.extract_options)
            print(text)
            # textを1行ずつに区切る
            text = text.split('\n')
            # textを1行ずつ処理する
            for line in text:
                # print(line) # debug
                self.text.append(line.strip())
        return self.text