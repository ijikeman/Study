from pdfminer.high_level import extract_text
from pathlib import Path
import sys

# PDFファイルからテキストを抽出
source = Path(sys.argv[1])

text = extract_text(source)
print(text)