from spire.pdf import PdfDocument
from spire.pdf import PdfTextExtractOptions
from spire.pdf import PdfTextExtractor

import sys
# PdfDocumentクラスのオブジェクトを作成し、PDFファイルをロードします
pdf = PdfDocument()
pdf.LoadFromFile(sys.argv[1])

# テキストを保存するための文字列オブジェクトを作成します
extracted_text = ""

# PdfExtractorのオブジェクトを作成します
extract_options = PdfTextExtractOptions()
# シンプルな抽出方法を使用するように設定します
extract_options.IsSimpleExtraction = True

# ドキュメント内のページをループします
for i in range(pdf.Pages.Count):
    # ページを取得します
    page = pdf.Pages.get_Item(i)
    # ページをパラメータとして渡してPdfTextExtractorのオブジェクトを作成します
    text_extractor = PdfTextExtractor(page)
    # ページからテキストを抽出します
    text = text_extractor.ExtractText(extract_options)
    # 抽出されたテキストを文字列オブジェクトに追加します
    print(text)
    
    print("Page" + str(i))
