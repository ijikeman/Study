
import sys
import pypdfium2 as pdfium

pdf = pdfium.PdfDocument(sys.argv[1])

for page in pdf:
    textpage = page.get_textpage()
    text = textpage.get_text_range()
    print(text)