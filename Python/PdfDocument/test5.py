import pdfplumber
import sys

# PDFファイルを開く
with pdfplumber.open(sys.argv[1]) as pdf:
    # PDFの各ページを処理
    for page in pdf.pages:
        # ページからテキストを抽出
        text = page.extract_text()
        print(text)
